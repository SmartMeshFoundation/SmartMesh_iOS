//
//  FFWalletVerifyView.m
//  FireFly
//
//  Created by SmartMesh on 18/1/29.
//  Copyright © 2018年 NAT. All rights reserved.
//

#import "FFWalletVerifyView.h"

//--------------------- 钱包选择视图 ---------------------//
@interface FFWalletSelectView ()<UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) UIPickerView *pickerView;

@end

@implementation FFWalletSelectView

+ (instancetype)selectView {
    return [[self alloc] initWithFrame:DDYRect(0, 0, DDYSCREENW, DDYSCREENH)];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = DDYRGBA(0, 0, 0, 0.7);
        DDYButton *bgView = DDYButtonNew.btnBgColor(DDYRGBA(230, 230, 230, 1)).btnSuperView(self);
        bgView.btnFrame(0,DDYSCREENH-240-SafeAreaBottomHeight,DDYSCREENW,240);
        // pickerView
        _pickerView = [[UIPickerView alloc] initWithFrame:DDYRect(0, 24, DDYSCREENW, 216)];
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        [_pickerView selectRow:[WALLET indexForAddress:WALLET.activeAccount] inComponent:0 animated:YES];
        [bgView addSubview:_pickerView];
        // cancelBtn
        DDYButton *cancelBtn = DDYButtonNew.btnFrame(0,0,DDYSCREENW/2,40).btnAction(self,@selector(handleSelectCancel)).btnBgColor(DDY_White);
        UILabel *cancelLab = UILabelNew.labText(DDYLocalStr(@"Cancel")).labAlignmentLeft().labTextColor(DDY_Small_Black);
        cancelLab.labFont(DDYFont(14)).viewSetFrame(15,0,140,40).viewAddToView(cancelBtn.btnSuperView(bgView));
        // OKBtn
        DDYButton *okBtn = DDYButtonNew.btnFrame(cancelBtn.ddy_right,0,DDYSCREENW/2,40).btnAction(self,@selector(handleSelectOK));
        UILabel *okLab = UILabelNew.labText(DDYLocalStr(@"OK")).labAlignmentRight().labTextColor(FF_MAIN_COLOR);
        okLab.labFont(DDYFont(14)).viewSetFrame(okBtn.ddy_w-155,0,140,40).viewAddToView(okBtn.btnSuperView(bgView).btnBgColor(DDY_White));
    }
    return self;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return WALLET.numberOfAccounts;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 40;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return DDYSCREENW-40;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *addressLab = nil;
    addressLab = UILabelNew.labFont(DDYFont(16)).labAlignmentCenter().labText([WALLET addressAtIndex:row].checksumAddress);
    [view addSubview:addressLab.labTextColor(DDY_Big_Black).viewSetFrame(0,0,view.ddy_w,view.ddy_h)];
    addressLab.lineBreakMode = NSLineBreakByTruncatingMiddle;
    return addressLab;
}

- (void)showOnWindow {
    UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
    if (!keyWindow) keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow addSubview:self];
}

- (void)handleSelectOK {
    Address *address = [WALLET addressAtIndex:[_pickerView selectedRowInComponent:0]];
    if (![WALLET.activeAccount isEqual:address]) {
        WALLET.activeAccount = address;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.selectBlock) {
                self.selectBlock();
            }
        });
    }
    [self.superview endEditing:YES];
    [self removeFromSuperview];
}

- (void)handleSelectCancel {
    [self.superview endEditing:YES];
    [self removeFromSuperview];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.superview endEditing:YES];
    [self removeFromSuperview];
}

@end


//--------------------- 钱包密码视图 ---------------------//
@interface FFWalletVerifyView ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *inputField;

@property (nonatomic, strong) DDYButton *confirmBtn;

@end

@implementation FFWalletVerifyView

+ (instancetype)verifyView {
    return [[self alloc] initWithFrame:DDYRect(0, 0, DDYSCREENW, DDYSCREENW-30)];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 密码输入
        _inputField = UITextFieldNew.txtFieldFont(DDYFont(14)).txtFieldPlaceholder(DDYLocalStr(@"GestureWalletPassword"));
        _inputField.viewSetFrame(25,30,DDYSCREENW-50,25).viewAddToView(self);
        [_inputField ddy_BorderTop:NO left:NO bottom:YES right:NO color:DDY_Small_Black width:1];
        [_inputField addTarget:self action:@selector(verifyTextChange) forControlEvents:UIControlEventEditingChanged];
        _inputField.returnKeyType = UIReturnKeyDone;
        _inputField.keyboardType = UIKeyboardTypeASCIICapable;
        _inputField.delegate = self;
        // 确定按钮
        _confirmBtn = DDYButtonNew.btnTitleN(DDYLocalStr(@"GestureWalletConfirm")).btnTitleColorN(DDY_Big_Black);
        _confirmBtn.btnSuperView(self).btnAction(self, @selector(confirmClick:)).btnFrame(40,_inputField.ddy_bottom+30,DDYSCREENW-80,44);
        [_confirmBtn setBackgroundImage:[UIImage imageWithColor:DDY_LightGray size:_confirmBtn.ddy_size] forState:UIControlStateDisabled];
        [_confirmBtn setBackgroundImage:[UIImage imageWithColor:FF_MAIN_COLOR size:_confirmBtn.ddy_size] forState:UIControlStateNormal];
        [_confirmBtn setEnabled:NO];
        DDYBorderRadius(_confirmBtn, _confirmBtn.ddy_h/2, 1, DDY_ClearColor);
    }
    return self;
}

- (void)verifyTextChange {
    _confirmBtn.enabled = _inputField.text.length>5 ? YES : NO;
}

- (void)confirmClick:(DDYButton *)sender {
    __weak __typeof__ (self)weakSelf = self;
    [self showLoading];
    [WALLET isValidPassword:_inputField.text forAddress:WALLET.activeAccount callback:^(BOOL isOK) {
        [self dismissLoading];
        if (weakSelf.walletVerifyBlock) {
            weakSelf.walletVerifyBlock(isOK);
        }
//        if (isOK) {
//            
//        } else {
//            MBProgressHUD *hud = [self showHudWithText:DDYLocalStr(@"GestureWalletError")];
//            hud.mode = MBProgressHUDModeText;
//            hud.userInteractionEnabled = YES;
//            [hud hideAnimated:YES afterDelay:2];
//        }
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField*)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
