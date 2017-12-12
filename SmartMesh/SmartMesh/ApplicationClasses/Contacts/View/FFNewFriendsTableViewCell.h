//
//  FFNewFriendsTableViewCell.h
//  NextApp
//
//  Created by Megan on  17-12-12.
//  Copyright (c) 2017年 SmartMesh Foundation All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,FFUserListType) {
    FFUserListDiscoverType = 0,     // 发现页列表
    FFAddUserListType,              // 好友请求列表
};

@interface FFNewFriendsTableViewCell : UITableViewCell

@property(nonatomic,copy) void(^addFriendBlock)(FFMessage *message);

/** message */
@property (nonatomic, strong) FFMessage * message;

@property(nonatomic,strong)FFUser * user;

@property(nonatomic,assign)FFUserListType userListType;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
