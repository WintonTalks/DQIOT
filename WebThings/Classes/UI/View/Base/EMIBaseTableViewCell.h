//
//  EMIBaseTableViewCell.h
//  WebThings
//
//  Created by machinsight on 2017/6/12.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "MDTableViewCell.h"

@interface EMIBaseTableViewCell : MDTableViewCell
@property (nonatomic,strong)UserModel *baseUser;
+ (id)cellWithTableView:(UITableView *)tableview;
@end
