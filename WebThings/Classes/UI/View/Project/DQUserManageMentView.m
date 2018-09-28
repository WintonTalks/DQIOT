//
//  DQUserManageMentView.m
//  WebThings
//
//  Created by 孙文强 on 2017/9/29.
//  Copyright © 2017年 machinsight. All rights reserved.
//  项目管理-人员管理

#import "DQUserManageMentView.h"
#import "DQProjectUserTitleView.h"
#import "DQDeriveManagerCell.h"

@interface DQUserManageMentView()
<DQProjectUserTitleViewDelegate,
DQDeriveManagerCellDelegate,
UITableViewDelegate,
UITableViewDataSource,
MGSwipeTableCellDelegate>
{
    DQDeriveManagerCell *_selectedCell;
    UILabel *_workNumberLabel;
    UIButton *_addUserBtn;
    CGFloat _offY;
}
@property (nonatomic, strong) DQProjectUserTitleView *userTitleView;
@property (nonatomic, strong) UIView *adjuNewUserView; //添加人员
@property (nonatomic, strong) UITableView *mTableView;
@property (nonatomic, strong) NSMutableArray *infoArray;
@end

@implementation DQUserManageMentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addInfoManagerView];
    }
    return self;
}

- (void)addInfoManagerView
{
    _userTitleView = [[DQProjectUserTitleView alloc] initWithFrame:CGRectMake(0, 8, self.width, 83) manageInfoViewType:KDQProjectManageTopSelectedStyle];
    _userTitleView.delegate = self;
    [self addSubview:_userTitleView];
    [self addSubview:self.adjuNewUserView];
    [self addSubview:self.mTableView];
}

//判断是否租订商,CEO只能看看，无操作权限
- (void)addManageDeriveUserButton
{
    _addUserBtn.hidden = true;
}

#pragma mark- UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.infoArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DriverModel *model = [self.infoArray safeObjectAtIndex:indexPath.section];
    return [self cellForHeightWithModel:model];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 8.5f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.mTableView.width, 8.5)];
    headerView.backgroundColor = [UIColor colorWithHexString:@"#F3F4F5"];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellWithIdentifier = [NSString stringWithFormat:@"ManagerCellIdentifier-%ld",indexPath.section];
    DQDeriveManagerCell *cell = [tableView dequeueReusableCellWithIdentifier:cellWithIdentifier];
    if (!cell) {
        cell = [[DQDeriveManagerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellWithIdentifier];
        BOOL isCEO = [self.delegate didUserManageExpandIsCEO];
        cell.delegate = isCEO ? self : nil;
        cell.mDelegate = self;
    }
    cell.indexMangerPath = indexPath;
    DriverModel *model = [self.infoArray safeObjectAtIndex:indexPath.section];
    [cell configDeriveManagerData:model projectName:self.projectName];
    return cell;
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

-(BOOL)swipeTableCell:(MGSwipeTableCell*)cell
  tappedButtonAtIndex:(NSInteger)index
            direction:(MGSwipeDirection)direction
        fromExpansion:(BOOL)fromExpansion
{
    if (direction == MGSwipeDirectionRightToLeft) {
        NSIndexPath *indexPath = [self.mTableView indexPathForCell:cell];
        [self swipeDeleteAction:indexPath];
    }
    return false;
}

- (NSArray *)createRightButtons
{
    UIColor *color = [UIColor colorWithHexString:@"#F3F4F5"];
    MGSwipeButton *button = [MGSwipeButton buttonWithTitle:@"" icon:ImageNamed(@"icon_delete") backgroundColor:color padding:20];
    button.width = 80.f;
    return @[button];
}

- (void)swipeDeleteAction:(NSIndexPath *)indexPath
{
    UIAlertAction *infoAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self fetchRemoveUserAPI:indexPath.section];
    }];
    [infoAction setValue:[UIColor colorWithHexString:COLOR_TITLE_GRAY] forKey:@"titleTextColor"];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [cancelAction setValue:[UIColor colorWithHexString:COLOR_BLUE] forKey:@"titleTextColor"];
    
    NSString *text = @"是否删除人员信息？";
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

///删除人员
- (void)fetchRemoveUserAPI:(NSInteger)index
{
    DriverModel *model = [self.infoArray safeObjectAtIndex:index];
    [[DQProjectInterface sharedInstance] dq_getDeleteNewUser:self.projectID workerid:model.workcategoryid success:^(id result) {
        [_infoArray safeRemoveObjectAtIndex:index];
        [self.mTableView reloadData];
    } failture:^(NSError *error) {
        
    }];
}

//引导进来的相册图片，多张/单张
- (void)configAlubmPhoto:(NSArray *)listArray
{
    NSIndexPath *indexPath = [self.mTableView indexPathForCell:_selectedCell];
    DriverModel *model = [self.infoArray safeObjectAtIndex:indexPath.section];
    model.photoList = listArray.mutableCopy;
    [self.mTableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
}

//添加人员
- (void)configUserListClicked:(NSMutableArray *)result
{
    NSString *text = [NSString stringWithFormat:@"特种作业总人数: %ld人",result.count];
    CGFloat width = [AppUtils textWidthSystemFontString:text height:12 font:_workNumberLabel.font];
    _workNumberLabel.text = text;
    _workNumberLabel.width = width;
    
    [self.infoArray removeAllObjects];
    self.infoArray = result;
    [self.mTableView reloadData];
}

#pragma mark-DQProjectUserTitleViewDelegate
- (void)didProjectUserMentView:(DQProjectUserTitleView *)titleView
                          type:(DQProjectUserTitleViewType)type
{
    switch (type) {
        case KDQProjectUserAttendanceStyle:{
            [self.delegate didManageMentView:self index:1 type:KDQUserManageMentViewStyle userModel:nil];
        } break;
        case KDQProjectUserQualificationStyle:{
            [self.delegate didManageMentView:self index:2 type:KDQUserManageMentViewStyle userModel:nil];
        } break;
        case KDQProjectUserTrainingStyle:{
            [self.delegate didManageMentView:self index:3 type:KDQUserManageMentViewStyle userModel:nil];
        } break;
        case KDQProjectUserEvaluationStyle:{
            [self.delegate didManageMentView:self index:4 type:KDQUserManageMentViewStyle userModel:nil];
        } break;
        default:
            break;
    }
}

- (void)didDeriveMentClick:(DQDeriveManagerCell *)managerCell
                     index:(NSInteger)index
{
    _selectedCell = managerCell;
    NSIndexPath *indexPath = [self.mTableView indexPathForCell:managerCell];
    DriverModel *model = [self.infoArray safeObjectAtIndex:indexPath.section];
    switch (index) {
        case 1:{
            [self.delegate didManageMentView:self index:1 type:KDQUserManageInfoCellStyle userModel:model];
        } break;
        case 2:{
            [self.delegate didManageMentView:self index:2 type:KDQUserManageInfoCellStyle userModel:model];
        } break;
        case 3:{
            [self.delegate didManageMentView:self index:3 type:KDQUserManageInfoCellStyle userModel:model];
        } break;
        case 4:{
            [self.delegate didManageMentView:self index:4 type:KDQUserManageInfoCellStyle userModel:model];
        } break;
        default:
            break;
    }
}

//人员权限设置
- (void)didFixUserOperAuth:(DQDeriveManagerCell *)managerCell
              deriveWorkID:(NSInteger)workID
                    isAuth:(BOOL)isAuth
{
    NSInteger permiss = isAuth ? 1 : 0;
    [[DQProjectInterface sharedInstance] dq_getPersonPermissions:self.projectID workerid:workID authpermission:permiss success:^(id result) {
        if (result) {
            MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"人员权限修改成功" actionTitle:@"" duration:3.0];
            [t show];
        }
    } failture:^(NSError *error) {
        
    }];
}

//编辑司机
- (void)didPushEditDeriveClicked:(DQDeriveManagerCell *)managerCell
                           index:(NSInteger)index
{
    DriverModel *model = [self.infoArray safeObjectAtIndex:index];
    [self.delegate didEditUserFixClicked:self userModel:model];
}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (velocity.y < 0) {
        self.userTitleView.top = 8;
        self.adjuNewUserView.top = self.userTitleView.bottom;
        self.mTableView.top = self.adjuNewUserView.bottom;
        self.mTableView.height = self.height-self.adjuNewUserView.bottom;
    } else {
        self.userTitleView.top = -91;
        self.adjuNewUserView.top = 8;
        self.mTableView.top = self.adjuNewUserView.bottom;
        self.mTableView.height = self.height-self.adjuNewUserView.bottom;
    }
}

#pragma mark -UI
- (UITableView *)mTableView
{
    if (!_mTableView) {
        _mTableView = [[UITableView alloc] initWithFrame:CGRectMake(10, self.adjuNewUserView.bottom, self.width-20, self.height-self.adjuNewUserView.bottom) style:UITableViewStylePlain];
        _mTableView.backgroundColor = [UIColor colorWithHexString:@"#F3F4F5"];
        _mTableView.delegate = self;
        _mTableView.dataSource = self;
        _mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mTableView.tableFooterView = [UIView new];
        _mTableView.showsVerticalScrollIndicator = false;
        if (@available(iOS 11.0, *)) {
            _mTableView.estimatedRowHeight = 0;
            _mTableView.estimatedSectionHeaderHeight = 0;
            _mTableView.estimatedSectionFooterHeight = 0;
            _mTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _mTableView;
}

- (UIView *)adjuNewUserView
{
    if (!_adjuNewUserView) {
        _adjuNewUserView = [[UIView alloc] initWithFrame:CGRectMake(0, self.userTitleView.bottom, self.width, 44)];
        _adjuNewUserView.backgroundColor = [UIColor  clearColor];
        _adjuNewUserView.userInteractionEnabled = true;
       
        _workNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 15, 0, 12)];
//        _workNumberLabel.text = text;
        _workNumberLabel.font = [UIFont dq_semiboldSystemFontOfSize:12];
        _workNumberLabel.textAlignment = NSTextAlignmentLeft;
        [_adjuNewUserView addSubview:_workNumberLabel];

        _addUserBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _addUserBtn.frame = CGRectMake(_adjuNewUserView.width-8-80, 5, 80, 35);
        _addUserBtn.titleLabel.font = [UIFont dq_mediumSystemFontOfSize:12];
        [_addUserBtn setTitleColor:[UIColor colorWithHexString:COLOR_BLACK] forState:UIControlStateNormal];
        [_addUserBtn setTitle:@"添加人员" forState:UIControlStateNormal];
        [_addUserBtn setImage:ImageNamed(@"ic_business_device") forState:UIControlStateNormal];
        _addUserBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -_addUserBtn.imageView.bounds.size.width, 0, _addUserBtn.imageView.width+6);
        _addUserBtn.imageEdgeInsets = UIEdgeInsetsMake(0, _addUserBtn.titleLabel.width, 0, -_addUserBtn.titleLabel.bounds.size.width);
        [_addUserBtn addTarget:self action:@selector(onNewUserClick) forControlEvents:UIControlEventTouchUpInside];
        [_adjuNewUserView addSubview:_addUserBtn];
    }
    return _adjuNewUserView;
}

- (void)onNewUserClick
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didAddNewUserMentView:)]) {
        [self.delegate didAddNewUserMentView:self];
    }
}

- (CGFloat)cellForHeightWithModel:(DriverModel *)model
{
    if (!model.credentials.length) {
        return 430.f;
    }
    NSInteger count = model.photoList.count/2;
//    if ([model.credentials dq_rangeOfStringWithLocation:@","]) {
//        NSMutableString *picString = [NSMutableString stringWithFormat:@"%@",model.credentials];
//        NSArray *comlpeArr = [picString componentsSeparatedByString:@","];
//        count =  comlpeArr.count%2==0 ? comlpeArr.count/2 : comlpeArr.count/2+1;
//    } else {
//        count = 1;
//    }
    CGFloat configHeight = 430.f; //基本高度
    CGFloat photoHeight = 89;//引入图片的计算高度
    if (count > 0) {
        photoHeight = count*88;
    }
    return configHeight+photoHeight;
}

- (NSMutableArray *)infoArray
{
    if (!_infoArray) {
        _infoArray = [NSMutableArray new];
    }
    return _infoArray;
}

@end
