//
//  ZL_SBCC.m
//  WebThings
//
//  Created by machinsight on 2017/8/9.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "ZL_SBCC.h"

@interface ZL_SBCC()
@property (weak, nonatomic) IBOutlet WorkDeskDetailView *detailV;
@property (weak, nonatomic) IBOutlet UIView *bottomV;
@end

@implementation ZL_SBCC

+ (id)cellWithTableView:(UITableView *)tableview delegate:(id<ZL_SBCCDelegate>)delegate{
    ZL_SBCC *cell = [tableview dequeueReusableCellWithIdentifier:@"ZL_SBCC"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ZL_SBCC" owner:nil options:nil] objectAtIndex:0];
    }
    cell.zl_SBCCDelegate = delegate;
    return cell;
}
//费用已缴清
- (IBAction)sureBtnClicked:(UIButton *)sender {
    if (_zl_SBCCDelegate && [_zl_SBCCDelegate respondsToSelector:@selector(querenBtnClicked)]) {
        [_zl_SBCCDelegate querenBtnClicked];
    }
}
//费用未缴清
- (IBAction)agaBtnClicked:(UIButton *)sender {
    if (_zl_SBCCDelegate && [_zl_SBCCDelegate respondsToSelector:@selector(bohuiBtnClicked)]) {
        [_zl_SBCCDelegate bohuiBtnClicked];
    }
}
- (void)setViewValuesWithModel:(DWMsgModel *)model{
    [self.detailV setViewValuesWithModel:model];
//    self.bottomV.hidden = !model.isOpen;
    self.bottomV.hidden = YES;
}
- (CGFloat)cellOpenHeightWithModel:(DWMsgModel *)model{
//    return 132.f;
    return 86.f;
}
@end
