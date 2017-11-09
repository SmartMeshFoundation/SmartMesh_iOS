//
//  FFSendMgsViewController.m
//  SmartMesh
//
//  Created by Megan on 2017/9/22.
//  Copyright © 2017年 SmartMesh Foundation All rights reserved.
//

#import "FFSendMgsViewController.h"
#import "FFCreatAccountViewController.h"

@interface FFSendMgsViewController ()
{
    UILabel * _tipsLabel;
    UILabel * _codeTips;
    UILabel * _codeLabel;
    UILabel * _callTips;
    UIButton * _continueBtn;
}
@end

@implementation FFSendMgsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)buildUI
{
    _tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(28, 80, DDYSCREENW - 56, 45)];
    _tipsLabel.text = @"We have sent you an SMS with a code to the number.";
    _tipsLabel.font = NA_FONT(16);
    _tipsLabel.numberOfLines = 2;
    _tipsLabel.textColor = LC_RGB(111, 111, 111);
    [self.view addSubview:_tipsLabel];
    
    _codeTips = [[UILabel alloc] initWithFrame:CGRectMake(28, _tipsLabel.viewBottomY + 10, DDYSCREENW - 56, 20)];
    _codeTips.text = @"ENTER THE CODE";
    _codeTips.font = NA_FONT(12);
    [self.view addSubview:_codeTips];
    
    _codeLabel = [[UILabel alloc] initWithFrame:CGRectMake(28, _codeTips.viewBottomY + 10, DDYSCREENW - 56, 48)];
    _codeLabel.font = NA_FONT(32);
    _codeLabel.text = @"320-697-8644";
    _codeLabel.textColor = LC_RGB(213, 213, 213);
    [self.view addSubview:_codeLabel];
    
    _callTips = [[UILabel alloc] initWithFrame:CGRectMake(28, _codeLabel.viewBottomY + 30, DDYSCREENW - 56, 45)];
    _callTips.text = @"Sparks will call you in 1:23.";
    _callTips.font = NA_FONT(16);
    _callTips.numberOfLines = 2;
    _callTips.textColor = LC_RGB(111, 111, 111);
    [self.view addSubview:_callTips];
    
    _continueBtn = [[UIButton alloc] initWithFrame:LC_RECT(37.5, _callTips.viewBottomY + 10, DDYSCREENW - 75, 50)];
    [_continueBtn setTitle:@"Continue" forState:UIControlStateNormal];
    _continueBtn.titleLabel.font = NA_FONT(18);
    [_continueBtn setTitleColor:LC_RGB(153, 153, 153) forState:UIControlStateNormal];
    _continueBtn.backgroundColor = LC_RGB(234, 234, 234);
    [_continueBtn addTarget:self action:@selector(continueAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_continueBtn];
    _continueBtn.layer.cornerRadius = 25;
    _continueBtn.layer.masksToBounds = YES;
    
}

- (void)continueAction
{
    FFCreatAccountViewController * controller = [[FFCreatAccountViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
