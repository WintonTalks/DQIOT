//
//  DQDeviceMaintainContinueFormViewCell.m
//  WebThings
//
//  Created by Eugene on 10/11/17.
//  Copyright © 2017 machinsight. All rights reserved.
//  维保（维保、维修、加高） 设备维保单 维保进行中 维保人员列表cell   

#import "DQDeviceMaintainContinueFormViewCell.h"
#import "DQMaintenanceContinueFormView.h"
#import "DQLogicMaintainModel.h"

@interface DQDeviceMaintainContinueFormViewCell ()

@property (nonatomic, strong) DQMaintenanceContinueFormView *continueFormView;

@end

@implementation DQDeviceMaintainContinueFormViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initContinueFormView];
    }
    return self;
}

- (void)initContinueFormView {
    
    _continueFormView = [[DQMaintenanceContinueFormView alloc] initWithFrame:CGRectMake(16, 16, screenWidth-75, 200)];
    [self.contentView addSubview:_continueFormView];
}

- (void)setData:(DQLogicMaintainModel *)data {
    
    _continueFormView.model = data;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
