//
//  DataCenterScrollView.h
//  WebThings
//
//  Created by machinsight on 2017/7/6.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddProjectModel.h"
@class DataCenterScrollView;
@protocol  DataCenterScrollViewDelegate<NSObject>

- (void)didSelectSecondCellWithDeviceId:(NSInteger)deviceid WithStr:(NSString *)str WithProjectId:(NSInteger)projectid;

@end
@interface DataCenterScrollView : UIView

@property(nonatomic,strong)id<DataCenterScrollViewDelegate> delegate;

- (void)showWithFatherV:(UIView *)fatherV;

- (void)disshow;


/**
 给第一个table赋值

 @param arr arr
 */
- (void)setFirstData:(NSArray <AddProjectModel *> *)arr;
@end
