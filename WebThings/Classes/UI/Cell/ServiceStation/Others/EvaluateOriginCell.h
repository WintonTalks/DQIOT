//
//  EvaluateOriginCell.h
//  WebThings
//
//  Created by machinsight on 2017/8/8.
//  Copyright © 2017年 machinsight. All rights reserved.
//  服务评价cell

#import "EMINormalTableViewCell.h"

@interface EvaluateOriginCell : EMINormalTableViewCell
- (void)setViewValuesWithModel:(ServiceCenterBaseModel *)model;

- (CGFloat)cellHeightWithModel:(ServiceCenterBaseModel *)model;

//servicefinishbtn
- (void)setAction1:(SEL)action1 target:(id)target;
@end
