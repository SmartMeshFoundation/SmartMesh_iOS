//
//  FFForgotPasswordVC.m
//  SmartMesh
//
//  Created by Megan on 2017/9/25.
//  Copyright © 2017年 SmartMesh Foundation All rights reserved.
//

#import "FFForgotPasswordVC.h"
#import "FFSettingPasswordVC.h"

@interface FFForgotPasswordVC ()<UITextFieldDelegate>
{
    UILabel     * _numTips;
    UILabel     * _phoneLabel;
    UITextField * _phoneNumLabel;
    UIButton    * _nextBtn;
}
@end

@implementation FFForgotPasswordVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title  = @"Forgot password";
    
    [self observeNotification:UIKeyboardWillShowNotification];
    [self observeNotification:UIKeyboardWillHideNotification];
    [self observeNotification:UITextFieldTextDidChangeNotification];
}

- (void)buildUI
{
    [self.view addTapTarget:self action:@selector(tapAction)];
    
    _numTips = [[UILabel alloc] initWithFrame:CGRectMake(37.5, 80, DDYSCREENW - 75, 15)];
    _numTips.text = @"YOUR NUMBER";
    _numTips.font = NA_FONT(12);
    _numTips.textColor = LC_RGB(42, 42, 42);
    [self.view addSubview:_numTips];

    _phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(37.5, _numTips.viewBottomY + 10, 60, 48)];
    _phoneLabel.font = NA_FONT(32);
    _phoneLabel.text = @"+3";
    _phoneLabel.textColor = LC_RGB(42, 42, 42);
    [self.view addSubview:_phoneLabel];
    
    _phoneNumLabel = [[UITextField alloc] initWithFrame:CGRectMake(_phoneLabel.viewRightX + 10, _numTips.viewBottomY + 10, DDYSCREENW - 100, 48)];
    _phoneNumLabel.font = NA_FONT(32);
    _phoneNumLabel.placeholder = @"phone num";
    _phoneNumLabel.textColor = LC_RGB(42, 42, 42);
    _phoneNumLabel.delegate = self;
    _phoneNumLabel.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_phoneNumLabel];

    _nextBtn = [[UIButton alloc] initWithFrame:LC_RECT(37.5, _phoneNumLabel.viewBottomY + 50, DDYSCREENW - 75, 50)];
    [_nextBtn setTitle:@"Next step" forState:UIControlStateNormal];
    _nextBtn.titleLabel.font = NA_FONT(18);
    [_nextBtn setUserInteractionEnabled:NO];
    [_nextBtn setBackgroundColor:LC_RGB(230, 230, 230)];
    [_nextBtn setTitleColor:LC_RGB(153, 153, 153) forState:UIControlStateNormal];
    [_nextBtn addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nextBtn];
    _nextBtn.layer.cornerRadius = 25;
    _nextBtn.layer.masksToBounds = YES;
    
}

- (void)nextAction
{
    FFSettingPasswordVC * controller = [[FFSettingPasswordVC alloc] init];
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
    if (_phoneNumLabel.text.length == 0) {
        
        [_nextBtn setUserInteractionEnabled:NO];
        [_nextBtn setBackgroundColor:LC_RGB(230, 230, 230)];
        [_nextBtn setTitleColor:LC_RGB(153, 153, 153) forState:UIControlStateNormal];
    }
    else
    {
        [_nextBtn setUserInteractionEnabled:YES];
        [_nextBtn setBackgroundColor:LC_RGB(248, 220, 74)];
        [_nextBtn setTitleColor:LC_RGB(51, 51, 51) forState:UIControlStateNormal];
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
