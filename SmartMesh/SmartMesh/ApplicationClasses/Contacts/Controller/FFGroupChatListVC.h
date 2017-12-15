//
//  FFGroupChatListVC.h
//  SmartMesh
//
//  Created by Megan on 2017/12/15.
//  Copyright © 2017年 SmartMesh Foundation All rights reserved.
//

#import "DDYBaseViewController.h"

@interface FFGroupChatListVC : DDYBaseViewController

@property(nonatomic,copy) void (^selectedAction)();

-(instancetype) initWithSelectMode;

@end
