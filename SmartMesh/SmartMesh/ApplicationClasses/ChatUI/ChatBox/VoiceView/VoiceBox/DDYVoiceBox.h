//
//  DDYVoiceBox.h
//  DDYProject
//
//  Created by LingTuan on 17/11/22.
//  Copyright © 2017年 Starain. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM (NSInteger, DDYVoiceBoxState) {
    DDYVoiceBoxStateDefault = 0, // 默认状态
    DDYVoiceBoxStateRecord,      // 录音
    DDYVoiceBoxStatePlay         // 播放
};

@interface DDYVoiceBox : UIView

@property (nonatomic, copy) void (^recordFinish) (NSString *path, NSInteger second);

@property (nonatomic,assign) DDYVoiceBoxState state;

+ (instancetype)voiceBox;

@end
