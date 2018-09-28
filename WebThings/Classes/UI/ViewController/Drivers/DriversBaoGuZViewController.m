//
//  DriversBaoGuZViewController.m
//  WebThings
//
//  Created by machinsight on 2017/7/24.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "DriversBaoGuZViewController.h"
#import "NewDeviceScrollView.h"
#import "FaultDataModel.h"
#import "DriverManagerWI.h"
#import "DriverFaultinFormationWI.h"

@interface DriversBaoGuZViewController ()<NewDeviceScrollViewDelegate>{
    NSMutableArray <UserModel *> *xmjlArr;//项目经理数组
    NSInteger managerid;//经理id
    NSMutableArray <WarningModel *> *gzArr;//故障数据
    NSInteger warnid;//故障id，没有传0
    
    DeviceModel *selectedDevice;
    UserModel *selectedManager;
    WarningModel *selectedWarn;
}
@property (weak, nonatomic) IBOutlet UIView *sbFatherV;
@property (weak, nonatomic) IBOutlet MDTextField *sbTF;
@property (nonatomic,strong) NewDeviceScrollView *pdxhAlertV;/**< 设备 弹出框*/
@property (nonatomic,strong) UITapGestureRecognizer *pdxhFatherGes;/**< top手势*/
@property (weak, nonatomic) IBOutlet UIView *xmjlFatherV;
@property (weak, nonatomic) IBOutlet MDTextField *xmjlTF;
@property (nonatomic,strong) NewDeviceScrollView *xmjlhAlertV;/**< 项目经理 弹出框*/
@property (nonatomic,strong) UITapGestureRecognizer *xmjlFatherGes;/**< top手势*/
@property (weak, nonatomic) IBOutlet UIView *gzFatherV;
@property (weak, nonatomic) IBOutlet MDTextField *gzTF;
@property (nonatomic,strong) NewDeviceScrollView *gzAlertV;/**< 故障 弹出框*/
@property (nonatomic,strong) UITapGestureRecognizer *gzFatherGes;/**< top手势*/
@property (weak, nonatomic) IBOutlet MDTextField *qtgzTF;
@end

@implementation DriversBaoGuZViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initArr];
    [self initView];
    
    self.title = @"报故障";
    
//    [EMINavigationController addAppBar:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)initArr{
    
}

- (void)initView{
    [self rightNavBtn];
    
    [self fetchManagerList];
    [self fetchGuZList];
    
    [self initGesture:_pdxhFatherGes withSelTag:0 withView:_sbFatherV];
    [self initGesture:_xmjlFatherGes withSelTag:1 withView:_xmjlFatherV];
    [self initGesture:_gzFatherGes withSelTag:2 withView:_gzFatherV];
    //设备弹出框
    if (!_pdxhAlertV) {
        _pdxhAlertV = [[NewDeviceScrollView alloc] initWithFrame:CGRectMake(8, 148, screenWidth-16, 223)];
        _pdxhAlertV.tag = 1000;
        _pdxhAlertV.delegate = self;
    }
    [_pdxhAlertV setData:_deviceData];
    //项目经理弹出框
    if (!_xmjlhAlertV) {
        _xmjlhAlertV = [[NewDeviceScrollView alloc] initWithFrame:CGRectMake(8, 218, screenWidth-16, 223)];
        _xmjlhAlertV.tag = 3000;
        _xmjlhAlertV.delegate = self;
    }
    
    //故障弹出框
    if (!_gzAlertV) {
        _gzAlertV = [[NewDeviceScrollView alloc] initWithFrame:CGRectMake(8, 258, screenWidth-16, 223)];
        _gzAlertV.tag = 4000;
        _gzAlertV.delegate = self;
    }
    
}

#pragma NewDeviceScrollViewDelegate
- (void)didSelectValue:(id)value withSelf:(NewDeviceScrollView *)sender witnIndex:(NSInteger)index{
    if (sender.tag == 1000) {
        selectedDevice = (DeviceModel *)value;
        _sbTF.text = selectedDevice.deviceno;
    }else if(sender.tag == 3000){
        selectedManager = (UserModel *)value;
        _xmjlTF.text = selectedManager.name;
    
    }else if(sender.tag == 4000){
        selectedWarn = (WarningModel *)value;
        _gzTF.text = selectedWarn.warnname;
    }
    
}

- (UIBarButtonItem *)rightNavBtn{
    UIBarButtonItem *rightNav = [UIBarButtonItem itemWithTarget:self action:@selector(rightNavClicked) image:[UIImage imageNamed:@"ic_done"]]; 
    self.navigationItem.rightBarButtonItem = rightNav;
    return rightNav;
}

- (void)rightNavClicked{
    [self hideAll];
    if (!selectedDevice) {
        MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"请选择设备" actionTitle:@"" duration:3.0];
        [t show];
        return;
    }
    if (!selectedManager) {
        MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"请选择项目经理" actionTitle:@"" duration:3.0];
        [t show];
        return;
    }
    if (!selectedWarn && !_qtgzTF.text.length) {
        MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"若不选择故障，请填写其他故障" actionTitle:@"" duration:3.0];
        [t show];
        return;
    }
    [MobClick event:@"driver_troubleSend"];
    [self fetchBaoGuZ];
    
}
- (IBAction)hideKeyBoard:(UITapGestureRecognizer *)sender {
    [self hideAll];
    
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([NSStringFromClass(object_getClass(touch.view)) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
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
        default:
            break;
    }
    if (!ges) {
        ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:NSSelectorFromString(selStr)];
        [aimView addGestureRecognizer:ges];
    }
}
- (void)gesTap0:(UITapGestureRecognizer *)sender {
    if (_projectid == 0) {
        MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"数据加载中" actionTitle:@"" duration:3.0];
        [t show];
        return;
    }
    [self hideAll];
    if (_pdxhAlertV.hidden) {
        
        [_pdxhAlertV showWithFatherV:self.view];
    }
}
- (void)gesTap1:(UITapGestureRecognizer *)sender {
    if (!xmjlArr.count) {
        MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"暂无项目经理可选" actionTitle:@"" duration:3.0];
        [t show];
        return;
    }
    [self hideAll];
    if (_xmjlhAlertV.hidden) {
        
        [_xmjlhAlertV showWithFatherV:self.view];
    }
}
- (void)gesTap2:(UITapGestureRecognizer *)sender {
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
 请求项目经理
 */
- (void)fetchManagerList{
    DriverManagerWI *lwi = [[DriverManagerWI alloc] init];
    NSArray *arr = @[@(self.baseUser.userid),self.baseUser.type,self.baseUser.usertype];
    NSDictionary *param = [lwi inBox:arr];
    [CKNetTools requestWithRequestType:POST WithURL:lwi.fullUrl WithParamater:param WithProgressBlock:^(NSProgress *process) {
        
    } WithSuccessBlock:^(id returnValue) {
        NSArray *temp = [lwi unBox:returnValue];
        if ([temp[0] integerValue] == 1) {
            //成功
            xmjlArr = temp[1];
            [_xmjlhAlertV setData:xmjlArr];
        }
        
        
    } WithFailureBlock:^(NSError *error) {
    }];
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

/**
 报故障
 */
- (void)fetchBaoGuZ{
    DriverFaultinFormationWI *lwi = [[DriverFaultinFormationWI alloc] init];
    NSString *s;
    if (!_qtgzTF.text.length) {
        s = selectedWarn.warnname;
    }else{
        s = _qtgzTF.text;
    }
    NSArray *arr = @[@(self.baseUser.userid),self.baseUser.type,self.baseUser.usertype,@(selectedManager.userid),@(selectedWarn.warnid),s,@(_projectid),@(selectedDevice.projectdeviceid),@(selectedDevice.deviceid)];
    NSDictionary *param = [lwi inBox:arr];
    [CKNetTools requestWithRequestType:POST WithURL:lwi.fullUrl WithParamater:param WithProgressBlock:^(NSProgress *process) {
        
    } WithSuccessBlock:^(id returnValue) {
        NSArray *temp = [lwi unBox:returnValue];
        if ([temp[0] integerValue] == 1) {
            //成功
            MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"操作成功" actionTitle:@"" duration:3.0];
            [t show];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
        
    } WithFailureBlock:^(NSError *error) {
    }];
}
- (void)hideAll{
    [self.view endEditing:YES];
    if (!_pdxhAlertV.hidden) {
        [_pdxhAlertV disshow];
    }
    if (!_xmjlhAlertV.hidden) {
        [_xmjlhAlertV disshow];
    }
    if (!_gzAlertV.hidden) {
        [_gzAlertV disshow];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
