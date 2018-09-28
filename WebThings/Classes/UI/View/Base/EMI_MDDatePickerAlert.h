//
//  EMI_MDDatePickerAlert.h
//  WebThings
//
//  Created by machinsight on 2017/6/20.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EMI_MDDatePickerAlert;
@protocol EMI_MDDatePickerAlertDelegate <NSObject>

- (void)datePickerDialogDidSelectDate:(nonnull NSDate *)date withSelf:(EMI_MDDatePickerAlert *_Nullable)sender;
@optional
- (void)pickerdidDisappear;
@end
@interface EMI_MDDatePickerAlert : UIControl
@property (nullable, strong, nonatomic) NSDate *selectedDate;
@property (nonnull, strong, nonatomic) NSDate *minimumDate;

@property (nonatomic,strong)UIView * _Nullable fatherV;//父视图，通过是否为nil来判断当前picker是否显示

@property(weak, nonatomic, nullable) id<EMI_MDDatePickerAlertDelegate> delegate;

/**
 展示时间选择器

 @param fatherV 父视图
 @param selfFrame 自己的frame
 */
- (void)showwithFatherV:(UIView *_Nullable)fatherV andSelfFrame:(CGRect)selfFrame;

/**
 设置按钮标题

 @param okTitle 确定标题
 @param cancelTitle 取消标题
 */
- (void)setTitleOk: (nonnull NSString *) okTitle andTitleCancel: (nonnull NSString *) cancelTitle;

/**
 关闭页面
 */
- (void)disShow;
@end
