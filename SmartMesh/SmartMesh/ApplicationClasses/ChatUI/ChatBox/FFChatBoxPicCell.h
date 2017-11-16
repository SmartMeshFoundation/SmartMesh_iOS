//
//  FFChatBoxPicCell.h
//  SmartMesh
//
//  Created by Rain on 17/11/16.
//  Copyright © 2017年 SmartMesh Foundation All rights reserved.
//

#import <UIKit/UIKit.h>

//------------------- 模型 -------------------//
@interface FFchatBoxPicModel : NSObject

@property (nonatomic, strong) PHAsset *asset;

@property (nonatomic, assign, getter=isSelected) BOOL selected;

@property (nonatomic, strong) UIImage *image;

@end

//------------------- cell -------------------//
@interface FFChatBoxPicCell : UICollectionViewCell

@property (nonatomic, copy) void (^selectBlock)(BOOL isSelected);

@property (nonatomic, copy) void (^swipeToSendBlock)(UIImage *image);

@property (nonatomic, strong) FFchatBoxPicModel *model;

@end
