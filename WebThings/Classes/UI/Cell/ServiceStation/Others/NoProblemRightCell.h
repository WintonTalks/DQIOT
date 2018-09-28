//
//  NoProblemRightCell.h
//  WebThings
//
//  Created by machinsight on 2017/7/1.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "EMINormalTableViewCell.h"
#import "ServiceCenterBaseModel.h"

@interface NoProblemRightCell : EMINormalTableViewCell
- (void)setViewValuesWithModel:(ServiceCenterBaseModel *)model;



//servicefinishbtn
- (void)setAction1:(SEL)action1 target:(id)target;
@end
