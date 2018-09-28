//
//  AppUtils.h
//  SHDoctor
//
//  Created by Mac mini on 15/10/21.
//  Copyright © 2015年 ECM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "UserModel.h"
#import "DQEnum.h"

@interface AppUtils : NSObject

/**
 用户配置信息
 */
+ (void)saveUser:(UserModel *)user;
+ (void)removeConfigUser;
+ (UserModel *)readUser;


+ (AppDelegate *)getAppDelegate;
+ (UIWindow *)getAppWindow;

+ (CGSize)textSizeFromTextString:(NSString *)text
                           width:(CGFloat)textWidth
                          height:(CGFloat)height
                            font:(UIFont *)font;

/**
 根据特性的font来计算宽度
 */
+ (CGFloat)textWidthSystemFontString:(NSString *)text height:(CGFloat)textHeight font:(UIFont *)font;

+ (CGFloat)textHeightSystemFontString:(NSString *)text height:(CGFloat)textHeight font:(UIFont *)font;


/*!
 * 根据字符串范围设置字符串效果
 */
+ (NSMutableAttributedString *)mString:(NSString *)mString addString:(NSString *)addString font:(UIFont *)font changeFont:(UIFont *)changeFont color:(UIColor *)color changeColor:(UIColor  *)changeColor isAddLine:(BOOL)isAddLine lineColor:(UIColor *)lineColor;

/**
 *  根据指定格式将NSDate转换为NSString
 *
 *  @param date      时间 NSDate
 *  @param formatter 时间格式
 *
 *  @return 时间String
 */
+ (NSString *)stringFromDate:(NSDate *)date formatter:(NSString *)formatter;


/**
 *  根据指定格式将NSString转换为NSDate
 *
 *  @param dateString 时间String
 *  @param formatter  时间格式
 *
 *  @return 时间 NSDate
 */
+ (NSDate *)dateFromString:(NSString *)dateString formatter:(NSString *)formatter;

/**
 *  把时间转化成对应的类型
 *
 *  @param dateString    时间String
 *  @param fromFormatter 时间格式
 *  @param toFormatter   转换为的时间格式
 *
 *  @return 时间String
 */
+ (NSString *)stringFromDateString:(NSString*)dateString fromFormatter:(NSString*)fromFormatter toFormatter:(NSString*)toFormatter;

/**
 *  根据生日计算年龄
 *
 *  @param birthDay 生日
 *
 *  @return 年龄
 */
+ (NSInteger)ageFromBirthDay:(NSString*)birthDay;

/**
 *  获取项目版本
 *
 *  @return 版本号
 */
+ (NSString*)getProjectVersion;


/**
 *  验证手机号码
 *
 *  @param mobileNum 11位的手机号码
 */
+ (BOOL)checkPhoneNumber:(NSString *)mobileNum;

/**
 *  验证邮箱
 *
 *
 *  @return bool
 */
+ (BOOL)validateEmail:(NSString *)email;

/**
 *  是否为纯数字
 *
 *
 *  @return bool
 */
+ (BOOL)isAllNum:(NSString *)string;

/**
 身份证校验
 
 @param userID ID
 @return  ""
 */
+(BOOL)checkUserID:(NSString *)userID;

/**
 *  拨打电话
 */
+ (void)makeStarMobilePhoneClicked:(NSString *)mobile;


/**
 设备、司机页面时间比对
 */
+ (BOOL)verifyTime:(NSString *)oneTime
         curreTime:(NSString *)curreTime
     isEqualToTime:(BOOL)EqualTo;

#pragma mark -业务中心计算Money
//  业务中心用的，将数字金额转为最大五位的字符串
+ (NSString *)formatMoney:(int) money;

/**
 获取storyboard中的视图
 
 @param sbName 故事板名称
 @param vcID vcidentifier
 @return vc
 */
+ (id)VCFromSB:(NSString *)sbName vcID:(NSString *)vcID;

+ (DQFlowType)nodeIndexWithTypeName:(NSString *)name;

@end
