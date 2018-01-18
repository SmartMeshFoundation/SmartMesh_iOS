//
//  DDYVoicePlayView.m
//  DDYProject
//
//  Created by LingTuan on 17/11/23.
//  Copyright © 2017年 Starain. All rights reserved.
//

#import "DDYVoicePlayView.h"
#import "DDYVoiceStateView.h"
#import "DDYRecordModel.h"
#import "DDYVoiceBox.h"

static inline UIImage* strectchImg(NSString *imgName) { return [[UIImage imageNamed:DDYStrFormat(@"DDYVoice.bundle/%@",imgName)] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 1, 1)];}

@interface DDYVoicePlayView ()<DDYAudioManagerDelegate>
/** 状态视图 */
@property (nonatomic, strong) DDYVoiceStateView *stateView;
/** 播放按钮 */
@property (nonatomic, strong) DDYButton *playBtn;
/** 取消按钮 */
@property (nonatomic, strong) DDYButton *cancelBtn;
/** 发送按钮 */
@property (nonatomic, strong) DDYButton *sendBtn;

@end

@implementation DDYVoicePlayView

+ (instancetype)viewWithFrame:(CGRect)frame {
    return [[self alloc] initWithFrame:frame];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = FFBackColor;
        [self addSubview:self.stateView];
        [self addSubview:self.playBtn];
        [self setupSendBtnAndCancelBtn];
        [self listerProgress];
    }
    return self;
}

- (DDYVoiceStateView *)stateView {
    if (!_stateView) {
        _stateView = [DDYVoiceStateView viewWithFrame:DDYRect(0, 10, self.ddy_w, 50)];
        _stateView.voiceState = DDYVoiceStatePreparePlay;
    }
    return _stateView;
}

- (DDYButton *)playBtn {
    if (!_playBtn) {
        _playBtn = DDYButtonNew;
        _playBtn.btnImageN(voiceImg(@"PlayBtnN")).btnImageH(voiceImg(@"PlayBtnH")).btnImageS(voiceImg(@"PlayBtnN")).btnFrame(0,0,107,107).btnAction(self,@selector(playRecord));
        _playBtn.center = CGPointMake(self.ddy_centerX, self.stateView.ddy_bottom+107/2);
    }
    return _playBtn;
}

- (void)setupSendBtnAndCancelBtn {
    _cancelBtn = DDYButtonNew.btnFrame(0,self.ddy_h-40,self.ddy_w/2,40).btnTitleN(DDYLocalStr(@"Cancel")).btnTitleColorN(kSelectColor).btnFont(DDYFont(17));
    _cancelBtn.btnSuperView(self).btnAction(self,@selector(btnClick:)).btnBgImageN(strectchImg(@"PlayCancelN")).btnBgImageH(strectchImg(@"PlayCancelH"));
    
    _sendBtn = DDYButtonNew.btnFrame(self.ddy_w/2,self.ddy_h-40,self.ddy_w/2,40).btnTitleN(DDYLocalStr(@"Send")).btnTitleColorN(kSelectColor).btnFont(DDYFont(17));
    _sendBtn.btnSuperView(self).btnAction(self,@selector(btnClick:)).btnBgImageN(strectchImg(@"PlaySendN")).btnImageH(strectchImg(@"PlaySendH"));
}

- (void)btnClick:(DDYButton *)sender {
    [self stopPlay];
    if (sender == _sendBtn) {
        if (self.playSendBlock) self.playSendBlock();
    } else {
        [[DDYAudioManager sharedManager] ddy_DeleteRecord];
    }
    if (self.changeVoiceBoxState) self.changeVoiceBoxState(DDYVoiceBoxStateDefault);
    [self removeFromSuperview];
}

- (void)playRecord {
    self.playBtn.selected = !self.playBtn.selected;
    if (self.playBtn.selected) {
        [DDYAudioManager sharedManager].delegate = self;
        self.stateView.voiceState = DDYVoiceStatePlay;
        [[DDYAudioManager sharedManager] ddy_PlayAudio:[DDYRecordModel shareInstance].path];
    } else {
        [self stopPlay];
    }
}

- (void)stopPlay {
    self.playBtn.selected = NO;
    self.stateView.voiceState = DDYVoiceStatePreparePlay;
    [[DDYAudioManager sharedManager] ddy_StopAudio];
    _progressValue = 0;
    [self setNeedsDisplay];
    [self layoutIfNeeded];
}

#pragma mark DDYAudioManagerDelegate 声音播放完成
- (void)ddy_AudioPlayDidFinish {
    [self stopPlay];
}

#pragma mark 环形进度条
- (void)listerProgress {
    __weak __typeof__ (self)weakSelf = self;
    self.stateView.playProgress = ^(CGFloat progress) {
        weakSelf.progressValue = progress;
        [weakSelf setNeedsDisplay];
        [weakSelf layoutIfNeeded];
    };
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    UIImage *image = voiceImg(@"TalkRecordN");
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctx, 2.0f);
    CGContextSetStrokeColorWithColor(ctx, [DDYRGBA(214, 219, 222, 1.0) CGColor]);
    CGContextAddArc(ctx, self.center.x, self.stateView.ddy_bottom + image.size.width / 2, image.size.width / 2, 0, M_PI * 2, 0);
    CGContextStrokePath(ctx);
    
    CGContextSetStrokeColorWithColor(ctx, [kSelectColor CGColor]);
    CGFloat startAngle = -M_PI_2;
    CGFloat angle = self.progressValue * M_PI * 2;
    CGFloat endAngle = startAngle + angle;
    CGContextAddArc(ctx, self.center.x, self.stateView.ddy_bottom + image.size.width/2, image.size.width/2, startAngle, endAngle, 0);
    CGContextStrokePath(ctx);
}

@end
