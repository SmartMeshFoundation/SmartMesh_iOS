//
//  FFGestureLockVC.h
//  FireFly
//
//  Created by SmartMesh on 18/1/29.
//  Copyright © 2018年 NAT. All rights reserved.
//

#import "DDYBaseViewController.h"

@interface FFGestureLockVC : DDYBaseViewController

@property (nonatomic, assign) DDYLockViewType lockType;

@property (nonatomic, copy) void (^gestureLockBlock)(BOOL isGesture);

@end
