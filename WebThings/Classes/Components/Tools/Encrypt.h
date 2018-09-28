//
//  Encrypt.h
//  EMINest
//
//  Created by WongSuechang on 15/3/16.
//  Copyright (c) 2015年 emi365. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

@class Encrypt;
@interface Encrypt : NSObject

//公司以前自定义的MD5
+ (NSString *)hexStringFromString:(NSString *)passWord;

//原生MD5
+ (NSString *)md5EncryptWithString:(NSString *)inputStr;
@end
