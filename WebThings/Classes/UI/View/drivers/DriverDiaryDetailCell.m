//
//  DriverDiaryDetailCell.m
//  WebThings
//
//  Created by machinsight on 2017/7/27.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "DriverDiaryDetailCell.h"
#import "NewDeviceScrollView.h"
@interface DriverDiaryDetailCell()<NewDeviceScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *contentLab;

/** 设备品牌 弹出框*/@property (nonatomic,strong) NewDeviceScrollView *pdxhAlertV;
@end
@implementation DriverDiaryDetailCell

+ (id)cellWithTableView:(UITableView *)tableview{
    DriverDiaryDetailCell *cell = [tableview dequeueReusableCellWithIdentifier:@"DriverDiaryDetailCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DriverDiaryDetailCell" owner:nil options:nil] objectAtIndex:0];
        [cell initView];
    }
    return cell;
}

- (void)initView{
    if (!_pdxhAlertV) {
        _pdxhAlertV = [[NewDeviceScrollView alloc] initWithFrame:CGRectMake(self.contentView.frame.size.width-9-62, -49, 92, 110)];
        _pdxhAlertV.tag = 2000;
        _pdxhAlertV.delegate = self;
    }
}

- (void)didSelectValue:(id)value withSelf:(NewDeviceScrollView *)sender witnIndex:(NSInteger)index{
    _thisModel.checkstate = value;
    [_stateBtn setTitle:_thisModel.checkstate forState:UIControlStateNormal];
    [_stateBtn setTitleColor:[_thisModel getColor] forState:UIControlStateNormal];
    
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectStateWithCellIndex:WithModel:)]) {
        [_delegate didSelectStateWithCellIndex:_index WithModel:_thisModel];
    }
}

- (void)setViewValuesWithModel:(CheckModel *)model{
    
    _contentLab.text = model.checktype;
    if (model.checkstate) {
         [_stateBtn setTitle:model.checkstate forState:UIControlStateNormal];
    }else{
        [_stateBtn setTitle:@"请选择" forState:UIControlStateNormal];
    }
   
    [_stateBtn setTitleColor:[model getColor] forState:UIControlStateNormal];
    if (model.states.count == 0) {
        model.states = @[@"正常",@"已修复",@"待修复"];
    }
    
    _thisModel = model;
//    [_pdxhAlertV setData:model.states];
}
- (IBAction)stateBtnClickedd:(id)sender {
//    if (_pdxhAlertV.hidden) {
//        [_pdxhAlertV showWithFatherV:self.contentView];
//    }
    if (_delegate && [_delegate respondsToSelector:@selector(didClickBtnWithCellIndex:WithModel:)]) {
        [_delegate didClickBtnWithCellIndex:_index WithModel:_thisModel];
    }
}

@end
