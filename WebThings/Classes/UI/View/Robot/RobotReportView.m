//
//  RobotReportView.m
//  WebThings
//
//  Created by Henry on 2017/8/3.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "RobotReportView.h"

@implementation RobotReportView

+(instancetype)viewWithCheck:(CheckModel *)checkModel{
    
    RobotReportView *view = [[[NSBundle mainBundle] loadNibNamed:@"RobotReportView" owner:nil options:nil] lastObject];
    view.check.text = checkModel.checktype;
    view.checkstate.text = checkModel.checkstate;
    return view;
}

@end
