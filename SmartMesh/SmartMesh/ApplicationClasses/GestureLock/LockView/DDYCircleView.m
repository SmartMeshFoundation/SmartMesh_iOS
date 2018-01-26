//
//  DDYCircleView.m
//  SmartMesh
//
//  Created by Rain on 18/1/26.
//  Copyright © 2018年 SmartMesh Foundation All rights reserved.
//

#import "DDYCircleView.h"

@implementation DDYCircleView

+ (instancetype)circleView {
    return [[self alloc] init];
}

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = lockViewBgColor;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // 上下文旋转
    [self tansformCtx:ctx rect:rect];
    // 画外空心圆
    [self drawOutCircleWithCtx:ctx rect:rect];
    // 画内实心圆
    [self drawInCircleWithCtx:ctx rect:rect];
    // 画三角形
    [self drawTrangleWithCtx:ctx rect:rect];
}

#pragma mark 上下文旋转
- (void)tansformCtx:(CGContextRef)ctx rect:(CGRect)rect {
    CGFloat translateXY = rect.size.width*.5f;
    CGContextTranslateCTM(ctx, translateXY, translateXY);
    CGContextRotateCTM(ctx, self.angle);
    CGContextTranslateCTM(ctx, -translateXY, -translateXY);
}

#pragma mark 画外空心圆
- (void)drawOutCircleWithCtx:(CGContextRef)ctx rect:(CGRect)rect {
    CGRect circleRect = DDYRect(outCircleWidth, outCircleWidth, rect.size.width-2*outCircleWidth, rect.size.height-2*outCircleWidth);
    CGMutablePathRef circlePath = CGPathCreateMutable();
    CGPathAddEllipseInRect(circlePath, NULL, circleRect);
    CGContextAddPath(ctx, circlePath);
    [[self outCircleColor] set];
    CGContextSetLineWidth(ctx, outCircleWidth);
    CGContextStrokePath(ctx);
    CGPathRelease(circlePath);
}

#pragma mark 画内实心圆
- (void)drawInCircleWithCtx:(CGContextRef)ctx rect:(CGRect)rect {
    CGFloat radio = (self.type == DDYCircleViewTypeGesture) ? circleRadio : 1;
    CGFloat circleX = rect.size.width/2 * (1-radio) + outCircleWidth;
    CGFloat circleY = rect.size.height/2 * (1-radio) + outCircleWidth;
    CGFloat circleW = rect.size.width*radio - outCircleWidth*2;
    CGFloat circleH = rect.size.height*radio - outCircleWidth*2;
    CGMutablePathRef circlePath = CGPathCreateMutable();
    CGPathAddEllipseInRect(circlePath, NULL, CGRectMake(circleX, circleY, circleW, circleH));
    [[self inCircleColor] set];
    CGContextAddPath(ctx, circlePath);
    CGContextFillPath(ctx);
    CGPathRelease(circlePath);
}

#pragma mark 画三角形
- (void)drawTrangleWithCtx:(CGContextRef)ctx rect:(CGRect)rect {
    if (self.arrow) {
        CGPoint topPoint = CGPointMake(rect.size.width/2, 10);
        CGMutablePathRef trianglePath = CGPathCreateMutable();
        CGPathMoveToPoint(trianglePath, NULL, topPoint.x, topPoint.y);
        CGPathAddLineToPoint(trianglePath, NULL, topPoint.x - trangleLength/2, topPoint.y + trangleLength/2);
        CGPathAddLineToPoint(trianglePath, NULL, topPoint.x + trangleLength/2, topPoint.y + trangleLength/2);
        CGContextAddPath(ctx, trianglePath);
        [[self trangleColor] set];
        CGContextFillPath(ctx);
        CGPathRelease(trianglePath);
    }
}

#pragma mark 外圆颜色
- (UIColor *)outCircleColor {
    UIColor *color;
    switch (self.state) {
        case DDYCircleViewStateNormal:
            color = outCircleNormalColor;
            break;
        case DDYCircleViewStateSelected:
            color = outCircleSelectedColor;
            break;
        case DDYCircleViewStateError:
            color = outCircleErrorColor;
            break;
        case DDYCircleViewStateLastOneSelected:
            color = outCircleSelectedColor;
            break;
        case DDYCircleViewStateLastOneError:
            color = outCircleErrorColor;
            break;
        default:
            color = outCircleNormalColor;
            break;
    }
    return color;
}

#pragma mark 内圆颜色
- (UIColor *)inCircleColor {
    UIColor *color;
    switch (self.state) {
        case DDYCircleViewStateNormal:
            color = inCircleNormalColor;
            break;
        case DDYCircleViewStateSelected:
            color = inCircleSelectedColor;
            break;
        case DDYCircleViewStateError:
            color = inCircleErrorColor;
            break;
        case DDYCircleViewStateLastOneSelected:
            color = inCircleSelectedColor;
            break;
        case DDYCircleViewStateLastOneError:
            color = inCircleErrorColor;
            break;
        default:
            color = inCircleNormalColor;
            break;
    }
    return color;
}

#pragma mark 三角颜色
- (UIColor *)trangleColor {
    UIColor *color;
    switch (self.state) {
        case DDYCircleViewStateNormal:
            color = trangleNormalColor;
            break;
        case DDYCircleViewStateSelected:
            color = trangleSelectedColor;
            break;
        case DDYCircleViewStateError:
            color = trangleErrorColor;
            break;
        case DDYCircleViewStateLastOneSelected:
            color = trangleSelectedColor;
            break;
        case DDYCircleViewStateLastOneError:
            color = trangleErrorColor;
            break;
        default:
            color = trangleNormalColor;
            break;
    }
    return color;
}

#pragma mark 角度set方法
- (void)setAngle:(CGFloat)angle {
    _angle = angle;
    [self setNeedsDisplay];
}

#pragma mark 状态set方法
- (void)setState:(DDYCircleViewState)state {
    _state = state;
    [self setNeedsDisplay];
}

@end
