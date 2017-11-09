//
//  DDYButton.h
//  DDYProject
//
//  Created by LingTuan on 17/7/20.
//  Copyright © 2017年 Starain. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef DDYButtonNew
#define DDYButtonNew ([DDYButton customDDYBtn])
#endif

typedef NS_ENUM(NSInteger, DDYBtnStyle) {
    DDYBtnStyleDefault   = 0,     // 左图右文，整体居中，默认状态
    DDYBtnStyleImgLeft   = 1,     // 左图右文，整体居中，设置间隙
    DDYBtnStyleImgRight  = 2,     // 左文右图，整体居中，设置间隙
    DDYBtnStyleImgTop    = 3,     // 上图下文，整体居中，设置间隙
    DDYBtnStyleImgDown   = 4,     // 下图上文，整体居中，设置间隙
    DDYBtnStyleNaturalImgLeft   = 5,     // 左图右文，自然对齐，两端对齐
    DDYBtnStyleNaturalImgRight  = 6,     // 左文右图，自然对齐，两端对齐
    DDYBtnStyleImgLeftThenLeft  = 7,     // 左图右文，整体居左，设置间隙
};

@interface DDYButton : UIButton

+ (instancetype)customDDYBtn;

/** 布局方式 */
@property (nonatomic, assign) DDYBtnStyle btnStyle;
/** 图文间距 默认5 */
@property (nonatomic, assign) CGFloat padding;
/** 文字字体 */
@property (nonatomic, strong) UIFont *textFont;

/** 创建一个NormalState按钮 */
+ (instancetype)btnTitle:(NSString *)title img:(id)img target:(id)target action:(SEL)action;

+ (instancetype)btnTitle:(NSString *)title img:(id)img target:(id)target action:(SEL)action tag:(NSInteger)tag;

@end
