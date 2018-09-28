//
//  BusinessCenterCell.h
//  WebThings
//
//  Created by machinsight on 2017/6/12.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "AddProjectModel.h"

@interface BusinessCenterCell : MGSwipeTableCell
+ (id)cellWithTableView:(UITableView *)tableview;

- (void)setViewWithValues:(AddProjectModel *)model;
@end
