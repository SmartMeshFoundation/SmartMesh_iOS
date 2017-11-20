//
//  FFXMPPManager.m
//  SmartMesh
//
//  Created by Rain on 17/11/20.
//  Copyright © 2017年 SmartMesh Foundation All rights reserved.
//

#import "FFXMPPManager.h"

@interface FFXMPPManager ()

@property (nonatomic, strong) XMPPStream *stream;
@property (nonatomic, strong) FFXMPPReconnect *reconnect;
@property (nonatomic, strong) FFUser *user;
@property (nonatomic, strong) NSMutableDictionary * sendingMessage;
@property (nonatomic, strong) NSMutableDictionary * callbackingMessage;

@end

@implementation FFXMPPManager

#pragma mark - 单例对象
static FFXMPPManager *_instance;

+ (instancetype)sharedManager {
    return [[self alloc] init];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone {
    return _instance;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return _instance;
}

-(void) dealloc {
    [self unobserveAllNotifications];
}

- (instancetype)init {
    if (self = [super init]) {
        self.sendingMessage = [NSMutableDictionary dictionary];
        self.callbackingMessage = [NSMutableDictionary dictionary];
        [self observeNotification:kReachabilityChangedNotification];
    }
    return self;
}

- (void)handleNotification:(NSNotification *)notification {
    if ([notification is:kReachabilityChangedNotification]) {
        if ([(Reachability *)notification.object currentReachabilityStatus] == NotReachable) {
            [self.stream sendElement:[XMPPPresence presenceWithType:@"unavailable"]];
            [_stream disconnect];
        }
    }
}

- (XMPPStream *)stream {
    if (!_stream) {
        _stream = [[XMPPStream alloc] init];
        [_stream setHostName:NEXT_APP_CHAT_SERVER];
        [_stream setHostPort:6222];
        [_stream addDelegate:self delegateQueue:dispatch_get_main_queue()];
        DDYInfoLog(@"初始化stream");
    }
    return _stream;
}

#pragma mark XMPP连接与状态
- (BOOL)connectWithUser:(FFUser *)user {
    if (self.stream.isConnected || self.stream.isConnecting) { return YES; }
    if ([NSString ddy_blankString:user.localID] || [NSString ddy_blankString:user.token]) { return NO; }
    
    self.user = user;
    
    [self.stream setMyJID:[XMPPJID jidWithString:JID_String(user.localID)]];
    
    if (![self.stream connectWithTimeout:XMPPStreamTimeoutNone error:nil]) { return NO; }
    if (self.reconnect) { [self.reconnect cancelAllTimers]; }
    
    self.reconnect = [[FFXMPPReconnect alloc] initWithXmppStream:self.stream];
    
    __weak __typeof__(self) weakSelf = self;
    self.reconnect.beginConnect = ^(XMPPStream *stream) {
        if (!weakSelf.stream.isConnected && !weakSelf.stream.isConnecting) {
            [weakSelf.stream disconnect];
            weakSelf.stream = nil;
            [weakSelf connectWithUser:weakSelf.user];
        }
    };
    return YES;
}

- (void)disconnect {
    [self.stream sendElement:[XMPPPresence presenceWithType:@"unavailable"]];
    [self.stream disconnect];
    self.reconnect = nil;
}

- (void)teardownStream {
    [self.stream removeDelegate:self];
    [self.stream disconnect];
    self.stream = nil;
}

#pragma mark 进入ereryone
- (void)enterEveryoneChatWithLastMsgTime:(NSInteger)msgTime {
    XMPPPresence* presence = [XMPPPresence presence];
    [presence addAttributeWithName:@"from" stringValue:[NSString stringWithFormat:@"%@@firefly.com/app_v2.1.2",self.user.localID]];
    [presence addAttributeWithName:@"to" stringValue:JID_EveryOne(self.user.localID)];
    [presence addAttributeWithName:@"id" stringValue:[XMPPStream generateUUID]];
    [presence addAttributeWithName:@"msgTime" integerValue:msgTime];
    [self.stream sendElement:presence];
    DDYInfoLog(@"send presence:\n%@\n%@\n%@\n",[presence attributeForName:@"from"],[presence attributeForName:@"to"],[presence attributeForName:@"id"]);
}

#pragma mark 退出everyone
- (void)exitEveryoneChat {
    XMPPPresence* presence = [XMPPPresence presence];
    [presence addAttributeWithName:@"from" stringValue:[NSString stringWithFormat:@"%@@firefly.com/app_v2.1.2",self.user.localID]];
    [presence addAttributeWithName:@"to" stringValue:JID_EveryOne(self.user.localID)];
    [presence addAttributeWithName:@"id" stringValue:[XMPPStream generateUUID]];
    [presence addAttributeWithName:@"type" stringValue:@"unavailable"];
    [self.stream sendElement:presence];
}

- (void)sendMessage:(FFMessage *)message {
    
    NSMutableDictionary *rawData = message.netDict;
    
    XMPPMessage *xmppMessage = nil;
    if (message.chatType == FFChatTypeSingle) {
        xmppMessage = [XMPPMessage messageWithType:@"chat" to:[XMPPJID jidWithString:JID_String(message.remoteID)]];
        [xmppMessage addAttributeWithName:@"msgtype" stringValue:@"normalchat"];
    } else if (message.chatType == FFChatTypeGroup) {
        xmppMessage = [XMPPMessage messageWithType:@"chat" to:[XMPPJID jidWithString:JID_Group(message.remoteID)]];
        [xmppMessage addAttributeWithName:@"msgtype" stringValue:@"groupchat"];
    } else if (message.chatType == FFChatTypeEveryOne) {
        xmppMessage = [XMPPMessage messageWithType:@"chat" to:[XMPPJID jidWithString:JID_EveryOne(message.uidFrom)]];
        [xmppMessage addAttributeWithName:@"type" stringValue:@"groupchat"];
    }
    
    [xmppMessage addAttributeWithName:@"from" stringValue:JID_String(self.user.localID)];
    [xmppMessage addAttributeWithName:@"id" stringValue:message.messageID];
    [xmppMessage addChild:[DDXMLNode elementWithName:@"body" stringValue:[NSString ddy_ToJsonStr:rawData]]];
    [self.stream sendElementLookAfterNetwork:xmppMessage];
    self.sendingMessage[message.messageID] = message;
}

#pragma mark 发送回执
- (void)sendReceiveCallBack:(FFMessage *)message msgID:(NSString *)msgID {
    DDYInfoLog(@"发送回执msgID:%@\nremoteID:%@",msgID,message.uidFrom);
    XMPPMessage *xmppMessage = nil;
    if (message.chatType == FFChatTypeSingle) {
        xmppMessage = [XMPPMessage messageWithType:@"chat" to:[XMPPJID jidWithString:JID_String(message.remoteID)]];
    } else if (message.chatType == FFChatTypeGroup) {
        xmppMessage = [XMPPMessage messageWithType:@"chat" to:[XMPPJID jidWithString:JID_Group(message.remoteID)]];
    } else if (message.chatType == FFChatTypeEveryOne) {
        xmppMessage = [XMPPMessage messageWithType:@"chat" to:[XMPPJID jidWithString:JID_EveryOne(message.remoteID)]];
    } else if (message.chatType == FFChatTypeSystem) {
        xmppMessage = [XMPPMessage messageWithType:@"chat" to:[XMPPJID jidWithString:JID_String(message.uidFrom)]];
    }
    
    [xmppMessage addAttributeWithName:@"from"    stringValue:JID_String(self.user.localID)];
    [xmppMessage addAttributeWithName:@"id"      stringValue:msgID];
    [xmppMessage addAttributeWithName:@"msgtype" stringValue:@"msgStatus"];
    
    NSMutableDictionary *body = [NSMutableDictionary dictionary];
    body[@"state"] = @"received";
    [xmppMessage addChild:[DDXMLNode elementWithName:@"body" stringValue:[NSString ddy_ToJsonStr:body]]];
    [self.stream sendElementLookAfterNetwork:xmppMessage];
    self.callbackingMessage[message.messageID] = message;
}

- (void) sendUnknowReciveCallBack:(XMPPMessage *)message messageid:(NSString *)messageid
{
    NSString * jid = [[message attributeForName:@"from"] stringValue];
    XMPPMessage * xmppMessage = [XMPPMessage messageWithType:@"chat" to:[XMPPJID jidWithString:jid]];
    [xmppMessage addAttributeWithName:@"id" stringValue:messageid];
    [xmppMessage addAttributeWithName:@"msgtype" stringValue:@"msgStatus"];
    NSMutableDictionary * body = [NSMutableDictionary dictionary];
    [body setObject:@"received" forKey:@"state"];
    [xmppMessage addChild:[DDXMLNode elementWithName:@"body" stringValue:[NSString ddy_ToJsonStr:body]]];
    [self.stream sendElementLookAfterNetwork:xmppMessage];
}

- (void)sendUnknowReceiveCallBack:(XMPPMessage *)xmppMessage messageID:(NSString *)messageID  {
    XMPPMessage *message = [XMPPMessage messageWithType:@"chat" to:[XMPPJID jidWithString:[[xmppMessage attributeForName:@"from"] stringValue]]];
    [message addAttributeWithName:@"id" stringValue:messageID];
    
    NSMutableDictionary *body = [NSMutableDictionary dictionary];
    body[@"state"] = @"received";
    [xmppMessage addChild:[DDXMLNode elementWithName:@"body" stringValue:[NSString ddy_ToJsonStr:body]]];
    [self.stream sendElementLookAfterNetwork:xmppMessage];
}

#pragma mark - XMPPStream Delegeta
- (void)xmppStream:(XMPPStream *)sender socketDidConnect:(GCDAsyncSocket *)socket { }
- (void)xmppStream:(XMPPStream *)sender willSecureWithSettings:(NSMutableDictionary *)settings { }
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error { DDYInfoLog(@"密码验证失败");}
- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq { return NO; }
- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence {
    DDYInfoLog(@"receive presence:\n%@\n%@\n%@",[presence attributeForName:@"from"],[presence attributeForName:@"to"],[presence attributeForName:@"id"]);
}
- (void)xmppStream:(XMPPStream *)sender didReceiveError:(id)error { }
- (void)xmppStreamDidSecure:(XMPPStream *)sender { }
- (void)xmppStreamDidConnect:(XMPPStream *)sender {
    NSError * error = nil;
    if (![_stream authenticateWithPassword:self.user.token error:&error]) { DDYInfoLog(@"XMPP error authenticating: %@", error);}
    else { DDYInfoLog(@"XMPP success authenticating"); }
}

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender { DDYInfoLog(@"xmppStreamDidAuthenticate");
    [self.stream sendElement:[XMPPPresence presence]];
}

- (void)xmppStream:(XMPPStream *)sender didSendMessage:(XMPPMessage *)message {
    DDYInfoLog(@"XMPP发送成功：\n%@\n%@\n%@",[message attributeForName:@"to"],[message attributeForName:@"msgtype"],[message elementForName:@"body"]);
    NSString *messageID = [[message attributeForName:@"id"] stringValue];
    // 回执成功才算接收成功
    id callBack = self.callbackingMessage[messageID];
    if (callBack) {
        DDYInfoLog(@"XMPP 发送其他消息成功");
    } else {
        DDYInfoLog(@"XMPP 发送消息%@成功",messageID);
        FFMessage *messageData = self.sendingMessage[messageID];
        if (messageData) {
            messageData.messageSendState = FFMessageSendStateSuccess;
            [self.sendingMessage removeObjectForKey:messageID];
        }
    }
}

- (void)xmppStream:(XMPPStream *)sender didFailToSendMessage:(XMPPMessage *)message error:(NSError *)error {
    DDYInfoLog(@"XMPP send message error %@ \nerror:%@ ",message, error);
    NSString *messageID = [[message attributeForName:@"id"] stringValue];
    // 回执
    FFMessage *callbackingMessage = self.callbackingMessage[messageID];
    if (callbackingMessage) {
        [self.callbackingMessage removeObjectForKey:messageID];
        return;
    }
    // 发送
    FFMessage *messageData = self.sendingMessage[messageID];
    if (messageData) {
        messageData.messageSendState = FFMessageSendStateFailure;
        [self.sendingMessage removeObjectForKey:messageID];
    }
}

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message {
    if (message) {
        [FFMessage handleXMPPMessage:message];
    }
}

- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error { DDYInfoLog(@"xmppStreamDidDisconnect");
    if (!sender.isConnected && !sender.isConnecting) { DDYInfoLog(@"XMPP unable connect to server.error : %@",error);
        if (self.reconnect) {
            [self.reconnect streamDisconnect];
        }
    }
}

@end
