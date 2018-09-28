//
//  PersonInfoViewController.m
//  WebThings
//
//  Created by machinsight on 2017/7/4.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "PersonInfoViewController.h"
#import "HeadImgV.h"
#import "DQTextFieldArrowForCell.h"
#import "BRStringPickerView.h"
#import "DQAddressPickerView.h"

#import "DQPhotoActionSheetManager.h"

@interface PersonInfoViewController ()
<CKRadioButtonDelegate,
UITableViewDelegate,
UITableViewDataSource,
DQAddressPickerViewDelegate>
{
    UITableView *_mTableView;
    NSMutableArray *_dataCellList;
    NSString *_province, *_city, *_area;
    DQTextFiledInfoCell *_nameCell;
    DQTextFiledInfoCell *_jobAtCell;
    DQTextFiledInfoCell *_companyCell;
    DQTextFieldArrowForCell *_sexCell;
    DQTextFiledInfoCell *_phoneCell;
    DQTextFiledInfoCell *_IDCell;
    DQTextFiledInfoCell *_locationCell;
}
@property (nonatomic, strong) HeadImgV *headV;
@property (nonatomic, strong) NSArray *arrDataSources;
//图片地址
@property (nonatomic, strong) NSString *headUrl;
@property (nonatomic, strong) WTScrollViewKeyboardManager *manger;
@end

@implementation PersonInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"个人资料";
    //[EMINavigationController addAppBar:self barHeight:64 shadowColor:[UIColor whiteColor]];
    self.arrDataSources = nil;
    _headUrl = self.baseUser.headimg;
    [self initView];
    [self setManger:[[WTScrollViewKeyboardManager alloc] initWithScrollView:_mTableView viewController:self]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initLocalValues];
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

- (void)initLocalValues
{
    [_headV setImageWithURL:[NSURL URLWithString:appendUrl(imgUrl, self.baseUser.headimg)] placeholderImage:[_headV defaultImageWithName:self.baseUser.name]];
    _nameCell.rightField.text = self.baseUser.name;
    _jobAtCell.rightField.text = self.baseUser.usertype;
    //公司名称
    _companyCell.rightField.text = self.baseUser.orgname;
    //性别
    if ([self.baseUser.sex isEqualToString:@"男"]) {
        _sexCell.rightField.text = @"男";
    } else {
        _sexCell.rightField.text = @"女";
    }
    _phoneCell.rightField.text = self.baseUser.dn;
    _IDCell.rightField.text = self.baseUser.idcard;
    _locationCell.rightField.text = self.baseUser.district;
}

#pragma mark -rightItem
- (void)rightPresonNavClicked
{
    [MobClick event:@"usercenter_preson_right"];
    if (!_nameCell.rightField.text.length || !_sexCell.rightField.text.length || !_phoneCell.rightField.text.length || !_IDCell.rightField.text.length || !_locationCell.rightField.text.length || !_jobAtCell.rightField.text.length || !_companyCell.rightField.text.length) {
        MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"请填写完整信息" actionTitle:@"" duration:3.0];
        [t show];
        return;
    }
    if (_phoneCell.rightField.text.length != 11 || ![AppUtils isAllNum:_phoneCell.rightField.text]) {
        MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"手机号不合法" actionTitle:@"" duration:3.0];
        [t show];
        return;
    }
    if (_arrDataSources) { //先传头像
        [self fetchUploadImage];
    } else { //直接跟新资料
        [self fetchUpdateInfo];
    }
}

#pragma mark-- UI
- (void)initView
{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(rightPresonNavClicked) title:@"提交"];

    _dataCellList = [[NSMutableArray alloc] initWithArray:[self createPersonCellList]];
    
    _mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, screenWidth, screenHeight-8) style:UITableViewStylePlain];
    _mTableView.backgroundColor = [UIColor colorWithHexString:@"#F3F4F5"];
    _mTableView.delegate = self;
    _mTableView.dataSource = self;
    _mTableView.separatorColor = [UIColor clearColor];
    _mTableView.tableFooterView = [UIView new];
    if (@available(iOS 11.0, *)) {
        _mTableView.estimatedRowHeight = 0;
        _mTableView.estimatedSectionHeaderHeight = 0;
        _mTableView.estimatedSectionFooterHeight = 0;
        _mTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [self.view addSubview:_mTableView];

    _province = nil;
    _city = nil;
    _area = nil;
}

#pragma mark -UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataCellList.count;
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
    UITableViewCell *cell = [_dataCellList safeObjectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 3: {//职位
            
            
            
        } break;
        case 5: {//性别
            [self.view endEditing:true];
            [BRStringPickerView showStringPickerWithTitle:nil dataSource:@[@"男",@"女"] defaultSelValue:nil isAutoSelect:false resultBlock:^(id selectValue) {
                _sexCell.rightField.text = [NSString stringWithFormat:@"%@",selectValue];
            }];
        } break;
        case 8:{//地区
            [self.view endEditing:true];
            DQAddressPickerView *pickerView = [[DQAddressPickerView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
            pickerView.delegate = self;
            [pickerView configTitle:@"请选择地址"];
            [pickerView updateAddressAtProvince:_province city:_city town:_area];
            [self.view addSubview:pickerView];
        } break;
        default:
            break;
    }
}

#pragma mark -DQAddressPickerViewDelegate
- (void)didAddressPickerWithProvince:(NSString *)province
                                city:(NSString *)city
                                area:(NSString *)area
                          pickerView:(DQAddressPickerView *)pickerView
{
    _province = province;
    _city = city;
    _area = area;
    DQTextFieldArrowForCell *addressCell = [_dataCellList safeObjectAtIndex:7];
    addressCell.rightField.text = [NSString stringWithFormat:@"%@%@%@", province, city, area];
    [pickerView removeFromSuperview];
}

- (void)fetchUploadImage
{
    [[DQMyCenterInterface sharedInstance] dq_getUploadImageApi:[_arrDataSources safeObjectAtIndex:0] success:^(NSDictionary * returnValue){
        if (returnValue) {
            NSString *url = [returnValue objectForKey:@"imgpath"];
            self.headUrl = url;
            self.baseUser.headimg = self.headUrl;
            [self fetchUpdateInfo];
        } else {
            MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"头像上传失败" actionTitle:@"" duration:3.0];
            [t show];
        }
    } failture:^(NSError *error){
        
    }];
}

/**
 更新资料
 */
- (void)fetchUpdateInfo
{
    self.baseUser.name = _nameCell.rightField.text;
    self.baseUser.sex = _sexCell.rightField.text;
    self.baseUser.dn = _phoneCell.rightField.text;
    self.baseUser.idcard = _IDCell.rightField.text;
    self.baseUser.district = _locationCell.rightField.text;
    [[DQMyCenterInterface sharedInstance] dq_getUserModifyApi:self.baseUser success:^(id result){
        MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"修改成功" actionTitle:@"" duration:3.0];
        [t show];
        [AppUtils removeConfigUser];
        [AppUtils saveUser:self.baseUser];
        [self.navigationController popViewControllerAnimated:YES];
        if (self.basedelegate && [self.basedelegate respondsToSelector:@selector(didPopFromNextVC)]) {
            [self.basedelegate didPopFromNextVC];
        }
    } failture:^(NSError *error){
    }];
}

#pragma mark -Photo 上传头像

- (void)uploadHead
{
    [MobClick event:@"usercenter_preson_upheader"];
    [self showWithPreview:YES];
}

- (void)showWithPreview:(BOOL)preview
{
    DQPhotoActionSheetManager *manager = [[DQPhotoActionSheetManager alloc] init];
    [manager dq_showPhotoActionSheetWithController:self showPreviewPhoto:preview maxSelectCount:1 didSelectedImages:^(NSArray<UIImage *> *images) {
         self.headV.image = [images safeObjectAtIndex:0];
    }];
}

- (NSArray *)createPersonCellList
{
    UITableViewCell *topCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"topCellLineIdentifier"];
    topCell.selectionStyle = UITableViewCellSelectionStyleNone;
    topCell.contentView.backgroundColor = [UIColor colorWithHexString:@"#F3F4F5"];
    
    DQEMIBaseCell *headCell = [[DQEMIBaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"headCellIdentifier"];
    headCell.selectionStyle = UITableViewCellSelectionStyleNone;
    headCell.configLeftName = @"头像";
    headCell.configLeftFont = [UIFont dq_regularSystemFontOfSize:16];
    
    UIImageView *arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth-16-6, 20, 6, 10)];
    arrowView.image = ImageNamed(@"ic_business_device");
    [headCell.contentView addSubview:arrowView];
    
    _headV = [[HeadImgV alloc] initWithFrame:CGRectMake(arrowView.left-30-18, 10, 30, 30)];
    _headV.userInteractionEnabled = true;
    [_headV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(uploadHead)]];
    [headCell.contentView addSubview:_headV];
    
    DQTextFiledInfoCell *nameCell = [[DQTextFiledInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"nameCellIdentifier"];
    nameCell.configLeftName = @"姓名";
    nameCell.configLeftFont = [UIFont dq_regularSystemFontOfSize:16];
    [nameCell.rightField setEnabled:false];
    _nameCell = nameCell;
    
    DQTextFiledInfoCell *jobCell = [[DQTextFiledInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"jobCellIdentifier"];
    jobCell.configLeftName = @"职位";
    jobCell.configLeftFont = [UIFont dq_regularSystemFontOfSize:16];
    [jobCell.rightField setEnabled:false];
    _jobAtCell = jobCell;
    
    DQTextFiledInfoCell *infoCell = [[DQTextFiledInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"infoCellIdentifier"];
    infoCell.configLeftName = @"公司名称";
    infoCell.configLeftFont = [UIFont dq_regularSystemFontOfSize:16];
    infoCell.rightField.placeholder = @"点击填写公司名称";
    [infoCell.rightField setEnabled:false];
    _companyCell = infoCell;
    
    DQTextFieldArrowForCell *sexCell = [[DQTextFieldArrowForCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"sexCellIdentifier"];
    sexCell.configLeftName = @"性别";
    sexCell.configLeftFont = [UIFont dq_regularSystemFontOfSize:16];
    sexCell.rightField.placeholder = @"点击填写性别";
    [sexCell.rightField setEnabled:false];
    sexCell.rightField.font = [UIFont dq_regularSystemFontOfSize:14];
    _sexCell = sexCell;
    
    DQTextFiledInfoCell *phoneCell = [[DQTextFiledInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"phoneCellIdentifier"];
    phoneCell.configLeftName = @"联系电话";
    phoneCell.configLeftFont = [UIFont dq_regularSystemFontOfSize:16];
    phoneCell.rightField.placeholder = @"请输入";
    [phoneCell.rightField setEnabled:false];
    _phoneCell = phoneCell;
    
    DQTextFiledInfoCell *IDCardCell = [[DQTextFiledInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"IDCardCellIdentifier"];
    IDCardCell.configLeftName = @"身份证号";
    IDCardCell.configLeftFont = [UIFont dq_regularSystemFontOfSize:16];
    IDCardCell.rightField.placeholder = @"请输入";
    [IDCardCell.rightField setEnabled:false];
    _IDCell = IDCardCell;
    
    DQTextFiledInfoCell *addressCell = [[DQTextFiledInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"addressCellIdentifier"];
    addressCell.configLeftName = @"地区";
    addressCell.configLeftFont = [UIFont dq_regularSystemFontOfSize:16];
    addressCell.rightField.placeholder = @"请选择";
    [addressCell.rightField setEnabled:false];
    _locationCell = addressCell;
    
    return @[topCell,headCell,_nameCell,_jobAtCell,_companyCell,_sexCell,_phoneCell,_IDCell,_locationCell];
}

@end
