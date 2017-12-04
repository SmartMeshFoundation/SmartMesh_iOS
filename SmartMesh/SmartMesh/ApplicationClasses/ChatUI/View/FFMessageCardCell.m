//
//  FFMessageCardCell.m
//  SmartMesh
//
//  Created by Rain on 17/12/04.
//  Copyright © 2017年 SmartMesh Foundation All rights reserved.
//

#import "FFMessageCardCell.h"

@interface FFMessageCardCell ()

@property (nonatomic, strong) UIView *cardView;

@property (nonatomic, strong) DDYHeader *cardHeader;

@property (nonatomic, strong) UILabel *cardName;

@property (nonatomic, strong) UILabel *cardSign;

@end

@implementation FFMessageCardCell

- (void)setupContentView {
    [super setupContentView];
    
    _cardView = UIViewNew.viewBGColor(DDY_ClearColor).viewAddToView(self.contentView);
    
    _cardHeader = [DDYHeader headerWithHeaderWH:ChatCardH-4];
    
    _cardName = UILabelNew.labFont(DDYFont(17)).labAlignmentLeft().labTextColor(DDY_Big_Black);
    
    _cardSign = UILabelNew.labFont(DDYFont(14)).labAlignmentLeft().labTextColor(DDY_Mid_Black);
    
    [_cardView addSubview:_cardHeader.viewSetX(2).viewSetY(2)];
    [_cardView addSubview:_cardName.viewSetFrame(_cardHeader.ddy_right+8, 2, ChatTextMaxW-_cardHeader.ddy_right-16, 20)];
    [_cardView addSubview:_cardSign.viewSetFrame(_cardHeader.ddy_right+8, _cardHeader.ddy_centerY, ChatTextMaxW-_cardHeader.ddy_right-16, 20)];
}

- (void)handleTapBubble:(UITapGestureRecognizer *)recognizer {
    [super handleTapBubble:recognizer];
    if ([self.delegate respondsToSelector:@selector(messageCell:withMessage:)]) {
        [self.delegate messageCell:self withMessage:self.cellModel.message];
    }
}

- (void)setCellModel:(FFMessageCellModel *)cellModel {
    [super setCellModel:cellModel];
    _cardView.frame = cellModel.cardFrame;
    _cardHeader.imgArray = @[[FFUser avatarWithRemarkName:cellModel.message.cardName]];
    _cardHeader.urlArray = @[cellModel.message.cardImage];
    _cardName.text = cellModel.message.cardName;
    _cardSign.text = cellModel.message.cardSign;
    _cardSign.hidden = [NSString ddy_blankString:_cardSign.text];
}

@end
