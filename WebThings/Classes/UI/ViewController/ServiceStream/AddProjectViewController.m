//
//  AddProjectViewController.m
//  WebThings
//
//  Created by machinsight on 2017/6/13.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "AddProjectViewController.h"
#import "DQTextFiledInfoCell.h"
#import "DQTextFieldArrowForCell.h"
#import "NewDeviceScrollView.h"
#import "NewProjectScrollView.h"
#import "BRDatePickerView.h"
#import "CK_ID_NameModel.h"
#import "UserModel.h"

#import "ModifyProjectWI.h"
#import "AddProjectWI.h"

@interface AddProjectViewController ()
<UITableViewDelegate,
UITableViewDataSource,
NewDeviceScrollViewDelegate,
NewProjectScrollViewDelegate>
{
    CGFloat _offY;
    NSString *_minDate;
    NSString *_maxDate;
    NSString *_deviceTitle;
    NSMutableArray *_dataListArr;
}
@property (nonatomic, strong) UITableView *mTableView;
@property (nonatomic, strong) NSMutableArray *details;//设备品牌型号
@property (nonatomic, strong) NewDeviceScrollView *leaseAlertView;/**< 承租方 弹出框*/
@property (nonatomic, strong) NewDeviceScrollView *projectMangerAlertView;/**< 项目经理 弹出框*/
@property (nonatomic, strong) NewProjectScrollView *pdxhAlertV;/**< 选择设备品牌及型号 弹出框*/
@property (nonatomic, assign) NSInteger czfid;//出租方id
@property (nonatomic, assign) NSInteger czfPMID;
@property (nonatomic, assign) NSInteger cid;

@end

@implementation AddProjectViewController

#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configView];
    //获取承租方
    [self fetchCZF];
    //请求品牌型号
    [self fetchBrandModel];
}

- (void)configView
{
    switch (_isNew) {
        case 0:{
            self.title = @"新增项目";
            self.czfid = self.baseUser.orgid;
            break;
        }
        default:
            self.title = @"修改项目";
            break;
    }
    UIBarButtonItem *rightNav = [UIBarButtonItem itemWithTarget:self action:@selector(onSubmitClicked) title:@"提交"];
    self.navigationItem.rightBarButtonItem = rightNav;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(popAddProjectViewController) image:[UIImage imageNamed:@"back"]];
    _minDate = nil;
    _maxDate = nil;
    _deviceTitle = nil;
    
    _dataListArr = [NSMutableArray arrayWithArray:[self createAddNewProjectCell]];
    _mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, screenWidth, screenHeight-64) style:UITableViewStylePlain];
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
    
    _leaseAlertView = [[NewDeviceScrollView alloc] initWithFrame:CGRectMake(0, 208, screenWidth, 223)];
    _leaseAlertView.tag = 6688;
    _leaseAlertView.delegate = self;
    _leaseAlertView.hidden = true;
    [_mTableView addSubview:_leaseAlertView];
    
    _projectMangerAlertView = [[NewDeviceScrollView alloc] initWithFrame:CGRectMake(0, 258, self.view.width, 223)];
    _projectMangerAlertView.tag = 5000;
    _projectMangerAlertView.delegate = self;
    _projectMangerAlertView.hidden = true;
    [_mTableView addSubview:_projectMangerAlertView];

    //选择品牌及型号弹出框
    _pdxhAlertV = [[NewProjectScrollView alloc] initWithFrame:CGRectMake(0, 474, self.view.width, 223)];
    _pdxhAlertV.delegate = self;
    _pdxhAlertV.hidden = true;
    [_mTableView addSubview:_pdxhAlertV];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
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

- (void)keyboardWillShow:(NSNotification *)note
{
    //获取键盘的高度
    NSDictionary *userInfo = [note userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [value CGRectValue];
    int KeyBoradHeight = keyboardRect.size.height;
    self.mTableView.height = screenHeight-KeyBoradHeight-64;
}

- (void)keyboardWillHide:(NSNotification *)note
{
    self.mTableView.height = screenHeight-64;
    [self.mTableView setContentOffset:CGPointMake(0, 0) animated:false];
}

- (void)onSubmitClicked
{
    DQTextFiledInfoCell *projectNameCell = [_dataListArr safeObjectAtIndex:1];
    DQTextFiledInfoCell *orderNumberCell = [_dataListArr safeObjectAtIndex:2];
    DQTextFiledInfoCell *czfCell = [_dataListArr safeObjectAtIndex:4];
    DQTextFieldArrowForCell *leaseCell = [_dataListArr safeObjectAtIndex:5];
    DQTextFieldArrowForCell *leasePMCell = [_dataListArr safeObjectAtIndex:6];
    DQTextFiledInfoCell *addressCell = [_dataListArr safeObjectAtIndex:8];
    DQTextFiledInfoCell *companyCell = [_dataListArr safeObjectAtIndex:9];
    DQTextFiledInfoCell *unitCell = [_dataListArr safeObjectAtIndex:10];
    DQTextFieldArrowForCell *deviceXHCell = [_dataListArr safeObjectAtIndex:12];
    DQTextFiledInfoCell *rentCell = [_dataListArr safeObjectAtIndex:14];
    DQTextFiledInfoCell *exitFeeCell = [_dataListArr safeObjectAtIndex:15];
    DQTextFieldArrowForCell *expectedCell = [_dataListArr safeObjectAtIndex:17];
    DQTextFieldArrowForCell *goAwayCell = [_dataListArr safeObjectAtIndex:18];
    if (!projectNameCell.rightField.text.length || !orderNumberCell.rightField.text.length || !czfCell.rightField.text.length || !leaseCell.rightField.text.length || !leasePMCell.rightField.text.length || !addressCell.rightField.text.length || !companyCell.rightField.text.length || !unitCell.rightField.text.length || !deviceXHCell.rightField.text.length || !rentCell.rightField.text.length || !exitFeeCell.rightField.text.length || !expectedCell.rightField.text.length || !goAwayCell.rightField.text.length ) {
        MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"请填写完整信息" actionTitle:@"" duration:3.0];
        [t show];
        return;
    }
    
    switch (_isNew) {
        case 0: { //新增项目
            AddProjectModel *addm = [[AddProjectModel alloc] init];
            addm.userid = self.baseUser.userid;
            addm.type = self.baseUser.type;
            addm.projectname = [NSString stringWithFormat:@"%@",projectNameCell.rightField.text];
            addm.no = [NSString stringWithFormat:@"%@",orderNumberCell.rightField.text];
            addm.needorgname = [NSString stringWithFormat:@"%@",leaseCell.rightField.text];
            addm.needorgid = self.cid;
            addm.provideorgid = self.czfid;
            addm.projectaddress = [NSString stringWithFormat:@"%@",addressCell.rightField.text];
            addm.contractor = [NSString stringWithFormat:@"%@",companyCell.rightField.text];
            addm.supervisor = [NSString stringWithFormat:@"%@",unitCell.rightField.text];
            addm.detail = _details;
            addm.devicenum = self.details.count;
            addm.rent = [rentCell.rightField.text doubleValue];
            addm.intoutprice = [exitFeeCell.rightField.text doubleValue];
            addm.drivertype = @"";
            addm.drivers = @[];
            addm.indate = [NSString stringWithFormat:@"%@",expectedCell.rightField.text];
            addm.outdate = [NSString stringWithFormat:@"%@",goAwayCell.rightField.text];
            addm.note = @"";
            addm.usertype = self.baseUser.usertype;
            addm.pmid = _czfPMID;
            addm.pmname = [NSString stringWithFormat:@"%@",leasePMCell.rightField.text];
            [self fetchAddProject:addm];
        } break;
        default: //修改项目
            [self fetchEditProject];
            break;
    }
}

/**
 获取承租方
 */
- (void)fetchCZF
{
    NSDictionary *dic = @{@"userid":@(self.baseUser.userid),@"type":self.baseUser.type,@"usertype":self.baseUser.usertype};
    [[DQServiceInterface sharedInstance] dq_getNeedOrgList:dic success:^(id result) {
        if (result != nil) {
            [self.leaseAlertView setData:result];
        }
    } failture:^(NSError *error) {
    }];
}

/**
 请求品牌型号
 */
- (void)fetchBrandModel
{
    [[DQServiceInterface sharedInstance] dq_getBrandDeviceProject:1
        success:^(id result) {
        if (result != nil) {
            
            [self.pdxhAlertV setDataArr:result];
        }
    } failture:^(NSError *error) {
    }];
}

/**
 新增项目
 */
- (void)fetchAddProject:(AddProjectModel *)model
{
    [[DQBusinessInterface sharedInstance] dq_getAddProject:model success:^(id result) {
        if (result) {
            self.newProjectId = [result integerValue];
            [self.navigationController popViewControllerAnimated:YES];
            if (self.basedelegate && [self.basedelegate respondsToSelector:@selector(didPopFromNextVC)]) {
                [self.basedelegate didPopFromNextVC];
            }
        }
    } failture:^(NSError *error) {

    }];
}

/**
 修改项目
 */
- (void)fetchEditProject
{
    DQTextFiledInfoCell *projectNameCell = [_dataListArr safeObjectAtIndex:1];
    DQTextFiledInfoCell *orderNumberCell = [_dataListArr safeObjectAtIndex:2];
//    DQTextFiledInfoCell *lessorCell = [_dataListArr safeObjectAtIndex:3];
//    DQTextFieldArrowForCell *leaseCell = [_dataListArr safeObjectAtIndex:4];
    DQTextFieldArrowForCell *leasePMCell = [_dataListArr safeObjectAtIndex:6];
    DQTextFiledInfoCell *addressCell = [_dataListArr safeObjectAtIndex:8];
    DQTextFiledInfoCell *companyCell = [_dataListArr safeObjectAtIndex:9];
    DQTextFiledInfoCell *unitCell = [_dataListArr safeObjectAtIndex:10];
//    DQTextFieldArrowForCell *deviceXHCell = [_dataListArr safeObjectAtIndex:11];
    DQTextFiledInfoCell *rentCell = [_dataListArr safeObjectAtIndex:13];
    DQTextFiledInfoCell *exitFeeCell = [_dataListArr safeObjectAtIndex:14];
    DQTextFieldArrowForCell *expectedCell = [_dataListArr safeObjectAtIndex:17];
    DQTextFieldArrowForCell *goAwayCell = [_dataListArr safeObjectAtIndex:18];
    
    AddProjectModel *addm = [[AddProjectModel alloc] init];
    addm.projectid = _pmodel.projectid;
    addm.userid = self.baseUser.userid;
    addm.type = self.baseUser.type;
    addm.projectname = [NSString stringWithFormat:@"%@",projectNameCell.rightField.text];
    addm.no = [NSString stringWithFormat:@"%@",orderNumberCell.rightField.text];
    addm.needorgid = self.czfid; //承租方:needorgid
    addm.provideorgid = _pmodel.needorgid; //出租方
    addm.projectaddress = [NSString stringWithFormat:@"%@",addressCell.rightField.text];
    addm.contractor = [NSString stringWithFormat:@"%@",companyCell.rightField.text];
    addm.supervisor = [NSString stringWithFormat:@"%@",unitCell.rightField.text];
    addm.detail = _details;
    addm.devicenum = _details.count;
    addm.rent = [rentCell.rightField.text doubleValue];
    addm.intoutprice = [exitFeeCell.rightField.text doubleValue];
    addm.drivertype = @"";
    addm.drivers = @[];
    addm.indate = [NSString stringWithFormat:@"%@",expectedCell.rightField.text];
    addm.outdate = [NSString stringWithFormat:@"%@",goAwayCell.rightField.text];
    addm.note = @"";
    addm.usertype = self.baseUser.usertype;
    addm.pmname = [NSString stringWithFormat:@"%@",leasePMCell.rightField.text];
    addm.pmid = _czfPMID;

    ModifyProjectWI *lwi = [[ModifyProjectWI alloc] init];
    NSDictionary *param = [lwi inBox:addm];
    [CKNetTools requestWithRequestType:POST WithURL:lwi.fullUrl WithParamater:param WithProgressBlock:^(NSProgress *process) {
        
    } WithSuccessBlock:^(id returnValue) {
        NSArray *temp = [lwi unBox:returnValue];
        if ([temp[0] integerValue] == 1) {
            MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"修改成功"actionTitle:@"" duration:3.0];
            [t show];
            [self.navigationController popViewControllerAnimated:YES];
            if (self.basedelegate && [self.basedelegate respondsToSelector:@selector(didPopFromNextVC)]) {
                [self.basedelegate didPopFromNextVC];
            };
        }
        
    } WithFailureBlock:^(NSError *error) {
    }];
}

/** 如果是业务中心搜索页面push的，返回时要直接pop到业务中心页面 */
- (void)popAddProjectViewController
{
    UIAlertAction *infoAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
    [infoAction setValue:[UIColor colorWithHexString:COLOR_TITLE_GRAY] forKey:@"titleTextColor"];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [cancelAction setValue:[UIColor colorWithHexString:COLOR_BLUE] forKey:@"titleTextColor"];
    
    NSString *text = @"是否退出新增项目？";
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

#pragma mark -NewProjectScrollViewDelegate
- (void)sureBtnClicked:(NSMutableArray *)arr str:(NSString *)str
{
    if (_details.count) {
        [_details removeAllObjects];
    }
    for (DeviceTypeModel *typeModel in arr) {
        NSDictionary *dict = @{@"modelid" : @(typeModel.modelid),
                               @"model" : typeModel.model,
                               @"count" : @(typeModel.count),
                               @"brand" : typeModel.brand};
        [_details safeAddObject:dict];
    }
    DQTextFieldArrowForCell *deviceXHCell = [_dataListArr safeObjectAtIndex:12];
    deviceXHCell.rightField.text = str;
}

#pragma mark -NewDeviceScrollViewDelegate
- (void)didSelectValue:(id)value withSelf:(NewDeviceScrollView *)sender witnIndex:(NSInteger)index
{
    if (sender.tag == 6688) {
        CK_ID_NameModel *m = (CK_ID_NameModel *)value;
        self.cid = m.cid;
        DQTextFieldArrowForCell *leaseCell = [_dataListArr safeObjectAtIndex:5];
        DQTextFieldArrowForCell *leasePMCell = [_dataListArr safeObjectAtIndex:6];
        leaseCell.rightField.text = m.cname;
        leasePMCell.rightField.text = nil;
        [self.projectMangerAlertView setData:[NSMutableArray arrayWithArray:m.pm]];
    } else {
        UserModel *model = (UserModel *)value;
        _czfPMID = model.userid;
        DQTextFieldArrowForCell *leasePMCell = [_dataListArr safeObjectAtIndex:6];
        leasePMCell.rightField.text = model.name;
    }
}

#pragma mark -UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataListArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 || indexPath.row == 3 || indexPath.row == 7 || indexPath.row == 11 || indexPath.row == 16) {
        return 8.f;
    }
    return 50.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [_dataListArr safeObjectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:true];
    [self.leaseAlertView disshow];
    [self.projectMangerAlertView disshow];
    [self.pdxhAlertV disshow];
    switch (indexPath.row) {
        case 5:{//承租方
            [self.leaseAlertView showWithFatherV:self.mTableView];
        } break;
        case 6:{//承租方经理
            DQTextFieldArrowForCell *leaseCell = [_dataListArr safeObjectAtIndex:5];
            if (!leaseCell.rightField.text) {
                MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"请先选择承租方" actionTitle:@"" duration:3.0];
                [t show];
                return;
            }
            [self.projectMangerAlertView showWithFatherV:self.mTableView];
        } break;
        case 12:{//选择设备品牌型号
            [self.pdxhAlertV showWithFatherV:self.mTableView];
        } break;
        case 17:{//预计进场时机
            __block DQTextFieldArrowForCell *expectedCell = [_dataListArr safeObjectAtIndex:17];
            [BRDatePickerView showDatePickerWithTitle:@"请选择" dateType:UIDatePickerModeDate defaultSelValue:expectedCell.rightField.text minDateStr:[NSDate currentDateString] maxDateStr:nil isAutoSelect:true resultBlock:^(NSString *selectValue) {
                expectedCell.rightField.text = selectValue;
            }];
        } break;
        case 18:{//预计出场时机
            DQTextFieldArrowForCell *expectedCell = [_dataListArr safeObjectAtIndex:17];
            __block  DQTextFieldArrowForCell *goAwayCell = [_dataListArr safeObjectAtIndex:18];
            if (!expectedCell.rightField.text.length) {
                MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"请先选择进场时间" actionTitle:@"" duration:3.0];
                [t show];
                return;
            }
            [BRDatePickerView showDatePickerWithTitle:@"请选择" dateType:UIDatePickerModeDate defaultSelValue:goAwayCell.rightField.text minDateStr:expectedCell.rightField.text maxDateStr:nil isAutoSelect:true resultBlock:^(NSString *selectValue) {
                goAwayCell.rightField.text = selectValue;
            }];
        } break;
        default:
            break;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:self.mTableView]) {
        if (self.mTableView.contentOffset.y < _offY) {
            [self.view endEditing:true];
        }
        _offY = self.mTableView.contentOffset.y;//将当前位移变成缓存位移
    }
}

- (NSArray *)createAddNewProjectCell
{
    MJWeakSelf;
    UITableViewCell *topLineCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"topCellLineIdentifier"];
    topLineCell.selectionStyle = UITableViewCellSelectionStyleNone;
    topLineCell.contentView.backgroundColor = [UIColor colorWithHexString:@"#F3F4F5"];
    
    DQTextFiledInfoCell *projectNameCell = [[DQTextFiledInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"projectNameCellIdentifier"];
    projectNameCell.configLeftName = @"项目名称";
    projectNameCell.configLeftTitleColor = @"#1D1D1D";
    projectNameCell.rightField.font = [UIFont dq_regularSystemFontOfSize:14];
    projectNameCell.rightField.placeholder = @"请输入";
    
    DQTextFiledInfoCell *orderNumberCell = [[DQTextFiledInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"orderNumberCellIdentifier"];
    orderNumberCell.configLeftName = @"确认订单编号";
    orderNumberCell.configLeftTitleColor = @"#1D1D1D";
    orderNumberCell.rightField.font = [UIFont dq_regularSystemFontOfSize:14];
    orderNumberCell.rightField.placeholder = @"请输入";
    
    UITableViewCell *topCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"topCellLineIdentifier"];
    topCell.selectionStyle = UITableViewCellSelectionStyleNone;
    topCell.contentView.backgroundColor = [UIColor colorWithHexString:@"#F3F4F5"];
    
    DQTextFiledInfoCell *czfCell = [[DQTextFiledInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"lessorCellIdentifier"];
    czfCell.configLeftName = @"出租方";
    czfCell.configLeftTitleColor = @"#1D1D1D";
    czfCell.rightField.font = [UIFont dq_regularSystemFontOfSize:14];
    czfCell.rightField.placeholder = @"请输入";
    
    DQTextFieldArrowForCell *leaseCell = [[DQTextFieldArrowForCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"leaseCellIdentifier"];
    leaseCell.configLeftName = @"承租方";
    leaseCell.configLeftTitleColor = @"#1D1D1D";
    leaseCell.rightField.font = [UIFont dq_regularSystemFontOfSize:14];
    
    DQTextFieldArrowForCell *leasePMCell = [[DQTextFieldArrowForCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"leasePMCellIdentifier"];
    leasePMCell.configLeftName = @"承租方经理";
    leasePMCell.configLeftTitleColor = @"#1D1D1D";
    leasePMCell.rightField.font = [UIFont dq_regularSystemFontOfSize:14];
    [leasePMCell.rightField setEnabled:false];
    
    DQTextFiledInfoCell *addressCell = [[DQTextFiledInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"addressCellIdentifier"];
    addressCell.configLeftName = @"工程地点";
    addressCell.configLeftTitleColor = @"#1D1D1D";
    addressCell.rightField.font = [UIFont dq_regularSystemFontOfSize:14];
    addressCell.rightField.placeholder = @"请输入";
    
    DQTextFiledInfoCell *companyCell = [[DQTextFiledInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"companyCellIdentifier"];
    companyCell.configLeftName = @"总包公司";
    companyCell.configLeftTitleColor = @"#1D1D1D";
    companyCell.rightField.font = [UIFont dq_regularSystemFontOfSize:14];
    companyCell.rightField.placeholder = @"请输入";
    companyCell.InfoCellBlock = ^(DQTextFiledInfoCell *infoCell) {
        NSIndexPath *indexPath = [weakSelf.mTableView indexPathForCell:infoCell];
        CGRect frame = [weakSelf.mTableView rectForRowAtIndexPath:indexPath];
        [weakSelf.mTableView setContentOffset:CGPointMake(0, frame.origin.y) animated:false];
    };
    
    DQTextFiledInfoCell *unitCell = [[DQTextFiledInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"unitCellIdentifier"];
    unitCell.configLeftName = @"监理单位";
    unitCell.configLeftTitleColor = @"#1D1D1D";
    unitCell.rightField.font = [UIFont dq_regularSystemFontOfSize:14];
    unitCell.rightField.placeholder = @"请输入";
    
    DQTextFieldArrowForCell *deviceXHCell = [[DQTextFieldArrowForCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"deviceXHCellIdentifier"];
    deviceXHCell.configLeftName = @"选择设备品牌及型号";
    deviceXHCell.configLeftTitleColor = @"#1D1D1D";
    deviceXHCell.rightField.font = [UIFont dq_regularSystemFontOfSize:14];
    
    DQTextFiledInfoCell *deviceCountCell = [[DQTextFiledInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"unitCellIdentifier"];
    deviceCountCell.configLeftName = @"设备数量";
    deviceCountCell.configLeftTitleColor = @"#1D1D1D";
    deviceCountCell.rightField.font = [UIFont dq_regularSystemFontOfSize:14];
    deviceCountCell.rightField.placeholder = @"请输入";
    
    DQTextFiledInfoCell *rentCell = [[DQTextFiledInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"rentCellIdentifier"];
    rentCell.configLeftName = @"租金";
    rentCell.configLeftTitleColor = @"#1D1D1D";
    rentCell.rightField.font = [UIFont dq_regularSystemFontOfSize:14];
    rentCell.rightField.placeholder = @"请输入";
    
    DQTextFiledInfoCell *exitFeeCell = [[DQTextFiledInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"exitFeeCellIdentifier"];
    exitFeeCell.configLeftName = @"进出场费";
    exitFeeCell.configLeftTitleColor = @"#1D1D1D";
    exitFeeCell.rightField.font = [UIFont dq_regularSystemFontOfSize:14];
    exitFeeCell.rightField.placeholder = @"请输入";
    exitFeeCell.InfoCellBlock = ^(DQTextFiledInfoCell *infoCell) {
        CGPoint offY = weakSelf.mTableView.contentOffset;
        offY.y += 100;
        weakSelf.mTableView.contentOffset = offY;
    };
    
    DQTextFieldArrowForCell *expectedCell = [[DQTextFieldArrowForCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"expectedCellIdentifier"];
    expectedCell.configLeftName = @"预计进场时间";
    expectedCell.configLeftTitleColor = @"#1D1D1D";
    expectedCell.rightField.font = [UIFont dq_regularSystemFontOfSize:14];
    [expectedCell.rightField setEnabled:false];
    
    DQTextFieldArrowForCell *goAwayCell = [[DQTextFieldArrowForCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"goAwayCellIdentifier"];
    goAwayCell.configLeftName = @"预计出场时间";
    goAwayCell.configLeftTitleColor = @"#1D1D1D";
    goAwayCell.rightField.font = [UIFont dq_regularSystemFontOfSize:14];
    [goAwayCell.rightField setEnabled:false];
    
    if (_isNew != 0) { //修改项目
       projectNameCell.rightField.text = _pmodel.projectname;
       orderNumberCell.rightField.text = _pmodel.no;
       leaseCell.rightField.text = _pmodel.needorgname;
       czfCell.rightField.text = _pmodel.provideorgname;
       leasePMCell.rightField.text = _pmodel.pmname;
       addressCell.rightField.text = _pmodel.projectaddress;
       companyCell.rightField.text = _pmodel.contractor;
       unitCell.rightField.text = _pmodel.supervisor;
        NSString *str;
        if (_pmodel.detail.count > 0) {
            str = [NSString stringWithFormat:@"%@-",_pmodel.detail[0].brand];
            _details = [NSMutableArray arrayWithArray:_pmodel.detail];
        }
        
        for (int i = 0; i < _pmodel.detail.count; i++) {
            str = [NSString stringWithFormat:@"%@%@,",str,_pmodel.detail[i].model];
        }
        _czfPMID = _pmodel.pmid;
        self.czfid = _pmodel.needorgid;

        //去除最后一个逗号
        str = [str substringToIndex:str.length-1];
        deviceXHCell.rightField.text = str;

        deviceCountCell.rightField.text = [NSString stringWithFormat:@"%ld",(long)_pmodel.devicenum];
        rentCell.rightField.text = [NSString stringWithFormat:@"%.0ld",_pmodel.realrent];
        exitFeeCell.rightField.text = [NSString stringWithFormat:@"%ld",_pmodel.intoutprice];
        expectedCell.rightField.text = [NSDate verifyDateForYMD:_pmodel.indate];
        goAwayCell.rightField.text = [NSDate verifyDateForYMD:_pmodel.outdate];
    } else {
        czfCell.rightField.text = self.baseUser.orgname;
    }
    
    return @[topLineCell,projectNameCell,orderNumberCell,topCell,czfCell,leaseCell,leasePMCell,topCell,addressCell,companyCell,unitCell,topCell,deviceXHCell,deviceCountCell,rentCell,exitFeeCell,topCell,expectedCell,goAwayCell];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
