//  Created by R on 18/3/13.
//  Copyright © 2018年 SmartMesh Foundation rights reserved.
//

#import <UIKit/UIKit.h>
#import "RIButtonItem.h"

@interface UIActionSheet (Blocks) <UIActionSheetDelegate>

-(id)initWithTitle:(NSString *)inTitle cancelButtonItem:(RIButtonItem *)inCancelButtonItem destructiveButtonItem:(RIButtonItem *)inDestructiveItem otherButtonItems:(RIButtonItem *)inOtherButtonItems, ... NS_REQUIRES_NIL_TERMINATION;

- (NSInteger)addButtonItem:(RIButtonItem *)item;

/** This block is called when the action sheet is dismssed for any reason.
 */
@property (copy, nonatomic) void(^dismissalAction)();

@end
