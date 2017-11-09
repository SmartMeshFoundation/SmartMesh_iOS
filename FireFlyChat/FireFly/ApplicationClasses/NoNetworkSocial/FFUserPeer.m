//
//  FFUserPeer.m
//  SmartMesh
//
//  Created by Rain on 15/9/11.
//  Copyright © 2017年 SmartMesh Foundation All rights reserved.
//

#import "FFUserPeer.h"

@implementation FFUserPeer

- (NSMutableDictionary *)userInfo {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"nickName"] = self.nickName;
    dict[@"peerID"] = self.peerID;
    dict[@"avatarPath"] = self.avatarPath;
    dict[@"sex"] = self.sex;
    dict[@"age"] = self.age;
    dict[@"timeStamp"] = self.timeStamp;
    return dict;
}

+ (id)userWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

- (id)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        self.nickName = dict[@"nickName"];
        self.peerID = dict[@"peerID"];
        self.avatarPath = dict[@"avatarPath"];
        self.sex = dict[@"sex"];
        self.age = dict[@"age"];
    }
    return self;
}

@end
