//
//  FFCreatAccountViewController.m
//  SmartMesh
//
//  Created by Megan on 2017/9/22.
//  Copyright © 2017年 SmartMesh Foundation All rights reserved.
//

#import "FFCreatAccountViewController.h"

@interface FFCreatAccountViewController ()<UITextFieldDelegate>
{
    UILabel     * _ffidLabel;
    UITextField * _ffidField;
    UILabel     * _nameLabel;
    UITextField * _nameField;
    UILabel     * _passwordLabel;
    UITextField * _passwordField;
    UIButton    * _signBtn;
}
@end

@implementation FFCreatAccountViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    self.title = @"Creat an Account";
    
    [self observeNotification:UIKeyboardWillShowNotification];
    [self observeNotification:UIKeyboardWillHideNotification];
    [self observeNotification:UITextFieldTextDidChangeNotification];

}

- (void)buildUI
{
    [self.view addTapTarget:self action:@selector(tapAction)];
    
    _ffidLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 80, DDYSCREENW - 56, 15)];
    _ffidLabel.text = @"FFID";
    _ffidLabel.font = NA_FONT(12);
    _ffidLabel.textColor = LC_RGB(42, 42, 42);
    [self.view addSubview:_ffidLabel];
    
    _ffidField = [[UITextField alloc] initWithFrame:LC_RECT(15, _ffidLabel.viewBottomY + 10, DDYSCREENW - 30, 35)];
    _ffidField.placeholder = @"FFID.";
    _ffidField.font = NA_FONT(24);
    _ffidField.textColor = LC_RGB(42, 42, 42);
    [self.view addSubview:_ffidField];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, _ffidField.viewBottomY + 20, DDYSCREENW - 56, 15)];
    _nameLabel.text = @"USERNAME";
    _nameLabel.font = NA_FONT(12);
    _nameLabel.textColor = LC_RGB(42, 42, 42);
    [self.view addSubview:_nameLabel];
    
    _nameField = [[UITextField alloc] initWithFrame:LC_RECT(15, _nameLabel.viewBottomY + 10, DDYSCREENW - 30, 35)];
    _nameField.placeholder = @" name";
    _nameField.font = NA_FONT(24);
    _nameField.textColor = LC_RGB(42, 42, 42);
    [self.view addSubview:_nameField];
    
    _passwordLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, _nameField.viewBottomY + 20, DDYSCREENW - 56, 15)];
    _passwordLabel.text = @"PARRWORD";
    _passwordLabel.font = NA_FONT(12);
    _passwordLabel.textColor = LC_RGB(42, 42, 42);
    [self.view addSubview:_passwordLabel];
    
    _passwordField = [[UITextField alloc] initWithFrame:LC_RECT(15, _passwordLabel.viewBottomY + 10, DDYSCREENW - 30, 35)];
    _passwordField.placeholder = @" password";
    _passwordField.font = NA_FONT(24);
    _passwordField.textColor = LC_RGB(42, 42, 42);
    [self.view addSubview:_passwordField];

    _signBtn = [[UIButton alloc] initWithFrame:LC_RECT(37.5, _passwordField.viewBottomY + 40, DDYSCREENW - 75, 50)];
    [_signBtn setTitle:@"sign up" forState:UIControlStateNormal];
    _signBtn.titleLabel.font = NA_FONT(18);
    [_signBtn setUserInteractionEnabled:NO];
    [_signBtn setBackgroundColor:LC_RGB(230, 230, 230)];
    [_signBtn setTitleColor:LC_RGB(153, 153, 153) forState:UIControlStateNormal];
    [_signBtn addTarget:self action:@selector(signUpAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_signBtn];
    _signBtn.layer.cornerRadius = 25;
    _signBtn.layer.masksToBounds = YES;
    
}

- (void)signUpAction
{
    
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
    if (_ffidField.text.length == 0 || _nameField.text.length == 0 || _passwordField.text.length == 0) {
        
        [_signBtn setUserInteractionEnabled:NO];
        [_signBtn setBackgroundColor:LC_RGB(230, 230, 230)];
        [_signBtn setTitleColor:LC_RGB(153, 153, 153) forState:UIControlStateNormal];
    }
    else
    {
        [_signBtn setUserInteractionEnabled:YES];
        [_signBtn setBackgroundColor:LC_RGB(248, 220, 74)];
        [_signBtn setTitleColor:LC_RGB(51, 51, 51) forState:UIControlStateNormal];
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
