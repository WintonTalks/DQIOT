//
//  RobotReportView.h
//  WebThings
//
//  Created by Henry on 2017/8/3.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CheckModel.h"
@interface RobotReportView : UIView
@property (weak, nonatomic) IBOutlet UILabel *check;
@property (weak, nonatomic) IBOutlet UILabel *checkstate;

+(instancetype)viewWithCheck:(CheckModel *)checkModel;
@end
