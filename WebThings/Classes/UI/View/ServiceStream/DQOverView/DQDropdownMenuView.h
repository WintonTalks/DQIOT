//
//  DQDropdownMenuView.h
//  DQDropdownMenuViewDemo
//
//  Created by Eugene on 2017/9/17.
//  Copyright © 2017年 Eugene. All rights reserved.
//  业务中心-概览下拉菜单

#import <UIKit/UIKit.h>
#import "AddProjectModel.h"

@class DQDropdownMenuView;

@protocol DQDropdownMenuViewDelegate <NSObject>

/** 点击菜单上的item，执行跳转事件 */
- (void)dropdownMenuItemWillPushViewWithProject:(AddProjectModel *)model deviceType:(DeviceTypeModel *)device;

@optional

/** 即将显示菜单 */
- (void)dropdownMenuWillShowView:(DQDropdownMenuView *)menuView;

/** 已经显示菜单 */
- (void)dropdownMenuDidShowView:(DQDropdownMenuView *)menuView;

/** 即将隐藏菜单 */
- (void)dropdownMenuWillDismissView:(DQDropdownMenuView *)menuView;

/** 已经隐藏菜单 */
- (void)dropdownMenuDidDismissView:(DQDropdownMenuView *)menuView;

@end

@interface DQDropdownMenuView : UIView

@property (nonatomic, weak) id<DQDropdownMenuViewDelegate> delegate;

/** 工程项目列表 */
@property (nonatomic, strong) NSArray <AddProjectModel *>*projectAry;

/** 二级页面返回一级页面时，需要默认展示概览时调用此方法 */
- (void)showMenu;

@end
