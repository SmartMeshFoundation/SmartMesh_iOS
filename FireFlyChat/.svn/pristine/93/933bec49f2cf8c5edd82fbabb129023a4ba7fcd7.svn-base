//
//  UIButton+DDYStyle.h
//  DDYProject
//
//  Created by Rain Dou on 15/5/18.
//  Copyright © 2015年 634778311 All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DDYStyle) {
    DDYStyleDefault = 0,        // 左图右文，整体居中，默认状态
    DDYStyleImgLeft = 1,        // 左图右文，整体居中，设置间隙
    DDYStyleImgRight = 2,       // 左文右图，整体居中，设置间隙
    DDYStyleImgTop = 3,         // 上图下文，整体居中，设置间隙
    DDYStyleImgBottom = 4,      // 下图上文，整体居中，设置间隙
};

@interface UIButton (DDYStyle)

+ (instancetype)customBtn;
/** style:图文样式 padding:图文间隙 */
- (void)setDDYStyle:(DDYStyle)style padding:(CGFloat)padding;
- (void)DDYStyle:(DDYStyle)style padding:(CGFloat)padding;

@end
