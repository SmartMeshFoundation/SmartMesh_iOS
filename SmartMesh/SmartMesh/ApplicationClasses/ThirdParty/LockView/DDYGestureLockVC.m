//
//  DDYGestureLockVC.m
//  SmartMesh
//
//  Created by Rain on 18/1/26.
//  Copyright © 2018年 SmartMesh Foundation All rights reserved.
//

#import "DDYGestureLockVC.h"
#import "AvatarImg.h"

@interface DDYGestureLockVC ()<DDYLockViewDelegate, UINavigationControllerDelegate>

/** 底层容器 */
@property (nonatomic, strong) UIScrollView *scrollView;
/** 解锁九宫格 */
@property (nonatomic, strong) DDYLockView *lockView;
/** TypeLogin手势缩略图 */
@property (nonatomic, strong) DDYLockInfoView *infoView;
/** 连线提示文字 */
@property (nonatomic, strong) UILabel *tipLabel;

@end

@implementation DDYGestureLockVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSameUI];
    [self setupDifferentUI];
}

#pragma mark UI相同部分
- (void)setupSameUI {
    // 底层scrollView
    _scrollView = UIScrollViewNew.scroll_viewContentSize(2*DDYSCREENW, DDYSCREENH).scroll_viewScrollEnabled(NO);
    _scrollView.viewSetFrame(0,SafeAreaTopHeight,DDYSCREENW,DDYSCREENH-SafeAreaTopHeight).viewBGColor(DDY_White).viewAddToView(self.view);
    // 解锁九宫格
    _lockView = [DDYLockView lockViewWithType:self.lockType];
    _lockView.delegate = self;
    [_scrollView addSubview:_lockView];
    // 手势九宫格中心
    self.lockView.center = DDYPoint(DDYSCREENW*0.5, DDYSCREENH*(self.lockType==DDYLockViewTypeSetting ? 0.45 : 0.55));
    // 提示文字
    _tipLabel = UILabelNew.labFont(DDYFont(14)).labAlignmentCenter();
    [_scrollView addSubview:_tipLabel.viewSetFrame(0,0,DDYSCREENW,16).viewSetCenterY(_lockView.ddy_y-16)];
}

#pragma mark UI不同部分
- (void)setupDifferentUI {
    switch (self.lockType) {
        case DDYLockViewTypeSetting:
            [self setupViewTypeSetting];
            break;
        case DDYLockViewTypeLogin:
            [self setupViewTypeLogin];
            break;
        case DDYLockViewTypeVerify:
            [self setupViewTypeVerify];
            break;
    }
}

#pragma mark 设置模式界面
- (void)setupViewTypeSetting {
    self.navigationItem.title = lockTitleSetting;
    self.lockView.type = self.lockType;
    [self showNormalMsg:DDYLocalStr(@"GestureSet")];
    _infoView = [DDYLockInfoView infoViewWithFrame:DDYRect(0, 0, 1.2*circleRadius, 1.2*circleRadius)];
    _infoView.center = DDYPoint(DDYSCREENW/2, _tipLabel.ddy_y - _infoView.ddy_h/2-10);
    [_scrollView addSubview:_infoView];
}

#pragma mark 登录模式界面
- (void)setupViewTypeLogin {
    self.navigationItem.title = lockTitleLogin;
    [self setupLoginAndVerifySameUI];
}

#pragma mark 验证模式界面
- (void)setupViewTypeVerify {
    self.navigationItem.title = lockTitleVerify;
    [self setupLoginAndVerifySameUI];
}

- (void)setupLoginAndVerifySameUI {
    // 钱包地址
    UILabel *addressLab = UILabelNew.labFont(DDYFont(13)).labText(WALLET.activeAccount.checksumAddress).labAlignmentCenter();
    addressLab.lineBreakMode = NSLineBreakByTruncatingMiddle;
    [_scrollView addSubview:addressLab.labTextColor(DDY_Mid_Black).viewSetFrame(15,_tipLabel.ddy_y-28, DDYSCREENW-30, 15)];
    // 钱包昵称
    UILabel *nameLab = UILabelNew.labFont(DDYFont(14)).labText([WALLET nicknameForAccount:WALLET.activeAccount]).labAlignmentCenter();
    [_scrollView addSubview:nameLab.labTextColor(DDY_Mid_Black).viewSetFrame(15, addressLab.ddy_y-25, DDYSCREENW-30, 16)];
    // 钱包头像
    DDYHeader *header = [DDYHeader headerWithHeaderWH:60];
    header.center = DDYPoint(DDYSCREENW/2, nameLab.ddy_y-15-30);
    header.imgArray = @[[AvatarImg avatarImgFromAddress:WALLET.activeAccount]];
    header.urlArray = @[@""];
    [_scrollView addSubview:header];
    // 提示请输入手势密码
    [self showNormalMsg:DDYLocalStr(@"GestureVerify")];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 清空第一个密码【登录验证都第二个(不关心第一个),设置从第一个开始(此时第一个为空)】
    DDYUserDefaultsSet(nil, lockOneKey);
}

#pragma mark DDYLockViewDelegate and UINavigationControllerDelegate
- (void)lockView:(DDYLockView *)lockView state:(DDYLockViewState)state {
    switch (state) {
        case DDYLockViewStateLess:
        {
            [self showWarningAndShake:DDYLocalStr(@"GestureLess")];
        }
            break;
        case DDYLockViewStateFirstFinish:
        {
            [self showNormalMsg:DDYLocalStr(@"GestureAgain")];
            [self infoViewSelectedSameAsLockView:lockView];
        }
            break;
        case DDYLockViewStateSecondFinish:
        {
            [self showNormalMsg:DDYLocalStr(@"GestureSuccess")];
            if (self.gestureLockBlock) {
                self.gestureLockBlock(YES);
            }
            if (![self.navigationController popViewControllerAnimated:YES]) {
                [self dismissViewControllerAnimated:YES completion:^{ }];
            }
        }
            break;
        case DDYLockViewStateSecondError:
        {
            [self showWarningAndShake:DDYLocalStr(@"GestureAgainError")];
            [self infoViewDeselectedAllCircle];
        }
            break;
        case DDYLockViewStateLoginFinish:
        {
            if (![self.navigationController popViewControllerAnimated:YES]) {
                [self dismissViewControllerAnimated:YES completion:^{ }];
            }
        }
            break;
        case DDYLockViewStateLoginError:
        {
            [self showWarningAndShake:DDYLocalStr(@"GestureVerifyError")];
        }
            break;
        case DDYLockViewStateVerifyFinish:
        {
            if (self.gestureLockBlock) {
                self.gestureLockBlock(NO);
            }
            if (![self.navigationController popViewControllerAnimated:YES]) {
                [self dismissViewControllerAnimated:YES completion:^{ }];
            }
        }
            break;
        case DDYLockViewStateVerifyError:
        {
            [self showWarningAndShake:DDYLocalStr(@"GestureVerifyError")];
        }
            break;
    }
}

#pragma mark - tipLabel不同提示
#pragma mark 普通提示
- (void)showNormalMsg:(NSString *)msg {
    [_tipLabel setText:msg];
    [_tipLabel setTextColor:lockTipNormalColor];
}

#pragma mark 警示提示
- (void)showWarningMsg:(NSString *)msg {
    [_tipLabel setText:msg];
    [_tipLabel setTextColor:lockColorError];
}

#pragma mark 摇动警示
- (void)showWarningAndShake:(NSString *)msg {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    animation.values = @[@(-5),@(0),@(5),@(0),@(-5),@(0),@(5),@(0)];
    animation.duration = 0.3f;
    animation.repeatCount = 2;
    animation.removedOnCompletion = YES;
    [_tipLabel setText:msg];
    [_tipLabel setTextColor:lockColorError];
    [_tipLabel.layer addAnimation:animation forKey:@"shake"];
}

#pragma mark - infoView操作
#pragma mark 设置状态第一次设置后infoView展示相应选中
- (void)infoViewSelectedSameAsLockView:(DDYLockView *)lockView {
    for (DDYCircleView *circle in lockView.subviews) {
        if (circle.state==DDYCircleViewStateSelected || circle.state==DDYCircleViewStateLastOneSelected) {
            for (DDYCircleView *infoCircle in _infoView.subviews) {
                if (infoCircle.tag == circle.tag) {
                    infoCircle.state = DDYCircleViewStateSelected;
                }
            }
        }
    }
}

#pragma mark 让infoView按钮全部取消选中
- (void)infoViewDeselectedAllCircle {
    [_infoView.subviews enumerateObjectsUsingBlock:^(DDYCircleView *circle, NSUInteger idx, BOOL *stop) {
        circle.state = DDYCircleViewStateNormal;
    }];
}

@end
