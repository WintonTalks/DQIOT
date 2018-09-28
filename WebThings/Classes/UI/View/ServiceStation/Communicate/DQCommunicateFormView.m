//
//  DQCommunicateFormView.m
//  WebThings
//
//  Created by Eugene on 27/09/2017.
//  Copyright © 2017 machinsight. All rights reserved.
//  前期沟通-》沟通单列表

#import "DQCommunicateFormView.h"
#import "DQCommunicateFormViewCell.h"

#import "DQSubCommunicateModel.h"
#import "AddProjectModel.h"

static NSInteger const marginValue = 16;

@interface DQCommunicateFormView ()<UITableViewDelegate,UITableViewDataSource>
/** 信息表 */
@property (nonatomic, strong) UITableView *tableView;
/** 沟通表单数据 */
@property (nonatomic, strong) NSArray *dataAry;
@end

@implementation DQCommunicateFormView

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.tableView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.tableView.frame = CGRectMake(0, 0, self.width, self.height);
}

- (void)setLogicModel:(DQLogicCommunicateModel *)logicModel {
    
    _logicModel = logicModel;
    [self changedFormViewOpen:logicModel.isOpen];
    [self.tableView reloadData];
}

- (CGFloat)getCommunicateFormViewHeight {

    NSArray *ary = [_logicModel arrayForBill];
    CGFloat height = 0;
    for (NSDictionary *dict in ary) {
        
        CGSize size = [AppUtils
                       textSizeFromTextString:dict[@"value"]
                       width:kWIDTH_BILLCELL
                       height:1000
                       font:[UIFont boldSystemFontOfSize:14]];
        if (size.height < 20) {
            height += 30;
        } else {
            height += size.height + 16;
        }
    }
    
    if (ary.count > 5) { // 表单展开时要加上header and footer Section的高度
        height += (kHEIHGT_BILLCELL + 8)*2 + 15;
    } else {
        height += 16; // 表单折叠时要加上header and footer Section的高度
    }
    
    return height;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataAry.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return _dataAry.count > 1 ? (section == 0 ? kHEIHGT_BILLCELL + 8 : kHEIHGT_BILLCELL + 15) : 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 8;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *sectionAry = _dataAry[section];
    return sectionAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"communicateFormCellIdenfier";
    DQCommunicateFormViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[DQCommunicateFormViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                        reuseIdentifier:identifier];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    NSArray *ary = _dataAry[indexPath.section];
    [cell setData:ary[indexPath.row]];

    return cell;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    
    if (section == 1) {
        UIView *lineView = [[UIView alloc] init];
        lineView.frame = CGRectMake(marginValue, 7, self.width-(marginValue+5)*2, 1);
        lineView.backgroundColor = [UIColor colorWithHexString:@"#F3F3F3"];
        [headerView addSubview:lineView];
    }
    if (_dataAry.count == 1) {
        return headerView;
    }
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont dq_semiboldSystemFontOfSize:14];
    titleLabel.textColor = _logicModel.hexTitleColor;
    if (section == 0) {
        titleLabel.text = @"项目信息";
    } else {
        titleLabel.text = @"设备信息";
    }
    titleLabel.frame = CGRectMake(marginValue, section == 0 ? 16 : 21, 300, 16);
    [headerView addSubview:titleLabel];
    
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *ary = _dataAry[indexPath.section];
    NSDictionary *dict = ary[indexPath.row];
    if (dict[@"addition"]) {
        
        NSMutableString *str=[[NSMutableString alloc]initWithFormat:@"tel:%@",dict[@"value"]];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"拨号" message:dict[@"value"] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }];
                              
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"呼叫" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                // Typical usage
            [self openScheme:str];
        }];
                              
        // Add the actions.
        [alertController addAction:cancelAction];
        [alertController addAction:otherAction];
        UIViewController *view = [self getCurrentViewController];
        [view presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)openScheme:(NSString *)scheme {
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *URL = [NSURL URLWithString:scheme];
    
    if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
        [application openURL:URL options:@{}
           completionHandler:^(BOOL success) {
               NSLog(@"Open %@: %d",scheme,success);
           }];
    } else {
        BOOL success = [application openURL:URL];
        NSLog(@"Open %@: %d",scheme,success);
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor whiteColor];
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor clearColor];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kHEIHGT_BILLCELL;
}

#pragma mark - Private Methods
/** 折叠或展开时的数据 */
- (void)changedFormViewOpen:(BOOL)isOpen {
    
    DQSubCommunicateModel *model = (DQSubCommunicateModel *)_logicModel.cellData;
    AddProjectModel *projectModel = model.projecthistory;
    DeviceModel *deviceModel = projectModel.projectDevicehistory;
    
    if (isOpen) { /** 展开状态沟通表数据 */
        NSString *dirction = (_logicModel.direction == DQDirectionLeft) ? @"left" : @"right";
        _dataAry = @[
                     @[@{@"key" : @"项目名称", @"value" : [NSObject changeType:projectModel.projectname]},// 项目信息
                       @{@"key" : @"确认订单编号", @"value" : [NSObject changeType:projectModel.no]},
                       @{@"key" : @"出租方", @"value" : [NSObject changeType:projectModel.providename]},
                       @{@"key" : @"承租方", @"value" : [NSObject changeType:projectModel.needorgname]},
                       @{@"key" : @"工程地点", @"value" : [NSObject changeType:projectModel.projectaddress]},
                       @{@"key" : @"总包单位", @"value" : [NSObject changeType:projectModel.contractor]},
                       @{@"key" : @"监理单位", @"value" : [NSObject changeType:projectModel.supervisor]},
                       @{@"key" : @"预计进场时间", @"value" : [NSObject changeType:projectModel.indate]},
                       @{@"key" : @"预计出场时间", @"value" : [NSObject changeType:projectModel.outdate]},
                       @{@"key" : @"设备数量", @"value" : [NSString stringWithFormat:@"%ld",projectModel.devicenum]},
                       @{@"key" : @"租金", @"value" : [NSString stringWithFormat:@"%ld",projectModel.rent]},
                       @{@"key" : @"进出场费", @"value" : [NSString stringWithFormat:@"%ld",projectModel.intoutprice]},
                       @{@"key" : @"司机工资", @"value" : [NSString stringWithFormat:@"%ld",projectModel.driverrent]},
                       @{@"key" : @"项目负责人", @"value" : [NSObject changeType:projectModel.dn], @"addition" : [NSString stringWithFormat:@"%@",dirction]},
                       @{@"key" : @"总金额", @"value" : [NSString stringWithFormat:@"%ld",projectModel.totalprice]},
                       ],
                     @[@{@"key" : @"设备品牌", @"value" : [NSObject changeType:deviceModel.brand]},// 设备信息
                       @{@"key" : @"设备型号", @"value" : [NSObject changeType:deviceModel.model]},
                       @{@"key" : @"预埋件安装时间", @"value" : [NSObject changeType:deviceModel.beforehanddate]},
                       @{@"key" : @"安装高度", @"value" : [NSString stringWithFormat:@"%ld",deviceModel.high]},
                       @{@"key" : @"安装时间", @"value" : [NSObject changeType:deviceModel.handdate]},
                       @{@"key" : @"租赁价格", @"value" : [NSString stringWithFormat:@"%ld",deviceModel.rent]},
                       @{@"key" : @"安装地点", @"value" : [NSObject changeType:deviceModel.installationsite]},
                       @{@"key" : @"使用时间", @"value" : [NSObject changeType:deviceModel.starttime]}
                       ]
                     ];
    }
    else { /** 折叠状态沟通表数据 */
        _dataAry = @[
                     @[@{@"key" : @"项目名称", @"value" : [NSObject changeType:projectModel.projectname]},// 项目信息
                       @{@"key" : @"总金额", @"value" : [NSString stringWithFormat:@"%ld",projectModel.totalprice]},
                       
                       @{@"key" : @"设备品牌", @"value" : [NSObject changeType:deviceModel.brand]},// 设备信息
                       @{@"key" : @"设备型号", @"value" : [NSObject changeType:deviceModel.model]},
                       @{@"key" : @"安装时间", @"value" : [NSObject changeType:deviceModel.handdate]}
                       ]
                     ];
    }
}

#pragma mark - Getter
- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.bounces = NO;
        _tableView.backgroundColor = [UIColor clearColor];
    }
    return _tableView;
}

@end
