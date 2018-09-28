//
//  MeViewController.m
//  WebThings
//
//  Created by 陈凯 on 2017/7/4.
//  Copyright © 2017年 陈凯. All rights reserved.
//

#import "MeViewController.h"
#import "PersonInfoViewController.h"
#import "MyColleagueViewController.h"
#import "SuggestBackViewController.h"
#import "DQUserCenterHeaderCell.h"
#import "MeBaseTableViewCell.h"
#import "DQBaseWebViewController.h" //关于我们
#import "ForgetPasswordViewController.h"
#import "NewLoginViewController.h"
#import "DQAlert.h"

@interface MeViewController ()
<UITableViewDelegate,
UITableViewDataSource,
EMIBaseViewControllerDelegate>
{
    NSMutableArray *_InfoArray;
    DQAlert *_alert;
    UIView *_logoutView;
}

@property (nonatomic, strong) DQUserCenterHeaderCell *userHeadCell;
@property (nonatomic, strong) UITableView *mTableView;
@property (nonatomic, strong) UIBarButtonItem *navigationTitle;

@end

@implementation MeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.edgesForExtendedLayout = UIRectEdgeNone;
//    self.automaticallyAdjustsScrollViewInsets = NO;// 自动滚动调整，默认为YES
    //self.NaigationScrollerView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
    [self initMeViewNav];
    
    _InfoArray = [[NSMutableArray alloc] initWithArray:[self createInfoCell]];
    [self.view addSubview:self.mTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //[self.navigationController setNavigationBarHidden:true animated:animated];
    [self initLocalValues];
    
    [MobClick beginLogPageView:@"MyCenter"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"MyCenter"];
}

- (void)initMeViewNav
{
    self.navigationItem.leftBarButtonItem = self.navigationTitle;
}

#pragma mark -UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _InfoArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 104*screenHeight/667;
    } else if (indexPath.row == 1 || indexPath.row == 5) {
        return 30.f*screenHeight/667;
    } else if (indexPath.row == 9 || indexPath.row == 11) {
        return 16.f*screenHeight/667;
    }
    return (screenHeight-49-92-165)/7*screenHeight/667;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [_InfoArray safeObjectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 2:{//个人资料
            PersonInfoViewController *VC = [PersonInfoViewController new];
            VC.basedelegate = self;
            [self.navigationController pushViewController:VC animated:YES];
        } break;
        case 3: { //我的同事
            MyColleagueViewController *VC = [MyColleagueViewController new];
            [self.navigationController pushViewController:VC animated:YES];
        } break;
        case 4: { //修改密码
            ForgetPasswordViewController *pwdVC = [ForgetPasswordViewController new];
            pwdVC.type = KForgetPasswordModifyStyle;
            [self.navigationController pushViewController:pwdVC animated:true];
        } break;
        case 6: { //意见反馈
            SuggestBackViewController *VC = [[SuggestBackViewController alloc] init];
            [self.navigationController pushViewController:VC animated:YES];
        } break;
        case 7: { //服务条款
            DQBaseWebViewController *vc = [[DQBaseWebViewController alloc] init];
            vc.fileName = @"service";
            vc.navTitle = @"服务条款";
            [self.navigationController pushViewController:vc animated:YES];
        } break;
        case 8: { //关于我们
            DQBaseWebViewController *vc = [[DQBaseWebViewController alloc] init];
            vc.fileName = @"about";
            vc.navTitle = @"关于我们";
            [self.navigationController pushViewController:vc animated:YES];
        } break;
        case 10:
        {//退出登录
            if (!_alert) {
                _alert = [[DQAlert alloc] init];
                CGFloat width = screenWidth -  20;
                
                _logoutView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, width, 132)];
                
                UIView *border = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 122)];
                border.backgroundColor = [UIColor whiteColor];
                border.layer.cornerRadius = 5.0;
                [_logoutView addSubview:border];
                
                UILabel *lblTitle = [[UILabel alloc] initWithFrame:
                                     CGRectMake(30, 30, width - 40, 18)];
                lblTitle.textColor = [UIColor colorWithHexString:COLOR_BLACK];
                lblTitle.font = [UIFont boldSystemFontOfSize:16];
                lblTitle.text = @"您真的要退出吗？";
                [border addSubview:lblTitle];
                
                UIButton *btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
                [btnCancel setTitle:@"取消" forState:UIControlStateNormal];
                [btnCancel setTitleColor:[UIColor colorWithHexString:@"#656565"] forState:UIControlStateNormal];
                [btnCancel addTarget:self action:@selector(onCancelClick) forControlEvents:UIControlEventTouchUpInside];
                btnCancel.frame = CGRectMake(0, 62, 92, 44);
                btnCancel.titleLabel.font = [UIFont dq_mediumSystemFontOfSize:16];
                [border addSubview:btnCancel];
                
                UIButton *btnOK = [UIButton buttonWithType:UIButtonTypeCustom];
                [btnOK setTitle:@"确定" forState:UIControlStateNormal];
                [btnOK setTitleColor:[UIColor colorWithHexString:COLOR_BLUE] forState:UIControlStateNormal];
                btnOK.frame = CGRectMake(width - 92, 62, 95, 44);
                btnOK.titleLabel.font = [UIFont dq_mediumSystemFontOfSize:16];
                [btnOK addTarget:self action:@selector(onOKClick) forControlEvents:UIControlEventTouchUpInside];
                [border addSubview:btnOK];
            }
            [_alert showViewFromBottom:_logoutView Animated:YES];
        }
            break;
        default:
            break;
    }
}

- (void)initLocalValues
{
    [self.userHeadCell configModel:self.baseUser];
}

- (UITableView *)mTableView
{
    if (!_mTableView) {
        _mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight-49) style:UITableViewStylePlain];
        _mTableView.backgroundColor = [UIColor colorWithHexString:@"#F3F4F5"];
        _mTableView.delegate = self;
        _mTableView.dataSource = self;
        _mTableView.separatorColor = [UIColor clearColor];
        _mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (@available(iOS 11.0, *)) {
            _mTableView.estimatedRowHeight = 0;
            _mTableView.estimatedSectionHeaderHeight = 0;
            _mTableView.estimatedSectionFooterHeight = 0;
            _mTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _mTableView.contentInset = UIEdgeInsetsMake(64,0,0,0);
            _mTableView.scrollIndicatorInsets = _mTableView.contentInset;
        }
    }
    return _mTableView;
}

- (NSArray *)createInfoCell
{
    _userHeadCell = [[DQUserCenterHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"userHeadCellIdentifier"];
    [_userHeadCell configModel:self.baseUser];

    UITableViewCell *topCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"topCellIdentifier"];
    topCell.selectionStyle = UITableViewCellSelectionStyleNone;
    topCell.contentView.backgroundColor = [UIColor colorWithHexString:COLOR_BG];
    topCell.textLabel.text = @"基本";
    topCell.textLabel.font = [UIFont boldSystemFontOfSize:11];
    topCell.textLabel.textColor = [UIColor colorWithHexString:@"707070"];
    topCell.textLabel.textAlignment = NSTextAlignmentLeft;
    MeBaseTableViewCell *userPodfileCell = [[MeBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PodfileCellIdentifier"];
    [userPodfileCell configTitleWithCell:@"个人资料"];
    
    MeBaseTableViewCell *myColleagueCell = [[MeBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"myColleagueCellIdentifier"];
    [myColleagueCell configTitleWithCell:@"项目团队"];
    
    MeBaseTableViewCell *fixPassWordCell = [[MeBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"fixPassWordCellIdentifier"];
    [fixPassWordCell configTitleWithCell:@"修改密码"];
    UITableViewCell *setUpCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"topCellIdentifier"];
    setUpCell.selectionStyle = UITableViewCellSelectionStyleNone;
    setUpCell.contentView.backgroundColor = [UIColor colorWithHexString:COLOR_BG];
    setUpCell.textLabel.text = @"设置";
    setUpCell.textLabel.font = [UIFont boldSystemFontOfSize:11];
    setUpCell.textLabel.textColor = [UIColor colorWithHexString:@"707070"];
    setUpCell.textLabel.textAlignment = NSTextAlignmentLeft;
    
    MeBaseTableViewCell *feedBackCell = [[MeBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"feedBackCellIdentifier"];
    [feedBackCell configTitleWithCell:@"意见反馈"];
    
    MeBaseTableViewCell *serViceCell = [[MeBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"myColleagueCellIdentifier"];
    [serViceCell configTitleWithCell:@"服务条款"];
    
    MeBaseTableViewCell *aboutUsCell = [[MeBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"aboutUsCellIdentifier"];
    [aboutUsCell configTitleWithCell:@"关于我们"];
    
    UITableViewCell *bottomLineCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bottomLineCellIdentifier"];
    bottomLineCell.selectionStyle = UITableViewCellSelectionStyleNone;
    bottomLineCell.contentView.backgroundColor = [UIColor colorWithHexString:COLOR_BG];
    
    UITableViewCell *quitButtonCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"quitButtonCellIdentifier"];
    quitButtonCell.selectionStyle = UITableViewCellSelectionStyleNone;
    quitButtonCell.contentView.backgroundColor = [UIColor whiteColor];
    quitButtonCell.textLabel.text = @"退出登录";
    quitButtonCell.textLabel.font = [UIFont boldSystemFontOfSize:12];
    quitButtonCell.textLabel.font = [UIFont dq_mediumSystemFontOfSize:14];
    quitButtonCell.textLabel.textColor = [UIColor colorWithHexString:@"303030"];
    quitButtonCell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    UITableViewCell *lineCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"lineCellCellIdentifier"];
    lineCell.selectionStyle = UITableViewCellSelectionStyleNone;
    lineCell.contentView.backgroundColor = [UIColor colorWithHexString:COLOR_BG];
    return @[_userHeadCell,topCell,userPodfileCell,myColleagueCell,fixPassWordCell,setUpCell,feedBackCell,serViceCell,aboutUsCell,bottomLineCell,quitButtonCell,lineCell];
}

#pragma mark -退出登录
- (void)dropOutBtnClick
{
    [MobClick event:@"signOutClick"];
//    EMINavigationController *nav = [[EMINavigationController alloc] initWithRootViewController:[NewLoginViewController new]];
//    [self presentViewController:nav animated:true completion:^{
//
//    }];
    UIWindow *window = [AppUtils getAppWindow];
    window.rootViewController = [[EMINavigationController alloc] initWithRootViewController:[NewLoginViewController new]];
    UIApplication *application = [UIApplication sharedApplication];
    [application setApplicationIconBadgeNumber:0];
}

- (void)onOKClick
{
    [_alert dissmissBottom];
    [self dropOutBtnClick];
}

- (void)onCancelClick
{
    [_alert dissmissBottom];
}

#pragma mark - Getter And Setter
- (UIBarButtonItem *)navigationTitle
{
    
    if (!_navigationTitle) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 90, 40)];
        titleLabel.text = @"个人中心";
        titleLabel.font = [UIFont dq_semiboldSystemFontOfSize:18];
        titleLabel.textColor = [UIColor colorWithHexString:@"#1D1D1D"];
       _navigationTitle = [[UIBarButtonItem alloc] initWithCustomView:titleLabel];
    }
    return _navigationTitle;
}

@end
