//
//  FFMessage.m
//  FireFly
//
//  Created by Rain on 17/11/29.
//  Copyright © 2017年 SmartMesh Foundation. All rights reserved.
//

#import "FFMessage.h"

@implementation FFMessage

@synthesize content = _content;
@synthesize netDict = _netDict;

- (NSString *)content {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"messageType"] = DDYStrFormat(@"%d",(int)_messageType);
    
    if (_chatType == FFChatTypeSystem) {
        dict[@"textContent"] = _textContent;
    }
    else
    {
        if (_messageType == FFMessageTypeText) {
            dict[@"textContent"] = _textContent;
        } else if (_messageType == FFMessageTypeImg) {
            dict[@"imgBase64Data"] = _imgBase64Data;
            if(_fileURL) dict[@"fileURL"] = _fileURL;
        } else if (_messageType == FFMessageTypeVoice) {
            dict[@"voiceDuration"] = _voiceDuration;
            if(_fileURL) dict[@"fileURL"] = _fileURL;
        } else if (_messageType == FFMessageTypeCard) {
            dict[@"name"] = self.cardName;
            dict[@"image"] = self.cardImage;
            dict[@"id"] = self.cardID;
            dict[@"sign"] = self.cardSign;
        } else if (_messageType == FFMessageTypeSystemTime) {
            dict[@"textContent"] = _textContent;
        }
    }
    return [NSString ddy_ToJsonStr:dict];
}

- (void)setContent:(NSString *)content {
    _content = content;
    
    NSDictionary *dict = [NSString ddy_JsonStrToDict:content];
    
    _messageType = (FFMessageType)([dict[@"messageType"] intValue]);
    
    if (_messageType == FFMessageTypeText) {
        _textContent = dict[@"textContent"];
    } else if (_messageType == FFMessageTypeImg) {
        
        _imgBase64Data = dict[@"imgBase64Data"];
        if (dict[@"fileURL"]) _fileURL = dict[@"fileURL"];
    } else if (_messageType == FFMessageTypeVoice) {
        _voiceDuration = dict[@"voiceDuration"];
        if (dict[@"fileURL"]) _fileURL = dict[@"fileURL"];
    } else if (_messageType == FFMessageTypeCard) {
        self.cardName = dict[@"name"];
        self.cardImage = dict[@"image"];
        self.cardID = dict[@"id"];
        self.cardSign = dict[@"sign"];
    } else if (_messageType == FFMessageTypeSystemTime) {
        _textContent = dict[@"textContent"];
    }
}

- (NSString *)showText {
    if (self.chatType == FFChatTypeSystem) {
        _showText = _textContent;
    } else {
        if (_messageType == FFMessageTypeText) {
            _showText = _textContent;
        } else if (_messageType == FFMessageTypeImg) {
            _showText = @"[图片]";
        } else if (_messageType == FFMessageTypeVoice) {
            _showText = @"[语音]";
        } else if (_messageType == FFMessageTypeCard) {
            _showText = @"[名片]";
        }
    }
    return _showText;
}

- (NSMutableDictionary *)netDict  {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    dict[@"userid"] = self.uidFrom;
    dict[@"username"] = self.nickName;
    dict[@"userimage"] = self.userImage;
    dict[@"mask"] = self.mask;
    dict[@"usergender"] = self.gender;
    dict[@"msgsource"] = @"SmartMesh";
    
    if (_chatType == FFChatTypeGroup) {
        dict[@"groupid"] = self.remoteID;
        dict[@"groupname"] = self.groupName;
    }
    
    if (_messageType == FFMessageTypeText) {
        dict[@"type"] = @"0";
        dict[@"content"] = self.textContent;
    } else if (_messageType == FFMessageTypeImg) {
        dict[@"type"] = @"1";
        dict[@"cover"] = self.imgBase64Data;
        dict[@"content"] = self.fileURL;
    } else if (_messageType == FFMessageTypeVoice) {
        dict[@"type"] = @"2";
        dict[@"second"] = self.voiceDuration;
        dict[@"content"] = self.fileURL;
    } else if (_messageType == FFMessageTypeCard) {
        dict[@"type"] = @"6";
        dict[@"name"] = self.cardName;
        dict[@"image"] = self.cardImage;
        dict[@"id"] = self.cardID;
        dict[@"sign"] = self.cardSign;
    }
    return dict;
}

+ (void)msgDict:(NSDictionary *)dict type:(NSString *)type msgID:(NSString *)msgID msgTime:(NSString *)msgTime others:(NSDictionary *)others
{
    NSString *nowTime = DDYStrFormat(@"%.0lf",[[NSDate date] timeIntervalSince1970]);
    FFMessage *msg = [[FFMessage alloc] init];
    msg.uidFrom = dict[@"userid"];
    msg.nickName = dict[@"username"];
    msg.userImage = dict[@"userimage"];
    
    msg.timeStamp = msgTime ? [(msgTime.length>10?[msgTime substringToIndex:10]:msgTime) integerValue] : [nowTime integerValue];
    msg.messageID = msgID;
    
    if ([dict[@"type"] integerValue] == 0) {            //文本
        msg.messageType = FFMessageTypeText;
        msg.textContent = dict[@"content"];
    } else if ([dict[@"type"] integerValue] == 1) {     //图片
        msg.messageType = FFMessageTypeImg;
        msg.imgBase64Data = dict[@"cover"];
        msg.fileURL = dict[@"content"];
    } else if ([dict[@"type"] integerValue] == 2) {     //语音
        msg.messageType = FFMessageTypeVoice;
        msg.fileURL = dict[@"content"];
        msg.voiceDuration = dict[@"second"];
    } else if ([dict[@"type"] integerValue] == 6) {     //名片
        msg.messageType = FFMessageTypeCard;
        msg.cardName = dict[@"name"];
        msg.cardImage = dict[@"image"];
        msg.cardID = dict[@"id"];
        msg.cardSign = dict[@"sign"];
    }
    
    if ([type isEqualToString:@"normalchat"]) {         // 单聊
        msg.remoteID = dict[@"userid"] ? dict[@"userid"] : others[@"userid"];
        msg.chatType = FFChatTypeSingle;
        msg.groupName = dict[@"username"] ? dict[@"username"] : others[@"username"];
        
        // 保存用户
        FFUser *user = [[FFUserDataBase sharedInstance] getUserWithLocalID:msg.uidFrom];
        if (user) {
            user.nickName = msg.nickName;
            user.userImage = msg.userImage;
        } else {
            user = [[FFUser alloc] init];
            user.localID = msg.uidFrom;
            user.nickName = msg.nickName;
            user.userImage = msg.userImage;
        }
        [[FFUserDataBase sharedInstance] saveUser:user];
    } else if ([type isEqualToString:@"groupchat"]) {   // 群组
        msg.remoteID = others[@"groupid"];
        msg.groupName = others[@"groupname"];
        msg.chatType = FFChatTypeGroup;
        
        // 保存群组
        FFGroupModel *group = [[FFUserDataBase sharedInstance] getGroupWithCid:msg.remoteID];
        if (group) {
            group.groupName = msg.groupName;
            for (NSDictionary *userDict in (NSArray *)others[@"groupmember"]) {
                FFUser *user = [[FFUser alloc] init];
                user.localID = userDict[@"uid"];
                user.userImage = userDict[@"image"] ;
                user.gender = userDict[@"gender"];
                for (FFUser *tmpUser in group.memberList) {
                    if ([user.localID isEqualToString:tmpUser.localID]) {
                        user.nickName = tmpUser.nickName;
                    }
                }
                [group.memberList addObject:user];
            }
        } else {
            group = [[FFGroupModel alloc] init];
            group.cid = msg.remoteID;
            group.groupName = msg.groupName;
            for (NSDictionary *userDict in (NSArray *)others[@"groupmember"]) {
                FFUser *user = [[FFUser alloc] init];
                user.localID = userDict[@"uid"];
                user.userImage = userDict[@"image"] ;
                user.gender = userDict[@"gender"];
                [group.memberList addObject:user];
            }
        }
        [[FFUserDataBase sharedInstance] saveGroup:group];
    } else if ([type isEqualToString:@"everyone"]) {    // Everyone
        msg.remoteID = EveryoneLocalID;
        msg.groupName = EveryoneRoomName;
        msg.chatType = FFChatTypeEveryOne;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        if (msg.timeStamp/10000000000000) { DDYInfoLog(@"有网接收的消息时间戳有错误：%ld为十三位",(long)msg.timeStamp); }
        [self postNotification:FFNewMessageNotification withObject:msg];
        [[FFXMPPManager sharedManager] sendReceiveCallBack:msg msgID:msg.messageID];
        if ([NSString ddy_blankString:msg.remoteID]) {
            DDYInfoLog(@"09090099090990:\n%d\n%@",msg.messageType,dict);
        }
    });
}

// 处理消息
+ (void)handleXMPPMessage:(XMPPMessage *)xmppMessage
{
    NSString *xmppType = [[xmppMessage attributeForName:@"msgtype"] stringValue];
    NSString *type = [[xmppMessage attributeForName:@"type"] stringValue];
    NSString *messageID = [[xmppMessage attributeForName:@"id"] stringValue];
    NSString *toStr = [[xmppMessage attributeForName:@"to"] stringValue];
    NSString *uidFrom = [[[xmppMessage attributeForName:@"from"] stringValue] componentsSeparatedByString:@"@"][0];
    NSString *timeStamp = [[[xmppMessage attributeForName:@"msgTime"] stringValue] substringToIndex:10];
   
    NSDictionary *dict = [NSString ddy_JsonStrToArrayOrDict:[[xmppMessage elementForName:@"body"] stringValue]];
    DDYInfoLog(@"收到消息\n%@\nxmppType:%@\nmessageID:%@\ntoStr：%@\nuidFrom:%@\ntimeStamp:%@",dict,xmppType,messageID,toStr,uidFrom,timeStamp);
    
    [self writeToFile:DDYStrFormat(@"xmppType:%@\ntype:%@\nmessageID:%@\nuidFrom:%@\ncontent:%@",xmppType,type,messageID,uidFrom,[[xmppMessage elementForName:@"body"] stringValue])];
    
    NSInteger msgtype = [dict[@"type"] integerValue];
    
    if ([xmppType isEqualToString:@"normalchat"] || [xmppType isEqualToString:@"groupchat"])
    {
        if ([type isEqualToString:@"chat"]) // 群/单聊
        {
            if (msgtype==0 || msgtype==1 || msgtype==2 || msgtype==6) { //文本/图片/语音/名片
                [FFMessage msgDict:dict type:xmppType msgID:messageID msgTime:timeStamp others:dict];
            } else if (msgtype==10000) { // 离线消息
                for (NSDictionary *offlineDict in (NSArray *)dict[@"offlinelist"]) {
                    [FFMessage msgDict:offlineDict type:xmppType msgID:offlineDict[@"id"] msgTime:offlineDict[@"msgTime"] others:dict];
                }
            }
        }
        else if ([type isEqualToString:@"groupchat"]) // everyone
        {
            [FFMessage msgDict:dict type:@"everyone" msgID:messageID msgTime:timeStamp others:nil];
        }
    }
    else if ([xmppType isEqualToString:@"system"])
    {
        [[FFXMPPManager sharedManager] sendUnknowReciveCallBack:xmppMessage messageid:messageID];
        DDYInfoLog(@"系统消息：%ld",(long)msgtype);
        if (msgtype == -1) //强制下线
        {
            [self postNotification:FFUserOffLineNotification];
        }
        else if (msgtype == 0) //好友请求
        {
            FFMessage *msg = [[FFMessage alloc] init];
            msg.timeStamp = [[NSDate date] timeIntervalSince1970];
            msg.messageType = FFMessageTypeFriendRequest;
            msg.remoteID = SystemLocalID;
            msg.chatType = FFChatTypeSystem;
            msg.groupName = @"好友通知";
            msg.nickName = dict[@"username"];
            msg.userImage = dict[@"userimage"];
            msg.uidFrom = dict[@"userid"];
            msg.textContent = dict[@"content"];
            msg.messageID = messageID;
            dispatch_async(dispatch_get_main_queue(), ^{
                // 发送最近通知消息列表
                [self postNotification:FFNewMessageNotification withObject:msg];
            });
        }
        else if (msgtype == 1) //好友请求确认系统消息
        {
            DDYInfoLog(@"好友请求确认系统消息");
        }
        else if (msgtype == 2) //好友删除消息
        {
            
        }
    }
}

#pragma mark 临时测试，以后删除
+ (void)writeToFile:(NSString *)str {
    if ([NSString ddy_blankString:str]) return;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString * logPath = [DDYPathDocument stringByAppendingString:@"/DDYXMPPLog"];
        [FFFileManager createDirectory:logPath error:nil];
        NSString *content = [NSString stringWithContentsOfFile:DDYStrFormat(@"%@/DDYLog.txt",logPath) encoding:NSUTF8StringEncoding error:nil];
        NSString *textStr = content ? DDYStrFormat(@"%@\n\n\n\n%@",content, str) : str;
        [textStr writeToFile:DDYStrFormat(@"%@/DDYLog.txt",logPath) atomically:YES encoding:NSUTF8StringEncoding error:NULL];
        
    });
}

@end
