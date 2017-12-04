//
//  FFMessageImageCell.m
//  SmartMesh
//
//  Created by Rain on 17/12/04.
//  Copyright © 2017年 SmartMesh Foundation All rights reserved.
//

#import "FFMessageImageCell.h"

@interface FFMessageImageCell ()

@property (nonatomic, strong) UIImageView *imgView;

@end

@implementation FFMessageImageCell

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imgView;
}

- (void)setupContentView {
    [super setupContentView];
    [self.contentView addSubview:self.imgView];
}

- (void)handleTapBubble:(UITapGestureRecognizer *)recognizer {
    [super handleTapBubble:recognizer];
    if ([self.delegate respondsToSelector:@selector(messageCell:withMessage:)]) {
        [self.delegate messageCell:self withMessage:self.cellModel.message];
    }
    
}


- (void)setCellModel:(FFMessageCellModel *)cellModel {
    [super setCellModel:cellModel];
    self.imgView.frame = cellModel.imageFrame;
    if ([cellModel.message.uidFrom isEqualToString:SystemLocalID]) { // 在remoteID的聊天中，系统发送
        
    } else {
        self.imgView.image = [FFFileManager chatImgWithMsgID:cellModel.message.messageID uidTo:cellModel.message.remoteID];
    }
}

@end
