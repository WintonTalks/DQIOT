//
//  SecondTableVCell.h
//  WebThings
//
//  Created by machinsight on 2017/6/22.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "EMINormalTableViewCell.h"
#import "CKCheckBoxButton.h"
@class SecondTableVCell;
@protocol SecondTableVCellDelegate <NSObject>

- (void)cellcekBtnClicked:(CKCheckBoxButton *)sender indexPath:(NSIndexPath *)indexPath;

@end

@interface SecondTableVCell : EMINormalTableViewCell
@property (nonatomic, strong) NSIndexPath *thisIndexPath;
@property (nonatomic,   weak) id<SecondTableVCellDelegate> delegate;
@property (nonatomic, assign) BOOL checkState;
- (void)setViewWithValues:(NSString *)str;
@end
