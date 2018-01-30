//
//  FFGestureHeader.h
//  FireFly
//
//  Created by SmartMesh on 18/1/29.
//  Copyright © 2018年 NAT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FFWalletVerifyView.h"

@interface FFGestureHeader : UIView

+ (instancetype)headerType:(DDYLockViewType)type;

/** 普通提示 */
- (void)showNormalMsg:(NSString *)msg;
/** 摇动警示 */
 - (void)showWarningAndShake:(NSString *)msg;

/** 设置状态第一次设置后infoView展示相应选中 */
- (void)infoViewSelectedSameAsLockView:(DDYLockView *)lockView andShowNormalMsg:(NSString *)msg;
/** 重绘手势不成功让infoView按钮全部取消选中 */
- (void)infoViewDeselectedAllCircleAndShowMsg:(NSString *)msg;

/** 切换验证/登录方式 */
- (void)changeToWallet:(BOOL)isWallet;

/** 切换钱包地址后刷新钱包信息 */
- (void)refreshWalletInfo;

@end
