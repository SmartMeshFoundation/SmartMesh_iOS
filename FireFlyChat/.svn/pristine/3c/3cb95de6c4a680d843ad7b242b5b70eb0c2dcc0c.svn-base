//
//  TestTableView.m
//  DDYProject
//
//  Created by LingTuan on 17/7/26.
//  Copyright © 2017年 Starain. All rights reserved.
//

#import "TestTableView.h"

@interface TestTableView ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation TestTableView

- (void)setTopView:(TableTopHeaderView *)topView
{
    _topView = topView;
    
    self.dataSource = self;
    self.delegate = self;
    self.scrollIndicatorInsets = UIEdgeInsetsMake(self.topView.ddy_h, 0, 0, 0);
    self.tableHeaderView = UIViewNew.viewSetFrame(0, 0, DDYSCREENW, self.topView.ddy_h);
    self.tableFooterView = [UIView new];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return (section == 2) ? 0.1 : 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellID = @"reuseFirstTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld--%ld", (long)indexPath.section, (long)indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DDYLog(@"didSelect:%ld--%ld",(long)indexPath.section, (long)indexPath.row);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat topViewContentH = self.topView.ddy_h - self.topView.BottomItemH;
    
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (offsetY >= 0 && offsetY <= topViewContentH)
    {
        self.topView.ddy_y = -offsetY;
    }
    else if (offsetY > topViewContentH)
    {
        self.topView.ddy_y = -topViewContentH;
    }
    else if (offsetY <0)
    {
        self.topView.ddy_y =  -offsetY;
    }
}

@end
