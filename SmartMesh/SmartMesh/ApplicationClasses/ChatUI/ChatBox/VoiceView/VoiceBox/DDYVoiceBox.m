//
//  DDYVoiceBox.m
//  DDYProject
//
//  Created by LingTuan on 17/11/22.
//  Copyright © 2017年 Starain. All rights reserved.
//

#import "DDYVoiceBox.h"
#import "DDYVoiceChangeView.h"
#import "DDYVoiceTalkView.h"
#import "DDYVoiceRecordView.h"
#import "DDYVoiceBottomView.h"
#import "DDYRecordModel.h"
#import "DDYVoicePlayView.h"

@interface DDYVoiceBox ()<UIScrollViewDelegate>
/** 滚动容器 */
@property (nonatomic, strong) UIScrollView *contentScrollView;
/** 变声视图 */
@property (nonatomic, strong) DDYVoiceChangeView *voiceChangeView;
/** 对讲视图 */
@property (nonatomic, strong) DDYVoiceTalkView  *voiceTalkView;
/** 录音视图 */
@property (nonatomic, strong) DDYVoiceRecordView *voiceRecordView;
/** 标签视图 */
@property (nonatomic, strong) DDYVoiceBottomView *voiceBottomView;
/** 播放界面 */
@property (nonatomic, strong) DDYVoicePlayView *playView;

@end

@implementation DDYVoiceBox

+ (instancetype)voiceBox {
    return [[self alloc] initWithFrame:CGRectMake(0, 0, DDYSCREENW, FFChatBoxFunctionViewH)];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        __weak __typeof__ (self)weakSelf = self;
        // 滚动容器
        _contentScrollView = [[UIScrollView alloc] initWithFrame:DDYRect(0, 0, self.ddy_w, self.ddy_h)];
        _contentScrollView.pagingEnabled = YES;
        _contentScrollView.contentSize = CGSizeMake(self.ddy_w*3, self.ddy_h);
        _contentScrollView.showsHorizontalScrollIndicator = NO;
        _contentScrollView.delegate = self;
//        [self addSubview:_contentScrollView];
        // 变声视图
        _voiceChangeView = [DDYVoiceChangeView viewWithFrame:DDYRect(0, 0, self.ddy_w, self.ddy_h)];
//        [_contentScrollView addSubview:_voiceChangeView];
        // 对讲视图
        _voiceTalkView = [DDYVoiceTalkView viewWithFrame:DDYRect(0, 0, self.ddy_w, self.ddy_h)];
        _voiceTalkView.talkPlayBlock = ^() { [weakSelf setupPlayView]; };
        _voiceTalkView.talkSendBlock = ^() { [weakSelf handleSend]; };
//        [_contentScrollView addSubview:_voiceTalkView];
        [self addSubview:_voiceTalkView];
        // 录音视图
        _voiceRecordView = [DDYVoiceRecordView viewWithFrame:DDYRect(self.ddy_w*2, 0, self.ddy_w, self.ddy_h)];
//        [_contentScrollView addSubview:_voiceRecordView];
        // 标签指示
        _voiceBottomView = [DDYVoiceBottomView viewWithFrame:DDYRect(0, self.ddy_h-55, self.ddy_w, 55)];
//        [self addSubview:_voiceBottomView];
        // 选中对讲
        _contentScrollView.contentOffset = CGPointMake(self.ddy_w, 0);
    }
    return self;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_voiceBottomView contentOffsetX:scrollView.contentOffset.x-scrollView.ddy_w];
    [_voiceBottomView scrollToIndex:(scrollView.contentOffset.x +  scrollView.ddy_w/2) / scrollView.ddy_w];
}

- (void)setState:(DDYVoiceBoxState)state {
    _state = state;
    self.voiceBottomView.hidden = state!=DDYVoiceBoxStateDefault;
    self.contentScrollView.scrollEnabled = state==DDYVoiceBoxStateDefault;
}

#pragma mark 播放视图
- (void)setupPlayView {
    _playView = nil;
    _playView = [DDYVoicePlayView viewWithFrame:self.bounds];
    __weak __typeof__ (self)weakSelf = self;
    _playView.changeVoiceBoxState = ^(DDYVoiceBoxState state) { weakSelf.state = state; };
    _playView.playSendBlock = ^() {[weakSelf handleSend]; };
    [self addSubview:_playView];
    DDYInfoLog(@"111111:%ld",(long)[DDYRecordModel shareInstance].duration);
}

#pragma mark 发送
- (void)handleSend {
    if (self.recordFinish) {
        self.recordFinish([DDYRecordModel shareInstance].path, [DDYRecordModel shareInstance].duration);
    }
}

@end
