//
//  DDYVoiceButton.m
//  DDYProject
//
//  Created by LingTuan on 17/11/23.
//  Copyright © 2017年 Starain. All rights reserved.
//

#import "DDYVoiceButton.h"

@implementation DDYVoiceButton

+ (id)btnWithBgImgN:(NSString *)bgImgN bgImgS:(NSString *)bgImgS imgN:(NSString *)imgN imgS:(NSString *)imgS frame:(CGRect)frame isMicPhone:(BOOL)isMicPhone {
    DDYVoiceButton *btn = [DDYVoiceButton customDDYBtn];
    btn.normalImg = [UIImage imageNamed:bgImgN];
    btn.selectImg = [UIImage imageNamed:bgImgS];
    btn.frame = frame;
    btn.ddy_size = btn.normalImg.size;
    if (isMicPhone) {
        [btn setBackgroundImage:btn.normalImg forState:UIControlStateNormal];
        [btn setBackgroundImage:btn.selectImg forState:UIControlStateSelected];
    }
    [btn setImage:[UIImage imageNamed:imgN] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:imgS] forState:UIControlStateSelected];
    btn.imageView.backgroundColor = [UIColor clearColor];
    if (!isMicPhone) {
        btn.bgLayer.contents = (__bridge id _Nullable)(btn.normalImg.CGImage);
    }
    return btn;
}

- (CALayer *)bgLayer {
    if (!_bgLayer) {
        _bgLayer = [[CALayer alloc] init];
        _bgLayer.frame = self.bounds;
        [self.layer insertSublayer:_bgLayer atIndex:0];
    }
    return _bgLayer;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    // 取消CALayer的隐式动画
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    UIImage *image = selected ? self.selectImg : self.normalImg;
    self.bgLayer.contents = (__bridge id _Nullable)(image.CGImage);
    [CATransaction commit];
}

@end
