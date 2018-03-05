//
//  DDYLockView.h
//  SmartMesh
//
//  Created by Rain on 18/1/26.
//  Copyright © 2018年 SmartMesh Foundation All rights reserved.
//

#import <UIKit/UIKit.h>

@class  DDYLockView;

typedef NS_ENUM(NSInteger, DDYLockViewType) {
    DDYLockViewTypeSetting = 1, // 设置手势密码
    DDYLockViewTypeLogin   = 2, // 登录手势密码
    DDYLockViewTypeVerify  = 3, // 验证手势密码
};

typedef NS_ENUM(NSInteger, DDYLockViewState) {
    DDYLockViewStateLess        = 1,    // 连线个数少于最小值(设置)
    DDYLockViewStateFirstFinish = 2,    // 提示再次绘制以确认(设置)
    DDYLockViewStateSecondFinish= 3,    // 两次绘制一致可保存(设置)
    DDYLockViewStateSecondError = 4,    // 两次绘制路径不一致(设置)
    DDYLockViewStateLoginFinish = 5,    // 手势密码登录成功(登录)
    DDYLockViewStateLoginError  = 6,    // 手势密码登录失败(登录)
    DDYLockViewStateVerifyFinish= 7,    // 修改密码验证成功(验证)
    DDYLockViewStateVerifyError = 8,    // 修改密码验证失败(验证)
    
};

//--------------------------- delegate ---------------------------//
@protocol DDYLockViewDelegate <NSObject>

- (void)lockView:(DDYLockView *)lockView state:(DDYLockViewState)state;

@end

//--------------------------- InfoView ---------------------------//
@interface DDYLockInfoView : UIView

+ (instancetype)infoViewWithFrame:(CGRect)frame;

@end

//--------------------------- lockView ---------------------------//
@interface DDYLockView : UIView

/** 是否裁剪 默认YES */
@property (nonatomic, assign) BOOL clip;
/** 是否有箭头 默认YES */
@property (nonatomic, assign) BOOL arrow;
/** 解锁类型 */
@property (nonatomic, assign) DDYLockViewType type;
/** 代理 */
@property (nonatomic, weak) id<DDYLockViewDelegate> delegate;
/** 初始化 */
+ (instancetype)lockViewWithType:(DDYLockViewType)type;

+ (instancetype)lockViewWithType:(DDYLockViewType)type clip:(BOOL)clip arrow:(BOOL)arrow;

- (instancetype)initWithType:(DDYLockViewType)type clip:(BOOL)clip arrow:(BOOL)arrow;

@end
