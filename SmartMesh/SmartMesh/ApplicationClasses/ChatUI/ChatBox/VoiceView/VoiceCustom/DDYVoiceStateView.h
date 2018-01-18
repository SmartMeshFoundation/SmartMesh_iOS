//
//  DDYVoiceStateView.h
//  DDYProject
//
//  Created by LingTuan on 17/11/23.
//  Copyright © 2017年 Starain. All rights reserved.
//

#import <UIKit/UIKit.h>

#define DDYRecordMax 60

typedef NS_ENUM(NSInteger, DDYVoiceState) {
    DDYVoiceStateDefault = 0,       // 按住说话
    DDYVoiceStateClickRecord,       // 点击录音
    DDYVoiceStateTouchChangeVoice,  // 按住变声
    DDYVoiceStateListen ,           // 试听
    DDYVoiceStateCancel,            // 取消
    DDYVoiceStateSend,              // 发送
    DDYVoiceStatePrepare,           // 准备中
    DDYVoiceStateRecording,         // 录音中
    DDYVoiceStatePreparePlay,       // 准备播放
    DDYVoiceStatePlay               // 播放
};

@interface DDYVoiceStateView : UIView

@property (nonatomic, assign) DDYVoiceState voiceState;

@property (nonatomic, copy) void(^playProgress)(CGFloat progress);

@property (nonatomic, copy) void(^overTimeBlock)();

/** 初始化 */
+ (instancetype)viewWithFrame:(CGRect)frame;

/** 开始录音 */
- (void)startRecord;
/** 结束录音 */
- (void)endRecord;

@end
