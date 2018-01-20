//
//  FFMessage.m
//  SmartMesh
//
//  Created by Rain on 18/1/206.
//  Copyright © 2018年 SmartMesh Foundation All rights reserved.
//

#import "FFMessage.h"
#define MESSAGE_FROM_SYSTEMTYPE(type) {return ;}


@implementation FFMessage

@synthesize content = _content;
@synthesize netDict = _netDict;

- (NSString *)content {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"messageType"] = DDYStrFormat(@"%d",(int)_messageType);
    dict[@"isShowTime"] = _isShowTime ? @"1" : @"0";
    if(_isFromNoNet) dict[@"isFromNoNet"] = _isFromNoNet;
    if (_chatType == FFChatTypeSystem || _chatType == FFWalletSysytem) {
        
        dict[@"textContent"] = _textContent;
        
        if (_messageType == FFMessageTypeReceiveTransactionRecord) {
            
            dict[@"noticetype"] = _noticetype;
            dict[@"money"] = _money;
            dict[@"mode"] = _mode;
            dict[@"msgtype"] = _msgtype;
            dict[@"toaddress"] = _toaddress;
            dict[@"fee"] = _fee;
            dict[@"time"] = _time;
            dict[@"url"] = _url;
            dict[@"number"] = _number;
            dict[@"txblocknumber"] = _txblocknumber;
            dict[@"fromaddress"] = _fromaddress;
            dict[@"messageType"] = LC_NSSTRING_FORMAT(@"%li", (FFMessageType)FFMessageTypeReceiveTransactionRecord);
    
        }
        else if (_messageType == FFMessageTypeFriendRequest) {
            dict[@"messageType"] = LC_NSSTRING_FORMAT(@"%li", (FFMessageType)FFMessageTypeFriendRequest);
        }
        
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
        } else //if (_messageType == FFMessageTypeSystemTime)
        {
            dict[@"textContent"] = _textContent;
        }
    }
    return [NSString ddy_ToJsonStr:dict];
}

- (void)setContent:(NSString *)content {
    _content = content;
    
    NSDictionary *dict = [NSString ddy_JsonStrToDict:content];
    
    _messageType = (FFMessageType)([dict[@"messageType"] intValue]);
    if(dict[@"isFromNoNet"]) _isFromNoNet = dict[@"isFromNoNet"];
    _isShowTime = [dict[@"isShowTime"] isEqualToString:@"1"] ? YES : NO;
    if (_chatType == FFChatTypeSystem || _chatType == FFWalletSysytem) {
        
        _textContent = dict[@"textContent"];
        
        if (_messageType == FFMessageTypeReceiveTransactionRecord) {
            _textContent = dict[@"textContent"];
            
            self.noticetype = dict[@"noticetype"];
            self.money = dict[@"money"];
            self.mode = dict[@"mode"];
            self.msgtype = dict[@"msgtype"];
            self.toaddress = dict[@"toaddress"];
            self.fee = dict[@"fee"];
            self.time = dict[@"time"];
            self.url = dict[@"url"];
            self.number = dict[@"number"];
            self.txblocknumber = dict[@"txblocknumber"];
            self.fromaddress = dict[@"fromaddress"];
            
        }
        
        
    }else {
        
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
        } else //if (_messageType == FFMessageTypeSystemTime)
        {
            _textContent = dict[@"textContent"];
        }
    }
}

- (NSString *)showText {
    if (self.chatType == FFChatTypeSystem) {
        _showText = _textContent;
    } else {
        if (_messageType == FFMessageTypeText) {
            _showText = _textContent;
        } else if (_messageType == FFMessageTypeImg) {
            _showText = @"[Picture]";
        } else if (_messageType == FFMessageTypeVoice) {
            _showText = @"[Voice]";
        } else if (_messageType == FFMessageTypeCard) {
            _showText = @"[Card]";
        }else {
            _showText = _textContent;
        }
    }
    return _showText;
}

- (NSMutableDictionary *)netDict  {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    dict[@"userid"] = self.uidFrom;
    dict[@"username"] = self.nickName;
    dict[@"userimage"] = self.userImage;
    dict[@"mask"] = @(self.mask);
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

+ (void)msgDict:(NSDictionary *)dict type:(NSString *)type msgID:(NSString *)msgID msgTime:(NSString *)msgTime
{
    NSString *nowTime = DDYStrFormat(@"%.0lf",ceil([[NSDate date] timeIntervalSince1970]));
    FFMessage *msg = [[FFMessage alloc] init];
    msg.uidFrom = dict[@"userid"];
    msg.nickName = dict[@"username"];
    msg.userImage = dict[@"userimage"];
    msg.timeStamp = msgTime ? [(msgTime.length>10?[msgTime substringToIndex:10]:msgTime) integerValue] : [nowTime integerValue];
    msg.messageID = msgID;
    msg.mask = [dict[@"mask"] integerValue];
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
        // 保存用户
        [self saveUserFromMsg:msg];
        
        msg.uidFrom = dict[@"userid"];
        msg.remoteID = dict[@"userid"];
        msg.chatType = FFChatTypeSingle;
        msg.groupName = dict[@"username"];
        FFUser *user111 = [[FFUserDataBase sharedInstance].userDict objectForKey:msg.uidFrom];
        msg.groupName = user111.remarkName;
        
    } else if ([type isEqualToString:@"groupchat"]) {   // 群组
        msg.uidFrom = dict[@"userid"];
        msg.remoteID = dict[@"groupid"];
        msg.groupName = dict[@"groupname"];
        msg.chatType = FFChatTypeGroup;
        [self saveUserFromMsg:msg];
        
        // 保存群组
        FFGroupModel *group = [[FFUserDataBase sharedInstance] getGroupWithCid:msg.remoteID];
        if (group) {
            group.groupName = msg.groupName;
            for (NSDictionary *userDict in (NSArray *)dict[@"groupmember"]) {
                FFUser *user = [[FFUser alloc] init];
                user.localID = userDict[@"uid"];
                user.userImage = userDict[@"image"] ;
                user.gender = userDict[@"gender"];
                for (FFUser *tmpUser in group.memberList) {
                    if ([user.localID isEqualToString:tmpUser.localID]) {
                        user.nickName = tmpUser.nickName;
                    }
                    [self saveUserFromMsg:msg];
//                    [self saveGroupUserFromMsg:user];
                }
                [group.memberList addObject:user];
            }
        } else {
            group = [[FFGroupModel alloc] init];
            group.cid = msg.remoteID;
            group.groupName = msg.groupName;
            for (NSDictionary *userDict in (NSArray *)dict[@"groupmember"]) {
                FFUser *user = [[FFUser alloc] init];
                user.localID = userDict[@"uid"];
                user.userImage = userDict[@"image"] ;
                user.gender = userDict[@"gender"];
                [group.memberList addObject:user];
            
//                [self saveGroupUserFromMsg:user];
            }
        }
        [[FFUserDataBase sharedInstance] saveGroup:group];
    } else if ([type isEqualToString:@"everyone"]) {    // Everyone
        msg.remoteID = EveryoneLocalID;
        msg.groupName = EveryoneRoomName;
        msg.chatType = FFChatTypeEveryOne;
        [self saveUserFromMsg:msg];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (msg.timeStamp/10000000000000) { DDYInfoLog(@"有网接收的消息时间戳有错误：%ld为十三位",(long)msg.timeStamp); }
        
        [self postNotification:FFNewMessageNotification withObject:msg];
        
        if ([NSString ddy_blankString:msg.remoteID]) {
            DDYInfoLog(@"09090099090990:\n%d\n%@",msg.messageType,dict);
        }
        
        [[FFXMPPManager sharedManager] sendReceiveCallBack:msg msgID:msg.messageID];
    });
    
}

+ (void)msgDictArray:(NSDictionary *)dict0 type:(NSString *)type xmppMessage:(XMPPMessage *)xmppMessage
{
    
    NSArray *dictArray = (NSArray *)(dict0[@"offlinelist"]);
    
    NSString *xmppType = [[xmppMessage attributeForName:@"msgtype"] stringValue];
    NSString *type0 = [[xmppMessage attributeForName:@"type"] stringValue];
    NSString *messageID0 = [[xmppMessage attributeForName:@"id"] stringValue];

    NSString *remoteId = dict0[@"userid"];
    NSString *username = dict0[@"username"];
    NSString *userimage = dict0[@"userimage"];
    NSInteger mask = [dict0[@"mask"] integerValue];
    
    FFMessage *offMessage = [[FFMessage alloc] init];
    offMessage.messageID = messageID0;
    offMessage.remoteID = remoteId;

    if ([xmppType isEqualToString:@"normalchat"] && [type0 isEqualToString:@"chat"]){
        offMessage.chatType = FFChatTypeSingle;
        
    }else if ([xmppType isEqualToString:@"groupchat"] && [type0 isEqualToString:@"chat"]){
        offMessage.chatType = FFChatTypeGroup;
        offMessage.remoteID = dict0[@"groupid"];
        
    }else if ([type0 isEqualToString:@"groupchat"]){
        offMessage.chatType = FFChatTypeEveryOne;
    }
    
    NSMutableArray *msgArray = [NSMutableArray array];
    
    for (NSInteger count = 0; count < dictArray.count; count ++) {
      
        NSDictionary *dict = dictArray[count];
    
        FFMessage *msg = [[FFMessage alloc] init];
        msg.uidFrom = remoteId;
        msg.nickName = username;
        msg.userImage = userimage;
        msg.mask = mask;
        msg.timeStamp = [dict[@"msgTime"] doubleValue] / 1000;
        msg.messageID = dict[@"msgid"];
        
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
            msg.remoteID = remoteId;
            msg.chatType = FFChatTypeSingle;
            msg.groupName = username;
            
            // 保存用户
            [self saveUserFromMsg:msg];
        } else if ([type isEqualToString:@"groupchat"]) {   // 群组
            msg.remoteID = dict0[@"groupid"];
            msg.uidFrom = dict[@"userid"];
            msg.groupName = dict0[@"groupname"];
            msg.chatType = FFChatTypeGroup;
            msg.nickName = dict[@"username"];
            
            // 保存群组
            FFGroupModel *group = [[FFUserDataBase sharedInstance] getGroupWithCid:msg.remoteID];
            if (group) {
                group.groupName = msg.groupName;
                for (NSDictionary *userDict in (NSArray *)dict[@"groupmember"]) {
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
                for (NSDictionary *userDict in (NSArray *)dict[@"groupmember"]) {
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
        
        [msgArray addObject:msg];
        
        if (count == dictArray.count - 1) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (msg.timeStamp/10000000000000) { DDYInfoLog(@"有网接收的消息时间戳有错误：%ld为十三位",(long)msg.timeStamp); }
                
                [self postNotification:FFNewOffArrayMessageNotification withObject:msgArray];
                
                [[FFXMPPManager sharedManager] sendReceiveCallBack:offMessage msgID:messageID0];
            });
        }
    }
}

// 处理消息
+ (void)handleXMPPMessage:(XMPPMessage *)xmppMessage
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSString *xmppType = [[xmppMessage attributeForName:@"msgtype"] stringValue];
        NSString *type = [[xmppMessage attributeForName:@"type"] stringValue];
        NSString *messageID = [[xmppMessage attributeForName:@"id"] stringValue];
        NSString *toStr = [[xmppMessage attributeForName:@"to"] stringValue];
        NSString *uidFrom = [[[xmppMessage attributeForName:@"from"] stringValue] componentsSeparatedByString:@"@"][0];
        NSString *timeStamp = [[[xmppMessage attributeForName:@"msgTime"] stringValue] substringToIndex:10];
        
        NSDictionary *dict = [NSString ddy_JsonStrToArrayOrDict:[[xmppMessage elementForName:@"body"] stringValue]];
        DDYInfoLog(@"收到消息\n%@\nxmppType:%@\nmessageID:%@\ntoStr：%@\nuidFrom:%@\ntimeStamp:%@",dict,xmppType,messageID,toStr,uidFrom,timeStamp);
        
        NSInteger msgtype = [dict[@"type"] integerValue];
        
        if ([xmppType isEqualToString:@"normalchat"] || [xmppType isEqualToString:@"groupchat"])
        {
            if ([type isEqualToString:@"chat"]) // 群/单聊
            {
                if (msgtype==0 || msgtype==1 || msgtype==2 || msgtype==6) { //文本/图片/语音/名片
                    [FFMessage msgDict:dict type:xmppType msgID:messageID msgTime:timeStamp];
                    
                } else if (msgtype==10000) { // 离线消息
                    
                    [FFMessage msgDictArray:dict type:xmppType xmppMessage:xmppMessage];
                }
            }
            else if ([type isEqualToString:@"groupchat"]) // everyone
            {
                [FFMessage msgDict:dict type:@"everyone" msgID:messageID msgTime:timeStamp];
            }
        }
        else if ([xmppType isEqualToString:@"system"])
        {
            [[FFXMPPManager sharedManager] sendUnknowReciveCallBack:xmppMessage messageid:messageID];
            
            DDYInfoLog(@"系统消息：%ld",(long)msgtype);
            
            FFMessage *msg = nil;
            if (msgtype == -1) //强制下线
            {
                if ([toStr containsString:[FFLocalUserInfo deviceUUID]]) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [self showErrorText:[dict objectForKey:@"content"]];
                        [self postNotification:FFUserOffLineNotification];
                        
                        return ;
                    });
                    
                }
                
            }
            else if (msgtype == 0) //好友请求
            {
                msg = [[FFMessage alloc] init];
                msg.timeStamp = ceil([[NSDate date] timeIntervalSince1970]);
                msg.messageType = FFMessageTypeFriendRequest;
                msg.remoteID = SystemFriendRequestID;
                msg.chatType = FFChatTypeSystem;
                msg.groupName = DDYLocalStr(@"MessageFriendNotification");
                msg.nickName = dict[@"username"];
                msg.userImage = dict[@"userimage"];
                msg.uidFrom = dict[@"userid"];
                if (![NSString ddy_blankString:dict[@"content"]]) {
                    //                    msg.textContent = LC_NSSTRING_FORMAT(@"%@ %@", msg.nickName, DDYLocalStr(@"ChatRequestAddBuddy"));
                    msg.textContent = dict[@"content"];
                }
                msg.messageID = messageID;
                
            }
            else if (msgtype == 1) //好友请求确认系统消息
            {
                DDYInfoLog(@"好友请求确认系统消息");
                return ;
            }
            else if (msgtype == 2) //好友删除消息
            {
                DDYInfoLog(@"好友请求删除系统消息");
                return ;
            }
            else if (msgtype == 12 || msgtype == 13) //群主邀请
            {
                msg = [FFMessage msgGroupDict:dict msgID:messageID msgTime:timeStamp];
            }else if (msgtype == 14){// 你被群主移除群聊

                NSMutableDictionary *dictGroup = [FFUserDataBase sharedInstance].groupDict;
                FFGroupModel *group = dictGroup[dict[@"groupid"]];
                if ([group.groupState isEqualToString:groupStateRemoved]) { DDYInfoLog(@"已经被踢,或者群组解散,直接return");

                    return;
                }
                msg = [FFMessage msgGroupDict:dict msgID:messageID msgTime:timeStamp];
                [[FFUserDataBase sharedInstance] changeGroupState:groupStateRemoved cid:dict[@"groupid"]];
            }else if (msgtype == 15) {// 群组已被解散
                
                msg = [FFMessage msgGroupDict:dict msgID:messageID msgTime:timeStamp];
                [[FFUserDataBase sharedInstance] changeGroupState:groupStateDissolved cid:dict[@"groupid"]];
            }else if (msgtype == 17) {// 群组名变更
                
                msg = [FFMessage msgGroupDict:dict msgID:messageID msgTime:timeStamp];
            }else if (msgtype == 18) {// xx退出群聊
                
                msg = [FFMessage msgGroupDict:dict msgID:messageID msgTime:timeStamp];
            }
            else if (msgtype == 22){// 群主邀请xx进入群聊
                
                msg = [FFMessage msgGroupDict:dict msgID:messageID msgTime:timeStamp];
            }
            
            else if (msgtype == 300) // 收到交易消息
            {
                msg = [[FFMessage alloc] init];
                msg.timeStamp = [timeStamp integerValue];
                msg.messageType = FFMessageTypeReceiveTransactionRecord;
                msg.remoteID = SystemWalletTransactionRecordID;
                msg.chatType = FFChatTypeSystem;
                msg.groupName = DDYLocalStr(@"MessageTransactionRecord");
                
                msg.uidFrom = SystemLocalID;
                msg.noticetype      = dict[@"noticetype"];
                msg.money           = dict[@"money"];
                msg.mode            = dict[@"mode"];
                msg.msgtype         = dict[@"msgtype"];
                msg.toaddress       = dict[@"toaddress"];
                msg.fee             = dict[@"fee"];
                msg.time            = dict[@"time"];
                msg.url             = dict[@"url"];
                msg.number          = dict[@"number"];
                msg.txblocknumber   = LC_NSSTRING_FORMAT(@"%@", dict[@"txblocknumber"]);
                msg.fromaddress     = dict[@"fromaddress"];
                
                // 判断本地登录的用户是否有该钱包账户
                BOOL isSave = [self isSaveTransactionMessage:msg];
                if (!isSave) {
                    return ;
                }
                
                NSString *showText = [NSString stringWithFormat:@"%@%@ %@ %@%@",
                                      (([msg.noticetype integerValue] == 0) ? DDYLocalStr(@"MessageTransferNotification") : DDYLocalStr(@"MessageRecieveNotification")),
                                      (msg.money),
                                      (([msg.mode integerValue] == 0) ? @"eth" : @"smt"),
                                      (([msg.noticetype integerValue] == 0) ? DDYLocalStr(@"MessageTransfer") : DDYLocalStr(@"MessageReceive")),
                                      (([msg.msgtype integerValue] == 0) ? DDYLocalStr(@"MessageSuccess") : DDYLocalStr(@"MessageFail"))];
                
                msg.textContent = showText;
                msg.messageID = messageID;
                
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // 发送最近通知消息列表
                [self postNotification:FFNewMessageNotification withObject:msg];
            });
        }
        
    });
    
}

#pragma mark - 判断本地的钱包是否包含该地址
+ (BOOL)isSaveTransactionMessage:(FFMessage *)msg
{
    BOOL isSave = NO;
    if ([msg.noticetype isEqualToString:@"0"] && ([WALLET containsAddress:[Address addressWithString:msg.fromaddress]])) {
        isSave = YES;
    }else if ([msg.noticetype isEqualToString:@"1"] && ([WALLET containsAddress:[Address addressWithString:msg.toaddress]])) {
        isSave = YES;
    }else {
        
    }
    return isSave;
    
}

#pragma mark 从消息缓存用户
+ (void)saveUserFromMsg:(FFMessage *)msg {
    FFUser *user = [FFUserDataBase sharedInstance].userDict[msg.uidFrom];
    if (user) {
        if (![user.nickName isEqualToString:msg.nickName] || ![user.userImage isEqualToString:msg.userImage]) {
            user.nickName = msg.nickName;
            user.userImage = msg.userImage;
            if(msg.friend_log) user.friend_log = msg.friend_log;
            if(user.netSource) user.netSource = user.netSource;
            [[FFUserDataBase sharedInstance] saveUser:user];
        }
        
    } else {
        user = [[FFUser alloc] init];
        user.localID = msg.uidFrom;
        user.nickName = msg.nickName;
        user.userImage = msg.userImage;
        user.netSource = @"msg";
        user.friend_log = @"0";
        [[FFUserDataBase sharedInstance] saveUser:user];
    }
}

#pragma mark 从群聊中缓存用户
+ (void)saveGroupUserFromMsg:(FFUser *)groupUser {
    FFUser *user = [FFUserDataBase sharedInstance].userDict[groupUser.localid];
    if (user) {
        if (![user.nickName isEqualToString:groupUser.nickName] || ![user.userImage isEqualToString:groupUser.userImage]) {
            user.nickName = groupUser.nickName;
            user.userImage = groupUser.userImage;
            if(groupUser.friend_log) user.friend_log = groupUser.friend_log;
            if(user.netSource) user.netSource = user.netSource;
            [[FFUserDataBase sharedInstance] saveUser:user];
        }
        
    } else {
        user = [[FFUser alloc] init];
        user.localID = groupUser.localid;
        user.nickName = groupUser.nickName;
        user.userImage = groupUser.userImage;
        user.netSource = @"msg";
        user.friend_log = @"0";
        [[FFUserDataBase sharedInstance] saveUser:user];
    }
}


+ (FFMessage *) msgGroupDict:(NSDictionary *)dict msgID:(NSString *)messageID msgTime:(NSString *)timeStamp
{
    // 群组
    FFMessage *msg = [[FFMessage alloc] init];
    msg.uidFrom = SystemLocalID;
    msg.nickName = SystemLocalID;
    msg.remoteID = dict[@"groupid"];
    msg.groupName = dict[@"groupname"];
    msg.chatType = FFChatTypeGroup;
    msg.timeStamp = [timeStamp integerValue];
    msg.mask = [dict[@"mask"] integerValue];
    msg.invitename = dict[@"invitename"];
    msg.messageID = messageID;
    msg.messageType = FFMessageTypeSystemTime;
    msg.contentType = [dict[@"type"] integerValue];
//    msg.
    
    
    NSInteger msgtype = [dict[@"type"] integerValue];
    if (msgtype == 12 || msgtype == 13) {
        msg.textContent = LC_NSSTRING_FORMAT(@"您被%@邀请加入群聊", msg.invitename);
        
    }else if (msgtype == 14){// 你被群主踢出群聊
        msg.textContent = LC_NSSTRING_FORMAT(@"您被群主踢出群聊");
        msg.timeStamp = ceil([[NSDate date] timeIntervalSince1970]);
        
        
    }else if (msgtype == 15) {// 群组已被解散
        msg.textContent = LC_NSSTRING_FORMAT(@"该群聊已被群主解散");
        
    }else if (msgtype == 17) {// 群组名变更
        msg.textContent = LC_NSSTRING_FORMAT(@"群聊已更名为:%@", dict[@"groupname"]);
        
    }else if (msgtype == 18) {// xx退出群聊
        msg.textContent = LC_NSSTRING_FORMAT(@"%@ 退出群聊", dict[@"username"]);
        
    }else if (msgtype == 22) {// 群主邀请xx进入群聊
        msg.textContent = LC_NSSTRING_FORMAT(@"%@", dict[@"content"]);
        
    }

    // 保存群组
    FFGroupModel *group = [FFUserDataBase sharedInstance].groupDict[msg.remoteID];
    if (group) {
        group.groupName = msg.groupName;
        for (NSDictionary *userDict in (NSArray *)dict[@"groupmember"]) {
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
        for (NSDictionary *userDict in (NSArray *)dict[@"groupmember"]) {
            FFUser *user = [[FFUser alloc] init];
            user.localID = userDict[@"uid"];
            user.userImage = userDict[@"image"] ;
            user.gender = userDict[@"gender"];
            [group.memberList addObject:user];
        }
    }
    [[FFUserDataBase sharedInstance] saveGroup:group];
    
    return msg;
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
