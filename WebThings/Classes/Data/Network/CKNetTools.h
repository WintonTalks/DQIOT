//
//  CKNetTools.h
//  AnotherAudit
//
//  Created by machinsight on 17/2/17.
//  Copyright © 2017年 machinsight. All rights reserved.
//  网络请求类，基于AFNetWorking3.10

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "ImageTools.h"

typedef void (^NETProcessBlock) (NSProgress *process);
typedef void (^NETSuccessBlock) (id returnValue);
typedef void (^NETFailureBlock) (NSError *error);

typedef NS_ENUM(NSInteger,RequestType){
    GET = 0,
    POST = 1,
    PUT = 2,
    DELETE = 3
    
};

@interface CKNetTools : NSObject

+ (instancetype)sharedCKNetTools;

//网络请求，包括get，post，put，delete
+ (void)requestWithRequestType:(RequestType)type
                WithURL:(NSString *)url
                 WithParamater:(NSDictionary *)dic
                    WithProgressBlock:(NETProcessBlock)progressBlock
                        WithSuccessBlock:(NETSuccessBlock)successBlock
                            WithFailureBlock:(NETFailureBlock)failureBlock;
//上传图片
- (void)uploadWithImage:(UIImage *)image
                       WithURL:(NSString *)url
                 WithParamater:(NSDictionary *)dic
             WithProgressBlock:(NETProcessBlock)progressBlock
              WithSuccessBlock:(NETSuccessBlock)successBlock
              WithFailureBlock:(NETFailureBlock)failureBlock;

+ (AFHTTPSessionManager *)getManegerWithType:(int)type;//单例

@end
