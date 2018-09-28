//
//  DQApproachBottomView.m
//  WebThings
//
//  Created by 孙文强 on 2017/9/27.
//  Modify by Heidi
//  Copyright © 2017年 machinsight. All rights reserved.
//  进场同意or驳回view

#import "DQApproachBottomView.h"
#import "HeadImgV.h"

#import "DQLogicServiceBaseModel.h"
#import "DQServiceSubNodeModel.h"

@interface DQApproachBottomView()
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) HeadImgV *headerView;
@end

@implementation DQApproachBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat width = frame.size.width;
        CGFloat height = frame.size.height;
        _headerView = [[HeadImgV alloc] initWithFrame:
                       CGRectMake(width - 46 - 16, height / 2.0 - 23, 46, 46)];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 16, width / 3.0, 14)];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.textColor = [UIColor colorWithHexString:COLOR_BLACK];
        _nameLabel.font = [UIFont dq_mediumSystemFontOfSize:12];
        
        _subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.nameLabel.left, self.nameLabel.bottom+16, screenWidth - 56, 16)];
        _subTitleLabel.textAlignment = NSTextAlignmentLeft;
        _subTitleLabel.font = [UIFont dq_mediumSystemFontOfSize:14];
        
        _dateLabel = [[UILabel alloc] initWithFrame:
                      CGRectMake(width / 3.0, self.nameLabel.top, 125, 18)];
        _dateLabel.textAlignment = NSTextAlignmentRight;
        _dateLabel.textColor = [UIColor colorWithHexString:@"#797979"];
        _dateLabel.font = [UIFont dq_mediumSystemFontOfSize:12];
        
        self.layer.borderColor = [UIColor colorWithHexString:COLOR_GREEN_LIGHT].CGColor;
        self.layer.borderWidth = 0.5;
        self.layer.cornerRadius = 5.0;
        self.layer.masksToBounds = YES;
        
        [self addSubview:_nameLabel];
        [self addSubview:_subTitleLabel];
        [self addSubview:_headerView];
        [self addSubview:_dateLabel];
    }
    return self;
}

- (void)configApproachWithModel:(DQLogicServiceBaseModel *)model {
    DQServiceSubNodeModel *sub = model.cellData;
    
    _nameLabel.text = sub.sendname;
    _dateLabel.text = sub.sendtime;
    [_headerView setImageWithURL:[NSURL URLWithString:appendUrl(imgUrl, sub.sendheadimg)]
                placeholderImage:[_headerView defaultImageWithName:sub.sendname]];

    // 通过|驳回资料
    NSArray *keys = @[@"12", @"13",//进场沟通单
                      @"15", @"16",//报装资料
                      @"18", @"19",//现场技术交底确认／驳回
                      @"21", @"22",//现场安装
                      @"24", @"25",//第三方验收凭证
                      @"27", @"28",//启租单
                      @"33", @"34",//司机确认
                      
                      @"36", @"",//设备维保单确认
                      @"40", @"",//设备维修单确认
                      @"44", @"",//设备加高确认
                      
                      @"38", @"50",//维保完成
                      @"42", @"51",//维修完成
                      @"46", @"52",//设备加高完成
                      @"30", @"31",// 停租单确认
                      @"48", @"",
                      @"164", @"",
                      
                      [NSString stringWithFormat:@"%ld", DQEnumStateBusContactConfirmed], @"",  // 商函通知已确认
                      [NSString stringWithFormat:@"%ld",DQEnumStateBusContactFinishPass],
                      [NSString stringWithFormat:@"%ld",DQEnumStateBusContactFinishRefuse],  // 整改完成单已通过/已驳回
                      [NSString stringWithFormat:@"%ld",DQEnumStateBusContactAdviceComfirmed], @"", // 整改意见已确认
                      ];
    NSArray *values = @[@"进场沟通单确认", @"进场沟通单驳回",
                        @"报装资料通过", @"报装资料驳回",
                        @"现场技术交底通过", @"现场技术交底驳回",
                        @"安装凭证通过", @"现场安装驳回",
                        @"第三方验收凭证通过", @"第三方验收凭证驳回",
                        @"启租单通过", @"启租单驳回",
                        @"司机确认通过", @"司机确认驳回",
                        
                        @"设备维保单确认",@"",
                        @"设备维修单确认",@"",
                        @"设备加高确认",@"",
                        
                        @"维保完成确认", @"维保完成驳回",
                        @"维修完成确认", @"维修完成驳回",
                        @"设备加高确认", @"设备加高驳回",
                        @"费用已缴清，立即安排拆机", @"费用未缴清，请立即缴费",
                        @"服务评价", @"",
                        @"服务评价", @"",
                        
                        @"商函通知已确认", @"",
                        @"整改已通过", @"整改已驳回",
                        @"整改意见已确认", @""];
    
    NSString *stateID = [NSString stringWithFormat:@"%ld", sub.enumstateid];
    NSInteger index = [keys indexOfObject:stateID];

    if (index != NSNotFound) {
        _subTitleLabel.text = values[index];
    }

    BOOL other = model.direction == DQDirectionLeft;
    //  确认还是驳回，驳回显示红色，确认显示(我发的显示绿色，别人发的显示蓝色）
    UIColor *titleColor = [model hexTitleColor];
    UIColor *bgColor = [model hexBgColor];
    UIColor *borderColor = [model hexBorderColor];
    _subTitleLabel.textColor = index % 2 == 0 ? titleColor : [UIColor colorWithHexString:COLOR_RED];

    if (sub.enumstateid == 48 || sub.enumstateid == 164) {  // 服务评价里使用
        self.layer.borderColor = [UIColor clearColor].CGColor;
        self.backgroundColor = [UIColor clearColor];
    }
    else {
        self.backgroundColor = index % 2 == 0 ? bgColor : [UIColor colorWithHexString:COLOR_RED_LIGHT];
        self.layer.borderColor = (index % 2 == 0 ? borderColor : [UIColor colorWithHexString:COLOR_RED]).CGColor;
        
        CGFloat height = self.frame.size.height;
        CGFloat width = self.frame.size.width;
        if (other) {    // 对方发的
            _headerView.frame = CGRectMake(16, height / 2.0 - 23, 46, 46);
            _nameLabel.frame = CGRectMake(78, 16, width / 3.0, 14);
            _subTitleLabel.frame = CGRectMake(78, height - 16 - 21, width - 88, 16);
            _dateLabel.frame = CGRectMake(width - 141, self.nameLabel.top, 125, 18);
            
        } else { // 我方发的
            _headerView.frame = CGRectMake(width - 46 - 16, height / 2.0 - 23, 46, 46);
            _nameLabel.frame = CGRectMake(16, 16, width / 3.0, 14);
            _subTitleLabel.frame = CGRectMake(self.nameLabel.left, height - 16 - 21, width - 94, 16);
            _dateLabel.frame = CGRectMake(width - 32 - 125 - 46, self.nameLabel.top, 125, 18);
        }
    }
}

@end
