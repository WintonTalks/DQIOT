//
//  DQBusContGoingCell.m
//  WebThings
//  商函通知单Cell
//  Created by Heidi on 2017/10/13.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DQBusContGoingCell.h"

#import "DQSubPackModel.h"
#import "DQLogicBusinessContractModel.h"

#import "DQFormView.h"

@implementation DQBusContGoingCell

#pragma mark - Init
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGFloat width = screenWidth - 58 - 16;
        _icon = [[UIImageView alloc] initWithFrame:CGRectMake(16 + width/2.0 - 51, 0, 69, 102)];
        _icon.image = [UIImage imageNamed:@"icon_bus_doing"];
        [self.contentView addSubview:_icon];
    }
    return self;
}

/// 设置数据
- (void)setData:(DQLogicBusinessContractModel *)data {

}

@end
