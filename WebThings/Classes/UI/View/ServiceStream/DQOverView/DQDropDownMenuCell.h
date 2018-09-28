//
//  DQDropDownMenuCell.h
//  WebThings
//
//  Created by Eugene on 2017/9/7.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceTypeModel.h"

typedef void(^DeviceTypeBlock)();

@interface DQDropDownMenuCell : UICollectionViewCell

@property (nonatomic, strong) DeviceTypeModel *deviceType;

@property (nonatomic, copy) DeviceTypeBlock typeBlock;

@end
