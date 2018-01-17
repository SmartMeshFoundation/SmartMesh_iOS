//
//  FFAppDelegate.h
//  SmartMesh
//
//  Created by RainDou on 18/1/16.
//  Copyright © 2015年 RainDou All rights reserved.
//

#import <UIKit/UIKit.h>

//#import <Geth/Geth.h>

@class GethEthereumClient;

@interface FFAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) Wallet   *wallet;
@property (nonatomic, strong) GethEthereumClient *ethereumClient;


- (void)startNode:(NSInteger)state;

+ (UIViewController *)rootViewController;

@end

