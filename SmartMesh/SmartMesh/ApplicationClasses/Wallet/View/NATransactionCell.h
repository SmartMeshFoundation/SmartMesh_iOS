//
//  NATransactionCell.h
//  SmartMesh
//
//  Created by Rain on 17/9/11.
//  Copyright © 2017年 SmartMesh Foundation All rights reserved.

#import <UIKit/UIKit.h>
#import "NATransactionItem.h"

@interface NATransactionCell : UITableViewCell

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, strong) NATransactionItem *transactionItem;

@end
