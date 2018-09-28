//
//  SDTextField.h
//  SDTextFieldDemo
//
//  Created by songjc on 16/10/11.
//  Copyright © 2016年 Don9. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMICardView.h"

@protocol SDTextFieldDelegate <NSObject>

@optional
- (void)didSelectText;

@end

@interface SDTextField : UIView

/**
 @author Don9
 
 唯一注意的是frame中的高度是属性textfield的高度,诱导输入列表的的高度将会是textfield的三倍,需要调整请修改源码!建议高度设置为32-42之间比较合适!
 
 @param frame textfield尺寸大小
 
 @return 创建SDTextField
 */
+(instancetype)initWithFrame:(CGRect)frame;
//代理
@property (nonatomic,weak) id<SDTextFieldDelegate> textDelegate;
//输入框
@property (nonatomic,strong) MDTextField *textfield;

//诱导输入查询的数据源(存储的为字符串类型)
@property(nonatomic,strong)NSMutableArray <CK_ID_NameModel *> *dataArray;

//诱导输入列表的背景颜色(默认的是浅灰色(RGB值约为0.94,0.94,0.94,1.0))
@property(nonatomic,strong)UIColor *listBackgroundColor;

//列表每一行的高度,默认与textfield高度相同.
@property(nonatomic,assign)CGFloat  cellHeight;

//列表与输入框的高度比例,默认为3
@property(nonatomic,assign)int  heightMultiple;

@property(nonatomic,assign)NSInteger cid;

@property(nonatomic,strong)NSArray <UserModel *> *pmArr;
@end
