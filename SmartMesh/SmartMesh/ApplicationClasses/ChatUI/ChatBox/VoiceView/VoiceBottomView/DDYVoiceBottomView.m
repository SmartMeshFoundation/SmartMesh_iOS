//
//  DDYVoiceBottomView.m
//  DDYProject
//
//  Created by LingTuan on 17/11/23.
//  Copyright © 2017年 Starain. All rights reserved.
//

#import "DDYVoiceBottomView.h"

@interface DDYVoiceBottomView ()
/** 标签容器 */
@property (nonatomic, strong) UIView *labelContainer;
/** 标签数组 */
@property (nonatomic, strong) NSMutableArray *labelArray;
/** 相对比例 */
@property (nonatomic, assign) CGFloat scale;

@end

@implementation DDYVoiceBottomView

+ (instancetype)viewWithFrame:(CGRect)frame {
    return [[self alloc] initWithFrame:frame];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 圆点指示
        [self addSubview:UIViewNew.viewSetFrame(0,0,8,8).viewCornerRadius(4).viewBGColor(DDY_Red).viewSetCenterX(self.ddy_w/2)];
        // 标签容器
        _labelContainer = UIViewNew.viewSetFrame(0,8,self.ddy_w,self.ddy_h-8).viewBGColor(DDY_ClearColor);
        [self addSubview:_labelContainer];
        // 标签数组
        _labelArray = [NSMutableArray array];
        // 设置标签
        UILabel *label1 = [self labelWithTitle:@"变声"];
        UILabel *label2 = [self labelWithTitle:@"对讲"];
        UILabel *label3 = [self labelWithTitle:@"录音"];
        label2.ddy_centerX = self.ddy_w/2;
        label1.ddy_right = label2.ddy_x - 10;
        label3.ddy_x = label2.ddy_right + 10;
        // 相对比例
        _scale = (label2.ddy_centerX-label1.ddy_centerX)/self.ddy_w;
    }
    return self;
}

- (UILabel *)labelWithTitle:(NSString *)title {
    UILabel *label = UILabelNew.labText(DDYLocalStr(title)).labFont(DDYFont(14)).labTextColor(DDY_Black);
    label.ddy_y = 4;
    [label sizeToFit];
    [_labelContainer addSubview:label];
    [_labelArray addObject:label];
    return label;
}

- (void)contentOffsetX:(CGFloat)offsetX {
    _labelContainer.transform = CGAffineTransformMakeTranslation(-offsetX*_scale, 0);
}

- (void)scrollToIndex:(NSInteger)index {
    for (int i=0; i<_labelArray.count; i++) {
        UILabel *label = _labelArray[i];
        label.textColor = i==index ? DDY_Red : DDY_Black;
    }
}

@end
