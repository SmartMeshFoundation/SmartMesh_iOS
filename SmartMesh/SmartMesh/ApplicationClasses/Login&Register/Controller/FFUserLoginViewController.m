//
//  FFUserLoginViewController.m
//  SmartMesh
//
//  Created by Megan on 2017/9/22.
//  Copyright © 2017年 SmartMesh Foundation All rights reserved.
//

#import "FFUserLoginViewController.h"
#import "FFForgotPasswordVC.h"

@interface FFUserLoginViewController ()<UITextFieldDelegate>
{
    UILabel     * _numLabel;
    UILabel     * _phoneLabel;
    UITextField * _phoneNumLabel;
    UIButton    * _loginBtn;
    UILabel     * _passwordLabel;
    UITextField * _pwdLabel;
    UIButton    * _forgotLabel;
}
@end

@implementation FFUserLoginViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"Your Phone";
    
    [self observeNotification:UIKeyboardWillShowNotification];
    [self observeNotification:UIKeyboardWillHideNotification];
    [self observeNotification:UITextFieldTextDidChangeNotification];
}

- (void)buildUI
{
    [self.view addTapTarget:self action:@selector(tapAction)];
    
    _numLabel = [[UILabel alloc] initWithFrame:CGRectMake(37.5, 80, DDYSCREENW - 75, 15)];
    _numLabel.text = @"YOUR NUMBER";
    _numLabel.font = NA_FONT(12);
    _numLabel.textColor = LC_RGB(42, 42, 42);
    [self.view addSubview:_numLabel];
    
    _phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(37.5, _numLabel.viewBottomY + 10, 60, 48)];
    _phoneLabel.font = NA_FONT(32);
    _phoneLabel.text = @"+3";
    _phoneLabel.textColor = LC_RGB(42, 42, 42);
    [self.view addSubview:_phoneLabel];
    
    _phoneNumLabel = [[UITextField alloc] initWithFrame:CGRectMake(_phoneLabel.viewRightX + 10, _numLabel.viewBottomY + 10, DDYSCREENW - 100, 48)];
    _phoneNumLabel.font = NA_FONT(32);
    _phoneNumLabel.placeholder = @"phone num";
    _phoneNumLabel.textColor = LC_RGB(42, 42, 42);
    _phoneNumLabel.delegate = self;
    _phoneNumLabel.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_phoneNumLabel];
    
    _passwordLabel = [[UILabel alloc] initWithFrame:CGRectMake(37.5, _phoneNumLabel.viewBottomY + 20, DDYSCREENW - 75, 15)];
    _passwordLabel.text = @"PASSWORD";
    _passwordLabel.font = NA_FONT(12);
    _passwordLabel.textColor = LC_RGB(42, 42, 42);
    [self.view addSubview:_passwordLabel];
    
    _pwdLabel = [[UITextField alloc] initWithFrame:CGRectMake(37.5, _passwordLabel.viewBottomY + 10, DDYSCREENW - 70, 48)];
    _pwdLabel.font = NA_FONT(32);
    _pwdLabel.placeholder = @"password";
    _pwdLabel.textColor = LC_RGB(42, 42, 42);
    _pwdLabel.delegate = self;
    [self.view addSubview:_pwdLabel];
    
    _loginBtn = [[UIButton alloc] initWithFrame:LC_RECT(37.5, _pwdLabel.viewBottomY + 40, DDYSCREENW - 75, 50)];
    [_loginBtn setTitle:@"Login" forState:UIControlStateNormal];
    _loginBtn.titleLabel.font = [UIFont systemFontOfSize: 18];
    [_loginBtn setUserInteractionEnabled:NO];
    [_loginBtn setBackgroundColor:LC_RGB(230, 230, 230)];
    [_loginBtn setTitleColor:LC_RGB(153, 153, 153) forState:UIControlStateNormal];
    _loginBtn.layer.cornerRadius = 25;
    _loginBtn.layer.masksToBounds = YES;
    [_loginBtn addTarget:self action:@selector(singAtion) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginBtn];
    
    _forgotLabel = [[UIButton alloc] initWithFrame:LC_RECT(37.5, _loginBtn.viewBottomY + 10, DDYSCREENW - 75, 15)];
    [_forgotLabel setTitle:@"Forgot password" forState:UIControlStateNormal];
    _forgotLabel.titleLabel.font = [UIFont systemFontOfSize: 14];
    [_forgotLabel setTitleColor:LC_RGB(200, 200, 200) forState:UIControlStateNormal];
    [_forgotLabel addTarget:self action:@selector(forgotAtion) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_forgotLabel];
    
}

- (void)singAtion
{
    
}

- (void)forgotAtion
{
    FFForgotPasswordVC * contorller = [[FFForgotPasswordVC alloc] init];
    [self.navigationController pushViewController:contorller animated:YES];
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
    if (_phoneNumLabel.text.length == 0 || _pwdLabel.text.length == 0 ) {
        
        [_loginBtn setUserInteractionEnabled:NO];
        [_loginBtn setBackgroundColor:LC_RGB(230, 230, 230)];
        [_loginBtn setTitleColor:LC_RGB(153, 153, 153) forState:UIControlStateNormal];
    }
    else
    {
        [_loginBtn setUserInteractionEnabled:YES];
        [_loginBtn setBackgroundColor:LC_RGB(248, 220, 74)];
        [_loginBtn setTitleColor:LC_RGB(51, 51, 51) forState:UIControlStateNormal];
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


@end
