//
//  TextViewTestVC.m
//  DDYProject
//
//  Created by LingTuan on 17/7/27.
//  Copyright © 2017年 Starain. All rights reserved.
//

#import "TextViewTestVC.h"
#import "DDYTextView.h"

@interface TextViewTestVC ()<UITextViewDelegate>

@property (nonatomic, strong) DDYTextView *textView;

@property (nonatomic, strong) UILabel *tipLabel;

@end

@implementation TextViewTestVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self prepare];
    [self setupContentView];
}

- (void)prepare
{
    // 64当起点布局
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = DDYRGBA(245, 245, 245, 1);
}

- (void)setupContentView
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, DDYSCREENW, 140)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    _textView = [DDYTextView textView];
    _textView.font = DDYFont(14);
    _textView.placeholder = @"我是占位大哥";
    _textView.frame = CGRectMake(0, 0, DDYSCREENW, 110);
    _textView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
    _textView.delegate = self;
    [bgView addSubview:_textView];
    
    _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _textView.ddy_bottom + 10, DDYSCREENW-10, 20)];
    _tipLabel.textAlignment = NSTextAlignmentRight;
    _tipLabel.textColor = DDYRGBA(75, 222, 209, 1.0);
    _tipLabel.font = DDYFont(11);
    _tipLabel.text = @"0/250";
    [bgView addSubview:_tipLabel];    
}

#pragma mark - UITextViewDelegate
#pragma mark 可以用来控制占位字符显隐，剩余字数计算等
- (void)textViewDidChange:(UITextView *)textView
{
    if (_textView.text.length > 250)
    {
        _textView.text = [_textView.text substringToIndex:250];
        _tipLabel.textColor = [UIColor redColor];
    }
    else
    {
        _tipLabel.textColor = (_textView.text.length == 250)?[UIColor redColor]:DDYRGBA(75, 222, 209, 1.0);
    }
    
    _tipLabel.text = [NSString stringWithFormat:@"%lu%@",(unsigned long)_textView.text.length,@"/250"];
    [_textView scrollRangeToVisible:NSMakeRange(_textView.text.length, 1)];
    
}

@end
