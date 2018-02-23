//
//  FFGestureLockVC.m
//  FireFly
//
//  Created by SmartMesh on 18/1/29.
//  Copyright © 2018年 NAT. All rights reserved.
//

#import "FFGestureLockVC.h"
#import "FFGestureHeader.h"

@interface FFGestureLockVC ()<DDYLockViewDelegate, UINavigationControllerDelegate>
/** 头部视图 */
@property (nonatomic, strong) FFGestureHeader *header;
/** 底层容器 */
@property (nonatomic, strong) UIScrollView *scrollView;
/** 解锁九宫格 */
@property (nonatomic, strong) DDYLockView *lockView;
/** 钱包验证 */
@property (nonatomic, strong) FFWalletVerifyView *walletView;
/** 底部手势密码和钱包密码切换按钮 */
@property (nonatomic, strong) DDYButton *changeBtn;

@end

@implementation FFGestureLockVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // 头部视图
    [self setupTopView];
    // 中部视图
    [self setupMidView];
    // 不同类型
    [self setupDifferentUI];
}

#pragma mark 顶部视图 缩略图或钱包信息
- (void)setupTopView {
    _header = [FFGestureHeader headerType:self.lockType];
    _header.viewAddToView(self.view);
}

#pragma mark 中部视图 九宫格或钱包内容
- (void)setupMidView {
    // 底层scrollView
    _scrollView = UIScrollViewNew.scroll_viewContentSize(2*DDYSCREENW, DDYSCREENW-30).scroll_viewScrollEnabled(NO);
    _scrollView.viewSetFrame(0,_header.ddy_bottom,DDYSCREENW,DDYSCREENW-30).viewBGColor(FFBackColor).viewAddToView(self.view);
    // 解锁九宫格
    _lockView = [DDYLockView lockViewWithType:self.lockType];
    _lockView.delegate = self;
    _lockView.viewAddToView(_scrollView).viewSetCenter(_scrollView.ddy_w/2, _scrollView.ddy_h/2);
    // 钱包验证
    _walletView = [FFWalletVerifyView verifyView];
    _walletView.viewAddToView(_scrollView).viewSetX(DDYSCREENW);
    __weak __typeof__ (self)weakSelf = self;
    _walletView.walletVerifyBlock = ^(BOOL isOk) {
        if (isOk) {
            if (weakSelf.lockType == DDYLockViewTypeVerify) [weakSelf verifyFinish];
            else if (weakSelf.lockType == DDYLockViewTypeLogin) [weakSelf loginFinish];
        } else {
            [weakSelf.header showWarningAndShake:DDYLocalStr(@"GestureWalletError")];
        }
    };
}

#pragma mark 底部视图 切换按钮
- (void)setupBottomView {
    // 切换按钮
    _changeBtn = DDYButtonNew.btnTitleN(DDYLocalStr(self.lockType==DDYLockViewTypeLogin?@"GestureLoginChange":@"GestureCloseChange"));
    _changeBtn.btnTitleColorN(FF_MAIN_COLOR).btnFrame(0,self.view.ddy_h-45,DDYSCREENW,40).btnAction(self,@selector(changeWay:));
    _changeBtn.btnFont(DDYFont(14)).btnSuperView(self.view).contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
}

#pragma mark UI不同部分
- (void)setupDifferentUI {
    switch (self.lockType) {
        case DDYLockViewTypeSetting:
        {
            self.navigationItem.title = lockTitleSetting;
            self.lockView.type = self.lockType;
            [_header showNormalMsg:DDYLocalStr(@"GestureSet")];
        }
            break;
        case DDYLockViewTypeLogin:
        {
            self.navigationItem.title = lockTitleLogin;
            [_header showNormalMsg:DDYLocalStr(@"GestureVerify")];
            // 底部视图
            [self setupBottomView];
        }
            break;
        case DDYLockViewTypeVerify:
        {
            self.navigationItem.title = lockTitleVerify;
            [_header showNormalMsg:DDYLocalStr(@"GestureVerify")];
            // 底部视图
            [self setupBottomView];
        }
            break;
    }
}

#pragma mark 清空第一个密码【登录验证都第二个(不关心第一个),设置从第一个开始(此时第一个为空)】
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    DDYUserDefaultsSet(nil, lockOneKey);
}

#pragma mark DDYLockViewDelegate and UINavigationControllerDelegate
- (void)lockView:(DDYLockView *)lockView state:(DDYLockViewState)state {
    switch (state) {
        case DDYLockViewStateLess:
            [_header showWarningAndShake:DDYLocalStr(@"GestureLess")];
            break;
        case DDYLockViewStateFirstFinish:
            [_header infoViewSelectedSameAsLockView:lockView andShowNormalMsg:DDYLocalStr(@"GestureAgain")];
            break;
        case DDYLockViewStateSecondFinish:
            [self settingFinish];
            break;
        case DDYLockViewStateSecondError:
            [_header infoViewDeselectedAllCircleAndShowMsg:DDYLocalStr(@"GestureAgainError")];
            break;
        case DDYLockViewStateLoginFinish:
            [self loginFinish];
            break;
        case DDYLockViewStateLoginError:
            [_header showWarningAndShake:DDYLocalStr(@"GestureVerifyError")];
            break;
        case DDYLockViewStateVerifyFinish:
            [self verifyFinish];
            break;
        case DDYLockViewStateVerifyError:
            [_header showWarningAndShake:DDYLocalStr(@"GestureVerifyError")];
            break;
    }
}

#pragma mark 设置手势完成 回调设置开关状态 控制器返回
- (void)settingFinish {
    [_header showNormalMsg:DDYLocalStr(@"GestureSuccess")];
    if (self.gestureLockBlock) {
        self.gestureLockBlock(YES);
    }
    if (![self.navigationController popViewControllerAnimated:YES]) {
        [self dismissViewControllerAnimated:YES completion:^{ }];
    }
}

#pragma mark 登录通过 tabbar切换 控制器返回
- (void)loginFinish {
    if (self.gestureLockBlock) {
        self.gestureLockBlock(YES);
    }
    if (![self.navigationController popViewControllerAnimated:YES]) {
        [self dismissViewControllerAnimated:YES completion:^{ }];
    }
}

#pragma mark 验证通过清除手势 回调设置开关状态 控制器返回
- (void)verifyFinish {
    DDYUserDefaultsSet(nil, lockEndKey);
    if (self.gestureLockBlock) {
        self.gestureLockBlock(NO);
    }
    if (![self.navigationController popViewControllerAnimated:YES]) {
        [self dismissViewControllerAnimated:YES completion:^{ }];
    }
}

#pragma mark 切换登录(验证取消)方式
- (void)changeWay:(DDYButton *)sender {
    if ((sender.selected = !sender.selected)) {
        _changeBtn.btnTitleN(DDYLocalStr(self.lockType==DDYLockViewTypeLogin?@"GestureWalletLogin":@"GestureWalletClose"));
        _scrollView.contentOffset = CGPointMake(DDYSCREENW, 0);
    } else {
        _changeBtn.btnTitleN(DDYLocalStr(self.lockType==DDYLockViewTypeLogin?@"GestureLoginChange":@"GestureCloseChange"));
        _scrollView.contentOffset = CGPointMake(0, 0);
    }
     [_header changeToWallet:sender.isSelected];
}

@end
