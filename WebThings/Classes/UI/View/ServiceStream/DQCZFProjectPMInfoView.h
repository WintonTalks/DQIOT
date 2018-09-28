//
//  DQCZFProjectPMInfoView.h
//  WebThings
//
//  Created by winton on 2017/10/30.
//  Copyright © 2017年 machinsight. All rights reserved.
//  承租方PM下拉view

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DQCZFProjectPMWithType) {
    KDQCZFProjectPM_Edit_Style,   //承租方style，允许编辑
    KDQCZFProjectPM_Forbidden_Style //租定方style，禁止编辑
};

@interface DQCZFProjectPMInfoView : UIView
- (instancetype)initWithFrame:(CGRect)frame
                       pmType:(DQCZFProjectPMWithType)pmType;
- (void)showWithFatherV:(UIView *)fatherV;
- (void)disshow;
- (void)reloadPMData:(NSMutableArray *)pmArr;
@end
