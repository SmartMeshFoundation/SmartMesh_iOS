//
//  DDYLockView.m
//  SmartMesh
//
//  Created by Rain on 18/1/26.
//  Copyright © 2018年 SmartMesh Foundation All rights reserved.
//

#import "DDYLockView.h"

//--------------------------- InfoView ---------------------------//
@implementation DDYLockInfoView

+ (instancetype)infoViewWithFrame:(CGRect)frame {
    return [[self alloc] initWithFrame:frame];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = circleBgColor;
        for (int i = 0; i < 9; i++) {
            DDYCircleView *circle = [DDYCircleView circleView];
            circle.type = DDYCircleViewTypeInfo;
            [self addSubview:circle];
        }
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat itemViewWH = circleInfoRadius * 2;
    CGFloat itemMargin = (self.ddy_w - 3*itemViewWH) / 3.f;
    // 九宫格
    [self.subviews enumerateObjectsUsingBlock:^(DDYCircleView *circle, NSUInteger idx, BOOL *stop) {
        NSUInteger row = idx % 3;
        NSUInteger col = idx / 3;
        CGFloat x = itemMargin*row + row*itemViewWH + itemMargin/2;
        CGFloat y = itemMargin*col + col*itemViewWH + itemMargin/2;
        circle.tag = idx + 1;
        circle.frame = DDYRect(x, y, itemViewWH, itemViewWH);
    }];
}

@end

//--------------------------- lockView ---------------------------//
@interface DDYLockView ()
/** 选中的圆数组 */
@property (nonatomic, strong) NSMutableArray <DDYCircleView *>*selectedCircleArray;
/** 当前点位 */
@property (nonatomic, assign) CGPoint currentPoint;
/** 数组清空标识 */
@property (nonatomic, assign) BOOL isCleaned;

@end

@implementation DDYLockView

#pragma mark setter/getter
#pragma mark 设置箭头
- (void)setArrow:(BOOL)arrow {
    _arrow = arrow;
    // 遍历子控件，改变其是否有箭头
    [self.subviews enumerateObjectsUsingBlock:^(DDYCircleView *circle, NSUInteger idx, BOOL *stop) {
        [circle setArrow:arrow];
    }];
}

- (NSMutableArray <DDYCircleView *>*)selectedCircleArray {
    if (!_selectedCircleArray) {
        _selectedCircleArray = [NSMutableArray array];
    }
    return _selectedCircleArray;
}

#pragma mark - 初始化
#pragma mark 类方法初始化,默认裁剪有箭头
+ (instancetype)lockViewWithType:(DDYLockViewType)type {
    return [[self alloc] initWithType:type clip:YES arrow:YES];
}

+ (instancetype)lockViewWithType:(DDYLockViewType)type clip:(BOOL)clip arrow:(BOOL)arrow {
    return [[self alloc] initWithType:type clip:clip arrow:arrow];
}

#pragma mark 初始化方法:初始化type、clip、arrow
- (instancetype)initWithType:(DDYLockViewType)type clip:(BOOL)clip arrow:(BOOL)arrow {
    if (self = [super init]) {
        [self lockViewPrepare];
        self.type  = type;
        self.clip  = clip;
        self.arrow = arrow;
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self lockViewPrepare];
    }
    return self;
}

#pragma mark UI
#pragma mark 视图准备
- (void)lockViewPrepare {
    self.frame = DDYRect(0, 0, DDYSCREENW-lockViewEdgeMargin*2, DDYSCREENW-lockViewEdgeMargin*2);
    self.center = DDYPoint(DDYSCREENW/2, DDYSCREENH*3/5);
    self.clip = YES;  // 默认裁剪
    self.arrow = YES; // 默认有箭头
    self.backgroundColor = circleBgColor;
    for (int i = 0; i < 9; i++) {
        DDYCircleView *circle = [DDYCircleView circleView];
        circle.type = DDYCircleViewTypeGesture;
        circle.arrow = self.arrow;
        [self addSubview:circle];
    }
}

#pragma mark 布局子控件
- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat itemViewWH = circleRadius * 2;
    CGFloat itemMargin = (self.ddy_w - 3*itemViewWH) / 3.f;
    // 九宫格
    [self.subviews enumerateObjectsUsingBlock:^(DDYCircleView *circle, NSUInteger idx, BOOL *stop) {
        NSUInteger row = idx % 3;
        NSUInteger col = idx / 3;
        CGFloat x = itemMargin*row + row*itemViewWH + itemMargin/2;
        CGFloat y = itemMargin*col + col*itemViewWH + itemMargin/2;
        circle.tag = idx + 1;
        circle.frame = DDYRect(x, y, itemViewWH, itemViewWH);
    }];
}

#pragma mark - touch began / touch moved / touch end
#pragma mark touch began
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // 手势重置
    [self gestureReset];
    self.currentPoint = CGPointZero;
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    [self.subviews enumerateObjectsUsingBlock:^(DDYCircleView *circle, NSUInteger idx, BOOL *stop) {
        if (CGRectContainsPoint(circle.frame, point)) {
            circle.state = DDYCircleViewStateSelected;
            [self.selectedCircleArray addObject:circle];
        }
    }];
    // 数组中最后一个对象的处理
    [self.selectedCircleArray lastObject].state = DDYCircleViewStateLastOneSelected;
    [self setNeedsDisplay];
}

#pragma mark touch moved
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.currentPoint = CGPointZero;
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    [self.subviews enumerateObjectsUsingBlock:^(DDYCircleView *circle, NSUInteger idx, BOOL *stop) {
        if (CGRectContainsPoint(circle.frame, point)) {
            if (![self.selectedCircleArray containsObject:circle]) {
                [self.selectedCircleArray addObject:circle];
                // move过程中连线(包含跳跃连线的处理)
                [self calculateAngleAndConnectJumpedCircle];
            }
        } else {
            self.currentPoint = point;
        }
    }];
    
    [self.selectedCircleArray enumerateObjectsUsingBlock:^(DDYCircleView *circle, NSUInteger idx, BOOL *stop) {
        circle.state = DDYCircleViewStateSelected;
        // 如果是登录或验证密码需要改相应状态
        if (self.type == DDYLockViewTypeSetting) {
            circle.state = DDYCircleViewStateLastOneSelected;
        }
    }];
    // 数组中最后一个对象的处理
    [self.selectedCircleArray lastObject].state = DDYCircleViewStateLastOneSelected;
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.isCleaned = NO;
    // 拼手势密码字符串
    NSMutableString *gesture = [NSMutableString string];
    for (DDYCircleView *circle in self.selectedCircleArray) {
        [gesture appendFormat:@"%@", @(circle.tag)];
    }
    CGFloat length = [gesture length];
    if (length == 0) return;
    
    if ([self.delegate respondsToSelector:@selector(lockView:state:)]) {
        // 手势绘制结果处理
        switch (self.type) {
            case DDYLockViewTypeSetting:
            {
                if (length < lockCircleLeast) {
                    [self.delegate lockView:self state:DDYLockViewStateLess];
                    [self changeCircleInSelectedCircleArrayWithSate:DDYCircleViewStateError];
                } else if ([DDYUserDefaultsGet(lockOneKey) length] < lockCircleLeast) {
                    DDYUserDefaultsSet(gesture, lockOneKey);
                    [self.delegate lockView:self state:DDYLockViewStateFirstFinish];
                } else if ([gesture isEqual:DDYUserDefaultsGet(lockOneKey)]) {
                    DDYUserDefaultsSet(gesture, lockEndKey);
                    [self.delegate lockView:self state:DDYLockViewStateSecondFinish];
                } else {
                    [self.delegate lockView:self state:DDYLockViewStateSecondError];
                    [self changeCircleInSelectedCircleArrayWithSate:DDYCircleViewStateError];
                    DDYUserDefaultsSet(nil, lockOneKey);
                }
            }
                break;
            case DDYLockViewTypeLogin:
            {
                if ([gesture isEqual:DDYUserDefaultsGet(lockEndKey)]) {
                    [self.delegate lockView:self state:DDYLockViewStateLoginFinish];
                } else {
                    [self.delegate lockView:self state:DDYLockViewStateLoginError];
                    [self changeCircleInSelectedCircleArrayWithSate:DDYCircleViewStateError];
                }
            }
                break;
            case DDYLockViewTypeVerify:
            {
                if ([gesture isEqual:DDYUserDefaultsGet(lockEndKey)]) {
                    [self.delegate lockView:self state:DDYLockViewStateVerifyFinish];
                } else {
                    [self.delegate lockView:self state:DDYLockViewStateVerifyError];
                    [self changeCircleInSelectedCircleArrayWithSate:DDYCircleViewStateError];
                }
            }
                break;
        }
    }
    [self errorToDisplay];
}

#pragma mark - 私有操作方法
#pragma mark 手势清空重置操作
- (void)gestureReset {
    // 线程安全
    @synchronized (self) {
        if (!self.isCleaned) {
            // 手势完毕,选中的圆回归普通状态
            [self changeCircleInSelectedCircleArrayWithSate:DDYCircleViewStateNormal];
            // 清空保存选中的数组
            [self.selectedCircleArray removeAllObjects];
            // 清空方向
            [self resetAllCirclesDirection];
            // 完成后改变clean状态
            self.isCleaned = YES;
        }
    }
}

#pragma mark 清空所有子控件方向
- (void)resetAllCirclesDirection {
    [self.subviews enumerateObjectsUsingBlock:^(DDYCircleView *circle, NSUInteger idx, BOOL *stop) {
        circle.angle = 0;
    }];
}

#pragma mark 改变选中数组子控件状态
- (void)changeCircleInSelectedCircleArrayWithSate:(DDYCircleViewState)state {
    [self.selectedCircleArray enumerateObjectsUsingBlock:^(DDYCircleView *circle, NSUInteger idx, BOOL *stop) {
        circle.state = state;
        // 如果是错误状态,那就将最后一个按钮特殊处理
        if (state == DDYCircleViewStateError && idx == self.selectedCircleArray.count-1) {
            circle.state = DDYCircleViewStateLastOneError;
        }
    }];
    [self setNeedsDisplay];
}

#pragma mark 每添加一个圆计算一次方向,同时处理跳跃连线
- (void)calculateAngleAndConnectJumpedCircle {
    if (self.selectedCircleArray && self.selectedCircleArray.count>1) {
        // 最后一个对象
        DDYCircleView *last1 = [self.selectedCircleArray lastObject];
        // 倒数第二个对象
        DDYCircleView *last2 = self.selectedCircleArray[self.selectedCircleArray.count-2];
        // 计算角度(反正切)
        last2.angle = atan2(last1.center.y-last2.center.y, last1.center.x-last2.center.x) + M_PI_2;
        // 跳跃连线问题
        DDYCircleView *jumpedCircle = [self selectedCircleContainPoint:[self centerPointWithPoint1:last1.center point2:last2.center]];
        if (jumpedCircle && ![self.selectedCircleArray containsObject:jumpedCircle]) {
            // 把跳跃的圆添加到已选择圆的数组(插入到倒数第二个)
            [self.selectedCircleArray insertObject:jumpedCircle atIndex:self.selectedCircleArray.count-1];
        }
    }
}

#pragma mark 提供两个点返回他们中点
- (CGPoint)centerPointWithPoint1:(CGPoint)point1 point2:(CGPoint)point2 {
    CGFloat x1 = fmax(point1.x, point2.x);
    CGFloat x2 = fmin(point1.x, point2.x);
    CGFloat y1 = fmax(point1.y, point2.y);
    CGFloat y2 = fmin(point1.y, point2.y);
    return CGPointMake((x1+x2)/2, (y1+y2)/2);
}

#pragma mark 判断点是否被圆包含(包含返回圆否则返回nil)
- (DDYCircleView *)selectedCircleContainPoint:(CGPoint)point {
    DDYCircleView *centerCircle = nil;
    for (DDYCircleView *circle in self.subviews) {
        if (CGRectContainsPoint(circle.frame, point)) {
            centerCircle = circle;
        }
    }
    if (![self.selectedCircleArray containsObject:centerCircle]) {
        // 跳跃的点角度和已选择的倒数第二个角度一致
        centerCircle.angle = [self.selectedCircleArray[self.selectedCircleArray.count-2] angle];
    }
    return centerCircle;
}

#pragma mark 错误回显重绘
- (void)errorToDisplay {
    if ([self circleState] == DDYCircleViewStateError || [self circleState] == DDYCircleViewStateLastOneError) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(lockDisplayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self gestureReset];
        });
    } else {
        [self gestureReset];
    }
}

#pragma mark 获取当前圆的状态
- (DDYCircleViewState)circleState {
    return [self.selectedCircleArray firstObject].state;
}

- (void)drawRect:(CGRect)rect {
    // 没有任何选中则return
    if (self.selectedCircleArray && self.selectedCircleArray.count) {
        UIColor *lineColor = [self circleState]==DDYCircleViewStateError ? lineErrorColor : LineNormalColor;
        
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextAddRect(ctx, rect);
        // 是否裁剪
        if (self.clip) {
            [self.subviews enumerateObjectsUsingBlock:^(DDYCircleView *circle, NSUInteger idx, BOOL *stop) {
                // 确定裁剪的形状
                CGContextAddEllipseInRect(ctx, circle.frame);
            }];
        }
        CGContextEOClip(ctx);
        
        for (int i = 0; i<self.selectedCircleArray.count; i++) {
            DDYCircleView *circle = self.selectedCircleArray[i];
            i==0 ? CGContextMoveToPoint(ctx, circle.center.x, circle.center.y) : CGContextAddLineToPoint(ctx, circle.center.x, circle.center.y);
        }
        
        // 连接最后一个按钮到手指当前触摸点
        if (!CGPointEqualToPoint(self.currentPoint, CGPointZero)) {
            [self.subviews enumerateObjectsUsingBlock:^(DDYCircleView *circle, NSUInteger idx, BOOL *stop) {
                if ([self circleState]==DDYCircleViewStateError || [self circleState]==DDYCircleViewStateLastOneError) {
                    // 错误状态下不连接到当前点
                } else {
                    CGContextAddLineToPoint(ctx, self.currentPoint.x, self.currentPoint.y);
                }
            }];
        }
        
        CGContextSetLineCap(ctx, kCGLineCapRound);
        CGContextSetLineJoin(ctx, kCGLineJoinRound);
        CGContextSetLineWidth(ctx, lockLineWidth);
        [lineColor set];
        CGContextStrokePath(ctx);
    }
}

@end
