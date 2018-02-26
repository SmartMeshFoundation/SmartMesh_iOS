//
//  FFWalletBackupAlert.h
//  FireFly
//
//  Created by Rain on 18/1/17.
//  Copyright © 2018年 SmartMesh Foundation All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FFWalletBackupAlert : UIView

@property (nonatomic, copy) void (^backupBlock)();

+ (instancetype)alertView;

- (void)showOnWindow;

@end
