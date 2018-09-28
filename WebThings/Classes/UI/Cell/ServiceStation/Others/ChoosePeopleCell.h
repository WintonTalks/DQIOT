//
//  ChoosePeopleCell.h
//  WebThings
//
//  Created by machinsight on 2017/7/3.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "EMINormalTableViewCell.h"
#import "CKCheckBoxButton.h"
#import "HeadImgV.h"
@class ChoosePeopleCell;
@protocol ChoosePeopleCellDelegate <NSObject>

- (void)cellcekBtnClicked:(CKCheckBoxButton *)sender indexPath:(NSIndexPath *)indexPath;

@end
@interface ChoosePeopleCell : EMINormalTableViewCell

@property (nonatomic,strong) NSIndexPath *thisIndexPath;
@property (nonatomic,  weak) id<ChoosePeopleCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet HeadImgV *headV;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *jobLab;
@property (weak, nonatomic) IBOutlet UILabel *phoneLab;
@property (nonatomic,strong)CKCheckBoxButton *cekBtn;/**< 多选框*/
@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;

- (void)setViewValues:(UserModel *)model;
@end
