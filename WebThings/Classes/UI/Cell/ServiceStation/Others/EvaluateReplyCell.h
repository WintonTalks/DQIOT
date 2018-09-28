//
//  EvaluateReplyCell.h
//  WebThings
//
//  Created by machinsight on 2017/8/8.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "EMINormalTableViewCell.h"

@interface EvaluateReplyCell : EMINormalTableViewCell
- (void)setViewValuesWithModel:(ServiceCenterBaseModel *)model;

- (CGFloat)cellHeightWithModel:(ServiceCenterBaseModel *)model;
@end
