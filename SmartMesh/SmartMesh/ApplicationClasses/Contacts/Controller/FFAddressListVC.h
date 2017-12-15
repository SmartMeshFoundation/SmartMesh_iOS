//
//  FFAddressListVC.h
//  SmartMesh
//
//  Created by Megan on 2017/12/15.
//  Copyright © 2017年 SmartMesh Foundation All rights reserved.
//

#import "DDYBaseViewController.h"

typedef NS_ENUM(NSInteger, FFSelectType) {
    FFChatUserCardType = 0,
    FFGroupChatType,
    FFGroupInvitationType,
};

@interface FFAddressListVC : UITableViewController

@property (nonatomic, copy) void(^seletedUsersBlock)(NSMutableArray<FFUser *> *users);

/** 群成员 */
@property (nonatomic, strong) NSMutableDictionary *groupMembers;

@property(nonatomic,assign)FFSelectType selectType;

@end
