//
//  ServiceStreamViewController.m
//  WebThings
//
//  Created by machinsight on 2017/6/27.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "ServiceStreamViewController.h"

#import "ServiceScreamSection.h"
#import "EMINormalTableViewCell.h"
#import "QQGTDetailCell.h"
#import "NoProblemLeftCell.h"
#import "NoProblemRightCell.h"
#import "BaoHuiCell.h"
#import "ServiceTakePhotoCell.h"
#import "ServiceImageCell.h"
#import "TechnicalDisclosureCell.h"
#import "ServiceBaoGao.h"
#import "DeviceQiZuDetailCell.h"
#import "DriverListCell.h"
#import "DeviceWHDetailCell.h"
#import "DeviceGZDetailCell.h"
#import "ServiceRequestListCell.h"
#import "StopListCell.h"
#import "CostMakeCell.h"
#import "EvaluateOriginCell.h"
#import "EvaluateReplyCell.h"

#import "ServiceCenterBaseModel.h"

#import "ZLPhotoActionSheet.h"
#import "ZLDefine.h"
#import "ZLCollectionCell.h"
#import <Photos/Photos.h>
#import "ZLShowGifViewController.h"
#import "ZLShowVideoViewController.h"
#import "ZLPhotoModel.h"
#import "MBProgressHUD.h"

#import "AddQiZuListViewController.h"
#import "AddDeviceWHListViewController.h"
#import "AddDeviceWXListViewController.h"
#import "AddServiceListViewController.h"
#import "AddStopListViewController.h"
#import "ServiceCommentViewController.h"
#import "ChooseMaintainers.h"
#import "AddDriverViewController.h"

#import "ObtainServiceflowWI.h"
#import "ServiceNewsWI.h"
#import "AgreeorDismissWI.h"
#import "MaintainFinishDo.h"
#import "RepairFinishWI.h"
#import "ReplyEvaluateWI.h"


@interface ServiceStreamViewController ()<ServiceScreamSectionDelegate,UIScrollViewDelegate,ServiceTakePhotoCellDelegate,EMIBaseViewControllerDelegate>
{
    NSMutableArray      <ServiceCenterBaseModel *> *firstCellArr;
    NSMutableArray      <ServiceCenterBaseModel *> *secondCellArr;
    NSMutableArray      <ServiceCenterBaseModel *> *thirdCellArr;
    NSMutableArray      <ServiceCenterBaseModel *> *fourthCellArr;
    NSMutableArray      <ServiceCenterBaseModel *> *fifththCellArr;
    NSMutableArray      <ServiceCenterBaseModel *> *sixthCellArr;
    NSMutableArray      <ServiceCenterBaseModel *> *seventhCellArr;
    NSMutableArray      <ServiceCenterBaseModel *> *eighthCellArr;
    NSMutableArray      <ServiceCenterBaseModel *> *ninthCellArr;
    NSMutableArray      <ServiceCenterBaseModel *> *tenthCellArr;
    
    ServiceCenterBaseModel *portalModel;//传送门，即用于传往下一个页面的
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

//选择照片
@property (nonatomic, strong) NSMutableArray<PHAsset *> *lastSelectAssets;
@property (nonatomic, strong) NSMutableArray<UIImage *> *lastSelectPhotos;
@property (nonatomic, strong) NSMutableArray *arrDataSources;
@property (nonatomic, strong) NSMutableArray *alreadyUploadImgUrls;
@property (nonatomic, assign) NSInteger whichTakePhoto;//是那个按钮的选照0,设备报装，1，设备安装

@property (nonatomic, strong) NSMutableArray <NSMutableArray <ServiceCenterBaseModel *> *> *dataSource;
@property (nonatomic, strong) NSMutableArray <ServiceCenterBaseModel *> *sectionArray;
@property (nonatomic, strong) NSMutableArray *stateArray;

@property (nonatomic, assign) NSInteger clickedSectionIndex;

@property (nonatomic, assign) NSInteger billid;//单据id

@property (weak, nonatomic) IBOutlet UIView *replyFatherV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *replyFatherVBottomSpace;
@property (weak, nonatomic) IBOutlet UITextField *replyTF;

@end

@implementation ServiceStreamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"业务站";
    [self initArr];
    [self initView];
    //[EMINavigationController addAppBar:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //监听当键盘将要出现时
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //监听当键将要退出时
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

//当键盘出现
- (void)keyboardWillShow:(NSNotification *)notification
{
    //获取键盘的高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [value CGRectValue];
    int height = keyboardRect.size.height;
    self.replyFatherVBottomSpace.constant = height;
}

//当键退出
- (void)keyboardWillHide:(NSNotification *)notification
{
    self.replyFatherVBottomSpace.constant = 0;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initArr{
    
    _projectid = _projectModel.projectid;
    _drivertype = _projectModel.drivertype;
    
    _sectionArray  = [NSMutableArray array];
    
    firstCellArr = [NSMutableArray array];
    
    secondCellArr = [NSMutableArray array];
    
    
    thirdCellArr = [NSMutableArray array];

    fourthCellArr = [NSMutableArray array];

    fifththCellArr = [NSMutableArray array];

    sixthCellArr = [NSMutableArray array];

    
    seventhCellArr = [NSMutableArray array];

    
    eighthCellArr = [NSMutableArray array];

    
    ninthCellArr = [NSMutableArray array];

    
    tenthCellArr = [NSMutableArray array];
    
    _dataSource = [NSMutableArray arrayWithObjects:firstCellArr,secondCellArr,thirdCellArr,fourthCellArr,fifththCellArr,sixthCellArr,seventhCellArr,eighthCellArr,ninthCellArr,tenthCellArr, nil];
    
    
    _alreadyUploadImgUrls = [NSMutableArray array];
}

- (void)initView{
    [self fetchServiceState];//服物流状态
}
#pragma mark -
#pragma mark - UITableViewDataSource UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _sectionArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([_stateArray[section] boolValue]){
        //如果是展开状态
        NSArray *array = [_dataSource objectAtIndex:section];
        return array.count;
    }else{
        //如果是闭合，返回0
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ServiceCenterBaseModel *m = _dataSource[indexPath.section][indexPath.row];
    m.deviceaddress = _dm.installationsite;
    [m returnCellHeight];
    
    if (m.enumstateid == 12 || m.enumstateid == 15 || m.enumstateid == 18|| m.enumstateid == 21|| m.enumstateid == 24 || m.enumstateid == 27|| m.enumstateid == 30 || m.enumstateid == 33|| m.enumstateid == 38|| m.enumstateid == 42|| m.enumstateid == 46 ||
        m.enumstateid == 36|| m.enumstateid == 40|| m.enumstateid == 44) {
        //已确认
        if (m.direction == 0) {
            NoProblemLeftCell *cell = [NoProblemLeftCell cellWithTableView:tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setViewValuesWithModel:m];
            return cell;
        }else{
            NoProblemRightCell *cell = [NoProblemRightCell cellWithTableView:tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            [cell setAction1:@selector(alreadySure:) target:self];
            
            [cell setViewValuesWithModel:m];
            return cell;
        }
        
    }
    if (m.enumstateid == 13 || m.enumstateid == 16 || m.enumstateid == 19|| m.enumstateid == 22|| m.enumstateid == 25 || m.enumstateid == 28 || m.enumstateid == 34 || m.enumstateid == 50|| m.enumstateid == 51|| m.enumstateid == 52) {
        //已驳回
        BaoHuiCell *cell = [BaoHuiCell cellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setViewValuesWithModel:m];
        return cell;
    }
    
    //前期沟通
    if (indexPath.section == 0) {
        if (m.enumstateid == 11) {
            //前期沟通
            QQGTDetailCell *cell = [QQGTDetailCell cellWithTableView:tableView];
            [cell setViewValuesWithModel:m];
            [cell setAction1:@selector(Agree:) Action2:@selector(Refuse:) target:self];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        if (m.enumstateid == 169) {
            ServiceTakePhotoCell *cell = [ServiceTakePhotoCell cellWithTableView:tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setBtnTitle:@"修改项目" andTag:13];
            [cell setBtnWidth:130];
            [cell setBtnImage:@"ic_create"];
            cell.delegate = self;
            [cell setLineHide:NO];
            return cell;
        }
    }
    
    //设备报装
    if (indexPath.section == 1) {
        if (m.enumstateid == 153) {
            //上传按钮
            ServiceTakePhotoCell *cell = [ServiceTakePhotoCell cellWithTableView:tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setBtnTitle:@"上传报装资料" andTag:0];
            [cell setBtnWidth:140.f];
            [cell setBtnImage:@"ic_photo"];
            cell.delegate = self;
            [cell setLineHide:NO];
            return cell;
        }
        if (m.enumstateid == 14) {
            //设备报装单据
            ServiceImageCell *cell = [ServiceImageCell cellWithTableView:tableView];
            [cell setViewValuesWithModel:m];
            [cell setAction1:@selector(Agree:) Action2:@selector(Refuse:) target:self];
            [cell setBtnTag1:3 Tag2:4];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    //设备安装
    if (indexPath.section == 2) {
        if (m.enumstateid == 154) {
            //申请现场技术交底按钮
            ServiceTakePhotoCell *cell = [ServiceTakePhotoCell cellWithTableView:tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setBtnTitle:@"申请现场技术交底"  andTag:1];
            [cell setBtnImage:@"flow_of_service_ic_send"];
            [cell setBtnWidth:170.f];
            cell.delegate = self;
            [cell setLineHide:NO];
            return cell;
        }
        if (m.enumstateid == 17) {
            //现场技术交底单据
            TechnicalDisclosureCell *cell = [TechnicalDisclosureCell cellWithTableView:tableView];
            [cell setViewValuesWithModel:m];
            [cell setAction1:@selector(Agree:) Action2:@selector(Refuse:) target:self];
            [cell setBtnTag1:5 Tag2:6];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        
        if (m.enumstateid == 155) {
            //上传安装凭证按钮
            ServiceTakePhotoCell *cell = [ServiceTakePhotoCell cellWithTableView:tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setBtnTitle:@"上传安装凭证" andTag:2];
            [cell setBtnWidth:140.f];
            [cell setBtnImage:@"ic_photo"];
            cell.delegate = self;
            [cell setLineHide:NO];
            return cell;
        }
        if (m.enumstateid == 20) {
            //安装凭证单据
            ServiceImageCell *cell = [ServiceImageCell cellWithTableView:tableView];
            [cell setViewValuesWithModel:m];
            [cell setAction1:@selector(Agree:) Action2:@selector(Refuse:) target:self];
            [cell setBtnTag1:7 Tag2:8];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        if (m.enumstateid == 156) {
            //上传第三方验收凭证按钮
            ServiceTakePhotoCell *cell = [ServiceTakePhotoCell cellWithTableView:tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setBtnTitle:@"上传第三方验收凭证" andTag:3];
            [cell setBtnImage:@"ic_photo"];
            [cell setBtnWidth:190.f];
            cell.delegate = self;
            [cell setLineHide:NO];
            return cell;
        }
        if (m.enumstateid == 23) {
            //第三方验收凭证单据
            ServiceImageCell *cell = [ServiceImageCell cellWithTableView:tableView];
            [cell setViewValuesWithModel:m];
            [cell setAction1:@selector(Agree:) Action2:@selector(Refuse:) target:self];
            [cell setBtnTag1:9 Tag2:10];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        if (m.enumstateid == 157) {
            //安装报告
            ServiceBaoGao *cell = [ServiceBaoGao cellWithTableView:tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    //设备启租
    if (indexPath.section == 3) {
        if (m.enumstateid == 158 || m.enumstateid == 159) {
            ServiceTakePhotoCell *cell = [ServiceTakePhotoCell cellWithTableView:tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (m.enumstateid == 158) {
                [cell setBtnTitle:@"新增启租单"  andTag:4];
            }else{
                [cell setBtnTitle:@"修改启租单"  andTag:5];
                portalModel = _dataSource[indexPath.section][indexPath.row-2];
            }
            [cell setBtnImage:@"ic_create"];
            [cell setBtnWidth:135.f];
            cell.delegate = self;
            [cell setLineHide:NO];
            return cell;
        }
        if (m.enumstateid == 26) {
            //启租单据
            DeviceQiZuDetailCell *cell = [DeviceQiZuDetailCell cellWithTableView:tableView];
            [cell setViewValuesWithModel:m];
            [cell setAction1:@selector(Agree:) Action2:@selector(Refuse:) target:self];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        if (m.enumstateid == 168) {
            ServiceTakePhotoCell *cell = [ServiceTakePhotoCell cellWithTableView:tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setBtnTitle:@"设备锁机"  andTag:12];
            [cell setBtnImage:@"flow_of_service_ic_lock"];
            [cell setBtnWidth:125.f];
            [cell setBtnBgColor:[UIColor colorWithHexString:@"#DC4437"]];
            cell.delegate = self;
            [cell setLineHide:NO];
            return cell;
        }
    }
    //司机确认
    if (indexPath.section == 4) {
        if (m.enumstateid == 166) {
            //自己找司机
            EvaluateReplyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EvaluateReplyCell"];
            if (!cell) {
                cell = [[EvaluateReplyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"EvaluateReplyCell"];
            }
            [cell setViewValuesWithModel:m];
            m.cellHeight = [cell cellHeightWithModel:m];
            return cell;
        }
        if (m.enumstateid == 32) {
//            DriverListCell *cell = [DriverListCell cellWithTableView:tableView];
            DriverListCell *cell = [[DriverListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DriverListCell"];
            [cell setViewValuesWithModel:m];
            [cell setAction1:@selector(Agree:) Action2:@selector(Refuse:) target:self];
            m.cellHeight = [cell cellHeightWithModel:m];
            return cell;
        }
        if (m.enumstateid == 167) {
            ServiceTakePhotoCell *cell = [ServiceTakePhotoCell cellWithTableView:tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setBtnTitle:@"修改司机"  andTag:11];
            [cell setBtnWidth:130];
            [cell setBtnImage:@"ic_create"];
            cell.delegate = self;
            [cell setLineHide:NO];
            portalModel = _dataSource[indexPath.section][indexPath.row-2];
            return cell;
        }
    }
    //设备维保
    if (indexPath.section == 5) {
        if (m.enumstateid == 160) {
            ServiceTakePhotoCell *cell = [ServiceTakePhotoCell cellWithTableView:tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setBtnWidth:150];
            [cell setBtnTitle:@"新增设备维保单"  andTag:6];
            [cell setBtnImage:@"ic_create"];
            [cell setBtnBgColor:[UIColor colorWithHexString:@"417EE8"]];
            cell.delegate = self;
            [cell setLineHide:NO];
            return cell;
        }
        if (m.enumstateid == 35) {
            DeviceWHDetailCell *cell = [DeviceWHDetailCell cellWithTableView:tableView];
            [cell setViewValuesWithModel:m];
            [cell setAction1:@selector(alreadySure:) target:self];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        if (m.enumstateid == 37) {
            //维保完成提交单据
            TechnicalDisclosureCell *cell = [TechnicalDisclosureCell cellWithTableView:tableView];
            [cell setViewValuesWithModel:m];
            [cell setAction1:@selector(Agree:) Action2:@selector(Refuse:) target:self];
            [cell setBtnTag1:13 Tag2:14];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    
    //设备维修
    if (indexPath.section == 6) {
        if (m.enumstateid == 161) {
            ServiceTakePhotoCell *cell = [ServiceTakePhotoCell cellWithTableView:tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setBtnTitle:@"新增设备维修单"  andTag:7];
            [cell setBtnWidth:150];
            [cell setBtnImage:@"ic_create"];
            cell.delegate = self;
            [cell setLineHide:NO];
            return cell;
        }
        if (m.enumstateid == 39) {
            DeviceGZDetailCell *cell = [DeviceGZDetailCell cellWithTableView:tableView];
            //[tableView dequeueReusableCellWithIdentifier:@"GZDetailCellIdentifier"];
//            if (!cell) {
//                cell = [[DeviceGZDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GZDetailCellIdentifier"];
//            }
            [cell setViewValuesWithModel:m];
            m.cellHeight = [cell cellHeight];
            [cell setAction1:@selector(alreadySure:) target:self];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        if (m.enumstateid == 41) {
            //维修完成提交单据
            TechnicalDisclosureCell *cell = [TechnicalDisclosureCell cellWithTableView:tableView];
            [cell setViewValuesWithModel:m];
            [cell setAction1:@selector(Agree:) Action2:@selector(Refuse:) target:self];
            [cell setBtnTag1:15 Tag2:16];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        
    }
    //加高
    if (indexPath.section == 7) {
        if (m.enumstateid == 162) {
            ServiceTakePhotoCell *cell = [ServiceTakePhotoCell cellWithTableView:tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setBtnTitle:@"新增服务要求表"  andTag:8];
            [cell setBtnWidth:150];
            [cell setBtnImage:@"ic_create"];
            cell.delegate = self;
            [cell setLineHide:NO];
            return cell;
        }
        if (m.enumstateid == 43) {
            ServiceRequestListCell *cell = [ServiceRequestListCell cellWithTableView:tableView];
            [cell setViewValuesWithModel:m];
            [cell setAction1:@selector(alreadySure:) target:self];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        if (m.enumstateid == 45) {
            //维修完成提交单据
            TechnicalDisclosureCell *cell = [TechnicalDisclosureCell cellWithTableView:tableView];
            [cell setViewValuesWithModel:m];
            [cell setAction1:@selector(Agree:) Action2:@selector(Refuse:) target:self];
            [cell setBtnTag1:17 Tag2:18];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        
    }
    //设备停租
    if (indexPath.section == 8) {
        if (m.enumstateid == 163) {
            ServiceTakePhotoCell *cell = [ServiceTakePhotoCell cellWithTableView:tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setBtnTitle:@"新增停租单"  andTag:9];
            [cell setBtnImage:@"ic_create"];
            [cell setBtnWidth:140.f];
            cell.delegate = self;
            [cell setLineHide:NO];
            return cell;
        }
        if (m.enumstateid == 29) {
            //停租单据
            StopListCell *cell = [StopListCell cellWithTableView:tableView];
            [cell setViewValuesWithModel:m];
            [cell setAction1:@selector(Agree:) Action2:@selector(Refuse:) target:self];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        if (m.enumstateid == 31) {
            //停租单驳回
            NoProblemRightCell *cell = [NoProblemRightCell cellWithTableView:tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            [cell setAction1:@selector(alreadySure:) target:self];
            
            [cell setViewValuesWithModel:m];
            return cell;
        }
        if (m.enumstateid == 165) {
            //费用清算
            CostMakeCell *cell = [CostMakeCell cellWithTableView:tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setViewValuesWithModel:m];
            return cell;
        }
        
    }
    //服务评价
    if (indexPath.section == 9) {
        if (m.enumstateid == 164) {
            ServiceTakePhotoCell *cell = [ServiceTakePhotoCell cellWithTableView:tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setBtnTitle:@"新增服务评价"  andTag:10];
            [cell setBtnImage:@"ic_create"];
            [cell setBtnWidth:150.f];
            [cell setLineHide:YES];
            cell.delegate = self;
            return cell;
        }
        if (m.enumstateid == 48) {
            //评价
            EvaluateOriginCell *cell = [EvaluateOriginCell cellWithTableView:tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setViewValuesWithModel:m];
            [cell setAction1:@selector(alreadySure:) target:self];
            m.cellHeight = [cell cellHeightWithModel:m];
            return cell;
        }
        if (m.enumstateid == 49) {
            //回复
            EvaluateReplyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EvaluateReplyCellIdentifier"];
            if (!cell) {
                cell = [[EvaluateReplyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"EvaluateReplyCellIdentifier"];
            }
            [cell setViewValuesWithModel:m];
            m.cellHeight = [cell cellHeightWithModel:m];
            return cell;
        }
        
    }
    return nil;
}

#pragma 0,上传报装图片1：现场技术交底2.安装凭证3.第三方验收凭证 4.跳转至新增启租单 5.跳转至修改启租单
//6.跳转至设备维保单 7.跳转至设备维修单 8.跳转至新增服务要求表 9.跳转至新增停租单 10.跳转至新增服务评价 11.跳转至修改司机,12.设备锁机13.修改项目
- (void)takePhoto:(ImgButton *)btn {
    if (btn.tag == 1) {
        //现场技术交底
        [self fetchTechnicalDisclosure];
    }else if (btn.tag == 4) {
        //跳转至新增启租单
        AddQiZuListViewController *VC = [AppUtils VCFromSB:@"Main" vcID:@"AddQiZuListVC"];
        VC.isAdd = 0;
        VC.dm = _dm;
        VC.projectid = _projectid;
        VC.basedelegate = self;
        [self.navigationController pushViewController:VC animated:YES];
        
    }else if (btn.tag == 5) {
        //跳转至修改启租单
        AddQiZuListViewController *VC = [AppUtils VCFromSB:@"Main" vcID:@"AddQiZuListVC"];
        VC.isAdd = 1;
        VC.dm = _dm;
        VC.projectid = _projectid;
        VC.portalModel = portalModel;
        VC.basedelegate = self;
        [self.navigationController pushViewController:VC animated:YES];
        
    }else if(btn.tag == 6){
        //跳转至设备维保单
        AddDeviceWHListViewController *VC = [AppUtils VCFromSB:@"Main" vcID:@"AddDeviceWHListVC"];
        VC.dm = _dm;
        VC.projectid = _projectid;
        VC.basedelegate = self;
        [self.navigationController pushViewController:VC animated:YES];
    }else if(btn.tag == 7){
        //跳转至设备维修单
        AddDeviceWXListViewController *VC = [AppUtils VCFromSB:@"Main" vcID:@"AddDeviceWXListVC"];
        VC.dm = _dm;
        VC.projectid = _projectid;
        VC.basedelegate = self;
        [self.navigationController pushViewController:VC animated:YES];
    }else if(btn.tag == 8){
        //跳转至新增服务要求表
        AddServiceListViewController *VC = [AppUtils VCFromSB:@"Main" vcID:@"AddServiceListVC"];
        VC.dm = _dm;
        VC.projectid = _projectid;
        VC.basedelegate = self;
        [self.navigationController pushViewController:VC animated:YES];
    }else if(btn.tag == 9){
        //跳转至新增停租单
        AddStopListViewController *VC = [AppUtils VCFromSB:@"Main" vcID:@"AddStopListVC"];
        VC.dm = _dm;
        VC.projectid = _projectid;
        VC.basedelegate = self;
        [self.navigationController pushViewController:VC animated:YES];
    }else if(btn.tag == 10){
        //跳转至新增服务评价
        ServiceCommentViewController *VC = [AppUtils VCFromSB:@"Main" vcID:@"ServiceCommentVC"];
        VC.dm = _dm;
        VC.projectid = _projectid;
        VC.basedelegate = self;
        [self.navigationController pushViewController:VC animated:YES];
    }else if(btn.tag == 11){
        //修改司机
        AddDriverViewController *VC = [AppUtils VCFromSB:@"Main" vcID:@"AddDriverVC"];
        VC.basedelegate = self;
        VC.isNew  = 1;
        VC.isfromServiceStream = 1;
        VC.dm = _dm;
        VC.projectid = _projectid;
        VC.dataArr = [NSMutableArray arrayWithArray:portalModel.dirverrenthistoryList];
        [self.navigationController pushViewController:VC animated:YES];
    }else if(btn.tag == 12){
        //设备锁机
        [self fetchLockMachine];
    }else if(btn.tag == 13){
        //修改项目
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else{
        _whichTakePhoto = btn.tag;
        [self showWithPreview:YES];
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ServiceScreamSection *headSec = [[ServiceScreamSection alloc] init];
    headSec.delegate = self;
    [headSec setViewValuesWithModel:_sectionArray[section]];
    [headSec setIsOpen:[_stateArray[section] boolValue]];
    return headSec;
}
#pragma mark
#pragma mark  -select cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _dataSource[indexPath.section][indexPath.row].cellHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.00001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 59;
    }
    if (section == 9) {
        return 29;
    }
    return 53;
}
//去掉UItableview headerview黏性(sticky)
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView)
    {
        CGFloat sectionHeaderHeight = 10; //sectionHeaderHeight
        if (scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y >= 0) {
            
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
            
        } else if (scrollView.contentOffset.y >= sectionHeaderHeight) {
            
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
            
        }
    }
}
#pragma sectionBtnDelegate
- (void)sectionBtnClicked:(NSInteger)index{

        if (!_dataSource[index].count) {
            if (index == 4) {
                //司机
                if ([self.drivertype isEqualToString:@"租赁方司机"]) {
                    //司机确认
                    [self fetchServiceNewsWithFlowType:_sectionArray[index]];
                }
            }else{
                [self fetchServiceNewsWithFlowType:_sectionArray[index]];
            }
        }
    
        //判断状态值
        if ([_stateArray[index] boolValue]){
            //修改
            [_stateArray replaceObjectAtIndex:index withObject:@(NO)];
            [_tableView reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationAutomatic];
        }else{
            if (index != _clickedSectionIndex) {
                [_stateArray replaceObjectAtIndex:_clickedSectionIndex withObject:@(NO)];
                 [_tableView reloadSections:[NSIndexSet indexSetWithIndex:_clickedSectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            [_stateArray replaceObjectAtIndex:index withObject:@(YES)];
            [_tableView reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    
        _clickedSectionIndex = index;
}

- (void)showWithPreview:(BOOL)preview
{
    ZLPhotoActionSheet *actionSheet = [self getPas];
    [actionSheet showPreviewAnimated:YES];
}

- (ZLPhotoActionSheet *)getPas
{
    ZLPhotoActionSheet *actionSheet = [[ZLPhotoActionSheet alloc] init];
    actionSheet.sortAscending = NO;
    actionSheet.allowSelectImage = YES;
    actionSheet.allowSelectGif = NO;
    actionSheet.allowSelectVideo = NO;
    actionSheet.allowTakePhotoInLibrary = NO;
    //设置照片最大预览数
    actionSheet.maxPreviewCount = 9;
    //设置照片最大选择数
    actionSheet.maxSelectCount = kNUMBER_MAXPHOTO;
    actionSheet.cellCornerRadio = 0;
    actionSheet.sender = self;
    
    NSMutableArray *arr = [NSMutableArray array];
    for (PHAsset *asset in self.lastSelectAssets) {
        if (asset.mediaType == PHAssetMediaTypeImage && ![[asset valueForKey:@"filename"] hasSuffix:@"GIF"]) {
            [arr addObject:asset];
        }
    }
    actionSheet.arrSelectedAssets = nil;
    
    weakify(self);
    [actionSheet setSelectImageBlock:^(NSArray<UIImage *> * _Nonnull images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
        strongify(weakSelf);
        strongSelf.arrDataSources = [NSMutableArray arrayWithArray:images];
        strongSelf.lastSelectAssets = assets.mutableCopy;
        strongSelf.lastSelectPhotos = images.mutableCopy;
        DQLog(@"image:%@", images);
        
        [strongSelf handleUploadImg];
    }];
    
    return actionSheet;
}

/**
 获取服务流状态
 */
- (void)fetchServiceState
{
    ObtainServiceflowWI *lwi = [[ObtainServiceflowWI alloc] init];
    NSArray *arr = @[@(self.baseUser.userid),self.baseUser.type,self.baseUser.usertype,@(_projectid),@(_dm.deviceid),@(_dm.projectdeviceid)];
    NSDictionary *param = [lwi inBox:arr];
    [CKNetTools requestWithRequestType:POST WithURL:lwi.fullUrl WithParamater:param WithProgressBlock:^(NSProgress *process) {
        
    } WithSuccessBlock:^(id returnValue) {
        NSArray *temp = [lwi unBox:returnValue];
        if ([temp[0] integerValue] == 1) {
            _sectionArray = temp[1];
            _stateArray = [NSMutableArray array];
            
            for (int i = 0; i < _sectionArray.count; i++)
            {
                if ([_sectionArray[i].flowtype isEqualToString:@"设备拆除"]) {
                    _sectionArray[i].flowtype = @"拆除设备";
                }
                //其他分区都是闭合
                [_stateArray addObject:@(NO)];
            }
            [self.tableView reloadData];
            //前期沟通
            [self fetchServiceNewsWithFlowType:_sectionArray[0]];
            if ([self.drivertype isEqualToString:@"租赁方司机"]) {
                //司机确认
                [self fetchServiceNewsWithFlowType:_sectionArray[4]];
            }else{
                //自己找司机
                ServiceCenterBaseModel *tempM = [[ServiceCenterBaseModel alloc] init];
                tempM.enumstateid = 166;
                tempM.sendheadimg = self.baseUser.headimg;
                tempM.sendname = self.baseUser.name;
                tempM.sendusertypename = self.baseUser.usertype;
                tempM.sendtime = self.projectModel.indate;
                tempM.title = @"用户自己找司机";
                [_dataSource[4] addObject:tempM];
                [self.tableView reloadData];
            }
            
        }
        
        
    } WithFailureBlock:^(NSError *error) {
        
    }];
}

/**
 获取服务流消息
 */
- (void)fetchServiceNewsWithFlowType:(ServiceCenterBaseModel *)baseM{

    ServiceNewsWI *lwi = [[ServiceNewsWI alloc] init];
    NSArray *arr = @[@(self.baseUser.userid),self.baseUser.type,@(_projectid),@(_dm.deviceid),baseM.flowtype,self.baseUser.usertype,@(_dm.projectdeviceid)];
    NSDictionary *param = [lwi inBox:arr];
    [CKNetTools requestWithRequestType:POST WithURL:lwi.fullUrl WithParamater:param WithProgressBlock:^(NSProgress *process) {
        
    } WithSuccessBlock:^(id returnValue) {
        NSArray *temp = [lwi unBox:returnValue];
        if ([temp[0] integerValue] == 1) {
            NSMutableArray <ServiceCenterBaseModel *> *modelArr = temp[1];
            [self handleNewsData:baseM withModelArr:modelArr];
        }
        
    } WithFailureBlock:^(NSError *error) {
        
    }];
}

/**
 根据flowtype来处理数据
 @param baseM flowtype
 @param modelArr 数据
 */
- (void)handleNewsData:(ServiceCenterBaseModel *)baseM withModelArr:(NSMutableArray <ServiceCenterBaseModel *> *)modelArr{
    NSInteger dataSourceIndex = [baseM returnIndex]-1;
    switch (dataSourceIndex) {
        case 0:
        {
            _dataSource[dataSourceIndex] = modelArr;
            //前期沟通最后一条为通过状态，那么司机就可点，否则不可点
            if (modelArr[modelArr.count-1].enumstateid == 12) {
                _sectionArray[4].canclick = 1;
            }else{
                _sectionArray[4].canclick = 0;
            }
            if (modelArr[modelArr.count-1].enumstateid == 13 && self.isZuLin && ![self isCEO]) {
                //最后一条为驳回状态且为租赁者，最后一条贴一条按钮cell
                ServiceCenterBaseModel *tempM = [[ServiceCenterBaseModel alloc] init];
                tempM.enumstateid = 169;//修改项目
                [_dataSource[dataSourceIndex] addObject:tempM];
            }
        }
            break;
        case 1:
            //设备报装
        {
            if (modelArr.count > 0) {
                // start:只显示有包装资料后面一条驳回信息
                NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
                for (int i = 0; i < [modelArr count]; i ++ ) {
                    ServiceCenterBaseModel *model = modelArr[i];
                    
                    if (model.enumstateid != 16) {
                        if ([model.msgattachmentList count] > 0) {
                            [array addObject:model];
                        }
                        
                        if ([modelArr count] > i + 1) {
                            ServiceCenterBaseModel *modelNext = modelArr[i + 1];
                            [array addObject:modelNext];
                        }
                    }
                }
                // end: 只显示有包装资料后面一条驳回信息
                _dataSource[dataSourceIndex] = array;
                if (modelArr[modelArr.count-1].enumstateid == 16 && self.isZuLin && ![self isCEO]) {
                    //最后一条为驳回状态且为租赁者，最后一条贴一条按钮cell
                    ServiceCenterBaseModel *tempM = [[ServiceCenterBaseModel alloc] init];
                    tempM.enumstateid = 153;//设备报装按钮
                    [_dataSource[dataSourceIndex] addObject:tempM];
                }
            } else {
                if (self.isZuLin && ![self isCEO]) {
                    ServiceCenterBaseModel *tempM = [[ServiceCenterBaseModel alloc] init];
                    tempM.enumstateid = 153;//设备报装按钮
                    [_dataSource[dataSourceIndex] addObject:tempM];
                }
            }
        }
            break;
        case 2:
        {
            //设备安装
            if (modelArr.count > 0) {
                _dataSource[dataSourceIndex] = modelArr;
                if (modelArr[modelArr.count-1].enumstateid == 19 && self.isZuLin  && ![self isCEO]) {
                    //最后一条为技术交底驳回状态且为租赁者，最后一条贴一条 设备现场技术交底按钮cell
                    ServiceCenterBaseModel *tempM = [[ServiceCenterBaseModel alloc] init];
                    tempM.enumstateid = 154;//设备现场技术交底按钮
                    [_dataSource[dataSourceIndex] addObject:tempM];
                }
                if (modelArr[modelArr.count-1].enumstateid == 18 && self.isZuLin && ![self isCEO]) {
                    //最后一条为技术交底通过状态且为租赁者，最后一条贴一条 上传安装凭证按钮cell
                    ServiceCenterBaseModel *tempM = [[ServiceCenterBaseModel alloc] init];
                    tempM.enumstateid = 155;//上传安装凭证按钮
                    [_dataSource[dataSourceIndex] addObject:tempM];
                }
                if (modelArr[modelArr.count-1].enumstateid == 22 && self.isZuLin && ![self isCEO]) {
                    //最后一条为安装凭证驳回状态且为租赁者，最后一条贴一条 上传安装凭证按钮cell
                    ServiceCenterBaseModel *tempM = [[ServiceCenterBaseModel alloc] init];
                    tempM.enumstateid = 155;//上传安装凭证按钮
                    [_dataSource[dataSourceIndex] addObject:tempM];
                }
                if (modelArr[modelArr.count-1].enumstateid == 21 && self.isZuLin && ![self isCEO]) {
                    //最后一条为安装凭证通过状态且为租赁者，最后一条贴一条 上传第三方凭证按钮cell
                    ServiceCenterBaseModel *tempM = [[ServiceCenterBaseModel alloc] init];
                    tempM.enumstateid = 156;//上传第三方验收凭证按钮
                    [_dataSource[dataSourceIndex] addObject:tempM];
                }
                if (modelArr[modelArr.count-1].enumstateid == 25 && self.isZuLin && ![self isCEO]) {
                    //最后一条为第三方凭证驳回状态且为租赁者，最后一条贴一条 上传第三方凭证按钮cell
                    ServiceCenterBaseModel *tempM = [[ServiceCenterBaseModel alloc] init];
                    tempM.enumstateid = 156;//上传第三方验收凭证按钮
                    [_dataSource[dataSourceIndex] addObject:tempM];
                }
                if (modelArr[modelArr.count-1].enumstateid == 24) {
                    //最后一条为第三方凭证确认状态，最后一条贴一条 安装报告cell
                    ServiceCenterBaseModel *tempM = [[ServiceCenterBaseModel alloc] init];
                    tempM.enumstateid = 157;//安装报告cell
                    [_dataSource[dataSourceIndex] addObject:tempM];
                }
            }else{
                if (self.isZuLin && ![self isCEO]) {
                    ServiceCenterBaseModel *tempM = [[ServiceCenterBaseModel alloc] init];
                    tempM.enumstateid = 154;//设备现场技术交底按钮
                    [_dataSource[dataSourceIndex] addObject:tempM];
                }
            }
        }
            break;
        case 3:
            //设备启租
        {
            if (modelArr.count > 0) {
                _dataSource[dataSourceIndex] = modelArr;
                if (modelArr[modelArr.count-1].enumstateid == 28 && self.isZuLin && ![self isCEO]) {
                    //最后一条为驳回状态且为租赁者，最后一条贴一条按钮cell
                    ServiceCenterBaseModel *tempM = [[ServiceCenterBaseModel alloc] init];
                    tempM.enumstateid = 159;//修改启租单按钮
                    [_dataSource[dataSourceIndex] addObject:tempM];
                }
                if (modelArr[modelArr.count-1].enumstateid == 27 && self.isZuLin && ![self isCEO]) {
                    //最后一条为确认状态且为租赁者，最后一条贴一条按钮cell
                    ServiceCenterBaseModel *tempM = [[ServiceCenterBaseModel alloc] init];
                    tempM.enumstateid = 168;//设备锁机按钮
                    [_dataSource[dataSourceIndex] addObject:tempM];
                }
            }else{
                if (self.isZuLin && ![self isCEO]) {
                    ServiceCenterBaseModel *tempM = [[ServiceCenterBaseModel alloc] init];
                    tempM.enumstateid = 158;//新增启租单按钮
                    [_dataSource[dataSourceIndex] addObject:tempM];
                }
            }
        }
            break;
        case 4:
        {
            //司机确认
            _dataSource[dataSourceIndex] = modelArr;
            if (modelArr.count > 0) {
                if (modelArr[modelArr.count-1].enumstateid == 34 && self.isZuLin && ![self isCEO]) {
                    //最后一条为驳回状态且为租赁者，最后一条贴一条按钮cell
                    ServiceCenterBaseModel *tempM = [[ServiceCenterBaseModel alloc] init];
                    tempM.enumstateid = 167;//修改司机按钮
                    [_dataSource[dataSourceIndex] addObject:tempM];
                }
            }
        }
            break;
        case 5:
        {
            //设备维保
            _dataSource[dataSourceIndex] = modelArr;
//            if (!self.isZuLin) {
                ServiceCenterBaseModel *tempM = [[ServiceCenterBaseModel alloc] init];
                tempM.enumstateid = 160;//新增维保单按钮
                [_dataSource[dataSourceIndex] insertObject:tempM atIndex:0];
//            }
        }
            break;
        case 6:
        {
            //设备维修
            _dataSource[dataSourceIndex] = modelArr;
            if (!self.isZuLin) {
                ServiceCenterBaseModel *tempM = [[ServiceCenterBaseModel alloc] init];
                tempM.enumstateid = 161;//新增维保单按钮
                [_dataSource[dataSourceIndex] insertObject:tempM atIndex:0];
            }
        }
            break;
        case 7:
        {
            //设备加高
            _dataSource[dataSourceIndex] = modelArr;
            if (!self.isZuLin) {
                ServiceCenterBaseModel *tempM = [[ServiceCenterBaseModel alloc] init];
                tempM.enumstateid = 162;//新增维保单按钮
                [_dataSource[dataSourceIndex] insertObject:tempM atIndex:0];
            }
        }
            break;
        case 8:
        {
            //设备停租
            if (modelArr.count > 0) {
                _dataSource[dataSourceIndex] = modelArr;
                if (_dataSource[dataSourceIndex][modelArr.count-1].enumstateid == 30) {
                    //在通过前插一条费用清算
                    ServiceCenterBaseModel *tempM = [[ServiceCenterBaseModel alloc] init];
                    tempM.dismantledevice = _dataSource[dataSourceIndex][modelArr.count-1].dismantledevice;
                    tempM.pricelist = _dataSource[dataSourceIndex][modelArr.count-1].pricelist;
                    tempM.enumstateid = 165;
                    [_dataSource[dataSourceIndex] insertObject:tempM atIndex:(modelArr.count-1)];
                }
            }else{
                if (!self.isZuLin) {
                    ServiceCenterBaseModel *tempM = [[ServiceCenterBaseModel alloc] init];
                    tempM.enumstateid = 163;//新增设备停租按钮
                    [_dataSource[dataSourceIndex] addObject:tempM];
                }
            }
        }
            break;
        case 9:
        {
            //服务评价
            if (modelArr.count > 0) {
                _dataSource[dataSourceIndex] = modelArr;
            }else{
                if (!self.isZuLin) {
                    ServiceCenterBaseModel *tempM = [[ServiceCenterBaseModel alloc] init];
                    tempM.enumstateid = 164;//新增服务评价按钮
                    [_dataSource[dataSourceIndex] addObject:tempM];
                }
            }
        }
            break;
        default:
            _dataSource[dataSourceIndex] = modelArr;
            break;
    }
    
    [self.tableView reloadData];
}

/**
 通过
 @param sender sender
 */
- (void)Agree:(UIButton *)sender{
    switch (sender.tag) {
        case 1:
            [self fetchAgreeOrDismissWithEventtype:QQGT_JCGTD WithYesOrNo:Agree];
            break;
        case 3:
            [self fetchAgreeOrDismissWithEventtype:SBBZ_BZZL WithYesOrNo:Agree];
            break;
        case 5:
            [self fetchAgreeOrDismissWithEventtype:SBAZ_XCJSJD WithYesOrNo:Agree];
            break;
        case 7:
            [self fetchAgreeOrDismissWithEventtype:SBAZ_AZPZ WithYesOrNo:Agree];
            break;
        case 9:
            [self fetchAgreeOrDismissWithEventtype:SBAZ_DSFYSPZ WithYesOrNo:Agree];
            break;
        case 11:
            [self fetchAgreeOrDismissWithEventtype:SBQZ_QZD WithYesOrNo:Agree];
            break;
        case 13:{
            EMINormalTableViewCell *cell = (EMINormalTableViewCell *)[[[[[[sender superview] superview] superview] superview] superview] superview];
            _billid = cell.baseServiceModel.deviceMaintainorder.ID;
            [self fetchAgreeOrDismissWithEventtype:SBWH WithYesOrNo:Agree];
        }
            break;
        case 15:{
            EMINormalTableViewCell *cell = (EMINormalTableViewCell *)[[[[[[sender superview] superview] superview] superview] superview] superview];
            _billid = cell.baseServiceModel.devicerepairorder.ID;
            [self fetchAgreeOrDismissWithEventtype:SBWX WithYesOrNo:Agree];
        }
            break;
        case 17:{
            EMINormalTableViewCell *cell = (EMINormalTableViewCell *)[[[[[[sender superview] superview] superview] superview] superview]superview];
            _billid = cell.baseServiceModel.deivieaddheight.ID;
            [self fetchAgreeOrDismissWithEventtype:SBJG WithYesOrNo:Agree];
        }
            break;
        case 19:{
            EMINormalTableViewCell *cell = (EMINormalTableViewCell *)[[[[[[sender superview] superview] superview] superview] superview]superview];
            _billid = cell.baseServiceModel.dismantledevice.ID;
            [self fetchAgreeOrDismissWithEventtype:SBCC WithYesOrNo:Agree];
        }
            break;
        case 21:
            [self fetchAgreeOrDismissWithEventtype:SJQR WithYesOrNo:Agree];
            break;
        default:
            break;
    }
}

/**
 驳回
 @param sender sender
 */
- (void)Refuse:(UIButton *)sender{
    switch (sender.tag) {
        case 2:
            [self fetchAgreeOrDismissWithEventtype:QQGT_JCGTD WithYesOrNo:Refuse];
            break;
        case 4:
            [self fetchAgreeOrDismissWithEventtype:SBBZ_BZZL WithYesOrNo:Refuse];
            break;
        case 6:
            [self fetchAgreeOrDismissWithEventtype:SBAZ_XCJSJD WithYesOrNo:Refuse];
            break;
        case 8:
            [self fetchAgreeOrDismissWithEventtype:SBAZ_AZPZ WithYesOrNo:Refuse];
            break;
        case 10:
            [self fetchAgreeOrDismissWithEventtype:SBAZ_DSFYSPZ WithYesOrNo:Refuse];
            break;
        case 12:
            [self fetchAgreeOrDismissWithEventtype:SBQZ_QZD WithYesOrNo:Refuse];
            break;
        case 14:{
            EMINormalTableViewCell *cell = (EMINormalTableViewCell *)[[[[[[sender superview] superview] superview] superview] superview] superview];
            _billid = cell.baseServiceModel.deviceMaintainorder.ID;
            [self fetchAgreeOrDismissWithEventtype:SBWH WithYesOrNo:Refuse];
        }
            break;
        case 16:{
            EMINormalTableViewCell *cell = (EMINormalTableViewCell *)[[[[[[sender superview] superview] superview] superview] superview] superview];
            _billid = cell.baseServiceModel.devicerepairorder.ID;
            [self fetchAgreeOrDismissWithEventtype:SBWX WithYesOrNo:Refuse];
        }
            break;
        case 18:{
            EMINormalTableViewCell *cell = (EMINormalTableViewCell *)[[[[[[sender superview] superview] superview] superview] superview]superview];
            _billid = cell.baseServiceModel.deivieaddheight.ID;
            [self fetchAgreeOrDismissWithEventtype:SBJG WithYesOrNo:Refuse];
        }
            break;
        case 20:{
            EMINormalTableViewCell *cell = (EMINormalTableViewCell *)[[[[[[sender superview] superview] superview] superview] superview]superview];
            _billid = cell.baseServiceModel.dismantledevice.ID;
            [self fetchAgreeOrDismissWithEventtype:SBCC WithYesOrNo:Refuse];
        }
            break;
        case 22:
            [self fetchAgreeOrDismissWithEventtype:SJQR WithYesOrNo:Refuse];
            break;
        default:
            break;
    }
}

/**
 已确认时间以及已完成
 @param sender sender
 */
- (void)alreadySure:(UIButton *)sender{
    //0:已确认时间并发起维保190
    //1:我已完成维保140
    //2：已确认时间并发起维修190
    //3:我已完成维修140
    //4:已确认时间并发起加高180
    //5：我已完成加高140
    //6:费用已缴清
    //7 :回复
    //跳往选择维修人员页面
    ChooseMaintainers *VC = [AppUtils VCFromSB:@"Main" vcID:@"ChooseMaintainersVC"];
    VC.dm = _dm;
    VC.projectid = _projectid;
    VC.basedelegate = self;
    switch (sender.tag) {
        case 0:
        {
            EMINormalTableViewCell *cell = (EMINormalTableViewCell *)[[[[sender superview] superview] superview] superview];
            if ([cell isKindOfClass:[EMINormalTableViewCell class]]) {
                _billid = cell.baseServiceModel.deviceMaintainorder.ID;
                VC.thistitle = @"选择维保人员";
                VC.billid = _billid;
                [self.navigationController pushViewController:VC animated:YES];
            }
            break;
        }
        case 1:
        {
            EMINormalTableViewCell *cell = (EMINormalTableViewCell *)[[[[[sender superview] superview] superview] superview] superview];
            _billid = cell.baseServiceModel.deviceMaintainorder.ID;
            [self fetch_MaintainFinishDo];
            break;
        }
        case 2:
        {
            EMINormalTableViewCell *cell = (EMINormalTableViewCell *)[[[[[[sender superview] superview] superview] superview] superview] superview];
            _billid = cell.baseServiceModel.devicerepairorder.ID;
            VC.thistitle = @"选择维修人员";
            VC.billid = _billid;
            [self.navigationController pushViewController:VC animated:YES];
            break;
        }
        case 3:
        {
            EMINormalTableViewCell *cell = (EMINormalTableViewCell *)[[[[[sender superview] superview] superview] superview]superview];
            _billid = cell.baseServiceModel.devicerepairorder.ID;
            [self fetch_RepairFinishWI];
            break;
        };
        case 4:
        {
            EMINormalTableViewCell *cell = (EMINormalTableViewCell *)[[[[[[sender superview] superview] superview] superview] superview]superview];
            _billid = cell.baseServiceModel.deivieaddheight.ID;
            VC.thistitle = @"选择加高人员";
            VC.billid = _billid;
            [self.navigationController pushViewController:VC animated:YES];
            break;
        }
        case 5:
        {
            EMINormalTableViewCell *cell = (EMINormalTableViewCell *)[[[[[sender superview] superview] superview] superview]superview];
            _billid = cell.baseServiceModel.deivieaddheight.ID;
            [self fetch_AddHighFinshWI];
            break;
        }
        case 6:{
            EMINormalTableViewCell *cell = (EMINormalTableViewCell *)[[[[[sender superview] superview] superview] superview]superview];
            _billid = cell.baseServiceModel.dismantledevice.ID;
            [self fetchAgreeOrDismissWithEventtype:SBCC WithYesOrNo:Agree];//费用已交清
        }
            break;
        case 7:
            //回复
            self.replyFatherV.hidden = NO;
            [self.replyTF becomeFirstResponder];
            break;
        default:
            break;
    }
}

//同意驳回
- (void)fetchAgreeOrDismissWithEventtype:(NSString *)eventtype WithYesOrNo:(NSString *)yesorno{
    AgreeorDismissWI *lwi = [[AgreeorDismissWI alloc] init];
    NSArray *arr = @[@(self.baseUser.userid),self.baseUser.type,eventtype,yesorno,@(_projectid),@(_dm.deviceid),@(_billid),@(_dm.projectdeviceid),self.baseUser.usertype];
    NSDictionary *param = [lwi inBox:arr];
    [CKNetTools requestWithRequestType:POST WithURL:lwi.fullUrl WithParamater:param WithProgressBlock:^(NSProgress *process) {
        
    } WithSuccessBlock:^(id returnValue) {
        NSArray *temp = [lwi unBox:returnValue];
        if ([temp[0] integerValue] == 1) {
            [self fetchServiceNewsWithFlowType:_sectionArray[_clickedSectionIndex]];
        }
        
    } WithFailureBlock:^(NSError *error) {
        
    }];
}

/**
 上传报装材料
 */
- (void)fetchUploadNoticeInstallData
{
    [[DQServiceInterface sharedInstance] dq_getUploadNoticeInstall: @(_projectid) deviceid:@(_dm.deviceid) upLoadImgs:_alreadyUploadImgUrls projectID:@(_dm.projectdeviceid) success:^(id result) {
        if (result) {
            [self fetchServiceNewsWithFlowType:[_sectionArray safeObjectAtIndex:_clickedSectionIndex]];
        }
        //清空图片数组，方便进行其他上传
        [_arrDataSources removeAllObjects];
        [_alreadyUploadImgUrls removeAllObjects];
    } failture:^(NSError *error) {
        //清空图片数组，方便进行其他上传
        [_arrDataSources removeAllObjects];
        [_alreadyUploadImgUrls removeAllObjects];
    }];
}

/**
 申请现场技术交底
 */
- (void)fetchTechnicalDisclosure
{
    [[DQServiceInterface sharedInstance] dq_getConfigDisclosure:@(_projectid) deviceid:@(_dm.deviceid) projectdeviceid:@(_dm.projectdeviceid) success:^(id result) {
        if (result) {
            MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"申请现场技术交底成功" actionTitle:@"" duration:3.0];
            [t show];
            [self fetchServiceNewsWithFlowType:_sectionArray[_clickedSectionIndex]];
        }
    } failture:^(NSError *error) {
        
    }];
}

/**
 上传安装凭证
 */
- (void)fetchUploadInstallDocument
{
     [[DQServiceInterface sharedInstance] dq_getUploadDocument:@(_projectid) deviceid:@(_dm.deviceid) imgs:_alreadyUploadImgUrls projectdeviceid:@(_dm.projectdeviceid) success:^(id result) {
         if (result) {
             [self fetchServiceNewsWithFlowType:[_sectionArray safeObjectAtIndex:_clickedSectionIndex]];
         }
         //清空图片数组，方便进行其他上传
         [_arrDataSources removeAllObjects];
         [_alreadyUploadImgUrls removeAllObjects];

     } failture:^(NSError *error) {
         [_arrDataSources removeAllObjects];
         [_alreadyUploadImgUrls removeAllObjects];
     }];
}

/**
 上传第三方验收凭证
 */
- (void)fetchUploadOtherCheckDocumnet
{
    [[DQServiceInterface sharedInstance] dq_getUploadOtherCheckDocumnet: @(_projectid) deviceid:@(_dm.deviceid) imgs:_alreadyUploadImgUrls projectdeviceid:@(_dm.projectdeviceid) success:^(id result) {
        if (result) {
            MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"上传第三方验收凭证成功" actionTitle:@"" duration:3.0];
            [t show];
            [self fetchServiceNewsWithFlowType:[_sectionArray safeObjectAtIndex:_clickedSectionIndex]];
        }
        //清空图片数组，方便进行其他上传
        [_arrDataSources removeAllObjects];
        [_alreadyUploadImgUrls removeAllObjects];
        
    } failture:^(NSError *error) {
        [_arrDataSources removeAllObjects];
        [_alreadyUploadImgUrls removeAllObjects];
    }];
}

/**
 处理上传图片，循环去传
 */
- (void)handleUploadImg{
    for (int i = 0; i < _arrDataSources.count; i++) {
        [self fetchUploadImageWithImage:_arrDataSources[i]];
    }
}

/**
 上传图片

 @param img img
 */
- (void)fetchUploadImageWithImage:(UIImage *)img
{
    [[DQMyCenterInterface sharedInstance] dq_getUploadImageApi:img success:^(id result) {
        if (result) {
            NSDictionary *param = (NSDictionary *)result;
            NSString *url = [param objectForKey:@"imgpath"];
            [_alreadyUploadImgUrls safeAddObject:url];
            //当图片数量一样多之后，请求各自的上传资料接口
            if (_alreadyUploadImgUrls.count == _arrDataSources.count) {
                [self handleUploadData];
            }
        } else {
            MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"图片上传失败" actionTitle:@"" duration:3.0];
            [t show];
        }
    } failture:^(NSError *error) {
    
    }];
}

- (void)handleUploadData{
    [MBProgressHUD hideHUDForView:[AppDelegate getMainView] animated:YES];//解决图片上传完成后菊花圈还不消失的bug
    switch (_whichTakePhoto) {
        case 0:
            //设备报装
            [self fetchUploadNoticeInstallData];
            break;
        case 2:
            //设备安装凭证
            [self fetchUploadInstallDocument];
            break;
        case 3:
            //第三方验收凭证
            [self fetchUploadOtherCheckDocumnet];
            break;
        default:
            break;
    }
}

/**
 我已完成维保
 */
- (void)fetch_MaintainFinishDo{
    MaintainFinishDo *lwi = [[MaintainFinishDo alloc] init];
    NSArray *arr = @[@(self.baseUser.userid),self.baseUser.type,@(_projectid),@(_dm.deviceid),@(_billid),self.baseUser.usertype];
    NSDictionary *param = [lwi inBox:arr];
    [CKNetTools requestWithRequestType:POST WithURL:lwi.fullUrl WithParamater:param WithProgressBlock:^(NSProgress *process) {
        
    } WithSuccessBlock:^(id returnValue) {
        NSArray *temp = [lwi unBox:returnValue];
        if ([temp[0] integerValue] == 1) {
            [self fetchServiceNewsWithFlowType:_sectionArray[_clickedSectionIndex]];
        }
        
    } WithFailureBlock:^(NSError *error) {
        
    }];
}

/**
 我已完成维修
 */
- (void)fetch_RepairFinishWI{
    RepairFinishWI *lwi = [[RepairFinishWI alloc] init];
    NSArray *arr = @[@(self.baseUser.userid),self.baseUser.type,@(_projectid),@(_dm.deviceid),@(_billid),self.baseUser.usertype];
    NSDictionary *param = [lwi inBox:arr];
    [CKNetTools requestWithRequestType:POST WithURL:lwi.fullUrl WithParamater:param WithProgressBlock:^(NSProgress *process) {
        
    } WithSuccessBlock:^(id returnValue) {
        NSArray *temp = [lwi unBox:returnValue];
        if ([temp[0] integerValue] == 1) {
            [self fetchServiceNewsWithFlowType:_sectionArray[_clickedSectionIndex]];
        }
        
    } WithFailureBlock:^(NSError *error) {
        
    }];
}

/**
 我已加高完成
 */
- (void)fetch_AddHighFinshWI
{
    [[DQServiceInterface sharedInstance] dq_getAddHeightFinsh:@(_projectid) deviceid: @(_dm.deviceid) highid: @(_billid) success:^(id result) {
        if (result) {
            MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"操作成功" actionTitle:@"" duration:3.0];
            [t show];
            [self fetchServiceNewsWithFlowType:[_sectionArray safeObjectAtIndex:_clickedSectionIndex]];
        }
    } failture:^(NSError *error) {
        
    }];
}

/**
 发送
 @param sender sender
 */
- (IBAction)sendBtnClicked:(UIButton *)sender {
    self.replyFatherV.hidden = YES;
    [self.replyTF resignFirstResponder];
    if (!_replyTF.text.length) {
        MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"回复内容不能为空" actionTitle:@"" duration:3.0];
        [t show];
        return;
    }
    [self fetchReplyWI];
}

/**
 回复评价
 */
- (void)fetchReplyWI{
    ReplyEvaluateWI *lwi = [[ReplyEvaluateWI alloc] init];
    NSArray *arr = @[@(self.baseUser.userid),self.baseUser.type,@(_projectid),@(_dm.deviceid),_replyTF.text,self.baseUser.usertype];
    NSDictionary *param = [lwi inBox:arr];
    [CKNetTools requestWithRequestType:POST WithURL:lwi.fullUrl WithParamater:param WithProgressBlock:^(NSProgress *process) {
        
    } WithSuccessBlock:^(id returnValue) {
        NSArray *temp = [lwi unBox:returnValue];
        if ([temp[0] integerValue] == 1) {
            [self fetchServiceNewsWithFlowType:_sectionArray[_clickedSectionIndex]];
        }
        
    } WithFailureBlock:^(NSError *error) {
        
    }];
}

//锁机
-(void)fetchLockMachine
{
    [[DQServiceInterface sharedInstance] dq_getConfigLocked:@(_projectid) deviceid:@(_dm.deviceid) success:^(id result) {
         if (result) {
            [self.navigationController popViewControllerAnimated:YES];
            MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"锁机成功" actionTitle:@"" duration:3.0];
            [t show];
        }
    } failture:^(NSError *error) {
    }];
}

#pragma basedelegate
- (void)didPopFromNextVC
{
    [self fetchServiceNewsWithFlowType:_sectionArray[_clickedSectionIndex]];
}

@end
