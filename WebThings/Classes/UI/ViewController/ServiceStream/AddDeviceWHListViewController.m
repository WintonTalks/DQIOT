//
//  AddDeviceWHListViewController.m
//  WebThings
//
//  Created by machinsight on 2017/7/3.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "AddDeviceWHListViewController.h"
#import "ServiceDetailView.h"
#import "AddDeviceMaintainOrderWI.h"
#import "BRDatePickerView.h"

@interface AddDeviceWHListViewController ()

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

@property (weak, nonatomic) IBOutlet UIView *dateFatherV1;
@property (strong,nonatomic) UITapGestureRecognizer *dateGes1;
@property (weak, nonatomic) IBOutlet MDTextField *dateTF1;
@property (weak, nonatomic) IBOutlet UIView *timeFatherV1;
@property (strong,nonatomic) UITapGestureRecognizer *timeGes1;
@property (weak, nonatomic) IBOutlet MDTextField *timeTF1;

@property (weak, nonatomic) IBOutlet UIStackView *stackV;

@property(nonatomic,assign)BOOL isStartDate;
@end

@implementation AddDeviceWHListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"设备维保单";
    
    [self initView];
    //[EMINavigationController addAppBar:self];
}

- (void)initView
{
    for (int i = 0; i < _stackV.arrangedSubviews.count; i++) {
        if ([_stackV.arrangedSubviews[i] isKindOfClass:[ServiceDetailView class]]) {
            ServiceDetailView *item = _stackV.arrangedSubviews[i];
            switch (i) {
                case 0:
                    [item setViewValuesWithTitle:@"检查外笼门上的安全开关" WithContent:@"检查上、下限位、减速开关"];
                    break;
                case 1:
                    [item setViewValuesWithTitle:@"打开吊笼单开门安全试验" WithContent:@"打开吊笼双开门"];
                    break;
                case 2:
                    [item setViewValuesWithTitle:@"打开外笼门及各个层门" WithContent:@"按下急停按钮"];
                    break;
                case 3:
                    [item setViewValuesWithTitle:@"打开吊笼天窗门" WithContent:@"触动断绳保护开关"];
                    break;
                case 4:
                    [item setViewValuesWithTitle:@"检查笼顶电控箱、电阻箱" WithContent:@"检查变频器发热及电流"];
                    break;
                case 5:
                    [item setViewValuesWithTitle:@"检查防坠器" WithContent:@"检查电缆"];
                    break;
                case 6:
                    [item setViewValuesWithTitle:@"检查电缆托架、保护架及挑线架" WithContent:@"检查小齿轮、导轮、滚轮、附墙架、导轨架及标准节齿条"];
                    break;
                case 7:
                    [item setViewValuesWithTitle:@"检查吊笼通道" WithContent:@"检查润滑部位、减速箱"];
                    break;
                default:
                    break;
            }
        }
    }
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(rightNavClicked) image:[UIImage imageNamed:@"ic_done"]];
    
    _deviceNumLab.text = _dm.deviceno;
    _deviceAddressLab.text = [NSString stringWithFormat:@"安装地点：%@",_dm.installationsite];
    self.peopleTF.text = [NSString stringWithFormat:@"%@   %@",self.baseUser.name,self.baseUser.dn];
    
    [self initGesture:_dateGes withSelTag:0 withView:_dateFatherV];
    [self initGesture:_timeGes withSelTag:1 withView:_timeFatherV];
    
    [self initGesture:_dateGes1 withSelTag:2 withView:_dateFatherV1];
    [self initGesture:_timeGes1 withSelTag:3 withView:_timeFatherV1];
}

- (void)rightNavClicked
{
    if (!_dateTF.text.length || !_timeTF.text.length || !_dateTF1.text.length|| !_timeTF1.text.length) {
        MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"请填写完整信息" actionTitle:@"" duration:3.0];
        [t show];
        return;
    }
    if (![AppUtils verifyTime:self.timeTF.text curreTime:self.timeTF1.text isEqualToTime:[self.dateTF.text isEqualToString:self.dateTF1.text]]) {
        self.timeTF1.text = @"";
        MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"开始维保时间要小于结束维保时间" actionTitle:@"" duration:3.0];
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
        case 2:
            selStr = @"gesTap2:";
            break;
        case 3:
            selStr = @"gesTap3:";
            break;
        default:
            break;
    }
    if (!ges) {
        ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:NSSelectorFromString(selStr)];
        [aimView addGestureRecognizer:ges];
    }
}

// 设置时间上限
- (void)setMaxTime {
    if (_dateTF1.text.length > 0 && _timeTF1.text.length > 0) {

    }
}
// 设置时间下限
- (void)setMinTIme {
    if (_dateTF.text.length > 0 && _timeTF.text.length > 0) {
        
    }
}

//请选择开始维保日期
- (void)gesTap0:(UIRotationGestureRecognizer *)sender
{
    [BRDatePickerView
     showDatePickerWithTitle:@"请选择开始维保日期"
     dateType:UIDatePickerModeDate
     defaultSelValue:_dateTF.text
     minDateStr:@""
     maxDateStr:nil
     isAutoSelect:true resultBlock:^(NSString *selectValue) {
         _dateTF.text = selectValue;
     }];
}

//开始维保时间
- (void)gesTap1:(UIRotationGestureRecognizer *)sender
{
    if (!_dateTF.text.length) {
        MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"请选择开始维保日期" actionTitle:@"" duration:3.0];
        [t show];
        return;
    }
    [BRDatePickerView
     showDatePickerWithTitle:@"请选择开始维保时间"
     dateType:UIDatePickerModeTime
     defaultSelValue:_timeTF.text
     minDateStr:@""
     maxDateStr:nil
     isAutoSelect:true resultBlock:^(NSString *selectValue) {
         _timeTF.text = selectValue;
     }];
}

//结束维保日期
- (void)gesTap2:(UIRotationGestureRecognizer *)sender
{
    
    [BRDatePickerView
     showDatePickerWithTitle:@"请选择结束维保日期"
     dateType:UIDatePickerModeDate
     defaultSelValue:_dateTF1.text
     minDateStr: _dateTF.text
     maxDateStr:nil
     isAutoSelect:true resultBlock:^(NSString *selectValue) {
         _dateTF1.text = selectValue;
     }];
}

//结束维保时间
- (void)gesTap3:(UIRotationGestureRecognizer *)sender
{
    if (!_dateTF1.text.length) {
        MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"请选择结束维保日期" actionTitle:@"" duration:3.0];
        [t show];
        return;
    }
    [BRDatePickerView
     showDatePickerWithTitle:@"请选择结束维保时间"
     dateType:UIDatePickerModeTime
     defaultSelValue:_timeTF1.text
     minDateStr:@""
     maxDateStr:nil
     isAutoSelect:true resultBlock:^(NSString *selectValue) {
         _timeTF1.text = selectValue;
     }];
}

//- (BOOL)verifyTime:(NSString *)oneTime curreTime:(NSString *)curreTime
//{
//    if (oneTime && curreTime) {
//        if ([self.dateTF.text isEqualToString:self.dateTF1.text]) {
//            int count = [NSDate compareOneDay:curreTime withAnotherDay:oneTime format:@"HH:mm"];
//            if (count != 1) {
//                self.timeTF1.text = @"";
////                _maxTimeString = nil;
//                return false;
//            }
//        }
//    }
//    return  true;
//}

/**
 新增
 */
- (void)fetchAdd{
    AddDeviceMaintainOrderWI *lwi = [[AddDeviceMaintainOrderWI alloc] init];
    NSString *startDate = [NSString stringWithFormat:@"%@ %@:00",_dateTF.text,_timeTF.text];
    NSString *endDate = [NSString stringWithFormat:@"%@ %@:00",_dateTF1.text,_timeTF1.text];
    NSArray *arr = @[@(self.baseUser.userid),self.baseUser.type,@(_projectid),@(_dm.deviceid),startDate,endDate,@"",self.baseUser.usertype];
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
    NSLog(@"%@",NSStringFromClass(object_getClass(touch.view)));
    if ([NSStringFromClass(object_getClass(touch.view)) isEqualToString:@"SDTextField"] || [NSStringFromClass(object_getClass(touch.view)) isEqualToString:@"UITableViewCellContentView"] || [NSStringFromClass(object_getClass(touch.view)) isEqualToString:@"ImgButton"]) {
        return NO;
    }
    return YES;
}

@end
