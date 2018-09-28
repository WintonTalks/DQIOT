//
//  DQNewDeviceCell.h
//  WebThings
//
//  Created by winton on 2017/10/18.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceModel.h"

@interface DQNewDeviceCell : MGSwipeTableCell
- (void)configAddDeviceModel:(DeviceModel *)deviceModel
                       count:(NSInteger)count;
@end
