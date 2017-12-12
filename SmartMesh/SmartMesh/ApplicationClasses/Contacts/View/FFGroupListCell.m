//
//  FFGroupListCell.m
//  NextApp
//
//  Created by Megan on  17-12-12.
//  Copyright (c) 2017年 SmartMesh Foundation All rights reserved.
//

#import "FFGroupListCell.h"
#import "FFGroupHeadView.h"

@interface FFGroupListCell ()
{
    UILabel         * _titleLabel;
}
@property (nonatomic, strong) DDYHeader *avatarView;

@end

@implementation FFGroupListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self builtUI];
    }
    return self;
}

-(void)builtUI
{
    _avatarView = [DDYHeader headerWithHeaderWH:46];
    _avatarView.ddy_x = 10;
    _avatarView.ddy_y = 10;
    _avatarView.backgroundColor = DDY_ClearColor;
    [self.contentView addSubview:_avatarView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:LC_RECT(_avatarView.viewRightX + 10, 0, DDYSCREENW - 80, 70)];
    _titleLabel.text = @" ";
    _titleLabel.font = NA_FONT(16);
    _titleLabel.textColor = LC_RGB(51, 51, 51);
    [self.contentView addSubview:_titleLabel];
}

-(void) setGroup:(FFGroupModel *)group
{
    _titleLabel.text = group.groupName;
    
    NSMutableArray *avatarArray = [NSMutableArray array];
    NSMutableArray *placeholderArray = [NSMutableArray array];
    for (FFUser *user in group.memberList) {
        [avatarArray addObject:user.userImage];
        [placeholderArray addObject:[FFUser avatarWithRemarkName:user.remarkName]];
    }
    _avatarView.imgArray = placeholderArray;
    _avatarView.urlArray = avatarArray;
}

@end
