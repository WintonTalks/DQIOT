//
//  NSString+Category.h
//  WebThings
//
//  Created by Eugene on 2017/9/9.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Category)

/** 一段文字设置多种颜色
 * @param color 需要设置的颜色
 * @param font 字体
 * @param range 需要设置的颜色字符串的范围
 */
- (NSAttributedString *)textDesplaydiffentColor:(UIColor*)color font:(UIFont*)font range:(NSRange)range;

/**
 *  根据字符串内容的多少  根据 <固定宽度> 计算出 <实际的行高>
 *
 *  @param width     设定的显示宽度
 *
 *  @return 高度
 */
- (CGFloat)textHeightFromTextWidth:(CGFloat)width font:(UIFont *)font;

/**
 *  根据字符串内容的多少  根据 <固定高度> 计算出 <实际的行宽>
 *
 *  @param height     设定的显示高度
 *
 *  @return 宽度
 */
- (CGFloat)textWidthFromTextHeight:(CGFloat)height font:(UIFont *)font;

/**
 由当前时间日期字符串生成指定格式的日期字符串
 */
- (NSString *)dq_newTimeStringWithFormat:(NSString *)formatter;


/**
 判断一个字符串是否包含另一个字符串

 @param string string
 @return bool
 */
- (BOOL)dq_rangeOfStringWithLocation:(NSString *)string;

/**
 判断null、nil
 */
+ (BOOL)isEmpty:(NSString*)text;

/**
 * 指定删掉字符串的最后一个字符
 */
- (NSString *)removeLastCharacter:(NSString *)character;

/**
 * 去除前后空格换行
 */
- (NSString *)dq_filterBlank;

/** 过滤表情
 */
- (NSString *)dq_filterEmoji;

@end
