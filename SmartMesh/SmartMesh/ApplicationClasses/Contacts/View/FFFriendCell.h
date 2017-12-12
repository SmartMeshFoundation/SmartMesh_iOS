//
//  FFFriendTableViewCell.h
//  NextApp
//
//  Created by Megan on  17-12-12.
//  Copyright (c) 2017年 SmartMesh Foundation All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FFFriendCell : UITableViewCell

@property(nonatomic,strong)FFUser * user;

- (void)reloadCellUser:(FFUser *)user selected:(BOOL)selected isFixed:(BOOL)fixed;

@end
