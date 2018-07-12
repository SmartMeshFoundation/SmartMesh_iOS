//
//  NAAccountHeader.h
//  SmartMesh
//
//  Created by Rain on 15/9/11.
//  Copyright © 2017年 SmartMesh Foundation All rights reserved.

#import <UIKit/UIKit.h>

@interface NAAccountHeader : UIView

@property (nonatomic, copy) void (^accountBlock)(Address *address);

@property (nonatomic, copy) void (^qrCodeBlock)(void);

@property (nonatomic, copy) void (^transactionBlock)(void);

@property (nonatomic, strong) Address *address;

+ (instancetype)headView:(CGRect)frame;

@end
