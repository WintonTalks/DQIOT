//
//  CZ_DDQRCell.m
//  WebThings
//
//  Created by machinsight on 2017/8/9.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "CZ_DDQRCell.h"
#import "JCGTDView.h"

@interface CZ_DDQRCell()
@property (weak, nonatomic) IBOutlet WorkDeskDetailView *detailV;
@property (weak, nonatomic) IBOutlet JCGTDView *jcgtView;
@property (weak, nonatomic) IBOutlet UIView *bottomV;
@property (weak, nonatomic) IBOutlet UIView *lineV;
@end


@implementation CZ_DDQRCell

+ (id)cellWithTableView:(UITableView *)tableview delegate:(id<CZ_DDQRCellDelegate>)delegate{
    CZ_DDQRCell *cell = [tableview dequeueReusableCellWithIdentifier:@"CZ_DDQRCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CZ_DDQRCell" owner:nil options:nil] objectAtIndex:0];
    }
    cell.cz_DDQRCellDelegate = delegate;
    return cell;
}
- (IBAction)sureBtnClicked:(UIButton *)sender {
    if (_cz_DDQRCellDelegate && [_cz_DDQRCellDelegate respondsToSelector:@selector(querenBtnClicked)]) {
        [_cz_DDQRCellDelegate querenBtnClicked];
    }
}
- (IBAction)agaBtnClicked:(UIButton *)sender {
    if (_cz_DDQRCellDelegate && [_cz_DDQRCellDelegate respondsToSelector:@selector(bohuiBtnClicked)]) {
        [_cz_DDQRCellDelegate bohuiBtnClicked];
    }
}


- (void)setViewValuesWithModel:(DWMsgModel *)model{
    [self.detailV setViewValuesWithModel:model];
//    self.bottomV.hidden = !model.isOpen;
    self.bottomV.hidden = YES;
    [self.jcgtView setViewValuesWithModel:model];
}
- (CGFloat)cellOpenHeightWithModel:(DWMsgModel *)model{
//    return 988.f;
    return 86.f;
}
@end
