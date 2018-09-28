//
//  ServiceRequestListCell.h
//  WebThings
//
//  Created by machinsight on 2017/7/4.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "EMINormalTableViewCell.h"

@interface ServiceRequestListCell : EMINormalTableViewCell
- (void)setViewValuesWithModel:(ServiceCenterBaseModel *)model;

//servicefinishbtn
- (void)setAction1:(SEL)action1 target:(id)target;
@end
