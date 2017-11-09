//
//  UIView+DDYAnimation.m
//  AnimationDemo
//
//  Created by Starain on 16/11/8.
//  Copyright © 2016年 Starain. All rights reserved.
//

#import "UIView+DDYAnimation.h"

#define DDYRand ((float)rand()/(float)RAND_MAX)
#define ParticleW 12.0

@interface DDYLayer : CALayer

@property (nonatomic, strong)UIBezierPath *particlePath;

@end

@implementation DDYLayer

@end

@implementation UIView (DDYAnimation)

- (void)crushAnimation
{
    CGSize imageSize = CGSizeMake(ParticleW, ParticleW);
    CGFloat cols = self.ddy_w / imageSize.width ;
    CGFloat rows = self.ddy_h /imageSize.height;
    int fullCols = floorf(cols);
    int fullRows = floorf(rows);
    
    CGFloat remainderW = self.ddy_w - (fullCols * imageSize.width);
    CGFloat remainderH = self.ddy_h - (fullRows * imageSize.height);
    
    if (cols > fullCols) fullCols++;
    if (rows > fullRows) fullRows++;
    
    CGRect originalFrame = self.layer.frame;
    CGRect originalBounds = self.layer.bounds;
    
    CGImageRef fullImage = [self imageFromLayer:self.layer].CGImage;
    
    if ([self isKindOfClass:[UIImageView class]]) {
        [(UIImageView*)self setImage:nil];
    }
    
    [[self subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [[self.layer sublayers] makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    
    for (int y = 0; y < fullRows; ++y) {
        for (int x = 0; x < fullCols; ++x) {
            
            CGSize tileSize = imageSize;
            
            if (x + 1 == fullCols && remainderW > 0) {
                tileSize.width = remainderW;
            }
            if (y + 1 == fullRows && remainderH > 0) {
                tileSize.height = remainderH;
            }
            
            CGRect layerRect = (CGRect){{x*imageSize.width, y*imageSize.height}, tileSize};
            
            CGImageRef tileImage = CGImageCreateWithImageInRect(fullImage,layerRect);
            
            DDYLayer *layer = [DDYLayer layer];
            layer.frame = layerRect;
            layer.contents = (__bridge id)(tileImage);
            layer.borderWidth = 0.0f;
            layer.borderColor = [UIColor blackColor].CGColor;
            layer.particlePath = [self pathForLayer:layer parentRect:originalFrame];
            [self.layer addSublayer:layer];
            
            CGImageRelease(tileImage);
        }
    }
    
    [self.layer setFrame:originalFrame];
    [self.layer setBounds:originalBounds];
    
    self.layer.backgroundColor = [UIColor clearColor].CGColor;
    
    NSArray *sublayersArray = [self.layer sublayers];
    [sublayersArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        DDYLayer *layer = (DDYLayer *)obj;
        CAKeyframeAnimation *moveAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        moveAnim.path = layer.particlePath.CGPath;
        moveAnim.removedOnCompletion = NO;
        moveAnim.fillMode=kCAFillModeForwards;
        NSArray *timingFunctions = [NSArray arrayWithObjects:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],nil];
        [moveAnim setTimingFunctions:timingFunctions];
        
        NSTimeInterval speed = 2.35*DDYRand;
        CAAnimationGroup *animGroup = [CAAnimationGroup animation];
        animGroup.animations = [NSArray arrayWithObjects:moveAnim, nil];
        animGroup.duration = speed;
        animGroup.fillMode = kCAFillModeForwards;
        animGroup.autoreverses = YES;
        [animGroup setValue:layer forKey:@"animationLayer"];
        [layer addAnimation:animGroup forKey:nil];
    }];
}

- (UIImage *)imageFromLayer:(CALayer *)layer
{
    UIGraphicsBeginImageContext([layer frame].size);
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    return UIGraphicsGetImageFromCurrentImageContext();
}

- (UIBezierPath *)pathForLayer:(CALayer *)layer parentRect:(CGRect)rect
{
    UIBezierPath *particlePath = [UIBezierPath bezierPath];
    [particlePath moveToPoint:layer.position];
    
    float r1 = (DDYRand) + 0.3f;
    float r2 = (DDYRand)+ 0.4f;
    float r3 = r1*r2;
    
    int upOrDown = (r1 <= 0.5) ? 1 : -1;
    
    CGPoint curvePoint = CGPointZero;
    CGPoint endPoint = CGPointZero;
    
    float maxLeftRightShift = 1.f * DDYRand;
    
    CGFloat layerYPosAndHeight = (self.superview.ddy_h-((layer.position.y+layer.frame.size.height)))*DDYRand;
    CGFloat layerXPosAndHeight = (self.superview.ddy_w-((layer.position.x+layer.frame.size.width)))*r3;
    
    float endY = self.superview.ddy_h-self.frame.origin.y;
    
    if (layer.position.x <= rect.size.width*0.5) {
        endPoint = CGPointMake(-layerXPosAndHeight, endY);
        curvePoint= CGPointMake((((layer.position.x*0.5)*r3)*upOrDown)*maxLeftRightShift,-layerYPosAndHeight);
    } else {
        endPoint = CGPointMake(layerXPosAndHeight, endY);
        curvePoint= CGPointMake((((layer.position.x*0.5)*r3)*upOrDown+rect.size.width)*maxLeftRightShift, -layerYPosAndHeight);
    }
    
    [particlePath addQuadCurveToPoint:endPoint
                         controlPoint:curvePoint];
    
    return particlePath;
}

@end
