//
//  AddDriverViewController.m
//  WebThings
//
//  Created by machinsight on 2017/6/22.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "AddDriverViewController.h"
#import "NewDriverCell.h"
#import "EditDriverViewController.h"
#import "DriverModel.h"
#import "DQAddNewDeriveView.h"
#import "EMICardView.h"

@interface AddDriverViewController ()<DQAddNewDeriveViewDelegate,EditDriverViewControllerDelegate,UITableViewDelegate,UITableViewDataSource,WTScrollViewKeyboardMangerDelegate>
{
    EMICardView *_cardView;
    
}
@property (nonatomic, strong) UITableView *mTableView;
@property (nonatomic, strong) DQAddNewDeriveView *newDeriveView;
@property (nonatomic, strong) WTScrollViewKeyboardManager *manger;
@end

@implementation AddDriverViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
    //self barHeight:64 shadowColor:[UIColor whiteColor]];
    [self setManger:[[WTScrollViewKeyboardManager alloc] initWithScrollView:self.mTableView viewController:self]];
}

- (void)initView
{
    if (self.isNew == 0) {
        self.title = @"新增司机";
    } else {
        self.title = @"修改司机";
    }
    UIBarButtonItem *rightNav = [UIBarButtonItem itemWithTarget:self action:@selector(rightNavClicked) image:[UIImage imageNamed:@"ic_done"]];
    self.navigationItem.rightBarButtonItem = rightNav;

    _cardView = [[EMICardView alloc] initWithFrame:CGRectMake(8, 77, screenWidth-16, self.view.height-77-10)];
    _cardView.backgroundColor = [UIColor whiteColor]; //[UIColor colorWithHexString:@"#F3F4F5"];
    [self.view addSubview:_cardView];
    [_cardView addSubview:self.mTableView];
}

- (void)rightNavClicked{
//    NSArray *dicArr = [DictIntoModel dictionaryWithArray:_dataArr];
    if (self.isfromServiceStream == 1) {
        if (_dataArr.count == 0) {
            MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"司机列表不能为空" actionTitle:@"" duration:3.0];
            [t show];
            return;
        }
        [self fetchEdit];
    }else{
        if (_delegate && [_delegate respondsToSelector:@selector(didPopWithDriverDics:)]) {
            [_delegate didPopWithDriverDics:_dataArr];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark -DQAddNewDeriveViewDelegate
- (void)addNewDeriveWithModel:(DQAddNewDeriveView *)deriveView  model:(DriverModel *)addModel
{
    [self.dataArr safeAddObject:addModel];
    [self.mTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)pushModifyDeriveVC:(DQAddNewDeriveView *)deriveView
{
    
}

#pragma mark -UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.dataArr.count;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == 0 ? 8.f : 0.f;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *hv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 8)];
    hv.backgroundColor = [UIColor colorWithHexString:@"#F3F4F5"];
    return hv;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        NewDriverCell *cell = [NewDriverCell cellWithTableView:tableView];
        [cell setViewWithValues:_dataArr[indexPath.section]];
        DriverModel *model = [_dataArr safeObjectAtIndex:indexPath.row];  //[indexPath.section]
        [cell setViewWithValues:model];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddDriverIdentifier"];
        if (!cell) {
          cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AddDriverIdentifier"];
          cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cell.contentView addSubview:self.newDeriveView];
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return _dataArr.count > 0 ? 78 : 0.f;
    }
    return _cardView.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return YES;
    }else{
        return NO;
    }
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_dataArr safeRemoveObjectAtIndex:indexPath.row] ;
    [self.mTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom] ;
}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *deleteAct = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"    " handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [_dataArr safeRemoveObjectAtIndex:indexPath.row];
        [self.mTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
    }];
    UITableViewRowAction *editAct = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"    " handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        EditDriverViewController *deriveVC = [EditDriverViewController new]; //[AppUtils VCFromSB:@"Main" vcID:@"EditDriverVC"];
        deriveVC.dm = [_dataArr safeObjectAtIndex:indexPath.row];
        deriveVC.delegate = self;
        deriveVC.index = indexPath.row;
        [self.navigationController pushViewController:deriveVC animated:YES];
    }];
    return @[deleteAct,editAct];
}

#pragma mark -EditDriverViewControllerDelegate
- (void)didPopWithDriver:(DriverModel *)driver WithIndex:(NSInteger)index
{
    [_dataArr replaceObjectAtIndex:index withObject:driver];
    [self.mTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (UITableView *)mTableView
{
    if (!_mTableView) {
        _mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, _cardView.width, _cardView.height) style:UITableViewStylePlain];
        _mTableView.delegate = self;
        _mTableView.dataSource = self;
        _mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mTableView.tableFooterView = [UIView new];
    }
    return _mTableView;
}

- (DQAddNewDeriveView *)newDeriveView
{
    if (!_newDeriveView) {
        _newDeriveView = [[DQAddNewDeriveView alloc] initWithFrame:CGRectMake(0, 0, _cardView.width, _cardView.height)];
        _newDeriveView.delegate = self;
        _newDeriveView.type = DQAddNewDeriveViewNewAddStyle;
    }
    return _newDeriveView;
}

#pragma hidekeyboard
- (IBAction)hideKeyBoard
{
    [self.view endEditing:YES];
}

/**
 修改司机。服务流接口
 */
- (void)fetchEdit
{
    NSDictionary *dic = @{@"userid":@(self.baseUser.userid),
                        @"type":[NSObject changeType:self.baseUser.type],
                        @"projectid":@(_projectid),
                        @"drivers":[DriverModel mj_keyValuesArrayWithObjectArray:_dataArr],
                        @"usertype":[NSObject changeType:self.baseUser.usertype]
                        };
   [[DQServiceInterface sharedInstance] dq_getModifyDeriveAPI:dic success:^(id result) {
       if (result != nil) {
           MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"操作成功,请在设备列表界面重新确认设备!" actionTitle:@"" duration:3.0];
           [t show];
           [self.navigationController popToRootViewControllerAnimated:YES];//回到项目列表页
           
           if (self.basedelegate && [self.basedelegate respondsToSelector:@selector(didPopFromNextVC)]) {
               [self.basedelegate didPopFromNextVC];
           };
       }
   } failture:^(NSError *error) {
       
   }];
}

@end
