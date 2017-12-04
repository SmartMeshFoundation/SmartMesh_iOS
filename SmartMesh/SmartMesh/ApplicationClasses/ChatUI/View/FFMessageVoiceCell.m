//
//  FFMessageVoiceCell.m
//  SmartMesh
//
//  Created by Rain on 17/12/04.
//  Copyright © 2017年 SmartMesh Foundation All rights reserved.
//

#import "FFMessageVoiceCell.h"
#define MAX_WIDTH 166
#define MIN_WIDTH 75

@interface FFMessageVoiceCell ()

@property(nonatomic,retain) NSString * playPath;

@property (nonatomic, strong) UILabel *secondLbl;

@end

@implementation FFMessageVoiceCell


-(void) dealloc {
    [_tip stopAnimating];
}

- (UIImageView *)tip {
    if (!_tip) {
        _tip = [[UIImageView alloc] init];
        _tip.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _tip;
}

- (UILabel *)secondLbl {
    if (!_secondLbl) {
        _secondLbl = [[UILabel alloc] init];
        _secondLbl.font = NA_FONT(13);
        _secondLbl.textColor = [UIColor lightGrayColor];
    }
    return _secondLbl;
}

- (void)setupContentView {
    [super setupContentView];
    [self.contentView addSubview:self.secondLbl];
    [self.contentView addSubview:self.tip];
}

- (void)setCellModel:(FFMessageCellModel *)cellModel
{
    [super setCellModel:cellModel];
    self.tip.frame = cellModel.voiceFrame;
    self.secondLbl.frame = cellModel.secondFrame;
    self.secondLbl.text = cellModel.message.voiceDuration;
    if ([cellModel.message.uidFrom isEqualToString:[FFLoginDataBase sharedInstance].loginUser.localID]) { // 在remoteID的聊天中，我本人发送
        self.tip.image = [UIImage imageNamed:@"chat_me_voice1.png"];
        self.tip.animationImages = [self animationImgs:@[@"chat_me_voice2",@"chat_me_voice3",@"chat_me_voice2",@"chat_me_voice1"]];
        self.tip.animationDuration = 0.5;
    } else { // 在remoteID的聊天中，他人发送
        self.tip.image = [UIImage imageNamed:@"chat_voice1.png"];
        self.tip.animationImages = [self animationImgs:@[@"chat_voice2",@"chat_voice3",@"chat_voice2",@"chat_voice1"]];
        self.tip.animationDuration = 0.5;
    }
}

- (NSMutableArray *)animationImgs:(NSArray *)array {
    NSMutableArray *imgs = [NSMutableArray array];
    for (NSString *imgName in array) {
        [imgs addObject:[UIImage imageNamed:imgName]];
    }
    return imgs;
}

- (void)handleTapBubble:(UITapGestureRecognizer *)recognizer
{
    [super handleTapBubble:recognizer];
    if (!self.tip.isAnimating) {
        [self.tip startAnimating];
        if ([self.delegate respondsToSelector:@selector(messageCell:withMessage:)]) {
            [self.delegate messageCell:self withMessage:self.cellModel.message];
        }
        [self performSelector:@selector(stopButtonAnimation) withObject:nil afterDelay:[self.cellModel.message.voiceDuration integerValue]];
    }
}

- (void)stopButtonAnimation {
   [self.tip stopAnimating];
}

@end
