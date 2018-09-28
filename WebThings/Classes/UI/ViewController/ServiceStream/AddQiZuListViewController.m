//
//  AddQiZuListViewController.m
//  WebThings
//
//  Created by machinsight on 2017/7/3.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "AddQiZuListViewController.h"
#import "BRDatePickerView.h"

@interface AddQiZuListViewController ()
<UITableViewDelegate, UITableViewDataSource> {
    UITableView *_mainTable;
}

@end

@implementation AddQiZuListViewController

- (void)initSubviews
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStyleDone target:self action:@selector(onSubmitClick)];
    
    _mainTable = [[UITableView alloc]
                  initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)
                  style:UITableViewStylePlain];
    _mainTable.delegate = self;
    _mainTable.dataSource = self;
    _mainTable.rowHeight = 55;
    _mainTable.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_mainTable];
    
    if (_isAdd == 1) {
        [self initLocalValues];
    }
}

- (void)initLocalValues
{
    //    NSArray *strArr = [_portalModel.projectstartrenthistory.startdate componentsSeparatedByString:@" "];
    //    if (strArr.count == 2) {
    //        _dateTF.text = strArr[0];
    //        NSString *t = strArr[1];
    //        _timeTF.text = [t substringToIndex:t.length-3];
    //    }
    //    _cqbahTF.text = _portalModel.projectstartrenthistory.recordno;
    //    _jcdwTF.text = _portalModel.projectstartrenthistory.checkcompany;
    //    _jcbgbhTF.text = _portalModel.projectstartrenthistory.chckreportid;
}

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (_isAdd == 0) {
        self.title = @"新增启租单";
    }else{
        self.title = @"修改启租单";
    }
    [self initSubviews];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 8)];
    footer.backgroundColor = [UIColor colorWithHexString:COLOR_BG];
    
    return footer;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"AddRentListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UILabel *lblTitle = nil;
    UITextField *field = nil;
    UIImageView *indictor = nil;
    CGFloat height = tableView.rowHeight;
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
        lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(kHEIHGT_SPACE, 0, 100, height)];
        lblTitle.font = [UIFont systemFontOfSize:14];
        lblTitle.textColor = [UIColor colorWithHexString:COLOR_BLACK];
        lblTitle.tag = 1;
        [cell.contentView addSubview:lblTitle];
        
        field = [[UITextField alloc] initWithFrame:CGRectMake(screenWidth - 130 - 38, 0, 130, height)];
        field.font = [UIFont systemFontOfSize:14];
        field.textColor = [UIColor colorWithHexString:COLOR_BLACK];
        field.tag = 2;
        field.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:field];
        
        indictor = [[UIImageView alloc] initWithImage:ImageNamed(@"ic_business_device")];
        indictor.frame = CGRectMake(screenWidth - 16 - 6, height/2.0 - 5, 6, 10);
        indictor.tag = 3;
        [cell.contentView addSubview:indictor];

    } else {
        lblTitle = (UILabel *)[cell.contentView viewWithTag:1];
        field = (UITextField *)[cell.contentView viewWithTag:2];
        indictor = (UIImageView *)[cell.contentView viewWithTag:3];
    }
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    NSString *title = @"";
    field.placeholder = @"请选择";
    field.enabled = NO;
    
    if (section == 0) {
        title = @"项目负责人";
    } else if (section == 1) {
        if (row == 0) {
            title = @"安装地点";
        } else {
            title = @"启租日期";
        }
    } else if (section == 2) {
        field.placeholder = @"请输入";
        field.enabled = YES;
        if (row == 0) {
            title = @"产权备案号";
        } else if (row == 1) {
            title = @"检测单位";
        } else {
            title = @"检测报告编号";
        }
    }
    lblTitle.text = title;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    if (section == 1) {
        
    } else if (section == 2) {
        if (row == 0) {
            
        } else if (row == 1) {
            
        }
    }
}

#pragma mark - Button clicks
- (void)onSubmitClick {
//    if (!_dateTF.text.length || !_timeTF.text.length || !_cqbahTF.text.length|| !_jcdwTF.text.length|| !_jcbgbhTF.text.length ) {
//        MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"请填写完整信息" actionTitle:@"" duration:3.0];
//        [t show];
//        return;
//    }
    if (_isAdd == 0) {
//        [self fetchAdd];
    }else{
//        [self fetchEdit];
    }
}

#pragma hidekeyboard
- (IBAction)hideKeyBoard:(id)sender {
    [self.view endEditing:YES];

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

//选择日期
//- (void)gesTap0:(UIRotationGestureRecognizer *)sender
//{
//    [BRDatePickerView showDatePickerWithTitle:@"选择日期" dateType:UIDatePickerModeDate defaultSelValue:self.dateTF.text minDateStr:[NSDate currentDateString] maxDateStr:nil isAutoSelect:false resultBlock:^(NSString *selectValue) {
//        self.dateTF.text = selectValue;
//    }];
//}
//
////选择时间
//- (void)gesTap1:(UIRotationGestureRecognizer *)sender
//{
//    [BRDatePickerView showDatePickerWithTitle:@"选择时间" dateType:UIDatePickerModeTime defaultSelValue:self.timeTF.text minDateStr:nil  maxDateStr:nil isAutoSelect:false resultBlock:^(NSString *selectValue) {
//        self.timeTF.text = selectValue;
//    }];
//}
//
///**
// 新增
// */
//- (void)fetchAdd{
//    NSString *startDate = [NSString stringWithFormat:@"%@ %@:00",_dateTF.text,_timeTF.text];
//    NSDictionary *dic = @{@"userid" : @(self.baseUser.userid),
//                          @"type" : [NSObject changeType:self.baseUser.type],
//                          @"usertype" : [NSObject changeType:self.baseUser.usertype],
//                          @"projectid" : @(_projectid),
//                          @"deviceid" : @(_dm.deviceid),
//                          @"startdate" : startDate,
//                          @"recordno" : [NSObject changeType:_cqbahTF.text],
//                          @"checkcompany" : [NSObject changeType:_jcdwTF.text],
//                          @"chckreportid" : [NSObject changeType:_jcbgbhTF.text]};
//    [[DQServiceInterface sharedInstance] dq_getAddStarRentOrder:dic success:^(id result) {
//        if (result != nil) {
//            MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"添加成功" actionTitle:@"" duration:3.0];
//            [t show];
//            [self.navigationController popViewControllerAnimated:YES];
//            if (self.basedelegate && [self.basedelegate respondsToSelector:@selector(didPopFromNextVC)]) {
//                [self.basedelegate didPopFromNextVC];
//            };
//        }
//    } failture:^(NSError *error) {
//
//    }];
//}
//
///**
// 修改
// */
//- (void)fetchEdit
//{
//    NSString *startDate = [NSString stringWithFormat:@"%@ %@:00",_dateTF.text,_timeTF.text];
//    NSDictionary *dic = @{@"userid" : @(self.baseUser.userid),
//                          @"type" : [NSObject changeType:self.baseUser.type],
//                          @"usertype" : [NSObject changeType:self.baseUser.usertype],
//                          @"projectid" : @(_projectid),
//                          @"deviceid" : @(_dm.deviceid),
//                          @"startdate" : startDate,
//                          @"recordno" : [NSObject changeType:_cqbahTF.text],
//                          @"checkcompany" : [NSObject changeType:_jcdwTF.text],
//                          @"chckreportid" : [NSObject changeType:_jcbgbhTF.text],
//                          @"pid" : @(_portalModel.projectstartrenthistory.projectstartrentid)};
//
//    [[DQServiceInterface sharedInstance] dq_getUpdateStarRentOrder:dic success:^(id result) {
//        if (result != nil) {
//            MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"修改成功" actionTitle:@"" duration:3.0];
//            [t show];
//            [self.navigationController popViewControllerAnimated:YES];
//            if (self.basedelegate && [self.basedelegate respondsToSelector:@selector(didPopFromNextVC)]) {
//              [self.basedelegate didPopFromNextVC];
//            }
//        }
//    } failture:^(NSError *error) {
//
//    }];
//}
//
//#pragma mark - UIGestureRecognizerDelegate
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
//    DQLog(@"%@",NSStringFromClass(object_getClass(touch.view)));
//    if ([NSStringFromClass(object_getClass(touch.view)) isEqualToString:@"SDTextField"] || [NSStringFromClass(object_getClass(touch.view)) isEqualToString:@"UITableViewCellContentView"] || [NSStringFromClass(object_getClass(touch.view)) isEqualToString:@"ImgButton"]) {
//        return NO;
//    }
//    return YES;
//}

@end
