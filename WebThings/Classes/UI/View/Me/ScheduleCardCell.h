//
//  ScheduleCardCell.h
//  WebThings
//
//  Created by machinsight on 2017/7/4.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "EMIBaseTableViewCell.h"
#import "RemindModel.h"


@interface ScheduleCardCell : EMIBaseTableViewCell

- (void)setViewValuesWithModel:(RemindModel *)model;
@end
