//
//  DQAPIDefine.h
//  WebThings
//
//  Created by Heidi on 2017/9/7.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#ifndef QBAPIDefine_h
#define QBAPIDefine_h

#pragma mark - Constant
#define TIMEOUT_API 20  // 超时时间

#pragma mark -
//#define httpUrl @"http://192.168.2.113:8080/app"//网络请求地址
//#define imgUrl @"http://192.168.2.113:8080"//图片地址
#define httpUrl @"http://39.108.149.194/app"//网络请求地址
#define imgUrl @"http://39.108.149.194"//图片地址
#define APIURL @"http://39.108.149.194/app"//网络请求地址
#define IMAGEURL @"http://39.108.149.194"//图片地址

#define aboutusUrl @"http://39.108.149.194/aboutus.html"//关于我们地址
#define serviceTermsUrl @"http://39.108.149.194/conditions.html"//服务条款地址

#pragma mark - 接口

#pragma mark --👇业务中心--

#define API_ProjectList @"/projectList.do"                          // 获取项目列表
#define API_ObtainNumber @"/obtainnumber.do"                        // 工作平台消息数量
#define API_WarningDevice @"/getWarnMonitor.do"                     // 获取设备警告
#define API_ServiceStation @"/obtainServiceflow.do"                 // 服务站状态
#define API_ServiceFlow    @"/getServiceMessageFlow.do"             // 服务站数据

#define API_AddProject      @"/addproject.do"                       // 新增项目
#define API_ModifyProject   @"/modifyproject.do"                    // 修改项目
#define API_BrandModel       @"/brandmodel.do"                      // 获取设备型号
#define API_GetNeedOrgList   @"/getneedorgList.do"                  // 获取承租方列表
#define API_ModifyWithDerive  @"/addmodifyDrviverRent.do"           // 修改司机

#define API_GetMsg            @"/getMsg.do"                         // 工作台 -> 消息通知列表
#define API_AddDeviceList     @"/addprojectdevice.do"               // 添加设备
#define API_ModifyDevice      @"/modifyprojectdevice.do"            //修改设备
#define API_DeviceList        @"/deviceList.do"                     //设备列表
#define API_DeleteDevice      @"/deleteProjectDevice.do"             //删除设备
#define API_DeviceFirm        @"/deviceconfirm.do"                  //设备确认

#pragma mark - 👇业务站
#define API_AddStartRentOrder      @"/addStartRentOrder.do"         // 新增启租单
#define API_UpdateStartRentOrder   @"/updateStartRentOrder.do"      // 修改启租单
#define API_StopRentOrder          @"/addStopRentOrder.do" // 停租单
#define API_AddDeviceRepairOrder   @"/addDeviceRepairOrder.do"      // 新增设备维修单
#define API_AddDeviceMaintainOrder @"/addDeviceMaintainOrder.do"    // 新增设备维保单
#define API_AddDevicehighOrder     @"/addDeviceHigh.do"             // 新增设备加高单
#define API_FaultDataList          @"/faultdata.do"                 // 获取故障列表
#define API_AddRepairFinish        @"/repairFinish.do"              // 新增维修完成单
#define API_AddHeightFinish        @"/addHighFinsh.do"              // 新增加高完成单
#define API_AddMaintainFinish      @"/maintainFinish.do"            // 新增维保完成单
#define API_getRepairUserList      @"/repairUserList.do"            // 获取维修人员列表

#define API_BusinessContactList    @"/obtainBusinessContactsInformation.do"     // 获取商务往来消息
#define API_BusinessContactAdd     @"/addBusinessorder.do"                      // 新增商务往来
#define API_BusiContConfirm        @"/businessCorrespondenceConfirmation.do"       // 商务往来确认
#define API_BusiContAdviceAdd      @"/addConfirmationOfRectification.do"           // 新增整改意见
#define API_BusiContAdviceConfirm  @"/confirmationOfRectificationOpinions.do"    // 整改意见确认
#define API_BusiContFinishAdd      @"/addCompletionNote.do"                        // 新增整改完成单
#define API_BusiContFinishConfirm  @"/rectificationComplete.do"                  // 整改完成单确认/驳回

#define API_GetMsg                 @"/getMsg.do"                    // 工作台 -> 消息通知列表

#define API_AddDeviceList     @"/addprojectdevice.do" // 添加设备
#define API_ModifyDevice      @"/modifyprojectdevice.do" //修改设备  
#define API_DeviceList        @"/deviceList.do" //设备列表
#define API_DeleteDevice      @"/deleteProjectDevice.do" //删除设备

#define API_AgreeRefuse       @"/agreeordismiss.do"     // 同意驳回接口
#define API_DeviceFirm        @"/deviceconfirm.do" //设备确认

#define API_SendMaintainMsg  @"/sendMantainMsg.do"                  // 租赁方发起维保提醒
#define API_StartRepair      @"/confirmStartRepair.do"              // 确认时间发起维修
#define API_DeviceAddHeight     @"/confirmAddHigh.do"               // 确认时间发起加高
#define API_StartMaintain    @"/confirmStartMaintain.do"            // 确认时间发起维保
#define API_Disclosure       @"/technicalDisclosure.do"             // 申请现场技术交底
#define API_UploadInstallDocument   @"/uploadInstallDocument.do"    //上传安装凭证
#define API_UploadOtherDocumnet     @"/uploadOtherCheckDocumnet.do" //上传第三方验收凭证
#define API_AddHighFinsh        @"/addHighFinsh.do"  //加高完成
#define API_UploadNoticeInstallData  @"/uploadNoticeInstallData.do" //上传报装材料
#define API_Locked              @"/locked.do"//设备锁机

#pragma mark  --👇项目管理--
#define API_GetUsetList           @"/getUsetList.do"   //人员列表
#define API_AddUser              @"/addUserList.do"  //新增人员
#define API_DeleteUser           @"/deleteUserById.do" //删除人员
#define API_ModifyUser           @"/updateUserById.do"  //修改人员
#define API_GetWorkType          @"/getWorkerTypeList.do" //工种类型（新增，原先貌似没有5）
#define API_PersonPermissions         @"/personnelPermissions.do"  //人员权限设置
#define API_PersonQualification       @"/personnelQualification.do" //人员资质上传
#define API_GetQualificationList      @"/getPersonnelQualificationList.do" //资质记录
#define API_DeleteQualification       @"/deletePersonnelQualification.do" //人员资质删除
#define API_AddTranrecord             @"/addTranrecord.do" //新增人员培训记录
#define API_GetTrainType              @"/getTrainTypeList.do" //人员培训类型列表
#define API_GetUserTranrecord         @"/getUserTranrecord.do"  //人员培训记录
#define API_DeleteTranrecord          @"/deleteTranrecordById.do"//人员培训记录删除
#define API_GetCheckUserList          @"/getCheckUserList.do"//人员考勤查询
#define API_GetAttendanceRecord       @"/getAttendanceRecord.do"//考勤记录
#define API_AddEvaluate               @"/addEvaluate.do" //评价
#define API_GetEvaluate               @"/getEvaluate.do" //人员评价列表


#pragma mark  --👇数据中心--
#define API_DataCenter @"/dataCenter.do"                            // 数据中心首页／业务中心概览
#define API_GetDaily     @"/getDailyList.do"                        // 获取日报接口
#define API_IsReadDaily     @"/addIsread.do"                        // 标记日报已读
#define API_BrandList   @"/brandmodel.do"                           // 获取品牌型号

#define API_DailyCheckType   @"/getDailychecktype.do"               //司机获取日报项

#pragma mark  --👇用户中心--
#define API_Login        @"/login.do"                                // 用户登录
#define API_AppVerify    @"/appverify.do"                            //获取验证码
#define API_UpdatePassd    @"/appupdatepassd.do"                     //忘记密码
/**
 修改用户资料API
 */
#define API_ModifyUserFile   @"/modifydata.do"

/**
 修改用户头像
 */
#define API_UpdateUserHeadImage  @"/uploadImg.do"
#define API_UploadImages  @"/uploadImgs.do"

/**
 我的同事
 */
#define API_MyColleagueList   @"/myColleagueList.do"


/**
 修改密码
 */
#define API_FixPassWord    @"/modifyPassword.do"

/**
 意见反馈
 */
#define API_FeedBack     @"/feedback.do"





#endif /* QBAPIDefine_h */
