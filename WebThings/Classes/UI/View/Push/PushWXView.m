//
//  PushWXView.m
//  WebThings
//
//  Created by machinsight on 2017/8/11.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "PushWXView.h"
#import "WorkDeskDetailView.h"
#import "IVEView.h"
#import "ChooseMaintainers.h"
#import "AppDelegate.h"
#import "AddDeviceWXListViewController.h"
@interface PushWXView()<EMIBaseViewControllerDelegate>
@property (weak, nonatomic) IBOutlet WorkDeskDetailView *detailV;
@property (weak, nonatomic) IBOutlet UIView *midFatherV;
@property (weak, nonatomic) IBOutlet IVEView *iveV;

@property (weak, nonatomic) IBOutlet UIButton *bottomBtn;

@property (nonatomic,assign)BOOL isOpen;
@end
@implementation PushWXView

- (instancetype)init{
    self = [super init];
    self = [[[NSBundle mainBundle] loadNibNamed:@"PushWXView" owner:nil options:nil] objectAtIndex:0];
    
    if (self) {
        self.frame = CGRectMake(0, 0, screenWidth, 136);
        self.midFatherV.hidden = YES;
    }
    return self;
}

- (IBAction)sureBtnClicked:(UIButton *)sender {
    /*
    ChooseMaintainers *VC = [VCFromSB VCFromSB:@"Main" vcID:@"ChooseMaintainersVC"];
    VC.deviceid = _m.deviceid;
    VC.billid = _m.devicewarnid;
    VC.projectid = _m.projectid;
    VC.thistitle = @"选择维修人员";
    UIViewController *currentVC = [(AppDelegate *) [[UIApplication sharedApplication] delegate] getCurrentVC];
    [currentVC.navigationController pushViewController:VC animated:YES];
     */
    //填写维修单
    UIViewController *currentVC = [(AppDelegate *) [[UIApplication sharedApplication] delegate] getCurrentVC];
    AddDeviceWXListViewController *VC = [AppUtils VCFromSB:@"Main" vcID:@"AddDeviceWXListVC"];
    VC.deviceid = _m.deviceid;
    VC.address = _m.address;
    VC.brand_model = _m.deviceno;
    VC.projectid = _m.projectid;
    VC.basedelegate = currentVC;
    VC.warnid = _m.devicewarnid;
    VC.warnname = _m.warnname;
    [currentVC.navigationController pushViewController:VC animated:YES];
    
    [self superview].hidden = YES;
}
- (IBAction)BottomBtnClicked:(UIButton *)sender {
    _isOpen = !_isOpen;
    if (_isOpen) {
        if (_m.ivedata.count) {
            self.frame = CGRectMake(0, 0, screenWidth, 317);
        }else{
            self.frame = CGRectMake(0, 0, screenWidth, 317-134.5);
            self.iveV.hidden = YES;
        }
        self.midFatherV.hidden = NO;
    }else{
        self.frame = CGRectMake(0, 0, screenWidth, 136);
        self.midFatherV.hidden = YES;
    }
}

- (void)setViewValues{
    [_iveV setViewValuesWithPushModel:_m];
    [_detailV setViewValuesWithPushModel:_m];
}
@end
