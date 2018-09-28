//
//  GZTZCell.m
//  WebThings
//
//  Created by machinsight on 2017/8/9.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "GZTZCell.h"
#import "AddDeviceWXListViewController.h"

@interface GZTZCell()

@property (strong, nonatomic) DWMsgModel *model;

@property (weak, nonatomic) IBOutlet WorkDeskDetailView *detailV;
@property (weak, nonatomic) IBOutlet UIView *bottomV;

@end

@implementation GZTZCell

+ (id)cellWithTableView:(UITableView *)tableview  delegate:(id<GZTZCellDelegate>)delegate{
    GZTZCell *cell = [tableview dequeueReusableCellWithIdentifier:@"GZTZCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"GZTZCell" owner:nil options:nil] objectAtIndex:0];
    }
    cell.gztzDelegate = delegate;
    return cell;
}

- (IBAction)btnClicked:(UIButton *)sender {
    if (_gztzDelegate && [_gztzDelegate respondsToSelector:@selector(gztzBtnClicked)]) {
        [_gztzDelegate gztzBtnClicked];
    }
    
    //填写维保单
    AddDeviceWXListViewController *VC = [AppUtils VCFromSB:@"Main" vcID:@"AddDeviceWXListVC"];
    VC.deviceid = self.model.deviceid;
    VC.address = self.model.address;
    VC.brand_model = self.model.deviceno;
    VC.projectid = self.model.projectid;
    VC.warnid = self.model.warnid;
    VC.warnname = self.model.warnname;
    if ([self viewController] == nil) {
        return;
    }
    
    [[self viewController].navigationController pushViewController:VC animated:YES];
    DQLog(@"%@",[self viewController]);
}


- (void)setViewValuesWithModel:(DWMsgModel *)model{
    [self.detailV setViewValuesWithModel:model];
    self.bottomV.hidden = !model.isOpen;
}

- (CGFloat)cellOpenHeightWithModel:(DWMsgModel *)model {
    _model = model;
    
    return 132.f;
//    return 86.f;
}

/**
 *  返回当前视图的控制器
 */
- (UIViewController *)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

@end
