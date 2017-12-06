//
//  FFMeVC.m
//  SmartMesh
//
//  Created by Rain on 17/9/19.
//  Copyright © 2017年 SmartMesh Foundation All rights reserved.
//

#import "FFMeVC.h"
#import "FFMeHeader.h"
#import "FFLoginViewController.h"
#import "FFSettingVC.h"
#import "FFEditUserInfoVC.h"
#import "FFSecurityDetailVC.h"
#import "FFBlackListVC.h"
#import "FFUser.h"
#import "AFHTTPSessionManager.h"
#import "XMPPStream.h"

static NSString *cellID = @"FFMeVCCellID";

@interface FFMeVC ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) FFMeHeader *headerView;

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) NSArray *iconArray;

@end

@implementation FFMeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    [self requestUserInfo];
}

- (void)prepare {
    [super prepare];
    _dataArray = @[@[@"Security"],@[@"Setting"]];
}

- (void)setupTableView
{
    _tableView = [[UITableView alloc] initWithFrame:DDYRect(0, 64, DDYSCREENW, DDYSCREENH-64-49)];
    [self.view addSubview:_tableView];
    _tableView.backgroundColor = DDY_ClearColor;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    _headerView = [FFMeHeader headView];
    _tableView.tableHeaderView = _headerView;
    
    __weak __typeof__ (self)weakSelf = self;
    _headerView.tatBlock = ^(id value){
        FFEditUserInfoVC * controller = [[FFEditUserInfoVC alloc] init];
        [weakSelf.navigationController pushViewController:controller animated:YES];
    };
    
}

#pragma mark - UITableViewDataSource
#pragma mark NumberOfSections
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArray.count;
}

#pragma mark NumberOfRows
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *itemArray = _dataArray[section];
    return itemArray.count;
}

#pragma mark CellForRow
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *itemArray = _dataArray[indexPath.section];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    NSLocalizedString(@"", nil);
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: cellID];
    }
    
    if (indexPath.section == 0) {
        cell.imageView.image = [UIImage imageNamed:@"user_info_wallet.png"];
    }
    else if (indexPath.section == 1)
    {
        cell.imageView.image = [UIImage imageNamed:@"user_info_setting.png"];
    }

    cell.textLabel.text = DDYLocalStr(itemArray[indexPath.row]);
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 48;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        FFSecurityDetailVC * controller = [[FFSecurityDetailVC alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    } else {
        [self.navigationController pushViewController:[FFSettingVC vc] animated:YES];
    }
}

#pragma mark - 去分割线15像素
- (void)viewDidLayoutSubviews {
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)requestUserInfo
{
    [FFLocalUserInfo LCInstance].isUser = YES;
    [FFLocalUserInfo LCInstance].isSignUp = YES;

    NSString * localID = [FFLoginDataBase sharedInstance].loginUser.localID;
    
    [NANetWorkRequest na_postDataWithService:@"user" action:@"userinfo" parameters:@{@"localid":localID} results:^(BOOL status, NSDictionary *result) {

        if (status) {
            NSDictionary * dict = [result objectForKey:@"data"];
            FFUser * user = [FFUser userWithDict:dict];
            [_headerView loadHeaderData:user];
            [FFLocalUserInfo LCInstance].isUser = NO;
        }
    }];

}

@end
