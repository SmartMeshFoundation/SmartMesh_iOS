//
//  FFDiscoverCell.h
//  SmartMesh
//
//  Created by Rain on 17/12/08.
//  Copyright © 2017年 SmartMesh Foundation All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FFDiscoverCell : UITableViewCell

/** height : 95 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (void)loadData:(NSDictionary *)dict;

@end
