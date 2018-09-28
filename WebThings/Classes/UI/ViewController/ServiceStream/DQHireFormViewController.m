//
//  DQHireFormViewController.m
//  WebThings
//
//  Created by Eugene on 10/23/17.
//  Copyright © 2017 machinsight. All rights reserved.
//

#import "DQHireFormViewController.h"
#import "DQTextFiledInfoCell.h"
#import "DQTextFieldArrowForCell.h"
#import "BRDatePickerView.h" // 日期选择器
#import "WTScrollViewKeyboardManager.h"

@interface DQHireFormViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITextField *managerTextField;/** 负责人 */
@property (nonatomic, strong) UITextField *addressTextField;/** 地址 */

@property (nonatomic, strong) UITextField *startDateTextField;/** 日期 */
@property (nonatomic, strong) UITextField *startTimeTextField;
@property (nonatomic, strong) UITextField *numberTextField;/** 备案号 */
@property (nonatomic, strong) UITextField *unitTextField;/** 检测单位 */
@property (nonatomic, strong) UITextField *reportNumTextField;/** 报告编号 */

@property (nonatomic, strong) NSArray *dataSource;

@property (nonatomic, strong) NSArray *titleAry;
/** 新增、维修起租单 */
@property (nonatomic, strong) NSArray *rentAry;
/** 停租单 */
@property (nonatomic, strong) NSArray *rentOffAry;

@end

@implementation DQHireFormViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initRentDateFormView];
}

- (void)initRentDateFormView {
    
    if (self.rentFormStyle == DQEnumStateRentAdd || self.rentFormStyle == DQEnumStateRentModify) {
        self.title = @"设备启租单";
    }
    else if (self.rentFormStyle == DQEnumStateRemoveAdd) {
        self.title = @"停租单";
    }
    
    [self.view addSubview:self.tableView];
    
    _dataSource = [[NSMutableArray alloc] initWithArray:[self createRentFormCell]];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(onSubmitRentFormViewClicked) title:@"提交"];
}

- (NSArray *)createRentFormCell {
    
    ProjectStartRentHistoryModel *rentHistory = _portalModel.projectstartrenthistory;

    /** 负责人 */
    DQTextFieldArrowForCell *managerCell = [[DQTextFieldArrowForCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"managerCellIdentifier"];
    [self configArrowTableViewCellArrowStyleWithCell:managerCell];
    managerCell.rightField.text = [NSObject changeType:self.baseUser.name];
    managerCell.arrowImageName = nil;
    _managerTextField = managerCell.rightField;
    
    /** 地点 */
    DQTextFieldArrowForCell *addressCell = [[DQTextFieldArrowForCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"addressCellIdentifier"];
    [self configArrowTableViewCellArrowStyleWithCell:addressCell];
    addressCell.rightField.text = [NSObject changeType:_dm.installationsite];
    addressCell.arrowImageName = nil;
    _addressTextField = addressCell.rightField;
    
    /** 起租日期 */
    DQTextFieldArrowForCell *startDateCell = [[DQTextFieldArrowForCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"startDateCellIdentifier"];
    [self configArrowTableViewCellArrowStyleWithCell:startDateCell];
    startDateCell.rightField.text = [NSObject changeType:_portalModel.projectstartrenthistory.startdate];
    _startDateTextField = startDateCell.rightField;
    
    DQTextFieldArrowForCell *startTimeCell = [[DQTextFieldArrowForCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"startTimeCellIdentifier"];
    [self configArrowTableViewCellArrowStyleWithCell:startTimeCell];
    _startTimeTextField = startTimeCell.rightField;
    
    /** 产权备案号 */
    DQTextFieldArrowForCell *numberCell = [[DQTextFieldArrowForCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"numberCellIdentifier"];
    [self configTableViewCellStyleWithCell:numberCell];
    numberCell.rightField.text = [NSObject changeType:_portalModel.projectstartrenthistory.recordno];
    _numberTextField = numberCell.rightField;
    
    /** 检测单位 */
    DQTextFieldArrowForCell *unitCell = [[DQTextFieldArrowForCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"unitCellIdentifier"];
    [self configTableViewCellStyleWithCell:unitCell];
    unitCell.rightField.text = [NSObject changeType:_portalModel.projectstartrenthistory.checkcompany];
    _unitTextField = unitCell.rightField;
    
    /** 检测报告编号 */
    DQTextFieldArrowForCell *reportNumberCell = [[DQTextFieldArrowForCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reportNumberCellIdentifier"];
    [self configTableViewCellStyleWithCell:reportNumberCell];
    reportNumberCell.rightField.text = [NSObject changeType:_portalModel.projectstartrenthistory.chckreportid];
    _reportNumTextField = reportNumberCell.rightField;
    
    if (self.rentFormStyle == DQEnumStateRentAdd || self.rentFormStyle == DQEnumStateRentModify) {
        _titleAry = @[@[@"项目负责人"],@[@"安装地点",@"启租日期"],@[@"产权备案号",@"检测单位",@"检测报告编号"]];
        return @[@[managerCell],@[addressCell,startDateCell],@[numberCell,unitCell,reportNumberCell]];
    }
    else if (self.rentFormStyle == DQEnumStateRemoveAdd) {
        _titleAry = @[@[@"项目负责人"],@[@"拆除地点",@"拆机日期",@"拆机时间"]];
        return @[@[managerCell],@[addressCell,startDateCell,startTimeCell]];
    }
    return @[];
}

- (void)configArrowTableViewCellArrowStyleWithCell:(DQTextFieldArrowForCell *)cell {
    
    cell.configLeftTitleColor = @"#1D1D1D";
    cell.configLeftFont = [UIFont dq_regularSystemFontOfSize:14.0];
    cell.rightField.font = [UIFont dq_regularSystemFontOfSize:14.0];
    cell.rightField.textColor = [UIColor colorWithHexString:@"#707070"];
    cell.rightField.enabled = NO;
}

- (void)configTableViewCellStyleWithCell:(DQTextFieldArrowForCell *)cell {
    
    cell.configLeftTitleColor = @"#1D1D1D";
    cell.configLeftFont = [UIFont dq_regularSystemFontOfSize:14.0];
    cell.rightField.font = [UIFont dq_regularSystemFontOfSize:14.0];
    cell.rightField.textColor = [UIColor colorWithHexString:@"#707070"];
    cell.rightField.enabled = YES;
    cell.rightField.delegate = self;
    cell.arrowImageName = nil;
    cell.configPlaceholder = @"请输入";
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self endEditingView];
    
//    CGFloat sectionHeaderHeight = 8;
//    if (scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y >= 0) {
//        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
//    } else if (scrollView.contentOffset.y >= sectionHeaderHeight) {
//        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
//    }
}

- (void)endEditingView {
    [self.view resignFirstResponder];
}

#pragma mark - Delegate And DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *ary = _dataSource[section];
    return ary.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *ary = _dataSource[indexPath.section];
    DQTextFieldArrowForCell *cell = [ary safeObjectAtIndex:indexPath.row];
    NSArray *titles = self.titleAry[indexPath.section];
    cell.configLeftName = titles[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self endEditingView];
    
    NSArray *ary = _dataSource[indexPath.section];
    DQTextFieldArrowForCell *cell = [ary safeObjectAtIndex:indexPath.row];
    DQTextFieldArrowForCell *previousCell = [ary safeObjectAtIndex:indexPath.row>0 ? indexPath.row-1: indexPath.row];
    
    if (indexPath.section == 0) {
        [self didSelectRowAtIndexPath:indexPath];
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            
        } else {
            
            [_startDateTextField resignFirstResponder];
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
            UIDatePickerMode pickerMode = (indexPath.row % 2 == 0) ? UIDatePickerModeTime : UIDatePickerModeDate;
            [BRDatePickerView showDatePickerWithTitle:title dateType:pickerMode defaultSelValue:nil minDateStr:miniDateStr maxDateStr:nil isAutoSelect:false resultBlock:^(NSString *selectValue) {
                cell.rightField.text = selectValue;
            }];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 8;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 8)];
    view.backgroundColor = [UIColor colorWithHexString:COLOR_BG];
    return view;
}

- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - Actions
- (void)onSubmitRentFormViewClicked {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if (self.rentFormStyle == DQEnumStateRentAdd) {
        [self postNewRentFormHttp];
    }
    else if (self.rentFormStyle == DQEnumStateRentModify) {
        [self postModifyRentFormHttp];
    }
    else if (self.rentFormStyle == DQEnumStateRemoveAdd) {
        [self postStopRentFormHttp];
    }
}

#pragma mark - HTTP
/** 添加新启租单网络请求*/
- (void)postNewRentFormHttp {
    if ([self isBlankString:_managerTextField.text] || [self isBlankString:_addressTextField.text] || [self isBlankString:_startDateTextField.text] || [self isBlankString:_numberTextField.text] || [self isBlankString:_reportNumTextField.text] || [self isBlankString:_unitTextField.text]) {
        [self alertWithTitle:@"您的表单未填写完成！"];
        return;
    }
    NSDictionary *dict = [self getRentFormParam];
    [self postRentFormWithParams:dict rentFormType:DQEnumStateRentAdd];
}

/** 修改启租单网络请求 */
- (void)postModifyRentFormHttp {
    
    if ([self isBlankString:_managerTextField.text] || [self isBlankString:_addressTextField.text] || [self isBlankString:_startDateTextField.text] || [self isBlankString:_numberTextField.text] || [self isBlankString:_reportNumTextField.text] || [self isBlankString:_unitTextField.text]) {
        [self alertWithTitle:@"您的表单未填写完成！"];
        return;
    }
    
    NSDictionary *dict = [self getRentFormParam];
    [self postRentFormWithParams:dict rentFormType:DQEnumStateRentModify];
}

/** 停租单网络请求 */
- (void)postStopRentFormHttp {
    
    if ([self isBlankString:_managerTextField.text] || [self isBlankString:_addressTextField.text] || [self isBlankString:_startDateTextField.text] || [self isBlankString:_startTimeTextField.text] ) {
        [self alertWithTitle:@"您的表单未填写完成！"];
        return;
    }
    
    NSDictionary *dict = [self getRentFormParam];
    [self postRentFormWithParams:dict rentFormType:DQEnumStateRemoveAdd];
}

- (void)postRentFormWithParams:(NSDictionary *)params rentFormType:(DQEnumState)type {
    
    [[DQServiceInterface sharedInstance] dq_getRentFormOrder:params rentFormType:type success:^(id result) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (result != nil) {
            MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"添加成功" actionTitle:@"" duration:1.5];
            [t show];
            [self.navigationController popViewControllerAnimated:YES];
            if (self.basedelegate && [self.basedelegate respondsToSelector:@selector(didPopFromNextVC)]) {
                [self.basedelegate didPopFromNextVC];
            };
        }
    } failture:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

#pragma mark - Getter And Setter
- (NSArray *)titleAry {
    
    if (self.rentFormStyle == DQEnumStateRentAdd || self.rentFormStyle == DQEnumStateRentModify) {
        _titleAry = @[@[@"项目负责人"],@[@"安装地点",@"启租日期"],@[@"产权备案号",@"检测单位",@"检测报告编号"]];
    }
    else if (self.rentFormStyle == DQEnumStateRemoveAdd) {
        _titleAry = @[@[@"项目负责人"],@[@"拆除地点",@"拆机日期",@"拆机时间"]];
    }
    return _titleAry;
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth,
                                                                   screenHeight)];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = [UIColor colorWithHexString:COLOR_BG];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
            _tableView.scrollIndicatorInsets = _tableView.contentInset;
        }
    }
    return _tableView;
}

#pragma mark - Private Methods
- (void)alertWithTitle:(NSString *)title {
    NSString *text = [NSString stringWithFormat:@"%@",title];
    MDSnackbar *alert = [[MDSnackbar alloc] initWithText:text  actionTitle:@"" duration:3.0];
    [alert show];
}

- (NSMutableDictionary *)getRentFormParam {

    NSMutableDictionary *dict = [@{@"userid" : @(self.baseUser.userid),
                                   @"type" : [NSObject changeType:self.baseUser.type],
                                   @"usertype" : [NSObject changeType:self.baseUser.usertype],
                                   @"projectid" : @(_projectid),
                                   @"deviceid" : @(_dm.deviceid)
                                   } mutableCopy];
    
    if (self.rentFormStyle == DQEnumStateRentAdd) {
        NSString *newDateStr = [NSString stringWithFormat:@"%@ 07:23:00",_startDateTextField.text];
        NSDictionary *newDict = @{@"startdate" : [NSObject changeType:newDateStr],
                                  @"recordno" : [NSObject changeType:_numberTextField.text],
                                  @"checkcompany" : [NSObject changeType:_unitTextField.text],
                                  @"chckreportid" : [NSObject changeType:_reportNumTextField.text]
                                  };
        [dict addEntriesFromDictionary:newDict];
    } else if (self.rentFormStyle == DQEnumStateRentModify) {
        NSString *startDateStr = [NSString stringWithFormat:@"%@ 07:23:00",_startDateTextField.text];
        NSDictionary *editDict = @{@"startdate" : [NSObject changeType:startDateStr],
                                   @"recordno" : [NSObject changeType:_numberTextField.text],
                                   @"checkcompany" : [NSObject changeType:_unitTextField.text],
                                   @"chckreportid" : [NSObject changeType:_reportNumTextField.text],
                                   @"pid":@(_portalModel.projectstartrenthistory.projectstartrentid)
                                   };
        [dict addEntriesFromDictionary:editDict];
    } else if (self.rentFormStyle == DQEnumStateRemoveAdd) {
        NSString *startDate = [NSString stringWithFormat:@"%@ %@:00",_startDateTextField.text,_startTimeTextField.text];
        [dict addEntriesFromDictionary:@{@"cdate" : startDate}];
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

@end
