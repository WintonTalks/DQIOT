//
//  DQArrowInfoWithCell.h
//  WebThings
//
//  Created by 孙文强 on 2017/9/27.
//  Copyright © 2017年 machinsight. All rights reserved.
//  右边带箭头cell，左边文字

#import "DQEMIBaseCell.h"

@interface DQArrowInfoWithCell : DQEMIBaseCell
@property (nonatomic, strong) NSString *configRightTitle;
@property (nonatomic, strong) UILabel *rightLabel;

@end
