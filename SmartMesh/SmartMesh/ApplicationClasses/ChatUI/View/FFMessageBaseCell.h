//
//  FFMessageBaseCell.h
//  SmartMesh
//
//  Created by Rain on 17/12/04.
//  Copyright © 2017年 SmartMesh Foundation All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FFMessageCellModel.h"

@class FFMessageBaseCell;

@protocol FFMessageBaseCellDelegate <NSObject>

/** 气泡长按 */
- (void)messageCell:(FFMessageBaseCell *)messageCell longPress:(UILongPressGestureRecognizer *)recognizer;
/** 点击头像 */
- (void)messageCell:(FFMessageBaseCell *)messageCell clickAvatar:(NSString *)uidFrom;
/** 单击事件 */
- (void)messageCell:(FFMessageBaseCell *)messageCell tap:(UITapGestureRecognizer *)recognizer;

/** bubble的点击 */
- (void)messageCell:(FFMessageBaseCell *)messageCell withMessage:(FFMessage *)message;

/** 文字双击 */
//- (void)messageCell:(FFMessageBaseCell *)messageCell doubleTapText:(NSString *)text;
///** 图片单击 */
//- (void)messageCell:(FFMessageBaseCell *)messageCell tapImage:(UIImage *)image;
///** 音频单击 */
//- (void)messageCell:(FFMessageBaseCell *)messageCell tapVoice:(NSString *)messageID;
///** 视频单击 */
//- (void)messageCell:(FFMessageBaseCell *)messageCell tapVideo:(NSString *)videoPath;

@end

@interface FFMessageBaseCell : UITableViewCell
/** 代理 */
@property (nonatomic, weak) id <FFMessageBaseCellDelegate> delegate;
/** 头像 */
@property (nonatomic, strong) UIImageView *avatarView;
/** 昵称 */
@property (nonatomic, strong) UILabel *nameLabel;
/** 位置图标 */
@property (nonatomic, strong) UIImageView *locationImgView;
/** 位置文字 */
@property (nonatomic, strong) UILabel *locationLabel;
/** 气泡 */
@property (nonatomic, strong) UIImageView *bubbleView;
/** 菊花 */
@property (nonatomic, strong) UIActivityIndicatorView *activityView;
/** 重发 */
@property (nonatomic, strong) UIImageView *retryImgView;
/** cell模型 */
@property (nonatomic, strong) FFMessageCellModel *cellModel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
/** 子类中添加控件 */
- (void)setupContentView;

- (void)handleTapBubble:(UITapGestureRecognizer *)recognizer;

@end
