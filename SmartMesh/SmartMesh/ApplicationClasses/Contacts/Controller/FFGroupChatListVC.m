//
//  FFGroupChatListVC.m
//  SmartMesh
//
//  Created by Megan on 2017/12/15.
//  Copyright © 2017年 SmartMesh Foundation All rights reserved.
//

#import "FFGroupChatListVC.h"
#import "UINavigationController+LCExtension.h"
#import "FFGroupListCell.h"
#import "FFChatViewController.h"
#import "FFGroupModel.h"
#import "FFAddressListVC.h"
#import "FFNavigationController.h"
#import "FFChatGroup.h"

@interface FFGroupChatListVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UIBarButtonItem * _anotherButton;
}
@property(nonatomic,strong) UITableView    * tableView;
@property(nonatomic,retain) NSMutableArray * groups;

@end

@implementation FFGroupChatListVC

-(void) dealloc
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];//可以成功取消全部。
    [[self class] cancelPreviousPerformRequestsWithTarget:self];
    
    [self unobserveAllNotifications];
}

- (NSMutableArray *)groups
{
    if (!_groups) {
        _groups = [NSMutableArray array];
    }
    return _groups;
}

-(instancetype) initWithSelectMode
{
    if (self = [super init]) {
     
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, DDYSCREENW, DDYSCREENH - 64)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = UIViewNew;
//    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        self.groups = [[FFUserDataBase sharedInstance] selectGroupsFromRange:NSMakeRange(0, 100)];
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            [self.tableView reloadData];
            
        });
    });
    
    [self observeNotification:@"UpdateMygroupListNotification"];
}

-(void) buildUI
{
    self.title = @"Group chat";
    
    _anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"创建" style:UIBarButtonItemStylePlain target:self action:@selector(builtGroupChat)];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItem = _anotherButton;

    // Left button.
    if (self.presentingViewController && self.navigationController.rootViewController == self) {
        
        _anotherButton.labText(@"取消");
    }
    else{
        
        _anotherButton.imgAddImg([UIImage imageNamed:@""], LC_RECT(0, 0, 40, 40));
    }
    
    self.tableView.backgroundColor = LC_RGB(238, 238, 238);
    
}

-(void)builtGroupChat
{
    FFAddressListVC *contactsVC = [FFAddressListVC vc];
    contactsVC.selectType = FFGroupChatType;
    contactsVC.seletedUsersBlock = ^(NSMutableArray<FFUser *> *users) {
      
        if (users.count == 1) {
            
            // 进入单聊
            [self pushSingleChat:[users lastObject]];
            
        }else if (users.count > 1) {
            
            // 创建群聊
            
            [self createGroupChat:users];
        }
    };
    
    FFNavigationController *nav = [[FFNavigationController alloc] initWithRootViewController:contactsVC];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - 进入单聊
- (void)pushSingleChat:(FFUser *)user
{
    FFChatViewController * controller = [[FFChatViewController alloc] init];
    [controller chatUID:user.localid chatType:FFChatTypeSingle groupName:user.nickName];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - 创建群聊
- (void)createGroupChat:(NSArray *)users
{
    NSMutableString * uids = [NSMutableString string];
    NSMutableString * names = [NSMutableString string];
    
    [names appendString:LC_NSSTRING_FORMAT(@"%@、", [FFLoginDataBase sharedInstance].loginUser.remarkName)];
    
    for (int i = 0;i <users.count; i++) {
        
        FFUser * user = users[i];
        
        if (i == users.count - 1) {
            
            [uids appendString:LC_NSSTRING_FORMAT(@"%@", user.localid)];
            [names appendString:LC_NSSTRING_FORMAT(@"%@", user.remarkName)];
        }
        else{
            [uids appendString:LC_NSSTRING_FORMAT(@"%@,", user.localid)];
            [names appendString:LC_NSSTRING_FORMAT(@"%@、",user.nickName)];
        }
    }
    
    NSDictionary *params = @{
                             @"tolocalids"  : uids,
                             @"name"        : names,
                             };
    
    [NANetWorkRequest na_postDataWithService:@"conversation" action:@"create_conversation" parameters:params results:^(BOOL status, NSDictionary *result) {
        
        if (status) {
        
            NSString *groupId = [result[@"cid"] stringValue];
            
            FFGroupModel *group = [[FFGroupModel alloc] init];
            group.groupName  = names;
            group.cid        = groupId;
            group.localID    = [FFLoginDataBase sharedInstance].loginUser.localID;
            group.memberList = [users mutableCopy];
        
            
            // 更新群聊列表
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                // 缓存该群记录
                [[FFUserDataBase sharedInstance] saveGroup:group];
                
                [self loadData];
            });
            
            // 进入群组聊天
            FFChatGroup * chatGroup = [[FFChatGroup alloc] init];
            chatGroup.groupid = groupId;
            chatGroup.groupName = names;
            [self pushGroupChatWithGroupId:chatGroup];
            
        }else {
        }
    
    }];
}

#pragma mark - 进入群组聊天
- (void)pushGroupChatWithGroupId:(FFChatGroup *)group
{
    FFChatViewController * controller = [[FFChatViewController alloc] init];
    [controller chatUID:group.groupid chatType:FFChatTypeGroup groupName:group.groupName];
    [self.navigationController pushViewController:controller animated:YES];
}


#pragma mark -- tableView delegate
#pragma mark --

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FFGroupListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"groupListCell"];
    
    if (!cell) {
        cell = [[FFGroupListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"groupListCell"];
    }
    
    cell.group = [self.groups objectAtIndex:indexPath.row];
    
    return cell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.groups.count;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    FFGroupModel * group = [self.groups objectAtIndex:indexPath.row];
    
    FFChatViewController * groupChatVC = [[FFChatViewController alloc] init];
    groupChatVC.type = FFChatVCTypeGroupChat;
    
    [groupChatVC chatUID:group.cid chatType:FFChatTypeGroup groupName:group.groupName];
    [self.navigationController pushViewController:groupChatVC animated:YES];
    
}

- (void)loadData
{
    [FFLocalUserInfo LCInstance].isSignUp = YES;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [NANetWorkRequest na_postDataWithService:@"conversation" action:@"get_conversation" parameters:nil results:^(BOOL status, NSDictionary *result) {
            
            if (status) {
                
                NSArray * allData = [result objectForKey:@"data"];
                
                [self.groups removeAllObjects];
                
                for (NSDictionary *dict in allData)
                {
                    FFGroupModel * group = [FFGroupModel groupWithDict:dict];
                    [self.groups addObject:group];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.tableView reloadData];
                });
                
                
                for (FFGroupModel *group in [self.groups copy]) {
                    
                    [[FFUserDataBase sharedInstance] saveGroup:group];
                }
                
                NSLog(@"==群聊列表请求成功==");
            }
            else
            {
                NSLog(@"==网络异常==");
            }
            
        }];
        
    });
    
    
}

@end
