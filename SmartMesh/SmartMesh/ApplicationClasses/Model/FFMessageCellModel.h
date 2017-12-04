//
//  FFMessageCellModel.h
//  FireFly
//
//  Created by Rain on 17/11/29.
//  Copyright © 2017年 SmartMesh Foundation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FFMessage.h"
#import "FFFileInfo.h"


//typedef NS_ENUM(NSInteger, FFMessageNoticType) {
//
//    FFMessageTypeLiveVideo,
//};

@interface FFMessageCellModel : NSObject
/** 消息模型 */
@property (nonatomic, strong) FFMessage *message;

/** 播放状态 处理互斥 */
@property (nonatomic, assign) BOOL isPlaying;

/** 聊天头像frame */
@property (nonatomic, assign, readonly) CGRect avatarFrame;
/** 用户昵称frame */
@property (nonatomic, assign, readonly) CGRect nameFrame;
/** 位置图片frame */
@property (nonatomic, assign, readonly) CGRect locationImgFrame;
/** 位置文字frame */
@property (nonatomic, assign, readonly) CGRect locationTextFrame;

/** 系统消息frame */
@property (nonatomic, assign, readonly) CGRect tipLabelFrame;

/** 文本消息frame */
@property (nonatomic, assign, readonly) CGRect textFrame;
/** 聊天气泡frame */
@property (nonatomic, assign, readonly) CGRect bubbleFrame;
/** 语音秒数frame */
@property (nonatomic, assign, readonly) CGRect secondFrame;
/** 图片内容frame */
@property (nonatomic, assign, readonly) CGRect imageFrame;
/** 语音内容frame */
@property (nonatomic, assign, readonly) CGRect voiceFrame;
/** 名片内容 */
@property (nonatomic, assign, readonly) CGRect cardFrame;

/** 缓存cell高度 */
@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic,strong) FFFileInfo *fileInfo;

//@property(nonatomic,assign) FFMessageNoticType type;

// Type share user.
@property(nonatomic,assign) NSInteger  shareUserid;
@property(nonatomic,retain) NSString * shareUserName;
@property(nonatomic,retain) NSString * shareUserHead;
@property(nonatomic,retain) NSString * shareUserSign;
@property(nonatomic,assign) NSInteger  shareUserGender;

// Type voice.
@property(nonatomic,retain) NSString * voiceURL;
@property(nonatomic,assign) NSInteger voiceSecond;
@property(nonatomic,assign) NSInteger isPlay;

@property(nonatomic,copy) NSString * liveTitle;
@property(nonatomic,copy) NSString * liveUserName;
@property(nonatomic,copy) NSString * shareURLTitle;
@property (strong,nonatomic) NSString* liveImageURL;
@property(nonatomic,copy) NSString * shareURLContent;
@property(nonatomic,copy) NSString * shareURLImage;

@property(nonatomic,copy) NSString *videoPath; //小视频路径
@property(nonatomic,retain) NSString * coverImageBase64Data;





@end
