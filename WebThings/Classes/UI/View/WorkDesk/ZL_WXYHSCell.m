//
//  ZL_WXYHSCell.m
//  WebThings
//
//  Created by machinsight on 2017/8/9.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "ZL_WXYHSCell.h"
#import "IVEView.h"



@interface ZL_WXYHSCell()
@property (weak, nonatomic) IBOutlet WorkDeskDetailView *detailV;
@property (weak, nonatomic) IBOutlet IVEView *iveView;
@property (weak, nonatomic) IBOutlet UIView *bottomV;
@property (weak, nonatomic) IBOutlet UIView *lineV;
@end



@implementation ZL_WXYHSCell

+ (id)cellWithTableView:(UITableView *)tableview delegate:(id<ZL_WXYHSCellDelegate>)delegate{
    ZL_WXYHSCell *cell = [tableview dequeueReusableCellWithIdentifier:@"ZL_WXYHSCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ZL_WXYHSCell" owner:nil options:nil] objectAtIndex:0];
    }
    cell.zl_WXYHSCellDelegate = delegate;
    return cell;
}
//已核实
- (IBAction)sureBtnClicked:(UIButton *)sender {
    if (_zl_WXYHSCellDelegate && [_zl_WXYHSCellDelegate respondsToSelector:@selector(querenBtnClicked)]) {
        [_zl_WXYHSCellDelegate querenBtnClicked];
    }
}
//已完成（不可点）
- (IBAction)agaBtnClicked:(UIButton *)sender {
}

- (void)setViewValuesWithModel:(DWMsgModel *)model{
//    self.bottomV.hidden = !model.isOpen;
    self.bottomV.hidden = YES;
    [self.detailV setViewValuesWithModel:model];
    [self.iveView setViewValuesWithModel:model];
}
- (CGFloat)cellOpenHeightWithModel:(DWMsgModel *)model{
//    return 237.f;
    return 86.f;
}
@end
