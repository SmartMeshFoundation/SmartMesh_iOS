//
//  DDYTextField.m
//  FireFly
//
//  Created by LingTuan on 17/9/26.
//  Copyright © 2017年 NAT. All rights reserved.
//

#import "DDYTextField.h"

@implementation DDYTextField

#pragma mark   控制清除按钮的位置
- (CGRect)clearButtonRectForBounds:(CGRect)bounds {
    return CGRectMake(bounds.origin.x+ bounds.size.width-50, bounds.origin.y+ bounds.size.height-20,16,16);
}

#pragma mark   控制placeHolder的位置，左右缩20
- (CGRect)placeholderRectForBounds:(CGRect)bounds {
    //return CGRectInset(bounds, 10, 0);
    CGRect inset = CGRectMake(bounds.origin.x+10, bounds.origin.y+16, bounds.size.width -10, bounds.size.height);
    return inset;
}
#pragma mark   控制显示文本的位置
- (CGRect)textRectForBounds:(CGRect)bounds {
    //return CGRectInset(bounds, 50, 0);
    CGRect inset = CGRectMake(bounds.origin.x+10, bounds.origin.y, bounds.size.width -10, bounds.size.height);
    return inset;
}
#pragma mark   控制编辑文本的位置
- (CGRect)editingRectForBounds:(CGRect)bounds {
    //return CGRectInset( bounds, 10 , 0 );
    CGRect inset = CGRectMake(bounds.origin.x+10, bounds.origin.y, bounds.size.width -10, bounds.size.height);
    return inset;
}

#pragma mark   控制placeHolder的颜色、字体
- (void)drawPlaceholderInRect:(CGRect)rect {
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    attributes[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    attributes[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    [[self placeholder] drawInRect:rect withAttributes:attributes];
}

@end
