//
//  FFAppDelegate.m
//  SmartMesh
//
//  Created by RainDou on 18/1/16.
//  Copyright © 2015年 RainDou All rights reserved.
//

#import "FFAppDelegate.h"
#import "FFTabBarController.h"
#import "FFLocalUserInfo.h"
#import "FFSignUpVC.h"
#import "FFLoginViewController.h"
#import "FFNavigationController.h"
#import "FFAccountViewController.h"
#import "FFWalletVC.h"
#import <Geth/Geth.h>
#import "FFUpdateAlert.h"

//#ifndef __OPTIMIZE__
//    #import "RRFPSBar.h"
//#endif

@interface FFAppDelegate ()<GethNewHeadHandler>
/** 无网社交管理器 */
@property (nonatomic, strong) FFMCManager *mcManager;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) BOOL hasGetTotalNum;

@property (nonatomic, assign) int64_t totalNum;

@property (nonatomic, strong) NSString *versionrl;

/** 记录失败时候,调用的次数 */
@property (nonatomic, assign) NSInteger count;

@end

@implementation FFAppDelegate

/** 异常捕获 */
void UncaughtExceptionHandler(NSException *exception) {
    NSArray  *callStackSymbols = [exception callStackSymbols];
    NSString *callStackSymbolStr = [callStackSymbols componentsJoinedByString:@"\n"];
    NSString *reason = [exception reason];
    NSString *name = [exception name];
    DDYInfoLog(@"异常名称：%@\n异常原因：%@\n堆栈标志：%@",name, reason, callStackSymbolStr);
}



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

//#ifndef __OPTIMIZE__
//    [[RRFPSBar sharedInstance] setHidden:NO];
//#endif
    
    /**-----------------App---------------------**/
    // 国际化
    [DDYLanguageTool sharedManager];
    // 初始化window
    [self prepareWindowSetting];
    // 添加监听通知
    [self addObserverNotification];
    // 异常捕获
    NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);
    // 判断登录状态
    [self judgeLoginStatus];
    // 去除角标
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;

    /**-----------------Wallet(轻钱包)---------------------**/
    
    if (NA_LIGHT_WALLET) {
        
        // 保存服务器和本地的时间戳差
        [self saveTimeDiff];
//        // 获得钱包
//        _wallet = [Wallet walletWithKeychainKey:@"io.ethers.sharedWallet"];
//        // 加载钱包相关数据
//        [self loadWallet];

    } else {
        
        /**-----------------新的 Wallet(轻节点)---------------------**/
        _hasGetTotalNum = NO;
        _totalNum = 0;
        // 1. 启动geth
        // 当前的正在同步或者同步完成时,下次启动依然同步最新的内容
        if ([[NSUserDefaults standardUserDefaults] integerForKey:SYNCHRONIZED] == 1 || [[NSUserDefaults standardUserDefaults] integerForKey:SYNCHRONIZED] == 2) {
            
            [self startNode:1];
        }
    }
    
    // 查看是否更新版本号
    [self isUpdateVersion];
    
    return YES;
}

#pragma mark -  无网钱包
#pragma mark 1. 启动geth(0 no sync, 1 syncing, 2 complete synchronously)
- (void)startNode:(NSInteger) state
{
    NSString *datadir = FFWalletUserPath;
    GethNodeConfig *config = GethNewNodeConfig();
    
    NSString *staticJson1 = [[datadir stringByAppendingPathComponent:@"iGeth"] stringByAppendingPathComponent:@"static-nodes.json"];
    
    NSString *staticJson =  @"[\"enode://77452c78f49488ee10897111278b82a1aaa4a1b74fcd110138c27468f0841a6e0aa103a7d8c946dd8ea82e1af6be7c5b2ba9befd0bc89ed58cdef1c59c215971@119.28.59.209:30303\"]";
    
    NSError *error1 = nil;
    
    BOOL isSuccess = [staticJson writeToFile:staticJson1 atomically:YES encoding:NSUTF8StringEncoding error:&error1];
    
    if (isSuccess) {
        NSLog(@"rdp写入成功");
    }
    
    // 测试
    if (!GLOBAL_SWITCH_OPEN) {
       
        [config setEthereumDatabaseCache:16];
        [config setEthereumEnabled:YES];
        [config setEthereumGenesis:GethTestnetGenesis()];
        [config setEthereumNetworkID:3];
    }
    
    NSError *error = nil;
    
    GethNode *node = GethNewNode(datadir, config, &error);
    [node start:&error];
    GethEthereumClient *ethereumClient = [node getEthereumClient:&error];
    
    if (state == 1) {
        [ethereumClient subscribeNewHead:GethNewContext() handler:self buffer:16 error:&error];
    }
    
    _ethereumClient = ethereumClient;
    
}

#pragma mark 2.GethNewHeadHandler
- (void)onError:(NSString*)failure
{
    
}

- (void)onNewHead:(GethHeader*)header
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        if (!_timer) {
            
            _timer = [NSTimer timerWithTimeInterval:2 target:self selector:@selector(getNum) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
            [[NSRunLoop currentRunLoop] run];
        }
    });
    
    
    
    
}

- (void)getNum
{
    
    NSError *error = nil;
    int64_t newValue = 0;
    newValue = [[_ethereumClient getHeaderByNumber:GethNewContext() number:-1 error:&error] getNumber];
    if (!_hasGetTotalNum) {
        
        GethSyncProgress *progress = [_ethereumClient syncProgress:GethNewContext() error:&error];
        if (progress) {
            
            _hasGetTotalNum = YES;
            _totalNum = [progress getHighestBlock];
        }
    }
    
    CGFloat rationF = newValue * 1.0 / _totalNum;
    
    NSString *ratio = LC_NSSTRING_FORMAT(@"%02f/%%", rationF * 100);
    [self postNotification:FFWalletBlockChainSynchroProgress withObject:ratio];
    
    if (newValue >= _totalNum) {
        
        
        // 更改同步的状态:同步完成
        [[NSUserDefaults standardUserDefaults] setInteger:2 forKey:SYNCHRONIZED];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        // 取消定时器;
        [_timer invalidate];
    }
    
}

- (void)saveTimeDiff
{
    // 获取服务器的时间戳;
    [self getServerTimeStamp:^(NSString *timeStamp) {
        
        NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
        
        NSString *s_cDiffTime = [NSString stringWithFormat:@"%f", [timeStamp doubleValue] - currentTime];
        
        // 保存该diff;
        [[NSUserDefaults standardUserDefaults] setObject:s_cDiffTime forKey:@"timeDiff"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }];
}

- (void)getServerTimeStamp:(void(^)(NSString *timeStamp))resultBlock
{
    [NANetWorkRequest na_getDataWithModule:@"account" action:@"systemTime" parameters:nil results:^(BOOL status, NSDictionary *result) {
        
        if (status) {
            
            NSString *serverTime = result[@"data"][@"time"];
            
            if (resultBlock) {
                resultBlock(serverTime);
            }
        }
        
    }];
}

- (void)loadWallet
{
    if (_wallet.activeAccount) {
        
        [self loginWalletSuccess];
    }
    else {
        
        [self needLoginWallet];
    }
}

#pragma mark - 进入钱包主界面
- (void)loginWalletSuccess
{
    // app 已经登录
    if ([self.window.rootViewController isKindOfClass:[FFTabBarController class]]) {
        
        FFTabBarController *tabBarVC = (FFTabBarController *)self.window.rootViewController;
        
        FFNavigationController *nav = (FFNavigationController *)tabBarVC.viewControllers[2];
        FFAccountViewController *accountVC = [FFAccountViewController vc];
        
        accountVC.tabBarItem.image = [[UIImage imageNamed:@"tabbar_wallet_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        accountVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabbar_wallet_selected_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        accountVC.tabBarItem.title = DDYLocalStr(@"WalletTab");
        
        nav.viewControllers = @[accountVC];
        
    }
}

#pragma mark - 上传当前钱包新(活跃)账户
- (void)uploadWalletActiveAccountToServer
{
    NSDictionary *params = @{
                             @"address": [WALLET.activeAccount.checksumAddress lowercaseString],
                             };
    
    [NANetWorkRequest na_postDataWithService:@"user" action:@"add_address" parameters:params results:^(BOOL status, NSDictionary *result) {
        
        if (status) {
            
            NSLog(@"上传钱包用户成功");
        }else {
            
            NSLog(@"上传钱包用户失败, 重新上传");
            if (_count < 3) {
                _count ++;
                
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    
                    [self uploadWalletActiveAccountToServer];
                });
                
            }else {
                _count = 0;
                return ;
            }
        }
        
    }];
}

#pragma mark - 进入钱包进行登录
- (void)needLoginWallet
{
    // app 已经登录
    if ([self.window.rootViewController isKindOfClass:[FFTabBarController class]]) {
        
        FFTabBarController *tabBarVC = (FFTabBarController *)self.window.rootViewController;
        
        FFNavigationController *nav = (FFNavigationController *)tabBarVC.viewControllers[2];
        
        FFWalletVC *walletVC = [FFWalletVC vc];
        walletVC.tabBarItem.image = [[UIImage imageNamed:@"tabbar_wallet_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        walletVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabbar_wallet_selected_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        walletVC.tabBarItem.title = DDYLocalStr(@"WalletTab");
        
        nav.viewControllers = @[walletVC];
        
    }
}

#pragma mark 设置window
- (void)prepareWindowSetting
{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = DDY_White;
    [self.window makeKeyAndVisible];
}

#pragma mark 添加监听通知
- (void)addObserverNotification {
    // 登录成功
    [self observeNotification:FFLoginSuccessdNotification];
    // 离线
    [self observeNotification:FFUserOffLineNotification];
    // token失效
    [self observeNotification:FFTokenInvalidNotification];
    
    // 钱包
    [self observeNotification:NALoginNotification];
    [self observeNotification:NAExitLoginNotification];
}

#pragma mark 启动后判断登录状态
- (void)judgeLoginStatus {
    
    [[FFLoginDataBase sharedInstance] openDB];
    [NSString ddy_blankString:[[FFLoginDataBase sharedInstance] activeUser]] ? [self needLogin] : [self loginSuccess];
}

#pragma mark - token过期，异地登录等
- (void)cleanToken
{
    // 清空token;
    [[FFLoginDataBase sharedInstance] logout];
    [[FFLoginDataBase sharedInstance] saveToken:nil];
    [[FFXMPPManager sharedManager] disconnect];
    
}

#pragma mark 需要登录(未登录，token过期，异地登录等)
- (void)needLogin {
    
    self.window.rootViewController = [[FFNavigationController alloc] initWithRootViewController:[FFLoginViewController vc]];
}

#pragma mark 登录成功
- (void)loginSuccess {
    dispatch_async(dispatch_get_main_queue(), ^{
        // 登录用户文件夹
        [FFFileManager createAllDirectory];
        // 打开聊天数据库
        [[FFChatDataBase sharedInstance] openDB];
        // 打开用户数据库
        [[FFUserDataBase sharedInstance] openDB];
        // 指定登录账户
        [FFLoginDataBase sharedInstance].loginUser = [[FFLoginDataBase sharedInstance] user];
        [FFLoginDataBase sharedInstance].loginUser.friend_log = @"-1";
        [[FFUserDataBase sharedInstance] saveUser:[FFLoginDataBase sharedInstance].loginUser];
        // 聊天管理器
        [FFChatManager sharedManager];
        // xmpp管理器 如果不存在token则视为无网
        if ([[FFLoginDataBase sharedInstance] activeUser] && ![NSString ddy_blankString:[FFLoginDataBase sharedInstance].loginUser.token]) {
            [[FFXMPPManager sharedManager] disconnect];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[FFXMPPManager sharedManager] connectWithUser:[FFLoginDataBase sharedInstance].loginUser];
            });
        }
        
        /* ** ** ** ** ** ** ** ** ** ** ** ** 更新钱包 *** ** ** ** ** ** ** ** ** ** ** ** ** ** */
        
        if (IOS_10_LATER) {
            
            NSString *keyChainKey = [[FFLoginDataBase sharedInstance].loginUser.localID ddy_MD5];
            // 获得钱包
            _wallet = [Wallet walletWithKeychainKey:keyChainKey];
            WALLET = _wallet;
            // 加载钱包相关数据
            [self loadWallet];
        }
    });
    
    // 切换主控制器
    self.window.rootViewController = [FFTabBarController vc];

}

#pragma mark 通知监听处理
- (void)handleNotification:(NSNotification *)notification
{
    
    if ([notification is:FFLoginSuccessdNotification]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            // 默认开启无网
            [[FFLoginDataBase sharedInstance] saveAppearOfflineSwitch:@"1"];
        });
        [self loginSuccess];
    } else if ([notification is:FFUserOffLineNotification]) {
        [self cleanToken];
        [self needLogin];
        
    } else if ([notification is:FFTokenInvalidNotification]) {
        [self needLogin];
        
    } else if ([notification is:NALoginNotification]) {
        [self loginWalletSuccess];
        [self uploadWalletActiveAccountToServer];
        DDYInfoLog(@"导入线程Appdelegate-----%@", [NSThread currentThread]);
    } else if ([notification is:NAExitLoginNotification]) {
        [self needLoginWallet];
    }
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // 挂起方法:按home,用这个方法去暂停正在执行的任务,中止定时器,减小OpenGL ES比率,暂停游戏
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{

}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // 进后台方法:减少共享资源,保存用户数据,销毁定时器,保存应用状态。
    // 后台任务标识
    __block UIBackgroundTaskIdentifier bgTask;
    // 结束后台任务
    void (^endBackgroundTask)() = ^(){
        [application endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    };
    
    bgTask = [application beginBackgroundTaskWithExpirationHandler:^{
        endBackgroundTask();
    }];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
      
        dispatch_async(dispatch_get_main_queue(), ^{
        
            // 记录后台任务开始时间
            double start_time = application.backgroundTimeRemaining;
            // 断开XMPP
            [[FFXMPPManager sharedManager] disconnect];
            
            // 记录后台任务结束时间
            double done_time = application.backgroundTimeRemaining;
            
            DDYLog(@"如果需要在这里后台备份，耗时: %f秒",start_time-done_time);
        });
        
        endBackgroundTask();
    });
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // 进前台方法
    // xmpp管理器 如果不存在token则视为无网
    if ([[FFLoginDataBase sharedInstance] activeUser] && ![NSString ddy_blankString:[FFLoginDataBase sharedInstance].loginUser.token]) {
        dispatch_async(dispatch_get_main_queue(), ^{
//            [[FFXMPPManager sharedManager] disconnect];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[FFXMPPManager sharedManager] connectWithUser:[FFLoginDataBase sharedInstance].loginUser];
            });
        });
    }
}

- (void)isUpdateVersion
{
// 测试弹窗
//    {
//        
//        FFUpdateAlert *alertV = [FFUpdateAlert alertView];
//        [alertV show:@"New Version(1.10) 新版上线" msg:@"哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈" coerce:NO];
//        alertV.updateBlock = ^() {
//            if (![NSString ddy_blankString:@"https://www.baidu.com"]) {
//                NSURL *url = [NSURL URLWithString:@"https://www.baidu.com"];
//                if ([[UIApplication sharedApplication] canOpenURL:url]) {
//                    [[UIApplication sharedApplication] openURL:url];
//                }
//            }
//        };
//    }
    
    NSDictionary *params = @{ @"currentversion" : [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] };
    
    [NANetWorkRequest na_postDataWithService:@"system" action:@"version" parameters:params results:^(BOOL status, NSDictionary *result) {
        
        
        if (status)
        {
            if (![NSString ddy_blankString:result[@"version"]]) {
                
                
                FFUpdateAlert *alertV = [FFUpdateAlert alertView];
                [alertV show:DDYStrFormat(@"%@ %@", result[@"msg"], result[@"version"]) msg:result[@"describe"] coerce:[LC_NSSTRING_FORMAT(@"%@", result[@"coerce"]) isEqualToString:@"1"]];
                alertV.updateBlock = ^() {
                    if (![NSString ddy_blankString:result[@"url"]]) { //@"https://itunes.apple.com/cn/app/jie-zou-da-shi/id493901993?mt=8";
                        NSURL *url = [NSURL URLWithString:result[@"url"]];
                        if ([[UIApplication sharedApplication] canOpenURL:url]) {
                            [[UIApplication sharedApplication] openURL:url];
                        }
                    }
                };
            } DDYInfoLog(@"%@", [result objectForKey:@"msg"]);
        }
    }];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // 复原方法:应用非活动状态时,重新启动已暂停(或尚未启动)的任务。
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // 当应用程序即将终止时调用。
}


+ (UIViewController *)rootViewController {
    return ((FFAppDelegate *)[UIApplication sharedApplication].delegate).window.rootViewController;
}

- (void)needLogin2
{
    FFSignUpVC * controller = [[FFSignUpVC alloc] init];
    controller.viewType = SignupType;
    UINavigationController * loginNav = [[UINavigationController alloc] initWithRootViewController:controller];
    self.window.rootViewController = loginNav;
}

- (void)loginSuccessfully
{
    FFTabBarController *vc = [[FFTabBarController alloc] init];
    self.window.rootViewController = vc;
}

@end
