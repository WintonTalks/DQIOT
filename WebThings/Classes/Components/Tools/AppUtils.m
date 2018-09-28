//
//  AppUtils.m
//  SHDoctor
//
//  Created by Mac mini on 15/10/21.
//  Copyright © 2015年 ECM. All rights reserved.
//

#import "AppUtils.h"

@implementation AppUtils

+ (void)saveUser:(UserModel *)user{
    NSDictionary *dic = user.mj_keyValues;
    
    [self addWithKey:KUserLoginKey andValue:dic];
}

+ (void)removeConfigUser
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault removeObjectForKey:KUserLoginKey];
    [userDefault synchronize];
}

+ (UserModel *)readUser
{
    NSDictionary *dic = [self readValueWithKey:KUserLoginKey];
    UserModel *mo = [UserModel mj_objectWithKeyValues:dic];
    return mo;
}

+ (void)addWithKey:(NSString *)key andValue:(id)value{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:value forKey:key];
    [userDefault synchronize];
}

+ (id)readValueWithKey:(NSString *)key{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    id value = [userDefault objectForKey:key];
    return value;
}


+ (AppDelegate *)getAppDelegate
{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

+ (UIWindow *)getAppWindow
{
    return [AppUtils getAppDelegate].window;
}


+ (CGSize)textSizeFromTextString:(NSString *)text
                           width:(CGFloat)textWidth
                          height:(CGFloat)height
                            font:(UIFont *)font
{
    if (![text isKindOfClass: [NSString class]]) {
        return CGSizeZero;
    }
    if (text.length == 0) {
        return CGSizeZero;
    }
    
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.lineBreakMode = NSLineBreakByWordWrapping;
    style.alignment = NSTextAlignmentLeft;
    
    NSAttributedString *string = [[NSAttributedString alloc]initWithString:text attributes:@{NSFontAttributeName:font, NSParagraphStyleAttributeName:style}];

    CGSize titleSize =  [string boundingRectWithSize:CGSizeMake(textWidth, height) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    
    NSArray *spaceArray = [text componentsSeparatedByString: @"\n"];
    if (spaceArray.count > 1) {
        titleSize.height += spaceArray.count * 0.1;
    }
    return titleSize;
}

+ (CGFloat)textWidthSystemFontString:(NSString *)text height:(CGFloat)textHeight font:(UIFont *)font
{
    NSDictionary *dict = @{NSFontAttributeName:font};
    CGRect rect = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, textHeight) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    return rect.size.width;
}

+ (CGFloat)textHeightSystemFontString:(NSString *)text height:(CGFloat)textHeight font:(UIFont *)font
{
    NSDictionary *dict = @{NSFontAttributeName:font};
    CGRect rect = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, textHeight) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    return rect.size.height;
}


/*!
 * 根据字符串范围设置字符串效果
 */
+ (NSMutableAttributedString *)mString:(NSString *)mString addString:(NSString *)addString font:(UIFont *)font changeFont:(UIFont *)changeFont color:(UIColor *)color changeColor:(UIColor  *)changeColor isAddLine:(BOOL)isAddLine lineColor:(UIColor *)lineColor
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:mString attributes:@{NSForegroundColorAttributeName:color,NSFontAttributeName:font}];
    [attributedString setAttributes:@{NSForegroundColorAttributeName:changeColor,NSFontAttributeName:changeFont} range:[mString rangeOfString:addString]];
    if (isAddLine) {
        [attributedString addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlineStyleSingle) range:[mString rangeOfString:addString]];
        [attributedString addAttribute:NSStrikethroughColorAttributeName value:lineColor range:[mString rangeOfString:addString]];
    }
    return  attributedString;
}

#pragma mark -获取本地app版本号
+ (NSString*)getProjectVersion {
    
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}

//获取iOS版本号
+ (double)getCurrentIOS {
    return [[[UIDevice currentDevice] systemVersion] doubleValue];
}

static NSDateFormatter *dateFormatter;
+ (NSString *)stringFromDate:(NSDate *)date formatter:(NSString *)formatter {
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
    }
    
    [dateFormatter setDateFormat:formatter];
    return [dateFormatter stringFromDate:date];
}

+ (NSDate *)dateFromString:(NSString *)dateString formatter:(NSString *)formatter {
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
    }
    [dateFormatter setDateFormat:formatter];
    return [dateFormatter dateFromString:dateString];
}

+ (NSString *)stringFromDateString:(NSString*)dateString fromFormatter:(NSString*)fromFormatter toFormatter:(NSString*)toFormatter {
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
    }
    
    if (dateString.length == 0) {
        return nil;
    }
    
    [dateFormatter setDateFormat: fromFormatter];
    NSDate* date = [dateFormatter dateFromString: dateString];
    [dateFormatter setDateFormat: toFormatter];
    return [dateFormatter stringFromDate: date];
}

+ (NSInteger)ageFromBirthDay:(NSString*)birthDay {
    
    if (birthDay == nil) {
        return 1;
    }
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
    }
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    NSDate* date = [dateFormatter dateFromString: birthDay];
    
    if (date == nil) {
        [dateFormatter setDateFormat: @"yyyyMMdd"];
        date = [dateFormatter dateFromString: birthDay];
    }
    
    NSTimeInterval timeInterval = [date timeIntervalSinceNow];
    
    NSInteger age = timeInterval / (3600 * 24 * 365);
    
    return labs(age) + 1;
}


+ (BOOL)isAllNum:(NSString *)string{
    unichar c;
    for (int i=0; i<string.length; i++) {
        c=[string characterAtIndex:i];
        if (!isdigit(c)) {
            return NO;
        }
    }
    return YES;
}

+ (BOOL)checkPhoneNumber:(NSString *)mobileNum
{
    if (mobileNum.length != 11 || ![self isAllNum:mobileNum])
    {
        return NO;
    }
    return YES;
    
//    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[0678])\\d{8}$";
//    NSString *CM = @"(^1(3[4-9]|4[7]|5[0-27-9]|7[8]|8[2-478])\\d{8}$)|(^1705\\d{7}$)";
//    NSString *CU = @"(^1(3[0-2]|4[5]|5[56]|7[6]|8[56])\\d{8}$)|(^1709\\d{7}$)";
//    NSString *CT = @"(^1(33|53|77|8[019])\\d{8}$)|(^1700\\d{7}$)";
//    
//    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
//    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
//    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
//    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
//    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
//        || ([regextestcm evaluateWithObject:mobileNum] == YES)
//        || ([regextestct evaluateWithObject:mobileNum] == YES)
//        || ([regextestcu evaluateWithObject:mobileNum] == YES))
//    {
//        return YES;
//    }
//    else
//    {
//        return NO;
//    }
}


/**
 身份证校验

 @param userID ID
 @return  ""
 */
+ (BOOL)checkUserID:(NSString *)userID
{
    //长度不为18的都排除掉
    if (userID.length!=18) {
        return NO;
    }
    //校验格式
    NSString *regex2 = @"^(^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$)|(^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}[Xx])$)$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    BOOL flag = [identityCardPredicate evaluateWithObject:userID];
    
    if (!flag) {
        return flag;    //格式错误
    }else {
        //格式正确在判断是否合法
        
        //将前17位加权因子保存在数组里
        NSArray * idCardWiArray = @[@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2"];
        
        //这是除以11后，可能产生的11位余数、验证码，也保存成数组
        NSArray * idCardYArray = @[@"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];
        
        //用来保存前17位各自乖以加权因子后的总和
        NSInteger idCardWiSum = 0;
        for(int i = 0;i < 17;i++)
        {
            NSInteger subStrIndex = [[userID substringWithRange:NSMakeRange(i, 1)] integerValue];
            NSInteger idCardWiIndex = [[idCardWiArray objectAtIndex:i] integerValue];
            
            idCardWiSum+= subStrIndex * idCardWiIndex;
            
        }
        
        //计算出校验码所在数组的位置
        NSInteger idCardMod=idCardWiSum%11;
        
        //得到最后一位身份证号码
        NSString * idCardLast= [userID substringWithRange:NSMakeRange(17, 1)];
        
        //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
        if(idCardMod==2)
        {
            if([idCardLast isEqualToString:@"X"]||[idCardLast isEqualToString:@"x"])
            {
                return YES;
            }else
            {
                return NO;
            }
        }else{
            //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
            if([idCardLast isEqualToString: [idCardYArray objectAtIndex:idCardMod]])
            {
                return YES;
            }
            else
            {
                return NO;
            }
        }
    }
}

/**
 *  拨打电话
 *
 *
 *
 */
+ (void)makeStarMobilePhoneClicked:(NSString *)mobile
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",mobile]];
    [[UIApplication sharedApplication] openURL:url];
}

//邮箱

+ (BOOL)validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}


/**
 设备、司机页面时间比对
 
 */
+ (BOOL)verifyTime:(NSString *)oneTime
         curreTime:(NSString *)curreTime
     isEqualToTime:(BOOL)EqualTo
{
    if (oneTime && curreTime) {
        if (EqualTo) {
            int count = [NSDate compareOneDay:curreTime withAnotherDay:oneTime format:@"HH:mm"];
            if (count != 1) {
//                self.timeTF1.text = @"";
//                _maxTimeString = nil;
                return false;
            }
        }
    }
    return true;
}

#pragma mark -业务中心计算Money
+ (NSString *)formatMoney:(int)money {
    if (money < 100000) {
        return [NSString stringWithFormat:@"%d",money];
    } else if(money>=100000&&money<100000000){
        int preFix = money/10000;
        int sufFix = money%10000/1000;
        if (sufFix!=0&&preFix<1000) {
            if (sufFix<1000&&sufFix>100) {
                return [NSString stringWithFormat:@"%d万%d千",preFix,sufFix];
            }else{
                return [NSString stringWithFormat:@"%d万%d",preFix,sufFix];
            }
        }else{
            return [NSString stringWithFormat:@"%d万",preFix];
        }
    } else {
        int preFix = money/100000000;
        int sufFix = money%100000000/10000;
        if (sufFix!=0) {
            if (sufFix<10000&&sufFix>0) {
                return [NSString stringWithFormat:@"%d亿%d万",preFix,sufFix];
            }else{
                return [NSString stringWithFormat:@"%d亿%d",preFix,sufFix];
            }
        } else {
            return [NSString stringWithFormat:@"%d亿",preFix];
        }
    }
    return @"";
    
}

+ (id)VCFromSB:(NSString *)sbName vcID:(NSString *)vcID{
    return [[UIStoryboard storyboardWithName:sbName bundle:nil] instantiateViewControllerWithIdentifier:vcID];
}

+ (DQFlowType)nodeIndexWithTypeName:(NSString *)typeName {
    
    NSArray *titles = @[@"沟通", @"报装", @"安装", @"租", @"维保", @"维修", @"加高", @"拆除", @"评价", @"商务"];
    NSInteger index = 0;
    for (int i = 0; i < [titles count]; i ++) {
        if ([typeName containsString:titles[i]]) {
            index = i;
            break;
        }
    }
    
    return index;
}


@end
