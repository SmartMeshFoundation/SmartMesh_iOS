//
//  FFChatBoxVoice.h
//  SmartMesh
//
//  Created by Rain on 17/11/16.
//  Copyright © 2017年 SmartMesh Foundation All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FFChatBoxVoice : UIView

@property (nonatomic, copy) void (^recordFinish) (NSString *path, NSInteger second);

+ (instancetype)voiceBox;

@end
