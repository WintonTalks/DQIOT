//
//  AddDeviceWXListViewController.m
//  WebThings
//
//  Created by machinsight on 2017/7/3.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "AddDeviceWXListViewController.h"
#import "WarningModel.h"
#import "NewDeviceScrollView.h"
#import "BRDatePickerView.h"

@interface AddDeviceWXListViewController ()<NewDeviceScrollViewDelegate>
{
    NSMutableArray <WarningModel *> *gzArr;//故障数据
    NSInteger warnid;//故障id，没有传0
    NSString *_mixDateString;
    NSString *_maxDateString;
    NSString *_mixTimeString;
    NSString *_maxTimeString;
    WarningModel *selectedWarn;
}
@property (weak, nonatomic) IBOutlet UIView *fartherV;
@property (weak, nonatomic) IBOutlet UILabel *deviceNumLab;
@property (weak, nonatomic) IBOutlet UILabel *deviceAddressLab;


@property (weak, nonatomic) IBOutlet MDTextField *peopleTF;

@property (weak, nonatomic) IBOutlet UIView *gzFatherV;
@property (weak, nonatomic) IBOutlet MDTextField *gzTF;//故障
@property (nonatomic,strong) NewDeviceScrollView *gzAlertV;/**< 故障 弹出框*/
@property (nonatomic,strong) UITapGestureRecognizer *gzFatherGes;/**< top手势*/

@property (weak, nonatomic) IBOutlet MDTextField *qtgzTF;//其他故障

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

@property (nonatomic, assign) BOOL isStartDate;
@end

@implementation AddDeviceWXListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"设备维修";
    _mixDateString = nil;
    _maxDateString = nil;
    _mixTimeString = nil;
    _maxTimeString = nil;
    if (!_dm) {
        _dm = [[DeviceModel alloc] init];
        _dm.installationsite = _address;
        _dm.deviceid = _deviceid;
        _dm.deviceno = _brand_model;
    }
    if (_warnid !=0 && _warnname) {
        selectedWarn = [[WarningModel alloc] init];
        selectedWarn.warnid = _warnid;
        warnid = _warnid;
        selectedWarn.warnname = _warnname;
        _gzTF.text = _warnname;
        _gzFatherV.userInteractionEnabled = NO;
        _qtgzTF.userInteractionEnabled = NO;
    }
    [self initView];
    
    [self fetchGuZList];
    //[EMINavigationController addAppBar:self];
}

- (void)initView
{
    UIBarButtonItem *rightNav = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_done"] style:UIBarButtonItemStylePlain target:self action:@selector(rightNavClicked)];
    self.navigationItem.rightBarButtonItem = rightNav;
    
    _deviceNumLab.text = _dm.deviceno;
    _deviceAddressLab.text = [NSString stringWithFormat:@"安装地点：%@",_dm.installationsite];
    self.peopleTF.text = [NSString stringWithFormat:@"%@   %@",self.baseUser.name,self.baseUser.dn];
    [self initGesture:_dateGes withSelTag:0 withView:_dateFatherV];
    [self initGesture:_timeGes withSelTag:1 withView:_timeFatherV];
    
    [self initGesture:_dateGes1 withSelTag:2 withView:_dateFatherV1];
    [self initGesture:_timeGes1 withSelTag:3 withView:_timeFatherV1];
    
    [self initGesture:_gzFatherGes withSelTag:4 withView:_gzFatherV];
    
    //故障弹出框
    if (!_gzAlertV) {
        _gzAlertV = [[NewDeviceScrollView alloc] initWithFrame:CGRectMake(8, 258, screenWidth-16, 223)];
        _gzAlertV.tag = 4000;
        _gzAlertV.delegate = self;
    }
}

#pragma NewDeviceScrollViewDelegate
- (void)didSelectValue:(id)value withSelf:(NewDeviceScrollView *)sender witnIndex:(NSInteger)index
{
    if(sender.tag == 4000){
        selectedWarn = (WarningModel *)value;
        warnid = selectedWarn.warnid;
        _gzTF.text = selectedWarn.warnname;
    }
}

- (void)rightNavClicked {
    
    [self.view endEditing:YES];
    if (!selectedWarn && !_qtgzTF.text.length) {
        MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"若不选择故障，请填写其他故障" actionTitle:@"" duration:3.0];
        [t show];
        return;
    }
    if (!_dateTF.text.length || !_timeTF.text.length || !_dateTF1.text.length|| !_timeTF1.text.length) {
        MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"请填写完整信息" actionTitle:@"" duration:3.0];
        [t show];
        return;
    }
    if (![AppUtils verifyTime:_mixTimeString curreTime:self.dateTF1.text isEqualToTime:[self.dateTF.text isEqualToString:self.dateTF1.text]]) {
        self.timeTF1.text = @"";
        _maxTimeString = nil;
        MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"开始维保时间要小于结束维保时间" actionTitle:@"" duration:3.0];
        [t show];
        return;
    }
    [self fetchAdd];
}

#pragma hidekeyboard
- (IBAction)hideKeyBoard:(id)sender {
    [self hideAll];
}

#pragma 初始化手势
- (void)initGesture:(UITapGestureRecognizer *)ges withSelTag:(int)tag withView:(UIView *)aimView
{
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
        case 4:
            selStr = @"gesTap4:";
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
- (void)gesTap0:(UIRotationGestureRecognizer *)sender
{
    [self.view endEditing:YES];
    [BRDatePickerView showDatePickerWithTitle:@"开始维保日期" dateType:UIDatePickerModeDate defaultSelValue:_mixDateString minDateStr:nil maxDateStr:_maxDateString isAutoSelect:false resultBlock:^(NSString *selectValue) {
        _mixDateString = selectValue;
        self.dateTF.text = selectValue;
    }];
}

//开始维保时间
- (void)gesTap1:(UIRotationGestureRecognizer *)sender
{
    [self.view endEditing:YES];
    if (!self.dateTF.text.length) {
        MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"请先选择开始维保日期" actionTitle:@"" duration:3.0];
        [t show];
        return;
    }
    [BRDatePickerView showDatePickerWithTitle:@"开始维保时间" dateType:UIDatePickerModeTime defaultSelValue:_mixTimeString minDateStr:nil maxDateStr:nil isAutoSelect:false resultBlock:^(NSString *selectValue) {
        _mixTimeString = selectValue;
        self.timeTF.text = selectValue;
    }];
}

//结束维保日期
- (void)gesTap2:(UIRotationGestureRecognizer *)sender
{
    [self.view endEditing:YES];
    [BRDatePickerView showDatePickerWithTitle:@"结束维保日期" dateType:UIDatePickerModeDate defaultSelValue:_maxDateString minDateStr:_mixDateString maxDateStr:nil isAutoSelect:false resultBlock:^(NSString *selectValue) {
        _maxDateString = selectValue;
        self.dateTF1.text = selectValue;
    }];
}

//结束维保时间
- (void)gesTap3:(UIRotationGestureRecognizer *)sender
{
    [self.view endEditing:YES];
    if (!self.dateTF1.text.length) {
        MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"请先选择结束维保日期" actionTitle:@"" duration:3.0];
        [t show];
        return;
    }
    MJWeakSelf;
    [BRDatePickerView showDatePickerWithTitle:@"结束维保时间" dateType:UIDatePickerModeTime defaultSelValue:_maxTimeString minDateStr:nil maxDateStr:nil isAutoSelect:false resultBlock:^(NSString *selectValue) {
        if (![AppUtils verifyTime:_mixTimeString curreTime:selectValue isEqualToTime:[self.dateTF.text isEqualToString:self.dateTF1.text]]) {
            self.timeTF1.text = @"";
            _maxTimeString = nil;
            MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"开始维保时间要小于结束维保时间" actionTitle:@"" duration:3.0];
            [t show];
            return;
        }
        _maxTimeString = selectValue;
        self.timeTF1.text = selectValue;
    }];
}

//选择故障
- (void)gesTap4:(UITapGestureRecognizer *)sender
{
    [self.view endEditing:YES];
    if (!gzArr.count) {
        MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"暂无故障可选" actionTitle:@"" duration:3.0];
        [t show];
        return;
    }
    [self hideAll];
    if (_gzAlertV.hidden) {
        [_gzAlertV showWithFatherV:self.view];
    }
}

/**
 请求故障列表
 */
- (void)fetchGuZList
{
    NSDictionary *dic = @{@"userid" : @(self.baseUser.userid),
                          @"type" : [NSObject changeType:self.baseUser.type],
                          @"usertype" : [NSObject changeType:self.baseUser.usertype]};
   [[DQServiceInterface sharedInstance] dq_getFaultdata:dic success:^(id result) {
       if (result != nil) {
           NSMutableArray *list = (NSMutableArray *)result;
           gzArr = [list safeObjectAtIndex:0];
           [_gzAlertV setData:gzArr];
       }
   } failture:^(NSError *error) {
       
   }];
}

- (void)hideAll{
    [self.view endEditing:YES];
    if (!_gzAlertV.hidden) {
        [_gzAlertV disshow];
    }
}

/**
 新增
 */
- (void)fetchAdd
{
    NSString *startDate = [NSString stringWithFormat:@"%@ %@:00",_dateTF.text,_timeTF.text];
    NSString *endDate = [NSString stringWithFormat:@"%@ %@:00",_dateTF1.text,_timeTF1.text];
    NSString *warntext = nil;
    if (warnid > 0) {
        warntext = selectedWarn.warnname;
    }else{
        warntext = _qtgzTF.text;
    }
    NSDictionary *dic = @{@"userid" : @(self.baseUser.userid),
                          @"type" : [NSObject changeType:self.baseUser.type],
                          @"usertype" : [NSObject changeType:self.baseUser.usertype],
                          @"projectid" : @(_projectid),
                          @"deviceid" : @(_dm.deviceid),
                          @"warnid" : @(warnid),
                          @"sdate" : [NSObject changeType:startDate],
                          @"edate" : [NSObject changeType:endDate],
                          @"text" : [NSObject changeType:warntext]};
    [[DQServiceInterface sharedInstance] dq_getAddDeviceRepairOrder:dic success:^(id result) {
        if (result != nil) {
            MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"添加成功" actionTitle:@"" duration:3.0];
            [t show];
            [self.navigationController popViewControllerAnimated:YES];
            if (self.basedelegate && [self.basedelegate respondsToSelector:@selector(didPopFromNextVC)]) {
              [self.basedelegate didPopFromNextVC];
            }
        }
    } failture:^(NSError *error) {
        
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
