//
//  FFChatManager.h
//  SmartMesh
//
//  Created by Rain on 17/12/07.
//  Copyright © 2017年 SmartMesh Foundation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FFChatManager : NSObject

/** 单例对象 */
+ (instancetype)sharedManager;

//--------------------- 聊天必须调用 ---------------------//
/** 聊天开始 清除未读计数 */
- (void)startChat:(FFChatType)chatType remoteID:(NSString *)remoteID;
/** 聊天结束 可以重新计数 */
- (void)endChat;
/** 发送消息 */
- (void)sendMsg:(FFMessage *)message;
/** 接收消息 */
- (void)receiveMsg:(FFMessage *)message;

//--------------------- 删除聊天操作 ---------------------//
/** 删除联系人 (同时删除聊天记录，删除文件夹，最近列表) */
- (void)deleteUser:(NSString *)localID callBack:(void(^)(BOOL finish))callBack;
/** 删除最近列表 (同时删除聊天记录，删除文件夹) */
- (void)deleteRecentChat:(NSString *)remoteID chatType:(FFChatType)chatType;

/* --------------------- 上传 语音1 source:图片data / 图片2 source: 语音本地地址 等操作 --------------------- */
- (void)uploadFileWithType:(NSString *)type source:(id)source callBack:(void(^)(BOOL isSuccess, NSDictionary *fileSource))callBack;

@end
