//
//  FFNavigationController.h
//  SmartMesh
//
//  Created by RainDou on 18/1/16.
//  Copyright © 2015年 RainDou All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PopBlock)(void);

@interface FFNavigationController : UINavigationController

@property (nonatomic, copy) PopBlock popClicked;

@end

