//
//  FFMessageCellModel.m
//  SmartMesh
//
//  Created by Rain on 18/1/206.
//  Copyright © 2018年 SmartMesh Foundation All rights reserved.
//

#import "FFMessageCellModel.h"
#import "FFEmotionManager.h"
#define MAX_WIDTH 166
#define MIN_WIDTH 30

@implementation FFMessageCellModel

- (void)setMessage:(FFMessage *)message {
    _message = message;
    if ([message.uidFrom isEqualToString:SystemLocalID]) { // 在remoteID的聊天中，系统发送
        [self systemLayout];
    } else if ([message.uidFrom isEqualToString:[FFLoginDataBase sharedInstance].loginUser.localID]) { // 在remoteID的聊天中，我本人发送
        [self senderLayout];
    } else { // 在remoteID的聊天中，他人发送
        [self receiverLayout];
    }
}

- (void)senderLayout
{
    // ---------------------------------- 公共部分 ---------------------------------- //
    // 时间
    CGSize textSize = [[NSDate chatPageTime:DDYStrFormat(@"%ld",(long)_message.timeStamp)] sizeWithMaxWidth:DDYSCREENW-40 font:ChatTimeFont];
    _timeFrame = _message.isShowTime ? DDYRect(10, ChatMargin, textSize.width+14, textSize.height+12) : DDYRect(0, 0, 0, 0);
    // 头像
    _avatarFrame = CGRectMake(DDYSCREENW-ChatMargin-ChatHeadWH, ChatMargin, ChatHeadWH, ChatHeadWH);
    
    switch (_message.messageType)
    {
        case FFMessageTypeText:
        {
            NSMutableAttributedString *msgText;
            if (_message.attributedString) {
                msgText = _message.attributedString;
            } else {
                msgText = [FFEmotionManager transferMessageString:_message.textContent
                                                             font:ChatTextFont
                                                       lineHeight:ChatTextFont.lineHeight];
                _message.attributedString = msgText;
            }
            CGSize  textSize = [msgText sizeWithMaxWidth:ChatTextMaxW];
            CGFloat bubbleW = textSize.width + 2*ChatMargin+ChatTriangleW;
            CGFloat bubbleH = textSize.height + 2*ChatMargin;
            CGFloat bubbleX = CGRectGetMinX(_avatarFrame)-ChatHeadToBubble-bubbleW;
            CGFloat bubbleY = ChatMargin + _timeFrame.size.height + _timeFrame.origin.y;
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
            UIImage *image = [UIImage imageWithData:[[NSData alloc] initWithBase64Encoding:_message.imgBase64Data]];
            if (image) {
                imageSize = [self scaleImageToFit:image];
            }
            CGFloat imgMargin = 1;
            
            CGFloat bubbleW = imageSize.width;// + ChatTriangleW;
            CGFloat bubbleH = imageSize.height;
            CGFloat bubbleX = CGRectGetMinX(_avatarFrame)-ChatHeadToBubble-bubbleW;
            CGFloat bubbleY = ChatMargin + _timeFrame.size.height + _timeFrame.origin.y;
            _bubbleFrame = CGRectMake(bubbleX, bubbleY, bubbleW, bubbleH);
            
//            CGFloat imageX = CGRectGetMinX(_bubbleFrame)+imgMargin;
//            CGFloat imageY = bubbleY+imgMargin;
//            CGFloat imageW = imageSize.width;
//            CGFloat imageH = imageSize.height;
//            _imageFrame = CGRectMake(imageX, imageY, imageW, imageH);
            _imageFrame = _bubbleFrame;
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
            CGFloat bubbleY = ChatMargin + _timeFrame.size.height + _timeFrame.origin.y;
            _bubbleFrame = CGRectMake(bubbleX, bubbleY, bubbleW, bubbleH);
            
            CGFloat secondW = (seconds / 10.0 + 1) * 15;
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
            CGFloat bubbleW = ChatCardMaxW + 2*ChatMargin+ChatTriangleW;
            CGFloat bubbleH = ChatCardH + 2*ChatMargin;
            CGFloat bubbleX = CGRectGetMinX(_avatarFrame)-ChatHeadToBubble-bubbleW;
            CGFloat bubbleY = ChatMargin + _timeFrame.size.height + _timeFrame.origin.y;
            _bubbleFrame = CGRectMake(bubbleX, bubbleY, bubbleW, bubbleH);
            CGFloat cardX = CGRectGetMinX(_bubbleFrame)+ChatMargin;
            CGFloat cardY = bubbleY+ChatMargin;
            CGFloat cardW = ChatCardMaxW;
            CGFloat cardH = ChatCardH;
            _cardFrame = CGRectMake(cardX, cardY, cardW, cardH);
            _cardLineColor = DDY_LightGray;
        }
            break;
            
        default:
            break;
    }
    _cellHeight = MAX(CGRectGetMaxY(_avatarFrame), CGRectGetMaxY(_bubbleFrame))+ChatMargin;
    // s头像
    _avatarFrame = CGRectMake(DDYSCREENW-ChatMargin-ChatHeadWH, _bubbleFrame.origin.y, ChatHeadWH, ChatHeadWH);

}

- (void)receiverLayout
{
    // ---------------------------------- 公共部分 ---------------------------------- //
    // 时间
    CGSize textSize = [[NSDate chatPageTime:DDYStrFormat(@"%ld",(long)_message.timeStamp)] sizeWithMaxWidth:DDYSCREENW-40 font:ChatTimeFont];
    _timeFrame = _message.isShowTime ? DDYRect(10, ChatMargin, textSize.width+14, textSize.height+12) : DDYRect(0, 0, 0, 0);
    // 头像
    _avatarFrame = CGRectMake(ChatMargin, ChatMargin, ChatHeadWH, ChatHeadWH);
    
    switch (_message.messageType)
    {
        case FFMessageTypeText:
        {
            NSMutableAttributedString *msgText;
            if (_message.attributedString) {
                msgText = _message.attributedString;
            } else {
                msgText = [FFEmotionManager transferMessageString:_message.textContent
                                                             font:ChatTextFont
                                                       lineHeight:ChatTextFont.lineHeight];
                _message.attributedString = msgText;
            }
            CGSize  textSize = [msgText sizeWithMaxWidth:ChatTextMaxW];
            CGFloat bubbleW = textSize.width + 2*ChatMargin+ChatTriangleW;
            CGFloat bubbleH = textSize.height + 2*ChatMargin;
            CGFloat bubbleX = CGRectGetMaxX(_avatarFrame)+ChatHeadToBubble;
            CGFloat bubbleY = ChatMargin + _timeFrame.size.height + _timeFrame.origin.y;
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
            UIImage *image = [UIImage imageWithData:[[NSData alloc] initWithBase64Encoding:_message.imgBase64Data]];
            if (image) {
                imageSize = [self scaleImageToFit:image];
            }
            CGFloat imgMargin = 1;
            
            CGFloat bubbleW = imageSize.width;//+ChatTriangleW;
            CGFloat bubbleH = imageSize.height;
            CGFloat bubbleX = CGRectGetMaxX(_avatarFrame)+ChatHeadToBubble;
            CGFloat bubbleY = ChatMargin + _timeFrame.size.height + _timeFrame.origin.y;
            _bubbleFrame = CGRectMake(bubbleX, bubbleY, bubbleW, bubbleH);
            
//            CGFloat imageX = CGRectGetMinX(_bubbleFrame)+imgMargin+ChatTriangleW;
//            CGFloat imageY = bubbleY+imgMargin;
//            CGFloat imageW = imageSize.width;
//            CGFloat imageH = imageSize.height;
//            _imageFrame = CGRectMake(imageX, imageY, imageW, imageH);
            _imageFrame = _bubbleFrame;
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
            CGFloat bubbleY = ChatMargin + _timeFrame.size.height + _timeFrame.origin.y;
            _bubbleFrame = CGRectMake(bubbleX, bubbleY, bubbleW, bubbleH);
            
            CGFloat secondW = (seconds / 10.0 + 1) * 15;
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
            CGFloat bubbleW = ChatCardMaxW + 2*ChatMargin+ChatTriangleW;
            CGFloat bubbleH = ChatCardH + 2*ChatMargin;
            CGFloat bubbleX = CGRectGetMaxX(_avatarFrame)+ChatHeadToBubble;
            CGFloat bubbleY = ChatMargin + _timeFrame.size.height + _timeFrame.origin.y;
            _bubbleFrame = CGRectMake(bubbleX, bubbleY, bubbleW, bubbleH);
            
            CGFloat cardX = CGRectGetMinX(_bubbleFrame)+ChatMargin+ChatTriangleW;
            CGFloat cardY = bubbleY+ChatMargin;
            CGFloat cardW = ChatCardMaxW;
            CGFloat cardH = ChatCardH;
            _cardFrame = CGRectMake(cardX, cardY, cardW, cardH);
            _cardLineColor = DDYRGBA(225, 225, 225, 1);
        }
            break;
        default:
            break;
    }
    
    _cellHeight = MAX(CGRectGetMaxY(_avatarFrame), CGRectGetMaxY(_bubbleFrame))+ChatMargin;
    // r头像
    _avatarFrame = CGRectMake(ChatMargin, _bubbleFrame.origin.y, ChatHeadWH, ChatHeadWH);
}

- (void)systemLayout {
    CGSize textSize = [_message.textContent sizeWithMaxWidth:DDYSCREENW-40 font:ChatTimeFont];
    _tipLabelFrame = CGRectMake(20, ChatMargin, textSize.width+14, textSize.height+12);
    _cellHeight = CGRectGetMaxY(_tipLabelFrame)+ChatMargin;
}

- (CGSize)scaleImageToFit:(UIImage *)image {
    CGFloat scaleW = image.size.width *ChatImgWH/MAX(image.size.width, image.size.height);
    CGFloat scaleH = image.size.height*ChatImgWH/MAX(image.size.width, image.size.height);
    return CGSizeMake(scaleW, scaleH);
}

- (CGFloat)cellHeight {
    if ([_message.uidFrom isEqualToString:SystemLocalID]) { // 在remoteID的聊天中，系统发送
        [self systemLayout];
    } else if ([_message.uidFrom isEqualToString:[FFLoginDataBase sharedInstance].loginUser.localID]) { // 在remoteID的聊天中，我本人发送
        [self senderLayout];
    } else { // 在remoteID的聊天中，他人发送
        [self receiverLayout];
    }
    return _cellHeight;
}

@end
