//
//  FFUpdateAlert.h
//  SmartMesh
//
//  Created by RainDou on 18/1/16.
//  Copyright © 2015年 RainDou All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FFUpdateAlert : UIView

@property (nonatomic, copy) void (^updateBlock)();

+ (instancetype)alertView;

- (void)show:(NSString *)title msg:(NSString *)msg coerce:(BOOL)coerce;

@end
