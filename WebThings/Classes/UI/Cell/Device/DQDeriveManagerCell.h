//
//  DQDeriveManagerCell.h
//  WebThings
//
//  Created by 孙文强 on 2017/10/2.
//  Copyright © 2017年 machinsight. All rights reserved.
//  司机-人员管理cell

#import <UIKit/UIKit.h>
#import "DriverModel.h"
@class DQDeriveManagerCell;
@protocol DQDeriveManagerCellDelegate <NSObject>
- (void)didDeriveMentClick:(DQDeriveManagerCell *)managerCell
                     index:(NSInteger)index;
//编辑司机
- (void)didPushEditDeriveClicked:(DQDeriveManagerCell *)managerCell
                           index:(NSInteger)index;
- (void)didFixUserOperAuth:(DQDeriveManagerCell *)managerCell
              deriveWorkID:(NSInteger)workID
                    isAuth:(BOOL)isAuth;

@end

@interface DQDeriveManagerCell : MGSwipeTableCell
@property (nonatomic,   weak) id<DQDeriveManagerCellDelegate>mDelegate;
@property (nonatomic, assign) NSIndexPath *indexMangerPath;
- (void)configDeriveManagerData:(DriverModel *)model
                    projectName:(NSString *)projectName;

@end
