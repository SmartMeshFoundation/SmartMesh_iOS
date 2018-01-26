//
//  DDYGestureLockVC.m
//  SmartMesh
//
//  Created by Rain on 18/1/26.
//  Copyright © 2018年 SmartMesh Foundation All rights reserved.
//

#import "DDYGestureLockVC.h"

@interface DDYGestureLockVC ()<DDYLockViewDelegate, UINavigationControllerDelegate>

/** 解锁九宫格 */
@property (nonatomic, strong) DDYLockView *lockView;
/** TypeSetting/TypeLogin 提示文字, TypeVerify清爽无提示 */
@property (nonatomic, strong) UILabel *tipLabel;
/** TypeSetting/TypeLogin 提示视图, TypeVerify清爽无提示 */
@property (nonatomic, strong) DDYLockInfoView *infoView;

@end

@implementation DDYGestureLockVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSameUI];
    [self setupDifferentUI];
}

#pragma mark UI相同部分
- (void)setupSameUI {
    self.view.backgroundColor = lockViewBgColor;
    // 解锁九宫格
    _lockView = [DDYLockView lockViewWithType:self.lockType];
    _lockView.delegate = self;
    [self.view addSubview:_lockView];
    // 提示文字
    _tipLabel = UILabelNew.labFont(DDYFont(14)).labAlignmentCenter();
    [self.view addSubview:_tipLabel.viewSetFrame(0,0,DDYSCREENW,16).viewSetCenterY(_lockView.ddy_y-30)];
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
    [self showNormalMsg:lockTipBeforeSet];
    _infoView = [DDYLockInfoView infoViewWithFrame:DDYRect(0, 0, 1.2*circleRadius, 1.2*circleRadius)];
    _infoView.center = DDYPoint(DDYSCREENW/2, _tipLabel.ddy_y - _infoView.ddy_h/2-10);
    [self.view addSubview:_infoView];
}

#pragma mark 登录模式界面
- (void)setupViewTypeLogin {
    self.navigationItem.title = lockTitleLogin;
    DDYHeader *header = [DDYHeader headerWithHeaderWH:65];
    header.center = DDYPoint(DDYSCREENW/2, DDYSCREENH/5);
    header.imgArray = @[[UIImage imageWithColor:DDY_Red size:DDYSize(65, 65)]];
    header.urlArray = @[@""];
    [self.view addSubview:header];
    // 提示请输入手势密码
    [self showNormalMsg:lockTipLoginTip];
    // 忘记手势密码？
    
    // 指纹解锁
}

#pragma mark 验证模式界面
- (void)setupViewTypeVerify {
    self.navigationItem.title = lockTitleSetting;
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
            [self showWarningAndShake:lockTipConnectLess];
        }
            break;
        case DDYLockViewStateFirstFinish:
        {
            [self showNormalMsg:lockTipDrawAgain];
            [self infoViewSelectedSameAsLockView:lockView];
        }
            break;
        case DDYLockViewStateSecondFinish:
        {
            [self showNormalMsg:lockTipSuccess];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
            break;
        case DDYLockViewStateSecondError:
        {
            [self showWarningAndShake:lockTipDrawAgainError];
            [self infoViewDeselectedAllCircle];
        }
            break;
        case DDYLockViewStateLoginFinish:
        {
            [self dismissViewControllerAnimated:YES completion:^{ }];
        }
            break;
        case DDYLockViewStateLoginError:
        {
            [self showWarningAndShake:lockTipVerifyError];
        }
            break;
        case DDYLockViewStateVerifyFinish:
        {
            [self dismissViewControllerAnimated:YES completion:^{ }];
        }
            break;
        case DDYLockViewStateVerifyError:
        {
            [self showWarningAndShake:lockTipVerifyError];
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
    [_tipLabel setTextColor:lockTipWarningColor];
}

#pragma mark 摇动警示
- (void)showWarningAndShake:(NSString *)msg {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    animation.values = @[@(-5),@(0),@(5),@(0),@(-5),@(0),@(5),@(0)];
    animation.duration = 0.3f;
    animation.repeatCount = 2;
    animation.removedOnCompletion = YES;
    [_tipLabel setText:msg];
    [_tipLabel setTextColor:lockTipWarningColor];
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
