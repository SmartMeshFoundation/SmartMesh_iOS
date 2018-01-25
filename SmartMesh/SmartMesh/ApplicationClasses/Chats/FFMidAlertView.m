//
//  FFMidAlertView.m
//  FireFly
//
//  Created by SmartMesh on 18/1/24.
//  Copyright © 2018年 NAT. All rights reserved.
//

#import "FFMidAlertView.h"

@interface FFMidAlertView ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UILabel *titleLab;

@property (nonatomic, strong) UITextField *inputField;

@property (nonatomic, strong) UILabel *tipLabel;

@property (nonatomic, strong) DDYButton *cancelBtn;

@property (nonatomic, strong) DDYButton *okBtn;

@end

@implementation FFMidAlertView

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
    
    _bgView = UIViewNew.viewSetFrame(30,0,DDYSCREENW-60, 90).viewBGColor(DDY_White).viewAddToView(self);
    
    _titleLab = UILabelNew.labFont(DDYFont(20)).labAlignmentCenter().labText(@"SmartMesh ID").labTextColor(NA_Big_Black);
    _titleLab.viewSetFrame(15, 20, _bgView.ddy_w-30, 23).viewAddToView(_bgView);
    
    _inputField = [[UITextField alloc] initWithFrame:DDYRect(15, _titleLab.ddy_bottom+20, _bgView.ddy_w-30, 24)];
    _inputField.placeholder = DDYLocalStr(@"ChatRegistMIDPlaceholder");
    _inputField.viewAddToView(_bgView);
    _inputField.font = DDYFont(14);
    [_inputField addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
    
    UIViewNew.viewSetFrame(15,_inputField.ddy_bottom, _inputField.ddy_w, 1).viewBGColor(DDYRGBA(230, 220, 220, 1)).viewAddToView(_bgView);
    
    _tipLabel = UILabelNew.labFont(DDYFont(15)).labAlignmentLeft().labText(DDYLocalStr(@"ChatRegistMIDTip")).labNumberOfLines(0).labTextColor(DDY_Mid_Black);
    _tipLabel.viewSetFrame(15,_inputField.ddy_bottom+15, _bgView.ddy_w-30, 30).viewAddToView(_bgView);
    [_tipLabel sizeToFit];
    
    _cancelBtn = DDYButtonNew.btnBgColor(DDY_LightGray).btnTitleColorN(DDY_White).btnTitleN(DDYLocalStr(@"Cancel")).btnFont(DDYFont(16));
    _cancelBtn.btnFrame(15, _tipLabel.ddy_bottom+20,_bgView.ddy_w/2-15-10, 36).btnAction(self, @selector(handleCancel)).btnSuperView(_bgView);
    
    _okBtn = DDYButtonNew.btnBgColor(FF_MAIN_COLOR).btnTitleColorN(DDY_White).btnTitleN(DDYLocalStr(@"ChatRegistMIDOK")).btnFont(DDYFont(16));
    _okBtn.btnFrame(_cancelBtn.ddy_right+20, _cancelBtn.ddy_y, _cancelBtn.ddy_w, _cancelBtn.ddy_h).btnAction(self, @selector(handleOK)).btnSuperView(_bgView);
    
    _bgView.viewSetHeight(_okBtn.ddy_bottom+15).viewSetCenterY(DDYSCREENH/2-50);
}

- (void)handleCancel {
    [self removeFromSuperview];
}

- (void)handleOK {
    if (_inputField.text.length < 6 || _inputField.text.length > 20) {
        [self shakeWarning:DDYLocalStr(@"ChatRegistMIDPlaceholder")];
    } else if ([_inputField.text ddy_onlyHasCharacterOfString:@"1234567890"]) {
        [self shakeWarning:DDYLocalStr(@"ChatRegistMIDAllNumbersTip")];
    } else {
        [self loadRegisterData:_inputField.text];
        [self removeFromSuperview];
    }
}

- (void)loadRegisterData:(NSString * )mid {
    UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
    if (!keyWindow) { keyWindow = [[UIApplication sharedApplication] keyWindow]; }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:keyWindow animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    
    NSDictionary * params = @{@"mid": _inputField.text,
                              @"password":[FFLoginDataBase sharedInstance].loginUser.passwrod,
                              @"localid":[FFLoginDataBase sharedInstance].loginUser.localID,
                              @"username":[FFLoginDataBase sharedInstance].loginUser.nickName, };
    
    [NANetWorkRequest na_postDataWithService:@"user" action:@"register" parameters:params results:^(BOOL status, NSDictionary *result) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES afterDelay:0.1];
        });
        if (status) {
            [[FFLoginDataBase sharedInstance] saveMid:_inputField.text];
            [[FFLoginDataBase sharedInstance] saveToken:result[@"token"]];
            [[FFLoginDataBase sharedInstance] saveUID:result[@"uid"]];
            [FFLocalUserInfo LCInstance].isSignUp = YES;
            if (![NSString ddy_blankString:[FFLoginDataBase sharedInstance].loginUser.token] && [[FFLoginDataBase sharedInstance] activeUser]) {
                [[FFXMPPManager sharedManager] disconnect];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [[FFXMPPManager sharedManager] connectWithUser:[FFLoginDataBase sharedInstance].loginUser];
                });
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.completeBlock) self.completeBlock();
            });
        }
    }];
}

- (void)showOnWindow {
    UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
    if (!keyWindow) keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow addSubview:self];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //    [self removeFromSuperview];
}

- (void)textChange {
    if (![_inputField.text ddy_OnlyLetterOrNumber]) {
        _inputField.text = @"";
    }
    if (_inputField.text.length > 0) {
        _tipLabel.labTextColor(DDY_Mid_Black).labText(DDYLocalStr(@"ChatRegistMIDTip"));
    }
}

- (void)shakeWarning:(NSString *)msg {
    _tipLabel.labTextColor(DDY_Red).labText(msg);
    CAKeyframeAnimation *frameAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    frameAnimation.values = @[@(-5),@(0),@(5),@(0),@(-5),@(0),@(5),@(0)];
    frameAnimation.duration = 0.3f;
    frameAnimation.repeatCount = 2;
    frameAnimation.removedOnCompletion = YES;
    [_tipLabel.layer addAnimation:frameAnimation forKey:@"shake"];
    _inputField.text = @"";
}

@end
