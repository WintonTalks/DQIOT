//
//  JCGTDView.h
//  WebThings
//
//  Created by machinsight on 2017/8/9.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DWMsgModel.h"

@interface JCGTDView : UIView
@property (nonatomic, retain) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *xmfzrDnLab;//项目负责人手机号
@property (weak, nonatomic) IBOutlet UILabel *zjeLab;//总金额
- (void)setViewValuesWithModel:(DWMsgModel *)model;
@end
