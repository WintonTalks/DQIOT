//
//  DQServiceBaseModel.h
//  WebThings
//  管理服务流子节点的父类
//  Created by Heidi on 2017/9/26.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#ifndef DQServiceBaseModel_h
#define DQServiceBaseModel_h

#import "DQServiceSubNodeModel.h"

@protocol DQLogicServiceDelegate;

@interface DQLogicServiceBaseModel : NSObject

@property (nonatomic, weak) id<DQLogicServiceDelegate> delegate;
@property (nonatomic, copy) NSString *cellIdentifier;           // cell的Identifier
@property (nonatomic, assign) CGFloat cellHeight;               // cell高度
@property (nonatomic, strong) DQServiceSubNodeModel *cellData;  // 每个cell里面的数据，即每一步业务的数据
@property (nonatomic, assign) DQFlowType nodeType;              // 业务类型
@property (nonatomic, copy) NSString *nodeName;                 // 业务名

@property (nonatomic, assign) BOOL isOpen;                      // 是否展开
@property (nonatomic, assign) DQDirection direction;            // 方向,0:向左 1:向右
@property (nonatomic, assign) BOOL showRefuteBackButton;        // 是否显示驳回和确认按钮
@property (nonatomic, assign) BOOL isLast;                      // 是否是最后一行
@property (nonatomic, assign) BOOL isRemoved;                   // 停租单已通过

// 👇 ------------ 用来处理业务逻辑 ------------
@property (nonatomic, strong) UINavigationController *navCtl;
@property (nonatomic, strong) DeviceModel *device;
@property (nonatomic, assign) NSInteger projectid;
/** 确认／驳回接口使用 */
@property (nonatomic, copy) NSString *billID;
/** 费用是否已结清 */
@property (nonatomic, assign) BOOL isFinished;

/** 表单背景是否为透明 */
@property (nonatomic, assign) BOOL isClearBillColor;

/** 是否可编辑 */
@property (nonatomic, assign) BOOL canEdit;

#pragma mark - UI
/** 自己发的/别人发的边框颜色显示不同 */
- (UIColor *)hexBorderColor;

/** 自己发的/别人发的头文字颜色显示不同 */
- (UIColor *)hexTitleColor;

/** 自己发的/别人发的背景颜色显示不同 */
- (UIColor *)hexBgColor;

/** 展示图片的View的高度 */
- (CGFloat)heightForImageCount:(NSInteger)count;

/** 表单数据 */
- (NSArray *)arrayForBill;

/** 表单高度 */
- (CGFloat)heightForBill;

/** 按钮标题 */
- (NSString *)titleForButton;
/** 按钮icon */
- (NSString *)iconNameForButton;

#pragma mark - Actions
/// ServiceBtnCell中按钮的事件处理
- (void)btnClicked;

/// 确认／驳回 confirm:1.确认 0.驳回
- (void)btnConfirmOrRefuteBack:(BOOL)confirm;

// 刷新业务站数据
- (void)reloadTableData;
// 隐藏加载等待框
- (void)hideHud;
// 弹出提示消息
- (void)showMessage:(NSString *)msg;
// 弹出上传选择器,返回图片链接，自行处理
- (void)showUploadPicker:(DQResultBlock)finishUpload;

@end

@protocol DQLogicServiceDelegate<NSObject>

// 完成某些操作（如API调用）后须刷新数据
- (void)dq_needReloadData;

@end

#endif /* DQServiceBaseModel_h */
