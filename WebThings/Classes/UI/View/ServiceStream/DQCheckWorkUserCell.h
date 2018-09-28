//
//  DQCheckWorkUserCell.h
//  WebThings
//
//  Created by winton on 2017/10/25.
//  Copyright © 2017年 machinsight. All rights reserved.
//  选择工作人员cell

#import <UIKit/UIKit.h>
typedef void(^DQCheckWorkUserCellBlock)(NSIndexPath *selectIndexPath);
@interface DQCheckWorkUserCell : UITableViewCell
@property (nonatomic, assign) NSIndexPath *selectIndexPath;
@property (nonatomic, copy) DQCheckWorkUserCellBlock cellSelectedUserBlock;
- (void)configCormit:(BOOL)isCormit; //确认是否选择
- (void)configCheckWorkModel:(UserModel *)model; //数据来源
@end
