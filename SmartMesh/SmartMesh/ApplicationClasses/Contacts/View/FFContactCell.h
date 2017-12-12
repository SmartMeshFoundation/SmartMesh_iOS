//
//  FFContactCell.h
//  NextApp
//
//  Created by Megan on  17-12-12.
//  Copyright (c) 2017年 SmartMesh Foundation All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,FFContactUserType) {
    FFContactUserListType = 0,     // 通讯录列表
    FFBlackUserType,              // 黑名单列表
};

@interface FFContactCell : UITableViewCell

@property (nonatomic, copy) void (^headBlock)();
@property (nonatomic, strong) FFUser *user;
@property (nonatomic, assign) FFContactUserType type;

/** height : 70 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
