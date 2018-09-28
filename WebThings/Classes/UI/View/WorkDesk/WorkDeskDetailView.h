//
//  WorkDeskDetailView.h
//  WebThings
//
//  Created by machinsight on 2017/8/9.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DWMsgModel.h"
#import "PushModel.h"

@interface WorkDeskDetailView : UIView
@property (nonatomic, retain) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIView *xwFatherV;//小维分析
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;


- (void)setCheckBtnHide:(BOOL)hide;

- (void)setViewValuesWithModel:(DWMsgModel *)model;

- (void)setViewValuesWithPushModel:(PushModel *)model;
@end
