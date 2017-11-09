//
//  TableTopHeaderView.m
//  DDYProject
//
//  Created by LingTuan on 17/7/26.
//  Copyright © 2017年 Starain. All rights reserved.
//

#import "TableTopHeaderView.h"

@interface TableTopHeaderView ()

@property (nonatomic, strong) UIView   *headView;

@property (nonatomic, strong) UIButton *firstBtn;

@property (nonatomic, strong) UIButton *secondBtn;

@property (nonatomic, strong) UIButton *thirdBtn;

@property (nonatomic, strong) UIView   *lineView;

@end

@implementation TableTopHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setupHeadView];
        [self setHorizontalBtn];
    }
    return self;
}

#pragma mark 这里设置上面显示的视图
- (void)setupHeadView
{
    _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DDYSCREENW, 200)];
    _headView.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:_headView];
}

- (void)setHorizontalBtn
{
    CGFloat btnW = DDYSCREENW/3.0;
    
    _firstBtn  = [DDYButton customDDYBtn].btnTitleN(@"第一个按钮").btnBgColor(DDYColor(245, 245, 245, 1)).btnTag(101);
    _secondBtn = [DDYButton customDDYBtn].btnTitleN(@"第二个按钮").btnBgColor(DDYColor(245, 245, 245, 1)).btnTag(102);
    _thirdBtn  = [DDYButton customDDYBtn].btnTitleN(@"第三个按钮").btnBgColor(DDYColor(245, 245, 245, 1)).btnTag(103);
    _lineView  = UIViewNew.viewBGColor([UIColor redColor]).viewSetFrame(0, 240, btnW, 1);
    
    _firstBtn.btnFrame( 0*btnW, 200, btnW, 40).btnSuperView(self).btnTitleColorN([UIColor redColor]);
    _secondBtn.btnFrame(1*btnW, 200, btnW, 40).btnSuperView(self).btnTitleColorN([UIColor lightGrayColor]);
    _thirdBtn.btnFrame( 2*btnW, 200, btnW, 40).btnSuperView(self).btnTitleColorN([UIColor lightGrayColor]);
    
    [_firstBtn  addTarget:self action:@selector(handleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_secondBtn addTarget:self action:@selector(handleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_thirdBtn  addTarget:self action:@selector(handleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_lineView];
    _selectedIndex = 0;
    _BottomItemH = _firstBtn.ddy_h;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    _selectedIndex = selectedIndex;
    
    if (_selectedIndex == 0)
    {
        _firstBtn.btnTitleColorN([UIColor redColor]);
        _secondBtn.btnTitleColorN([UIColor lightGrayColor]);
        _thirdBtn.btnTitleColorN([UIColor lightGrayColor]);
    }
    else if (_selectedIndex == 1)
    {
        _firstBtn.btnTitleColorN([UIColor lightGrayColor]);
        _secondBtn.btnTitleColorN([UIColor redColor]);
        _thirdBtn.btnTitleColorN([UIColor lightGrayColor]);
    }
    else if (_selectedIndex == 2)
    {
        _firstBtn.btnTitleColorN([UIColor lightGrayColor]);
        _secondBtn.btnTitleColorN([UIColor lightGrayColor]);
        _thirdBtn.btnTitleColorN([UIColor redColor]);
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        _lineView.ddy_x = _selectedIndex * DDYSCREENW/3.0;
    }];
}

- (void)handleBtnClick:(DDYButton *)button
{
    if (self.btnClickBlock)
    {
        self.btnClickBlock(button.tag-101);
    }
}

#pragma mark 防止响应链中断造成下面按钮不响应
- (id)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    id hitView = [super hitTest:point withEvent:event];
    return (hitView == _headView) ? nil : hitView;
}

@end
