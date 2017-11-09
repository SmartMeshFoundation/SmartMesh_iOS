//
//  FFCountryListCell.m
//  SmartMesh
//
//  Created by Megan on 2017/9/22.
//  Copyright © 2017年 SmartMesh Foundation All rights reserved.
//

#import "FFCountryListCell.h"

@interface FFCountryListCell()
{
    UIImageView * _countryIcon;
    UILabel     * _countryName;
    UIView      * _line;
}
@end

@implementation FFCountryListCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    _countryIcon = [[UIImageView alloc] initWithFrame:LC_RECT(15, 10, 20, 15)];
    _countryIcon.backgroundColor = LC_RGB(235, 235, 235);
    [self.contentView addSubview:_countryIcon];
    
    _countryName = [[UILabel alloc] initWithFrame:LC_RECT(_countryIcon.viewRightX + 10, 0, 100, 40)];
    _countryName.text = @"China";
    _countryName.textColor = LC_RGB(51, 51, 51);
    _countryName.font = NA_FONT(20);
    [self.contentView addSubview:_countryName];
    
    _line = [[UIView alloc] initWithFrame:LC_RECT(15, 39, DDYSCREENW - 15, 1)];
    _line.backgroundColor = LC_RGB(235, 235, 235);
    [self.contentView addSubview:_line];
}



@end
