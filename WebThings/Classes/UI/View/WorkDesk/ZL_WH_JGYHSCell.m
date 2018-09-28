//
//  ZL_WH&JGCell.m
//  WebThings
//
//  Created by machinsight on 2017/8/9.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "ZL_WH_JGYHSCell.h"


@interface ZL_WH_JGYHSCell()
@property (weak, nonatomic) IBOutlet WorkDeskDetailView *detailV;
@property (weak, nonatomic) IBOutlet UIView *bottomV;
@end


@implementation ZL_WH_JGYHSCell

+ (id)cellWithTableView:(UITableView *)tableview delegate:(id<ZL_WH_JGYHSCellDelegate>)delegate{
    ZL_WH_JGYHSCell *cell = [tableview dequeueReusableCellWithIdentifier:@"ZL_WH_JGYHSCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ZL_WH_JGYHSCell" owner:nil options:nil] objectAtIndex:0];
    }
    cell.zl_WH_JGYHSCellDelegate = delegate;
    return cell;
}
//已核实
- (IBAction)sureBtnClicked:(UIButton *)sender {
    if (_zl_WH_JGYHSCellDelegate && [_zl_WH_JGYHSCellDelegate respondsToSelector:@selector(querenBtnClicked)]) {
        [_zl_WH_JGYHSCellDelegate querenBtnClicked];
    }
}
//已完成（不可点）
- (IBAction)agaBtnClicked:(UIButton *)sender {
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
