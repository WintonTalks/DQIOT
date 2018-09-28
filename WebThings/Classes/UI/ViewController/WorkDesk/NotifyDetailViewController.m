//
//  NotifyDetailViewController.m
//  WebThings
//
//  Created by machinsight on 2017/7/5.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "NotifyDetailViewController.h"
#import "NotifyDetailSectionCellTableViewCell.h"
#import "NotifyDetail.h"
//#import "RippleView.h"
#import "DWMsgModel.h"
#import "WorkDeskDelegate.h"
#import "WorkDeskOptFactory.h"
#import "NoticeListWI.h"
#import "ReadnoticeWI.h"
#import "DeletenoticeWI.h"
#import "EMICardView.h"

@interface NotifyDetailViewController ()<EMIBaseViewControllerDelegate,UITableViewDelegate,UITableViewDataSource>{
}
@property (weak, nonatomic) IBOutlet EMICardView *fatherV;
@property (strong, nonatomic) UITableView *tableView;

@property(nonatomic,strong) NSMutableArray <DWMsgModel *> *dataArray;
@property (weak, nonatomic) IBOutlet UIView *bottomV;
@property (weak, nonatomic) IBOutlet UIView *ydV;
@property (nonatomic,strong) UITapGestureRecognizer *ydVGes;
@property (weak, nonatomic) IBOutlet UIView *scV;
@property (nonatomic,strong) UITapGestureRecognizer *scVGes;

@property (nonatomic,assign)BOOL isShowCheckBtn;//默认不显示

@property (nonatomic,strong)UIBarButtonItem *rightB;
@end

@implementation NotifyDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _isShowCheckBtn = NO;
    self.title = _thisTitle;
    [self initArr];
    [self initView];
    [self fetchList];
    //[EMINavigationController addAppBar:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initArr {
    self.dataArray = [NSMutableArray array];
}

- (void)initView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(1, 1, screenWidth-22, screenHeight-100)];
        [self.fatherV addSubview:_tableView];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.hidden = NO;
    }
    
//    [self rightBwithTitle:@"全选"];
    _bottomV.bounds = CGRectMake(_bottomV.bounds.origin.x, _bottomV.bounds.origin.y, screenWidth, _bottomV.bounds.size.height);
 
    //[EMINavigationController dropShadowWithOffset:CGSizeMake(0, -1) radius:1 color:[UIColor colorWithHexString:@"#CBCCCD"] opacity:1 aimView:_bottomV];
    
    [self initGesture:_ydVGes withSelTag:0 withView:_ydV];
    [self initGesture:_scVGes withSelTag:1 withView:_scV];
}

- (void)rightBwithTitle:(NSString *)str {
    _rightB = [UIBarButtonItem itemWithTarget:self action:@selector(navRightBtn_Click:) title:str];
    self.navigationItem.rightBarButtonItem = _rightB;
}

- (void)navRightBtn_Click:(UIBarButtonItem *)sender
{
    if ([sender.title isEqualToString:@"全选"]) {
        _isShowCheckBtn = YES;
        for (int i = 0; i<_dataArray.count; i++) {
            _dataArray[i].isnotSelected = NO;
            _dataArray[i].isShowCekBtn = YES;
        }
        [self rightBwithTitle:@"取消"];
        _bottomV.hidden = NO;
    }else{
        _isShowCheckBtn = NO;
        for (int i = 0; i<_dataArray.count; i++) {
            _dataArray[i].isnotSelected = YES;
            _dataArray[i].isShowCekBtn = NO;
        }
        [self rightBwithTitle:@"全选"];
        _bottomV.hidden = YES;
    }
    [_tableView reloadData];
}

#pragma mark -
#pragma mark - UITableViewDataSource UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DWMsgModel *msgBean = _dataArray[indexPath.row];
    
    msgBean.closeCellHeight = 86.f;
    id<WorkDeskDelegate> delegate = [WorkDeskOptFactory factory:msgBean];
    return [delegate getTableViewCell:self tableView:tableView DWMsgData:msgBean];
}


#pragma mark
#pragma mark  -select cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.dataArray[indexPath.row].isOpen = !self.dataArray[indexPath.row].isOpen;
    [self.tableView reloadData];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArray[indexPath.row].isOpen) {
        return self.dataArray[indexPath.row].openCellHeight;
    }else{
//        return self.dataArray[indexPath.row].closeCellHeight;
        return 86.f;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
    /*
    if (self.dataArray[indexPath.row].isOpen) {
        return NO;
    }else{
        return YES;
    }
     */
}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(8_0) __TVOS_PROHIBITED{
    UITableViewRowAction *deleteAct = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"    " handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
    }];
    return @[deleteAct];
    
}

- (void)didPopFromNextVC{
    //刷新数据
    [self fetchList];
}

//刷新数据
- (void)fetchList {
    NoticeListWI *lwi = [[NoticeListWI alloc] init];
    NSArray *arr = @[@(self.baseUser.userid),self.baseUser.type,self.baseUser.usertype,self.thisTitle,@(0)];
    NSDictionary *param = [lwi inBox:arr];
    [CKNetTools requestWithRequestType:POST WithURL:lwi.fullUrl WithParamater:param WithProgressBlock:^(NSProgress *process) {
        
    } WithSuccessBlock:^(id returnValue) {
        NSArray *temp = [lwi unBox:returnValue];
        if ([temp[0] integerValue] == 1) {
            self.dataArray = temp[1];
            [_tableView reloadData];
        }
    } WithFailureBlock:^(NSError *error) {
    }];
}


#pragma 初始化手势
- (void)initGesture:(UITapGestureRecognizer *)ges withSelTag:(int)tag withView:(UIView *)aimView{
    NSString *selStr;
    switch (tag) {
        case 0:
            selStr = @"gesTap0:";
            break;
        case 1:
            selStr = @"gesTap1:";
            break;
        default:
            break;
    }
    if (!ges) {
        ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:NSSelectorFromString(selStr)];
        [aimView addGestureRecognizer:ges];
    }
}

- (void)gesTap0:(UITapGestureRecognizer *)sender{
    for (int i = 0; i<_dataArray.count; i++) {
        if (!_dataArray[i].isnotSelected) {
            [self yiduWithNoticeId:_dataArray[i].noticeid];
        }
        if (i == _dataArray.count-1) {
            _isShowCheckBtn = NO;
            _bottomV.hidden = YES;
            [self rightBwithTitle:@"全选"];
            [self fetchList];
        }
    }
    
}
- (void)gesTap1:(UITapGestureRecognizer *)sender{
    [self delete];
}
- (void)yiduWithNoticeId:(NSInteger)noticeid{
    ReadnoticeWI *lwi = [[ReadnoticeWI alloc] init];
    NSArray *arr = @[@(self.baseUser.userid),self.baseUser.type,self.baseUser.usertype,@(noticeid)];
    NSDictionary *param = [lwi inBox:arr];
    [CKNetTools requestWithRequestType:POST WithURL:lwi.fullUrl WithParamater:param WithProgressBlock:^(NSProgress *process) {
        
    } WithSuccessBlock:^(id returnValue) {
        NSArray *temp = [lwi unBox:returnValue];
        if ([temp[0] integerValue] == 1) {
            
        }
    } WithFailureBlock:^(NSError *error) {
    }];
}

- (void)delete{
    
    NSMutableArray *noticeids = [NSMutableArray array];
    for (int i = 0; i<_dataArray.count; i++) {
        if (!_dataArray[i].isnotSelected) {
            [noticeids addObject:@(_dataArray[i].noticeid)];
        }

    }
    
    DeletenoticeWI *lwi = [[DeletenoticeWI alloc] init];
    NSArray *arr = @[@(self.baseUser.userid),self.baseUser.type,self.baseUser.usertype,noticeids];
    NSDictionary *param = [lwi inBox:arr];
    [CKNetTools requestWithRequestType:POST WithURL:lwi.fullUrl WithParamater:param WithProgressBlock:^(NSProgress *process) {
        
    } WithSuccessBlock:^(id returnValue) {
        NSArray *temp = [lwi unBox:returnValue];
        if ([temp[0] integerValue] == 1) {
            _isShowCheckBtn = NO;
            _bottomV.hidden = YES;
            [self rightBwithTitle:@"全选"];
            [self fetchList];
        }
    } WithFailureBlock:^(NSError *error) {
    }];
}

@end
