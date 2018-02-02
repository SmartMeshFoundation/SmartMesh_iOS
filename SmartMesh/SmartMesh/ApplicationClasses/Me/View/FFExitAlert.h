//
//  FFExitAlert.h
//  FireFly
//
//  Created by SmartMesh on 18/2/2.
//  Copyright © 2018年 SmartMesh Foundation All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, FFExitAlertType) {
    FFExitAlertTypeOne = 1,        // 第一次弹窗
    FFExitAlertTypeTwo = 2,        // 第二次弹窗
};

@interface FFExitAlert : UIView

@property (nonatomic, copy) void (^firstBtnBlock)();

@property (nonatomic, copy) void (^secondBtnBlock)();

+ (instancetype)alertViewWithType:(FFExitAlertType)type;

- (void)showOnWindow;

@end
