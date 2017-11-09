//
//  DDYQRCodeManager.h
//  DDYProject
//
//  Created by LingTuan on 17/8/8.
//  Copyright © 2017年 Starain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreImage/CoreImage.h>
#import <AVFoundation/AVFoundation.h>

#define scanY 120.0
#define scanW 240.0
#define scanX (DDYSCREENW/2.0-scanW/2.0)

@protocol DDYQRCodeManagerDelegate <NSObject>

@required
- (void)ddy_QRCodeScanResult:(NSString *)result success:(BOOL)success;

@end

@interface DDYQRCodeManager : NSObject

/** 扫码结果Block 优先代理 */
@property (nonatomic, copy) void (^scanResult)(NSString *resultStr, BOOL success);
/** 扫码结果Delegate 优先代理 */
@property (nonatomic, weak) id <DDYQRCodeManagerDelegate> delegate;

/** 是否播放音效 默认播放 */
@property (nonatomic, assign) BOOL playSound;

/** 单例对象 */
//+ (instancetype)sharedManager;

/** 生成普通条形码 */
- (UIImage *)ddy_BarCodeWithData:(NSString *)data size:(CGSize)size;
 
/** 生成彩色条形码 */
- (UIImage *)ddy_BarCodeWithData:(NSString *)data size:(CGSize)size color:(UIColor *)color bgColor:(UIColor *)bgColor;

/** 生成普通二维码 */
- (UIImage *)ddy_QRCodeWithData:(NSString *)data width:(CGFloat)width;

/** 生成logo二维码 */
- (UIImage *)ddy_QRCodeWithData:(NSString *)data width:(CGFloat)width logo:(UIImage *)logo logoScale:(CGFloat)logoScale;

/** 生成彩色二维码 */
- (UIImage *)ddy_QRCodeWithData:(NSString *)data width:(CGFloat)width color:(UIColor *)color bgColor:(UIColor *)bgColor;

/** 拍照扫描二维码 */
- (void)ddy_ScanQRCodeWithCameraContainer:(UIView *)container;

/** 开始运行会话 */
- (void)ddy_startRunningSession;

/** 停止运行会话 */
- (void)ddy_stopRunningSession;

/** 图片读取二维码 */
- (void)ddy_scanQRCodeWithImage:(UIImage *)image;

/** 利用UIImagePickerViewController选取二维码图片 */
- (void)ddy_imgPickerVCWithCurrentVC:(UIViewController *)controller;

/** 播放音效 */
- (void)ddy_palySound:(NSString *)soundName;

/** 打开关闭闪光灯--持续 */
+ (void)ddy_turnOnFlashLight:(BOOL)on;

@end
