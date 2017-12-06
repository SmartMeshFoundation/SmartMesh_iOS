//
//  FFMeHeader.m
//  SmartMesh
//
//  Created by Rain on 17/9/20.
//  Copyright © 2017年 SmartMesh Foundation All rights reserved.
//

#import "FFMeHeader.h"
#import "FFUser.h"

@interface FFMeHeader ()

/** 头像 */
@property (nonatomic, strong) DDYHeader *avatarView;
/** 昵称 */
@property (nonatomic, strong) UILabel *nameLab;
/** 描述 */
@property (nonatomic, strong) UILabel *profileLab;

@end

@implementation FFMeHeader

+ (instancetype)headView {
    return [[self alloc] initWithFrame:DDYRect(0, 0, DDYSCREENW, FFMeHeaderHight)];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:DDY_White];
        [self setupContentView];
        [self loadTempData];
        
        [self addTapTarget:self action:@selector(tapAction)];
    }
    return self;
}

- (void)setupContentView {
    
    _avatarView = [DDYHeader headerWithHeaderWH:70];
    _avatarView.ddy_x = 15;
    _avatarView.ddy_y = FFMeHeaderHight-85;
    _avatarView.backgroundColor = DDY_ClearColor;
    [self addSubview:_avatarView];
    
    _nameLab = [self labelColor:DDY_Big_Black font:DDYFont(19)];
    
    _profileLab = [self labelColor:DDY_Mid_Black font:DDYFont(16)];
}

- (void)loadHeaderData:(FFUser *)user {
    _avatarView.imgArray = @[[FFUser avatarWithRemarkName:user.remarkName]];
    _avatarView.urlArray = @[user.userImage ? user.userImage : @""]; // 有可能各种原因造成url不存在，例如无网用户
    _nameLab.text = user.remarkName;
    _profileLab.text = user.sightml;
}

#pragma mark 生成label
- (UILabel *)labelColor:(UIColor *)color font:(UIFont *)font {
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = color;
    label.font = font;
    [self addSubview:label];
    return label;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_avatarView.mas_right).offset(15);
        make.right.mas_equalTo(self.mas_right).offset(-15);
        make.top.mas_equalTo(_avatarView.mas_top);
        make.height.mas_equalTo(24);
    }];
    
    [_profileLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_avatarView.mas_right).offset(15);
        make.right.mas_equalTo(self.mas_right).offset(-15);
        make.bottom.mas_equalTo(_avatarView.mas_bottom);
        make.height.mas_equalTo(24);
    }];
}

- (void)loadTempData {
    _nameLab.text = [FFLoginDataBase sharedInstance].loginUser.remarkName;
    _profileLab.hidden = [NSString ddy_blankString:[FFLoginDataBase sharedInstance].loginUser.sightml];
    _profileLab.text = [FFLoginDataBase sharedInstance].loginUser.sightml;
}

- (void)tapAction {
    if (self.tatBlock) {
        self.tatBlock();
    }
}

@end
