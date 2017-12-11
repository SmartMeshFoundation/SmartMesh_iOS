//
//  FFChatsVC.m
//  SmartMesh
//
//  Created by Rain on 17/12/11.
//  Copyright © 2017年 SmartMesh Foundation All rights reserved.
//

#import "FFChatsVC.h"
#import "FFHomeChatsCell.h"
#import "FFChatViewController.h"
#import "XMPPStream.h"
#import "NRSA.h"
#import "LC_Network.h"
#import "FFSecurityDetailVC.h"
#import "NirKxMenu.h"
#import "FFAddFriendsVC.h"
#import "FFAddressListVC.h"
#import "FFNewFriendsViewController.h"

#define ALPHANUM @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"

@interface FFChatsVC ()<UIViewControllerPreviewingDelegate,UITextFieldDelegate>
{
    UITextField * _fidfiled;
    UIView      * _header;
}
@property (nonatomic, strong) NSMutableArray *chatsArray;

@end

@implementation FFChatsVC

- (NSMutableArray *)chatsArray {
    if (!_chatsArray) {
        _chatsArray = [NSMutableArray array];
    }
    return _chatsArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = FFBackColor;
    self.tableView.tableFooterView = [UIView new];
    if (![[LC_Network LCInstance] noNetWork] && [NSString ddy_blankString:[FFLoginDataBase sharedInstance].loginUser.token]) {
        [self registerView];
    }
    [self observeNotification:@"NetworkReachabilityChangedNotification"];
    [self observeNotification:FFRefreshHomePageNotification];
    
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_navigationBar_add"] style:UIBarButtonItemStylePlain target:self action:@selector(addButtonOnClicked:)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
//    UITabBarItem *item = [self.tabBarController.tabBar.items objectAtIndex:0];
//    item.badgeValue = LC_NSSTRING_FORMAT(@"%zi", [[FFUserDataBase sharedInstance] getRecentChatunreadNumber]);

    
    // 无网管理器
    [[FFMCManager sharedManager] initWithUser:[FFLoginDataBase sharedInstance].loginUser];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadRecentChatList];
}

-(void)addButtonOnClicked:(UIBarButtonItem *)sender
{
    // 配置零：内容配置
    NSArray *menuArray = @[[KxMenuItem menuItem:@"Add buddy" image:nil target:self action:@selector(pushMenuItem:)],
                           [KxMenuItem menuItem:@"Group chats" image:nil target:self action:@selector(pushMenuItem:)]];
    // 配置一：基础配置
    [KxMenu setTitleFont:[UIFont fontWithName:@"HelveticaNeue" size:15]];
    // 配置二：拓展配置
    OptionalConfiguration options = {  .arrowSize =  9,  //指示箭头大小
        .marginXSpacing =  7,  //MenuItem左右边距
        .marginYSpacing =  9,  //MenuItem上下边距
        .intervalSpacing =  25,  //MenuItemImage与MenuItemTitle的间距
        .menuCornerRadius =  6.5,  //菜单圆角半径
        .maskToBackground =  true,  //是否添加覆盖在原View上的半透明遮罩
        .shadowOfMenu =  false,  //是否添加菜单阴影
        .hasSeperatorLine =  true,  //是否设置分割线
        .seperatorLineHasInsets =  false,  //是否在分割线两侧留下Insets
        .textColor =  {.R= 0, .G= 0, .B= 0},  //menuItem字体颜色
        .menuBackgroundColor =  {.R= 1, .G= 1, .B= 1,.A = 1}  //菜单的底色
    };
    
    CGRect frame = CGRectMake(DDYSCREENW - 50, 64 , 30, 0);
    // 菜单展示
    [KxMenu showMenuInView:([UIApplication sharedApplication].keyWindow) fromRect:frame menuItems:menuArray withOptions:options];
}

- (void)pushMenuItem:(KxMenuItem *)sender
{
    if ([sender.title isEqualToString:@"Add buddy"])
    {
        FFAddFriendsVC * controller = [[FFAddFriendsVC alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if ([sender.title isEqualToString:@"Group chats"])
    {
        FFAddressListVC *conroller = [[FFAddressListVC alloc] init];
        conroller.selectType = FFGroupChatType;
        [self.navigationController pushViewController:conroller animated:YES];
    }
}


- (void)registerView
{
    _header = [[UIView alloc] initWithFrame:LC_RECT(0, 0, DDYSCREENW, 50)];
    _header.backgroundColor = APP_MAIN_COLOR;
    [_header addTapTarget:self action:@selector(headerAction)];
    self.tableView.tableHeaderView = _header;
    
    UILabel * tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, DDYSCREENW - 40, 50)];
    tipsLabel.text = @"为了账户安全请填写FID,以保证正常登录";
    tipsLabel.font = NA_FONT(14);
    tipsLabel.textColor = LC_RGB(51, 51, 51);
    [_header addSubview:tipsLabel];

}

- (void)headerAction
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: nil
                                                                              message: @"为了账户安全请填写FID,以保证正常登录"
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Digital + letter combinations";
        textField.textColor = [UIColor blueColor];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSArray * textfields = alertController.textFields;
        _fidfiled = textfields[0];
        _fidfiled.delegate = self;
        _fidfiled.keyboardType = UIKeyboardTypeASCIICapable;
        
        [[FFLoginDataBase sharedInstance] saveMid:_fidfiled.text];
        
        if (_fidfiled.text.length < 6 || _fidfiled.text.length > 20) {
            
            MBProgressHUD *hud = [self showHudWithText:@"fid应在6到20位以内"];
            [hud hideAnimated:YES afterDelay:1];
            return ;
        }
        else
        {
            [self loadRegisterData:_fidfiled.text];
        }
    
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)loadRegisterData:(NSString * )mid
{
    NSDictionary * params = @{@"mid": _fidfiled.text,
                              @"password":[FFLoginDataBase sharedInstance].loginUser.passwrod,
                              @"localid":[FFLoginDataBase sharedInstance].loginUser.localID,
                              @"username":[FFLoginDataBase sharedInstance].loginUser.nickName,
                              };
     
    [NANetWorkRequest na_postDataWithService:@"user" action:@"register" parameters:params results:^(BOOL status, NSDictionary *result) {
        
        if (status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"===== 注册成功 ====");
                DDYInfoLog(@"注册信息:\n%@",result);
                // 更新数据库token
                [[FFLoginDataBase sharedInstance] saveToken:result[@"token"]];
                // 更新数据库uid
                [[FFLoginDataBase sharedInstance] saveUID:result[@"uid"]];
                // xmpp管理器 如果不存在token则视为无网
                if (![NSString ddy_blankString:[FFLoginDataBase sharedInstance].loginUser.token] && ![NSString ddy_blankString:[FFLoginDataBase sharedInstance].loginUser.uid]) {
                    [[FFXMPPManager sharedManager] connectWithUser:[FFLoginDataBase sharedInstance].loginUser];
                }
                
                [FFLocalUserInfo LCInstance].isSignUp = YES;
                self.tableView.tableHeaderView = UIViewNew;
                
                UIAlertController * alertController = [UIAlertController alertControllerWithTitle: nil
                                                                                          message: LC_NSSTRING_FORMAT(@"您的MID是%@是否进行账户安全升级,绑定手机号或邮箱?",mid)
                                                       
                                                                                   preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"跳过" style:UIAlertActionStyleCancel handler:nil];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"绑定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    FFSecurityDetailVC * controller = [[FFSecurityDetailVC alloc] init];
                    [self.navigationController pushViewController:controller animated:YES];
                }];
                [alertController addAction:cancelAction];
                [alertController addAction:okAction];
                [self presentViewController:alertController animated:YES completion:nil];
                
            });
        }
    }];
}

-(void)handleNotification:(NSNotification *)notification
{
    if ([notification is:@"NetworkReachabilityChangedNotification"]) {
        
        if (![[LC_Network LCInstance] noNetWork] && [NSString ddy_blankString:[FFLoginDataBase sharedInstance].loginUser.token]) {
          [self registerView];
        }
    } else if ([notification is:FFRefreshHomePageNotification]) {
         [self loadRecentChatList];
    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section==0 ? 1 : self.chatsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FFHomeChatsCell *cell = [FFHomeChatsCell cellWithTableView:tableView];
    cell.recentModel = indexPath.section==0 ? [[FFUserDataBase sharedInstance] getEveryoneModel] : self.chatsArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    FFRecentModel *recentModel = indexPath.section==0 ? [[FFUserDataBase sharedInstance] getEveryoneModel] : self.chatsArray[indexPath.row];
    if (recentModel.chatType == FFChatTypeSystem) { // type = 0 好友请求
        FFNewFriendsViewController *newFriendsVC = [[FFNewFriendsViewController alloc] init];
        [self.navigationController pushViewController:newFriendsVC animated:YES];
    } else {
        FFChatViewController *vc = [FFChatViewController vc];
        [vc chatUID:recentModel.remoteID chatType:recentModel.chatType groupName:recentModel.remarkName];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark 置顶、删除
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section==0 ? NO : YES;
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:DDYLocalStr(@"Delete") handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        FFRecentModel *recentModel = self.chatsArray[indexPath.row];
        [[FFChatManager sharedManager] deleteRecentChat:recentModel.remoteID chatType:recentModel.chatType];
        [self loadRecentChatList];
    }];
    return @[deleteAction];
}

- (void)loadRecentChatList
{
    self.tableView.editing = NO;
    self.chatsArray = [NSMutableArray array];
    self.chatsArray = [[FFUserDataBase sharedInstance] selectRecentChat];
    [self.tableView reloadData];
    [self changeTabbarUnreadNumber];
}

- (void)changeTabbarUnreadNumber {
    NSInteger unread = 0;
    for (FFRecentModel *recentModel in self.chatsArray) {
        unread = unread + recentModel.unread;
    }
    DDYInfoLog(@"未读未读：%ld",(long)unread);
    self.tabBarItem.badgeValue = unread<1 ? nil : unread>99 ? DDYStrFormat(@"99+") : DDYStrFormat(@"%ld", (long)unread);
    
}

@end
