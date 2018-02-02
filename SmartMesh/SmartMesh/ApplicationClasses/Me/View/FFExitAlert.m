//
//  FFExitAlert.m
//  FireFly
//
//  Created by SmartMesh on 18/2/2.
//  Copyright © 2018年 SmartMesh Foundation All rights reserved.
//

#import "FFExitAlert.h"

@interface FFExitAlert ()

@property (nonatomic, strong) DDYButton *bgView;

@property (nonatomic, strong) UILabel *titleLab;

@property (nonatomic, strong) UILabel *msgLabel;

@property (nonatomic, strong) DDYButton *firstBtn;

@property (nonatomic, strong) DDYButton *secondBtn;

@end

@implementation FFExitAlert

+ (instancetype)alertViewWithType:(FFExitAlertType)type {
    return [[self alloc] initWithFrame:DDYSCREENBOUNDS type:type];
}

- (instancetype)initWithFrame:(CGRect)frame type:(FFExitAlertType)type {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = DDYRGBA(0, 0, 0, 0.7);
        _bgView    = DDYButtonNew.btnBgColor(DDY_White).btnSuperView(self).btnFrame(25,0,DDYSCREENW-50,100);
        _titleLab  = UILabelNew.labAlignmentLeft().labTextColor(DDY_Black).labText(DDYLocalStr(@"MeExitTipTitle")).labFont(DDYFont(17));
        _msgLabel  = UILabelNew.labAlignmentLeft().labTextColor(DDY_Mid_Black).labFont(DDYFont(14));
        _firstBtn  = DDYButtonNew.btnTitleColorN(DDY_White).btnFont(DDYFont(15)).btnAction(self, @selector(handleFirstBtn));
        _secondBtn = DDYButtonNew.btnTitleColorN(DDY_White).btnFont(DDYFont(15)).btnAction(self, @selector(handleSecondBtn));
        
        if (type == FFExitAlertTypeOne) {
            _msgLabel.labText(DDYLocalStr(@"MeExitFirstTipMsg"));
            _firstBtn.btnTitleN(DDYLocalStr(@"MeExitFirstTipBind")).btnBgColor(DDY_Green);
            _secondBtn.btnTitleN(DDYLocalStr(@"MeExitFirstTipExit")).btnBgColor(DDY_LightGray);
        } else if (type == FFExitAlertTypeTwo) {
            _msgLabel.labText(DDYLocalStr(@"MeExitSecondTipMsg"));
            _firstBtn.btnTitleN(DDYLocalStr(@"MeExitSecondTipCancel")).btnBgColor(DDY_LightGray);
            _secondBtn.btnTitleN(DDYLocalStr(@"MeExitSecondTipYes")).btnBgColor(DDY_Red);
        }
        
        [_titleLab.labNumberOfLines(0).viewSetFrame(12, 20, _bgView.ddy_w-24, 100).viewAddToView(_bgView) sizeToFit];
        [_msgLabel.labNumberOfLines(0).viewSetFrame(12, _titleLab.ddy_bottom+15, _bgView.ddy_w-24, 100).viewAddToView(_bgView) sizeToFit];
        _firstBtn.btnFrame(12,_msgLabel.ddy_bottom+20,_bgView.ddy_w/2-20,30).btnSuperView(_bgView);
        _secondBtn.btnFrame(_firstBtn.ddy_right+16,_firstBtn.ddy_y,_firstBtn.ddy_w,30).btnSuperView(_bgView);
        _bgView.viewSetHeight(_secondBtn.ddy_bottom + 15).viewSetCenterY(DDYSCREENH/2);
    }
    return self;
}

- (void)handleFirstBtn {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.firstBtnBlock) {
            self.firstBtnBlock();
            [self removeFromSuperview];
        }
    });
}

- (void)handleSecondBtn {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.secondBtnBlock) {
            self.secondBtnBlock();
            [self removeFromSuperview];
        }
    });
}

- (void)showOnWindow {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
        if (!keyWindow) keyWindow = [[UIApplication sharedApplication] keyWindow];
        [keyWindow addSubview:self];
    });
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self removeFromSuperview];
}

@end
