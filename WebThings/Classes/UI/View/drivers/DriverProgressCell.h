//
//  DriverProgressCell.h
//  WebThings
//
//  Created by machinsight on 2017/8/2.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "EMINormalTableViewCell.h"
#import "DWMsgModel.h"

@interface DriverProgressCell : EMINormalTableViewCell
- (void)setViewValuesWithModel:(DWMsgModel *)model;
@end
