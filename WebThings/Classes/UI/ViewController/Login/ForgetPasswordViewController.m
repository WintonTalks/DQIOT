//
//  ForgetPasswordViewController.m
//  WebThings
//
//  Created by machinsight on 2017/7/20.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "ForgetPasswordViewController.h"
#import "DQTextFiledInfoCell.h"
#import "NewLoginViewController.h"

@interface ForgetPasswordViewController ()
<UITableViewDelegate,
UITableViewDataSource>
{
    UIButton *_yzButton;
    UITextField *_dnField;
    NSMutableArray *_dataListArr;
}
@property (nonatomic, strong) UITableView *mTableView;
@end

@implementation ForgetPasswordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(popViewController) image:ImageNamed(@"back")];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(onSubmitAppVerifyClick) title:@"提交"];
    if (self.type == KForgetPasswordVerifyStyle) {
        self.title = @"忘记密码";
        _dataListArr = [NSMutableArray arrayWithArray:[self createInfoPwdCellArray]];
    } else {
        self.title = @"修改密码";
        _dataListArr = [NSMutableArray arrayWithArray:[self createInfoModifyCell]];
    }
    UIControl *infoControl = [[UIControl alloc] initWithFrame:self.view.bounds];
    infoControl.backgroundColor = [UIColor clearColor];
    [infoControl addTarget:self action:@selector(onHideKeyBoard) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:infoControl];
    [self.view sendSubviewToBack:infoControl];
    [self.view addSubview:self.mTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.type == KForgetPasswordVerifyStyle) {
        [self.navigationController setNavigationBarHidden:false];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.type == KForgetPasswordVerifyStyle) {
         [self.navigationController setNavigationBarHidden:true];
    }
}

- (CGSize)intrinsicContentSize
{
    return UILayoutFittingExpandedSize;
}

- (void)onHideKeyBoard
{
    [self.view endEditing:YES];
}

- (void)popViewController
{
    [self.navigationController popViewControllerAnimated:true];
}

//提交接口
- (void)onSubmitAppVerifyClick
{
    [self.view endEditing:YES];
    if (self.type == KForgetPasswordVerifyStyle) {//忘记密码
        DQTextFiledInfoCell *phoneCell = [_dataListArr safeObjectAtIndex:0];
        DQTextFiledInfoCell *pwdCell = [_dataListArr safeObjectAtIndex:2];
        DQTextFiledInfoCell *twoPwdCell = [_dataListArr safeObjectAtIndex:3];
        if (![AppUtils isAllNum:phoneCell.rightField.text] || phoneCell.rightField.text.length != 11) {
            MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"请输入正确的手机号" actionTitle:@"" duration:3.0];
            [t show];
            return;
        }
        if (!phoneCell.rightField.text.length || !_dnField.text.length ||!pwdCell.rightField.text.length|| !twoPwdCell.rightField.text.length) {
            MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"您有选项未输入" actionTitle:@"" duration:3.0];
            [t show];
            return;
        }
        if (![pwdCell.rightField.text isEqualToString:twoPwdCell.rightField.text]) {
            MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"两次密码输入不一致" actionTitle:@"" duration:3.0];
            [t show];
            return;
        }
        [[DQMyCenterInterface sharedInstance] dq_getUpdatepassdApi:phoneCell.rightField.text code:_dnField.text pwd:[Encrypt md5EncryptWithString:pwdCell.rightField.text] success:^(id result) {
            if (result != nil) {
                MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"操作成功" actionTitle:@"" duration:3.0];
                [t show];
                [self.navigationController popViewControllerAnimated:true];
            }
            
        } failture:^(NSError *error) {
        }];
    } else {
        [MobClick event:@"usercenter_modify_password"];
        DQTextFiledInfoCell *oldPwdCell = [_dataListArr safeObjectAtIndex:0];
        DQTextFiledInfoCell *pwdCell = [_dataListArr safeObjectAtIndex:1];
        DQTextFiledInfoCell *twoPwdCell = [_dataListArr safeObjectAtIndex:2];
        
        if (!oldPwdCell.rightField.text.length || !pwdCell.rightField.text.length || !twoPwdCell.rightField.text.length) {
            MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"密码不能为空" actionTitle:@"" duration:3.0];
            [t show];
            return;
        }
        if (pwdCell.rightField.text != twoPwdCell.rightField.text) {
            MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"两次密码输入不一致" actionTitle:@"" duration:3.0];
            [t show];
            return;
        }
        [[DQMyCenterInterface sharedInstance] dq_getFixPassWordApi:self.baseUser oldText:oldPwdCell.rightField.text newText:pwdCell.rightField.text success:^(id result) {
            //成功
            MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"修改成功" actionTitle:@"" duration:3.0];
            [t show];
            //返回登录页
            UIWindow *window = [AppUtils getAppWindow];
            window.rootViewController = [[EMINavigationController alloc] initWithRootViewController:[NewLoginViewController new]];            
        } failture:^(NSError *error) {
            
        }];
        
    }
}

/**
 请求验证码
 */
- (void)onVerficationBtnClick
{
    DQTextFiledInfoCell *phoneCell = [_dataListArr safeObjectAtIndex:0];
    if (![AppUtils isAllNum:phoneCell.rightField.text] || phoneCell.rightField.text.length != 11) {
        MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"请输入正确的手机号" actionTitle:@"" duration:3.0];
        [t show];
        return;
    }
    [self fetchAppVerify];
//    __weak typeof(self) weakSelf = self;
//    // 剩余的时间（必须用__block修饰，以便在block中使用）
    __block NSInteger remainTime = 60;
    // 获取全局队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    // 每隔1s钟执行一次
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    // 在queue中执行event_handler事件
    dispatch_source_set_event_handler(timer, ^{
        if (remainTime <= 0) { // 倒计时结束
            dispatch_source_cancel(timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [_yzButton setTitle:@"获取验证码" forState:UIControlStateNormal];
                _yzButton.enabled = true;
            });
        } else {
            NSString *timeStr = [NSString stringWithFormat:@"%ld s", remainTime];
            dispatch_async(dispatch_get_main_queue(), ^{
                [_yzButton setTitle:[NSString stringWithFormat:@"%@",timeStr] forState:UIControlStateDisabled];
                _yzButton.enabled = false;
            });
            remainTime--;
        }
    });
    dispatch_resume(timer);
}

- (void)fetchAppVerify
{
    [[DQMyCenterInterface sharedInstance] dq_getAppVerifyApi:_dnField.text success:^(id result) {
        if (result!=nil) {
            MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"验证码发送成功" actionTitle:@"" duration:3.0];
            [t show];
        }
    } failture:^(NSError *error) {
        
    }];
}


- (UITableView *)mTableView
{
    if (!_mTableView) {
        CGFloat height = (self.type == KForgetPasswordVerifyStyle) ? 200 : 150;
        _mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+8, screenWidth, height) style:UITableViewStylePlain];
        _mTableView.delegate = self;
        _mTableView.dataSource = self;
        _mTableView.separatorColor = [UIColor clearColor];
        _mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mTableView.tableFooterView = [UIView new];
        _mTableView.scrollEnabled = false;
        if (@available(iOS 11.0, *)) {
            _mTableView.estimatedRowHeight = 0;
            _mTableView.estimatedSectionHeaderHeight = 0;
            _mTableView.estimatedSectionFooterHeight = 0;
        }
    }
    return _mTableView;
}

//忘记密码cell
- (NSArray *)createInfoPwdCellArray
{
    DQTextFiledInfoCell *phoneCell = [[DQTextFiledInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"phoneCellIdentifier"];
    phoneCell.selectionStyle = UITableViewCellSelectionStyleNone;
    phoneCell.configPlaceholder = @"请输入";
    phoneCell.configLeftName = @"请输入手机号";
    phoneCell.configLeftFont = [UIFont dq_regularSystemFontOfSize:14];
    phoneCell.rightField.keyboardType = UIKeyboardTypeNumberPad;
    
    DQEMIBaseCell *codeCell = [[DQEMIBaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"codeCellIdentifier"];
    codeCell.selectionStyle = UITableViewCellSelectionStyleNone;
    codeCell.configLeftName = @"请输入验证码";
    codeCell.configLeftFont = [UIFont dq_regularSystemFontOfSize:14];
    
    UIButton *yzButton = [UIButton buttonWithType:UIButtonTypeCustom];
    yzButton.frame = CGRectMake(screenWidth-16-90, 10, 90, 30);
    yzButton.backgroundColor = RGB_Color(58, 137, 235, 1);
    [yzButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [yzButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    yzButton.titleLabel.font = [UIFont dq_regularSystemFontOfSize:14];
    [yzButton addTarget:self action:@selector(onVerficationBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [yzButton withRadius:6.f];
    [codeCell.contentView addSubview:yzButton];
    _yzButton = yzButton;
    
    UITextField *rightField = [[UITextField alloc] initWithFrame:CGRectMake(yzButton.left-75, yzButton.top, 70, yzButton.height)];
    rightField.returnKeyType = UIReturnKeyDefault;
    rightField.textAlignment = NSTextAlignmentRight;
    rightField.textColor = [UIColor colorWithHexString:COLOR_BLACK];
    rightField.font = [UIFont dq_regularSystemFontOfSize:14];
    [codeCell.contentView addSubview:rightField];
    _dnField = rightField;
    
    DQTextFiledInfoCell *pwdCell = [[DQTextFiledInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"pwdCellIdentifier"];
    pwdCell.selectionStyle = UITableViewCellSelectionStyleNone;
    pwdCell.configPlaceholder = @"请输入";
    pwdCell.configLeftName = @"请输入新密码";
    pwdCell.configLeftFont = [UIFont dq_regularSystemFontOfSize:14];
    pwdCell.rightField.secureTextEntry = true;
    
    DQTextFiledInfoCell *twoPwdCell = [[DQTextFiledInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"twoPwdCellIdentifier"];
    twoPwdCell.selectionStyle = UITableViewCellSelectionStyleNone;
    twoPwdCell.configPlaceholder = @"请输入";
    twoPwdCell.configLeftName = @"请再次输入密码";
    twoPwdCell.configLeftFont = [UIFont dq_regularSystemFontOfSize:14];
    twoPwdCell.rightField.secureTextEntry = true;
    return @[phoneCell,codeCell,pwdCell,twoPwdCell];
}

//修改密码cell
- (NSArray *)createInfoModifyCell
{
    DQTextFiledInfoCell *oldPwdCell = [[DQTextFiledInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"oldPwdCellIdentifier"];
    oldPwdCell.selectionStyle = UITableViewCellSelectionStyleNone;
    oldPwdCell.configPlaceholder = @"请输入";
    oldPwdCell.configLeftName = @"原密码";
    oldPwdCell.configLeftFont = [UIFont dq_regularSystemFontOfSize:14];
    oldPwdCell.rightField.secureTextEntry = true;
    
    DQTextFiledInfoCell *pwdCell = [[DQTextFiledInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"pwdCellCellIdentifier"];
    pwdCell.selectionStyle = UITableViewCellSelectionStyleNone;
    pwdCell.configPlaceholder = @"请输入";
    pwdCell.configLeftName = @"新密码";
    pwdCell.configLeftFont = [UIFont dq_regularSystemFontOfSize:14];
    pwdCell.rightField.secureTextEntry = true;
    
    DQTextFiledInfoCell *twoPwdCell = [[DQTextFiledInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"twoPwdCellIdentifier"];
    twoPwdCell.selectionStyle = UITableViewCellSelectionStyleNone;
    twoPwdCell.configPlaceholder = @"请输入";
    twoPwdCell.configLeftName = @"确认密码";
    twoPwdCell.configLeftFont = [UIFont dq_regularSystemFontOfSize:14];
    twoPwdCell.rightField.secureTextEntry = true;
    return @[oldPwdCell,pwdCell,twoPwdCell];
}


#pragma mark -UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataListArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [_dataListArr safeObjectAtIndex:indexPath.row];
    return cell;
}

@end
