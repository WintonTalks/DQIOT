//
//  DQTextFiledInfoCell.h
//  WebThings
//
//  Created by 孙文强 on 2017/9/27.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "DQEMIBaseCell.h"
@class DQTextFiledInfoCell;
typedef void(^DQTextFiledInfoCellBlock) (DQTextFiledInfoCell *infoCell);

@interface DQTextFiledInfoCell : DQEMIBaseCell
@property (nonatomic, strong) UITextField *rightField;
@property (nonatomic, strong) NSString *configPlaceholder;
@property (nonatomic,   copy) DQTextFiledInfoCellBlock InfoCellBlock;
@end
