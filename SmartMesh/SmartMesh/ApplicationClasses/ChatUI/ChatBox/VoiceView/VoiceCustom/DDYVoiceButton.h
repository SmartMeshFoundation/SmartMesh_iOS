//
//  DDYVoiceButton.h
//  DDYProject
//
//  Created by LingTuan on 17/11/23.
//  Copyright © 2017年 Starain. All rights reserved.
//

#import "DDYButton.h"

@interface DDYVoiceButton : DDYButton

@property (nonatomic, strong) CALayer *bgLayer;

@property (nonatomic, strong) UIImage *normalImg;

@property (nonatomic, strong) UIImage *selectImg;

+ (id)btnWithBgImgN:(NSString *)bgImgN bgImgS:(NSString *)bgImgS imgN:(NSString *)imgN imgS:(NSString *)imgS frame:(CGRect)frame isMicPhone:(BOOL)isMicPhone;

@end
