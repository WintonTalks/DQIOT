//
//  RobotLeftCell.h
//  WebThings
//
//  Created by machinsight on 2017/6/29.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "EMINormalTableViewCell.h"
#import "ChatModel.h"

@interface RobotLeftCell : EMINormalTableViewCell
- (void)setValuesWithModel:(ChatModel *)model;

- (CGFloat)cellHeight;
@end
