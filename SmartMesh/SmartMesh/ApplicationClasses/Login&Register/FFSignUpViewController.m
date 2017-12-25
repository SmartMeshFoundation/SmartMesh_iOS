//
//  FFSignUpViewController.m
//  SmartMesh
//
//  Created by Megan on 2017/9/20.
//  Copyright © 2017年 SmartMesh Foundation All rights reserved.
//

#import "FFSignUpViewController.h"
#import "FFCountryListViewController.h"
#import "FFMobileCountryCodeVC.h"
#import "FFSendMessageViewController.h"
#import "NSObject+LCNotification.h"
#import "LC_UIAlertView.h"
#import "GTMBase64.h"
#import "SecurityUtil.h"

@interface FFSignUpViewController ()<UITextFieldDelegate,UIAlertViewDelegate>
{
    UILabel     * _tipsLabel;
    UILabel     * _contryTips;
    UILabel     * _countryLabel;
    UIButton    * _chooseBtn;
    UILabel     * _phoneTips;
    UILabel     * _phoneLabel;
    UITextField * _phoneNum;
    UIButton    * _signBtn;
}
@end

@implementation FFSignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = DDYLocalStr(@"MeBindingPhone");
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:DDYLocalStr(@"BindingNext") style:UIBarButtonItemStylePlain target:self action:@selector(nextButtonOnClicked)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
    [self observeNotification:UIKeyboardWillShowNotification];
    [self observeNotification:UIKeyboardWillHideNotification];
    [self observeNotification:UITextFieldTextDidChangeNotification];
}

- (void)buildUI
{
    [self.view addTapTarget:self action:@selector(tapAction)];
    
    _tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 80, DDYSCREENW - 40, 45)];
    _tipsLabel.text = DDYLocalStr(@"BindingPhoneTip");
    _tipsLabel.font = NA_FONT(16);
    _tipsLabel.numberOfLines = 2;
    _tipsLabel.textColor = LC_RGB(111, 111, 111);
    [self.view addSubview:_tipsLabel];

    _contryTips = [[UILabel alloc] initWithFrame:CGRectMake(20, _tipsLabel.viewBottomY + 10, DDYSCREENW - 40, 20)];
    _contryTips.text = DDYLocalStr(@"BindingYourCiry");
    _contryTips.font = NA_FONT(12);
    [self.view addSubview:_contryTips];
    
    _countryLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, _contryTips.viewBottomY + 10, 100, 30)];
    _countryLabel.font = NA_FONT(24);
    _countryLabel.textColor = LC_RGB(42, 42, 42);
    _countryLabel.text = @"中国";
    [self.view addSubview:_countryLabel];

    _chooseBtn = [[UIButton alloc] initWithFrame:CGRectMake(_countryLabel.viewRightX + 5,  _contryTips.viewBottomY + 10, 15, 12)];
    _chooseBtn.viewCenterY = _countryLabel.viewCenterY;
    [_chooseBtn setImage:[UIImage imageNamed:@"icon_choose_country_arrow"] forState:UIControlStateNormal];
    [_chooseBtn addTarget:self action:@selector(chooseAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_chooseBtn];
    [self adjustView];
    
    UIView * actionView = [[UIView alloc] initWithFrame:LC_RECT(_countryLabel.viewRightX, _contryTips.viewBottomY + 10, 50, 40)];
    actionView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:actionView];
    actionView.userInteractionEnabled = YES;
    [actionView addTapTarget:self action:@selector(chooseAction)];
    
    _phoneTips = [[UILabel alloc] initWithFrame:CGRectMake(20, _countryLabel.viewBottomY + 20, DDYSCREENW - 40, 15)];
    _phoneTips.text = DDYLocalStr(@"BindingYourPhone");
    _phoneTips.font = NA_FONT(12);
    _phoneTips.textColor = LC_RGB(42, 42, 42);
    [self.view addSubview:_phoneTips];
    
    UILabel * addLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, _phoneTips.viewBottomY + 10, 20, 48)];
    addLbl.font = NA_FONT(32);
    addLbl.text = @"+";
    addLbl.textColor = LC_RGB(42, 42, 42);
    [self.view addSubview:addLbl];
    
    _phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(addLbl.viewRightX + 5, _phoneTips.viewBottomY + 10, 60, 48)];
    _phoneLabel.font = NA_FONT(32);
    _phoneLabel.text = @"86";
    _phoneLabel.textColor = LC_RGB(42, 42, 42);
    [self.view addSubview:_phoneLabel];
    
    _phoneNum = [[UITextField alloc] initWithFrame:CGRectMake(_phoneLabel.viewRightX + 10, _phoneTips.viewBottomY + 10, DDYSCREENW - 100, 48)];
    _phoneNum.font = NA_FONT(32);
    _phoneNum.placeholder = DDYLocalStr(@"BindingPhonePlaceholder");
    _phoneNum.textColor = LC_RGB(42, 42, 42);
    _phoneNum.delegate = self;
    _phoneNum.keyboardType = UIKeyboardTypeNumberPad;
    [_phoneNum becomeFirstResponder];
    [self.view addSubview:_phoneNum];
    
}

- (void)nextButtonOnClicked
{
    if (_phoneNum.text.length == 0) {
        
        MBProgressHUD *hud = [self showHudWithText:DDYLocalStr(@"BindingNoPhoneNumTip")];
        [hud hideAnimated:YES afterDelay:2];
        return;
    }
    
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:DDYLocalStr(@"BindingConfirmPhoneTitle")
                                                    message:LC_NSSTRING_FORMAT(@"%@:%@", DDYLocalStr(@"BindingConfirmSendCode"), _phoneNum.text)
                                                   delegate:self cancelButtonTitle:DDYLocalStr(@"BindingConfirmPhoneCancel")
                                          otherButtonTitles:DDYLocalStr(@"BindingConfirmPhoneOK"), nil];
    
    [alert show];
}

- (void)chooseAction
{
    __weak __typeof__(self) weakSelf = self;
    FFMobileCountryCodeVC * selectedCode = [[FFMobileCountryCodeVC alloc] initWithSelectedString:_phoneLabel.text];
    selectedCode.selectedAction = ^(NSString * valueName , NSString * value){
        
        if (value)
        {
            NSString * numStr = [valueName substringFromIndex:1];
            NSString * nameStr = value;
            self->_phoneLabel.text = numStr;
            self->_countryLabel.text = nameStr;
            [weakSelf adjustView];
        }
    };
    
    [self.navigationController pushViewController:selectedCode animated:YES];
}

- (void)adjustView {
    _countryLabel.ddy_w = [_countryLabel labMaxW:DDYSCREENW-60];
    _chooseBtn.ddy_x = _countryLabel.ddy_right+5;
}

- (void)singAtion
{
    FFSendMessageViewController * controller = [[FFSendMessageViewController alloc] init];
    controller.status = 0;
    controller.phoneStr = LC_NSSTRING_FORMAT(@"%@ %@",_phoneLabel.text,_phoneNum.text);
    [self.navigationController pushViewController:controller animated:YES];

}

-(void) handleNotification:(NSNotification *)notification
{
    if ([notification is:UIKeyboardWillShowNotification]) {
        
        [self keyboardWillShow:notification];
        
    }else if ([notification is:UIKeyboardWillHideNotification]){
        
        [self keyboardWillHide:notification];
    }
    else if ([notification is:UITextFieldTextDidChangeNotification]){
        
        [self textFieldChange];
        
    }
    
}


- (void)tapAction
{
    [self.view endEditing:YES];
}

#pragma mark -
#pragma mark Responding to keyboard events

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    return YES;
}

- (void)textFieldChange
{
    if (_phoneNum.text.length != 0) {
        
        [_signBtn setUserInteractionEnabled:YES];
        [_signBtn setBackgroundColor:LC_RGB(248, 220, 74)];
        [_signBtn setTitleColor:LC_RGB(51, 51, 51) forState:UIControlStateNormal];
        
    }
    else
    {
        [_signBtn setUserInteractionEnabled:NO];
        [_signBtn setBackgroundColor:LC_RGB(230, 230, 230)];
        [_signBtn setTitleColor:LC_RGB(153, 153, 153) forState:UIControlStateNormal];
    }
    
}

#pragma mark -
#pragma mark Responding to keyboard events

- (void)keyboardWillShow:(NSNotification *)notification {
    
    NSDictionary * userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [self moveInputBarWithKeyboardHeight:65 withDuration:animationDuration + 0.5];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    NSDictionary* userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [self moveInputBarWithKeyboardHeight:0 withDuration:animationDuration+0.2];
}

- (void) moveInputBarWithKeyboardHeight:(float)height withDuration:(NSTimeInterval)interval
{
    [UIView animateWithDuration:interval animations:^{
        
//        [_contentScrollView setContentOffset:CGPointMake(0, height)];
    }];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        
        if (![self isMobileNumber:_phoneNum.text]) {
            [self showHudWithText:@"手机号码格式不对"];
            return ;
        }
        
        //直接调用send接口
        [self getCodeAction];
    }
}

-(void) getCodeAction
{
    [FFLocalUserInfo LCInstance].isRSAKey = YES;
    [FFLocalUserInfo LCInstance].isUser = YES;

    NSDictionary * params = @{
                              @"phonenumber" : LC_NSSTRING_FORMAT(@"%@ %@",_phoneLabel.text,_phoneNum.text) ,
                              @"type"        : @"0",
                              };
    
    [NANetWorkRequest na_postDataWithService:@"smsc" action:@"send" parameters:params results:^(BOOL status, NSDictionary *result) {
        
        if (status) {
            
            //跳转下一页输入验证码
            [self singAtion];
            
            [FFLocalUserInfo LCInstance].isRSAKey = NO;
        }
        else
        {
            NSString * errcode = [result objectForKey:@"errcode"];
            NSLog(@"==错误码:%@==",errcode);                                                                
        }
        
    }];
}

- (BOOL)isMobileNumber:(NSString *)mobileNum
{
    if (mobileNum.length < 3) {
        return NO;
    }else{
        
        mobileNum = [mobileNum stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
        
        if(mobileNum.length > 0)
        {
            return NO;
        }
        else
        {
            return YES;
        }
    }

}

@end
