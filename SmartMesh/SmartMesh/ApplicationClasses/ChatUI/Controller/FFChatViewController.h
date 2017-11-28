//
//  FFChatViewController.h
//  SmartMesh
//
//  Created by Rain on 17/11/28.
//  Copyright © 2017年 SmartMesh Foundation All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, FFChatVCType)
{
    FFChatVCTypeChat = 0,
    FFChatVCTypeGroupChat,
    NAChatVCTypeStaticGroupChat,
};

@interface FFChatViewController : DDYBaseViewController

- (void)chatUID:(NSString *)chatUID chatType:(FFChatType)chatType groupName:(NSString *)groupName ;

@property (nonatomic, assign) FFChatVCType type;

@end
