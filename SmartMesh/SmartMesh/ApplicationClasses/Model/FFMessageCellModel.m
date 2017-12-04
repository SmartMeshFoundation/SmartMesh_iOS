//
//  FFMessageCellModel.m
//  FireFly
//
//  Created by Rain on 17/11/29.
//  Copyright © 2017年 SmartMesh Foundation. All rights reserved.
//

#import "FFMessageCellModel.h"
#import "FFEmotionManager.h"
#define MAX_WIDTH 166
#define MIN_WIDTH 75

@implementation FFMessageCellModel

- (void)setMessage:(FFMessage *)message {
    _message = message;
    if ([message.uidFrom isEqualToString:SystemLocalID]) {
        [self systemLayout];
    } else if ([message.uidFrom isEqualToString:[FFLoginDataBase sharedInstance].loginUser.localID]) {
        [self senderLayout];
    } else {
        [self receiverLayout];
    }
}

- (void)senderLayout
{
    _avatarFrame = CGRectMake(DDYSCREENW-ChatMargin-ChatHeadWH, ChatMargin/2., ChatHeadWH, ChatHeadWH);
    
    switch (_message.messageType)
    {
        case FFMessageTypeText:
        {
            NSMutableAttributedString *msgText = [FFEmotionManager transferMessageString:_message.textContent
                                                                   font:ChatTextFont
                                                             lineHeight:ChatTextFont.lineHeight];
            CGSize  textSize = [msgText sizeWithMaxWidth:ChatTextMaxW];
            CGFloat bubbleW = textSize.width + 2*ChatMargin+ChatTriangleW;
            CGFloat bubbleH = textSize.height + 2*ChatMargin;
            CGFloat bubbleX = CGRectGetMinX(_avatarFrame)-ChatHeadToBubble-bubbleW;
            CGFloat bubbleY = 0;
            _bubbleFrame = CGRectMake(bubbleX, bubbleY, bubbleW, bubbleH);
            
            CGFloat textX = CGRectGetMinX(_bubbleFrame)+ChatMargin;
            CGFloat textY = bubbleY+ChatMargin;
            CGFloat textW = textSize.width;
            CGFloat textH = textSize.height;
            _textFrame = CGRectMake(textX, textY, textW, textH);
        }
            break;
            
        case FFMessageTypeImg:
        {
            CGSize imageSize = CGSizeMake(40, 40);
            UIImage *image = [FFFileManager chatImgWithMsgID:_message.messageID uidTo:_message.remoteID];
            if (image) {
                imageSize = [self scaleImageToFit:image];
            }
            
            CGFloat bubbleW = imageSize.width + 2*ChatMargin+ChatTriangleW;
            CGFloat bubbleH = imageSize.height + 2*ChatMargin;
            CGFloat bubbleX = CGRectGetMinX(_avatarFrame)-ChatHeadToBubble-bubbleW;
            CGFloat bubbleY = 0;
            _bubbleFrame = CGRectMake(bubbleX, bubbleY, bubbleW, bubbleH);
            
            CGFloat imageX = CGRectGetMinX(_bubbleFrame)+ChatMargin;
            CGFloat imageY = bubbleY+ChatMargin;
            CGFloat imageW = imageSize.width;
            CGFloat imageH = imageSize.height;
            _imageFrame = CGRectMake(imageX, imageY, imageW, imageH);
        }
            break;
            
        case FFMessageTypeVoice:
        {
            NSInteger seconds = [_message.voiceDuration integerValue];
            CGFloat width = 190.0 / 60 * seconds;
            CGFloat height = 17;
            
            if (width < MIN_WIDTH) {
                width = MIN_WIDTH;
            }
            CGFloat bubbleW = width + 2*ChatMargin+ChatTriangleW;
            CGFloat bubbleH = height + 2*ChatMargin;
            CGFloat bubbleX = CGRectGetMinX(_avatarFrame)-ChatHeadToBubble-bubbleW;
            CGFloat bubbleY = 0;
            _bubbleFrame = CGRectMake(bubbleX, bubbleY, bubbleW, bubbleH);
            
            CGFloat secondW = 10;
            CGFloat secondX = CGRectGetMinX(_bubbleFrame) - ChatHeadToBubble - secondW;
            _secondFrame = CGRectMake(secondX, bubbleY, secondW, bubbleH);
            
            
            CGFloat voiceW = 13;
            CGFloat voiceX = CGRectGetMaxX(_bubbleFrame) - ChatMargin * 2 - voiceW;
            CGFloat voiceY = bubbleY;
            CGFloat voiceH = bubbleH;
            
            _voiceFrame = CGRectMake(voiceX, voiceY, voiceW, voiceH);
            
        }
            break;
        case FFMessageTypeCard:
        {
            CGFloat bubbleW = ChatTextMaxW + 2*ChatMargin+ChatTriangleW;
            CGFloat bubbleH = ChatCardH + 2*ChatMargin;
            CGFloat bubbleX = CGRectGetMinX(_avatarFrame)-ChatHeadToBubble-bubbleW;
            CGFloat bubbleY = 0;
            _bubbleFrame = CGRectMake(bubbleX, bubbleY, bubbleW, bubbleH);
            CGFloat cardX = CGRectGetMinX(_bubbleFrame)+ChatMargin;
            CGFloat cardY = bubbleY+ChatMargin;
            CGFloat cardW = ChatTextMaxW;
            CGFloat cardH = ChatCardH;
            _cardFrame = CGRectMake(cardX, cardY, cardW, cardH);
        }
            break;
            
        default:
            break;
    }
    _cellHeight = MAX(CGRectGetMaxY(_avatarFrame), CGRectGetMaxY(_bubbleFrame))+ChatMargin;

    _avatarFrame = CGRectMake(DDYSCREENW-ChatMargin-ChatHeadWH, _cellHeight-ChatMargin-ChatHeadWH, ChatHeadWH, ChatHeadWH);

}

- (void)receiverLayout
{
    _avatarFrame = CGRectMake(ChatMargin, ChatMargin, ChatHeadWH, ChatHeadWH);
    
    switch (_message.messageType)
    {
        case FFMessageTypeText:
        {
            NSMutableAttributedString *msgText = [FFEmotionManager transferMessageString:_message.textContent
                                                                                    font:ChatTextFont
                                                                              lineHeight:ChatTextFont.lineHeight];
            CGSize  textSize = [msgText sizeWithMaxWidth:ChatTextMaxW];
            CGFloat bubbleW = textSize.width + 2*ChatMargin+ChatTriangleW;
            CGFloat bubbleH = textSize.height + 2*ChatMargin;
            CGFloat bubbleX = CGRectGetMaxX(_avatarFrame)+ChatHeadToBubble;
            CGFloat bubbleY = 0;
            _bubbleFrame = CGRectMake(bubbleX, bubbleY, bubbleW, bubbleH);
            
            CGFloat textX = CGRectGetMinX(_bubbleFrame)+ChatMargin+ChatTriangleW;
            CGFloat textY = bubbleY+ChatMargin;
            CGFloat textW = textSize.width;
            CGFloat textH = textSize.height;
            _textFrame = CGRectMake(textX, textY, textW, textH);
        }
            break;
            
        case FFMessageTypeImg:
        {
            CGSize imageSize = CGSizeMake(40, 40);
            UIImage *image = [FFFileManager chatImgWithMsgID:_message.messageID uidTo:_message.remoteID];
            if (image) {
                imageSize = [self scaleImageToFit:image];
            }
            CGFloat bubbleW = imageSize.width + 2*ChatMargin+ChatTriangleW;
            CGFloat bubbleH = imageSize.height + 2*ChatMargin;
            CGFloat bubbleX = CGRectGetMaxX(_avatarFrame)+ChatHeadToBubble;
            CGFloat bubbleY = 0;
            _bubbleFrame = CGRectMake(bubbleX, bubbleY, bubbleW, bubbleH);
            
            CGFloat imageX = CGRectGetMinX(_bubbleFrame)+ChatMargin+ChatTriangleW;
            CGFloat imageY = bubbleY+ChatMargin;
            CGFloat imageW = imageSize.width;
            CGFloat imageH = imageSize.height;
            _imageFrame = CGRectMake(imageX, imageY, imageW, imageH);
        }
            break;
            
        case FFMessageTypeVoice:
        {
            NSInteger seconds = [_message.voiceDuration integerValue];
            CGFloat width = 190.0 / 60 * seconds;
            CGFloat height = 17;
            
            if (width < MIN_WIDTH) {
                width = MIN_WIDTH;
            }
            
            CGFloat bubbleW = width + 2*ChatMargin+ChatTriangleW;
            CGFloat bubbleH = height + 2*ChatMargin;
            CGFloat bubbleX = CGRectGetMaxX(_avatarFrame) + ChatHeadToBubble;
            CGFloat bubbleY = 0;
            _bubbleFrame = CGRectMake(bubbleX, bubbleY, bubbleW, bubbleH);
            
            CGFloat secondW = 10;
            CGFloat secondX = CGRectGetMaxX(_bubbleFrame) + ChatHeadToBubble;
            _secondFrame = CGRectMake(secondX, bubbleY, secondW, bubbleH);
            
            CGFloat voiceX = CGRectGetMinX(_bubbleFrame) + ChatMargin * 2;
            CGFloat voiceY = bubbleY;
            CGFloat voiceW = 13;
            CGFloat voiceH = bubbleH;
            
            _voiceFrame = CGRectMake(voiceX, voiceY, voiceW, voiceH);
        }
            break;
        case FFMessageTypeCard:
        {
            CGFloat bubbleW = ChatTextMaxW + 2*ChatMargin+ChatTriangleW;
            CGFloat bubbleH = ChatCardH + 2*ChatMargin;
            CGFloat bubbleX = CGRectGetMaxX(_avatarFrame)+ChatHeadToBubble;
            CGFloat bubbleY = 0;
            _bubbleFrame = CGRectMake(bubbleX, bubbleY, bubbleW, bubbleH);
            
            CGFloat cardX = CGRectGetMinX(_bubbleFrame)+ChatMargin+ChatTriangleW;
            CGFloat cardY = bubbleY+ChatMargin;
            CGFloat cardW = ChatTextMaxW;
            CGFloat cardH = ChatCardH;
            _cardFrame = CGRectMake(cardX, cardY, cardW, cardH);
        }
            break;
        default:
            break;
    }
    
    _cellHeight = MAX(CGRectGetMaxY(_avatarFrame), CGRectGetMaxY(_bubbleFrame))+ChatMargin;
    // r头像
    _avatarFrame = CGRectMake(ChatMargin, _cellHeight-ChatMargin-ChatHeadWH, ChatHeadWH, ChatHeadWH);
}

- (void)systemLayout {
    CGSize textSize = [_message.textContent sizeWithMaxWidth:DDYSCREENW-40 font:ChatTimeFont];
    _tipLabelFrame = CGRectMake(20, ChatMargin, textSize.width+14, textSize.height+10);
    _cellHeight = CGRectGetMaxY(_tipLabelFrame)+ChatMargin;
}

- (CGSize)scaleImageToFit:(UIImage *)image {
    CGFloat scaleW = image.size.width *ChatImgWH/MAX(image.size.width, image.size.height);
    CGFloat scaleH = image.size.height*ChatImgWH/MAX(image.size.width, image.size.height);
    return CGSizeMake(scaleW, scaleH);
}

- (CGFloat)cellHeight {
    if ([_message.uidFrom isEqualToString:SystemLocalID]) {
        [self systemLayout];
    } else if ([_message.uidFrom isEqualToString:[FFLoginDataBase sharedInstance].loginUser.localID]) {
        [self senderLayout];
        [self receiverLayout];
    }
    return _cellHeight;
}

@end
