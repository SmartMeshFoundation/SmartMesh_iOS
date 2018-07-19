//
//  FFWalletBackupAlert.m
//  FireFly
//
//  Created by Rain on 18/1/17.
//  Copyright © 2018年 SmartMesh Foundation All rights reserved.
//

#import "FFWalletBackupAlert.h"

@interface FFWalletBackupAlert ()

@property (nonatomic, strong) UIScrollView *bgView;

@property (nonatomic, strong) UILabel *titleLab;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UIView *msgBgView;

@property (nonatomic, strong) UILabel *msgLabel1;

@property (nonatomic, strong) UILabel *msgLabel2;

@property (nonatomic, strong) UILabel *msgLabel3;

@property (nonatomic, strong) UILabel *pkTitleLabel;

@property (nonatomic, strong) UILabel *pkMsgLabel;

@property (nonatomic, strong) UILabel *ksTitleLabel;

@property (nonatomic, strong) UILabel *ksMsgLabel;

@property (nonatomic, strong) DDYButton *backupBtn;

@end

@implementation FFWalletBackupAlert

+ (instancetype)alertView {
    return [[self alloc] initWithFrame:[UIScreen mainScreen].bounds];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupContentView];
    }
    return self;
}

- (void)setupContentView {
    
    self.backgroundColor = DDYRGBA(0, 0, 0, 0.7);
    
    _bgView = UIScrollViewNew.scroll_viewShowsVertical(NO);
    [self addSubview:_bgView.viewSetFrame(18, 0, DDYSCREENW-36, 205).viewBGColor(DDY_White)];
    
    _titleLab = [self labText:DDYLocalStr(@"WalletBackupTipTitle") big:YES left:NO frame:DDYRect(0, 25, _bgView.ddy_w, 20)];
    
    _lineView = UIViewNew.viewBGColor(DDYRGBA(235, 235, 235, 1)).viewSetFrame(0, _titleLab.ddy_bottom+(DDYSCREENW>320?15:13), _bgView.ddy_w, 1);
    
    _msgBgView = UIViewNew.viewSetFrame(16, _lineView.ddy_bottom+(DDYSCREENW>320?16:11) , _bgView.ddy_w-32, 20).viewBGColor(DDYRGBA(253, 250, 240, 1));
    
    _msgLabel1 = [self labText:DDYLocalStr(@"WalletBackupTipMsg1") big:NO left:YES frame:DDYRect(8, (DDYSCREENW>320?14:8), _msgBgView.ddy_w-16, 20)];
    
    _msgLabel2 = [self labText:DDYLocalStr(@"WalletBackupTipMsg2") big:NO left:YES frame:DDYRect(8, _msgLabel1.ddy_bottom+(DDYSCREENW>320?14:8), _msgLabel1.ddy_w, 20)];
    
    _msgLabel3 = [self labText:DDYLocalStr(@"WalletBackupTipMsg3") big:NO left:YES frame:DDYRect(8, _msgLabel2.ddy_bottom+(DDYSCREENW>320?14:8), _msgLabel2.ddy_w, 20)];
    
    _msgBgView.ddy_h = (DDYSCREENW>320?14:8)*4 + _msgLabel1.ddy_h + _msgLabel2.ddy_h + _msgLabel3.ddy_h;
    
    _pkTitleLabel = [self labText:DDYLocalStr(@"WalletBackupTipPKTitle") big:YES left:YES frame:DDYRect(16,_msgBgView.ddy_bottom+(DDYSCREENW>320?18:15),_bgView.ddy_w,20)];
    
    _pkMsgLabel = [self labText:DDYLocalStr(@"WalletBackupTipPKMsg") big:NO left:YES frame:DDYRect(16,_pkTitleLabel.ddy_bottom+(DDYSCREENW>320?10:7),_bgView.ddy_w-32,20)];
    
    _ksTitleLabel = [self labText:DDYLocalStr(@"WalletBackupTipKSTitle") big:YES left:YES frame:DDYRect(16,_pkMsgLabel.ddy_bottom+(DDYSCREENW>320?18:15),_bgView.ddy_w,20)];
    
    _ksMsgLabel = [self labText:DDYLocalStr(@"WalletBackupTipKSMsg") big:NO left:YES frame:DDYRect(16, _ksTitleLabel.ddy_bottom+(DDYSCREENW>320?10:7),_bgView.ddy_w-32, 20)];
    
    _backupBtn = DDYButtonNew.btnBgColor(FF_MAIN_COLOR).btnTitleN(DDYLocalStr(@"WalletBackupBtn")).btnFont(DDYFont(17)).btnTitleColorN(NA_Big_Black).btnFrame(22,_ksMsgLabel.ddy_bottom+(DDYSCREENW>320?24:18), _bgView.ddy_w-44,46).btnAction(self, @selector(handleBackup));
    
    _bgView.ddy_h = MIN(_backupBtn.ddy_bottom+(DDYSCREENW>320?20:17), DDYSCREENH-SafeAreaTopHeight-SafeAreaBottomHeight);
    _bgView.scroll_viewContentSize(_bgView.ddy_w, _backupBtn.ddy_bottom+(DDYSCREENW>320?20:17));
    
    [_bgView addSubview:_titleLab.viewSetCenterX(_bgView.ddy_w/2.)];
    [_bgView addSubview:_lineView];
    [_bgView addSubview:_msgBgView];
    [_bgView addSubview:_pkTitleLabel];
    [_bgView addSubview:_pkMsgLabel];
    [_bgView addSubview:_ksTitleLabel];
    [_bgView addSubview:_ksMsgLabel];
    [_bgView addSubview:_backupBtn];
    [_msgBgView addSubview:_msgLabel1];
    [_msgBgView addSubview:_msgLabel2];
    [_msgBgView addSubview:_msgLabel3];
    
    DDYBorderRadius(_bgView.viewSetCenterY(DDYSCREENH/2.), 3, 0, DDY_ClearColor);
    DDYBorderRadius(_msgBgView, 6, 1, DDYRGBA(230, 218, 194, 1));
    DDYBorderRadius(_backupBtn, _backupBtn.ddy_h/2., 0, DDY_ClearColor);
}

- (UILabel *)labText:(NSString *)text big:(BOOL)big left:(BOOL)left frame:(CGRect)frame {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.numberOfLines = 0;
    label.textColor = big ? NA_Big_Black : NA_Small_Black;
    label.font = big ? DDYFont(DDYSCREENW>320 ? 16 : 15) : DDYFont(DDYSCREENW>320 ? 14 : 13) ;
    label.textAlignment = left ? NSTextAlignmentLeft : NSTextAlignmentCenter;
    label.text = text;
    [label sizeToFit];
    return label;
}

- (void)handleLater {
    [self removeFromSuperview];
}

- (void)handleBackup {
    [self removeFromSuperview];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
        if (self.backupBlock) {
            self.backupBlock();
        }
    });
}

- (void)showOnWindow {
    UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
    if (!keyWindow) keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow addSubview:self];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //    [self removeFromSuperview];
}

@end

/**
 
 FFWalletBackupAlert *alert = [FFWalletBackupAlert alertView];
 alert.backupBlock = ^() {
 // #import "FFWalletBackupAlert.h"
 };
 [alert showOnWindow];
 
 */
