//
//  DDYVoiceChangeView.m
//  DDYProject
//
//  Created by LingTuan on 17/11/23.
//  Copyright © 2017年 Starain. All rights reserved.
//

#import "DDYVoiceChangeView.h"
#import "DDYVoiceStateView.h"
#import "DDYRecordModel.h"

@interface DDYVoiceChangeView ()<DDYAudioManagerDelegate>
/** 状态与振幅 */
@property (nonatomic, strong) DDYVoiceStateView *stateView;
/** 录音按钮 */
@property (nonatomic, strong) DDYButton *recordBtn;

@end

@implementation DDYVoiceChangeView

+ (instancetype)viewWithFrame:(CGRect)frame {
    return [[self alloc] initWithFrame:frame];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.stateView];
        [self addSubview:self.recordBtn];
    }
    return self;
}

#pragma mark 状态显示
- (DDYVoiceStateView *)stateView {
    if (!_stateView) {
        _stateView = [DDYVoiceStateView viewWithFrame:DDYRect(0, 10, self.ddy_w, 50)];
    }
    return _stateView;
}

#pragma mark 录音按钮
- (DDYButton *)recordBtn {
    if (!_recordBtn) {
        _recordBtn = DDYButtonNew.btnImageN(voiceImg(@"ChangeRecord")).btnFrame(0,self.stateView.ddy_bottom,107,107);
        _recordBtn.ddy_centerX = self.ddy_w/2.;
        [_recordBtn addTarget:self action:@selector(startRecorde:) forControlEvents:UIControlEventTouchDown];
        [_recordBtn addTarget:self action:@selector(endRecord:) forControlEvents:UIControlEventTouchUpInside];
        [_recordBtn addTarget:self action:@selector(endRecord:) forControlEvents:UIControlEventTouchUpOutside];
    }
    return _recordBtn;
}

#pragma mark 开始录音
- (void)startRecorde:(DDYButton *)sender {
    [DDYAudioManager sharedManager].delegate = self;
    if (self.changeVoiceBoxState) self.changeVoiceBoxState(DDYVoiceBoxStateRecord);
    [UIView animateWithDuration:0.1 animations:^{
        self.recordBtn.transform = CGAffineTransformMakeScale(1.1, 1.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.05 animations:^{
            self.recordBtn.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [[DDYAudioManager sharedManager] ddy_StartRecordAtPath:[DDYFileTool ddy_RecordPath]];
        }];
    }];
}

#pragma mark 结束录音
- (void)endRecord:(DDYButton *)sender {
    NSTimeInterval t = [DDYAudioManager sharedManager].isRecording ? 0 : 0.3;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(t * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.stateView.voiceState = DDYVoiceStateTouchChangeVoice;
        [[DDYAudioManager sharedManager] ddy_StopRecord];
        [self.stateView endRecord];
        // 设置状态 显示小圆点和三个标签
        if (self.changeVoiceBoxState) self.changeVoiceBoxState(DDYVoiceBoxStateDefault);
        t == 0 ? NSLog(@"跳转到变声界面") : NSLog(@"录音时间太短");
    });
}

#pragma mark DDYAudioManagerDelegate 录音状态 -1出错 0准备 1录音中
- (void)ddy_AudioRecordState:(NSInteger)state {
    if (state == -1) {
        self.stateView.voiceState = DDYVoiceStateTouchChangeVoice;
    } else if (state == 0) {
        self.stateView.voiceState = DDYVoiceStatePrepare;
    } else if (state == 1) {
        self.stateView.voiceState = DDYVoiceStateRecording;
        [self.stateView startRecord];
    }
}

@end
