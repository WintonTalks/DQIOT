//
//  DQRefuteBackCell.m
//  WebThings
//  确认／驳回结果
//  Created by Heidi on 2017/9/28.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DQRefuteBackCell.h"
#import "DQApproachBottomView.h"

@implementation DQRefuteBackCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _resultView = [[DQApproachBottomView alloc]
                       initWithFrame:CGRectMake(58, 0, screenWidth - 58 - 16, 76)];
        [self.contentView addSubview:_resultView];
    }
    return self;
}

- (void)setData:(DQLogicServiceBaseModel *)data {
    [_resultView configApproachWithModel:data];
    
    if (data.nodeType == DQFlowTypeBusinessContact ||
        data.nodeType == DQFlowTypeFix ||
        data.nodeType == DQFlowTypeMaintain ||
        data.nodeType == DQFlowTypeHeighten) {
        
        CGRect rect = _resultView.frame;
        rect.origin.x = 16;
        _resultView.frame = rect;
    }
}

@end
