//
//  DDYAudioManager.h
//  DDYProject
//
//  Created by LingTuan on 17/9/28.
//  Copyright © 2017年 Starain. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const pathExt_WAV = @"wav";
static NSString *const pathExt_AMR = @"amr";
static NSString *const pathExt_CAF = @"caf";
static NSString *const pathExt_MP3 = @"mp3";

@protocol DDYAudioManagerDelegate <NSObject>

/** 声音播放完成 */
- (void)audioPlayDidFinish;

@end

@interface DDYAudioManager : NSObject

/** 单例对象 */
+ (instancetype)sharedManager;

/** 录音设置 */
@property (nonatomic, strong) NSDictionary *recordSetting;
/** 开始录音 */
- (void)ddy_StartRecordAtPath:(NSString *)path;
/** 结束录音 */
- (void)ddy_StopRecord;

/** 播放代理 */
@property (nonatomic, weak) id <DDYAudioManagerDelegate>delegate;
/** 播放模式 */
@property (nonatomic, strong) NSString *audioCategory;
/** 播放音量 0-1 */
@property (nonatomic, assign) CGFloat volume;
/** 播放本地音频 */
- (void)ddy_PlayAudio:(NSString *)path;
/** 暂停播放 */
- (void)ddy_PauseAudio;
/** 恢复播放 */
- (void)ddy_ReplayAudio;

@end
