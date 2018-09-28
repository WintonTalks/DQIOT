//
//  AddServiceListViewController.m
//  WebThings
//
//  Created by machinsight on 2017/7/4.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "AddServiceListViewController.h"
#import "AddDeviceHighWI.h"

#import "BRDatePickerView.h"

@interface AddServiceListViewController ()
@property (weak, nonatomic) IBOutlet UIView *fartherV;


@property (weak, nonatomic) IBOutlet UILabel *deviceNumLab;
@property (weak, nonatomic) IBOutlet UILabel *deviceAddressLab;


@property (weak, nonatomic) IBOutlet MDTextField *peopleTF;

@property (weak, nonatomic) IBOutlet MDTextField *highTF;//高度


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


@property(nonatomic,assign)BOOL isStartDate;
@end

@implementation AddServiceListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"设备加高";
    
    [self initView];
    //[EMINavigationController addAppBar:self];
}

- (void)initView
{
    UIBarButtonItem *rightNav = [UIBarButtonItem itemWithTarget:self action:@selector(rightNavClicked) image:[UIImage imageNamed:@"ic_done"]]; 
    self.navigationItem.rightBarButtonItem = rightNav;
    
    _deviceNumLab.text = _dm.deviceno;
    _deviceAddressLab.text = [NSString stringWithFormat:@"安装地点：%@",_dm.installationsite];
    self.peopleTF.text = [NSString stringWithFormat:@"%@   %@",self.baseUser.name,self.baseUser.dn];
    [self initGesture:_dateGes withSelTag:0 withView:_dateFatherV];
    [self initGesture:_timeGes withSelTag:1 withView:_timeFatherV];
    
    [self initGesture:_dateGes1 withSelTag:2 withView:_dateFatherV1];
    [self initGesture:_timeGes1 withSelTag:3 withView:_timeFatherV1];
}

- (void)rightNavClicked{
    [self.view endEditing:YES];
    if (!_dateTF.text.length || !_timeTF.text.length || !_dateTF1.text.length|| !_timeTF1.text.length||!_highTF.text.length) {
        MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"请填写完整信息" actionTitle:@"" duration:3.0];
        [t show];
        return;
    }
    if (![AppUtils isAllNum:_highTF.text]) {
        MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"请填写数字" actionTitle:@"" duration:3.0];
        [t show];
        return;
    }
    [self verifyTime:self.timeTF.text curreTime:self.timeTF1.text];
    [self fetchAdd];
}

#pragma hidekeyboard
- (IBAction)hideKeyBoard:(id)sender {
    [self hideAll];
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

//开始维保日期
- (void)gesTap0:(UIRotationGestureRecognizer *)sender{
    [self.view endEditing:YES];
    
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

//选择时间
- (void)gesTap1:(UIRotationGestureRecognizer *)sender
{
    [self.view endEditing:YES];
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

//选择日期1
- (void)gesTap2:(UIRotationGestureRecognizer *)sender{
    [self.view endEditing:YES];
    
    [BRDatePickerView
     showDatePickerWithTitle:@"请选择结束维保日期"
     dateType:UIDatePickerModeDate
     defaultSelValue:_dateTF1.text
     minDateStr:_timeTF.text
     maxDateStr:nil
     isAutoSelect:true resultBlock:^(NSString *selectValue) {
         _dateTF1.text = selectValue;
     }];
}

//选择时间1
- (void)gesTap3:(UIRotationGestureRecognizer *)sender
{
    [self.view endEditing:YES];
    if (!_dateTF1.text.length) {
        MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"请选择结束维保日期" actionTitle:@"" duration:3.0];
        [t show];
        return;
    }
    MJWeakSelf;
    [BRDatePickerView
     showDatePickerWithTitle:@"请选择结束维保时间"
     dateType:UIDatePickerModeTime
     defaultSelValue:_timeTF1.text
     minDateStr:nil
     maxDateStr:nil
     isAutoSelect:true resultBlock:^(NSString *selectValue) {
         [weakSelf verifyTime:selectValue curreTime:_timeTF.text];
         _timeTF1.text = selectValue;
     }];
}

- (void)verifyTime:(NSString *)oneTime curreTime:(NSString *)curreTime
{
    if (oneTime && curreTime) {
        if ([self.dateTF.text isEqualToString:self.dateTF1.text]) {
            int count = [NSDate compareOneDay:curreTime withAnotherDay:oneTime format:@"HH:mm"];
            if (count != 1) {
                MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"开始维保时间要小于结束维保时间" actionTitle:@"" duration:3.0];
                [t show];
                return;
            }
        }
    }
}

- (void)hideAll{
    [self.view endEditing:YES];
}

/**
 新增
 */
- (void)fetchAdd{
    AddDeviceHighWI *lwi = [[AddDeviceHighWI alloc] init];
    NSString *startDate = [NSString stringWithFormat:@"%@ %@:00",_dateTF.text,_timeTF.text];
    NSString *endDate = [NSString stringWithFormat:@"%@ %@:00",_dateTF1.text,_timeTF1.text];
    NSArray *arr = @[@(self.baseUser.userid),self.baseUser.type,self.baseUser.usertype,@(_projectid),@(_dm.deviceid),startDate,endDate,_highTF.text];
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
