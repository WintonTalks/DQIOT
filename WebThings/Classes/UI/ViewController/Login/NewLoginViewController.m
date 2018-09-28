//
//  NewLoginViewController.m
//  WebThings
//
//  Created by machinsight on 2017/8/15.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "NewLoginViewController.h"
#import "YYTabBarController.h"
#import "ForgetPasswordViewController.h"
#import "WorkNoticeViewController.h"
#import "LoginWI.h"

// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@interface NewLoginViewController()
{
    UITextField *_dnTF;
    UITextField *_pwdTF;
    UIButton *_loginBtn;
    UIButton *_fogetBtn;
}
@property (nonatomic, strong) YYAnimatedImageView *backAnimatedView;
@end

@implementation NewLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addConfigLoginView];
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:true];
}

- (void)addConfigLoginView
{
    UIControl *infoControl = [[UIControl alloc] initWithFrame:self.view.bounds];
    infoControl.backgroundColor = [UIColor clearColor];
    [infoControl addTarget:self action:@selector(onHideKeyBoard) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:infoControl];
    [self.view sendSubviewToBack:infoControl];
    
    YYImage * image = [YYImage imageNamed:@"icon_LoginBack"];
    self.backAnimatedView = [[YYAnimatedImageView alloc] initWithImage:image];
    self.backAnimatedView.frame = self.view.bounds;
    self.backAnimatedView.contentMode = UIViewContentModeScaleAspectFill;
    self.backAnimatedView.clipsToBounds = YES;
    [self.view addSubview:self.backAnimatedView];

    UIImageView *useView = [[UIImageView alloc] initWithFrame:CGRectMake(62*screenWidth/375, 204, 20, 23)];
    useView.image = ImageNamed(@"icon_login_use");
    [self.view addSubview:useView];
    
    _dnTF = [[UITextField alloc] initWithFrame:CGRectMake(useView.right+12, useView.top, 219, useView.height)];
    _dnTF.placeholder = @"用户名";
    _dnTF.font = [UIFont dq_mediumSystemFontOfSize:14];
    _dnTF.returnKeyType = UIReturnKeyDefault;
    _dnTF.textAlignment = NSTextAlignmentLeft;
    _dnTF.textColor = [UIColor colorWithHexString:COLOR_BLACK];
    _dnTF.keyboardType = UIKeyboardTypePhonePad;
    _dnTF.clearButtonMode = UITextFieldViewModeAlways;
    [self.view addSubview:_dnTF];
    
    UIView *topLineView = [[UIView alloc] initWithFrame:CGRectMake(_dnTF.left, _dnTF.bottom, _dnTF.width, 1)];
    topLineView.backgroundColor = [UIColor colorWithHexString:@"#D8D8D8"];
    [self.view addSubview:topLineView];
    
    UIImageView *pwdView = [[UIImageView alloc] initWithFrame:CGRectMake(useView.left, topLineView.bottom+42, 20, 23)];
    pwdView.image = ImageNamed(@"icon_login_pwd");
    [self.view addSubview:pwdView];
    
    _pwdTF = [[UITextField alloc] initWithFrame:CGRectMake(pwdView.right+12, pwdView.top, _dnTF.width, _dnTF.height)];
    _pwdTF.placeholder = @"密码";
    _pwdTF.font = [UIFont dq_mediumSystemFontOfSize:14];
    _pwdTF.returnKeyType = UIReturnKeyDefault;
    _pwdTF.textAlignment = NSTextAlignmentLeft;
    _pwdTF.textColor = [UIColor colorWithHexString:COLOR_BLACK];
    _pwdTF.secureTextEntry = true;
    _pwdTF.clearButtonMode = UITextFieldViewModeAlways;
    [self.view addSubview:_pwdTF];
    
    UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(_pwdTF.left, _pwdTF.bottom, _pwdTF.width, 1)];
    bottomLineView.backgroundColor = [UIColor colorWithHexString:@"#D8D8D8"];
    [self.view addSubview:bottomLineView];
    
    NSString *text = @"忘记密码?";
    UIFont *font = [UIFont dq_mediumSystemFontOfSize:14];
    CGFloat width = [AppUtils textWidthSystemFontString:text height:12 font:font];
    _fogetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _fogetBtn.backgroundColor = [UIColor clearColor];
    _fogetBtn.frame = CGRectMake(_pwdTF.left, bottomLineView.bottom+10, width, 14);
    [_fogetBtn setTitle:text forState:UIControlStateNormal];
    [_fogetBtn setTitleColor:[UIColor colorWithHexString:@"#CACACA"] forState:UIControlStateNormal];
    _fogetBtn.titleLabel.font = font;
    [_fogetBtn addTarget:self action:@selector(onForGetPwdClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_fogetBtn];

    _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _loginBtn.frame = CGRectMake((screenWidth-438/2)/2, _fogetBtn.bottom+82, 438/2, 61);
    [_loginBtn setImage:ImageNamed(@"icon_login_backbtn") forState:UIControlStateNormal];
    [_loginBtn addTarget:self action:@selector(onLoginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginBtn];

    UILabel *loginLabel = [[UILabel alloc] initWithFrame:CGRectMake((_loginBtn.width-36)/2, (_loginBtn.height-18)/2, 36, 18)];
    loginLabel.text = @"登录";
    loginLabel.textColor = [UIColor whiteColor];
    loginLabel.font = [UIFont dq_mediumSystemFontOfSize:18];
    [_loginBtn addSubview:loginLabel];
    
}

- (void)onHideKeyBoard
{
    [self.view endEditing:true];
}

//忘记密码
- (void)onForGetPwdClick
{
    ForgetPasswordViewController *pwdVC = [ForgetPasswordViewController new];
    pwdVC.type = KForgetPasswordVerifyStyle;
    [self.navigationController pushViewController:pwdVC animated:true];
}

//登录
- (void)onLoginBtnClick
{
     [self fetchLogin];
}

- (void)initView
{
    NSString *userName = [NSObject changeType:[AppUtils readUser].dn];
    _dnTF.text = userName;
    [_dnTF addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
}

// 账号一旦变更，就清空密码标签
- (void)textFieldTextChange:(UITextField *)textField
{
    //if ([[NSObject changeType:textField.text] isEqualToString:@""]) {
        _pwdTF.text = @"";
    //}
}

#pragma mark - Http Request
/** 登录请求 */
- (void)fetchLogin
{
    [MobClick event:@"userLoginClick"];
    [self.view endEditing:YES];
    if (!_dnTF.text.length || _dnTF.text.length != 11) {
        MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"手机号不合法" actionTitle:@"" duration:3.0];
        [t show];
        return;
    }
    if (!_pwdTF.text.length) {
        MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"密码不能为空" actionTitle:@"" duration:3.0];
        [t show];
        return;
    }
    LoginWI *lwi = [[LoginWI alloc] init];
    NSArray *arr = @[_dnTF.text,[Encrypt md5EncryptWithString:_pwdTF.text]];
    NSDictionary *param = [lwi inBox:arr];
    [CKNetTools requestWithRequestType:POST WithURL:lwi.fullUrl WithParamater:param WithProgressBlock:^(NSProgress *process) {
        
    } WithSuccessBlock:^(id returnValue) {
        
        NSArray *temp = [lwi unBox:returnValue];
        if ([[temp safeObjectAtIndex:0] integerValue] == 1) {
            //存个jpush别名
            [JPUSHService setAlias:_dnTF.text completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
                
            } seq:(1)];
            //成功
            UserModel *mo = [temp safeObjectAtIndex:1];
            [AppUtils saveUser:mo];
            
            if ([mo.usertype isEqualToString:@"工人"]) {
                [self.navigationController pushViewController:[AppUtils VCFromSB:@"Workers" vcID:@"WorkNoticeVC"] animated:YES];
            }else if([mo.usertype isEqualToString:@"司机"]){
                [self.navigationController pushViewController:[AppUtils VCFromSB:@"Drivers" vcID:@"DriversNewsVC"] animated:YES];
            }else{
                [self presentViewController:[[YYTabBarController alloc] init] animated:YES completion:nil];
            }
        }
        
    } WithFailureBlock:^(NSError *error) {
    }];
//    [[DQMyCenterInterface sharedInstance] dq_getLoginApi:_dnTF.text password:[Encrypt md5EncryptWithString:_pwdTF.text] success:^(id result) {
//        if (result) {
//            //存个jpush别名
//            [JPUSHService setAlias:_dnTF.text completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
//
//            } seq:(1)];
//            //成功
//            UserModel *mo = result;
//            [AppUtils saveUser:mo];
//            if ([mo.usertype isEqualToString:@"工人"]) {
//                [self.navigationController pushViewController:[AppUtils VCFromSB:@"Workers" vcID:@"WorkNoticeVC"] animated:YES];
//            }else if([mo.usertype isEqualToString:@"司机"]){
//                [self.navigationController pushViewController:[AppUtils VCFromSB:@"Drivers" vcID:@"DriversNewsVC"] animated:YES];
//            }else{
//                [self presentViewController:[[YYTabBarController alloc] init] animated:YES completion:nil];
//            }
//        }
//    } failture:^(NSError *error) {
//
//    }];
}


@end
