//
//  FFXMPPReconnect.h
//  SmartMesh
//
//  Created by Rain on 17/11/20.
//  Copyright © 2017年 SmartMesh Foundation All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPStream.h"

@interface FFXMPPReconnect : NSObject

@property (nonatomic, copy) void (^beginConnect)(XMPPStream *stream);

/** 初始化断线重连类 */
- (instancetype)initWithXmppStream:(XMPPStream *)stream;

/** 当XMPP stream断线后,调用此方法开始断线重连 */
- (void)streamDisconnect;

@end
