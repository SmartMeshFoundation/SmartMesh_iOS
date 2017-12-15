//
//  FFGroupMemberListVC.m
//  SmartMesh
//
//  Created by Megan on 2017/12/15.
//  Copyright © 2017年 SmartMesh Foundation All rights reserved.
//

#import "FFGroupMemberListVC.h"
#import "FFNewFriendsTableViewCell.h"

@interface FFGroupMemberListVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)NSMutableArray * membersArray;

@end

@implementation FFGroupMemberListVC

-(instancetype)initWithArray:(NSMutableArray *)array{
    
    if (self = [super init]) {
    
        self.membersArray = array;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title = @"Group member list";
    
}

-(void)buildUI
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, DDYSCREENW, DDYSCREENH - 64)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}

#pragma mark -- tableView delegate
#pragma mark --

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FFNewFriendsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"groupMemberListCell"];
    
    if (!cell) {
        cell = [[FFNewFriendsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"groupMemberListCell"];
    }
    
    cell.user = self.membersArray[indexPath.row];
    
    return cell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.membersArray.count;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


@end
