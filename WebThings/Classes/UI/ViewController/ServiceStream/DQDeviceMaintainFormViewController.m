//
//  DQDeviceMaintainFormViewController.m
//  WebThings
//
//  Created by Eugene on 10/16/17.
//  Copyright © 2017 machinsight. All rights


#import "DQDeviceMaintainFormViewController.h"
#import "DQTextFiledInfoCell.h"
#import "DQTextFieldArrowForCell.h"
#import "BRDatePickerView.h" // 日期选择器
#import "DQPopupListView.h" // 弹出框列表

#import "DeviceMaintainorderModel.h"
#import "WarningModel.h" // 故障列表model

#import "ZYKeyboardUtil.h" // 键盘处理

@interface DQDeviceMaintainFormViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITextField *managerTextField;
@property (nonatomic, strong) UITextField *additionTextField;
@property (nonatomic, strong) UITextField *descTextField;

@property (nonatomic, strong) UITextField *startDateTextField;
@property (nonatomic, strong) UITextField *startTimeTextField;
@property (nonatomic, strong) UITextField *endDateTextField;
@property (nonatomic, strong) UITextField *endTimeTextField;

/** 项目、设备ID */
@property (nonatomic, assign) NSInteger projectID;
@property (nonatomic, assign) NSInteger deviceID;
@property (nonatomic, assign) NSInteger warnID;

/** 设备维保单 */
@property (nonatomic, strong) DeviceMaintainorderModel *maintainOrderModel;
/**< 故障 弹出框*/

@property (nonatomic, strong) NSArray *dataSource;

@property (nonatomic, strong) NSArray *titleAry;
/** 维修 */
@property (nonatomic, strong) NSArray *fixArray;
/** 加高 */
@property (nonatomic, strong) NSArray *heightenArray;
/** 维保 */
@property (nonatomic, strong) NSArray *maintainArray;
/** 故障列表 */
@property (nonatomic, strong) NSMutableArray <NSDictionary *>*errorArray;
@property (nonatomic, strong) NSMutableArray <WarningModel *>*errorModelArray;

@property (nonatomic, strong) ZYKeyboardUtil *keyboardUtil;

@end

@implementation DQDeviceMaintainFormViewController

#pragma mark - Life Cycle
- (instancetype)initWithProjectID:(NSInteger)projectID deviceID:(NSInteger)deviceID {
    self = [super init];
    if (self) {
        _projectID = projectID;
        _deviceID = deviceID;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getFailureListHttp];
    [self initFormView];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInset = UIEdgeInsetsMake(0,0,0,0);
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)initFormView {
    
    if (self.formType == DQEnumStateFixAdd) {
        self.title = @"设备维修";
    } else if (self.formType == DQEnumStateHeightAdd) {
        self.title = @"设备加高";
    } else if (self.formType == DQEnumStateMaintainAdd) {
        self.title = @"设备维保";
    }
    
    [self.view addSubview:self.tableView];

    _errorArray = [[NSMutableArray alloc] init];
    _errorModelArray = [[NSMutableArray alloc] init];

    _maintainOrderModel = [[DeviceMaintainorderModel alloc] init];
    _dataSource = [[NSMutableArray alloc] initWithArray:[self createDeviceMaintainFormCell]];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(onSubmitMaintainFormViewClicked) title:@"提交"];
}

- (NSArray *)createDeviceMaintainFormCell {
    
    DQTextFieldArrowForCell *managerCell = [[DQTextFieldArrowForCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"managerCellIdentifier"];
    [self configTableViewCellStyleWithCell:managerCell];
    managerCell.rightField.text = self.baseUser.name;
    managerCell.arrowImageName = nil;
    _managerTextField = managerCell.rightField;
    
    DQTextFieldArrowForCell *failureCell;
    if (self.formType == DQEnumStateHeightAdd) {
        failureCell = [[DQTextFieldArrowForCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"failureCellIdentifier"];
        [self configTableViewCellStyleWithCell:failureCell];
        failureCell.rightField.enabled = YES;
        failureCell.rightField.delegate = self;
        failureCell.arrowImageName = nil;
        failureCell.configPlaceholder = @"请输入";
        failureCell.rightField.keyboardType = UIKeyboardTypePhonePad;
    } else {
        failureCell = [[DQTextFieldArrowForCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"failureCellIdentifier"];
        [self configTableViewCellStyleWithCell:failureCell];
    }
    _additionTextField = failureCell.rightField;
    
    DQTextFieldArrowForCell *contentCell = [[DQTextFieldArrowForCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"contentCellIdentifier"];
    contentCell.isFullTextField = YES;
    contentCell.rightField.delegate = self;
    contentCell.rightField.textAlignment = NSTextAlignmentLeft;
    contentCell.rightField.returnKeyType = UIReturnKeyDone;
    contentCell.configPlaceholder = @"如无以上故障，请输入故障";
    contentCell.rightField.font = [UIFont dq_regularSystemFontOfSize:14.0];
    contentCell.rightField.textColor = [UIColor colorWithHexString:@"#707070"];
    _descTextField = contentCell.rightField;
    
    DQTextFieldArrowForCell *startDateCell = [[DQTextFieldArrowForCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"startDateCellIdentifier"];
    [self configTableViewCellStyleWithCell:startDateCell];
    _startDateTextField = startDateCell.rightField;
    
    DQTextFieldArrowForCell *startTimeCell = [[DQTextFieldArrowForCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"startTimeCellIdentifier"];
    [self configTableViewCellStyleWithCell:startTimeCell];
    _startTimeTextField = startTimeCell.rightField;
    
    DQTextFieldArrowForCell *endDateCell = [[DQTextFieldArrowForCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"endDateCellIdentifier"];
    [self configTableViewCellStyleWithCell:endDateCell];
    _endDateTextField = endDateCell.rightField;
    
    DQTextFieldArrowForCell *endTimeCell = [[DQTextFieldArrowForCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"endTimeCellIdentifier"];
    [self configTableViewCellStyleWithCell:endTimeCell];
    _endTimeTextField = endTimeCell.rightField;
    
    if (self.formType == DQEnumStateFixAdd) {
        return @[@[managerCell,failureCell,contentCell],@[startDateCell,startTimeCell,endDateCell,endTimeCell]];
    }
    else if (self.formType == DQEnumStateHeightAdd) {
        return @[@[managerCell,failureCell],@[startDateCell,startTimeCell,endDateCell,endTimeCell]];
    }
    else if (self.formType == DQEnumStateMaintainAdd) {
        return @[@[managerCell],@[startDateCell,startTimeCell,endDateCell,endTimeCell],@[]];
    }
    return @[];
}

- (void)configTableViewCellStyleWithCell:(DQTextFieldArrowForCell *)cell {
    
    cell.configLeftTitleColor = @"#1D1D1D";
    cell.configLeftFont = [UIFont dq_regularSystemFontOfSize:14.0];
    cell.rightField.font = [UIFont dq_regularSystemFontOfSize:14.0];
    cell.rightField.textColor = [UIColor colorWithHexString:@"#707070"];
    cell.rightField.enabled = NO;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self endEditingView];
}

- (void)endEditingView {
    [_descTextField resignFirstResponder];
    [_additionTextField resignFirstResponder];
    [self.view resignFirstResponder];
}

#pragma mark - Delegate And DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.titleAry.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *ary = self.titleAry[section];
    return ary.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (indexPath.section == 2) ? ((indexPath.row == 0) ? 50 : 44) : 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 2) {
        DQTextFieldArrowForCell *cell = [tableView dequeueReusableCellWithIdentifier:@"maintainContentCellIdentifier"];
        if (!cell) {
            cell = [[DQTextFieldArrowForCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"maintainContentCellIdentifier"];
            cell.configLeftTitleColor = @"#1D1D1D";
            cell.configLeftFont = [UIFont dq_regularSystemFontOfSize:14.0];
            cell.rightField.hidden = YES;
            cell.arrowImageName = nil;
        }
        NSArray *titles = self.titleAry[indexPath.section];
        cell.configLeftName = titles[indexPath.row];
        if (indexPath.row == 0) {
            cell.configLeftFont = [UIFont dq_mediumSystemFontOfSize:16.0];
        }
        return cell;
    } else {
        NSArray *ary = _dataSource[indexPath.section];
        DQTextFieldArrowForCell *cell = [ary safeObjectAtIndex:indexPath.row];
        NSArray *titles = self.titleAry[indexPath.section];
        cell.configLeftName = titles[indexPath.row];
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    [self endEditingView];
    
    NSArray *ary = _dataSource[indexPath.section];
    DQTextFieldArrowForCell *cell = [ary safeObjectAtIndex:indexPath.row];
    DQTextFieldArrowForCell *previousCell = [ary safeObjectAtIndex:indexPath.row>0 ? indexPath.row-1: indexPath.row];

    if (indexPath.section == 0) {
        [self didSelectRowAtIndexPath:indexPath];
    } else if (indexPath.section == 1) {
        NSArray *titles = self.titleAry[indexPath.section];
        NSString *title = titles[indexPath.row];

        /** 当前一个日期选择器为选择时，提示Alert */
        if (!previousCell.rightField.text.length && previousCell != cell) {
            NSString *text = [NSString stringWithFormat:@"请先选择%@",titles[indexPath.row>0 ? indexPath.row-1 : indexPath.row]];
            MDSnackbar *alert = [[MDSnackbar alloc] initWithText:text  actionTitle:@"" duration:3.0];
            [alert show];
            return;
        }
        /** 判断 结束维修日期 大于 开始维修日期 */
        DQTextFieldArrowForCell *startDateCell = [ary safeObjectAtIndex:0];
        NSString *miniDateStr = (indexPath.row == 2) ? startDateCell.rightField.text : nil;
        /** 判断选择器类型 */
        UIDatePickerMode pickerMode = (indexPath.row % 2 == 0) ? UIDatePickerModeDate : UIDatePickerModeTime;
        [BRDatePickerView showDatePickerWithTitle:title dateType:pickerMode defaultSelValue:nil minDateStr:miniDateStr maxDateStr:nil isAutoSelect:false resultBlock:^(NSString *selectValue) {
            cell.rightField.text = selectValue;
        }];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 8;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 10)];
    view.backgroundColor = [UIColor colorWithHexString:COLOR_BG];
    return view;
}

- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
    } else if (indexPath.row == 1) {
        if (self.formType == DQEnumStateFixAdd) {
            NSArray *ary = _dataSource[indexPath.section];
            DQTextFieldArrowForCell *cell = [ary safeObjectAtIndex:indexPath.row];
            
            NSMutableArray *errors = [[NSMutableArray alloc] init];
            [_errorModelArray enumerateObjectsUsingBlock:^(WarningModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [errors addObject:obj.warnname];
                NSDictionary *dict = @{@"warnname":obj.warnname,@"warnid":@(obj.warnid)};
                [_errorArray addObject:dict];
            }];
            
            DQPopupListView *popListView = [DQPopupListView shareInstance];
            [popListView showPopListWithDataSource:errors];
            popListView.didSelectBlock = ^(id modle) {
                DQLog(@"error : %@",modle);
                NSString *errorStr = (NSString *)modle;
                cell.rightField.text = errorStr;
                
                [_errorArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj[@"warnname"] isEqualToString:errorStr]) {
                        _warnID = [obj[@"warnid"] integerValue];
                    }
                }];
            };
        } else if (self.formType == DQEnumStateHeightAdd) {
            
        } else if (self.formType == DQEnumStateMaintainAdd) {
            
        }
    } else {
        
    }
}

#pragma mark - Actions
- (void)onSubmitMaintainFormViewClicked {

    if ([self checkParamsError]) {
        [self alertWithTitle:@"您的表单未填写完成！"];
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self postMaintainFormHttp];
}

#pragma mark - HTTP
/** 发送维保单网络请求 */
- (void)postMaintainFormHttp {
    
    NSDictionary *param = [self getDeviceMaintainParam];
    [[DQServiceInterface sharedInstance] dq_addMaintenceOrderWithType:self.formType params:param success:^(id result) {
        DQLog(@"result: %@",result);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (result != nil) {
            MDSnackbar *alertBar = [[MDSnackbar alloc] initWithText:@"添加成功" actionTitle:@"" duration:1.5];
            [alertBar show];
            [self.navigationController popViewControllerAnimated:YES];
            if (self.basedelegate && [self.basedelegate respondsToSelector:@selector(didPopFromNextVC)]) {
                [self.basedelegate didPopFromNextVC];
            };
        }
    } failture:^(NSError *error) {
        DQLog(@"error: %@",error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

/** 请求故障列表 */
- (void)getFailureListHttp {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *dic = @{@"userid" : @(self.baseUser.userid),
                          @"type" : [NSObject changeType:self.baseUser.type],
                          @"usertype" : [NSObject changeType:self.baseUser.usertype]};
    [[DQServiceInterface sharedInstance] dq_getFaultdata:dic success:^(id result) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (result != nil) {
            NSMutableArray *list = (NSMutableArray *)result;
            _errorModelArray = [list safeObjectAtIndex:0];
        }
    } failture:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

#pragma mark - Private Method
- (void)alertWithTitle:(NSString *)title {
    NSString *text = [NSString stringWithFormat:@"%@",title];
    MDSnackbar *alert = [[MDSnackbar alloc] initWithText:text  actionTitle:@"" duration:3.0];
    [alert show];
}

- (BOOL)checkParamsError {
    
    if (self.formType == DQEnumStateMaintainAdd) {
        if ([self isBlankString:_startDateTextField.text] || [self isBlankString:_startTimeTextField.text] || [self isBlankString:_endDateTextField.text] || [self isBlankString:_endTimeTextField.text]) {
            return YES;
        }
    }
    else if (self.formType == DQEnumStateFixAdd) {
        if ([self isBlankString:_additionTextField.text] || [self isBlankString:_descTextField.text] || [self isBlankString:_startDateTextField.text] || [self isBlankString:_startTimeTextField.text] || [self isBlankString:_endDateTextField.text] || [self isBlankString:_endTimeTextField.text]) {
            return YES;
        }
    }
    else if (self.formType == DQEnumStateHeightAdd) {
        if ([self isBlankString:_additionTextField.text] || [self isBlankString:_startDateTextField.text] || [self isBlankString:_startTimeTextField.text] || [self isBlankString:_endDateTextField.text] || [self isBlankString:_endTimeTextField.text]) {
            return YES;
        }
    }
 
    return NO;
}


- (NSDictionary *)getDeviceMaintainParam {
    
    NSString *startDate = [NSString stringWithFormat:@"%@ %@:00",_startDateTextField.text,_startTimeTextField.text];
    NSString *endDate = [NSString stringWithFormat:@"%@ %@:00",_endDateTextField.text,_endTimeTextField.text];
    NSMutableDictionary *dict = [@{@"userid" : @(self.baseUser.userid),
                                   @"type" : [NSObject changeType:self.baseUser.type],
                                   @"usertype" : [NSObject changeType:self.baseUser.usertype],
                                   @"projectid" : @(_projectID),
                                   @"deviceid" : @(_deviceID),
                                   @"sdate" : [NSObject changeType:startDate],
                                   @"edate" : [NSObject changeType:endDate],
                                   } mutableCopy];
    
    if (self.formType == DQEnumStateFixAdd) {
        NSDictionary *fixDict = @{@"warnid" : @(_warnID),
                                  @"text" : [NSObject changeType:_descTextField.text]
                                  };
        [dict addEntriesFromDictionary:fixDict];
    } else if (self.formType == DQEnumStateHeightAdd) {
        NSString *heightStr = _additionTextField.text;
        [dict addEntriesFromDictionary:@{@"high":@([heightStr integerValue])}];
    } else if (self.formType == DQEnumStateMaintainAdd) {
        [dict addEntriesFromDictionary:@{@"text":[NSObject changeType:_descTextField.text]}];
    }
    return dict;
}

    // 判断字符串为空和只为空格解决办法
- (BOOL)isBlankString:(NSString *)string {
    
    if (string == nil) {
        return YES;
    }
    if (string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
        return YES;
    }
    if ([string isEqualToString:@""]) {
        return YES;
    }
    return NO;
    
}

#pragma mark - Getter And Setter
- (NSArray *)titleAry {
    
    if (self.formType == DQEnumStateFixAdd) {
        return self.fixArray;
    }
    else if (self.formType == DQEnumStateHeightAdd) {
        return self.heightenArray;
    }
    else if (self.formType == DQEnumStateMaintainAdd) {
        return self.maintainArray;
    }
    return _titleAry;
}

- (NSArray *)heightenArray {
    if (!_heightenArray) {
        _heightenArray = @[@[@"此次我方加高对接人",@"加高高度(米)"],@[@"开始加高日期",@"开始加高时间",@"结束加高日期",@"结束加高时间"]];
    }
    return _heightenArray;
}

- (NSArray *)fixArray {
    if (!_fixArray) {
        _fixArray = @[@[@"此次我方维修对接人",@"选择故障",@""],@[@"开始维修日期",@"开始维修时间",@"结束维修日期",@"结束维修时间"]];
    }
    return _fixArray;
}

- (NSArray *)maintainArray {
    if (!_maintainArray) {
        _maintainArray = @[
                           @[@"此次我方维保对接人"],
                           @[@"开始维保日期",@"开始维保时间",@"结束维保日期",@"结束维保时间"],
                           @[@"维保内容",@"检查外笼门上的安全开关",@"打开吊笼单开门安全试验",@"打开外笼门及各个层门",@"打开吊笼天窗门",@"检查笼顶电控箱、电阻箱",@"检查防坠器",@"检查吊笼通道",@"检查电缆托架、保护架及挑线架",@"检查上、下限位、减速开关挑线架",@"打开吊笼双开门",@"按下急停按钮",@"触动短绳保护开关",@"检查变频器发热及电流",@"检查电缆",@"检查小齿轮、导轮、滚轮、附墙架、导轨架及标准节齿条",@"检查润滑部位、减速箱"]];
    }
    return _maintainArray;
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, screenWidth,
                                                                       screenHeight-64)];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = [UIColor colorWithHexString:COLOR_BG];
//        if (@available(iOS 11.0, *)) {
//            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//            _tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
//            _tableView.scrollIndicatorInsets = _tableView.contentInset;
//        }
    }
    return _tableView;
}

@end
