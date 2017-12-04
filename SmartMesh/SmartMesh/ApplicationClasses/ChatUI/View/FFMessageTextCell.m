//
//  FFMessageTextCell.m
//  SmartMesh
//
//  Created by Rain on 17/12/04.
//  Copyright © 2017年 SmartMesh Foundation All rights reserved.
//  文本聊天

#import "FFMessageTextCell.h"
#import "FFEmotionManager.h"

@interface FFMessageTextCell ()

@property (nonatomic, strong) KILabel *chatLabel;

@end

@implementation FFMessageTextCell

- (KILabel *)chatLabel {
    if (!_chatLabel) {
        _chatLabel = [[KILabel alloc] init];
        _chatLabel.numberOfLines = 0;
        _chatLabel.font = ChatTextFont;
        _chatLabel.textColor = DDY_Mid_Black;
        _chatLabel.textAlignment = NSTextAlignmentCenter;
        [_chatLabel addTapTarget:self action:@selector(handleDoubleTap:) number:2];
    }
    return _chatLabel;
}

- (void)setupContentView {
    [super setupContentView];
    [self.contentView addSubview:self.chatLabel];
    __weak __typeof__(self) weakSelf = self;
    _chatLabel.urlLinkTapHandler = ^(KILabel *label, NSString *string, NSRange range) {
        [weakSelf urlSkip:DDYURLStr(string)];
    };
}

- (void)urlSkip:(NSURL *)url
{
    
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)recognizer {
    
}

- (void)setCellModel:(FFMessageCellModel *)cellModel {
    [super setCellModel:cellModel];
    self.chatLabel.frame = cellModel.textFrame;
    self.chatLabel.attributedText = [FFEmotionManager transferMessageString:cellModel.message.textContent
                                                                       font:self.chatLabel.font
                                                                 lineHeight:self.chatLabel.font.lineHeight];
}

@end
