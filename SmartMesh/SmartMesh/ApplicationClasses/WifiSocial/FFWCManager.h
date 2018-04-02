//
//  FFWCManager.h
//  FireFly
//
//  Created by Admin on 2018/3/30.
//  Copyright © 2018年 NAT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FFWCManager : NSObject

@property (nonatomic, readonly)NSArray *onlineUsersArray;

/** the singleton */
+ (instancetype)sharedManager;


//@property (nonatomic, copy) void(^getOnlineUsersArrayBlock)(NSArray *onlineUsersArray);

-(void)getOnlineUserWithLocalID:(NSString*)localID getOnlineUserBlock:(void(^)(FFUser *user))getOnlineUserBlock;

/** send message to all users */
- (BOOL)sendMessageToAll:(NSString *)message;

/** send message to one users */
- (BOOL)sendMessageToUser:(NSString *)localID message:(NSString *)message;
/** found user */
- (BOOL)foundUser:(NSString *)localID;

/** send image to all users */
- (void)sendImgToAll:(UIImage *)image result:(void (^)(BOOL success))result;

/** send image to one user */
- (void)sendImgToUser:(UIImage *)image result:(void (^)(BOOL success))result;

@end
