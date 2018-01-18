//
//  DDYVoiceBottomView.h
//  DDYProject
//
//  Created by LingTuan on 17/11/23.
//  Copyright © 2017年 Starain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDYVoiceBottomView : UIView

+ (instancetype)viewWithFrame:(CGRect)frame;

- (void)contentOffsetX:(CGFloat)offsetX;

- (void)scrollToIndex:(NSInteger)index;

@end
