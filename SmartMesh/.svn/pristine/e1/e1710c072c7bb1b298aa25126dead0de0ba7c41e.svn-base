//
//  DDYWaveView.h
//  DDYProject
//
//  Created by LingTuan on 17/9/15.
//  Copyright © 2017年 Starain. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DDYWaveDirection){
    DDYWaveDirectionLeftToRight = -1,   // 从左到右
    DDYWaveDirectionRightToLeft = +1    // 从右到左
};

@interface DDYWaveView : UIView

/** 前置波浪线颜色 默认白色 */
@property (nonatomic, strong) UIColor *frontColor;
/** 后置波浪线颜色 默认浅灰 */
@property (nonatomic, strong) UIColor *insideColor;
/** 前置波浪线速度 默认0.02 */
@property (nonatomic, assign) CGFloat frontSpeed;
/** 前置波浪线速度 默认0.02 */
@property (nonatomic, assign) CGFloat insideSpeed;
/** 两层波浪初相差 默认M_PI */
@property (nonatomic, assign) CGFloat phaseOffset;
/** 波浪的移动方向 默认从左到右 */
@property (nonatomic, assign) DDYWaveDirection direction;

/** 中间位置波浪线高度回调 */
@property (nonatomic, copy) void (^callBack)(CGFloat frontY, CGFloat insideY);

@end
