//
//  FFTabBarController.h
//  SmartMesh
//
//  Created by RainDou on 18/1/16.
//  Copyright © 2015年 RainDou All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FFTabBarController : UITabBarController

// 更换钱包Wallet的根控制器;
- (void)addChildVC:(UIViewController *)vc img:(UIImage *)img selectedImg:(UIImage *)selectedImg;

@end
