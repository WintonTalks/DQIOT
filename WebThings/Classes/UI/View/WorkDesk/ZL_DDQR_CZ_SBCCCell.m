//
//  ZL_DDQR&CZ_SBCCCell.m
//  WebThings
//
//  Created by machinsight on 2017/8/9.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "ZL_DDQR_CZ_SBCCCell.h"
@interface ZL_DDQR_CZ_SBCCCell()
@property (weak, nonatomic) IBOutlet WorkDeskDetailView *detailV;


@end
@implementation ZL_DDQR_CZ_SBCCCell

+ (id)cellWithTableView:(UITableView *)tableview{
    ZL_DDQR_CZ_SBCCCell *cell = [tableview dequeueReusableCellWithIdentifier:@"ZL_DDQR_CZ_SBCCCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ZL_DDQR_CZ_SBCCCell" owner:nil options:nil] objectAtIndex:0];
    }
    return cell;
}

- (void)setViewValuesWithModel:(DWMsgModel *)model{
    [self.detailV setViewValuesWithModel:model];
}
- (CGFloat)cellOpenHeightWithModel:(DWMsgModel *)model{
    return 86.f;
}
@end
