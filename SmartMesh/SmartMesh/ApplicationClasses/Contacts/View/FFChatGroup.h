//
//  NAChatGroup.h
//  NextApp
//
//  Created by Megan on  17-12-12.
//  Copyright (c) 2017年 SmartMesh Foundation All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FFChatGroup : NSObject

@property(nonatomic,copy)   NSString * groupid;
@property(nonatomic,copy)   NSString * groupName;
@property(nonatomic,copy)   NSMutableArray * groupMember;
@property(nonatomic,assign) BOOL isOwner;
@property(nonatomic,assign) NSInteger groupMask;
@property(nonatomic,copy)   NSString * memberInfo;
@property(nonatomic,copy)   NSString * tag;
@property(nonatomic,copy)   NSString * fromSource;
@property(nonatomic,copy)   NSString * sourceName;
@property(nonatomic,copy)   NSString * groupHeadIcon;

@end
