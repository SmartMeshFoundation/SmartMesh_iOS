//
//  FFMCManager.h
//  SmartMesh
//
//  Created by Rain on 15/9/11.
//  Copyright © 2017年 SmartMesh Foundation All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@class FFUser;

@interface FFMCManager : NSObject


@property (nonatomic, strong) NSMutableArray *onlineUsersArray;

@property (nonatomic, assign) BOOL canInvite;

@property (nonatomic, copy) void(^usersArrayChangeBlock)(NSMutableArray *onlineUsersArray);


+ (instancetype)sharedManager;


- (void)initWithUser:(FFUser *)user;


- (void)restart;


- (BOOL)sendMessageToAll:(NSData *)message;


- (BOOL)sendMessageToUser:(NSString *)localID message:(NSData *)message;

- (void)sendImgToAll:(NSURL *)url result:(void (^)(BOOL success))result;

- (void)sendImgToUser:(NSString *)localID url:(NSURL *)url result:(void (^)(BOOL success))result;


- (void)sendAvatarToAll;


- (void)sendVoiceToAll:(NSURL *)url result:(void (^)(BOOL success))result;


- (void)sendVoiceToUser:(NSString *)localID url:(NSURL *)url result:(void (^)(BOOL success))result;

- (void)sendVideoToAll:(NSURL *)url result:(void (^)(BOOL success))result;

- (void)sendVideoToUser:(NSString *)localID url:(NSURL *)url result:(void (^)(BOOL success))result;

@end
