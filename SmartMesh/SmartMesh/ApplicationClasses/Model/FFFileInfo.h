//
//  FFFileInfo.h
//  FireFly
//
//  Created by Rain on 17/11/29.
//  Copyright © 2017年 SmartMesh Foundation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>

typedef NS_ENUM(NSInteger, FFGroupFileStateType) {
    
    
    FFGroupFileStateTypeNormally = 0,
    FFGroupFileStateTypeUploading,
    FFGroupFileStateTypeUploadFailure,
    FFGroupFileStateTypeDownloading,
    FFGroupFileStateTypeDownloadFailure,
    FFGroupFileStateTypeLocalExist,
    FFGroupFileStateTypeUploadSuccess,
    FFGroupFileStateTypeDownloadSuccess,
    FFGroupFileStateTypeDateExpired          
    
};

@interface FFFileInfo : NSObject

@property (nonatomic,assign)NSInteger fid;
@property (nonatomic,copy) NSString * fileName;
@property (nonatomic,copy) NSString * showFileName;
@property (nonatomic,assign) double  fileSize;
@property (nonatomic,copy) NSString * fileURL;
@property (nonatomic,copy) NSString * fileType;
@property (nonatomic,copy) NSString * userName;
@property (nonatomic,copy) NSString * fileDate;
@property (nonatomic,copy) NSString * fileSourceName;
@property (nonatomic,assign) NSInteger   fileSource;  //文件类型 0消息文件 1群组文件 2群组文件已被管理员删除

@property (nonatomic,copy) NSString * dateline;
@property (nonatomic,copy) NSString * expireTime;
@property (nonatomic,copy) NSString * webFileURL;
@property (nonatomic,assign) NSInteger groupId;
@property (nonatomic,assign) FFGroupFileStateType status; //解析 不传值 默认  NAGroupFileStateTypeNormally

@property (nonatomic,assign) NSInteger isDel;
@property (nonatomic,assign) NSInteger isCollect;

@property (nonatomic,copy) NSString * formatFileSize;
@property (nonatomic,copy) NSString * collectTime;
@property (nonatomic,strong) ALAsset * videoAsset;
@property (nonatomic,copy) NSURL * videoUrl;


- (instancetype)initWithDictionary:(NSDictionary *)dic;


@end
