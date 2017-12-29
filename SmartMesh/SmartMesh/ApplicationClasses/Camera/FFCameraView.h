//
//  FFCameraView.h
//  SmartMesh
//
//  Created by LingTuan on 17/10/11.
//  Copyright © 2017年 SmartMesh Foundation All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FFCameraView : UIView

/** 切换摄像头 */
@property (nonatomic, copy) void (^toggleBlock)();
/** 闪光灯模式 */
@property (nonatomic, copy) void (^flashBlock)();
/** 点击返回 */
@property (nonatomic, copy) void (^backBlock)();
/** 点击拍照 */
@property (nonatomic, copy) void (^takeBlock)();
/** 录制事件 */
@property (nonatomic, copy) void (^recordBlock)(BOOL startOrStop);

+ (instancetype)cameraView;

@end
