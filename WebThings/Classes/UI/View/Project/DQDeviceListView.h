//
//  DQDeviceListView.h
//  WebThings
//
//  Created by 孙文强 on 2017/9/28.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DQDeviceListView;

typedef NS_ENUM(NSInteger, DQDeviceListViewType) {
  KDQDeviceListViewEditStyle,
  KDQDeviceListViewRemoveStyle
};

@protocol DQDeviceListViewDelegate <NSObject>

/** 获取设备列表 **/
- (void)didConfigDeviceList;

//判断是否租订商,CEO只能看看，无操作权限
- (BOOL)didExpandIsCEO;

/** 侧滑编辑或者删除设备 **/
- (void)didSwipeOptaionStyle:(DQDeviceListView *)deviceView
                        type:(DQDeviceListViewType)type
                   indexPath:(NSIndexPath *)indexPath;

- (void)didSelectedServiceStation:(DQDeviceListView *)deviceView
                        indexPath:(NSIndexPath *)indexPath;
- (void)didSelectedNewDeviceVC:(DQDeviceListView *)deviceView;
@end

@interface DQDeviceListView : UIView
@property (nonatomic,   weak) id<DQDeviceListViewDelegate>delegate;
@property (nonatomic, strong) UITableView *mTableView;

- (void)configAdjustmentView;//CEO没有权限修改

- (void)reloadTableView:(NSMutableArray *)dataArr;

@end
