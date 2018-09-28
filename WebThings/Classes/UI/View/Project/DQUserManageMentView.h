//
//  DQUserManageMentView.h
//  WebThings
//
//  Created by 孙文强 on 2017/9/29.
//  Copyright © 2017年 machinsight. All rights reserved.
//  项目管理-人员管理

#import <UIKit/UIKit.h>
#import "DriverModel.h"
typedef NS_ENUM(NSInteger,DQUserManageMentViewType) {
  KDQUserManageMentViewStyle, //菜单事件
  KDQUserManageInfoCellStyle //cell事件
};
@class DQUserManageMentView;
@protocol DQUserManageMentViewDelegate;

@interface DQUserManageMentView : UIView
@property (nonatomic, weak) id<DQUserManageMentViewDelegate>delegate;
@property (nonatomic, assign) NSInteger projectID; //项目ID
@property (nonatomic, strong) NSString *projectName; //项目名称
//判断是否租订商,CEO只能看看，无操作权限
- (void)addManageDeriveUserButton;

//引导进来的相册图片，多张/单张
- (void)configAlubmPhoto:(NSArray *)listArray;

//添加新的人员
//- (void)configAddNewUserClicked:(DriverModel *)model;
- (void)configUserListClicked:(NSMutableArray *)result;

@end

@protocol DQUserManageMentViewDelegate <NSObject>

- (BOOL)didUserManageExpandIsCEO;
- (void)didManageMentView:(DQUserManageMentView *)mentView
                    index:(NSInteger)index
                     type:(DQUserManageMentViewType)type
                userModel:(DriverModel *)userModel;
- (void)didEditUserFixClicked:(DQUserManageMentView *)mentView
                    userModel:(DriverModel *)model;
/** 添加人员 **/
- (void)didAddNewUserMentView:(DQUserManageMentView *)mentView;
@end
