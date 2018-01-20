//
//  FFMessage.h
//  SmartMesh
//
//  Created by Rain on 18/1/206.
//  Copyright © 2018年 SmartMesh Foundation All rights reserved.
//

/**
 {"userid" "username" "userimage" "usergender" "type" "content" "cover" "friend_log” "mask" "msgsource" }
 */

#import <Foundation/Foundation.h>
#import "XMPPMessage.h"

@interface FFMessage : NSObject

//----------------------------- 必须指定 -----------------------------//
/** 消息时间戳-- 改成double-- */
@property (nonatomic, assign) NSInteger timeStamp;
/** 聊天类型 */
@property (nonatomic, assign) FFChatType chatType;
/** 发送状态 消息发送者发送后指定 */
@property (nonatomic, assign) FFMessageSendState messageSendState;
/** 阅读状态 消息接收者接收后指定 */
@property (nonatomic, assign) FFMessageReadState messageReadState;
/** 真正发送者localID(无论单聊还是群聊,都是真正发送人的localid) */
@property (nonatomic, strong) NSString *uidFrom;
/** 发送者昵称 */
@property (nonatomic, strong) NSString *nickName;
/** 消息ID */
@property (nonatomic, strong) NSString *messageID;
/** 我在remoteID中聊天 单聊传对方ID 讨论组和群聊填相应GroupID */
@property (nonatomic, strong) NSString *remoteID;
/** 我在groupName中聊天 单聊忽略 群组传groupName */
@property (nonatomic, strong) NSString *groupName;
/** 发送者头像网络地址 有网用 */
@property (nonatomic, strong) NSString *userImage;
/** 是否屏蔽 未屏蔽0 屏蔽1 */
@property (nonatomic, assign) NSInteger mask;
/** 发送者性别 */
@property (nonatomic, strong) NSString *gender;
/** 好友关系 @"-1"自己 @"0"陌生人 @"1"好友 */
@property (nonatomic, strong) NSString *friend_log;
/** 保存表情富文本 */
@property (nonatomic, strong) NSMutableAttributedString *attributedString;
/** 是否显示时间 */
@property (nonatomic, assign) BOOL isShowTime;


/// 发送卡片
/** 名片名字 */
@property (nonatomic, strong) NSString *cardName;
/** 名片头像url */
@property (nonatomic, strong) NSString *cardImage;
/** 名片ID */
@property (nonatomic, strong) NSString *cardID;
/** 名片签名 */
@property (nonatomic, strong) NSString *cardSign;

/// 接收钱包的交易记录消息
/** noticetype 0 本次交易发款人接收消息  1 本次交易收款人接收消息 */
@property (nonatomic, strong) NSString *noticetype;
/** money 额度*/
@property (nonatomic, strong) NSString *money;
/** mode  0 eth   1 smt */
@property (nonatomic, strong) NSString *mode;
/** msgtype  -2 未打包; -1 等待12个区块确认中;   0成功   1失败 */
@property (nonatomic, strong) NSString *msgtype;
/** toaddress 对方的地址 */
@property (nonatomic, strong) NSString *toaddress;
/** fee 旷工费 */
@property (nonatomic, strong) NSString *fee;
/** time 订单时间 */
@property (nonatomic, strong) NSString *time;
/** url 交易记录的url */
@property (nonatomic, strong) NSString *url;
/** number 订单号 */
@property (nonatomic, strong) NSString *number;
/** txblocknumber 当前tx 所在的区块号 */
@property (nonatomic, strong) NSString *txblocknumber;
/** fromaddress 发送方的地址 */
@property (nonatomic, strong) NSString *fromaddress;

/** 未读数 */
@property (nonatomic, assign) NSInteger unread;

//----------------------------- 聊天内容 -----------------------------//
/** 消息内容类型 */
@property (nonatomic, assign) FFMessageType messageType;
/** 无网聊天内容字典转字符串 无网用 */
@property (nonatomic, strong) NSString *content;
/** 有网通讯数据字典 有网用 */
@property (nonatomic, strong) NSMutableDictionary *netDict;
/** 聊天列表展示的消息内容 本地存数据库用来显现在首页最近聊天列表 */
@property (nonatomic, strong) NSString *showText;

/** 文本消息内容 */
@property (nonatomic, strong) NSString *textContent;
/** 图片消息data */
@property (nonatomic, strong) NSString *imgBase64Data;
/** 有网文件URL */
@property (nonatomic, strong) NSString *fileURL;
/** 语音长度 */
@property (nonatomic, strong) NSString *voiceDuration;
/** 一般,都不需要使用该属性........ 对于系统消息提示的内容类型(暂时用于群聊系统消息和时间消息的提示tipcell的展示) */
@property (nonatomic, assign) NSInteger contentType;

//----------------------------- 聊天内容 -----------------------------//

/** 群组邀请人 */
@property (nonatomic, strong) NSString *invitename;

/** 是否接收好友请求 */
@property (nonatomic, strong) NSString *accepted;

/** 是否来自无网 来自无网@"1" */
@property (nonatomic, strong) NSString *isFromNoNet;

+ (void)handleXMPPMessage:(XMPPMessage *)xmppMessage;

/** 将message转为data */
+ (NSData *)dataWithMessage:(FFMessage *)message;

@end
