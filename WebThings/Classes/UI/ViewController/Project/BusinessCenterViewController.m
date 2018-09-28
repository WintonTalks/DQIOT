//
//  BusinessCenterViewController.m
//  WebThings
//
//  Created by machinsight on 2017/6/12.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "BusinessCenterViewController.h"
#import "BusinessCenterCell.h"
#import "AddProjectViewController.h"
#import "DQProjectManangeController.h"
#import "CKAlertView.h"
#import "ProjectListWI.h"
#import "DeleteProjectWI.h"
#import "AddProjectModel.h"
#import "ObtainNumberWI.h"

#import "DQDeviceDetailViewController.h" // 设备详情页面
#import "DQBusinessSearchController.h" // 业务搜索页面
#import <RDVTabBarController/RDVTabBarItem.h> // tabBarItem
#import "DQBusinessInterface.h" // 业务中心接口
#import "WorkDeskViewController.h" // 工作台
#import "DQDropdownMenuView.h"// 概览功能
#import "DQOverView.h" // 日历弹出表灰色背景

#import "CKRippleButton.h"
#import "EMI_MaterialSeachBar.h"
#import "UIColor+Hex.h"
#import "EMINavigationController.h"

#import "DQScannerDocController.h"

/** tabBar的高度，用来调整日历弹出框遮罩 */
// static NSInteger const tabBarHeight = 55;
static NSInteger const headerViewHeight = 49;

@interface BusinessCenterViewController ()
<UITableViewDelegate,
UITableViewDataSource,
UIGestureRecognizerDelegate,
UIScrollViewDelegate,
EMIBaseViewControllerDelegate,
DQDropdownMenuViewDelegate,
MGSwipeTableCellDelegate>
//{
//    NSIndexPath *_swipeIndexPath;
//}
@property(nonatomic, strong) UIView *topCalendarView;
@property(nonatomic, strong) UILabel *dateLabel;
@property(nonatomic, strong) UIImageView *iconImageView;
@property(nonatomic, assign) BOOL isUp;//默认为NO
@property(nonatomic, strong) UIView *dateTableBgView;
@property(nonatomic, strong) UITableView *dateTableView;//时间table,tag:1000
@property(nonatomic, strong) NSMutableArray *dateArray;

@property(nonatomic, strong) UITableView *mainTableView;
@property(nonatomic, strong) NSMutableArray <AddProjectModel *> *dataArray;
@property(nonatomic, strong) NSMutableArray <AddProjectModel *> *searchArray;
/** 概览数据数组 */
@property(nonatomic, strong) NSMutableArray <AddProjectModel *> *projectAry;

/** 添加新项目 */
@property(nonatomic, strong) UIButton *newProjectBtn;
/** 头部view */
@property(nonatomic, strong) UIView *headerView;
/** tabBar的遮罩，用来调整日历弹出框遮罩 */
@property(nonatomic, strong) UIWindow *keyWindow;
/** 导航条上title(返回按钮)的标签 */
@property(nonatomic, strong) UILabel *leftTitleLabel;
/** 导航条上的 搜索 */
@property(nonatomic, strong) UIButton *searchBtn;
/** 导航条上的 消息 */
@property(nonatomic, strong) UIButton *messageBtn;
/** 搜索栏 */
@property(nonatomic, strong) EMI_MaterialSeachBar *searchBar;
@property(nonatomic, strong) UIView *topView;
@property(nonatomic, strong) UIBarButtonItem *navigationTitle;
@property(nonatomic, strong) UIBarButtonItem *rightNavBtn;
@property(nonatomic, strong) UIBarButtonItem *rightNavBtns;
/** 日历弹出框遮罩 */
@property(nonatomic, strong) DQOverView *overView;
/** 概览菜单 */
@property(nonatomic, strong) DQDropdownMenuView *dropDownView;
/** 当前页面是否展开概览菜单 默认NO */
@property(nonatomic, assign) BOOL isShowDropView;
@end

@implementation BusinessCenterViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];

    [self initArr];
    [self initView];
    [self initNav];
    self.view.backgroundColor = [UIColor colorWithHexString:COLOR_BG];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    // 隐藏导航条
    // [self.navigationController setNavigationBarHidden:YES];

    // KVO
    [self addObserver:self forKeyPath:@"dataArray" options:NSKeyValueObservingOptionNew context:nil];
    if (!_dataArray) {
        self.dataArray = [NSMutableArray array];
        self.searchArray = [NSMutableArray array];
    }
    
    // 获取工程项目列表
    [self fetchProjectList];
    // 概览网络请求
    [self fetchProjectOverView];
    // 获取消息数量
    [self fetchWorkbenchMessageNumber];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // 移除KVO
    [self removeObserver:self forKeyPath:@"dataArray"];
}

- (void)initArr
{
//    _swipeIndexPath = nil;
    _dateArray = [NSMutableArray array];
    for (int i = 0; i < 24; i++) {
        [_dateArray addObject:[DateTools pointedTimeDicWithCount:-i]];
    }
}

- (void)initView
{
    // 导航栏下留下5像素的空白，让导航条给人69的错觉
    UIView *topMarginView = [[UIView alloc] init];
    topMarginView.frame = CGRectMake(0, 64, screenWidth, 5);
    topMarginView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topMarginView];
    
    [self.view addSubview:self.mainTableView];
    [self.overView addSubview:self.dateTableBgView];
    
    self.topView = [[UIView alloc] init];
    self.topView.frame = CGRectMake(0, 69, screenWidth, headerViewHeight+5);
    self.topView.backgroundColor = [UIColor colorWithHexString:COLOR_BG];
    [self.view insertSubview:self.topView aboveSubview:self.mainTableView];
    [self.topView addSubview:self.topCalendarView];
    if ([self isZuLin] && ![self isCEO]) {
        // 添加项目按钮
        [self.topView addSubview:self.newProjectBtn];
        [self.newProjectBtn layoutButtonWithEdgeInsetsStyle:TQButtonEdgeInsetsStyleRight imageTitleSpace:8];
    }
}

- (void)initNav {
    
    if (self.isCEO) {
        self.navigationItem.rightBarButtonItem = self.rightNavBtn;
    } else {
        self.navigationItem.rightBarButtonItem = self.rightNavBtns;
    }
    self.navigationItem.leftBarButtonItem = self.navigationTitle;
    // 配置导航条
    //[EMINavigationController addAppBar:self shadowColor:[UIColor whiteColor]];
    
    // 设置导航栏中间的标题按钮
    [self setupNavBarCenterView];
  
}

/** 概览nav view */
- (void)setupNavBarCenterView {
    
    _dropDownView = [[DQDropdownMenuView alloc] initWithFrame:CGRectMake(0, 20,80, 40)];
    _dropDownView.delegate = self;
    self.navigationItem.titleView = _dropDownView;
}

#pragma mark - Private Methods
- (void)navBarButtonItemStatus:(CGFloat)alphaValue
{
    
    if (self.isCEO) {
        _leftTitleLabel.alpha = alphaValue;
        _searchBtn.alpha = alphaValue;
    } else {
        _leftTitleLabel.alpha = alphaValue;
        _searchBtn.alpha = alphaValue;
        _messageBtn.alpha = alphaValue;
    }
}

/** 搜索 */
- (void)searchProject
{
//    DQScannerDocController *ctl = [[DQScannerDocController alloc] init];
//    [self.navigationController pushViewController:ctl animated:YES];

    [MobClick event:@"business_search"];

    DQBusinessSearchController *searchView = [[DQBusinessSearchController alloc] init];
    searchView.dateArray = _searchArray;
    [self.navigationController pushViewController:searchView animated:YES];
}

/** 工作台  */
- (void)workbenchMessage
{
    [MobClick event:@"business_workbench"];
    WorkDeskViewController *VC = [AppUtils VCFromSB:@"Work" vcID:@"WorkDeskVC"];
    [self.navigationController pushViewController:VC animated:YES];
}

/** 日期选择表 */
- (void)hideCalendarPopView
{
    if (_isUp) {
        _isUp = NO;
        [self calendarTableViewStatus];
    }
}

- (void)topCalendarViewTapped {
    
    [MobClick event:@"business_calendar_table"];
    
    _isUp = !_isUp;
    [self calendarTableViewStatus];
}

- (void)calendarTableViewStatus
{
    [UIView animateWithDuration:0.3 animations:^{
        if (_isUp) {
            _headerView.backgroundColor = [UIColor whiteColor];
            _iconImageView.transform = CGAffineTransformMakeRotation(M_PI);
                        [self.overView show];
        } else {
            _headerView.backgroundColor = [UIColor colorWithHexString:COLOR_BG];
            _iconImageView.transform = CGAffineTransformMakeRotation(0);
            [self.overView dismiss];
        }
        _topView.backgroundColor = _headerView.backgroundColor;
    }];
}

- (void)onAddNewProjectClick
{
    [self hideCalendarPopView];
    
    [MobClick event:@"business_add_project"];
    
    self.pushType = 3;
    AddProjectViewController *projectVC = [AddProjectViewController new];
    projectVC.basedelegate = self;
    projectVC.pushType = 3;
    projectVC.isNew = 0;
    [self.navigationController pushViewController:projectVC animated:true];
}

#pragma mark - DQDropdownMenuViewDelegate
- (void)dropdownMenuItemWillPushViewWithProject:(AddProjectModel *)model deviceType:(DeviceTypeModel *)device {
    
    self.isShowDropView = YES;
    
    DQDeviceDetailViewController *deviceView = [[DQDeviceDetailViewController alloc] init];
    deviceView.device = device;
    deviceView.project = model;
    [self.navigationController pushViewController:deviceView animated:true];
}

- (void)dropdownMenuWillShowView:(DQDropdownMenuView *)menuView {
    _dropDownView.projectAry = self.projectAry;
    
    [self hideCalendarPopView];
    [self navBarButtonItemStatus:0.0];
}

- (void)dropdownMenuWillDismissView:(DQDropdownMenuView *)menuView {
    [self navBarButtonItemStatus:1.0];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView.tag == 1000) {
        return 1;
    } else {
        return _searchArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView.tag == 1000) {
        return 0;
    } else {
        return headerViewHeight;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 1000) {
        return _dateArray.count;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 1000) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"timeTableCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"timeTableCell"];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.font = [UIFont dq_regularSystemFontOfSize:16.f];
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
        }
        
        NSString *date = [_dateArray[indexPath.row] allKeys][0];
        cell.textLabel.text = [NSString stringWithFormat:@"%@",date];
        return cell;
    } else {
        BusinessCenterCell *cell = [BusinessCenterCell cellWithTableView:tableView];
        if (tableView.tag != 1000 && [self isZuLin] && ![self isCEO]) {
            cell.delegate = self;
        } else {
            cell.delegate = nil;
        }
        [cell setViewWithValues:[_searchArray safeObjectAtIndex:indexPath.section]];
        return cell;
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section != 0) { return nil;}
    
    UIView *headerView = [[UIView alloc] init];
    headerView.frame = CGRectMake(0, 0, screenWidth, headerViewHeight);
    headerView.backgroundColor = [UIColor colorWithHexString:COLOR_BG];
    self.headerView = headerView;
    return headerView;
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    view.tintColor = [UIColor colorWithHexString:COLOR_BG];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1000) {
        return 44;
    } else {
        return 224;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1000) {
        _isUp = NO;
        [self calendarTableViewStatus];
        NSDictionary *dic = _dateArray[indexPath.row];
        _dateLabel.text = [dic objectForKey:[dic allKeys][0]];
        [_dateLabel sizeToFit];

        [self fetchProjectList];
    } else {
        DQProjectManangeController *VC = [DQProjectManangeController new];
        AddProjectModel *m = (AddProjectModel *)_searchArray[indexPath.section];
        VC.projectid = m.projectid;
        VC.drivertype = m.drivertype;
        VC.projectModel = m;
        [self.navigationController pushViewController:VC animated:YES];
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

- (BOOL)swipeTableCell:(MGSwipeTableCell*)cell
   tappedButtonAtIndex:(NSInteger)index
             direction:(MGSwipeDirection)direction
         fromExpansion:(BOOL)fromExpansion
{
    if (direction == MGSwipeDirectionRightToLeft) {
        NSIndexPath *indexPath = [self.mainTableView indexPathForCell:cell];
        if (index == 0) { //删除
            [MobClick event:@"business_delete_project"];
            UIAlertAction *infoAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self fetchDeleteProject:indexPath.section];
            }];
            [infoAction setValue:[UIColor colorWithHexString:COLOR_TITLE_GRAY] forKey:@"titleTextColor"];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [cancelAction setValue:[UIColor colorWithHexString:COLOR_BLUE] forKey:@"titleTextColor"];
            
            NSString *text = @"是否删除项目？";
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
            return false;
        } else {//编辑
            [MobClick event:@"business_modify_project"];
            AddProjectViewController *projectVC = [[AddProjectViewController alloc] init];
            projectVC.isNew = 1;
            projectVC.pmodel = [_searchArray safeObjectAtIndex:indexPath.section];
            projectVC.basedelegate = self;
            [self.navigationController pushViewController:projectVC animated:true];
            return false;
        }
    }
    return true;
}

- (NSArray *)createRightButtons
{
    NSMutableArray * result = [NSMutableArray array];
    UIColor *color = [UIColor  clearColor]; 
    NSArray *images = @[ImageNamed(@"icon_delete"),ImageNamed(@"icon_CellEdit")];
    for (int i = 0; i < 2; ++i)
    {
        MGSwipeButton * button = [MGSwipeButton buttonWithTitle:@"" icon:[images safeObjectAtIndex:i] backgroundColor:color padding:20];
        button.width = 80.f;
        [result safeAddObject:button];
    }
    return result;
}

CGFloat historyY;
CGFloat currentPosition;
CGFloat lastPosition;
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    historyY = scrollView.contentOffset.y;
    //DQLog(@"scrollView.contentOffset.y: %f",scrollView.contentOffset.y);
}

//去掉UItableview headerview黏性(sticky)
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    //DQLog(@"scrollView.contentOffset.y: %f",scrollView.contentOffset.y);
    
    if (scrollView == self.mainTableView) {
        
        CGRect tableViewFrame = _mainTableView.frame;
        {
            CGFloat sectionHeaderHeight = headerViewHeight;
            if (scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y >= 0) {
                scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
            } else if (scrollView.contentOffset.y >= sectionHeaderHeight) {
                scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
            }
        }
        
        {
            if (scrollView.contentOffset.y <= historyY) {
                
                //DQLog(@" <= historyY:%f",scrollView.contentOffset.y);
                _topView.frame = CGRectMake(0, 69+(-scrollView.contentOffset.y), screenWidth, headerViewHeight);
                tableViewFrame = CGRectMake(0, 69, screenWidth, screenHeight-69-50);
            } else if (scrollView.contentOffset.y > historyY) {
                
                //DQLog(@" >= historyY:%f",scrollView.contentOffset.y);
                _topView.frame = CGRectMake(0, 69, screenWidth, headerViewHeight);
                tableViewFrame = CGRectMake(0, 69, screenWidth, screenHeight-(self.navigationBarHeight+50));
            }
            _mainTableView.frame= tableViewFrame;
        }
        
        {
            currentPosition = scrollView.contentOffset.y;
            if(currentPosition > lastPosition) {
                //DQLog(@"Scroll Up");
            } else {
                //DQLog(@"Scroll Down");
                if (currentPosition >= 0) {
                    _topView.frame = CGRectMake(0, 69, screenWidth, headerViewHeight);
                }
            }
            lastPosition = currentPosition;
        }
        
        {
            [NSObject cancelPreviousPerformRequestsWithTarget:self];
            [self performSelector:@selector(scrollViewDidEndScrollingAnimation:) withObject:scrollView afterDelay:0.0001];
        }
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    //DQLog(@" stop scroll: %f",scrollView.contentOffset.y);
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    if (scrollView.contentOffset.y >= 0) {
        _topView.frame = CGRectMake(0, 69, screenWidth, headerViewHeight);
        _mainTableView.frame = CGRectMake(0, 69, screenWidth, screenHeight-self.navigationBarHeight-50);
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    //DQLog(@"%@",NSStringFromClass(object_getClass(touch.view)));
    if ([NSStringFromClass(object_getClass(touch.view)) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
}

#pragma mark - KVO回调
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    if (![keyPath isEqualToString:@"dataArray"]) {
        return;
    }
    
    if ([self.dataArray count]==0) { // 无数据
        [[BJNoDataView shareNoDataView] showCenterWithSuperView:self.view icon:@"ic_empty01" Frame:CGRectMake(0, 0, screenWidth, screenHeight) iconClicked:^{
            //图片点击回调
            // [self loadData]; // 刷新数据
            [self fetchProjectList];
        } WithText:@"暂时没有可查询的项目"];
        self.mainTableView.hidden  = YES;
        return;
    }
    //有数据
    [[BJNoDataView shareNoDataView] clear];
    self.mainTableView.hidden  = NO;
}

/** 刷新数据 */
- (void)loadData
{
    NSMutableArray*projectAry=[[NSMutableArray alloc] init];
    for (int i=0; i<2; i++) {
        AddProjectModel *model = [[AddProjectModel alloc] init];
        [projectAry addObject:model];
        //[self.dataArray addObject:[NSString stringWithFormat:@"第%d条数据",i]];//不会触发KVO
    }
    self.dataArray = projectAry;//数组指针改变 触发KVO
    self.searchArray = self.dataArray;
    [_mainTableView reloadData];
}

#pragma mark - 下拉刷新
- (void)loadNewData:(CKRefreshHeader *)sender {
    [self fetchProjectList];
}

#pragma mark - Http
/// 获取项目列表
- (void)fetchProjectList {
    
    NSString *cdate = [DateTools getpointerTimeStrWithFormat:@"yyyy/MM" WithOriginStr:_dateLabel.text WithOrignFormat:@"yyyy/MM"];
    
    [[DQBusinessInterface sharedInstance] dq_getProjectListWithMonth:cdate success:^(id returnValue) {
        [_mainTableView.mj_header endRefreshing];
        self.dataArray = returnValue;
        _searchArray = _dataArray;
        [_mainTableView reloadData];
    } failture:^(NSError *error) {
        [_mainTableView.mj_header endRefreshing];
    }];
}

- (void)fetchDeleteProject:(NSInteger)index
{
    DeleteProjectWI *lwi = [[DeleteProjectWI alloc] init];
    AddProjectModel *tempM = (AddProjectModel *)[_searchArray safeObjectAtIndex:index];
    NSArray *arr = @[@(self.baseUser.userid),self.baseUser.type,@(tempM.projectid),self.baseUser.usertype];
    NSDictionary *param = [lwi inBox:arr];
    [CKNetTools requestWithRequestType:POST WithURL:lwi.fullUrl WithParamater:param WithProgressBlock:^(NSProgress *process) {
        
    } WithSuccessBlock:^(id returnValue) {
        NSArray *temp = [lwi unBox:returnValue];
        if ([temp[0] integerValue] == 1) {
            //成功
            MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"删除成功" actionTitle:@"" duration:2.0];
            [t show];
            //刷新表格
            [self.dataArray removeObjectAtIndex:index];
            _searchArray = _dataArray;
            if (self.dataArray.count == 0) {
                self.dataArray = [NSMutableArray array];//为了触发kvc，显示无数据时的图
            }
            [_mainTableView reloadData];
        }
        
    } WithFailureBlock:^(NSError *error) {
    }];
}

/** 获取工作台消息数量 */
- (void)fetchWorkbenchMessageNumber
{
    /**
     [[DQBusinessInterface sharedInstance] dq_getWorkbenchMessageCountSuccess:^(id result) {
     } failture:^(NSError *error) {
     }];
     
     */
    
    ObtainNumberWI *lwi = [[ObtainNumberWI alloc] init];
    NSArray *arr = @[@(self.baseUser.userid),self.baseUser.type,self.baseUser.usertype];
    NSDictionary *param = [lwi inBox:arr];
    [CKNetTools requestWithRequestType:POST WithURL:lwi.fullUrl WithParamater:param WithProgressBlock:^(NSProgress *process) {
        
    } WithSuccessBlock:^(id returnValue) {
        NSArray *temp = [lwi unBox:returnValue];
        if ([temp[0] integerValue] == 1) {
            NSInteger num = [temp[1] integerValue];
            UIApplication *application = [UIApplication sharedApplication];
            if (num != 0) {
                [self configBadgeNumber:num];
                [application setApplicationIconBadgeNumber:num];
            } else {
                [_messageBtn pp_hiddenBadge];
                [application setApplicationIconBadgeNumber:0];
                [[self rdv_tabBarItem] setBadgeValue:[NSString stringWithFormat:@""]];
            }
        }
        
    } WithFailureBlock:^(NSError *error) {
        
    }];
}

- (void)fetchProjectOverView
{
    [[DQBusinessInterface sharedInstance]
     dq_getDataListWithMonth:nil
     success:^(id result) {
         self.projectAry = [NSObject changeType:result];
         if (self.isShowDropView) {
             self.isShowDropView = NO;
             [self.dropDownView showMenu];
         }
     } failture:^(NSError *error) {
     }];
}

- (void)configBadgeNumber:(NSInteger)number
{
    NSString *mesCount = number > 99 ? @"99+" : [NSString stringWithFormat:@"%ld",number];
    [_messageBtn pp_addBadgeWithText:mesCount];
    [_messageBtn pp_setBadgeHeightPoints:15];
    [_messageBtn pp_moveBadgeWithX:-4 Y:2];
    [_messageBtn pp_setBadgeLabelAttributes:^(PPBadgeLabel *badgeLabel) {
        badgeLabel.backgroundColor = [UIColor redColor];
        badgeLabel.font =  [UIFont dq_mediumSystemFontOfSize:13];
        badgeLabel.textColor = [UIColor whiteColor];
        if ([badgeLabel.text isEqualToString:@"99+"]) {
            badgeLabel.font =  [UIFont dq_regularSystemFontOfSize:12];
        }
    }];
    
    [[self rdv_tabBarItem] setBadgeTextFont:[UIFont systemFontOfSize:5]];
    [[self rdv_tabBarItem] setBadgePositionAdjustment:UIOffsetMake(-5, 3)];
    [[self rdv_tabBarItem] setBadgeValue:[NSString stringWithFormat:@" "]];
}

#pragma basedelegate
- (void)didPopFromNextVC
{
    [self fetchProjectList];
}

#pragma mark - Getter
- (UIButton *)newProjectBtn
{
    if (!_newProjectBtn) {
        _newProjectBtn = [[UIButton alloc] init];
        _newProjectBtn.frame = CGRectMake(screenWidth-90, 10, 80, 35);
        _newProjectBtn.titleLabel.font = [UIFont dq_regularSystemFontOfSize:12];
        [_newProjectBtn setTitle:@"添加项目" forState:UIControlStateNormal];
        [_newProjectBtn setTitleColor:[UIColor colorWithHexString:COLOR_BLACK] forState:UIControlStateNormal];
        [_newProjectBtn setImage:[UIImage imageNamed:@"ic_business_device"] forState:UIControlStateNormal];
        [_newProjectBtn addTarget:self action:@selector(onAddNewProjectClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _newProjectBtn;
}

- (UIView *)topCalendarView
{
    if (!_topCalendarView) {
        _isUp = NO;
        _topCalendarView = [[UIView alloc] initWithFrame:CGRectMake(16, 0, 120, 36)];
        _topCalendarView.centerY = 25;
        [_topCalendarView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(topCalendarViewTapped)]];
        // 日历icon
        UIImageView *calendarIconV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"business_calendar_icon"]];
        calendarIconV.frame = CGRectMake(0, 9, 19, 19);
        calendarIconV.centerY = 18;
        [_topCalendarView addSubview:calendarIconV];
        
        // 日期标签（年／月）
        if (!_dateLabel) {
            _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 9, _topCalendarView.width-36, 19)];
            _dateLabel.centerY = 18;
            _dateLabel.font = [UIFont dq_semiboldSystemFontOfSize:16];
            _dateLabel.textColor = [UIColor colorWithHexString:COLOR_BLACK];
            _dateLabel.text = [DateTools dateTopointedString:[NSDate date] format:@"yyyy/MM"];
            [_topCalendarView addSubview:_dateLabel];
        }
        
        // 选择器折叠指示icon
        if (!_iconImageView) {
            _iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_down"]];
            _iconImageView.frame = CGRectMake(_topCalendarView.frame.size.width - 10, calendarIconV.centerY, 9, 6);
            _iconImageView.centerY = _dateLabel.centerY;
            [_topCalendarView addSubview:_iconImageView];
        }
    }
    return _topCalendarView;
}

- (UIView *)dateTableBgView { // 时间选择器背景
    
    if (!_dateTableBgView) {
        _dateTableBgView = [[UIView alloc] init];
        _dateTableBgView.frame = CGRectMake( -1, -1, 169, 224);
        _dateTableBgView.userInteractionEnabled = YES;
        
        _dateTableView = [[UITableView alloc] init];
        _dateTableView.tag = 1000;
        _dateTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _dateTableView.delegate = self;
        _dateTableView.dataSource = self;
        _dateTableView.showsVerticalScrollIndicator = YES;
        _dateTableView.frame = CGRectMake(1, 1, 167, 222);
        [_dateTableBgView addSubview:_dateTableView];
    }
    return _dateTableBgView;
}

- (UITableView *)mainTableView {
    
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.navigationBarHeight+5, screenWidth,
                                                                       screenHeight-self.navigationBarHeight-50)];
        _mainTableView.tag = 2000;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.backgroundColor = [UIColor clearColor];
        _mainTableView.mj_header = [CKRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData:)];
        // [_mainTableView.mj_header beginRefreshing];
    }
    return _mainTableView;
}

#pragma mark  Nav
- (UIBarButtonItem *)navigationTitle {
    
    if (!_navigationTitle) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 90, 40)];
        titleLabel.text = @"项目中心";
        titleLabel.font = [UIFont dq_semiboldSystemFontOfSize:18];
        titleLabel.textColor = [UIColor colorWithHexString:@"#1D1D1D"];
        _navigationTitle = [[UIBarButtonItem alloc] initWithCustomView:titleLabel];
        _leftTitleLabel = titleLabel;
    }
    return _navigationTitle;
}

- (UIBarButtonItem *)rightNavBtn {
    
    if (!_rightNavBtn) {
        UIView *rightBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 70, 40)];
        rightBarView.backgroundColor = [UIColor clearColor];
        _searchBtn = [[UIButton alloc] init];
        [_searchBtn addTarget:self action:@selector(searchProject) forControlEvents:UIControlEventTouchUpInside];
        [_searchBtn setBackgroundImage:[UIImage imageNamed:@"business_nav_search_icon"] forState:UIControlStateNormal];
        _searchBtn.frame = CGRectMake(40, 10, 20, 20);
        [rightBarView addSubview:_searchBtn];
       
        _rightNavBtn = [[UIBarButtonItem alloc] initWithCustomView:rightBarView];
    }
    return _rightNavBtn;
}

- (UIBarButtonItem *)rightNavBtns {
    
    if (!_rightNavBtns) {
        UIView *rightBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 70, 40)];
        rightBarView.backgroundColor = [UIColor clearColor];
        _searchBtn = [[UIButton alloc] init];
        [_searchBtn addTarget:self action:@selector(searchProject) forControlEvents:UIControlEventTouchUpInside];
        [_searchBtn setBackgroundImage:[UIImage imageNamed:@"business_nav_search_icon"] forState:UIControlStateNormal];
        _searchBtn.frame = CGRectMake(5, 10, 20, 20);
        [rightBarView addSubview:_searchBtn];
        
        _messageBtn = [[UIButton alloc] init];
        [_messageBtn addTarget:self action:@selector(workbenchMessage) forControlEvents:UIControlEventTouchUpInside];
        [_messageBtn setBackgroundImage:[UIImage imageNamed:@"business_nav_mes_icon"] forState:UIControlStateNormal];
        _messageBtn.frame = CGRectMake(45, 10, 20, 20);
        [rightBarView addSubview:_messageBtn];
        
        _rightNavBtns = [[UIBarButtonItem alloc] initWithCustomView:rightBarView];
    }
    return _rightNavBtns;
}

- (DQOverView *)overView {
    
    if (!_overView) {
        
        _overView = [[DQOverView alloc] initWithFrame:CGRectMake(0, self.navigationBarHeight+headerViewHeight, screenWidth, screenHeight-self.navigationBarHeight-headerViewHeight)];
        // 隐藏日期选择表的手势
        UITapGestureRecognizer *hideCalendarGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideCalendarPopView)];
        hideCalendarGesture.delegate = self;
        [_overView addGestureRecognizer:hideCalendarGesture];
    }
    return _overView;
}

@end
