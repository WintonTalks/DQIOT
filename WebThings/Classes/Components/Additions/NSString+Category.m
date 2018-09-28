//
//  NSString+Category.m
//  WebThings
//
//  Created by Eugene on 2017/9/9.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "NSString+Category.h"

@implementation NSString (Category)

//一段文字设置多种颜色
- (NSAttributedString *)textDesplaydiffentColor:(UIColor*)color font:(UIFont*)font range:(NSRange)range {
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self];
    //设置字号
    [str addAttribute:NSFontAttributeName value:font range:range];
    //设置文字颜色
    [str addAttribute:NSForegroundColorAttributeName value:color range:range];
    
    return str;
}

// 动态 计算行高
// 根据字符串的实际内容的多少 在固定的宽度和字体的大小，动态的计算出实际的 -> 高度
- (CGFloat)textHeightFromTextWidth:(CGFloat)width font:(UIFont *)font {
    
    if (![self isKindOfClass: [NSString class]]) { return 0; }
    if (self.length == 0) { return 0; }
    
    UIFont *textFont = font;
    CGSize titleSize = [self boundingRectWithSize: CGSizeMake(width, MAXFLOAT) options: NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin attributes: @{NSFontAttributeName: textFont} context:nil].size;
    
    NSArray *spaceArray = [self componentsSeparatedByString: @"\n"];
    if (spaceArray.count > 1) {
        titleSize.height += spaceArray.count * 0.1;
    }
    return roundf(titleSize.height);
}
// 动态 计算行高
// 根据字符串的实际内容的多少 在固定的宽度和字体的大小，动态的计算出实际的 -> 高度
//- (CGFloat)textHeightFromTextString:(NSString *)text textWidth:(CGFloat)width fontSize:(CGFloat)size {
//
//    if (![text isKindOfClass: [NSString class]]) { return 0; }
//    if (text.length == 0) { return 0; }
//
//    UIFont *textFont = [UIFont systemFontOfSize: size];
//    CGSize titleSize = [text boundingRectWithSize: CGSizeMake(width, MAXFLOAT) options: NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin attributes: @{NSFontAttributeName: textFont} context:nil].size;
//
//    NSArray *spaceArray = [text componentsSeparatedByString: @"\n"];
//    if (spaceArray.count > 1) {
//        titleSize.height += spaceArray.count * 0.1;
//    }
//    return roundf(titleSize.height);
//}

// 动态 计算文本宽度
// 根据字符串的实际内容的多少 在固定的宽度和字体的大小，动态的计算出实际的 -> 宽度
- (CGFloat)textWidthFromTextHeight:(CGFloat)height font:(UIFont *)font {
    
    NSDictionary *dict = @{NSFontAttributeName:font};
    CGRect rect = [self boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    return rect.size.width;
}

//// 动态 计算文本宽度
//// 根据字符串的实际内容的多少 在固定的宽度和字体的大小，动态的计算出实际的 -> 宽度
//- (CGFloat)textWidthFromTextString:(NSString *)text textHeight:(CGFloat)height fontSize:(CGFloat)size {
//
//    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:size]};
//    CGRect rect = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
//    return rect.size.width;
//}

/**
 由当前时间日期字符串生成指定格式的日期字符串
 */
- (NSString *)dq_newTimeStringWithFormat:(NSString *)formatter {
    NSString *format = @"";
    if ([self containsString:@"/"]) {
        format = @"yyyy/MM/dd hh:mm:ss";
    } else if ([self containsString:@"-"]) {
        format = @"yyyy-MM-dd hh:mm:ss";
    }
    if (format.length > 0) {
        NSDate *date = [NSDate stringForDate:self format:format];
        NSString *str = [NSDate dateForString:date format:formatter];
        return str.length > 0 ? str : self;
    }
    
    return self;
}

+ (BOOL)isEmpty:(NSString*)text
{
    if ([text isEqual:[NSNull null]]) {
        return YES;
    }
    else if ([text isKindOfClass:[NSNull class]])
    {
        return YES;
    }
    else if (text == nil){
        return YES;
    }
    return NO;
}


/** 指定删掉字符串的最后一个字符 */
- (NSString *)removeLastCharacter:(NSString *)character {
    NSString* cutted;
    if([self length] > 0){
        if ([self hasSuffix:character]) {
            cutted = [self substringToIndex:([self length]-1)];
        } else {
            cutted = self;
        }
    }else{
        cutted = self;
    }
    return cutted;
}

/**
 * 去除前后空格换行
 */
- (NSString *)dq_filterBlank {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

/**
 * 过滤表情
 */
- (NSString *)dq_filterEmoji
{
    NSUInteger len = [[self dq_filterBlank] lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    const char *utf8 = [self UTF8String];
    
    char *newUTF8 =malloc(sizeof(char)*len);
    
    int j = 0;
    for (int i = 0; i < len; i++) {
        unsigned int c = utf8[i];
        BOOL isControlChar =NO;
        if (c == 4294967280) {  // 0xF0FFFFFF
            i = i+3;
            isControlChar = YES;
        }
        if (!isControlChar) {
            newUTF8[j] = utf8[i];
            j++;
        }
    }
    newUTF8[j] = '\0';
    
    NSString *encrypted = [[NSString alloc]initWithCString:(const char*)newUTF8 encoding:NSUTF8StringEncoding];
    return encrypted;
}


/**
 判断一个字符串是否包含另一个字符串
 
 @param string string
 @return bool
 */
- (BOOL)dq_rangeOfStringWithLocation:(NSString *)string
{
    if([self rangeOfString:string].location !=NSNotFound) {
        return true;
    }
    return false;
}

@end
