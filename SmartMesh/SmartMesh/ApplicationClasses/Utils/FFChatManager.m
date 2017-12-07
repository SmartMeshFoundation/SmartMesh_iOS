//
//  FFChatManager.m
//  SmartMesh
//
//  Created by Rain on 17/12/07.
//  Copyright © 2017年 SmartMesh Foundation. All rights reserved.
//

#import "FFChatManager.h"
#import "UIImage+LCExtension.h"
#import "NSData+XMPP.h"

// 两次响铃震动的最短时间间隔
static const CGFloat kVibrationInterval = 3.0;

@interface FFChatManager ()

@property (nonatomic, strong) NSString *remoteID;

@property (nonatomic, assign) FFChatType chatType;
/** 最后一次响铃时间 */
@property (nonatomic, strong) NSDate * lastVibrationDate;

@end

@implementation FFChatManager

#pragma mark - 单例对象

static FFChatManager *_instance;

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

- (instancetype)init {
    if (self = [super init]) {
        [FFFileManager createAllDirectory];
        [self observeNotification:FFNewMessageNotification];
        self.lastVibrationDate = [NSDate date];
    }
    return self;
}

- (void)handleNotification:(NSNotification *)notification {
    if ([notification is:FFNewMessageNotification]) {
        [self receiveMsg:(FFMessage *)notification.object];
    }
}

#pragma mark 开始聊天 清除未读计数
- (void)startChat:(FFChatType)chatType remoteID:(NSString *)remoteID {
    _chatType = chatType;
    _remoteID = remoteID;

    [FFFileManager createDirectoryWithUser:remoteID];
    // 告诉数据库正在跟谁聊天
    [FFChatDataBase sharedInstance].remoteID = remoteID;
    [[FFChatDataBase sharedInstance] createChatTableWithChatType:chatType remoteID:remoteID];
    // 清除chatVC的未读数
    [[FFChatDataBase sharedInstance] cleanUnreadWithChatType:chatType remoteID:remoteID];
    // 清除recentVC的未读数
    [[FFUserDataBase sharedInstance] cleanUnreadWithRemoteID:remoteID];
}

#pragma mark 聊天结束 可以重新计数
- (void)endChat {
    if (_chatType == FFChatTypeEveryOne)  {
        [[FFXMPPManager sharedManager] exitEveryoneChat];
        [FFMCManager sharedManager].canRreceiveEveryoneMsg = NO;
    }
    _chatType = -1;
    _remoteID = EveryoneLocalID;
    [FFChatDataBase sharedInstance].remoteID = EveryoneLocalID;
}

#pragma mark 发送消息
- (void)sendMsg:(FFMessage *)message {
    // 添加时间信息
    [self showTimeWithMsg:message];
    // 添加到聊天数据表 目前不管发送和接收状态(因为涉及无网和有网两方面，可能不一致)
    [self saveMessageToChatDataBase:message];
    // 有网发送 (条件有网并且已经是网络账户)
    if ([[LC_Network LCInstance] isNetwork] && ![NSString ddy_blankString:[FFLoginDataBase sharedInstance].loginUser.token] && ![message.isFromNoNet isEqualToString:@"1"]) {
        [[FFXMPPManager sharedManager] sendMessage:message];
    }
    // 无网发送
    [self sendNoNetwork:message];
    // 添加最近聊天列表
    [self addRecentChat:message]; 
}

#pragma mark 接收消息
- (void)receiveMsg:(FFMessage *)message {
    // 添加时间信息
    [self showTimeWithMsg:message];
    // 添加到聊天数据表
    [self saveMessageToChatDataBase:message];
    // 下载保存文件
    [self downLoadFile:message];
    // 添加最近聊天列表
    [self addRecentChat:message];
    // 响铃
    [self vibrationAndSound];
}

#pragma mark 删除联系人或退出群组 (同时删除聊天记录，删除文件夹，最近列表)
- (void)deleteUser:(NSString *)localID chatType:(FFChatType)chatType {
    switch (chatType) {
        case FFChatTypeSingle: // 从联系人数据库表中删除
            [[FFUserDataBase sharedInstance] deleteUser:localID];
            break;
        case FFChatTypeGroup:
            
            break;
        case FFChatTypeDiscuss:
            
            break;
        case FFChatTypeSystem:
            
            break;
        case FFChatTypeEveryOne:
            
            break;
    }
    // 删除聊天记录
    [[FFChatDataBase sharedInstance] deleteAllWithChatType:chatType remoteID:localID];
    // 删除文件夹
    [FFFileManager deleteDirecrotyWithUser:localID];
    // 删除最近列表
    [[FFUserDataBase sharedInstance] deleteRecentChat:localID];
}

#pragma mark 删除最近列表 (同时删除聊天记录，删除文件夹)
- (void)deleteRecentChat:(NSString *)remoteID chatType:(FFChatType)chatType {
    // 删除聊天记录
    [[FFChatDataBase sharedInstance] deleteAllWithChatType:chatType remoteID:remoteID];
    // 删除文件夹
    [FFFileManager deleteDirecrotyWithUser:remoteID];
    // 删除最近列表
    [[FFUserDataBase sharedInstance] deleteRecentChat:remoteID];
}

#pragma mark 清空聊天记录 (同时删除文件夹)
- (void)deleteChatContent:(NSString *)remoteID chatType:(FFChatType)chatType {
    // 删除聊天记录
    [[FFChatDataBase sharedInstance] deleteAllWithChatType:chatType remoteID:remoteID];
    // 删除文件夹
    [FFFileManager deleteDirecrotyWithUser:remoteID];
}

#pragma mark 清空缓存（同时删除聊天记录，删除文件夹，清空最近列表）
- (void)deleteAllChatCache {
    // 删除所有聊天记录
    [[FFChatDataBase sharedInstance] deleteAllChatDataBase];
    // 删除所有文件夹
    [FFFileManager deleteAllDirectory];
    // 删除所有最近列表
    [[FFUserDataBase sharedInstance] deleteAllRecentChat];
}

#pragma mark - 私有方法
#pragma mark 添加到聊天数据表
- (void)saveMessageToChatDataBase:(FFMessage *)message {
    
    // 发送通知,更新发送者聊天内容;
    dispatch_async(dispatch_get_main_queue(), ^{
            if (message.messageType == FFMessageTypeFriendRequest || message.messageType == FFMessageTypeFriendAccept) {
                [self postNotification:FFAddFriendRequestNotification withObject:message]; // 更新`好友请求状态`
            }else if ([message.remoteID isEqualToString:self.remoteID]) { // 如果当前消息的
                [self postNotification:FFNewMsgRefreshChatPageNotification withObject:message]; //通知聊天界面
            }
        });
    [[FFChatDataBase sharedInstance] saveMessage:message];
}

#pragma mark 添加最近聊天列表
- (void)addRecentChat:(FFMessage *)message {
    FFRecentModel *model = [FFRecentModel modelWithMessage:message];
    if ([[FFUserDataBase sharedInstance] addRecentChat:model]) {
        [self postNotification:FFRefreshHomePageNotification withObject:model];
    }
}

#pragma mark 无网发送
- (void)sendNoNetwork:(FFMessage *)message {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"timeStamp"] = DDYStrFormat(@"%lf",[[NSDate date] timeIntervalSince1970]*1000);
    dict[@"chatType"] = DDYStrFormat(@"%d",(int)message.chatType);
    dict[@"uidFrom"] = message.uidFrom;
    dict[@"nickName"] = message.nickName;
    dict[@"messageID"] = message.messageID;
    dict[@"remoteID"] = message.remoteID;
    dict[@"groupName"] = message.groupName;
    dict[@"content"] = message.content;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    if (message.chatType == FFChatTypeSingle) {
        [[FFMCManager sharedManager] sendMessageToUser:message.remoteID message:jsonData];
    } else if (message.chatType == FFChatTypeEveryOne) {
        [[FFMCManager sharedManager] sendMessageToAll:jsonData];
    }
}

#pragma mark 是否添加时间显示message 没上条消息或者两条间隔3分钟以上插入时间
- (void)showTimeWithMsg:(FFMessage *)msg {
    if (msg.chatType!=FFChatTypeSingle || msg.chatType!=FFChatTypeGroup || msg.chatType!=FFChatTypeEveryOne) {
        return;
    }
    NSMutableArray *lastMsgArray = [[FFChatDataBase sharedInstance] selectRange:NSMakeRange(0, 1) chatType:msg.chatType remoteID:msg.remoteID];
    NSInteger timeInterval = 60*kVibrationInterval;
    if (lastMsgArray && lastMsgArray.count) {
        FFMessage *lastMsg = lastMsgArray[0];
        timeInterval = [NSDate intervalWithTime1:DDYStrFormat(@"%ld",(long)lastMsg.timeStamp) time2:DDYStrFormat(@"%ld",(long)msg.timeStamp)];
    }
    
    if (timeInterval >= 60*kVibrationInterval) {
        FFMessage *timeMsg = [[FFMessage alloc] init];
        timeMsg.chatType = msg.chatType;
        timeMsg.uidFrom = SystemLocalID;
        timeMsg.messageType = FFMessageTypeSystemTime;
        timeMsg.nickName = SystemLocalID;
        timeMsg.messageID = [XMPPStream generateUUID];
        timeMsg.remoteID = msg.remoteID;
        timeMsg.groupName = msg.groupName;
        timeMsg.timeStamp = msg.timeStamp;
        timeMsg.textContent = [NSDate chatPageTime:DDYStrFormat(@"%ld",(long)msg.timeStamp) enOrCn:DDYLocalStr(@"enOrCn")];
        [self saveMessageToChatDataBase:timeMsg];
        DDYInfoLog(@"添加时间添加时间");
    }
}

#pragma mark 下载保存文件
- (void)downLoadFile:(FFMessage *)msg {
    if (![msg.isFromNoNet isEqualToString:@"1"] &&( msg.chatType==FFChatTypeSingle || msg.chatType==FFChatTypeGroup || msg.chatType==FFChatTypeEveryOne)) {
        
        if (msg.messageType == FFMessageTypeImg || msg.messageType == FFMessageTypeVoice) {
            
            [FFFileManager saveReceiveMsg:msg callBack:^(BOOL finish) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self postNotification:FFNewMsgRefreshChatPageNotification withObject:msg];
                });
            }];
            
        }
        else if (msg.messageType == FFMessageTypeCard) {
            
        }
    }
}

#pragma mark - 上传 语音/图片
- (void)uploadFileWithType:(NSString *)type source:(id)source callBack:(void(^)(BOOL isSuccess, NSDictionary *fileSource))callBack;
{
    NSString *uid = [FFLoginDataBase sharedInstance].loginUser.localid;
    
    // 本地文件信息
    NSMutableDictionary *fileDict = [NSMutableDictionary dictionary];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:uid forKey:@"uid"];
    [params setObject:type forKey:@"type"];
    
    NSData *data = nil;
    NSString *cover64 = nil;
    NSString *filePath = nil;
    
    // 处理图片
    if ([source isKindOfClass:[UIImage class]]) {
        
        UIImage *image = (UIImage *)source;
        data = [image jpgCompressionWithQuality:FF_COMPRESS maxFileSize:FF_MIN_SIZE];
        cover64 = [[[image scaleToWidth:240 height:240 isCover:YES] jpgCompressionWithQuality:0.5 maxFileSize:FF_MAX_COVER_KB] xmpp_base64Encoded];
        [fileDict setObject:cover64 forKey:@"cover"];
        
        
        [params setObject:@"accessory.jpg" forKey:@"imageKey"];
        [params setObject:data forKey:@"image"];

    }else if ([source isKindOfClass:[NSString class]]) { // 处理语音
        
        filePath = (NSString *)source;
        
        [params setObject:@"accessory.amr" forKey:@"fileKey"];
        [params setObject:filePath forKey:@"filePath"];
    }
    
    [NANetWorkRequest na_postDataWithService:@"conversation" action:@"speak" parameters:params results:^(BOOL status, NSDictionary *result) {
        
        if (status) {
            NSLog(@"上传成功\n");
            NSString *fileUrl = result[@"url"];
            
            [fileDict setObject:fileUrl forKey:@"fileUrl"]; // 语音,图片url
            
            if (callBack) {
                callBack(YES, fileDict);
            }
            
        }else {
            NSLog(@"上传失败");
            callBack(NO, nil);
        }
    }];
}

#pragma mark 震动和响铃 http://www.cnblogs.com/yajunLi/p/5952585.html
- (void)vibrationAndSound {
    NSDate *date = [NSDate date];
    if ([date timeIntervalSinceDate:_lastVibrationDate] > kVibrationInterval) {
//        if ([[FFLoginDataBase sharedInstance].loginUser.vibrationSwitch isEqualToString:@"1"]) {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
//        }
//        if ([[FFLoginDataBase sharedInstance].loginUser.soundSwitch isEqualToString:@"1"]) {
            SystemSoundID soundID;
            NSString * path = [@"/System/Library/Audio/UISounds/" stringByAppendingPathComponent:@"sms-received1.caf"];
            AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &soundID);
            AudioServicesPlaySystemSound (soundID);
//        }
    }
    _lastVibrationDate = date;
}

- (void)dealloc {
    [self unobserveAllNotifications];
}

@end
