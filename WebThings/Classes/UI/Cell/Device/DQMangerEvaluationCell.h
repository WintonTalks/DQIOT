//
//  DQMangerEvaluationCell.h
//  WebThings
//
//  Created by 孙文强 on 2017/10/4.
//  Copyright © 2017年 machinsight. All rights reserved.
//  人员评价cell

#import <UIKit/UIKit.h>
#import "DQEvaluateListModel.h"

@interface DQMangerEvaluationCell : UITableViewCell
- (void)configEvaluationModel:(DQEvaluateListModel *)listModel;
@end
