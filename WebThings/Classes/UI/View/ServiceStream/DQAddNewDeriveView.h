//
//  DQAddNewDeriveView.h
//  WebThings
//
//  Created by 孙文强 on 2017/9/18.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DQAddNewDeriveViewType) {
    DQAddNewDeriveViewNewAddStyle, //新增司机
    DQAddNewDeriveViewFixStyle //修改司机信息
};

@class DriverModel;
@class DQAddNewDeriveView;
@protocol DQAddNewDeriveViewDelegate <NSObject>
- (void)addNewDeriveWithModel:(DQAddNewDeriveView *)deriveView  model:(DriverModel *)addModel;
@optional
- (void)pushModifyDeriveVC:(DQAddNewDeriveView *)deriveView;
@end

@interface DQAddNewDeriveView : UIView
@property (nonatomic, weak) id<DQAddNewDeriveViewDelegate>delegate;
@property (nonatomic, strong) DriverModel *infoModel;
@property (nonatomic, assign) DQAddNewDeriveViewType type;
@property (nonatomic, strong) MDTextField *deriveNameField; /**司机姓名*/
@property (nonatomic, strong) MDTextField *numberIDField; /**身份证号*/
@property (nonatomic, strong) MDTextField *phoneField; /**联系电话*/
@property (nonatomic, strong) MDTextField *gzField; /**工资*/

- (DriverModel *)configInitDeriveModel;


@end
