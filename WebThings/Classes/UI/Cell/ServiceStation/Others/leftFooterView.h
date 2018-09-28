//
//  leftFooterView.h
//  WebThings
//
//  Created by machinsight on 2017/6/27.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeadImgV.h"
#import "ServiceCenterBaseModel.h"

@interface leftFooterView : UIView
@property (weak, nonatomic) IBOutlet HeadImgV *headImgV;/**头像*/
@property (weak, nonatomic) IBOutlet UILabel *nameLab;/**姓名*/
@property (weak, nonatomic) IBOutlet UILabel *positionLab;/**职位*/
@property (weak, nonatomic) IBOutlet UILabel *timeLab;/**时间*/
@property (nonatomic, retain) IBOutlet UIView *contentView;


- (void)setViewValuesWithModel:(ServiceCenterBaseModel *)model;
@end
