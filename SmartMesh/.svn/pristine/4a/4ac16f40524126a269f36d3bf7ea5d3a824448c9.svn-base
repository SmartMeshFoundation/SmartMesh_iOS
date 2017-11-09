//
//  UIButton+DDYStyle.m
//  DDYProject
//
//  Created by Rain Dou on 15/5/18.
//  Copyright © 2015年 634778311 All rights reserved.
//

#import "UIButton+DDYStyle.h"

@implementation UIButton (DDYStyle)

+ (instancetype)customBtn
{
    return [[self class] buttonWithType:UIButtonTypeCustom];
}

- (void)setDDYStyle:(DDYStyle)style padding:(CGFloat)padding
{
    if (self.imageView.image != nil && self.titleLabel.text != nil)
    {
        // 先还原
        self.titleEdgeInsets = UIEdgeInsetsZero;
        self.imageEdgeInsets = UIEdgeInsetsZero;
        
        // 上图下文或者上文下图情况重新计算高
        CGFloat imageX = self.imageView.ddy_x;
        CGFloat titleX = self.titleLabel.ddy_x;
        CGFloat imageY = self.imageView.ddy_y;
        CGFloat titleY = self.titleLabel.ddy_y;
        CGFloat imageW = self.imageView.ddy_w;
        CGFloat titleW = self.titleLabel.ddy_w;
        CGFloat imageH = self.imageView.ddy_h;
        CGFloat titleH = self.titleLabel.ddy_h;
        CGFloat totalH = imageH + titleH + padding;
        CGFloat selfH = self.ddy_h;
        CGFloat selfW = self.ddy_w;
        
        switch (style)
        {
            case DDYStyleImgLeft:
                self.titleEdgeInsets = UIEdgeInsetsMake(0, padding/2.0, 0, -padding/2.0);
                self.imageEdgeInsets = UIEdgeInsetsMake(0, -padding/2.0, 0, padding/2.0);
                break;
                
            case DDYStyleImgRight:
                self.titleEdgeInsets = UIEdgeInsetsMake(0, -(imageW + padding/2.0), 0, (imageW + padding/2.0));
                self.imageEdgeInsets = UIEdgeInsetsMake(0, (titleW + padding/2.0), 0, -(titleW + padding/2.0));
                break;
                
            case DDYStyleImgTop:
                self.titleEdgeInsets = UIEdgeInsetsMake(((selfH - totalH)/2.0 + imageH + padding - titleY),
                                                        -(titleX + titleW/2.0 - selfW/2.0),
                                                        -((selfH - totalH)/2.0 + imageH + padding - titleY),
                                                        (titleX + titleW/2.0 - selfW/2.0));
                self.imageEdgeInsets = UIEdgeInsetsMake(((selfH - totalH)/2.0 - imageY),
                                                        (selfW/2.0 - imageX - imageW/2.0),
                                                        -((selfH - totalH)/2.0 - imageY),
                                                        -(selfW/2.0 - imageX - imageW/2.0));
                break;
                
            case DDYStyleImgBottom:
                NSLog(@"%f",titleX);
                self.titleEdgeInsets = UIEdgeInsetsMake(((selfH - totalH)/2.0 - titleY),
                                                        -(titleX + titleW/2.0 - selfW/2.0),
                                                        -((selfH - totalH)/2.0 - titleY),
                                                        (titleX + titleW/2.0 - selfW/2.0));
                self.imageEdgeInsets = UIEdgeInsetsMake(((selfH - totalH)/2.0 + titleH + padding - imageY),
                                                        (selfW/2.0 - imageX - imageW/2.0),
                                                        -((selfH - totalH)/2.0 + titleH + padding - imageY),
                                                        -(selfW/2.0 - imageX - imageW/2.0));
                break;
                
            default:
                break;
        }
    }
}
- (void)DDYStyle:(DDYStyle)style padding:(CGFloat)padding {
    [self setDDYStyle:style padding:padding];
}
@end

























