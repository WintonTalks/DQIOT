//
//  CZ_SBWX&WH&JGCell.m
//  WebThings
//
//  Created by machinsight on 2017/8/9.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "CZ_SBWX_WH_JGCell.h"

@interface CZ_SBWX_WH_JGCell()
@property (weak, nonatomic) IBOutlet WorkDeskDetailView *detailV;
@property (weak, nonatomic) IBOutlet UIView *bottomV;
@end


@implementation CZ_SBWX_WH_JGCell

+ (id)cellWithTableView:(UITableView *)tableview delegate:(id<CZ_SBWX_WH_JGCellDelegate>)delegate{
    CZ_SBWX_WH_JGCell *cell = [tableview dequeueReusableCellWithIdentifier:@"CZ_SBWX_WH_JGCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CZ_SBWX_WH_JGCell" owner:nil options:nil] objectAtIndex:0];
    }
    cell.cz_SBWX_WH_JGDelegate = delegate;
    return cell;
}
- (IBAction)sureBtnClicked:(UIButton *)sender {
    if (_cz_SBWX_WH_JGDelegate && [_cz_SBWX_WH_JGDelegate respondsToSelector:@selector(querenBtnClicked)]) {
        [_cz_SBWX_WH_JGDelegate querenBtnClicked];
    }
}
- (IBAction)agaBtnClicked:(UIButton *)sender {
    if (_cz_SBWX_WH_JGDelegate && [_cz_SBWX_WH_JGDelegate respondsToSelector:@selector(bohuiBtnClicked)]) {
        [_cz_SBWX_WH_JGDelegate bohuiBtnClicked];
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
