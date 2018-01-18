//
//  DDYVoiceChangeView.h
//  DDYProject
//
//  Created by LingTuan on 17/11/23.
//  Copyright © 2017年 Starain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDYVoiceChangeView : UIView

@property (nonatomic, copy) void (^changeVoiceBoxState) (DDYVoiceBoxState state);

+ (instancetype)viewWithFrame:(CGRect)frame;

@end
