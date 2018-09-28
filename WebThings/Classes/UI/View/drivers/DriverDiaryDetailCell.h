//
//  DriverDiaryDetailCell.h
//  WebThings
//
//  Created by machinsight on 2017/7/27.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "EMINormalTableViewCell.h"
#import "CheckModel.h"
@class DriverDiaryDetailCell;
@protocol DriverDiaryDetailCellDelegate <NSObject>

@optional
- (void)didSelectStateWithCellIndex:(NSInteger)index WithModel:(CheckModel *)m;

@required
- (void)didClickBtnWithCellIndex:(NSInteger)index WithModel:(CheckModel *)m;
@end
@interface DriverDiaryDetailCell : EMINormalTableViewCell
@property (nonatomic,  weak) id<DriverDiaryDetailCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *stateBtn;

@property (nonatomic,strong)CheckModel *thisModel;
@property (nonatomic,assign)NSInteger index;//第几个cell
- (void)setViewValuesWithModel:(CheckModel *)model;
@end
