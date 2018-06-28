//
//  FFGestureHeader.m
//  FireFly
//
//  Created by SmartMesh on 18/1/29.
//  Copyright © 2018年 NAT. All rights reserved.
//

#import "FFGestureHeader.h"
#import "AvatarImg.h"

@interface FFGestureHeader ()
/** 手势密码类型 */
@property (nonatomic, assign) DDYLockViewType type;
/** 手势缩略图 TypeLogin */
@property (nonatomic, strong) DDYLockInfoView *infoView;
/** 钱包头像 TypeLogin/TypeVerify */
@property (nonatomic, strong) DDYHeader *header;
/** 钱包昵称 TypeLogin/TypeVerify */
@property (nonatomic, strong) UILabel *nameLab;
/** 钱包地址 TypeLogin/TypeVerify */
@property (nonatomic, strong) UILabel *addressLab;
/** 连线提示文字 TypeLogin/TypeVerify */
@property (nonatomic, strong) UILabel *tipLabel;
/** 地址后边箭头 钱包验证&&(TypeLogin/TypeVerify) */
@property (nonatomic, strong) UIImageView *arrowView;
/** 钱包地址切换 */
@property (nonatomic, strong) DDYButton *selectBtn;

@end

@implementation FFGestureHeader

+ (instancetype)headerType:(DDYLockViewType)type {
    return [[self alloc] initWithFrame:DDYRect(0, 0, DDYSCREENW, DDYSCREENW) type:type];
}

- (instancetype)initWithFrame:(CGRect)frame type:(DDYLockViewType)type {
    if (self = [super initWithFrame:frame]) {
        self.type = type;
        [self setupTipLabel];
        type == DDYLockViewTypeSetting ? [self setupInfoView] : [self setupWalletInfo];
    }
    return self;
}

#pragma mark - 添加控件
#pragma mark TypeSetting手势缩略图
- (void)setupInfoView {
    _infoView = [DDYLockInfoView infoViewWithFrame:DDYRect(0, SafeAreaTopHeight+25, 1.2*circleRadius, 1.2*circleRadius)];
    _infoView.viewAddToView(self).viewSetCenterX(DDYSCREENW/2);
    _tipLabel.ddy_y = _infoView.ddy_bottom + 15;
    self.ddy_h = _tipLabel.ddy_bottom;
}

#pragma mark TypeLogin/TypeVerify 钱包信息
- (void)setupWalletInfo {
    // 钱包头像
    _header = [DDYHeader headerWithHeaderWH:60];
    _header.imgArray = @[[AvatarImg avatarImgFromAddress:WALLET.activeAccount]];
    _header.urlArray = @[@""];
    _header.viewSetCenter(DDYSCREENW/2, SafeAreaTopHeight+20+30).viewAddToView(self);
    // 钱包昵称
    _nameLab = UILabelNew.labFont(DDYFont(14)).labText([WALLET nicknameForAccount:WALLET.activeAccount]).labAlignmentCenter();
    _nameLab.labTextColor(DDY_Mid_Black).viewSetFrame(15, _header.ddy_bottom+15, DDYSCREENW-30, 16).viewAddToView(self);
    // 钱包地址
    _addressLab = UILabelNew.labFont(DDYFont(13)).labText(WALLET.activeAccount.checksumAddress).labAlignmentCenter();
    _addressLab.lineBreakMode = NSLineBreakByTruncatingMiddle;
    _addressLab.labTextColor(DDY_Mid_Black).viewSetFrame(15,_nameLab.ddy_bottom+10, DDYSCREENW-30, 15).viewAddToView(self);
    // 地址选择
    _arrowView = UIImageViewNew.img_viewImageStr(@"arrow_down");
    _arrowView.viewSetFrame(0,_addressLab.ddy_y,13,13).viewHiddenYES().contentMode = UIViewContentModeScaleAspectFit;
    _selectBtn = DDYButtonNew.btnAction(self,@selector(selectClick)).btnFrame(0,_nameLab.ddy_bottom,DDYSCREENW,40);
    _selectBtn.btnBgColor(DDY_ClearColor).hidden = YES;
    // 提示位置
    _tipLabel.ddy_y = _addressLab.ddy_bottom + 15;
    self.ddy_h = _tipLabel.ddy_bottom;
}

#pragma mark 提示文字
- (void)setupTipLabel {
    _tipLabel = UILabelNew.labFont(DDYFont(14)).labAlignmentCenter();
    _tipLabel.viewSetFrame(0,0,DDYSCREENW,16).viewAddToView(self);
}


- (void)selectClick {
    __weak __typeof__ (self)weakSelf = self;
    FFWalletSelectView *selectView = [FFWalletSelectView selectView];
    selectView.selectBlock = ^() {[weakSelf refreshWalletInfo];};
    [selectView showOnWindow];
    [self.superview endEditing:YES];
}

#pragma mark - tipLabel不同提示
#pragma mark 普通提示
- (void)showNormalMsg:(NSString *)msg {
    [_tipLabel setText:msg];
    [_tipLabel setTextColor:lockTipNormalColor];
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
- (void)infoViewSelectedSameAsLockView:(DDYLockView *)lockView andShowNormalMsg:(NSString *)msg {
    for (DDYCircleView *circle in lockView.subviews) {
        if (circle.state==DDYCircleViewStateSelected || circle.state==DDYCircleViewStateLastOneSelected) {
            for (DDYCircleView *infoCircle in _infoView.subviews) {
                if (infoCircle.tag == circle.tag) {
                    infoCircle.state = DDYCircleViewStateSelected;
                }
            }
        }
    }
    [self showNormalMsg:msg];
}

#pragma mark 重绘手势不成功让infoView按钮全部取消选中
- (void)infoViewDeselectedAllCircleAndShowMsg:(NSString *)msg {
    [_infoView.subviews enumerateObjectsUsingBlock:^(DDYCircleView *circle, NSUInteger idx, BOOL *stop) {
        circle.state = DDYCircleViewStateNormal;
    }];
    [self showWarningAndShake:msg];
}

#pragma mark 切换验证/登录方式
- (void)changeToWallet:(BOOL)isWallet {
    if (isWallet) {
        _addressLab.viewSetFrame(40,_nameLab.ddy_bottom+10, DDYSCREENW-80, 15);
        _arrowView.viewSetX(_addressLab.ddy_right+5).viewAddToView(self).hidden = NO;
        _selectBtn.viewAddToView(self).hidden = NO;
        [self showNormalMsg:@""];
    } else {
        _addressLab.viewSetFrame(15,_nameLab.ddy_bottom+10, DDYSCREENW-30, 15);
        _arrowView.hidden = YES;
        _selectBtn.hidden = YES;
        [self showNormalMsg:DDYLocalStr(@"GestureVerify")];
    }
}

#pragma mark 切换钱包地址后刷新钱包信息
- (void)refreshWalletInfo {
    // 钱包头像
    _header.imgArray = @[[AvatarImg avatarImgFromAddress:WALLET.activeAccount]];
    _header.urlArray = @[@""];
    // 钱包昵称
    _nameLab.labText([WALLET nicknameForAccount:WALLET.activeAccount]);
    // 钱包地址
    _addressLab.labText(WALLET.activeAccount.checksumAddress);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.superview endEditing:YES];
}

@end
