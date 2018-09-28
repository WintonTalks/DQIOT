//
//  DQDeviceMaintainPhotoBrowseCell.h
//  WebThings
//
//  Created by Eugene on 10/19/17.
//  Copyright © 2017 machinsight. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DQDeviceMaintainPhotoBrowseCell : UITableViewCell

@property (nonatomic, copy) void(^reloadCellBlock)(NSArray *images);

@end
