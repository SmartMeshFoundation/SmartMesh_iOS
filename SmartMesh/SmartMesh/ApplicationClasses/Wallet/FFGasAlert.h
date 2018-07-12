//
//  FFGasAlert.h
//  FireFly
//
//  Created by SmartMesh on 18/1/31.
//  Copyright © 2018年 NAT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FFGasAlert : UIView

@property (nonatomic, copy) void (^confirmBlock)();

+ (instancetype)alertViewWithMsg:(NSString *)msg;

- (void)showOnWindow;

- (void)hide;

@end
