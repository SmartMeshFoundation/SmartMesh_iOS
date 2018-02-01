//
//  FFWalletDisclaimerAlert.m
//  FireFly
//
//  Created by SmartMesh on 18/2/1.
//  Copyright © 2018年 NAT. All rights reserved.
//

#import "FFWalletDisclaimerAlert.h"

@interface FFWalletDisclaimerAlert ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UILabel *titleLab;

@property (nonatomic, strong) UILabel *msgOneLabel;

@property (nonatomic, strong) UILabel *msgTwoLabel;

@property (nonatomic, strong) DDYButton *okBtn;

@end

@implementation FFWalletDisclaimerAlert

+ (instancetype)alertView {
    return [[self alloc] initWithFrame:DDYSCREENBOUNDS];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = DDYRGBA(0, 0, 0, 0.7);
        _bgView = UIViewNew.viewBGColor(DDY_White);
        _titleLab = UILabelNew.labText(DDYLocalStr(@"WalletDisclaimerTitle")).labTextColor(DDY_Big_Black).labFont(DDYBDFont(19)).labAlignmentCenter();
        _msgOneLabel = UILabelNew.labText(DDYLocalStr(@"WalletDisclaimerMsgOne")).labTextColor(DDY_Mid_Black).labFont(DDYFont(15)).labAlignmentLeft();
        _msgTwoLabel = UILabelNew.labText(DDYLocalStr(@"WalletDisclaimerMsgTwo")).labTextColor(DDY_Mid_Black).labFont(DDYFont(15)).labAlignmentLeft();
        _okBtn = DDYButtonNew.btnTitleN(DDYLocalStr(@"OK")).btnTitleColorN(DDY_Big_Black).btnFont(DDYBDFont(17)).btnAction(self,@selector(handleOk));
        
        [self addSubview:_bgView.viewSetFrame(25,0,DDYSCREENW-50,0)];
        [_bgView addSubview:_titleLab.labNumberOfLines(0).viewSetFrame(12,20,_bgView.ddy_w-24,20)];
        [_bgView addSubview:_msgOneLabel.labNumberOfLines(0).viewSetFrame(12,0,_bgView.ddy_w-24,100)];
        [_bgView addSubview:_msgTwoLabel.labNumberOfLines(0).viewSetFrame(12,0,_bgView.ddy_w-24,100)];
        [_bgView addSubview:_okBtn.btnFrame(15,0,_bgView.ddy_w-30,36).btnBgColor(FF_MAIN_COLOR)];
        DDYBorderRadius(_okBtn, _okBtn.ddy_h/2, 0, DDY_ClearColor);
        
        [_titleLab sizeToFit];
        [_msgOneLabel sizeToFit];
        [_msgTwoLabel sizeToFit];
        _titleLab.viewSetCenterX(_bgView.ddy_w/2);
        _msgOneLabel.ddy_y = _titleLab.ddy_bottom+12;
        _msgTwoLabel.ddy_y = _msgOneLabel.ddy_bottom+12;
        _okBtn.ddy_y = _msgTwoLabel.ddy_bottom+18;
        _bgView.ddy_h = _okBtn.ddy_bottom+15;
        _bgView.viewSetCenter(DDYSCREENW/2, DDYSCREENH/2);
    }
    return self;
}

- (void)handleOk {
    [self removeFromSuperview];
}

- (void)showOnWindow {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
        if (!keyWindow) keyWindow = [[UIApplication sharedApplication] keyWindow];
        [keyWindow addSubview:self];
    });
    
}

@end
