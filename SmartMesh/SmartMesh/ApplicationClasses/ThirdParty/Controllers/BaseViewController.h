//  Created by R on 18/3/7.
//  Copyright © 2018年 SmartMesh Foundation rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

/**
 *  子类化返回事件重写
 *
 *  @return YES则可以返回，NO则不能返回
 */
- (BOOL)isNavigationBack;

@end
