//
//  FFMidAlertView.h
//  FireFly
//
//  Created by SmartMesh on 18/1/24.
//  Copyright © 2018年 NAT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FFMidAlertView : UIView

@property (nonatomic, copy) void (^completeBlock)();

+ (instancetype)alertView;

- (void)showOnWindow;

@end
