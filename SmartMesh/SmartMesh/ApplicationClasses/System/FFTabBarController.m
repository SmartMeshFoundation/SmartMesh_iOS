//
//  FFTabBarController.m
//  SmartMesh
//
//  Created by RainDou on 18/1/16.
//  Copyright © 2015年 RainDou All rights reserved.
//

#import "FFTabBarController.h"
#import "FFNavigationController.h"
#import "FFTabBar.h"
#import "FFAppDelegate.h"

#import "FFChatsVC.h"
#import "FFContactVC.h"
#import "FFNearbyVC.h"
#import "FFMeVC.h"
#import "FFWalletVC.h"
#import "FFAccountViewController.h"

@interface FFTabBarController ()<FFTabBarDelegate>

@end

@implementation FFTabBarController

+ (void)initialize {
    
    NSDictionary *attributes = @{NSForegroundColorAttributeName:[UIColor lightGrayColor], NSFontAttributeName:DDYBDFont(11)};
    NSDictionary *selectedAttributes = @{NSForegroundColorAttributeName:FF_MAIN_COLOR};
    
    [[UITabBarItem appearance] setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:selectedAttributes forState:UIControlStateSelected];
    
    [[UITabBar appearance] setBackgroundColor:FFBackColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self addChildVC:[FFChatsVC vc]
                 img:[UIImage imageNamed:@"tabbar_chat_icon"]
         selectedImg:[UIImage imageNamed:@"tabbar_chat_selected_icon"]
               title:@"ChatTab"];
    
    [self addChildVC:[FFContactVC vc]
                 img:[UIImage imageNamed:@"tabber_contacts_icon"]
         selectedImg:[UIImage imageNamed:@"tabber_contacts_selected_icon"]
               title:@"ContactsTab"];
    
    if (IOS_10_LATER) {
    [self addChildVC:WALLET.activeAccount ? [FFAccountViewController vc] : [FFWalletVC vc]
                 img:[UIImage imageNamed:@"tabbar_wallet_icon"]
         selectedImg:[UIImage imageNamed:@"tabbar_wallet_selected_icon"]
               title:@"WalletTab"];
    }
    
    [self addChildVC:[FFNearbyVC vc]
                 img:[UIImage imageNamed:@"tabbar_discover_icon"]
         selectedImg:[UIImage imageNamed:@"tabbar_discover_selected_icon"]
               title:@"DiscoverTab"];
    
    [self addChildVC:[FFMeVC vc]
                 img:[UIImage imageNamed:@"tabbar_user_icon"]
         selectedImg:[UIImage imageNamed:@"tabbar_user_selected_icon"]
               title:@"MeTab"];
}

- (void)addChildVC:(UIViewController *)vc img:(UIImage *)img selectedImg:(UIImage *)selectedImg title:(NSString *)title {
    vc.tabBarItem.title = DDYLocalStr(title);
    vc.tabBarItem.image = [img imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.selectedImage = [selectedImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self addChildViewController:[[FFNavigationController alloc] initWithRootViewController:vc]];
}

#pragma mark - 控制旋转屏幕
#pragma mark 支持旋转的方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return [self.selectedViewController supportedInterfaceOrientations];
}
#pragma mark 是否支持自动旋转
- (BOOL)shouldAutorotate {
    return [self.selectedViewController shouldAutorotate];
}
#pragma mark 状态栏样式
- (UIStatusBarStyle)preferredStatusBarStyle {
    return [self.selectedViewController preferredStatusBarStyle];
}

@end
