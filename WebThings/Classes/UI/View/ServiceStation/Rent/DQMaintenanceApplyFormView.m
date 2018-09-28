//
//  DQMaintenanceApplyFormView.m
//  WebThings
//
//  Created by Eugene on 10/9/17.
//  Copyright © 2017 machinsight. All rights reserved.
//

#import "DQMaintenanceApplyFormView.h"
#import "DQServiceBillView.h"// 表单View

#import "DeviceMaintainorderModel.h"// 设备维保单,维修单，加高单，拆除单
#import "DQSubMaintainModel.h"

#import "DQMaintenanceWorkerCell.h"// 工作人员cell
#import "DQAddWorkUserController.h" //添加选择人员
#import "DQServiceStationDetailController.h"

@interface DQMaintenanceApplyFormView ()<UITableViewDelegate,UITableViewDataSource>

/** 项目信息标签 */
@property (nonatomic, strong) UILabel *titleLabel;
/** 项目信息表单view */
@property (nonatomic, strong) DQServiceBillView *billView;
 /** 工作人员列表单 */
@property (nonatomic, strong) UITableView *tableView;
/** 折叠按钮 */
@property (nonatomic, strong) UIButton *foldButton;

/** 加高数据 */
@property (nonatomic, strong) NSArray *heightenAry;
/** 维修数据 */
@property (nonatomic, strong) NSArray *serviceAry;
/** 维保数据 */
@property (nonatomic, strong) NSArray *maintainAry;


/** 工作人员列表数据 */
@property (nonatomic, strong) NSMutableArray *workerAry;
@end

@implementation DQMaintenanceApplyFormView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self initMaintenanceApplyFormView];
    }
    return self;
}

- (void)initMaintenanceApplyFormView {
    /** 工人数组 */
    _workerAry = [[NSMutableArray alloc] init];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont dq_semiboldSystemFontOfSize:14];
    _titleLabel.text = @"项目信息";
    _titleLabel.frame = CGRectMake(16, 0, 300, 32);
    [self addSubview:_titleLabel];
    
    // 维保单据表单容器view
    _billView = [[DQServiceBillView alloc]
                 initWithFrame:CGRectMake(0, _titleLabel.bottom, self.frame.size.width, 250)];
    [self addSubview:_billView];
    
    _tableView = [[UITableView alloc] init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.backgroundColor = [UIColor clearColor];
    [self addSubview:_tableView];
}

#pragma mark - Delegate And DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   return _foldButton.selected ? 1 : _workerAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"DQMaintenanceWorkerCellIdentifier";
    DQMaintenanceWorkerCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[DQMaintenanceWorkerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.userModel = _workerAry[indexPath.row];
    return cell;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return  _logicApplyFormModel.isLast && _logicApplyFormModel.showRefuteBackButton ? 44 : 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return _workerAry.count > 2 ? 44 : 0;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [self viewForHeaderInSction:YES];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [self viewForHeaderInSction:NO];
}

- (UIView *)viewForHeaderInSction:(BOOL)isHeader {
    
    UIView *sectionView = [[UIView alloc] init];
    sectionView.frame = CGRectMake(0, 0, self.width, 44);
    sectionView.backgroundColor = [UIColor clearColor];
    
    BOOL other = _logicApplyFormModel.direction == DQDirectionLeft;
    
    if (isHeader) {
        UIView *lineView = [[UIView alloc] init];
        lineView.frame = CGRectMake(16, 8, self.width-32, 1);
        lineView.backgroundColor = [UIColor colorWithHexString:@"#ECECEC"];
        [sectionView addSubview:lineView];
        
        UIButton *workerBtn = [[UIButton alloc] init];
        workerBtn.frame = CGRectMake(self.width/2-100, lineView.bottom+8, 200, 30);
        workerBtn.titleLabel.font = [UIFont dq_semiboldSystemFontOfSize:14.0];
        [workerBtn setTitle:@"选择工作人员" forState:UIControlStateNormal];
        [workerBtn setTitleColor:[UIColor colorWithHexString:COLOR_BTN_BLUE] forState:UIControlStateNormal];
        [workerBtn setImage:[UIImage imageNamed:@"icon_indictor"] forState:UIControlStateNormal];
        [workerBtn addTarget:self action:@selector(onSelectedWorkerClick:) forControlEvents:UIControlEventTouchUpInside];
        [sectionView addSubview:workerBtn];
        [workerBtn layoutButtonWithEdgeInsetsStyle:TQButtonEdgeInsetsStyleRight imageTitleSpace:5];
        workerBtn.hidden = !(_logicApplyFormModel.isLast && _logicApplyFormModel.showRefuteBackButton);
    } else {
        if (!_foldButton) {
            UIButton *foldBtn = [[UIButton alloc] init];
            foldBtn.frame = CGRectMake(self.width/2-30, 0, 60, 30);
            [foldBtn setImage:[UIImage imageNamed:other ? @"ic_station_unfold" : @"icon_indictor_green"] forState:UIControlStateNormal];//business_service_fold_icon
            [foldBtn addTarget:self action:@selector(onFoldWorkerListClick:) forControlEvents:UIControlEventTouchUpInside];
            _foldButton = foldBtn;
        }
        [sectionView addSubview:_foldButton];
    }
    return sectionView;
}


- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor whiteColor];
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor clearColor];
}

#pragma mark - Private Methods
/** 选择工作人员 */
- (void)onSelectedWorkerClick:(UIButton *)sender {
    
    DQServiceStationDetailController *peopleListView = (DQServiceStationDetailController *)[self getConfigViewController];
    DQSubMaintainModel *maintainModel = (DQSubMaintainModel *)_logicApplyFormModel.cellData;
    //跳转选择工作人员列表
    DQAddWorkUserController *workUserVC = [DQAddWorkUserController new];
    workUserVC.projectID = [maintainModel.projectid integerValue];
    workUserVC.type = KDQAddWorkUserManyStyle;
    [_workerAry removeAllObjects];
    
    __weak typeof(self) weakSelf = self;
    workUserVC.userDataBlock = ^(NSMutableArray *userList) {
       //回调人员数据  userModel
        weakSelf.workerAry = userList;
        weakSelf.logicApplyFormModel.workerAry = userList;
        [weakSelf.tableView reloadData];
        [weakSelf reloadTableViewHeight];
        if (weakSelf.reloadFrameBlock != nil) {
            weakSelf.reloadFrameBlock();
        }
    };
    [peopleListView.navigationController pushViewController:workUserVC animated:true];
}

/** 折叠工作人员列表 */
- (void)onFoldWorkerListClick:(UIButton *)sender {
    
    _foldButton.selected = !_foldButton.selected;
    CGFloat angle = _foldButton.selected ? M_PI:M_PI*2;
    sender.imageView.transform = CGAffineTransformMakeRotation(angle);
    [_tableView reloadData];
    
    NSInteger workerCount = _foldButton.selected ? 1 : _workerAry.count;

    CGFloat addibleWorkerHeight = (_workerAry.count > 2) ? (workerCount+2)*44 : (_workerAry.count+1)*44;
    CGFloat workerHeight = (_workerAry.count > 2) ? (workerCount+1)*44+20 :_workerAry.count*44+20;
    CGFloat tableViewHeight1 = _logicApplyFormModel.isLast && _logicApplyFormModel.showRefuteBackButton ? addibleWorkerHeight : workerHeight;
    _tableView.frame = CGRectMake(0, _billView.bottom, self.frame.size.width, tableViewHeight1);
    
    _logicApplyFormModel.isFoldWorkerList = _foldButton.selected;
    [self reloadTableViewHeight];
    
    if (self.reloadFrameBlock != nil) {
        self.reloadFrameBlock();
    }
}

/** 调整工作人员表单高度，从而准确的更改cell和维保单的高度 */
- (void)reloadTableViewHeight {
    
    NSInteger workerCount = _foldButton.selected ? 1 : _workerAry.count;
    CGFloat addibleWorkerHeight = (_workerAry.count > 2) ? (workerCount+2)*44 : (_workerAry.count+1)*44;
    CGFloat workerHeight = (_workerAry.count > 2) ? (workerCount+1)*44+20 :_workerAry.count*44+20;
    CGFloat tableViewHeight = _logicApplyFormModel.isLast && _logicApplyFormModel.showRefuteBackButton ? addibleWorkerHeight : workerHeight;
    _tableView.frame = CGRectMake(0, _billView.bottom, self.frame.size.width, tableViewHeight);
 
    _logicApplyFormModel.workerAry = _workerAry;
    
    UserModel *user = [AppUtils readUser];
    if (user.isZuLin) {// 租赁方 维保等申请表单需要显示工人列表
        _logicApplyFormModel.applyFormHeight = (_billView.bottom + tableViewHeight + 32);//32: 项目信息label的高度
    } else { //承租方不需要显示
        _logicApplyFormModel.applyFormHeight = _billView.bottom;
    }
    
}

#pragma mark - Setter And Getter
- (void)setLogicApplyFormModel:(DQLogicMaintainModel *)logicApplyFormModel {
    
    _logicApplyFormModel = logicApplyFormModel;
    
    _titleLabel.textColor = _logicApplyFormModel.hexTitleColor;
    [_billView setData:logicApplyFormModel.arrayForBill];//表单信息
    
    // 只需展示工作人员列表是调用
    if (logicApplyFormModel.devieceOrderModel.workers > 0) {
        [_workerAry removeAllObjects];
        _workerAry = [NSMutableArray arrayWithArray:logicApplyFormModel.devieceOrderModel.workers];
        [_tableView reloadData];
    } else {
    }

    CGRect rect = _billView.frame;
    rect.size.height = [_billView getViewHeight];
    _billView.frame = rect;
    [self reloadTableViewHeight];

    BOOL other = logicApplyFormModel.direction == DQDirectionLeft;
    if (other) {
        _tableView.hidden = NO;
    } else {
        _tableView.hidden = YES;
        _tableView.height = 0;
    }
}

- (NSInteger)formViewHeight {
    return _billView.frame.size.height+kHEIHGT_BILLCELL+_tableView.frame.size.height;
}

@end
