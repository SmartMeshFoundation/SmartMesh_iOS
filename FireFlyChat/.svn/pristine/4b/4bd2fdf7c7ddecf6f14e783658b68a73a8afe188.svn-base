//
//  DDYCameraManager.h
//  DDYProject
//
//  Created by LingTuan on 17/8/16.
//  Copyright © 2017年 Starain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDYCameraManager : NSObject

/** 拍照回调 */
@property (nonatomic, copy) void (^takePhotoBlock)(UIImage *image);

/** 单例对象 */
//+ (instancetype)sharedManager;

/** 会话质量 */
@property (nonatomic, copy) NSString *sessionPreset;

/** 初始化 */
- (void)ddy_CameraWithContainer:(UIView * _Nonnull)container;

/** 开启捕捉会话 */
- (void)ddy_StartCaptureSession;

/** 停止捕捉会话 */
- (void)ddy_StopCaptureSession;

/** 切换摄像头 */
- (void)ddy_ToggleCamera;

/** 设置闪光灯模式 */
- (void)ddy_SetFlashMode:(AVCaptureFlashMode)flashMode;

/** 手电筒补光模式 */
- (void)ddy_SetTorchMode:(AVCaptureTorchMode)torchMode;

/** 聚焦/曝光 */
- (void)ddy_FocusAtPoint:(CGPoint)point;

/** 拍照 */
- (void)ddy_TakePhotos;

/** 播放系统拍照声 */
- (void)ddy_palySystemTakePhotoSound;

/** 开始录制视频 */
- (void)ddy_StartRecord;

/** 结束录制视频 */
- (void)ddy_StopRecord;


@end
