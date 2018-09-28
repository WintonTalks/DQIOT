//
//  DQDericePhotoListCell.h
//  WebThings
//
//  Created by winton on 2017/10/8.
//  Copyright © 2017年 machinsight. All rights reserved.
//  资质记录cell

#import <UIKit/UIKit.h>
@class DQUserQualificationModel;

@interface DQDericePhotoListCell : MGSwipeTableCell
@property (nonatomic, strong) NSIndexPath *indexPath;
- (void)configQualificationInfoModel:(DQUserQualificationModel *)model;

@end
