//
//  DQDeviceMaintainFinishFormController.m
//  WebThings
//
//  Created by Eugene on 10/18/17.
//  Copyright © 2017 machinsight. All rights reserved.
//

#import "DQDeviceMaintainFinishFormController.h"
#import "DQTextFieldArrowForCell.h" //
#import "BRDatePickerView.h" // 日期选择器
#import "DQPopupListView.h" // 错误弹出列表
#import "ChooseMaintainers.h" // 选择维保人员
#import "DQAddWorkUserController.h"
#import "DQBaseAPIInterface.h" // 上传图片

#import "DQDeviceMaintainPhotoBrowseCell.h" // 图片选择cell

#import "DeviceMaintainorderModel.h" // 设备维保Model
#import "WarningModel.h" // 故障列表model

#import "ZYKeyboardUtil.h" // 键盘处理
#define MARGIN_KEYBOARD 10

@interface DQDeviceMaintainFinishFormController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITextField *managerTextField;
@property (nonatomic, strong) UITextField *additionTextField;

@property (nonatomic, strong) UITextField *startDateTextField;
@property (nonatomic, strong) UITextField *startTimeTextField;
@property (nonatomic, strong) UITextField *endDateTextField;
@property (nonatomic, strong) UITextField *endTimeTextField;

@property (nonatomic, strong) UITextField *resultTextField;
@property (nonatomic, strong) UITextField *partsTextField;
@property (nonatomic, strong) UITextField *expendTextField;

@property (nonatomic, strong) ZYKeyboardUtil *keyboardUtil;

/** 项目、设备ID、表单ID */
@property (nonatomic, assign) NSInteger projectID;
@property (nonatomic, assign) NSInteger deviceID;
@property (nonatomic, assign) NSInteger orderID;

/** 设备维保单 */
@property (nonatomic, strong) DeviceMaintainorderModel *maintainOrderModel;

/** 二维数组 表单数据 */
@property (nonatomic, strong) NSArray *dataSource;

@property (nonatomic, strong) NSArray *titleAry;
/** 维修 */
@property (nonatomic, strong) NSArray *fixArray;
/** 加高 */
@property (nonatomic, strong) NSArray *heightenArray;
/** 维保 */
@property (nonatomic, strong) NSArray *maintainArray;
/** 整改 */
@property (nonatomic, strong) NSArray *reformArray;

/** 选择的图片集合 */
@property (nonatomic, strong) NSArray <UIImage *>*imageArray;

/** 故障列表 */
@property (nonatomic, strong) NSMutableArray <UserModel *>*workerArray;
@property (nonatomic, strong) UserModel *managerModel;
@property (nonatomic, copy) NSString *imagesString;

@end

@implementation DQDeviceMaintainFinishFormController

#pragma mark - Life Cycle
- (instancetype)initWithProjectID:(NSInteger)projectID deviceID:(NSInteger)deviceID orderID:(NSInteger)orderID {
    self = [super init];
    if (self) {
        _projectID = projectID;
        _deviceID = deviceID;
        _orderID = orderID;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initDeviceMaintainFormView];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInset = UIEdgeInsetsMake(0,0,0,0);
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)dealloc {
    
    self.resultTextField.delegate = nil;
    self.expendTextField.delegate = nil;
    self.partsTextField.delegate = nil;
}

- (void)initDeviceMaintainFormView {
    
    if (self.formType == DQEnumStateFixDoneAdd) {
        self.title = @"设备维修完成单";
    } else if (self.formType == DQEnumStateMaintainDoneAdd) {
        self.title = @"设备维保完成单";
    } else if (self.formType == DQEnumStateHeightenDoneAdd) {
        self.title = @"设备加高完成单";
    } else if (self.formType == DQEnumStateBusConFinishAdd) {
        self.title = @"整改完成单";
    }
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(onSubmitFormViewClicked) title:@"提交"];
    
    _workerArray = [[NSMutableArray alloc] init];
    _maintainOrderModel = [[DeviceMaintainorderModel alloc] init];
    _dataSource = [[NSMutableArray alloc] initWithArray:[self createDeviceMaintainFinishFormCell]];
    
    [self.view addSubview:self.tableView];
    
    [self configKeyBoardRespond];
}

- (void)configKeyBoardRespond {
    
    self.keyboardUtil = [[ZYKeyboardUtil alloc] initWithKeyboardTopMargin:MARGIN_KEYBOARD];
    __weak DQDeviceMaintainFinishFormController *weakSelf = self;
    
    [_keyboardUtil setAnimateWhenKeyboardAppearAutomaticAnimBlock:^(ZYKeyboardUtil *keyboardUtil) {
        [keyboardUtil adaptiveViewHandleWithController:weakSelf adaptiveView:weakSelf.tableView, nil];
    }];
    
    #pragma explain - 获取键盘信息
    [_keyboardUtil setPrintKeyboardInfoBlock:^(ZYKeyboardUtil *keyboardUtil, KeyboardInfo *keyboardInfo) {
        NSLog(@"\n\n拿到键盘信息 和 ZYKeyboardUtil对象");
    }];
}


/** 根据不同区 展示不同的cell 并存储到数组中 */
- (NSArray *)createDeviceMaintainFinishFormCell {
    
    /** 人员 */
    DQTextFieldArrowForCell *managerCell = [[DQTextFieldArrowForCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"managerCellIdentifier"];
    [self configArrowTableViewCellArrowStyleWithCell:managerCell];
    //managerCell.rightField.text = self.baseUser.name;
    _managerTextField = managerCell.rightField;

    DQTextFieldArrowForCell *memberCell = [[DQTextFieldArrowForCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"memberCellIdentifier"];
    [self configArrowTableViewCellArrowStyleWithCell:memberCell];
   // memberCell.rightField.text = self.baseUser.name;
    _additionTextField = memberCell.rightField;

   /** 日期和时间 */
    DQTextFieldArrowForCell *startDateCell = [[DQTextFieldArrowForCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"startDateCellIdentifier"];
    [self configArrowTableViewCellArrowStyleWithCell:startDateCell];
    _startDateTextField = startDateCell.rightField;

    DQTextFieldArrowForCell *startTimeCell = [[DQTextFieldArrowForCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"startTimeCellIdentifier"];
    [self configArrowTableViewCellArrowStyleWithCell:startTimeCell];
    _startTimeTextField = startTimeCell.rightField;

    DQTextFieldArrowForCell *endDateCell = [[DQTextFieldArrowForCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"endDateCellIdentifier"];
    [self configArrowTableViewCellArrowStyleWithCell:endDateCell];
    _endDateTextField = endDateCell.rightField;

    DQTextFieldArrowForCell *endTimeCell = [[DQTextFieldArrowForCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"endTimeCellIdentifier"];
    [self configArrowTableViewCellArrowStyleWithCell:endTimeCell];
    _endTimeTextField = endTimeCell.rightField;

    /** 结果集 */
    DQTextFieldArrowForCell *resultCell = [[DQTextFieldArrowForCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"resultCellIdentifier"];
    [self configTableViewCellStyleWithCell:resultCell];
    _resultTextField = resultCell.rightField;
    _resultTextField.delegate = self;
    
    DQTextFieldArrowForCell *expendCell = [[DQTextFieldArrowForCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"expendCellIdentifier"];
    [self configTableViewCellStyleWithCell:expendCell];
    _expendTextField = expendCell.rightField;
    _expendTextField.delegate = self;
    
    DQTextFieldArrowForCell *partsCell = [[DQTextFieldArrowForCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"partsCellIdentifier"];
    [self configTableViewCellStyleWithCell:partsCell];
    _partsTextField = partsCell.rightField;
    _partsTextField.delegate = self;

    // 图片
    DQDeviceMaintainPhotoBrowseCell *photoBrowseCell = [[DQDeviceMaintainPhotoBrowseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"photoBrowseCellIdentifier"];
    
    if (self.formType == DQEnumStateFixDoneAdd) {
        return @[@[managerCell,memberCell],
                 @[startDateCell,startTimeCell,endDateCell,endTimeCell],
                 @[resultCell,expendCell,partsCell],
                 @[photoBrowseCell],
                 ];
    }
    else if (self.formType == DQEnumStateHeightenDoneAdd) {
        return @[@[managerCell,memberCell],
                 @[startDateCell,startTimeCell,endDateCell,endTimeCell],
                 @[resultCell,expendCell,partsCell],
                 @[photoBrowseCell],
                 ];
    }
    else if (self.formType == DQEnumStateMaintainDoneAdd) {
        return @[@[managerCell,memberCell],
                 @[startDateCell,startTimeCell,endDateCell,endTimeCell],
                 @[resultCell,expendCell,partsCell],
                 @[photoBrowseCell],
                 @[]
                 ];
    }
    else if (self.formType == DQEnumStateBusConFinishAdd) { // 整改完成单
        return @[@[managerCell,memberCell],
                 @[startDateCell,startTimeCell,endDateCell,endTimeCell],
                 @[resultCell,expendCell,partsCell],
                 @[photoBrowseCell],
                 ];
    }
    return @[];
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

- (void)configArrowTableViewCellArrowStyleWithCell:(DQTextFieldArrowForCell *)cell {
    
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

// 去掉UItableview headerview黏性(sticky) 及放弃textField的第一响应
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self endEditingView];
   
    if (scrollView == self.tableView) {
        
        CGFloat sectionHeaderHeight = 10;
        if (scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y >= 0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        }
        else if (scrollView.contentOffset.y >= sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}

- (void)endEditingView {
    [_expendTextField resignFirstResponder];
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
    CGFloat imageBrowseHeight = (_imageArray.count > 0 && _imageArray != nil) ? 285 : 100;
    CGFloat height = (indexPath.section == 4) ? ((indexPath.row == 0) ? 50 : 44) : 50;
    return indexPath.section == 3 ? imageBrowseHeight : height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *ary = _dataSource[indexPath.section];
    if (indexPath.section == 3) {
        DQDeviceMaintainPhotoBrowseCell *cell = [ary safeObjectAtIndex:indexPath.row];
        cell.reloadCellBlock = ^(NSArray *images){
            _imageArray = images;
            [_tableView reloadData];
        };
        return cell;
    } else if (indexPath.section == 4) {
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
    }  else {
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

    [_workerArray removeAllObjects];
    
        //跳转选择工作人员列表
    if (indexPath.row == 0) {
        DQAddWorkUserController *workerView = [[DQAddWorkUserController alloc] init];
        workerView.projectID = _projectID;
        workerView.type = KDQAddWorkUserRadioStyle;
        __weak typeof(self) weakSelf = self;
        workerView.userDataBlock = ^(NSMutableArray *userList) {
            //回调人员数据  userModel
            DQLog(@"负责人 ： %@",userList);
            if (userList.count > 0) {
                weakSelf.managerModel = [userList firstObject];
                NSMutableArray *nameAry = [NSMutableArray new];
                for (UserModel *user in userList) {
                    [nameAry addObject:[NSObject changeType:user.name]];
                }
                NSString *nameString = [nameAry componentsJoinedByString:@","];
                weakSelf.managerTextField.text = nameString;
            }
        };
        [self.navigationController pushViewController:workerView animated:YES];
    } else if (indexPath.row == 1) {
        DQAddWorkUserController *workerView = [[DQAddWorkUserController alloc] init];
        workerView.projectID = _projectID;
        workerView.type = KDQAddWorkUserManyStyle;
        __weak typeof(self) weakSelf = self;
        workerView.userDataBlock = ^(NSMutableArray *userList) {
            //回调人员数据  userModel
            DQLog(@"工作人员列表 ： %@",userList);
            weakSelf.workerArray = userList;
            
            NSMutableArray *nameAry = [NSMutableArray new];
            for (UserModel *user in userList) {
                [nameAry addObject:[NSObject changeType:user.name]];
            }
            NSString *nameString = [nameAry componentsJoinedByString:@","];
            weakSelf.additionTextField.text = nameString;
        };
        [self.navigationController pushViewController:workerView animated:YES];
    }
}

#pragma mark - Actions
- (void)onSubmitFormViewClicked {
    
    if ([self checkParamsError]) {
        [self showAlertWithTitle:@"您的表单未填写完成！"];
        return;
    }
    
    /** 上传图片成功后、提交完成表单 */
    [self uploadImageHttp];
}

#pragma mark - HTTP
/** 上传图片成功后、提交完成表单 */
- (void)uploadImageHttp {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak typeof(self) weakSelf = self;
    [[DQBaseAPIInterface sharedInstance]
     dq_uploadImage:self.imageArray
     progress:^(CGFloat percent) {

     } success:^(DQResultModel *returnValue) {
         if ([returnValue isRequestSuccess]) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             
            // 整改完成单、把参数传递出去并由发起地点发起整改完成单网络请求
             if (self.formType == DQEnumStateBusConFinishAdd) {
                 weakSelf.imagesString = [returnValue.imgpath componentsJoinedByString:@","];
                 NSMutableDictionary *param = [self getDeviceMaintainParam];
                 [param addEntriesFromDictionary:@{@"businessid":@(_orderID)}];
                 weakSelf.submitRequestBlock(param);
             } else {
                 [self postMaintainFinishFormHttp];
             }
             
            [self requestNetSuccess];
         } else {
             [weakSelf showAlertWithTitle:@"图片上传失败"];
         }

     } failture:^(NSError *error) {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         [weakSelf showAlertWithTitle:@"图片上传失败"];
     }];
}

/** 发送维保单完成单网络请求 */
- (void)postMaintainFinishFormHttp {
    
    NSMutableDictionary *param = [self getDeviceMaintainParam];
    
    if (self.formType == DQEnumStateHeightenDoneAdd) {
        [param addEntriesFromDictionary:@{@"highid":@(_orderID)}];
    } else {
        [param addEntriesFromDictionary:@{@"orderid":@(_orderID)}];
    }
    [[DQServiceInterface sharedInstance] dq_addMaintenceFinishOrderWithType:self.formType params:param success:^(id result) {
        DQLog(@"result: %@",result);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (result != nil) {
            [self showAlertWithTitle:@"添加成功"];
        }
    } failture:^(NSError *error) {
        DQLog(@"error: %@",error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

#pragma mark - Private Methods
/** 表单成功后pop出当前页面*/
- (void)requestNetSuccess {
    
    [self showAlertWithTitle:@"添加成功"];
    [self.navigationController popViewControllerAnimated:YES];
    if (self.basedelegate && [self.basedelegate respondsToSelector:@selector(didPopFromNextVC)]) {
        [self.basedelegate didPopFromNextVC];
    };
}

- (void)showAlertWithTitle:(NSString *)title {
    NSString *text = [NSString stringWithFormat:@"%@",title];
    MDSnackbar *alert = [[MDSnackbar alloc] initWithText:text  actionTitle:@"" duration:3.0];
    [alert show];
}

/** 参数检测，过滤未输入参数 */
- (BOOL)checkParamsError {
    
    if ([self isBlankString:_managerTextField.text] || [self isBlankString:_additionTextField.text] || [self isBlankString:_startDateTextField.text] || [self isBlankString:_startTimeTextField.text] || [self isBlankString:_endDateTextField.text] || [self isBlankString:_endTimeTextField.text] || [self isBlankString:_resultTextField.text] || [self isBlankString:_partsTextField.text] || [self isBlankString:_expendTextField.text] || self.imageArray.count == 0) {
        return YES;
    }
    return NO;
}

- (NSMutableDictionary *)getDeviceMaintainParam {
    
    // @"orderid" : @(_orderID),// 维修、维保、加高完成单是orderid，整改完成单是businessid
    NSMutableDictionary *managerDict = _managerModel.mj_keyValues;
    NSMutableArray *workerAry = [UserModel mj_keyValuesArrayWithObjectArray:_workerArray];
    NSString *startDate = [NSString stringWithFormat:@"%@ %@:00",_startDateTextField.text,_startTimeTextField.text];
    NSString *endDate = [NSString stringWithFormat:@"%@ %@:00",_endDateTextField.text,_endTimeTextField.text];
    NSMutableDictionary *dict = [@{@"userid" : @(self.baseUser.userid),
                                   @"type" : [NSObject changeType:self.baseUser.type],
                                   @"usertype" : [NSObject changeType:self.baseUser.usertype],
                                   @"projectid" : @(_projectID),
                                   @"deviceid" : @(_deviceID),
                                   @"start" : [NSObject changeType:startDate],
                                   @"end" : [NSObject changeType:endDate],
                                   @"result": [NSObject changeType:_resultTextField.text],
                                   @"expend": [NSObject changeType:_expendTextField.text],
                                   @"des": [NSObject changeType:_partsTextField.text],
                                   @"imgs": self.imagesString,// 图片地址，多图片时字符串 逗号 拼接
                                   @"manager": managerDict,
                                   @"workers": workerAry,
                                   } mutableCopy];
    
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
    
    if (self.formType == DQEnumStateFixDoneAdd) {
        return self.fixArray;
    }
    else if (self.formType == DQEnumStateHeightenDoneAdd) {
        return self.heightenArray;
    }
    else if (self.formType == DQEnumStateMaintainDoneAdd) {
        return self.maintainArray;
    }
    else if (self.formType == DQEnumStateBusConFinishAdd) {
        return self.reformArray;
    }
    //return _titleAry;
    return self.reformArray;
}

- (NSArray *)heightenArray {
    if (!_heightenArray) {
        _heightenArray = @[@[@"加高负责人",@"加高人员"],
                           @[@"开始加高日期",@"开始加高时间",@"结束加高日期",@"结束加高时间"],
                           @[@"加高结果",@"配件消耗",@"加高说明"],
                           @[@""]
                           ];
    }
    return _heightenArray;
}

- (NSArray *)reformArray {
    if (!_reformArray) {
        _reformArray = @[@[@"整改负责人",@"整改人员"],
                           @[@"开始整改日期",@"开始整改时间",@"结束整改日期",@"结束整改时间"],
                           @[@"整改结果",@"配件消耗",@"整改说明"],
                           @[@""]
                           ];
    }
    return _reformArray;
}

- (NSArray *)fixArray {
    if (!_fixArray) {
        _fixArray = @[@[@"维修负责人",@"选择故障"],
                      @[@"开始维修日期",@"开始维修时间",@"结束维修日期",@"结束维修时间"],
                      @[@"维修结果",@"配件消耗",@"维修说明"],
                      @[@""]
                      ];
    }
    return _fixArray;
}

- (NSArray *)maintainArray {
    if (!_maintainArray) {
        _maintainArray = @[@[@"维保负责人",@"维保人员"],
                           @[@"开始维保日期",@"开始维保时间",@"结束维保日期",@"结束维保时间"],
                           @[@"维保结果",@"配件消耗",@"维保说明"],
                           @[@""],
                           @[@"维保内容",@"检查外笼门上的安全开关",@"打开吊笼单开门安全试验",@"打开外笼门及各个层门",@"打开吊笼天窗门",@"检查笼顶电控箱、电阻箱",@"检查防坠器",@"检查吊笼通道",@"检查电缆托架、保护架及挑线架",@"检查上、下限位、减速开关挑线架",@"打开吊笼双开门",@"按下急停按钮",@"触动短绳保护开关",@"检查变频器发热及电流",@"检查电缆",@"检查小齿轮、导轮、滚轮、附墙架、导轨架及标准节齿条",@"检查润滑部位、减速箱"]
                           ];
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
 
        if (@available(iOS 11.0, *)) {
//            _tableView.estimatedRowHeight = 0;
//            _tableView.estimatedSectionHeaderHeight = 0;
//            _tableView.estimatedSectionFooterHeight = 0;
//            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//            _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
//            _tableView.scrollIndicatorInsets = _tableView.contentInset;
        }
    }
    return _tableView;
}

@end
