//
//  FFFriendTableViewCell.m
//  NextApp
//
//  Created by Megan on  17-12-12.
//  Copyright (c) 2017年 SmartMesh Foundation All rights reserved.
//

#import "FFFriendCell.h"

@interface FFFriendCell ()
{
    UIImageView *_avatarView;
    UIButton    *_selectBtn;
    UILabel     *_username;
}
@end

@implementation FFFriendCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        [self setupContentView];
    }
    return self;
}

- (void)setupContentView
{
    _selectBtn = [[UIButton alloc] initWithFrame:LC_RECT(10, 25, 20, 20)];
    [_selectBtn setImage:[UIImage imageNamed:@"icon_select_cricle"] forState:UIControlStateNormal];
    [_selectBtn setImage:[UIImage imageNamed:@"icon_selected_cricle"] forState:UIControlStateSelected];
//    [_selectBtn addTarget:self action:@selector(selectAction) forControlEvents:UIControlEventTouchUpInside];
    _selectBtn.userInteractionEnabled = NO;
    [self.contentView addSubview:_selectBtn];
    _selectBtn.selected = NO;
    
    _avatarView = [[UIImageView alloc] initWithFrame:LC_RECT(_selectBtn.viewRightX + 10, 15, 40, 40)];
    _avatarView.image = [UIImage imageNamed:@"icon_head_defaul"];
    _avatarView.layer.cornerRadius = 20;
    _avatarView.layer.masksToBounds = YES;
    _avatarView.backgroundColor =LC_RGB(235, 235, 235);
    [self.contentView addSubview:_avatarView];
    
    _username = [[UILabel alloc] initWithFrame:LC_RECT(_avatarView.viewRightX + 10, 0, DDYSCREENW - 130, 70)];
    _username.text = @"1234567890";
    _username.font = NA_FONT(16);
    _username.textColor = LC_RGB(42, 42, 42);
    [self.contentView addSubview:_username];
    
    
    
}

- (void)reloadCellUser:(FFUser *)user selected:(BOOL)selected isFixed:(BOOL)fixed
{
    [_avatarView sd_setImageWithURL:[NSURL URLWithString:user.userImage]];
    _username.text = user.remarkName;
    
    if (fixed) {
        
        [_selectBtn setImage:[UIImage imageNamed:@"icon_selected.png"] forState:UIControlStateNormal];
        [_selectBtn setImage:[UIImage imageNamed:@"icon_selected.png"] forState:UIControlStateSelected];
        
    }else {
        
        [_selectBtn setImage:[UIImage imageNamed:@"icon_select_cricle"] forState:UIControlStateNormal];
        [_selectBtn setImage:[UIImage imageNamed:@"icon_selected_cricle"] forState:UIControlStateSelected];
        
        if (selected) {
            
            _selectBtn.selected = YES;
        }
        else
        {
            _selectBtn.selected = NO;
        }
        
    }
    
        
//    if (user.exist)
//    {
//        _selectBtn.enabled = NO;
////        [_selectBtn setImage:[UIImage imageNamed:@"icon_selected_cricle"] forState:UIControlStateNormal];
//    }
//    else
//    {
//        _selectBtn.enabled = YES;
////        [_selectBtn setImage:[UIImage imageNamed:@"icon_selected"] forState:UIControlStateNormal];
////        [_selectBtn setImage:[UIImage imageNamed:@"icon_select_cricle"] forState:UIControlStateNormal];
//    }
}


//-(void)selectAction
//{
//    if (_selectBtn.selected == NO) {
//
//        _selectBtn.selected = YES;
//    }
//    else
//    {
//        _selectBtn.selected = NO;
//    }
//}

- (void)setUser:(FFUser *)user {
    
    [_avatarView sd_setImageWithURL:[NSURL URLWithString:user.userImage]];
    _username.text = user.remarkName;
}

@end
