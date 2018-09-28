//
//  DQDropdownMenuView.m
//  DQDropdownMenuViewDemo
//
//  Created by Eugene on 2017/9/17.
//  Copyright © 2017年 Eugene. All rights reserved.
//

#import "DQDropdownMenuView.h"

#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height;

const NSInteger kDeviceStateViewHeight = 105;

static NSString * const headerViewIdentifier = @"headerViewIdentifier";
static NSString * const menuCellIdentifier = @"menuCellIdentifier";
static NSString * const footerViewIdentifier = @"footerViewIdentifier";


/** 设备运行的状态View */
#import "DQDeviceStateView.h"
#import "DQDeviceStateModel.h"

/** collectionView 的头部、底部和cell */
#import "DQMenuHeadReusableView.h"
#import "DQDropDownMenuCell.h"
#import "DQMenuFootReusableView.h"

/** 设备接口 */
#import "DQDeviceInterface.h"

@interface DQDropdownMenuView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

/** menu 是否展开 */
@property (nonatomic, assign) BOOL isMenuShow;

/** collectionView 宽度 */
@property (nonatomic, assign) CGFloat viewWidth;

/** collectionView 高度 */
@property (nonatomic, assign) CGFloat viewHeight;

/** 概览按钮 */
@property (nonatomic, strong) UIButton *titleButton;

/** 灰色背景图层 */
@property (nonatomic, strong) UIView *backgroundView;

/** 容器图层view */
@property (nonatomic, strong) UIView *wrapperView;

/** animation duration default 0.2 */
@property (nonatomic, assign) CGFloat animationDuration;

/** 顶部设备运行状态表 */
@property (nonatomic, strong) DQDeviceStateView *deviceStateView;

/** 表单 */
@property (nonatomic, strong) UICollectionView *collectionView;

@end
@implementation DQDropdownMenuView

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self initDropdownView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initDropdownView];
    }
    return self;
}

- (CGSize)intrinsicContentSize {
    return UILayoutFittingExpandedSize;
}

- (void)initDropdownView {
    
    _viewWidth = kWidth;
    _animationDuration = 0.2;
    _isMenuShow = NO;
    
    [self addSubview:self.titleButton];
    
    [self.wrapperView addSubview:self.backgroundView];
    [self.wrapperView addSubview:self.deviceStateView];
    [self.wrapperView addSubview:self.collectionView];
}

- (void)didMoveToWindow {
    
    [super didMoveToWindow];
    
    if (self.window) {
        [self.window addSubview:self.wrapperView];
        
        self.titleButton.frame = CGRectMake(0, 0, 80, 40);
        //self.titleButton.centerX = (kWidth-240)/2;
        
        self.wrapperView.frame = CGRectMake(0, 69, self.window.width, self.window.height-69);
        self.backgroundView.frame = CGRectMake(0, 0, self.window.width, self.window.height-69);
        
        self.deviceStateView.frame = CGRectMake(0, 0, self.wrapperView.width, kDeviceStateViewHeight);
        
        self.collectionView.frame = CGRectMake(self.wrapperView.left, self.deviceStateView.top, self.wrapperView.width, self.wrapperView.height);
        
        self.wrapperView.hidden = YES;
    }
    else {
        // 避免不能销毁的问题
        [self.wrapperView removeFromSuperview];
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return _projectAry.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    AddProjectModel *projectModel = _projectAry[section];
    NSArray <DeviceTypeModel *>*deviceTypes = projectModel.devices;
    return deviceTypes.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DQDropDownMenuCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:menuCellIdentifier forIndexPath:indexPath];
    
    AddProjectModel *projectModel = _projectAry[indexPath.section];
    DeviceTypeModel *deviceType = [projectModel.devices safeObjectAtIndex:indexPath.row];
    cell.deviceType = deviceType;
    
    __weak typeof(self) weakself = self;
    cell.typeBlock = ^(){
        if (weakself.delegate && [weakself.delegate respondsToSelector:@selector(dropdownMenuItemWillPushViewWithProject:deviceType:)]) {
            
            [weakself dismissMenuWithAnimation:NO];
            [weakself.delegate dropdownMenuItemWillPushViewWithProject:projectModel deviceType:deviceType];
        }
    };
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(kWidth, 54);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (section < _projectAry.count-1) {
        return CGSizeMake(kWidth, 8);
    } else {
        return CGSizeMake(kWidth, 0);
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if (kind  == UICollectionElementKindSectionHeader) {
        
        DQMenuHeadReusableView *reuseableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerViewIdentifier forIndexPath:indexPath];
        AddProjectModel *projectModel = _projectAry[indexPath.section];
        reuseableView.projectName = [NSObject changeType:projectModel.projectname];
        return reuseableView;
    } else {
        
        DQMenuFootReusableView *footView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerViewIdentifier forIndexPath:indexPath];
        return footView;
    }
}

#pragma mark - Private Actions
- (void)handleTapOnTitleButton:(UIButton *)button {
    self.isMenuShow = !self.isMenuShow;
}

- (void)handleProjectDevices:(NSArray<AddProjectModel *> *)projects {
    
    // 确定collectionView的高度
    CGFloat collectionViewHeight = [self getCollectionViewHeight:projects];
    // 获取有效的项目（把无设备的项目过滤掉）
    NSArray *validAry = [self getValidProjectDevices:projects];
    _projectAry = validAry;
    
    if ([validAry count] == 0) { //无数据
        
        [[BJNoDataView shareNoDataView] showCenterWithSuperView:self.backgroundView icon:@"ic_empty01" Frame:CGRectMake(0, 0, self.backgroundView.width, self.backgroundView.height) iconClicked:^{
            //图片点击回调
            [self fetchProjectOverView];
        } WithText:@"暂时没有可查看的设备"];
        self.collectionView.hidden  = YES;
        
    } else { // 有数据
        
        [[BJNoDataView shareNoDataView] clear];
        
        // 获取设备运行状态并显示
        [self getDeviceRunningStateWithProjects:validAry];

        self.collectionView.hidden = NO;
        
        if (collectionViewHeight < self.backgroundView.height - kDeviceStateViewHeight) {
            self.viewHeight = collectionViewHeight;
        } else {
            self.viewHeight = self.backgroundView.height - kDeviceStateViewHeight;
        }
        
        self.collectionView.height = self.viewHeight;
        [self.collectionView reloadData];
    }
}

/** 根据项目设备数来确定collectionView的高度*/
- (CGFloat)getCollectionViewHeight:(NSArray <AddProjectModel*> *)projects {
    
    NSMutableArray *heightAry = [NSMutableArray new];
    for (int i = 0;i < projects.count; i ++) {
        AddProjectModel *projectModel = projects[i];
        NSArray <DeviceTypeModel *>*devices = projectModel.devices;
        
        if (devices.count > 0) {
            NSInteger rowCount = ceil((double)devices.count / 2.0);
            NSInteger headerHeight = 54 + 8;
            NSInteger cellHeight = headerHeight + rowCount * 40 + (rowCount + 1) * 15;
            [heightAry addObject:@(cellHeight)];
        } else {
            // 无设备时不显示
        }
    }
    
    CGFloat collectionViewHeight = [[heightAry valueForKeyPath:@"@sum.floatValue"] floatValue];
    return collectionViewHeight;
}

/** 当项目中没有安装设备时，将此项目过滤*/
- (NSArray *)getValidProjectDevices:(NSArray <AddProjectModel *>*)projects {
    
    NSMutableArray *validAry = [NSMutableArray new];
    [projects enumerateObjectsUsingBlock:^(AddProjectModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray <DeviceTypeModel *>*devices = obj.devices;
        // 无设备时不显示
        if (devices.count > 0) {
            [validAry addObject:obj];
        }
    }];
    
    return validAry;
}

// 计算设备的运行状态：故障设备数、正常设备数、和设备总数
- (void)getDeviceRunningStateWithProjects:(NSArray *)projects {

    NSMutableArray *deviceAry = [[NSMutableArray alloc] init];
    NSMutableArray *failAry = [[NSMutableArray alloc] init];
    [projects enumerateObjectsUsingBlock:^(AddProjectModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray <DeviceTypeModel *>*devices = obj.devices;
        [deviceAry addObjectsFromArray:devices];
    }];
    
    [deviceAry enumerateObjectsUsingBlock:^(DeviceTypeModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.isWarning) {
            [failAry addObject:obj];
        }
    }];
    
   NSDictionary *deviceDict = @{@"total":@(deviceAry.count),
                   @"failureCount":@(failAry.count),
                   @"normalCount":@(deviceAry.count-failAry.count)};
    _deviceStateView.deviceModel = [[DQDeviceStateModel alloc] initWithDictionary:deviceDict];
}

#pragma mark - Public Methods

#pragma mark show
- (void)showMenu {
    
    [self showMenuWithAnimation:NO];
}

- (void)showMenuWithAnimation:(BOOL)animation {
    
    if (_delegate && [_delegate respondsToSelector:@selector(dropdownMenuWillShowView:)]) {
        [_delegate dropdownMenuWillShowView:self];
    }
    
    self.titleButton.enabled = NO;
    self.wrapperView.hidden = NO;
    self.backgroundView.alpha = 0.0;
    
    /** 概览是否已展开的指示图片动画 */
    [self indicatorViewRotation:M_PI];
    
    if (animation == NO) {
        [self staticShow];
    } else {
        [self dynamicShow];
    }
}

/** 无动画展开概览 */
- (void)staticShow {
    
    self.backgroundView.alpha = 0.4;
    [self showMenuAnimation];
    [self viewDidShowDelegate];
}

/** 动画展开概览 */
- (void)dynamicShow {
    
    CGRect collectionViewLayerFrame = self.wrapperView.bounds;
    collectionViewLayerFrame.origin.y = -collectionViewLayerFrame.size.height-self.deviceStateView.bottom;
    if (self.viewHeight>0) {
        collectionViewLayerFrame.size.height = self.viewHeight;
    }
    self.collectionView.layer.frame = collectionViewLayerFrame;
    self.deviceStateView.layer.frame = CGRectMake(0, -self.deviceStateView.height, kWidth, kDeviceStateViewHeight);
    
    self.backgroundView.alpha = 0.4;
    
    [UIView animateWithDuration:self.animationDuration * 1.5 animations:^{
        [self showMenuAnimation];
    } completion:^(BOOL finished) {
        [self viewDidShowDelegate];
    }];
}

// ----- 展示动画 -----
- (void)showMenuAnimation {
    
    CGRect frame = self.wrapperView.bounds;
    if (self.viewHeight>0) {
        frame.size.height = self.viewHeight;
    }
    frame.origin.y = self.deviceStateView.height;
    self.collectionView.layer.frame = frame;
    [self.collectionView layoutIfNeeded];
    
    self.deviceStateView.layer.frame = CGRectMake(0, 0, kWidth, kDeviceStateViewHeight);
    self.titleButton.enabled = YES;
}

#pragma mark hide
- (void)dismissMenuWithAnimation:(BOOL)animation {
    
    if (_delegate && [_delegate respondsToSelector:@selector(dropdownMenuWillDismissView:)]) {
        [_delegate dropdownMenuWillDismissView:self];
    }
    
    self.titleButton.enabled = NO;
    /** 旋转指示图 */
    [self indicatorViewRotation:M_PI*2];
    
    if (animation == NO) {
        [self staticHide];
    } else {
        [self dynamicHide];
    }
}

// -- 动画 --
/** 静态隐藏动画 */
- (void)staticHide {
    // 第一步改变frame
    [self hideViewControlAnimation];
    // 最终效果
    [self didHideViewControlState];
}

/** 动态隐藏动画 */
- (void)dynamicHide {
    [UIView animateWithDuration:self.animationDuration * 1.5 animations:^{
        [self hideViewControlAnimation];
    } completion:^(BOOL finished) {
        [self didHideViewControlState];
    }];
}

// -- 动画内容 --
/** 概览隐藏 */
- (void)hideViewControlAnimation {
    
    CGRect collectionViewLayerFrame = self.wrapperView.bounds;
    collectionViewLayerFrame.origin.y = -collectionViewLayerFrame.size.height-self.deviceStateView.height;
    self.collectionView.layer.frame = collectionViewLayerFrame;
    [self.collectionView layoutIfNeeded];
    
    self.deviceStateView.layer.frame = CGRectMake(0, -self.deviceStateView.height, kWidth, kDeviceStateViewHeight);
}

/** 概览隐藏后控件的状态 */
- (void)didHideViewControlState {
    
    self.wrapperView.hidden = YES;
    [self.collectionView reloadData];
    self.titleButton.enabled = YES;
    self.backgroundView.alpha = 0.0;
    
    [self viewDidDismissDelegate];
}

/** 旋转指示视图 */
- (void)indicatorViewRotation:(CGFloat)angle {
    [UIView animateWithDuration:self.animationDuration
                     animations:^{
                         self.titleButton.imageView.transform = CGAffineTransformMakeRotation(angle);
                     }];
}

#pragma param delegate
- (void)viewDidShowDelegate {
    if (_delegate && [_delegate respondsToSelector:@selector(dropdownMenuDidShowView:)]) {
        [_delegate dropdownMenuDidShowView:self];
    }
}

- (void)viewDidDismissDelegate {
    if (_delegate && [_delegate respondsToSelector:@selector(dropdownMenuDidDismissView:)]) {
        [_delegate dropdownMenuDidDismissView:self];
    }
}

#pragma mark - Http Request
- (void)fetchProjectOverView {
    
    [[DQBusinessInterface sharedInstance]
     dq_getDataListWithMonth:nil
     success:^(id result) {
         _projectAry = [NSObject changeType:result];
         
         [self handleProjectDevices:_projectAry];
     } failture:^(NSError *error) {
     }];
}

#pragma mark - Getter and Setter
- (UIButton *)titleButton {
    
    if (!_titleButton) {
        _titleButton = [[UIButton alloc] init];
        _titleButton.frame = CGRectMake(0, 0, 80, 40);
        
        _titleButton.titleLabel.font = [UIFont dq_semiboldSystemFontOfSize:16];
        [_titleButton setTitle:@"概览" forState:UIControlStateNormal];
        [_titleButton setTitleColor:[UIColor colorWithHexString:@"303030"] forState:UIControlStateNormal];
        [_titleButton setImage:[UIImage imageNamed:@"ic_down"] forState:UIControlStateNormal];
        [_titleButton addTarget:self action:@selector(handleTapOnTitleButton:) forControlEvents:UIControlEventTouchUpInside];
        // 布局按钮中图片和文字的edge
        [_titleButton layoutButtonWithEdgeInsetsStyle:TQButtonEdgeInsetsStyleRight imageTitleSpace:10];
    }
    
    return _titleButton;
}
- (DQDeviceStateView *)deviceStateView {
    
    if (!_deviceStateView) {
        _deviceStateView = [[DQDeviceStateView alloc] init];
        _deviceStateView.frame = CGRectMake(0, 0, kWidth, kDeviceStateViewHeight);
    }
    return _deviceStateView;
}

- (UICollectionView *)collectionView {
    
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumLineSpacing = 11;//item 之间的水平间距
        layout.minimumInteritemSpacing = 26;//item间的垂直间距
        layout.sectionInset = UIEdgeInsetsMake(15, 16, 15, 16);
        layout.itemSize = CGSizeMake((kWidth- 32 - 33)/2, 40);
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate=self;
        _collectionView.dataSource=self;
        [_collectionView registerClass:[DQDropDownMenuCell class] forCellWithReuseIdentifier:menuCellIdentifier];
        [_collectionView registerClass:[DQMenuHeadReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerViewIdentifier];
        [_collectionView registerClass:[DQMenuFootReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerViewIdentifier];
        _collectionView.backgroundColor = [UIColor whiteColor];
    }
    return _collectionView;
}

- (UIView *)wrapperView {
    
    if (!_wrapperView) {
        _wrapperView = [[UIView alloc] init];
        _wrapperView.clipsToBounds = YES;
    }
    return _wrapperView;
}

- (UIView *)backgroundView {
    
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] init];
        _backgroundView.backgroundColor = [UIColor blackColor];
        _backgroundView.alpha = 0;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapOnTitleButton:)];
        [_backgroundView addGestureRecognizer:tapGesture];
    }
    return _backgroundView;
}

- (void)setIsMenuShow:(BOOL)isMenuShow {
    
    if (_isMenuShow != isMenuShow) {
        _isMenuShow = isMenuShow;
        
        if (isMenuShow) {
            [self showMenuWithAnimation:YES];
        } else {
            [self dismissMenuWithAnimation:YES];
        }
    }
}

- (void)setProjectAry:(NSArray<AddProjectModel *> *)projectAry {

    [self handleProjectDevices:projectAry];
}
@end
