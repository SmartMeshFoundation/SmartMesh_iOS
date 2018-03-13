//  Created by R on 18/3/13.
//  Copyright © 2018年 SmartMesh Foundation rights reserved.
//

#import <UIKit/UIKit.h>
#import "RIButtonItem.h"

@interface UIAlertView (Blocks)

-(id)initWithTitle:(NSString *)inTitle message:(NSString *)inMessage cancelButtonItem:(RIButtonItem *)inCancelButtonItem otherButtonItems:(RIButtonItem *)inOtherButtonItems, ... NS_REQUIRES_NIL_TERMINATION;

- (NSInteger)addButtonItem:(RIButtonItem *)item;

@end
