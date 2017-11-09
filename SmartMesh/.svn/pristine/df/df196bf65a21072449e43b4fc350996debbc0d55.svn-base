//
//  NSBundle+Language.m
//  GreatChef
//
//  Created by 赵赤赤 on 16/8/4.
//  Copyright © 2016年 early bird international. All rights reserved.
//

#import "NSBundle+DDYExtension.h"
#import <objc/runtime.h>

static const char _bundle = 0;

@interface DDYBundleEx : NSBundle

@end

@implementation DDYBundleEx

- (NSString *)localizedStringForKey:(NSString *)key value:(NSString *)value table:(NSString *)tableName {
    NSBundle *bundle = objc_getAssociatedObject(self, &_bundle);
    return bundle ? [bundle localizedStringForKey:key value:value table:tableName] : [super localizedStringForKey:key value:value table:tableName];
}

@end

@implementation NSBundle (DDYExtension)

+ (void)ddy_Language:(NSString *)language {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        object_setClass([NSBundle mainBundle], [DDYBundleEx class]);
    });
    
    objc_setAssociatedObject([NSBundle mainBundle], &_bundle, language ? [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:language ofType:@"lproj"]] : nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
