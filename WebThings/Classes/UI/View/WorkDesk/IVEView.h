//
//  IVECell.h
//  WebThings
//
//  Created by machinsight on 2017/8/9.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DWMsgModel.h"
#import "PushModel.h"

@interface IVEView : UIView
@property (nonatomic, retain) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UILabel *firstLab;
@property (weak, nonatomic) IBOutlet UILabel *secondLab;
@property (weak, nonatomic) IBOutlet UILabel *thirdLab;

- (void)setViewValuesWithModel:(DWMsgModel *)model;

- (void)setViewValuesWithPushModel:(PushModel *)model;
@end
