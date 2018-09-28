//
//  NewDriverCell.h
//  WebThings
//
//  Created by machinsight on 2017/6/22.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "EMIBaseTableViewCell.h"
#import "DriverModel.h"

@interface NewDriverCell : EMIBaseTableViewCell
- (void)setViewWithValues:(DriverModel *)m;
@end
