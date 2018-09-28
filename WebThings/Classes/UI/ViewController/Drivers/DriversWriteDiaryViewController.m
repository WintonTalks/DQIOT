//
//  DriversWriteDiaryViewController.m
//  WebThings
//
//  Created by machinsight on 2017/7/24.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "DriversWriteDiaryViewController.h"
#import "EMICardView.h"
#import "NewDeviceScrollView.h"
#import "DriverDiaryDetailCell.h"
#import "CheckModel.h"
#import "AddDailyWI.h"
#import "DQDeviceInterface.h"

@interface DriversWriteDiaryViewController ()<NewDeviceScrollViewDelegate,DriverDiaryDetailCellDelegate>{

    NSInteger deviceid; //设备id
    NSString *deviceno; //设备编号
}
@property (weak, nonatomic) IBOutlet EMICardView *topFatherV;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (nonatomic, strong) UITapGestureRecognizer *pdxhFatherGes;/**< top手势*/
@property (nonatomic, strong) NewDeviceScrollView *pdxhAlertV;/**< top 弹出框*/

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray  <CheckModel *> *dataSourse;


@property (nonatomic, strong) NewDeviceScrollView *stateAlertV;/**< state 弹出框*/

@property (nonatomic, assign) NSInteger stateIndex;
@end

@implementation DriversWriteDiaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initArr];
    [self initView];

    self.title = @"发日报";
    
    //[EMINavigationController addAppBar:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initArr{
    _dataSourse = [NSMutableArray array];
}

- (void)initView{
    
    //设备弹出框
    if (!_pdxhAlertV) {
        _pdxhAlertV = [[NewDeviceScrollView alloc]
                       initWithFrame:CGRectMake(8, 78 + _topFatherV.frame.size.height, screenWidth-16, 223)];
        _pdxhAlertV.tag = 1000;
        _pdxhAlertV.delegate = self;
    }
    
    if (!_stateAlertV) {
        _stateAlertV = [[NewDeviceScrollView alloc] initWithFrame:CGRectMake(8, 78, screenWidth-16, 125)];
        _stateAlertV.tag = 2000;
        _stateAlertV.delegate = self;
    }
    
    [self initGesture:_pdxhFatherGes withSelTag:0 withView:_topFatherV];
    [self rightNavBtn];
    
    _titleLab.text = _projectname;
    [_pdxhAlertV setData:_deviceData];
    
    [self fetchDiaryList];
}

- (UIBarButtonItem *)rightNavBtn{
    UIBarButtonItem *rightNav = [UIBarButtonItem itemWithTarget:self action:@selector(rightNavClicked) image:[UIImage imageNamed:@"ic_done"]];
    self.navigationItem.rightBarButtonItem = rightNav;
    return rightNav;
}

- (void)rightNavClicked{
    if (deviceid == 0) {
        MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"请选择设备" actionTitle:@"" duration:3.0];
        [t show];
        return;
    }
    for (int i = 0; i < _dataSourse.count; i++) {
        if (!_dataSourse[i].checkstate) {
            MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"还有项目检查未填写" actionTitle:@"" duration:3.0];
            [t show];
            return;
        }
    }
    [MobClick event:@"driver_diarySend"];
    [self fetchSendDiary];
}

#pragma mark -UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSourse.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DriverDiaryDetailCell *cell = [DriverDiaryDetailCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setViewValuesWithModel:_dataSourse[indexPath.row]];
    cell.index = indexPath.row;
    cell.delegate = self;
    return cell;
}

#pragma cellbtn 点击
- (void)didClickBtnWithCellIndex:(NSInteger)index WithModel:(CheckModel *)m{
    if (!_stateAlertV.hidden) {
        [_stateAlertV disshow];
        return;
    }
    
    DriverDiaryDetailCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    
    CGPoint point = [cell.stateBtn convertPoint:CGPointMake(0, 0) toView:self.view];
    CGFloat y = point.y + 25;
    if (y + 125 > screenHeight) {
        y -= 145;
    }
    
    _stateAlertV.frame = CGRectMake(_tableView.frame.size.width-70-11, y, 70, 125);
    [_stateAlertV setData:[NSMutableArray arrayWithArray:m.states]];
    if (_stateAlertV.hidden) {
        [_stateAlertV showWithFatherV:self.view];
    } else {
        [_stateAlertV disshow];
    }
    _stateIndex = index;
}

#pragma mark -UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 61;
}

#pragma 初始化手势
- (void)initGesture:(UITapGestureRecognizer *)ges withSelTag:(int)tag withView:(UIView *)aimView{
    NSString *selStr;
    switch (tag) {
        case 0:
            selStr = @"gesTap0:";
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
    if (_pdxhAlertV.hidden) {
        [MobClick event:@"driver_chooseDevice"];
        [_pdxhAlertV showWithFatherV:self.view];
    } else {
        [_pdxhAlertV disshow];
    }
}

#pragma NewDeviceScrollViewDelegate
- (void)didSelectValue:(id)value withSelf:(NewDeviceScrollView *)sender witnIndex:(NSInteger)index{
    if (sender.tag == 1000) {
        DeviceModel *m = (DeviceModel *)value;
        _titleLab.text = [NSString stringWithFormat:@"%@-%@",_projectname,m.deviceno];
        deviceid = m.deviceid;
        deviceno = m.deviceno;
    }else if(sender.tag == 2000){
        _dataSourse[_stateIndex].checkstate = value;
        [self.tableView reloadData];
    }
}

- (IBAction)hideKeyBoard:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
    if (_pdxhAlertV) {
        [_pdxhAlertV disshow];
    }
}

/**
 获取日报项
 */
- (void)fetchDiaryList
{
    [[DQDeviceInterface sharedInstance] dq_getDailyCheckType:^(id result) {
        if (result) {
            _dataSourse = (NSMutableArray *)result;
            [self.tableView reloadData];
        }
    } failture:^(NSError *error) {
        
    }];
}

/**
 发日报
 */
- (void)fetchSendDiary{
    AddDailyWI *lwi = [[AddDailyWI alloc] init];
    NSArray *da = [CheckModel mj_keyValuesArrayWithObjectArray:_dataSourse];
    NSArray *arr = @[@(self.baseUser.userid),self.baseUser.type,self.baseUser.usertype,da,@(deviceid),deviceno];
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

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if(_pdxhAlertV && CGRectContainsPoint(_pdxhAlertV.frame, [touch locationInView:self.view])){
        return NO;
    }
    if ([NSStringFromClass(object_getClass(touch.view)) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
}

@end
