//
//  DQAddNewUserController.m
//  WebThings
//
//  Created by winton on 2017/9/30.
//  Copyright © 2017年 machinsight. All rights reserved.
//  添加人员

#import "DQAddNewUserController.h"
#import "DQTextFiledInfoCell.h"
#import "DQTextFieldArrowForCell.h"
#import "DriverModel.h"
#import "DQWorkTypeModel.h"
#import "NewDeviceScrollView.h"
#import "BRStringPickerView.h"
#import "BRDatePickerView.h"

@interface DQAddNewUserController ()
<UITableViewDelegate,
UITableViewDataSource,
NewDeviceScrollViewDelegate>
{
    NSMutableArray *_dataSource;
    NSInteger _workID;
    CGFloat _offY;
    NewDeviceScrollView *_pullWorkView;
}
@property (nonatomic, strong) UITableView *mTableView;
@end

#define FootViewHeight  40.f

@implementation DQAddNewUserController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    if (self.type == KDQAddNewUserAddNewStyle) {
         self.title = @"添加人员";
        self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(popViewController) image:ImageNamed(@"back")];
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(onSubmitClick) title:@"提交"];
        _dataSource = [NSMutableArray arrayWithArray:[self createInfoCell]];
        [self addTheUserInfoView];
    } else {
        self.title = @"修改人员";
        self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(popViewController) image:ImageNamed(@"back")];
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(onSubmitClick) title:@"提交"];
        if ([self.userModel.workcategory isEqualToString:@"工人"]) {
            _dataSource = [NSMutableArray arrayWithArray:[self createInfoCell]];
            [self addTheUserInfoView];
        } else if ([self.userModel.workcategory isEqualToString:@"司机"]) {
            _dataSource = [NSMutableArray arrayWithArray:[self createInfoCell]];
            [_dataSource addObjectsFromArray:[self addDerivePayTypeInfoCell]];
            [self addTheUserInfoView];
        }
    }
    //选择工种
    [self fetchWorkTypeApi];
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

- (void)popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)keyboardWillShow:(NSNotification *)note
{
    //获取键盘的高度
    NSDictionary *userInfo = [note userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [value CGRectValue];
    int KeyBoradHeight = keyboardRect.size.height;
    self.mTableView.height = screenHeight-64-KeyBoradHeight;
}

- (void)keyboardWillHide:(NSNotification *)note
{
    self.mTableView.height = screenHeight-64;
}

#pragma mark -NewDeviceScrollViewDelegate
- (void)didSelectValue:(id)value
              withSelf:(NewDeviceScrollView *)sender
             witnIndex:(NSInteger)index
{//工种选择
 //如果是司机，弹出司机选择cell。否则不作处理
    DQWorkTypeModel *typeModel = (DQWorkTypeModel *)value;
    _workID = typeModel.workcategoryid;
    DQTextFiledInfoCell *typeWorkCell = [_dataSource safeObjectAtIndex:9];
    typeWorkCell.rightField.text = typeModel.workcategory;
    if ([typeModel.workcategory isEqualToString:@"司机"]) {
        if (_dataSource.count > 13) {
            return;
        }
        [_dataSource addObjectsFromArray:[self addDerivePayTypeInfoCell]];
        [self.mTableView reloadData];
    } else {
        if (_dataSource.count > 13) {
            [_dataSource removeObjectsInRange:NSMakeRange(10, _dataSource.count-10)];
            [self.mTableView reloadData];
        }
    }
}

///选择工种
- (void)fetchWorkTypeApi
{
    [[DQProjectInterface sharedInstance] dq_getWorkType:^(id result) {
        if (result) {
            [_pullWorkView setData:result];
        }
    } failture:^(NSError *error) {
        
    }];
}

#pragma mark -UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 || indexPath.row == 10 || indexPath.row == 14) {
        return 8.f;
    }
    return 50.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [_dataSource safeObjectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:true];
    [_pullWorkView disshow];
    switch (indexPath.row) {
        case 2:{ //性别
            __block DQTextFiledInfoCell *sexCell = [_dataSource safeObjectAtIndex:2];
            [BRStringPickerView showStringPickerWithTitle:@"请选择" dataSource:@[@"男",@"女"] defaultSelValue: sexCell.rightField.text isAutoSelect:false resultBlock:^(id selectValue) {
                sexCell.rightField.text = [NSString stringWithFormat:@"%@",selectValue];
            }];
        } break;
        case 8:{//进驻项目时间
            __block DQTextFieldArrowForCell *topTimeCell = [_dataSource safeObjectAtIndex:8];
            [BRDatePickerView showDatePickerWithTitle:@"请选择" dateType:UIDatePickerModeDate defaultSelValue:topTimeCell.rightField.text minDateStr:[NSDate currentDateString] maxDateStr:nil isAutoSelect:true resultBlock:^(NSString *selectValue) {
                topTimeCell.rightField.text = selectValue;
            }];
        } break;
        case 9:{//工种
            [_pullWorkView showWithFatherV:_mTableView];
        } break;
        case 11:{//工资类型
            __block DQTextFieldArrowForCell *payTypeCell = [_dataSource safeObjectAtIndex:11];
            [BRStringPickerView showStringPickerWithTitle:@"请选择" dataSource:@[@"月工资",@"包干工资"] defaultSelValue: nil isAutoSelect:false resultBlock:^(id selectValue) {
                payTypeCell.rightField.text = [NSString stringWithFormat:@"%@",selectValue];
            }];
        } break;
        case 15:{ //司机安全教育
            __block DQTextFieldArrowForCell *infiMationCell = [_dataSource safeObjectAtIndex:15];
            [BRStringPickerView showStringPickerWithTitle:@"请选择" dataSource:@[@"是",@"否"] defaultSelValue: infiMationCell.rightField.text isAutoSelect:false resultBlock:^(id selectValue) {
                infiMationCell.rightField.text = [NSString stringWithFormat:@"%@",selectValue];
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

#pragma mark -Submit
- (void)onSubmitClick
{
    DQTextFiledInfoCell *nameCell = [_dataSource safeObjectAtIndex:1];
    DQTextFieldArrowForCell *sexCell = [_dataSource safeObjectAtIndex:2];
    DQTextFiledInfoCell *numberCell = [_dataSource safeObjectAtIndex:3];
    DQTextFiledInfoCell *ageCell = [_dataSource safeObjectAtIndex:4];
    DQTextFiledInfoCell *phoneCell = [_dataSource safeObjectAtIndex:5];
    DQTextFiledInfoCell *IDCardCell = [_dataSource safeObjectAtIndex:6];
    DQTextFiledInfoCell *addProjectCell = [_dataSource safeObjectAtIndex:7];
    DQTextFieldArrowForCell *topTimeCell = [_dataSource safeObjectAtIndex:8];
    DQTextFieldArrowForCell *typeWorkCell = [_dataSource safeObjectAtIndex:9];
    //默认选择或者工人选择的验证
    if (!nameCell.rightField.text.length || !sexCell.rightField.text.length || !numberCell.rightField.text.length ||!ageCell.rightField.text.length ||!phoneCell.rightField.text.length ||!IDCardCell.rightField.text.length ||!addProjectCell.rightField.text.length ||!typeWorkCell.rightField.text.length || !topTimeCell.rightField.text.length) {
        MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"请完善用户信息" actionTitle:@"" duration:3.0];
        [t show];
        return;
    }

    if (![AppUtils isAllNum:ageCell.rightField.text]) {
        MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"请填写正确格式年龄" actionTitle:@"" duration:3.0];
        [t show];
        return;
    }
    if (![AppUtils isAllNum:phoneCell.rightField.text] || phoneCell.rightField.text.length<11 || phoneCell.rightField.text.length>11 ) {
        MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"请填写正确格式的手机号" actionTitle:@"" duration:3.0];
        [t show];
        return;
    }
    NSString *sex = [sexCell.rightField.text isEqualToString:@"男"] ? @"1" : @"0";

    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:@(self.userModel.workerid) forKey:@"workerid"];
    [params setObject:nameCell.rightField.text forKey:@"name"];
    [params setObject:sex forKey:@"sex"];
    [params setObject:numberCell.rightField.text forKey:@"no"];
    [params setObject:ageCell.rightField.text forKey:@"age"];
    [params setObject:phoneCell.rightField.text forKey:@"dn"];
    [params setObject:IDCardCell.rightField.text forKey:@"idcard"];
    [params setObject:@(_workID) forKey:@"workcategoryid"];
    [params setObject:typeWorkCell.rightField.text forKey:@"workcategory"];
    [params setObject:topTimeCell.rightField.text forKey:@"entertime"];
    [params setObject:@"1" forKey:@"authpermission"];
    
    NSString *entertime = topTimeCell.rightField.text;
    NSString *notes = @"";
    NSString *renttype = @"";
    NSString *rent = @"";
    NSString *issafeteach = @"";
    NSString *authpermission = @"1";
    if (_dataSource.count > 10) {
        //司机的选择验证
        DQTextFieldArrowForCell *payTypeCell = [_dataSource safeObjectAtIndex:11];
        DQTextFiledInfoCell *payCell =  [_dataSource safeObjectAtIndex:12];
        DQTextFiledInfoCell *remarksCell = [_dataSource safeObjectAtIndex:13];
        DQTextFieldArrowForCell *infiMationCell = [_dataSource safeObjectAtIndex:15];
        if (!payTypeCell.rightField.text.length || !payCell.rightField.text.length || !infiMationCell.rightField.text.length) {
            MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"请完善用户信息" actionTitle:@"" duration:3.0];
            [t show];
            return;
        }
        if (![AppUtils isAllNum:payCell.rightField.text]) {
            MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"请填写正确格式的工资" actionTitle:@"" duration:3.0];
            [t show];
            return;
        }
        notes = [NSObject changeType:remarksCell.rightField.text];
        renttype = payTypeCell.rightField.text;
        rent = payCell.rightField.text;
        
        if ([infiMationCell.rightField.text isEqualToString:@"是"]) {
            issafeteach = @"1";
        } else {
            issafeteach = @"0";
        }

        [params setObject:payTypeCell.rightField.text forKey:@"renttype"];
        [params setObject:payCell.rightField.text forKey:@"rent"];
        [params setObject:notes forKey:@"notes"];
        [params setObject:infiMationCell.rightField.text forKey:@"issafeteach"];
    }
    
//    if (![AppUtils checkUserID:IDCardCell.rightField.text]) {
//        MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"请填写正确格式的身份证号" actionTitle:@"" duration:3.0];
//        [t show];
//        return;
//    }
    
    if (self.type == KDQAddNewUserAddNewStyle) { //新增人员
        NSDictionary *dict = @{@"name" : nameCell.rightField.text,//姓名
                               @"sex" : sex, //性别
                               @"no" : numberCell.rightField.text, //编号
                               @"age" : ageCell.rightField.text, //年龄
                               @"dn" : phoneCell.rightField.text, //手机号码
                               @"idcard" : IDCardCell.rightField.text, //身份证号
                               @"workcategory" : typeWorkCell.rightField.text, //工种
                               @"workcategoryid" : @(_workID), //工种ID
                               @"entertime" : entertime,  //进驻项目时间
                               @"notes" : notes,  //备注
                               @"renttype" : renttype, //工资类型,月工资\包干工资
                               @"rent" : rent, //工资
                               @"issafeteach" : issafeteach, //是否安全教育
                               @"authpermission" : authpermission //是否拥有操作权限,0-无 1有
                               };
        [[DQProjectInterface sharedInstance] dq_getAddNewUser:self.projectID params:dict success:^(id result) {
            if (result) {
                if (self.delegate && [self.delegate respondsToSelector:@selector(didConfigUserClicked:)]) {
                    [self.delegate didConfigUserClicked:self];
                    [self.navigationController popViewControllerAnimated:true];
                }
            }
        } failture:^(NSError *error) {
            
        }];
    } else {
        //修改人员
        [[DQProjectInterface sharedInstance] dq_getUpdateUser:self.projectID params:params success:^(id result) {
            if (result) {
                if (self.delegate && [self.delegate respondsToSelector:@selector(didConfigUserClicked:)]) {
                    [self.delegate didConfigUserClicked:self];
                    [self.navigationController popViewControllerAnimated:true];
                }
            }
        } failture:^(NSError *error) {
            
        }];
    }
}

#pragma mark -UI
- (void)addTheUserInfoView
{
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
    
    _pullWorkView = [[NewDeviceScrollView alloc] initWithFrame:CGRectMake(0, 458, screenWidth, 110)];
    _pullWorkView.tag = 7000;
    _pullWorkView.delegate = self;
    _pullWorkView.hidden = true;
    [_mTableView addSubview:_pullWorkView];
}

- (NSArray *)createInfoCell
{
    UITableViewCell *topCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"topCellLineIdentifier"];
    topCell.selectionStyle = UITableViewCellSelectionStyleNone;
    topCell.contentView.backgroundColor = [UIColor colorWithHexString:@"#F3F4F5"];
    MJWeakSelf;
    
    DQTextFiledInfoCell *nameCell = [[DQTextFiledInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"nameCellIdentifier"];
    nameCell.configLeftName = @"姓名";
    nameCell.configLeftTitleColor = @"#1D1D1D";
    nameCell.rightField.font = [UIFont dq_regularSystemFontOfSize:14];
    
    DQTextFieldArrowForCell *sexCell = [[DQTextFieldArrowForCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"sexCellIdentifier"];
    sexCell.configLeftName = @"性别";
    sexCell.configLeftTitleColor = @"#1D1D1D";
    sexCell.rightField.font = [UIFont dq_regularSystemFontOfSize:14];

    DQTextFiledInfoCell *numberCell = [[DQTextFiledInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"numberCellIdentifier"];
    numberCell.configLeftName = @"编号";
    numberCell.configLeftTitleColor = @"#1D1D1D";
    numberCell.rightField.font = [UIFont dq_regularSystemFontOfSize:14];
    
    DQTextFiledInfoCell *ageCell = [[DQTextFiledInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ageCellIdentifier"];
    ageCell.configLeftName = @"年龄";
    ageCell.configLeftTitleColor = @"#1D1D1D";
    ageCell.rightField.font = [UIFont dq_regularSystemFontOfSize:14];
    ageCell.rightField.placeholder = @"请输入";
    
    DQTextFiledInfoCell *phoneCell = [[DQTextFiledInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"phoneCellIdentifier"];
    phoneCell.configLeftName = @"电话";
    phoneCell.configLeftTitleColor = @"#1D1D1D";
    phoneCell.rightField.font = [UIFont dq_regularSystemFontOfSize:14];
    phoneCell.rightField.placeholder = @"请输入";
    
    DQTextFiledInfoCell *IDCardCell = [[DQTextFiledInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"IDCardCellIdentifier"];
    IDCardCell.configLeftName = @"身份证";
    IDCardCell.configLeftTitleColor = @"#1D1D1D";
    IDCardCell.rightField.font = [UIFont dq_regularSystemFontOfSize:14];
    IDCardCell.rightField.placeholder = @"请输入";
    IDCardCell.InfoCellBlock = ^(DQTextFiledInfoCell *infoCell) {
        NSIndexPath *indexPath = [weakSelf.mTableView indexPathForCell:infoCell];
        CGRect frame = [weakSelf.mTableView rectForRowAtIndexPath:indexPath];
        [weakSelf.mTableView setContentOffset:CGPointMake(0, frame.origin.y) animated:true];
    };
    
    DQTextFiledInfoCell *addProjectCell = [[DQTextFiledInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"addProjectCellIdentifier"];
    addProjectCell.configLeftName = @"所属项目";
    addProjectCell.configLeftTitleColor = @"#1D1D1D";
    addProjectCell.rightField.font = [UIFont dq_regularSystemFontOfSize:14];
    addProjectCell.rightField.text = self.projectname;
    [addProjectCell.rightField setEnabled:false];
    addProjectCell.rightField.placeholder = @"请输入";
 
    DQTextFieldArrowForCell *topTimeCell = [[DQTextFieldArrowForCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"topTimeCellIdentifier"];
    topTimeCell.configLeftName = @"进驻项目时间";
    topTimeCell.configLeftTitleColor = @"#1D1D1D";
    topTimeCell.rightField.font = [UIFont dq_regularSystemFontOfSize:14];

    DQTextFieldArrowForCell *typeWorkCell = [[DQTextFieldArrowForCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"typeWorkCellIdentifier"];
    typeWorkCell.configLeftName = @"工种";
    typeWorkCell.configLeftTitleColor = @"#1D1D1D";
    typeWorkCell.rightField.font = [UIFont dq_regularSystemFontOfSize:14];

    if (self.type == KDQModifyUserAddNewStyle) { //修改项目
        nameCell.rightField.text = self.userModel.name;
        if ([AppUtils  isAllNum:self.userModel.sex]) {
            sexCell.rightField.text = (self.userModel.sex.intValue == 0) ? @"女" : @"男";
        } else {
            sexCell.rightField.text = self.userModel.sex;
        }
        numberCell.rightField.text = self.userModel.no;
        ageCell.rightField.text = self.userModel.age;
        phoneCell.rightField.text = self.userModel.dn;
        IDCardCell.rightField.text = self.userModel.idcard;
        topTimeCell.rightField.text = [NSDate verifyDateForYMD:self.userModel.entertime];
        typeWorkCell.rightField.text = self.userModel.workcategory;
    }
    return @[topCell,nameCell,sexCell,numberCell,ageCell,phoneCell,IDCardCell,addProjectCell,topTimeCell,typeWorkCell];
}

///选择司机，增加司机选项的cell
- (NSArray *)addDerivePayTypeInfoCell
{
    UITableViewCell *topCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"topCellLineIdentifier"];
    topCell.selectionStyle = UITableViewCellSelectionStyleNone;
    topCell.contentView.backgroundColor = [UIColor colorWithHexString:@"#F3F4F5"];
    
    MJWeakSelf;
    DQTextFieldArrowForCell *payTypeCell = [[DQTextFieldArrowForCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"payTypeCellIdentifier"];
    payTypeCell.configLeftName = @"工资类型";
    payTypeCell.configLeftTitleColor = @"#1D1D1D";
    [payTypeCell.rightField setEnabled:false];
    payTypeCell.rightField.font = [UIFont dq_regularSystemFontOfSize:14];

    DQTextFiledInfoCell *payCell = [[DQTextFiledInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"payCellIdentifier"];
    payCell.configLeftName = @"工资";
    payCell.configLeftTitleColor = @"#1D1D1D";
    payCell.rightField.font = [UIFont dq_regularSystemFontOfSize:14];
    payCell.rightField.placeholder = @"请输入";
    payCell.InfoCellBlock = ^(DQTextFiledInfoCell *infoCell) {
        NSIndexPath *indexPath = [weakSelf.mTableView indexPathForCell:infoCell];
        CGRect frame = [weakSelf.mTableView rectForRowAtIndexPath:indexPath];
        [weakSelf.mTableView setContentOffset:CGPointMake(0, frame.origin.y) animated:true];
    };
    
    DQTextFiledInfoCell *remarksCell = [[DQTextFiledInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"remarksCellIdentifier"];
    remarksCell.configLeftName = @"备注";
    remarksCell.configLeftTitleColor = @"#1D1D1D";
    remarksCell.rightField.font = [UIFont dq_regularSystemFontOfSize:14];
    remarksCell.rightField.placeholder = @"是否有加班费";
    
    UITableViewCell *bottomCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bottomCellLineIdentifier"];
    bottomCell.selectionStyle = UITableViewCellSelectionStyleNone;
    bottomCell.contentView.backgroundColor = [UIColor colorWithHexString:@"#F3F4F5"];

    DQTextFieldArrowForCell *infiMationCell = [[DQTextFieldArrowForCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"infiMationCellIdentifier"];
    infiMationCell.configLeftName = @"司机安全教育";
    infiMationCell.configLeftTitleColor = @"#1D1D1D";
    [infiMationCell.rightField setEnabled:false];
    infiMationCell.rightField.font = [UIFont dq_regularSystemFontOfSize:14];

    if (self.type == KDQModifyUserAddNewStyle) { //修改项目
        payTypeCell.rightField.text = self.userModel.renttype;
        payCell.rightField.text = [NSString stringWithFormat:@"%.0f",self.userModel.rent];
        remarksCell.rightField.text = self.userModel.notes;
        infiMationCell.rightField.text = (self.userModel.issafeteach == 0) ? @"否" : @"是";
    }
    return @[topCell,payTypeCell,payCell,remarksCell,bottomCell,infiMationCell];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
