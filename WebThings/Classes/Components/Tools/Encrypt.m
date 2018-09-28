//
//  Encrypt.m
//  EMINest
//
//  Created by WongSuechang on 15/3/16.
//  Copyright (c) 2015年 emi365. All rights reserved.
//

#import "Encrypt.h"

@interface Encrypt()

+ (NSString *)md5:(NSString *)oriString;

@end

@implementation Encrypt

+ (NSString *)md5:(NSString *)oriString
{
    const char *cStr = [oriString UTF8String];
    unsigned char result[32];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result );
    return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",result[0], result[1], result[2], result[3],result[4], result[5], result[6],result[7],result[8], result[9], result[10], result[11],result[12], result[13], result[14], result[15]];
}

+ (NSString *)hexStringFromString:(NSString *)passWord
{
    NSString *tempString = [NSString stringWithFormat:@"%@",[self md5:passWord]];
    
    //设置普通的16进制
    const NSString *Str16Class = [NSString stringWithFormat:@"0123456789ABCDEF"];
    //设置自己的16进制
    const NSString *StrMy16Class = [NSString stringWithFormat:@"987654321ABCOXYZ"];
    //分别转化位char类型
    const char * My16Class = [StrMy16Class UTF8String];
    const char * A16Class = [Str16Class UTF8String];
    //设置返回值
    NSString *encryptedString = [[NSString alloc]init];
    encryptedString = @"";
    const char * APassword =[tempString UTF8String];
    //进行循环查找，替换成自己的16进制的数
    for (int i =0; i<[tempString length]; i++) {
        for (int j=0; j<16; j++) {
            if (APassword[i]==A16Class[j]) {
                //连加
                encryptedString = [NSString stringWithFormat:@"%@%c",encryptedString,My16Class[j]];
                continue;
            }
        }
        
    }
    
    return encryptedString;
}


+ (NSString *)md5EncryptWithString:(NSString *)inputStr {
    //1.首先将字符串转换成UTF-8编码, 因为MD5加密是基于C语言的,所以要先把字符串转化成C语言的字符串
    const char *fooData = [inputStr UTF8String];
    
    //2.然后创建一个字符串数组,接收MD5的值
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    //3.计算MD5的值, 这是官方封装好的加密方法:把我们输入的字符串转换成16进制的32位数,然后存储到result中
    CC_MD5(fooData, (CC_LONG)strlen(fooData), result);
    /**
     第一个参数:要加密的字符串
     第二个参数: 获取要加密字符串的长度
     第三个参数: 接收结果的数组
     */
    
    //4.创建一个字符串保存加密结果
    NSMutableString *saveResult = [NSMutableString string];
    
    //5.从result 数组中获取加密结果并放到 saveResult中
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [saveResult appendFormat:@"%02X", result[i]];
    }
    /*
     x表示十六进制，%02X  意思是不足两位将用0补齐，如果多余两位则不影响
     NSLog("%02X", 0x888);  //888
     NSLog("%02X", 0x4); //04
     */
    return saveResult;
}
@end
