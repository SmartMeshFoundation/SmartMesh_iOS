//
//  FFUserPeer.h
//  SmartMesh
//
//  Created by Rain on 15/9/11.
//  Copyright © 2017年 SmartMesh Foundation All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FFUserPeer : NSObject

@property (nonatomic, strong) NSString *nickName;

@property (nonatomic, strong) NSString *peerID;

@property (nonatomic, strong) UIImage *avatarImg;

@property (nonatomic, strong) NSString *avatarPath;

@property (nonatomic, strong) NSString *sex;

@property (nonatomic, strong) NSString *age;

@property (nonatomic, strong) NSString *timeStamp;

@property (nonatomic, strong) NSMutableDictionary *userInfo;

+ (id)userWithDict:(NSDictionary *)dict;

@end
