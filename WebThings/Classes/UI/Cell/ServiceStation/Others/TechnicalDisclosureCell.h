//
//  TechnicalDisclosureCell.h
//  WebThings
//
//  Created by machinsight on 2017/8/3.
//  Copyright © 2017年 machinsight. All rights reserved.
//  现场技术交底

#import "EMINormalTableViewCell.h"
#import "ServiceCenterBaseModel.h"

@interface TechnicalDisclosureCell : EMINormalTableViewCell
- (void)setViewValuesWithModel:(ServiceCenterBaseModel *)model;

- (void)setAction1:(SEL)action1 Action2:(SEL)action2 target:(id)target;

- (void)setBtnTag1:(NSInteger)tag1 Tag2:(NSInteger)tag2;


@end
