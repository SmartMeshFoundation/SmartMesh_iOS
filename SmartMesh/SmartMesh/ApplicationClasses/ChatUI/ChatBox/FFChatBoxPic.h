//
//  FFChatBoxPic.h
//  SmartMesh
//
//  Created by Rain on 17/11/16.
//  Copyright © 2017年 SmartMesh Foundation All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FFChatBoxPic : UIView

@property (nonatomic, copy) void (^selectedBlock)(NSArray<UIImage *> *imgArray);

+ (instancetype)picBoxWithCurrentVC:(UIViewController *)vc;

- (void)reloadData;

@end
