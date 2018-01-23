//
//  FFXMPPManager.h
//  SmartMesh
//
//  Created by Rain on 17/11/20.
//  Copyright © 2017年 SmartMesh Foundation All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPP.h"
#import "FFXMPPReconnect.h"

#define JID_String(remoteID)   [NSString stringWithFormat:@"%@@firefly.com/app_v2.1.2",remoteID]
#define JID_EveryOne(localID) [NSString stringWithFormat:@"everyone@conference.firefly.com/%@",localID]
#define JID_Group(remoteID)    [NSString stringWithFormat:@"%@@group.firefly.com",remoteID]

@interface FFXMPPManager : NSObject

/** 单例对象 */
+ (instancetype)sharedManager;

/** 连接XMPP,连接后将启用自动重连机制 */
- (BOOL)connectWithUser:(FFUser *)user;

/** XMPP发消息 */
- (void)sendMessage:(FFMessage *)message;

/** 发送回执 */
- (void)sendReceiveCallBack:(FFMessage *)message msgID:(NSString *)msgID;

-(void) sendUnknowReciveCallBack:(XMPPMessage *)message messageid:(NSString *)messageid;

/** 进入ereryone */
- (void)enterEveryoneChatWithLastMsgTime:(NSInteger)msgTime;

/** 退出everyone */
- (void)exitEveryoneChat;
/** <presence from="15475@firefly.com" to="everyone@conference.firefly.com/15475" msgTime="1508486714234" id="20171011" /> */


/** 断开连接,断开后会停止自动重连 */
- (void)disconnect;

@end
