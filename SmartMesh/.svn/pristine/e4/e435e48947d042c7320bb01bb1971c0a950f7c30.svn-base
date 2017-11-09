//
//  FFSettingPasswordVC.m
//  SmartMesh
//
//  Created by Megan on 2017/9/25.
//  Copyright © 2017年 SmartMesh Foundation All rights reserved.
//

#import "FFSettingPasswordVC.h"
#import "FFSendMessageViewController.h"

@interface FFSettingPasswordVC ()<UITextFieldDelegate>
{
    UILabel     * _pwdTips;
    UITextField * _pwdLabel;
    UILabel     * _pwdTips1;
    UITextField * _pwdLabel1;
    UIButton    * _finishBtn;
}
@end

@implementation FFSettingPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self observeNotification:UIKeyboardWillShowNotification];
    [self observeNotification:UIKeyboardWillHideNotification];
    [self observeNotification:UITextFieldTextDidChangeNotification];

}

- (void)buildUI
{
    [self.view addTapTarget:self action:@selector(tapAction)];
    
    _pwdTips = [[UILabel alloc] initWithFrame:CGRectMake(37.5, 80, DDYSCREENW - 75, 15)];
    _pwdTips.text = @"SET THE NEW PASSWORD";
    _pwdTips.font = NA_FONT(12);
    _pwdTips.textColor = LC_RGB(42, 42, 42);
    [self.view addSubview:_pwdTips];
    
    _pwdLabel = [[UITextField alloc] initWithFrame:CGRectMake(37.5, _pwdTips.viewBottomY + 10, DDYSCREENW - 75, 48)];
    _pwdLabel.font = NA_FONT(32);
    _pwdLabel.placeholder = @"password";
    _pwdLabel.textColor = LC_RGB(42, 42, 42);
    _pwdLabel.delegate = self;
    [self.view addSubview:_pwdLabel];
    
    _pwdTips1 = [[UILabel alloc] initWithFrame:CGRectMake(37.5, _pwdLabel.viewBottomY +10, DDYSCREENW - 75, 15)];
    _pwdTips1.text = @"CONFIRM NEW PASSWORD";
    _pwdTips1.font = NA_FONT(12);
    _pwdTips1.textColor = LC_RGB(42, 42, 42);
    [self.view addSubview:_pwdTips1];
    
    _pwdLabel1 = [[UITextField alloc] initWithFrame:CGRectMake(37.5, _pwdTips1.viewBottomY + 10, DDYSCREENW - 75, 48)];
    _pwdLabel1.font = NA_FONT(32);
    _pwdLabel1.placeholder = @"password";
    _pwdLabel1.textColor = LC_RGB(42, 42, 42);
    _pwdLabel1.delegate = self;
    [self.view addSubview:_pwdLabel1];
    
    _finishBtn = [[UIButton alloc] initWithFrame:LC_RECT(37.5, _pwdLabel1.viewBottomY + 50, DDYSCREENW - 75, 50)];
    [_finishBtn setTitle:@"complete" forState:UIControlStateNormal];
    _finishBtn.titleLabel.font = NA_FONT(18);
    [_finishBtn setUserInteractionEnabled:NO];
    [_finishBtn setBackgroundColor:LC_RGB(230, 230, 230)];
    [_finishBtn setTitleColor:LC_RGB(153, 153, 153) forState:UIControlStateNormal];
    [_finishBtn addTarget:self action:@selector(finishAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_finishBtn];
    _finishBtn.layer.cornerRadius = 25;
    _finishBtn.layer.masksToBounds = YES;

}

- (void)finishAction
{
    FFSendMessageViewController * controller = [[FFSendMessageViewController alloc] init];
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
    if (_pwdLabel.text.length == 0 || _pwdLabel1.text.length == 0) {
        
        [_finishBtn setUserInteractionEnabled:NO];
        [_finishBtn setBackgroundColor:LC_RGB(230, 230, 230)];
        [_finishBtn setTitleColor:LC_RGB(153, 153, 153) forState:UIControlStateNormal];
    }
    else
    {
        [_finishBtn setUserInteractionEnabled:YES];
        [_finishBtn setBackgroundColor:LC_RGB(248, 220, 74)];
        [_finishBtn setTitleColor:LC_RGB(51, 51, 51) forState:UIControlStateNormal];
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
