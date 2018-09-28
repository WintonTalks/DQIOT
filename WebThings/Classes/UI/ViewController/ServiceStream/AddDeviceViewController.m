//
//  AddDeviceViewController.m
//  WebThings
//
//  Created by machinsight on 2017/6/23.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "AddDeviceViewController.h"
#import "DeviceModel.h"
#import "DeviceProjectModel.h"
#import "EditDeviceViewController.h"

#import "DQNewDeviceCell.h"
#import "DQTextFiledInfoCell.h"
#import "DQTextFieldArrowForCell.h"
#import "NewDeviceScrollView.h"
#import "BRDatePickerView.h"
#import "DQAddProjectModel.h"

@interface AddDeviceViewController ()
<UITableViewDelegate,
UITableViewDataSource,
EditDeviceViewControllerDelegate,
NewDeviceScrollViewDelegate,
MGSwipeTableCellDelegate>
{
    NSMutableArray *_dataSource;
}
@property (nonatomic, strong) UITableView *mTableView;
/** 设备品牌 弹出框*/
@property (nonatomic, strong) NewDeviceScrollView *bradAlertV;
/** 设备型号 弹出框*/
@property (nonatomic, strong) NewDeviceScrollView *numberAlertV;
/** 设备品牌 数据源*/
@property (nonatomic, strong) NSMutableArray *bradArr;

@property (nonatomic, assign) NSInteger deviceid;
@end

@implementation AddDeviceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"新增设备";
    [self configView];
    [self fetchBrandModel];
}

- (void)popDeviceListController
{
    if (!_dataArr.count) { //没有添加设备直接返回，不作处理
        [self.navigationController popViewControllerAnimated:true];
        return;
    }
    
    UIAlertAction *infoAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:true];
    }];
    [infoAction setValue:[UIColor colorWithHexString:COLOR_TITLE_GRAY] forKey:@"titleTextColor"];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [cancelAction setValue:[UIColor colorWithHexString:COLOR_BLUE] forKey:@"titleTextColor"];
    
    NSString *text = @"退出新增设备将会清除数据";
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:text preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:infoAction];
    [alertController addAction:cancelAction];
    NSMutableAttributedString *alertControllerMessageStr = [[NSMutableAttributedString alloc] initWithString:text];
    [alertControllerMessageStr addAttribute:NSFontAttributeName value:[UIFont dq_mediumSystemFontOfSize:16] range:NSMakeRange(0, text.length)];
    [alertController setValue:alertControllerMessageStr forKey:@"attributedMessage"];
    
    UIViewController *topRootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (topRootViewController.presentedViewController)
    {
        topRootViewController = topRootViewController.presentedViewController;
    }
    [topRootViewController presentViewController:alertController animated:true completion:nil];
}

- (CGSize)intrinsicContentSize
{
    return UILayoutFittingExpandedSize;
}

- (void)configView
{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(onSubmitClick) title:@"提交"];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(popDeviceListController) image:ImageNamed(@"back")];

    _dataSource = [NSMutableArray arrayWithArray:[self createInfoCells]];
   
    _mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, screenWidth, 488) style:UITableViewStylePlain];
    _mTableView.backgroundColor = [UIColor colorWithHexString:@"#F3F4F5"];
    _mTableView.delegate = self;
    _mTableView.dataSource = self;
    _mTableView.separatorColor = [UIColor clearColor];
    _mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mTableView.tableFooterView = [UIView new];
    if (@available(iOS 11.0, *)) {
        _mTableView.estimatedRowHeight = 0;
        _mTableView.estimatedSectionHeaderHeight = 0;
        _mTableView.estimatedSectionFooterHeight = 0;
    }
    [self.view addSubview:_mTableView];
    
    if (!_dataArr) {
        _dataArr = [NSMutableArray new];
    }
    _bradAlertV = [[NewDeviceScrollView alloc] initWithFrame:CGRectMake(0, 64+8+50, screenWidth, 223)];
    _bradAlertV.tag = 0;
    _bradAlertV.delegate = self;
    _bradAlertV.hidden = true;
    [self.mTableView addSubview:_bradAlertV];
    
    _numberAlertV = [[NewDeviceScrollView alloc] initWithFrame:CGRectMake(0, 172, screenWidth, 223)];
    _numberAlertV.tag = 1;
    _numberAlertV.delegate = self;
    _numberAlertV.hidden = true;
    [self.mTableView addSubview:_numberAlertV];
}

#pragma mark -保存 && 提交
- (void)onSaveClick
{
    DQTextFieldArrowForCell *deviceBrandCell = [_dataSource safeObjectAtIndex:1];
    DQTextFieldArrowForCell *deviceNumberCell = [_dataSource safeObjectAtIndex:2];
    DQTextFiledInfoCell *priceCell = [_dataSource safeObjectAtIndex:3];
    DQTextFieldArrowForCell *pretreatmentCell = [_dataSource safeObjectAtIndex:4];
    DQTextFiledInfoCell *heightCell = [_dataSource safeObjectAtIndex:5];
    DQTextFieldArrowForCell *timeCell = [_dataSource safeObjectAtIndex:6];
    DQTextFiledInfoCell *addressCell = [_dataSource safeObjectAtIndex:7];
    DQTextFieldArrowForCell *useTimeCell = [_dataSource safeObjectAtIndex:8];
    if (!deviceBrandCell.rightField.text || ![deviceNumberCell.rightField.text length] || ![priceCell.rightField.text length] || ![pretreatmentCell.rightField.text length] || ![heightCell.rightField.text length] || ![timeCell.rightField.text length] || ![addressCell.rightField.text length] || ![useTimeCell.rightField.text length]) {
        MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"请填写相关数据" actionTitle:@"" duration:3.0];
        [t show];
        return;
    }
    if (![AppUtils isAllNum:priceCell.rightField.text] || ![AppUtils isAllNum:heightCell.rightField.text]) {
        MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"请填写正确的格式" actionTitle:@"" duration:3.0];
        [t show];
        return;
    }
    
    int cute = [NSDate compareOneDay:useTimeCell.rightField.text withAnotherDay:pretreatmentCell.rightField.text format:@"yyyy/MM/dd"];
    if (cute < 1) {
        MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"使用时间要大于安装时间" actionTitle:@"" duration:3.0];
        [t show];
        return;
    }
    
    int compleDate = [NSDate compareOneDay:useTimeCell.rightField.text withAnotherDay:timeCell.rightField.text format:@"yyyy/MM/dd"];
    if (compleDate < 1) {
        MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"使用时间要大于安装时间" actionTitle:@"" duration:3.0];
        [t show];
        return;
    }
    
    if (_dataArr.count > 0) {
      //判断有无重复的设备编号
        for (DeviceModel *model in _dataArr) {
            if ([model.deviceno isEqualToString:deviceNumberCell.rightField.text] && model.deviceid == _deviceid) {
                MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"设备编号不能重复!" actionTitle:@"" duration:3.0];
                [t show];
                return;
            }
        }
    }
    DeviceModel *model = [[DeviceModel alloc] init];
    model.brand = deviceBrandCell.rightField.text;
    model.deviceid = _deviceid;
    model.price = [priceCell.rightField.text doubleValue];
    model.projectid = _projectid;
    model.beforehanddate = pretreatmentCell.rightField.text;
    model.high = [heightCell.rightField.text integerValue];
    model.handdate = timeCell.rightField.text;
    model.address = addressCell.rightField.text;
    model.installationsite = addressCell.rightField.text;
    model.starttime = useTimeCell.rightField.text;
    model.deviceno = deviceNumberCell.rightField.text;
    [_dataArr insertObject:model atIndex:0];

    CGFloat height = _dataArr.count*(74+8)+488;
    if (height > screenHeight) {
        height = screenHeight-64-10;
    }
    self.mTableView.height = height;
    _bradAlertV.top += 90;
    _numberAlertV.top += 90;
    [self clearDataCell];
    [self.mTableView reloadData];
}

- (void)onSubmitClick
{
    [self.view endEditing:true];
    if (!_dataArr.count) {
        MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"请至少添加一台设备" actionTitle:@"" duration:3.0];
        [t show];
        return;
    }
    [self fetchAdd];
}

#pragma mark - EditDeviceViewControllerDelegate 修改设备返回代理
- (void)didPopWithDevice:(DeviceModel *)device WithIndex:(NSInteger)index
{
    [_dataArr replaceObjectAtIndex:index withObject:device];
    [self.mTableView reloadData];
}

#pragma mark -NewDeviceScrollViewDelegate
- (void)didSelectValue:(id)value withSelf:(NewDeviceScrollView *)sender witnIndex:(NSInteger)index
{
    if (sender.tag == 0) { //设备品牌
        DQAddProjectModel *projectModel = (DQAddProjectModel *)value;
        DQTextFieldArrowForCell *deviceBrandCell = [_dataSource safeObjectAtIndex:1];
        deviceBrandCell.rightField.text = [NSString stringWithFormat:@"%@", projectModel.brand];
        [_numberAlertV setData:projectModel.deviceArray];
    } else if (sender.tag == 1) { //设备型号
        DQDeviceModel *model = (DQDeviceModel *)value;
        DQTextFieldArrowForCell *deviceNumberCell = [_dataSource safeObjectAtIndex:2];
        deviceNumberCell.rightField.text = [NSString stringWithFormat:@"%@",model.deviceno];
        _deviceid = model.deviceid;
    }
}

/**
 添加项目设备
 */
- (void)fetchAdd
{
    NSMutableArray *addList = [NSMutableArray new];
    for (DeviceModel *model in _dataArr) {
        [addList safeAddObject:@(model.deviceid)];
    }
    [[DQDeviceInterface sharedInstance] dq_getAddDeviceList:_dataArr projectID:_projectid success:^(id result) {
        if (result) {
            MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"操作成功" actionTitle:@"" duration:3.0];
            [t show];
            if (self.AddDeviceSubmitBlock) {
              self.AddDeviceSubmitBlock(addList);
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failture:^(NSError *error) {

    }];
}

/**
 请求品牌型号
 */
- (void)fetchBrandModel
{
    [[DQServiceInterface sharedInstance] dq_getBrandDeviceProject:0 success:^(id result) {
        if (result != nil) {
            _bradArr = result;
            self.bradAlertV.dataList = result;
        }
    } failture:^(NSError *error) {
        
    }];
}

#pragma mark-UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.dataArr.count;
    }
    return _dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 82.f;
    } else {
        if (indexPath.row == 0) {
            return 8.f;
        } else if (indexPath.row == 9) {
            return 88.f;
        }
    }
    return 50.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0 && _dataArr.count > 0) {
        return 8.f;
    }
    return 0.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0 && _dataArr.count > 0) {
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 8)];
        headView.backgroundColor = [UIColor colorWithHexString:@"#F3F4F5"];
        return headView;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && _dataArr.count > 0) {
        DQNewDeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewDeviceCellIdentifier"];
        if (!cell) {
            cell = [[DQNewDeviceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NewDeviceCellIdentifier"];
            cell.delegate = self;
        }
        [cell configAddDeviceModel:[_dataArr safeObjectAtIndex:indexPath.row] count:indexPath.row+1];
        return cell;
    }
    UITableViewCell *cell = [_dataSource safeObjectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:true];
    [_bradAlertV disshow];
    [_numberAlertV disshow];
    if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 1: {//设备品牌
                [_bradAlertV showWithFatherV:self.view];
            } break;
            case 2: {//设备编号
                DQTextFieldArrowForCell *deviceBrandCell = [_dataSource safeObjectAtIndex:1];
                if (deviceBrandCell.rightField.text.length < 1) {
                    MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"请先选择设备品牌" actionTitle:@"" duration:3.0];
                    [t show];
                    return;
                }
                [_numberAlertV showWithFatherV:self.view];
            } break;
            case 4: {//预埋件安装时间
                DQTextFieldArrowForCell *pretreatmentCell = [_dataSource safeObjectAtIndex:4];
                [BRDatePickerView
                 showDatePickerWithTitle:@"请选择预埋件安装时间"
                 dateType:UIDatePickerModeDate
                 defaultSelValue:pretreatmentCell.rightField.text
                 minDateStr:@""
                 maxDateStr:nil
                 isAutoSelect:true
                 resultBlock:^(NSString *selectValue) {
                     pretreatmentCell.rightField.text = selectValue;
                 }];
            } break;
            case 6: {//安装时间
                DQTextFieldArrowForCell *timeCell = [_dataSource safeObjectAtIndex:6];
    
                [BRDatePickerView
                 showDatePickerWithTitle:@"请选择安装时间"
                 dateType:UIDatePickerModeDate
                 defaultSelValue:timeCell.rightField.text
                 minDateStr:nil
                 maxDateStr:nil
                 isAutoSelect:true
                 resultBlock:^(NSString *selectValue) {
                     timeCell.rightField.text = selectValue;
                 }];
            } break;
            case 8: {// 使用时间
                DQTextFieldArrowForCell *timeCell = [_dataSource safeObjectAtIndex:6];
                DQTextFieldArrowForCell *useTimeCell = [_dataSource safeObjectAtIndex:8];
                
                NSString *tomorrwText = [NSDate getTomorrowDay:timeCell.rightField.text withTomorrow:true];
                [BRDatePickerView
                 showDatePickerWithTitle:@"请选择使用时间"
                 dateType:UIDatePickerModeDate
                 defaultSelValue:useTimeCell.rightField.text
                 minDateStr:tomorrwText
                 maxDateStr:nil
                 isAutoSelect:true resultBlock:^(NSString *selectValue) {
                     useTimeCell.rightField.text = selectValue;
                 }];
            } break;
            default:
                break;
        }
    }
}

#pragma mark -MGSwipeTableCellDelegate
-(nullable NSArray<UIView*>*) swipeTableCell:(nonnull MGSwipeTableCell*) cell swipeButtonsForDirection:(MGSwipeDirection)direction
                               swipeSettings:(nonnull MGSwipeSettings*) swipeSettings expansionSettings:(nonnull MGSwipeExpansionSettings*) expansionSettings
{
    swipeSettings.transition = MGSwipeTransitionBorder;
    if (direction == MGSwipeDirectionRightToLeft) {
        expansionSettings.buttonIndex = -1;
        expansionSettings.fillOnTrigger = true;
        return [self createRightButtons];
    }
    return nil;
}

-(BOOL) swipeTableCell:(MGSwipeTableCell*)cell
   tappedButtonAtIndex:(NSInteger)index
             direction:(MGSwipeDirection)direction
         fromExpansion:(BOOL)fromExpansion

{
    if (direction == MGSwipeDirectionRightToLeft) {
        NSIndexPath *indexPath = [self.mTableView indexPathForCell:cell];
        if (index == 0) { //删除
            [_dataArr safeRemoveObjectAtIndex:indexPath.row];
            [self.mTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];            
            return false;
        } else {//编辑
            EditDeviceViewController *deviceVC = [EditDeviceViewController new];
            deviceVC.dm = [_dataArr safeObjectAtIndex:indexPath.row];
            deviceVC.delegate = self;
            deviceVC.fromWho = 1;
            [self.navigationController pushViewController:deviceVC animated:true];
            return false;
        }
    }
    return true;
}

- (NSArray *)createRightButtons
{
    NSMutableArray * result = [NSMutableArray array];
    UIColor *color = [UIColor colorWithHexString:@"#F3F4F5"];
    NSArray *images = @[ImageNamed(@"icon_delete"),ImageNamed(@"icon_CellEdit")];
    for (int i = 0; i < 2; ++i)
    {
        MGSwipeButton * button = [MGSwipeButton buttonWithTitle:@"" icon:[images safeObjectAtIndex:i] backgroundColor:color padding:20];
        button.width = 80.f;
        [result safeAddObject:button];
    }
    return result;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat height = 488+50;
    if (_dataArr.count > 0) {
        height = _dataArr.count*(74+8)+488+150;
    }
    self.mTableView.contentSize = CGSizeMake(screenWidth, height);
}

#pragma mark -UI
- (NSArray *)createInfoCells
{
    UITableViewCell *topCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"topCellLineIdentifier"];
    topCell.selectionStyle = UITableViewCellSelectionStyleNone;
    topCell.contentView.backgroundColor = [UIColor colorWithHexString:@"#F3F4F5"];
    
    DQTextFieldArrowForCell *deviceBrandCell = [[DQTextFieldArrowForCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"deviceBrandCellIdentifier"];
    deviceBrandCell.configLeftName = @"设备品牌";
    deviceBrandCell.rightField.font = [UIFont dq_regularSystemFontOfSize:14];
    [deviceBrandCell.rightField setEnabled:false];
    
    DQTextFieldArrowForCell *deviceNumberCell = [[DQTextFieldArrowForCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"deviceNumberCellIdentifier"];
    deviceNumberCell.configLeftName = @"设备编号";
    deviceNumberCell.rightField.font = [UIFont dq_regularSystemFontOfSize:14];
    [deviceNumberCell.rightField setEnabled:false];

    DQTextFiledInfoCell *priceCell = [[DQTextFiledInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"priceCellIdentifier"];
    priceCell.configLeftName = @"租赁价格";
    priceCell.rightField.font = [UIFont dq_regularSystemFontOfSize:14];
    priceCell.rightField.keyboardType = UIKeyboardTypeNumberPad;

    DQTextFieldArrowForCell *pretreatmentCell = [[DQTextFieldArrowForCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"pretreatmentCellIdentifier"];
    pretreatmentCell.configLeftName = @"预处理安装时间";
    pretreatmentCell.rightField.font = [UIFont dq_regularSystemFontOfSize:14];
    [pretreatmentCell.rightField setEnabled:false];

    DQTextFiledInfoCell *heightCell = [[DQTextFiledInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"heightCellIdentifier"];
    heightCell.configLeftName = @"安装高度";
    heightCell.rightField.keyboardType = UIKeyboardTypeNumberPad;
    
    DQTextFieldArrowForCell *timeCell = [[DQTextFieldArrowForCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"timeCellIdentifier"];
    timeCell.configLeftName = @"安装时间";
    timeCell.rightField.font = [UIFont dq_regularSystemFontOfSize:14];
    [timeCell.rightField setEnabled:false];

    
    DQTextFiledInfoCell *addressCell = [[DQTextFiledInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"addressCellIdentifier"];
    addressCell.configLeftName = @"安装地点";

    DQTextFieldArrowForCell *useTimeCell = [[DQTextFieldArrowForCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"useTimeCellIdentifier"];
    useTimeCell.configLeftName = @"使用时间";
    useTimeCell.rightField.font = [UIFont dq_regularSystemFontOfSize:14];
    [useTimeCell.rightField setEnabled:false];
    
    UITableViewCell *footInfoCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"footInfoCellIdentifier"];
    footInfoCell.selectionStyle = UITableViewCellSelectionStyleNone;
    footInfoCell.contentView.backgroundColor = [UIColor whiteColor];
    
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    saveButton.frame = CGRectMake((screenWidth-125)/2, 24, 125, 40);
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    saveButton.backgroundColor = RGB_Color(59, 113, 244, 1);
    [saveButton withRadius:18.f];
    [saveButton addTarget:self action:@selector(onSaveClick) forControlEvents:UIControlEventTouchUpInside];
    [footInfoCell.contentView addSubview:saveButton];
    
    return @[topCell,deviceBrandCell,deviceNumberCell,priceCell,pretreatmentCell,heightCell,timeCell,addressCell,useTimeCell,footInfoCell];
}

///清空数据
- (void)clearDataCell
{
    DQTextFieldArrowForCell *deviceBrandCell = [_dataSource safeObjectAtIndex:1];
    DQTextFieldArrowForCell *deviceNumberCell = [_dataSource safeObjectAtIndex:2];
    DQTextFiledInfoCell *priceCell = [_dataSource safeObjectAtIndex:3];
    DQTextFieldArrowForCell *pretreatmentCell = [_dataSource safeObjectAtIndex:4];
    DQTextFiledInfoCell *heightCell = [_dataSource safeObjectAtIndex:5];
    DQTextFieldArrowForCell *timeCell = [_dataSource safeObjectAtIndex:6];
    DQTextFiledInfoCell *addressCell = [_dataSource safeObjectAtIndex:7];
    DQTextFieldArrowForCell *useTimeCell = [_dataSource safeObjectAtIndex:8];
    
    deviceBrandCell.rightField.text = nil;
    deviceNumberCell.rightField.text = nil;
    priceCell.rightField.text = nil;
    pretreatmentCell.rightField.text = nil;
    heightCell.rightField.text = nil;
    timeCell.rightField.text = nil;
    addressCell.rightField.text = nil;
    useTimeCell.rightField.text = nil;
}

@end
