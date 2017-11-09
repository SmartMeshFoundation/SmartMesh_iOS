//
//  DDYAuthorityMaster.h
//  DDYProject
//
//  Created by starain on 15/8/31.
//  Copyright © 2015年 Starain. All rights reserved.
//
//  Use : [DDYAuthorityMaster checkCameraAuthority]

#import <Foundation/Foundation.h>

typedef void (^AuthorizedFinishBlock)();

typedef void (^AuthorityBlock)();

@interface DDYAuthorityMaster : NSObject

#pragma mark - 摄像头权限
+ (void)cameraAuthorizedSuccess:(AuthorizedFinishBlock)success fail:(AuthorizedFinishBlock)fail;

#pragma mark - 麦克风权限
+ (void)audioAuthorizedSuccess:(AuthorizedFinishBlock)success fail:(AuthorizedFinishBlock)fail;

#pragma mark - 相册权限
+ (void)albumAuthorizedSuccess:(AuthorizedFinishBlock)success fail:(AuthorizedFinishBlock)fail;

#pragma mark - 推送通知权限
+ (void)pushNotificationAuthorizedSuccess:(AuthorizedFinishBlock)success fail:(AuthorizedFinishBlock)fail;

#pragma mark - 定位权限
+ (void)locationAuthorizedSuccess:(AuthorizedFinishBlock)success fail:(AuthorizedFinishBlock)fail;

#pragma mark - 通讯录权限
+ (void)AddressBookAuthorizedSuccess:(AuthorizedFinishBlock)success fail:(AuthorizedFinishBlock)fail;

/** 麦克风权限 */
+ (void)audioAuthSuccess:(AuthorityBlock)success fail:(AuthorityBlock)fail alertShow:(BOOL)show;
/** 摄像头权限 */
+ (void)cameraAuthSuccess:(AuthorityBlock)success fail:(AuthorityBlock)fail alertShow:(BOOL)show;
/** 相册使用权限 */
+ (void)albumAuthSuccess:(AuthorityBlock)success fail:(AuthorityBlock)fail alertShow:(BOOL)show;
/** 推送通知权限 */
+ (void)pushNotificationAuthSuccess:(AuthorityBlock)success fail:(AuthorityBlock)fail alertShow:(BOOL)show;
/** 通讯录权限 */
+ (void)contactsAuthSuccess:(AuthorityBlock)success fail:(AuthorityBlock)fail alertShow:(BOOL)show;
/** 定位权限 */
+ (void)locationAuthSuccess:(AuthorityBlock)success fail:(AuthorityBlock)fail alertShow:(BOOL)show;

@end
