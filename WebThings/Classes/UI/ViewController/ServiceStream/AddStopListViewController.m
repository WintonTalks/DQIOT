//
//  AddStopListViewController.m
//  WebThings
//
//  Created by machinsight on 2017/7/4.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "AddStopListViewController.h"
#import "AddStopRentOrderWI.h"
#import "BRDatePickerView.h"

@interface AddStopListViewController ()

@property (weak, nonatomic) IBOutlet UIView *fartherV;

@property (weak, nonatomic) IBOutlet UILabel *deviceNumLab;
@property (weak, nonatomic) IBOutlet UILabel *deviceAddressLab;

@property (weak, nonatomic) IBOutlet MDTextField *peopleTF;
@property (weak, nonatomic) IBOutlet UIView *dateFatherV;
@property (strong,nonatomic) UITapGestureRecognizer *dateGes;
@property (weak, nonatomic) IBOutlet MDTextField *dateTF;
@property (weak, nonatomic) IBOutlet UIView *timeFatherV;
@property (strong,nonatomic) UITapGestureRecognizer *timeGes;
@property (weak, nonatomic) IBOutlet MDTextField *timeTF;

@end

@implementation AddStopListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"停租单";
    
    [self initView];
    //[EMINavigationController addAppBar:self];
}

- (void)initView{
    UIBarButtonItem *rightNav = [UIBarButtonItem itemWithTarget:self action:@selector(rightNavClicked) image:[UIImage imageNamed:@"ic_done"]];
    self.navigationItem.rightBarButtonItem = rightNav;
    _deviceNumLab.text = _dm.deviceno;
    _deviceAddressLab.text = [NSString stringWithFormat:@"安装地点：%@",_dm.installationsite];
    self.peopleTF.text = [NSString stringWithFormat:@"%@   %@",self.baseUser.name,self.baseUser.dn];
    
    [self initGesture:_dateGes withSelTag:0 withView:_dateFatherV];
    [self initGesture:_timeGes withSelTag:1 withView:_timeFatherV];
}

- (void)rightNavClicked{
    if (!_dateTF.text.length || !_timeTF.text.length) {
        MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"请填写完整信息" actionTitle:@"" duration:3.0];
        [t show];
        return;
    }
    [self fetchAdd];
}

#pragma hidekeyboard
- (IBAction)hideKeyBoard:(id)sender {
    [self.view endEditing:YES];
}

#pragma 初始化手势
- (void)initGesture:(UITapGestureRecognizer *)ges withSelTag:(int)tag withView:(UIView *)aimView{
    NSString *selStr;
    switch (tag) {
        case 0:
            selStr = @"gesTap0:";
            break;
        case 1:
            selStr = @"gesTap1:";
            break;
        default:
            break;
    }
    if (!ges) {
        ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:NSSelectorFromString(selStr)];
        [aimView addGestureRecognizer:ges];
    }
}

//选择日期
- (void)gesTap0:(UIRotationGestureRecognizer *)sender
{
    [BRDatePickerView
     showDatePickerWithTitle:@"请选择拆机日期"
     dateType:UIDatePickerModeDate
     defaultSelValue:_dateTF.text
     minDateStr:@""
     maxDateStr:nil
     isAutoSelect:true resultBlock:^(NSString *selectValue) {
         _dateTF.text = selectValue;
     }];
}

//选择时间
- (void)gesTap1:(UIRotationGestureRecognizer *)sender
{
    [BRDatePickerView
     showDatePickerWithTitle:@"请选择拆机时间"
     dateType:UIDatePickerModeTime
     defaultSelValue:_timeTF.text
     minDateStr:@""
     maxDateStr:nil
     isAutoSelect:true resultBlock:^(NSString *selectValue) {
         _timeTF.text = selectValue;
     }];
}

/**
 新增
 */
- (void)fetchAdd{
    AddStopRentOrderWI *lwi = [[AddStopRentOrderWI alloc] init];
    NSString *startDate = [NSString stringWithFormat:@"%@ %@:00",_dateTF.text,_timeTF.text];
    NSArray *arr = @[@(self.baseUser.userid),self.baseUser.type,self.baseUser.usertype,@(_projectid),@(_dm.deviceid),startDate];
    NSDictionary *param = [lwi inBox:arr];
    [CKNetTools requestWithRequestType:POST WithURL:lwi.fullUrl WithParamater:param WithProgressBlock:^(NSProgress *process) {
        
    } WithSuccessBlock:^(id returnValue) {
        NSArray *temp = [lwi unBox:returnValue];
        if ([temp[0] integerValue] == 1) {
            [self.navigationController popViewControllerAnimated:YES];
            if (self.basedelegate && [self.basedelegate respondsToSelector:@selector(didPopFromNextVC)]) {
                [self.basedelegate didPopFromNextVC];
            };
        }
        
    } WithFailureBlock:^(NSError *error) {
        
    }];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    DQLog(@"%@",NSStringFromClass(object_getClass(touch.view)));
    if ([NSStringFromClass(object_getClass(touch.view)) isEqualToString:@"SDTextField"] || [NSStringFromClass(object_getClass(touch.view)) isEqualToString:@"UITableViewCellContentView"] || [NSStringFromClass(object_getClass(touch.view)) isEqualToString:@"ImgButton"]) {
        return NO;
    }
    return YES;
}

@end
