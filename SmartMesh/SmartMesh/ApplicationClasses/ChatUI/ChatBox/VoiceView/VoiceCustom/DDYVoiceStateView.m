//
//  DDYVoiceStateView.m
//  DDYProject
//
//  Created by LingTuan on 17/11/23.
//  Copyright © 2017年 Starain. All rights reserved.
//

#import "DDYVoiceStateView.h"
#import "DDYRecordModel.h"

static CGFloat const levelWidth = 3.0;
static CGFloat const levelMargin = 2.0;

@interface DDYVoiceStateView ()
/** 按住说话标签 */
@property (nonatomic, strong) UILabel *titleLabel;
/** 指示器 */
@property (nonatomic, strong) UIActivityIndicatorView *activityView;

/** 振幅界面载体 */
@property (nonatomic, strong) UIView *contentView;
/** 录音时长标签 */
@property (nonatomic, strong) UILabel *timeLabel;
/** 对称复制图层 */
@property (nonatomic, strong) CAReplicatorLayer *replicatorLayer;
/** 条状振幅波形 */
@property (nonatomic, strong) CAShapeLayer *levelLayer;
/** 当前振幅数组 */
@property (nonatomic, strong) NSMutableArray *currentLevels;
/** 振幅路径 */
@property (nonatomic, strong) UIBezierPath *levelPath;
/** 录音播放计时器 */
@property (nonatomic, strong) NSTimer *audioTimer;
/** 振幅计时器 */
@property (nonatomic, strong) CADisplayLink *levelTimer;
/** 录音时长 */
@property (nonatomic, assign) NSInteger duration;
/** 播放时振幅计时器 */
@property (nonatomic, strong) CADisplayLink *playTimer;

@end

@implementation DDYVoiceStateView

+ (instancetype)viewWithFrame:(CGRect)frame {
    return [[self alloc] initWithFrame:frame];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.titleLabel];
        [self addSubview:self.activityView];
        [self updateTitleLabelWithTitle:DDYLocalStr(@"ChatBoxVoiceTalk")];
        [self addSubview:self.contentView];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView.layer addSublayer:self.replicatorLayer];
        [self.replicatorLayer addSublayer:self.levelLayer];
    }
    return self;
}

- (NSMutableArray *)currentLevels {
    if (!_currentLevels) {
        _currentLevels = [NSMutableArray arrayWithArray:@[@0.05,@0.05,@0.05,@0.05,@0.05,@0.05,@0.05,@0.05,@0.05,@0.05]];
    }
    return _currentLevels;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = UIViewNew.viewHidden(YES).viewSetFrame(0,0,self.ddy_w,self.ddy_h);
    }
    return _contentView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = UILabelNew.labAlignmentCenter().labTextColor(DDYRGBA(120, 120, 120, 1));
    }
    return _titleLabel;
}

- (UIActivityIndicatorView *)activityView {
    if (!_activityView) {
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityView.hidesWhenStopped = YES;
    }
    return _activityView;
}

- (CAReplicatorLayer *)replicatorLayer {
    if (!_replicatorLayer) {
        _replicatorLayer = [CAReplicatorLayer layer];
        _replicatorLayer.frame = self.layer.bounds;
        _replicatorLayer.instanceCount = 2;
        _replicatorLayer.instanceTransform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
    }
    return _replicatorLayer;
}

- (CAShapeLayer *)levelLayer {
    if (!_levelLayer) {
        _levelLayer = CAShapeLayerNew.sharpLayerSetStrokeColor(DDYRGBA(250, 99, 9, 1)).sharpLayerSetLineWidth(levelWidth);
        _levelLayer.frame = DDYRect(self.timeLabel.ddy_right, 10, self.ddy_w/2.-30, self.ddy_h-20);
    }
    return _levelLayer;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = UILabelNew.labText(@"0:00").labAlignmentCenter().labFont(DDYFont(17)).labTextColor(DDYRGBA(120, 120, 120, 1));
        _timeLabel.frame = DDYRect(0, 0, 50, self.ddy_h);
        _timeLabel.center = self.contentView.center;
    }
    return _timeLabel;
}

- (void)updateTitleLabelWithTitle:(NSString *)title {
    self.titleLabel.text = title;
    self.titleLabel.hidden = NO;
    [self.titleLabel sizeToFit];
    self.titleLabel.center = CGPointMake(self.ddy_w/2, self.ddy_h/2);
    self.activityView.ddy_right = self.titleLabel.ddy_x-5;
    self.activityView.ddy_centerY = self.titleLabel.ddy_centerY;
    self.activityView.transform = CGAffineTransformMakeScale(0.8, 0.8);
}

- (void)startRecordMeterTimer {
    [_levelTimer invalidate];
    _levelTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateRecordMeter)];
    if ([[UIDevice currentDevice].systemVersion floatValue] > 10.0) {
        _levelTimer.preferredFramesPerSecond = 10;
    } else {
        _levelTimer.frameInterval = 6;
    }
    [_levelTimer addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)updateRecordMeter {
    CGFloat level = [[DDYAudioManager sharedManager] ddy_RecordLevels];
    [self.currentLevels removeLastObject];
    [self.currentLevels insertObject:@(level) atIndex:0];
    [self updateLevelLayer];
}

- (void)startAudioTimer {
    if (_audioTimer) [_audioTimer invalidate];
    if (_voiceState != DDYVoiceStatePlay) _duration = 0;
    self.audioTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(addSeconded) userInfo:nil repeats:YES];
}

- (void)addSeconded {
    if (_voiceState==DDYVoiceStatePlay && _duration==[DDYRecordModel shareInstance].duration) {
        [_audioTimer invalidate];
    } else {
        _duration++;
        [self updateTimeLabel];
        if (_duration >= DDYRecordMax) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.overTimeBlock) self.overTimeBlock();
            });
        }
    }
}

- (void)updateTimeLabel {
    self.timeLabel.text = _duration<60 ? DDYStrFormat(@"0:%02zd",_duration) : DDYStrFormat(@"%zd:%02zd",_duration/60, _duration%60);
}

#pragma mark - setter
- (void)setVoiceState:(DDYVoiceState)voiceState {
    _voiceState = voiceState;
    _contentView.hidden = YES;
    [_activityView stopAnimating];
    switch (voiceState) {
        case DDYVoiceStateDefault:
            [self updateTitleLabelWithTitle:DDYLocalStr(@"ChatBoxVoiceTalk")];
            break;
        case DDYVoiceStateClickRecord:
            [self updateTitleLabelWithTitle:DDYLocalStr(@"ChatBoxVoiceRecord")];
            break;
        case DDYVoiceStateTouchChangeVoice:
             [self updateTitleLabelWithTitle:DDYLocalStr(@"ChatBoxVoiceChange")];
            break;
        case DDYVoiceStateListen:
             [self updateTitleLabelWithTitle:DDYLocalStr(@"ChatBoxVoiceListen")];
            break;
        case DDYVoiceStateCancel:
             [self updateTitleLabelWithTitle:DDYLocalStr(@"ChatBoxVoiceCancel")];
            break;
        case DDYVoiceStateSend:
            break;
        case DDYVoiceStatePrepare:
             [self updateTitleLabelWithTitle:DDYLocalStr(@"ChatBoxVoicePrepare")];
            [self.activityView startAnimating];
            self.timeLabel.text = @"00:00";
            break;
        case DDYVoiceStateRecording:
            self.titleLabel.hidden = YES;
            self.contentView.hidden = NO;
            break;
        case DDYVoiceStatePlay:
             self.titleLabel.hidden = YES;
            self.contentView.hidden = NO;
            [self playAndMetering];
            break;
        case DDYVoiceStatePreparePlay:
            self.titleLabel.hidden = YES;
            self.contentView.hidden = NO;
            [self preparePlay];
            break;
        default:
            break;
    }
}

#pragma mark 开始录音
- (void)startRecord {
    self.contentView.hidden = NO;
    self.currentLevels = nil;
    [self startRecordMeterTimer];
    [self startAudioTimer];
}

#pragma mark 结束录音
- (void)endRecord {
    [DDYRecordModel shareInstance].path = [DDYRecordModel shareInstance].tmpPath;
    [DDYRecordModel shareInstance].duration = (NSTimeInterval)_duration;
    [self updateTimeLabel];
    [_levelTimer invalidate];
    [self.audioTimer invalidate];
    self.currentLevels = nil;
    self.contentView.hidden = YES;
    _duration = 0;
}

#pragma mark 准备播放
- (void)preparePlay {
    [self.playTimer invalidate];
    [self.audioTimer invalidate];
    self.currentLevels = nil;
    _duration = [DDYRecordModel shareInstance].duration;
    [self updateLevelLayer];
    [self updateTimeLabel];
}

#pragma mark 播放录音
- (void)playAndMetering {
    [self preparePlay];
    _duration = 0;
    [self updateTimeLabel];
    [self startPlayTimer];
    [self startAudioTimer];
}

- (void)startPlayTimer {
    [_playTimer invalidate];
    _playTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(updatePlayMeter)];
    if ([[UIDevice currentDevice].systemVersion floatValue] > 10.0) {
        self.playTimer.preferredFramesPerSecond = 10;
    } else {
        self.playTimer.frameInterval = 6;
    }
    [self.playTimer addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)updatePlayMeter {
    if (_playProgress) {
        _playProgress([DDYAudioManager sharedManager].palyProgress);
    }
    CGFloat level = [[DDYAudioManager sharedManager] ddy_PlayLevels];
    [self.currentLevels removeLastObject];
    [self.currentLevels insertObject:@(level) atIndex:0];
    [self updateLevelLayer];
}


#pragma mark 振幅UI
- (void)updateLevelLayer {
    _levelPath = [UIBezierPath bezierPath];
    CGFloat height = CGRectGetHeight(self.levelLayer.frame);
    for (int i=0; i<self.currentLevels.count; i++) {
        CGFloat x = i*(levelWidth + levelMargin) + 5;
        CGFloat pathH = [self.currentLevels[i] floatValue] * height;
        CGFloat startY = height/2. - pathH/2.;
        CGFloat endY = height/2. + pathH/2.;
        [_levelPath moveToPoint:CGPointMake(x, startY)];
        [_levelPath addLineToPoint:CGPointMake(x, endY)];
    }
    self.levelLayer.path = _levelPath.CGPath;
}

@end
