//
//  DQDeriveTrainingController.m
//  WebThings
//
//  Created by winton on 2017/9/30.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "DQDeriveTrainingController.h"
#import "DQTextFieldArrowForCell.h"
#import "DQTextFiledInfoCell.h"
#import "BRDatePickerView.h"
#import "NewDeviceScrollView.h"
#import "DQTrainTypeModel.h"

@interface DQDeriveTrainingController ()
<UITableViewDelegate,
UITableViewDataSource,
NewDeviceScrollViewDelegate>
{
    NSMutableArray *_dataListArray;
    NewDeviceScrollView *_typeScrollView;
    NSInteger _typeID;
}
@property (nonatomic, strong) UITableView *mTableView;
@end

@implementation DQDeriveTrainingController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"培训";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(popViewController) image:ImageNamed(@"back")];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(onSubmitTrainingClicked) title:@"提交"];

    _dataListArray = [NSMutableArray arrayWithArray:[self createInfoTraingCell]];
    _mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 72, screenWidth, screenHeight-72) style:UITableViewStylePlain];
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
        _mTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [self.view addSubview:_mTableView];
    
    _typeScrollView = [[NewDeviceScrollView alloc] initWithFrame:CGRectMake(0, 64+158, screenWidth, 223)];
    _typeScrollView.delegate = self;
    _typeScrollView.tag = 9566;
    _typeScrollView.hidden = true;
    [self.view addSubview:_typeScrollView];
    [self fetchTrainingTypeAPI];
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

- (void)popViewController
{
    [self.navigationController popViewControllerAnimated:true];
}

- (void)fetchTrainingTypeAPI
{
  //获取培训类型
    [[DQProjectInterface sharedInstance] dq_getTrainTypeList:^(id result) {
        if (result) {
            [_typeScrollView setData:result];
        }
    } failture:^(NSError *error) {
        
    }];
}

//点击提交
- (void)onSubmitTrainingClicked
{
    DQTextFiledInfoCell *projectNameCell = [_dataListArray safeObjectAtIndex:0];
    DQTextFiledInfoCell *oritionCell = [_dataListArray safeObjectAtIndex:1];
    DQTextFieldArrowForCell *typeCell = [_dataListArray safeObjectAtIndex:2];
    DQTextFieldArrowForCell *timeCell = [_dataListArray safeObjectAtIndex:3];
    DQTextFiledInfoCell *numberCell = [_dataListArray safeObjectAtIndex:4];
    if (!projectNameCell.rightField.text.length || !oritionCell.rightField.text.length || !typeCell.rightField.text.length || !timeCell.rightField.text.length || !numberCell.rightField.text.length) {
        MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"请完善培训信息" actionTitle:@"" duration:3.0];
        [t show];
        return;
    }
    NSDictionary *dict = @{
                        @"workerid" : @(self.workerid),
                        @"name" : [NSString stringWithFormat:@"%@",self.name],
                        @"projectid" : @(self.projectID),
                        @"projectname" : [NSString stringWithFormat:@"%@",projectNameCell.rightField.text],
                        @"organizer" : [NSString stringWithFormat:@"%@",oritionCell.rightField.text],
                        @"type" : [NSString stringWithFormat:@"%@",typeCell.rightField.text],
                        @"typeid" : @(_typeID),
                        @"date" : [NSString stringWithFormat:@"%@",timeCell.rightField.text],
                        @"recordno" : [NSString stringWithFormat:@"%@",numberCell.rightField.text],
                        @"traincount" : @"1"};
    //10,新增人员培训记录接口
    [[DQProjectInterface sharedInstance] dq_getAddTranrecord:dict success:^(id result) {
        if (result) {
            MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"提交培训成功" actionTitle:@"" duration:2.0];
            [t show];
            [self.navigationController popViewControllerAnimated:true];
        }
    } failture:^(NSError *error) {
    }];
}

#pragma mark -NewDeviceScrollViewDelegate
- (void)didSelectValue:(id)value
              withSelf:(NewDeviceScrollView *)sender
             witnIndex:(NSInteger)index
{
    DQTrainTypeModel *typeModel = (DQTrainTypeModel *)value;
    DQTextFieldArrowForCell *typeCell = [_dataListArray safeObjectAtIndex:2];
    typeCell.rightField.text = typeModel.type;
    _typeID = typeModel.typeid;
}

#pragma mark -UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataListArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [_dataListArray safeObjectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 2: {//培训类型
            [self.view endEditing:true];
            [_typeScrollView showWithFatherV:self.view];
        } break;
        case 3: {//培训时间
            __block DQTextFieldArrowForCell *timeCell = [_dataListArray safeObjectAtIndex:3];
            [self.view endEditing:true];
            [BRDatePickerView showDatePickerWithTitle:@"培训时间" dateType:UIDatePickerModeDate defaultSelValue:timeCell.rightField.text minDateStr:nil maxDateStr:nil isAutoSelect:false resultBlock:^(NSString *selectValue) {
                timeCell.rightField.text = selectValue;
            }];
        } break;
        default:
            break;
    }
}

#pragma mark -UI
- (NSArray *)createInfoTraingCell
{
    DQTextFiledInfoCell *projectNameCell = [[DQTextFiledInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"projectNameCellIdentifier"];
    projectNameCell.configLeftName = @"项目名称";
    projectNameCell.rightField.font = [UIFont dq_mediumSystemFontOfSize:14];
    
    DQTextFiledInfoCell *oritionCell = [[DQTextFiledInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"oritionCellIdentifier"];
    oritionCell.configLeftName = @"组织者";
    oritionCell.rightField.font = [UIFont dq_mediumSystemFontOfSize:14];
    
    DQTextFieldArrowForCell *typeCell = [[DQTextFieldArrowForCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"typeCellIdentifier"];
    typeCell.configLeftName = @"培训类型";
    typeCell.rightField.font = [UIFont dq_mediumSystemFontOfSize:14];
    typeCell.rightField.placeholder = @"请选择";
    [typeCell.rightField setEnabled:false];
    
    
    DQTextFieldArrowForCell *timeCell = [[DQTextFieldArrowForCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"timeCellIdentifier"];
    timeCell.configLeftName = @"培训时间";
    timeCell.rightField.font = [UIFont dq_mediumSystemFontOfSize:14];
    timeCell.rightField.placeholder = @"请选择";
    [timeCell.rightField setEnabled:false];
    
    DQTextFiledInfoCell *numberCell = [[DQTextFiledInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"numberCellIdentifier"];
    numberCell.configLeftName = @"记录表编号";
    numberCell.rightField.font = [UIFont dq_mediumSystemFontOfSize:14];
    
    return @[projectNameCell,oritionCell,typeCell,timeCell,numberCell];
}


@end
