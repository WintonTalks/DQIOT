//
//  PeopleView.h
//  WebThings
//
//  Created by machinsight on 2017/8/9.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeadImgV.h"

@interface PeopleView : UIView
@property (nonatomic, retain) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIImageView *ywcImgV;
@property (weak, nonatomic) IBOutlet HeadImgV *headImgV;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *dnLab;
@property (weak, nonatomic) IBOutlet UILabel *jobLab;
@property (weak, nonatomic) IBOutlet UIImageView *ydImgV;

- (void)setViewValuesWithModel:(UserModel *)model;
@end
