//
//  FFGasAlert.m
//  FireFly
//
//  Created by SmartMesh on 18/1/31.
//  Copyright © 2018年 NAT. All rights reserved.
//

#import "FFGasAlert.h"

@interface FFGasAlert ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UILabel *msgLabel;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) DDYButton *okBtn;

@end

@implementation FFGasAlert

+ (instancetype)alertViewWithMsg:(NSString *)msg {
    return [[self alloc] initWithFrame:DDYSCREENBOUNDS msg:msg];
}

- (instancetype)initWithFrame:(CGRect)frame msg:(NSString *)msg {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = DDYRGBA(0, 0, 0, 0.7);
        _bgView = UIViewNew.viewSetCenterY(DDYSCREENH/2.).viewBGColor(DDY_White);
        _msgLabel = UILabelNew.labFont(DDYBDFont(16)).labTextColor(DDY_Big_Black).labText(msg).labAlignmentCenter().labNumberOfLines(0);
        _lineView = UIViewNew.viewBGColor(DDYRGBA(220, 220, 220, 1));
        _okBtn = DDYButtonNew.btnTitleN(DDYLocalStr(@"OK")).btnTitleColorN(DDY_Blue).btnAction(self, @selector(handleOpen));
        [self addSubview:_bgView.viewSetFrame(25,0, DDYSCREENW-50, 190)];
        [_bgView addSubview:_msgLabel.viewSetFrame(12,12,_bgView.ddy_w-24,100)];
        [_bgView addSubview:_lineView.viewSetFrame(0,0,_bgView.ddy_w,1)];
        [_bgView addSubview:_okBtn.btnFrame(12,0,_bgView.ddy_w-24,26)];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [_msgLabel sizeToFit];
    if (_msgLabel.ddy_h<30) {
        _msgLabel.ddy_h = 30;
    }
    _lineView.ddy_y = _msgLabel.ddy_bottom+20;
    _okBtn.ddy_y = _lineView.ddy_bottom+12;
    _bgView.ddy_h = _okBtn.ddy_bottom+12;
    DDYBorderRadius(_bgView.viewSetCenter(DDYSCREENW/2,DDYSCREENH/2), 8, 0, DDY_ClearColor);
    
}

- (void)handleOpen {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.confirmBlock) self.confirmBlock();
        [self removeFromSuperview];
    });
}

- (void)showOnWindow {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIView *currentFirstResponder = [UIResponder ddy_CurrentFirstResponder];
        [currentFirstResponder resignFirstResponder];
        UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
        if (!keyWindow) keyWindow = [[UIApplication sharedApplication] keyWindow];
        [keyWindow addSubview:self];
    });
    
}

- (void)hide {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIView *currentFirstResponder = [UIResponder ddy_CurrentFirstResponder];
        [currentFirstResponder resignFirstResponder];
        [self removeFromSuperview];
    });
}

@end
