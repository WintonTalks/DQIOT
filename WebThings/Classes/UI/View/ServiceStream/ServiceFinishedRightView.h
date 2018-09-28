//
//  ServiceFinishedRightView.h
//  WebThings
//
//  Created by machinsight on 2017/7/1.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceCenterBaseModel.h"

@interface ServiceFinishedRightView : UIView
@property (nonatomic, retain) IBOutlet UIView *contentView;

- (void)setViewValuesWithModel:(ServiceCenterBaseModel *)model;
@end
