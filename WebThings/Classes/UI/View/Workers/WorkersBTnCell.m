//
//  WorkersBTnCell.m
//  WebThings
//
//  Created by machinsight on 2017/7/23.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "WorkersBTnCell.h"
@interface WorkersBTnCell()
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;

@property (nonatomic,strong)DWMsgModel *thisModel;
@end
@implementation WorkersBTnCell

+ (id)cellWithTableView:(UITableView *)tableview{
    WorkersBTnCell *cell = [tableview dequeueReusableCellWithIdentifier:@"WorkersBTnCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"WorkersBTnCell" owner:nil options:nil] objectAtIndex:0];
    }
    return cell;
}


- (void)setViewValues:(DWMsgModel *)model{
    _thisModel = model;
    [_rightBtn setTitle:[model returnBtnTitle] forState:UIControlStateNormal];
    if ([model.isread isEqualToString:@"已读"]) {
        _leftBtn.enabled = NO;
    }
    if ([model.isfinish isEqualToString:@"已完成"]) {
        _rightBtn.enabled = NO;
    }
}
- (IBAction)leftBtnClicked:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(leftBtnClickedWithIndex:WithModel:)]) {
        [_delegate leftBtnClickedWithIndex:_index WithModel:_thisModel];
    }
}
- (IBAction)rightBtnClicked:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(rightBtnClickedWithIndex:WithModel:)]) {
        [_delegate rightBtnClickedWithIndex:_index WithModel:_thisModel];
    }
}
@end
