//
//  NAUserModel.h
//  SmartMesh
//
//  Created by Rain on 15/9/11.
//  Copyright © 2017年 SmartMesh Foundation All rights reserved.

#import <Foundation/Foundation.h>

@interface NAUserModel : NSObject

@property (nonatomic, strong) NSString *u_address;

@property (nonatomic, strong) NSString *u_tip;

- (id)initWithAddress:(NSString *)u_address tip:(NSString *)u_tip;

@end
