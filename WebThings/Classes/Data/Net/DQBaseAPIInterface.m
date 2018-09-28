//
//  DQBaseAPIInterface.m
//  WebThings
//  基础网络请求类
//  Created by Heidi on 2017/9/7.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIImage+Category.h"
#import "DQBaseAPIInterface.h"
#import "ToastUtils.h"
#import <AFNetworking/AFNetworking.h>
#import "DQResultModel.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "ImageTools.h"

@interface DQBaseAPIInterface()

@property (nonatomic,strong) AFHTTPSessionManager  *manager;
@property (nonatomic,strong) AFNetworkReachabilityManager *reachManager;

@end

@implementation DQBaseAPIInterface

#pragma mark - Init
+ (instancetype)sharedInstance {
    static DQBaseAPIInterface *singleton = nil;
    static dispatch_once_t pred = 0;
    dispatch_once(&pred, ^{
        singleton = [[self alloc] init];
    });
    return singleton;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.manager = [AFHTTPSessionManager manager];
        self.reachManager = [AFNetworkReachabilityManager sharedManager];
    }
    return self;
}

#pragma mark - Network Status
// 检查网络，show：是否弹出网络未连接提示
- (void)dq_checkNetwork
{
    // 如果要检测网络状态的变化,必须用检测管理器的单例的startMonitoring
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    // 检测网络连接的单例,网络变化时的回调方法
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:        // 网络错误
            case AFNetworkReachabilityStatusNotReachable:   // 没有连接网络
            {
                MDSnackbar *t = [[MDSnackbar alloc] initWithText:STRING_NONETWORK actionTitle:@"" duration:3.0];
                [t show];
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                break;
        }
    }];
}

#pragma mark - API request
// 基础Get网络请求
- (void)dq_getRequestWithUrl:(NSString *)urlStr
                   parameters:(NSDictionary *)params
                     progress:(DQProcessBlock)progress
                      success:(DQSuccessBlock)suc
                     failture:(DQFailureBlock)fail {
//    // 网络检查
//    if (!_reachManager.isReachable) {
//        
//        MDSnackbar *t = [[MDSnackbar alloc] initWithText:STRING_REQUESTFAIL actionTitle:@"" duration:3.0];
//        [t show];
//        return;
//    }
    NSString *path = [APIURL stringByAppendingPathComponent:urlStr];
    NSURL *url = [NSURL URLWithString:path];
    
    [self.manager GET:url.absoluteString
           parameters:params
             progress:^(NSProgress * _Nonnull downloadProgress) {
                 
                 if (progress) {
                     progress(1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
                 }
                 
             } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 
                 DQResultModel *result = [DQResultModel mj_objectWithKeyValues:responseObject];
                 if (suc) {
                     suc(result);
                 }
                 
             } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 
                 MDSnackbar *t = [[MDSnackbar alloc] initWithText:STRING_APIEXCEPTION actionTitle:@"" duration:3.0];
                 [t show];

                 if (fail) {
                     fail(error);
                 }
             }];
}

// 基础Post网络请求
- (void)dq_postRequestWithUrl:(NSString *)url
                    parameters:(NSDictionary *)params
                      progress:(DQProcessBlock)progress
                       success:(DQSuccessBlock)suc
                      failture:(DQFailureBlock)fail {
//    // 网络检查
//    if (!_reachManager.isReachable) {
//        
//        MDSnackbar *t = [[MDSnackbar alloc] initWithText:STRING_REQUESTFAIL actionTitle:@"" duration:3.0];
//        [t show];
//        return;
//    }
    
    NSString *path = [APIURL stringByAppendingString:url];
    NSMutableDictionary *requestParameters = [[NSMutableDictionary alloc] init];
    if (nil != params) {
        [requestParameters addEntriesFromDictionary:params];
    }
    DQLog(@"\n接口：%@\n 请求参数:%@", url, [params mj_JSONString]);

    // 公参在此设置
    // .........
    [_manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    //申明请求的数据是json类型
    _manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    // 设置超时时间
    [_manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    _manager.requestSerializer.timeoutInterval = 20.f;
    [_manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    [_manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    NSSet *set = [NSSet setWithObjects:@"text/plain",@"text/json",@"application/json",@"text/javascript",@"text/html", @"application/javascript", @"text/js",@"image/jpeg",
                  @"image/png",@"application/octet-stream",nil];
    _manager.responseSerializer.acceptableContentTypes = set;
    
    [_manager POST:path parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        //处理请求进度
        progress(1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            // 第一层解析出ResultModel
            DQResultModel *result = [DQResultModel mj_objectWithKeyValues:responseObject];
            NSString *json = [responseObject mj_JSONString];
            DQLog(@"\n请求接口：【%@】,返回数据：【%@】\n", path, [responseObject mj_JSONObject]);
            if (suc && result) {
                suc(result);
            }
            else {
                fail([NSError errorWithDomain:STRING_NONETWORK code:-1 userInfo:nil]);
            }
        }];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            MDSnackbar *t = [[MDSnackbar alloc] initWithText:STRING_REQUESTFAIL actionTitle:@"" duration:3.0];
            [t show];
            
            fail(error);
        }];
    }];
}

/** 上传图片
 */
- (void)dq_uploadImage:(NSArray *)images
              progress:(DQProcessBlock)progress
               success:(DQSuccessBlock)suc
              failture:(DQFailureBlock)fail {
    NSString *url = [NSString stringWithFormat:@"%@%@", httpUrl, API_UploadImages];
    _manager.requestSerializer.timeoutInterval = TIMEOUT_API;
    _manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [_manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {

        for (UIImage *image in images) {
            
            NSData *imageData = UIImageJPEGRepresentation([UIImage dq_compressImage:image toByte:100 * 1024], 1.0);
            [formData appendPartWithFileData:imageData
                                        name:@"files" fileName:@"files"
                                    mimeType:@"multipart/form-data"];
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        DQLog(@"\n上传图片进度 -> %f\n", 1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
        if (uploadProgress) {
            progress(1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
        }
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        DQResultModel *result = [DQResultModel mj_objectWithKeyValues:responseObject];
        
        NSError *error;
        
        NSDictionary *InfoDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&error];
        DQLog(@"\n请求接口：【%@】,返回数据：【%@】\n", url, InfoDic);
        if (suc && result) {
            suc(result);
        }
        else {
            fail([NSError errorWithDomain:STRING_NONETWORK code:0 userInfo:nil]);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DQLog(@"上传图片失败 -> %@\n", error.description);
        fail([NSError errorWithDomain:@"上传失败" code:error.code userInfo:nil]);
    }];
}

@end
