//
//  FFWalletVerifyView.h
//  FireFly
//
//  Created by SmartMesh on 18/1/29.
//  Copyright © 2018年 NAT. All rights reserved.
//

#import <UIKit/UIKit.h>

//--------------------- 钱包选择视图 ---------------------//
@interface FFWalletSelectView : UIView

@property (nonatomic, copy) void(^selectBlock)();

+ (instancetype)selectView;

- (void)showOnWindow;

@end

//--------------------- 钱包密码视图 ---------------------//
@interface FFWalletVerifyView : UIView

@property (nonatomic, assign) BOOL isWallet;

@property (nonatomic, copy) void (^walletVerifyBlock)(BOOL isOk);

+ (instancetype)verifyView;

@end
