//
//  FFWCManager.m
//  FireFly
//
//  Created by Admin on 2018/3/30.
//  Copyright © 2018年 NAT. All rights reserved.
//

#import "FFWCManager.h"

#import "Server.h"

#import "Connection.h"

#import "ServerBrowser.h"

@interface FFWCManager()<ServerDelegate,ConnectionDelegate,ServerBrowserDelegate>

@property(nonatomic,strong)ServerBrowser *serverBrowser;
@property(nonatomic,strong)Server *server;
@property(nonatomic,strong)NSMutableSet *clients;

@property (nonatomic, copy) void(^getOnlineUserBlock)(FFUser *onlineUser);

@end

@implementation FFWCManager

static FFWCManager *_instance;

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

-(instancetype)init{
    if (self=[super init]) {
        [self.server start];
        [self.serverBrowser start];
    }
    return self;
}

#pragma mark - Getter and Setter
-(ServerBrowser *)serverBrowser{
    if (_serverBrowser==nil) {
        _serverBrowser=[[ServerBrowser alloc] init];
        _serverBrowser.delegate = self;
    }
    return _serverBrowser;
}

-(Server*)server{
    if (_server==nil) {
        _server=[[Server alloc] init];
        _server.delegate=self;
    }
    return _server;
}

-(NSMutableSet *)clients{
    if (_clients==nil) {
        _clients=[[NSMutableSet alloc] init];
    }
    return _clients;
}

-(void)setGetOnlineUsersArrayBlock:(void (^)(NSArray *))getOnlineUsersArrayBlock{
//    _getOnlineUsersArrayBlock=getOnlineUsersArrayBlock;
    [self sendGetInfoToAll];
}

#pragma mark - Events

-(void)getOnlineUserWithLocalID:(NSString *)localID getOnlineUserBlock:(void (^)(FFUser *))getOnlineUserBlock{
    _getOnlineUserBlock=getOnlineUserBlock;
    [self sendGetInfoToUser:localID];
}

-(BOOL)sendGetInfoToAll{
    return YES;
}

-(BOOL)sendGetInfoToUser:(NSString *)localID{
    return YES;
}

-(BOOL)sendMessageToAll:(NSString *)message{
    return YES;
}

-(BOOL)sendMessageToUser:(NSString *)localID message:(NSString *)message{
    return YES;
}

#pragma mark - ServerDelegate
- (void) serverFailed:(Server*)server reason:(NSString*)reason{
    [self.server stop];
    [self.clients removeAllObjects];
}

- (void) handleNewConnection:(Connection*)connection{
    connection.delegate = self;
    for (Connection *client in self.clients) {
        if (![client.host isEqualToString:connection.host]||client.port!=connection.port) {
            [self.clients addObject:connection];
        }
    }
}

#pragma mark - ConnectionDelegate
- (void) connectionAttemptFailed:(Connection*)connection{
    
}

- (void) connectionTerminated:(Connection*)connection{
    [self.clients removeObject:connection];
}

- (void) receivedNetworkPacket:(NSDictionary*)message viaConnection:(Connection*)connection{

    DDYInfoLog(@"收到无网消息\n%@", message);
    FFMessage *msg  = [[FFMessage alloc] init];
    switch ([message[@"chatType"] integerValue]) {
        case 1:
            msg.chatType=FFChatTypeSingle;
            break;
        case 2:
            msg.chatType=FFChatTypeWifiEveryOne;
            break;

        default:
            break;
    }

    msg.uidFrom     = message[@"mid"];
    msg.nickName    = message[@"from"];
    msg.messageID   = message[@"messageID"];
    msg.content     = message[@"data"];
//    msg.   = dict[@"userImage"];
//    msg.isFromNoNet = @"1";
//    if (msg.chatType == FFChatTypeSingle) {
//        msg.remoteID = peerID.displayName;
//        msg.groupName = user.remarkName;
//        if (!msg.textContent) {
//            msg.textContent = dict[@"textContent"];
//        }
//
//        // 判断是否需要 `上传无网好友`
//        if ([dict[@"messageRealType"] integerValue] == FFMessageTypeFriendAccept) {
//
//            FFUser *user = [[FFUser alloc] init];
//            user.nickName = msg.nickName;
//            user.localID = msg.uidFrom;
//            user.userImage = msg.userImage;
//            user.netSource = @"noNet";
//            [self saveNoNetUser:user];
//
//            [self secretAddFriend:msg];
//
//        }
//
//    } else if (msg.chatType == FFChatTypeEveryOne) {
//        msg.remoteID = dict[@"remoteID"];
//        msg.groupName =  dict[@"groupName"];
//    } else if (msg.chatType == FFChatTypeSystem) {
//        if ([dict[@"messageType"] integerValue] == FFMessageTypeFriendRequest) {
//            msg.messageType = FFMessageTypeFriendRequest;
//            msg.remoteID = dict[@"remoteID"];
//            msg.groupName = DDYLocalStr(@"MessageFriendNotification");
//            msg.textContent = @"";
//            msg.messageID   = dict[@"messageID"];
//            DDYInfoLog(@"hhhhhhh:%@",dict[@"messageID"]);
//        } else if ([dict[@"messageType"] integerValue] == FFMessageTypeFriendAccept) {
//            FFUser *user = [[FFUser alloc] init];
//            user.nickName = msg.nickName;
//            user.localID = msg.uidFrom;
//            user.userImage = msg.userImage;
//            user.netSource = @"noNet";
//            [self saveNoNetUser:user];
//            return;
//        }
//    }
    
    if (msg.timeStamp/10000000000000) {
        DDYInfoLog(@"无网接收的消息时间戳有错误：%ld为十三位",(long)msg.timeStamp);
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self postNotification:FFNewMessageNotification withObject:msg];
    });
}

#pragma mark - ServerBrowserDelegate
- (void)updateServerList{

}

@end
