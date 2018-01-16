//
//  FFTabBar.h
//  SmartMesh
//
//  Created by RainDou on 18/1/16.
//  Copyright © 2015年 RainDou All rights reserved.
//

#import <UIKit/UIKit.h>

@class FFTabBar;

@protocol FFTabBarDelegate <NSObject, UITabBarDelegate>

@optional

- (void)tabBarDidPlusBtn:(FFTabBar *)tabBar;

@end

@interface FFTabBar : UITabBar

@property (nonatomic, weak) id<FFTabBarDelegate> delegate;

@end
