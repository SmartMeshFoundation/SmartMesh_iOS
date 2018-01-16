//
//  FFUpdateAlert.m
//  SmartMesh
//
//  Created by RainDou on 18/1/16.
//  Copyright © 2015年 RainDou All rights reserved.
//


#import "FFUpdateAlert.h"

@interface FFUpdateAlert ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIImageView *titleImgView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *messageLabel;

@property (nonatomic, strong) DDYButton *cancelBtn;

@property (nonatomic, strong) DDYButton *okBtn;

@end

@implementation FFUpdateAlert

+ (instancetype)alertView {
    return [[self alloc] initWithFrame:[UIScreen mainScreen].bounds];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupContentView];
    }
    return self;
}

- (void)setupContentView {
    self.backgroundColor = DDYRGBA(0, 0, 0, 0.7);
    
    UIImage *img = [UIImage imageNamed:@"UpdateUpIcon"];
    
    _bgView = UIViewNew.viewSetFrame(40,0, DDYSCREENW-80, 190).viewSetCenterY(DDYSCREENH/2.).viewBGColor(DDY_White);
    
    _titleImgView = UIImageViewNew.img_viewImage(img);
    
    _titleLabel = UILabelNew.labFont(DDYBDFont(17)).labTextColor(DDY_Big_Black).labText(DDYLocalStr(@" ")).labAlignmentCenter();
    
    _messageLabel = UILabelNew.labFont(DDYFont(14)).labTextColor(DDY_Mid_Black).labText(DDYLocalStr(@" ")).labAlignmentLeft();
    
    _cancelBtn = DDYButtonNew.btnBgColor(DDYRGBA(200, 200, 200, 1)).btnTitleN(DDYLocalStr(@"UpdateLater")).btnTitleColorN(DDY_White).btnAction(self, @selector(handleLater));
    
    _okBtn = DDYButtonNew.btnBgColor(DDYRGBA(253, 200, 62, 1)).btnTitleN(DDYLocalStr(@"UpdateNow")).btnTitleColorN(DDY_White).btnAction(self, @selector(handleOpen));
    
    [self addSubview:_bgView];
    [self addSubview:_titleImgView.viewSetFrame(_bgView.ddy_x,0,_bgView.ddy_w,_bgView.ddy_w*img.size.height/img.size.width).viewSetCenterY(_bgView.ddy_y)];
    [self addSubview:_titleLabel.labNumberOfLines(0).viewSetFrame(_bgView.ddy_x, _bgView.ddy_y+62, _bgView.ddy_w, 200)];
    [self addSubview:_messageLabel.labNumberOfLines(0).viewSetFrame(_bgView.ddy_x+15, _titleLabel.ddy_bottom+12, _bgView.ddy_w-30, 200)];
    [self addSubview:_cancelBtn.btnFrame(_bgView.ddy_x+15,_bgView.ddy_bottom-50, _bgView.ddy_w/2.-23, 36)];
    [self addSubview:_okBtn.btnFrame(_cancelBtn.ddy_right+15,_bgView.ddy_bottom-50, _bgView.ddy_w/2.-23, 36)];
    
    DDYBorderRadius(_bgView, 4, 0, DDY_ClearColor);
    DDYBorderRadius(_cancelBtn, _cancelBtn.ddy_h/2., 0, DDY_ClearColor);
    DDYBorderRadius(_okBtn, _okBtn.ddy_h/2., 0, DDY_ClearColor);
}

- (void)handleLater {
    [self removeFromSuperview];
}

- (void)handleOpen {
    [self removeFromSuperview];
    if (self.updateBlock) {
        self.updateBlock();
    }
}

- (void)show:(NSString *)title msg:(NSString *)msg coerce:(BOOL)coerce {
    _titleLabel.text = title;
    _messageLabel.text = msg;
    [_titleLabel sizeToFit];
    [_messageLabel sizeToFit];
    _bgView.viewSetHeight(10+_titleLabel.ddy_h+20+_messageLabel.ddy_h+25+_okBtn.ddy_h+15).viewSetCenterY(DDYSCREENH/2.+_titleImgView.ddy_h/2.);
    _titleImgView.ddy_bottom = _bgView.ddy_y+5;
    _titleLabel.ddy_y = _bgView.ddy_y+10;
    _titleLabel.ddy_centerX = _bgView.ddy_centerX;
    _messageLabel.ddy_y = _titleLabel.ddy_bottom+20;
    if (coerce) {
        _cancelBtn.hidden = YES;
        _okBtn.ddy_centerX = _bgView.ddy_centerX;
        _okBtn.ddy_y = _messageLabel.ddy_bottom+25;
    } else {
        _cancelBtn.hidden = NO;
        _cancelBtn.ddy_x = _bgView.ddy_x+15;
        _okBtn.ddy_x = _cancelBtn.ddy_right+15;
        _cancelBtn.ddy_y = _messageLabel.ddy_bottom+25;
        _okBtn.ddy_y = _messageLabel.ddy_bottom+25;
    }
    UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
    if (!keyWindow) keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow addSubview:self];
}

@end
