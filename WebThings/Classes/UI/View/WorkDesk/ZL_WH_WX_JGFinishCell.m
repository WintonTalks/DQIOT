//
//  ZL_WH&WX&JGFinishCell.m
//  WebThings
//
//  Created by machinsight on 2017/8/9.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "ZL_WH_WX_JGFinishCell.h"
#import "PeopleView.h"


@interface ZL_WH_WX_JGFinishCell()
@property (weak, nonatomic) IBOutlet WorkDeskDetailView *detailV;
@property (weak, nonatomic) IBOutlet UIView *peopleFatherV;

@property (weak, nonatomic) IBOutlet UIView *bottomV;
@property (weak, nonatomic) IBOutlet UIView *lineV;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *peoTop;
@property (nonatomic,strong) NSMutableArray <PeopleView *> *peopleVArr;
@end


@implementation ZL_WH_WX_JGFinishCell

+ (id)cellWithTableView:(UITableView *)tableview delegate:(id<ZL_WH_WX_JGFinishCellDelegate>)delegate{
    ZL_WH_WX_JGFinishCell *cell = [tableview dequeueReusableCellWithIdentifier:@"ZL_WH_WX_JGFinishCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ZL_WH_WX_JGFinishCell" owner:nil options:nil] objectAtIndex:0];
        cell.peopleVArr = [NSMutableArray array];
    }
    cell.zl_WH_WX_JGFinishCellDelegate = delegate;
    return cell;
}
//已核实(不可点)
- (IBAction)sureBtnClicked:(UIButton *)sender {
}
//已完成
- (IBAction)agaBtnClicked:(UIButton *)sender {
    if (_zl_WH_WX_JGFinishCellDelegate && [_zl_WH_WX_JGFinishCellDelegate respondsToSelector:@selector(bohuiBtnClicked)]) {
        [_zl_WH_WX_JGFinishCellDelegate bohuiBtnClicked];
    }
}

- (void)setViewValuesWithModel:(DWMsgModel *)model{
    self.bottomV.hidden = !model.isOpen;
    ;
    if (model.isOpen) {
        _lineV.hidden = YES;
        _peoTop.constant = -46;
    }
    [self.detailV setViewValuesWithModel:model];
    
    if (model.users.count && !_peopleVArr.count) {
        [self setPeopleChildVWithArr:model.users];
    }
    
}

- (void)setPeopleChildVWithArr:(NSArray <UserModel *> *)userArr{
    for (int i = 0; i<userArr.count; i++) {
        if (i == 0) {
            PeopleView *v1 = [[PeopleView alloc] init];
            [v1 setViewValuesWithModel:userArr[i]];
            [self.peopleFatherV addSubview:v1];
            v1.sd_layout.topSpaceToView(self.peopleFatherV, 0).leftSpaceToView(self.peopleFatherV, 0).rightSpaceToView(self.peopleFatherV, 0).heightIs(68);
            [_peopleVArr addObject:v1];
        }else{
            PeopleView *v1 = [[PeopleView alloc] init];
            [v1 setViewValuesWithModel:userArr[i]];
            [self.peopleFatherV addSubview:v1];
            v1.sd_layout.topSpaceToView(self.peopleVArr[i-1], 0).leftSpaceToView(self.peopleFatherV, 0).rightSpaceToView(self.peopleFatherV, 0).heightIs(68);
            [_peopleVArr addObject:v1];
        }
        
    }
}

- (CGFloat)cellOpenHeightWithModel:(DWMsgModel *)model{
//    return 132+model.users.count*67;
    return 86+model.users.count*67;
//    return 86.f;
}
@end
