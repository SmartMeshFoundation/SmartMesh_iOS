//
//  DDYRadarView.h
//  DDYProject
//
//  Created by ShangHaiSheQuan on 15/12/19.
//  Copyright © 2015年 Starain. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DDYRadarView;
@class DDYRadarPointView;

//------------------------ 数据代理 ------------------------//
@protocol DDYRadarViewDataSource <NSObject>
@optional
/** 点位数量 最大为8 */
- (NSInteger)numberOfPointInRadarView:(DDYRadarView *)radarView;
/** 点位视图 */
- (DDYRadarPointView *)radarView:(DDYRadarView *)radarView viewForIndex:(NSInteger)index;
/** 点位图片 */
- (UIImage *)radarView:(DDYRadarView *)radarView imageForIndex:(NSInteger)index;

@end

//------------------------ 视图代理 ------------------------//
@protocol DDYRadarViewDelegate <NSObject>
@optional
/** 点击点位回调 */
- (void)radarView:(DDYRadarView *)radarView didSelectItemAtIndex:(NSInteger)index;

@end

//----------------------- 点位头像视图 -----------------------//
@interface DDYRadarPointView : UIView

@property (nonatomic, strong) UIImage *image;

@end

//------------------------ 扇形指示器 ------------------------//
@interface DDYRadarIndicatorView : UIView

@end

//------------------------- 雷达视图 -------------------------//
@interface DDYRadarView : UIView

/** 数据源代理 */
@property (nonatomic, weak) id <DDYRadarViewDataSource> dataSource;
/** 视图代理 */
@property (nonatomic, weak) id <DDYRadarViewDelegate> delegate;

/** 同心圆半径 */
@property (nonatomic, assign) CGFloat radius;
/** 同心圆个数 */
@property (nonatomic, assign) NSInteger circleNumber;
/** 同心圆边框颜色 */
@property (nonatomic, strong) UIColor *circleColor;
/** 指示器开始颜色 */
@property (nonatomic, strong) UIColor *indicatorStartColor;
/** 指示器结束颜色 */
@property (nonatomic, strong) UIColor *indicatorEndColor;
/** 是否顺时针方向 */
@property (nonatomic, assign) BOOL indicatorClockwise;
/** 指示器角度大小 */
@property (nonatomic, assign) CGFloat indicatorAngle;
/** 指示器旋转速度 */
@property (nonatomic, assign) CGFloat indicatorSpeed;
/** 视图背景图片 */
@property (nonatomic, strong) UIImage *backgroundImage;
/** 显示虚分割线 */
@property (nonatomic, assign) BOOL showSeparator;

/** 雷达视图对象 */
+ (instancetype)radarView;
/** 开始动画 */
- (void)startScanAnimation;
/** 结束动画 */
- (void)stopScanAnimation;
/** 刷新以展示数据 */
- (void)reloadData;

@end
