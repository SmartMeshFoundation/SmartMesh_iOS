//
//  DDYVoiceChangePlayCell.h
//  DDYProject
//
//  Created by LingTuan on 17/11/27.
//  Copyright © 2017年 Starain. All rights reserved.
//

#import <UIKit/UIKit.h>

//------------------------------- 模型 -------------------------------//
@interface DDYVoiceChangeModel : NSObject

@property (nonatomic, strong) NSString *title;

@property (nonatomic, assign) NSString *pitch;

@property (nonatomic, strong) NSString *changedPath;

+ (id)modelWithDict:(NSDictionary *)dict;

@end

//------------------------------- cell -------------------------------//
@interface DDYVoiceChangePlayCell : UICollectionViewCell

@property (nonatomic, copy) void (^startPlayBlock)(DDYVoiceChangePlayCell *cell);

@property (nonatomic, copy) void (^endPlayBlock)(DDYVoiceChangePlayCell *cell);

@property (nonatomic, strong) DDYVoiceChangeModel *model;

- (void)playRecord;

- (void)updateLevels;

- (void)endPlay;

@end
