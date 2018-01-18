//
//  DDYRecordModel.h
//  DDYProject
//
//  Created by LingTuan on 17/11/23.
//  Copyright © 2017年 Starain. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef FFChatBoxFunctionViewH
#define FFChatBoxFunctionViewH 253
#endif

#define kSelectColor DDYRGBA(80, 180, 230, 1)
#define kNormalColor DDYRGBA(120, 120, 120, 1)

static UIImage* voiceImg(NSString *imgName) { return [UIImage imageNamed:DDYStrFormat(@"DDYVoice.bundle/%@",imgName)];}

@interface DDYRecordModel : NSObject

@property (nonatomic, strong) NSString *tmpPath;

@property (nonatomic, strong) NSString *path;

@property (nonatomic, strong) NSArray *levels;

@property (nonatomic, assign) NSInteger duration;

/** 单例对象 */
+ (instancetype)shareInstance;

@end
