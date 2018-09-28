//
//  EditDeviceViewController.m
//  WebThings
//
//  Created by machinsight on 2017/7/22.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "EditDeviceViewController.h"
#import "NewDeviceDetailCell.h"

#import "DQArrowInfoWithCell.h"
#import "DQTextFiledInfoCell.h"
#import "NewDeviceScrollView.h"
#import "BRDatePickerView.h"
#import "DQAddProjectModel.h"

@interface EditDeviceViewController ()
<UITableViewDelegate,
UITableViewDataSource>
{
    NSMutableArray *_infoArray;
}
@property (nonatomic, strong) UITableView *mTableView;
///** 设备品牌 弹出框*/
//@property (nonatomic, strong) NewDeviceScrollView *bradAlertV;
///** 设备型号 弹出框*/
//@property (nonatomic, strong) NewDeviceScrollView *numberAlertV;
@end

@implementation EditDeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改设备";
    [self initView];
//    [self fetchBrandModel];
}

- (void)initView
{
    UIBarButtonItem *rightNav = [UIBarButtonItem itemWithTarget:self action:@selector(rightNavClicked) title:@"提交"];
    self.navigationItem.rightBarButtonItem = rightNav;
    _infoArray = [NSMutableArray arrayWithArray:[self createInfoCells]];
    
    _mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, screenWidth, 408) style:UITableViewStylePlain];
    _mTableView.delegate = self;
    _mTableView.dataSource = self;
    _mTableView.backgroundColor = [UIColor colorWithHexString:@"#F3F4F5"];
    _mTableView.separatorColor = [UIColor clearColor];
    _mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mTableView.tableFooterView = [UIView new];
    if (@available(iOS 11.0, *)) {
        _mTableView.estimatedRowHeight = 0;
        _mTableView.estimatedSectionHeaderHeight = 0;
        _mTableView.estimatedSectionFooterHeight = 0;
    }
    [self.view addSubview:_mTableView];
    
//    if (!_bradAlertV) {
//        _bradAlertV = [[NewDeviceScrollView alloc] initWithFrame:CGRectMake(0, 69, screenWidth, 223)];
//        _bradAlertV.tag = 0;
//        _bradAlertV.delegate = self;
//        _bradAlertV.hidden = true;
//        [_mTableView addSubview:_bradAlertV];
//    }
//    if (!_numberAlertV) {
//        _numberAlertV = [[NewDeviceScrollView alloc] initWithFrame:CGRectMake(0, 138, screenWidth, 223)];
//        _numberAlertV.tag = 1;
//        _numberAlertV.delegate = self;
//        _numberAlertV.hidden = true;
//        [_mTableView addSubview:_numberAlertV];
//    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (IS_IOS10) {
        UIEdgeInsets inset = _mTableView.contentInset;
        inset.top = 0;
        _mTableView.contentInset = inset;
    }
}

#pragma mark -提交
- (void)rightNavClicked
{
    DQArrowInfoWithCell *deviceBrandCell = [_infoArray safeObjectAtIndex:1];
    DQArrowInfoWithCell *deviceNumberCell = [_infoArray safeObjectAtIndex:2];
    DQTextFiledInfoCell *priceCell = [_infoArray safeObjectAtIndex:3];
    DQArrowInfoWithCell *pretreatmentCell = [_infoArray safeObjectAtIndex:4];
    DQTextFiledInfoCell *heightCell = [_infoArray safeObjectAtIndex:5];
    DQArrowInfoWithCell *timeCell = [_infoArray safeObjectAtIndex:6];
    DQTextFiledInfoCell *addressCell = [_infoArray safeObjectAtIndex:7];
    DQArrowInfoWithCell *useTimeCell = [_infoArray safeObjectAtIndex:8];
//    if (![deviceBrandCell.rightLabel.text length] || ![deviceNumberCell.rightLabel.text length] || ![priceCell.rightField.text length] || ![pretreatmentCell.rightLabel.text length] || ![heightCell.rightField.text length] || ![timeCell.rightLabel.text length] || ![addressCell.rightField.text length] || ![useTimeCell.rightLabel.text length]) {
//        MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"请填写相关数据" actionTitle:@"" duration:3.0];
//        [t show];
//        return;
//    }
    if (![AppUtils isAllNum:priceCell.rightField.text] || ![AppUtils isAllNum:heightCell.rightField.text]) {
        MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"请填写正确的格式" actionTitle:@"" duration:3.0];
        [t show];
        return;
    }
//    DeviceModel *model = [[DeviceModel alloc] init];
    _dm.brand = deviceBrandCell.rightLabel.text;
//    model.deviceid = _dm.deviceid;
    _dm.price = [priceCell.rightField.text doubleValue];
    _dm.projectid = _projectid;
    _dm.beforehanddate = pretreatmentCell.rightLabel.text;
    _dm.high = [heightCell.rightField.text integerValue];
    _dm.handdate = timeCell.rightLabel.text;
    _dm.address = addressCell.rightField.text;
    _dm.installationsite = addressCell.rightField.text;
    _dm.starttime = useTimeCell.rightLabel.text;
    _dm.deviceno = deviceNumberCell.rightLabel.text;
//    model.projectdeviceid = _dm.projectdeviceid;
    
    if (_fromWho == 1) {
        if (_delegate && [_delegate respondsToSelector:@selector(didPopWithDevice:WithIndex:)]) {
                [_delegate didPopWithDevice:_dm WithIndex:_index];
        }
        [self.navigationController popViewControllerAnimated:true];
    } else {
        [self fetchDeviceEdit:_dm];
    }
}

#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _infoArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 8.f;
    }
    return 50.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [_infoArray safeObjectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
//    [_bradAlertV disshow];
//    [_numberAlertV disshow];
    switch (indexPath.row) {
        case 1: {//设备品牌
//            [_bradAlertV showWithFatherV:_mTableView];
        } break;
        case 2: {//设备编号
//            DQArrowInfoWithCell *deviceBrandCell = [_infoArray safeObjectAtIndex:1];
//            if (deviceBrandCell.configRightTitle.length < 1) {
//                MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"请先选择设备品牌" actionTitle:@"" duration:3.0];
//                [t show];
//                return;
//            }
//            [_numberAlertV showWithFatherV:_mTableView];
        } break;
        case 4: {//预埋件安装时间
            DQArrowInfoWithCell *pretreatmentCell = [_infoArray safeObjectAtIndex:4];
            [BRDatePickerView
             showDatePickerWithTitle:@"请选择预埋件安装时间"
             dateType:UIDatePickerModeDate
             defaultSelValue:pretreatmentCell.configRightTitle
             minDateStr:@""
             maxDateStr:nil
             isAutoSelect:true
             resultBlock:^(NSString *selectValue) {
                 pretreatmentCell.configRightTitle = selectValue;
             }];
        } break;
        case 6: {//安装时间
            DQArrowInfoWithCell *timeCell = [_infoArray safeObjectAtIndex:6];
            [BRDatePickerView
             showDatePickerWithTitle:@"请选择安装时间"
             dateType:UIDatePickerModeDate
             defaultSelValue:timeCell.configRightTitle
             minDateStr:@""
             maxDateStr:nil
             isAutoSelect:true
             resultBlock:^(NSString *selectValue) {
                 timeCell.configRightTitle = selectValue;
             }];
        } break;
        case 8: {// 使用时间
            DQArrowInfoWithCell *useTimeCell = [_infoArray safeObjectAtIndex:8];
            [BRDatePickerView
             showDatePickerWithTitle:@"请选择使用时间"
             dateType:UIDatePickerModeDate
             defaultSelValue:useTimeCell.configRightTitle
             minDateStr:@""
             maxDateStr:nil
             isAutoSelect:true resultBlock:^(NSString *selectValue) {
                 useTimeCell.configRightTitle = selectValue;
             }];
        } break;
            
        default:
            break;
    }
}

//#pragma mark -NewDeviceScrollViewDelegate
//- (void)didSelectValue:(id)value withSelf:(NewDeviceScrollView *)sender witnIndex:(NSInteger)index
//{
//    if (sender.tag == 0) { //设备品牌
//        DQAddProjectModel *projectModel = (DQAddProjectModel *)value;
//        DQArrowInfoWithCell *deviceBrandCell = [_infoArray safeObjectAtIndex:1];
//        deviceBrandCell.configRightTitle = [NSString stringWithFormat:@"%@", projectModel.brand];
//        self.numberAlertV.dataList = projectModel.deviceArray;
//    } else if (sender.tag == 1) { //设备型号
//        DQDeviceModel *model = (DQDeviceModel *)value;
//        DQArrowInfoWithCell *deviceNumberCell = [_infoArray safeObjectAtIndex:2];
//        deviceNumberCell.configRightTitle = model.deviceno;
//    }
//}

/**
 请求品牌型号
 */
//- (void)fetchBrandModel
//{
//    [[DQServiceInterface sharedInstance] dq_getBrandDeviceProject:0 success:^(id result) {
//        if (result != nil) {
//            self.bradAlertV.dataList = result;
//        }
//    } failture:^(NSError *error) {
//    }];
//}

/**
 修改项目设备
 */
- (void)fetchDeviceEdit:(DeviceModel *)model
{
    [[DQDeviceInterface sharedInstance] dq_getModifyDevice:model success:^(id result) {
        if (result) {
            MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"修改成功" actionTitle:@"" duration:3.0];
            [t show];
            if (self.state == DQEnumStateCommunicateSubmitted) {
                //发送小飞机
                [self fetchQRDeviceAPI:model];
            } else {
                if (self.basedelegate && [self.basedelegate respondsToSelector:@selector(didPopFromNextVC)]) {
                    [self.basedelegate didPopFromNextVC];
                }
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    } failture:^(NSError *error) {
        
    }];
}

//设备确认接口
- (void)fetchQRDeviceAPI:(DeviceModel *)model
{
    [[DQDeviceInterface sharedInstance]
     dq_getDeviceFirm:@(self.projectid)
     deviceList:[NSMutableArray arrayWithObject:[NSString stringWithFormat:@"%ld", model.deviceid]]
     success:^(id result) {
        if (result) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failture:^(NSError *error) {
        
    }];
}


#pragma mark- UI

- (NSArray *)createInfoCells
{
    UITableViewCell *topCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"topCellLineIdentifier"];
    topCell.selectionStyle = UITableViewCellSelectionStyleNone;
    topCell.contentView.backgroundColor = [UIColor colorWithHexString:@"#F3F4F5"];
    
    DQArrowInfoWithCell *deviceBrandCell = [[DQArrowInfoWithCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"deviceBrandCellIdentifier"];
    deviceBrandCell.configLeftName = @"设备品牌";
    deviceBrandCell.configRightTitle = _dm.brand;
    
    DQArrowInfoWithCell *deviceNumberCell = [[DQArrowInfoWithCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"deviceNumberCellIdentifier"];
    deviceNumberCell.configLeftName = @"设备编号";
    deviceNumberCell.configRightTitle = _dm.deviceno;
    
    DQTextFiledInfoCell *priceCell = [[DQTextFiledInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"priceCellIdentifier"];
    priceCell.configLeftName = @"租赁价格";
    priceCell.rightField.text = [NSString stringWithFormat:@"%.0f",_dm.price];
    
    DQArrowInfoWithCell *pretreatmentCell = [[DQArrowInfoWithCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"pretreatmentCellIdentifier"];
    pretreatmentCell.configLeftName = @"预处理安装时间";
    pretreatmentCell.configRightTitle = [NSDate verifyDateForYMD:_dm.beforehanddate];
    
    DQTextFiledInfoCell *heightCell = [[DQTextFiledInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"heightCellIdentifier"];
    heightCell.configLeftName = @"安装高度";
    heightCell.rightField.text = [NSString stringWithFormat:@"%ld",_dm.high];
    
    DQArrowInfoWithCell *timeCell = [[DQArrowInfoWithCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"timeCellIdentifier"];
    timeCell.configLeftName = @"安装时间";
    timeCell.configRightTitle = [NSDate verifyDateForYMD:_dm.handdate];   //_dm.handdate;
    
    DQTextFiledInfoCell *addressCell = [[DQTextFiledInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"addressCellIdentifier"];
    addressCell.configLeftName = @"安装地点";
    addressCell.rightField.text = _dm.installationsite;
    
    DQArrowInfoWithCell *useTimeCell = [[DQArrowInfoWithCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"useTimeCellIdentifier"];
    useTimeCell.configLeftName = @"使用时间";
    useTimeCell.configRightTitle = [NSDate verifyDateForYMD:_dm.starttime];
    
    return @[topCell,deviceBrandCell,deviceNumberCell,priceCell,pretreatmentCell,heightCell,timeCell,addressCell,useTimeCell];
}

@end
