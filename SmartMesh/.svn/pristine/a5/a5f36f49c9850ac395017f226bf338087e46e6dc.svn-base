//
//  TableViewInScrollViewVC.m
//  DDYProject
//
//  Created by LingTuan on 17/7/26.
//  Copyright © 2017年 Starain. All rights reserved.
//

#import "TableViewInScrollViewVC.h"
#import "TableTopHeaderView.h"
#import "TestTableView.h"

@interface TableViewInScrollViewVC ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *bottomScrollView;

@property (nonatomic, strong) TableTopHeaderView *headView;

@property (nonatomic, strong) TestTableView *firstTableView;

@property (nonatomic, strong) TestTableView *secondTableView;

@property (nonatomic, strong) TestTableView *thirdTableView;

@property (nonatomic, strong) UIView *navLine;

@end

@implementation TableViewInScrollViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepare];
    [self.view addSubview:self.bottomScrollView];
    [self.view addSubview:self.headView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _navLine.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _navLine.hidden = NO;
}

- (void)prepare
{
    // 64当作起点布局
    UIView *backgroundView = [self.navigationController.navigationBar subviews].firstObject;
    // 导航分割线
    for (UIView *view in backgroundView.subviews) {
        if ([view isKindOfClass:[UIImageView class]] && view.ddy_h == 0.5) {
            _navLine = (UIImageView *)view;
        }
    }
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.view.backgroundColor = DDYRGBA(245, 245, 245, 1);
    self.navigationController.navigationBar.barTintColor = DDYRGBA(247, 247, 247, 1);
}

- (UIScrollView *)bottomScrollView
{
    if (!_bottomScrollView)
    {
        _bottomScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _bottomScrollView.contentSize = CGSizeMake(DDYSCREENW*3, 0);
        _bottomScrollView.showsVerticalScrollIndicator = NO;
        _bottomScrollView.showsHorizontalScrollIndicator = NO;
        _bottomScrollView.pagingEnabled = YES;
        _bottomScrollView.delegate = self;
        _bottomScrollView.bounces = NO;
        [_bottomScrollView addSubview:self.firstTableView];
        [_bottomScrollView addSubview:self.secondTableView];
        [_bottomScrollView addSubview:self.thirdTableView];
    }
    return _bottomScrollView;
}

- (TableTopHeaderView *)headView
{
    if (!_headView)
    {
        __weak __typeof__ (self)weakSelf = self;
        _headView = [[TableTopHeaderView alloc] initWithFrame:CGRectMake(0, 0, DDYSCREENW, 241)];
        _headView.btnClickBlock = ^(NSInteger index) {
            [weakSelf verticalScrollSetting];
            weakSelf.headView.selectedIndex = index;
            [weakSelf.bottomScrollView setContentOffset:CGPointMake(index*DDYSCREENW, 0) animated:NO];
        };
    }
    return _headView;
}

- (TestTableView *)firstTableView
{
    if (!_firstTableView)
    {
        _firstTableView = [[TestTableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _firstTableView.ddy_x = 0*DDYSCREENW;
        _firstTableView.ddy_h = DDYSCREENH-64;
        _firstTableView.topView = self.headView;
        
    }
    return _firstTableView;
}

- (TestTableView *)secondTableView
{
    if (!_secondTableView)
    {
        _secondTableView = [[TestTableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _secondTableView.ddy_x = 1*DDYSCREENW;
        _secondTableView.ddy_h = DDYSCREENH-64;
        _secondTableView.topView = self.headView;
    }
    return _secondTableView;
}

- (TestTableView *)thirdTableView
{
    if (!_thirdTableView)
    {
        _thirdTableView = [[TestTableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _thirdTableView.ddy_x = 2*DDYSCREENW;
        _thirdTableView.ddy_h = DDYSCREENH-64;
        _thirdTableView.topView = self.headView;
    }
    return _thirdTableView;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.navigationController.navigationBarHidden = (scrollView.contentOffset.y > 0);
    [self verticalScrollSetting];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self verticalScrollSetting];
    self.headView.selectedIndex = ceilf(scrollView.contentOffset.x / DDYSCREENW);
}

- (void)verticalScrollSetting
{
    CGFloat placeholderOffset = 0;
    if (self.headView.selectedIndex == 0)
    {
        if (self.firstTableView.contentOffset.y > self.headView.ddy_h - self.headView.BottomItemH)
        {
            placeholderOffset = self.headView.ddy_h - 40;
        }
        else
        {
            placeholderOffset = self.firstTableView.contentOffset.y;
        }
        [self.secondTableView setContentOffset:CGPointMake(0, placeholderOffset) animated:NO];
        [self.thirdTableView  setContentOffset:CGPointMake(0, placeholderOffset) animated:NO];
    }
    else if (self.headView.selectedIndex == 1)
    {
        if (self.secondTableView.contentOffset.y > self.headView.ddy_h - self.headView.BottomItemH)
        {
            placeholderOffset = self.headView.ddy_h - self.headView.BottomItemH;
        }
        else
        {
            placeholderOffset = self.secondTableView.contentOffset.y;
        }
        [self.firstTableView setContentOffset:CGPointMake(0, placeholderOffset) animated:NO];
        [self.thirdTableView setContentOffset:CGPointMake(0, placeholderOffset) animated:NO];
    }
    else if (self.headView.selectedIndex == 2)
    {
        if (self.thirdTableView.contentOffset.y > self.headView.ddy_h - self.headView.BottomItemH)
        {
            placeholderOffset = self.headView.ddy_h - self.headView.BottomItemH;
        }
        else
        {
            placeholderOffset = self.thirdTableView.contentOffset.y;
        }
        [self.firstTableView  setContentOffset:CGPointMake(0, placeholderOffset) animated:NO];
        [self.secondTableView setContentOffset:CGPointMake(0, placeholderOffset) animated:NO];
    }
}

@end
