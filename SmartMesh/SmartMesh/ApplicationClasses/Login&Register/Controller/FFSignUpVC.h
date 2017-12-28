//
//  FFSignUpVC.h
//  SmartMesh
//
//  Created by Megan on 2017/10/12.
//  Copyright © 2017年 SmartMesh Foundation All rights reserved.
//

#import "DDYBaseViewController.h"

typedef enum _ViewType
{
    LoginType = 1,
    SignupType = 2,
    walletType = 3
    
}ViewType;

@interface FFSignUpVC : DDYBaseViewController

@property(nonatomic,assign) ViewType viewType;

@end
