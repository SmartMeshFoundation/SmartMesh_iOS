//
//  DDYVoiceChangePlayCell.m
//  DDYProject
//
//  Created by LingTuan on 17/11/27.
//  Copyright © 2017年 Starain. All rights reserved.
//

#import "DDYVoiceChangePlayCell.h"
#import "DDYRecordModel.h"

static CGFloat const levelWidth = 3.0;
static CGFloat const levelMargin = 2.0;

//------------------------------- 模型 -------------------------------//
@implementation DDYVoiceChangeModel

+ (id)modelWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

- (id)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        self.title = dict[@"title"];
        self.pitch = dict[@"pitch"];
    }
    return self;
}

@end

//------------------------------- cell -------------------------------//
@interface DDYVoiceChangePlayCell ()
/** 播放时振幅计时器 */
@property (nonatomic, strong) CADisplayLink *playTimer;
/** 头像播放按钮 */
@property (nonatomic, strong) DDYButton *playButton;
/** 底部标签按钮 */
@property (nonatomic, strong) DDYButton *titleButton;
/** 当前振幅数组 */
@property (nonatomic, strong) NSMutableArray *currentLevels;
/** 振幅图层 */
@property (nonatomic, strong) CAShapeLayer *levelLayer;
/** 振幅path */
@property (nonatomic, strong) UIBezierPath *levelPath;
/** 录音时长标签 */
@property (nonatomic, strong) UILabel *timeLabel;
/** 环形进度条 */
@property (nonatomic, strong) CAShapeLayer *circleLayer;
/** 录音播放计时器 */
@property (nonatomic, strong) NSTimer *audioTimer;
/** 录音时长 */
@property (nonatomic, assign) NSInteger duration;

@end

@implementation DDYVoiceChangePlayCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:DDY_White];
        [self addSubview:self.playButton];
    }
    return self;
}

#pragma mark 振幅数组
- (NSMutableArray *)currentLevels {
    if (!_currentLevels) {
        _currentLevels = [NSMutableArray arrayWithArray:@[@0.05,@0.05,@0.05,@0.05,@0.05,@0.05]];
    }
    return _currentLevels;
}

- (DDYButton *)playButton {
    if (!_playButton) {
        _playButton = DDYButtonNew.btnImageS(voiceImg(@"effectS")).btnImageH(voiceImg(@"effectP")).btnFrame(0,0,60,60).btnAction(self,@selector(playAudio));
        [_playButton setImage:nil forState:UIControlStateNormal];
        _playButton.center = CGPointMake(self.ddy_w/2, self.ddy_h/2 - 10);
    }
    return _playButton;
}

- (DDYButton *)titleButton {
    if (!_titleButton) {
        UIImage *image = [UIImage imageNamed:@"DDYVoice.bundle/textSelect"];
        _titleButton = DDYButtonNew.btnImageS(voiceImg(@""));
    }
    return _titleButton;
}

- (void)startAudioTimer {
    if (_audioTimer) [_audioTimer invalidate];
    self.audioTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(addSeconded) userInfo:nil repeats:YES];
}

- (void)addSeconded {
    if (_duration == [DDYRecordModel shareInstance].duration) {
        [_audioTimer invalidate];
    } else {
        _duration++;
        [self updateTimeLabel];
    }
}

#pragma mark 事件响应
- (void)playAudio {
    self.titleButton.selected = !self.titleButton.selected;
    self.playButton.selected = !self.playButton.selected;
    __weak __typeof__ (self)weakSelf = self;
    if (self.playButton.selected) {
        if (self.startPlayBlock) self.startPlayBlock(weakSelf);
    } else {
        if (self.endPlayBlock) self.endPlayBlock(weakSelf);
    }
}

#pragma mark 准备播放


#pragma mark 更新时间
- (void)updateTimeLabel {
    self.timeLabel.text = _duration<60 ? DDYStrFormat(@"0:%02zd",_duration) : DDYStrFormat(@"%zd:%02zd",_duration/60, _duration%60);
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


#pragma mark 圆弧进度
- (void)updateCircleLayer {
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGFloat width = CGRectGetWidth(self.circleLayer.frame);
    CGFloat startAngle = -M_PI_2;
    CGFloat endAngle = [DDYAudioManager sharedManager].palyProgress*M_PI*2 + startAngle;
    [path addArcWithCenter:CGPointMake(width/2, width/2) radius:width/2 startAngle:startAngle endAngle:endAngle clockwise:YES];
    self.circleLayer.path = path.CGPath;
}

@end
