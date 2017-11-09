//
//  DDYProxy.m
//  DDYProject
//
//  Created by LingTuan on 17/9/15.
//  Copyright © 2017年 Starain. All rights reserved.
//

#import "DDYProxy.h"

@implementation DDYProxy

+ (instancetype)proxyWithTarget:(id)target {
    return [[self alloc] initWithTarget:target];
}

- (instancetype)initWithTarget:(id)target {
    _target = target;
    return self;
}

#pragma mark 获得目标对象的方法签名
- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    return [_target methodSignatureForSelector:sel];
}

#pragma mark 转发给目标对象
- (void)forwardInvocation:(NSInvocation *)invocation {
    if ([_target respondsToSelector:[invocation selector]]) {
        [invocation invokeWithTarget:_target];
    }
}


@end
