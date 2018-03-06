//
//  DDYCircleView.h
//  SmartMesh
//
//  Created by Rain on 18/1/26.
//  Copyright © 2018年 SmartMesh Foundation All rights reserved.
//

#import <UIKit/UIKit.h>

/** 圆的状态 */
typedef NS_ENUM(NSInteger, DDYCircleViewState) {
    DDYCircleViewStateNormal             = 1,
    DDYCircleViewStateSelected           = 2,
    DDYCircleViewStateError              = 3,
    DDYCircleViewStateLastOneSelected    = 4,
    DDYCircleViewStateLastOneError       = 5,
};

/** 圆的用途 */
typedef NS_ENUM(NSInteger, DDYCircleViewType) {
    DDYCircleViewTypeInfo                = 1,
    DDYCircleViewTypeGesture             = 2,
};

@interface DDYCircleView : UIView

/** 所处状态 */
@property (nonatomic, assign) DDYCircleViewState state;
/** 类型 */
@property (nonatomic, assign) DDYCircleViewType type;
/** 是否有箭头 默认YES */
@property (nonatomic, assign) BOOL arrow;
/** 角度 */
@property (nonatomic, assign) CGFloat angle;
/** 初始化 */
+ (instancetype)circleView;

@end
