//
//  NewDriverDetailCell.h
//  WebThings
//
//  Created by machinsight on 2017/6/22.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "EMIBaseTableViewCell.h"
#import "DriverModel.h"
@class NewDriverDetailCell;
@protocol NewDriverDetailCellDelegate <NSObject>

@required
- (void)cellBtnClickedWithModel:(DriverModel *)model;//保存按钮
- (void)nextPageClicked;//跳转至司机列表页面
@end
@interface NewDriverDetailCell : EMIBaseTableViewCell
@property (nonatomic,  weak) id<NewDriverDetailCellDelegate> delegate;
@property (nonatomic,strong) DriverModel *m;
- (void)setView;

- (void)setViewWithValues:(UserModel *)model;
- (void)setViewWithDriverValues:(DriverModel *)model;
- (void)hideSaveBtn;

- (BOOL)judgeIsInfoFull;
@end
