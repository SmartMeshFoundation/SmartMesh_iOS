//
//  NAAccountCell.h
//  SmartMesh
//
//  Created by Rain on 15/9/11.
//  Copyright © 2017年 SmartMesh Foundation All rights reserved.

#import <UIKit/UIKit.h>
#import "NATModel.h"

@interface NAAccountCell : UITableViewCell

@property (nonatomic, copy) void (^qrCodeBlock)(void);

@property (nonatomic, copy) void (^transferBlock)(void);

@property (nonatomic, strong) NATModel *model;

+ (instancetype)cellWithTabelView:(UITableView *)tableView;

@end
