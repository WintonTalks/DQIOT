//
//  DQBaseAPIInterface.h
//  WebThings
//  基础网络请求类
//  Created by Heidi on 2017/9/7.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "DQAPIDefine.h"

@interface DQBaseAPIInterface : NSObject

+ (instancetype)sharedInstance;

// 检查网络连接，未连接时弹出toast
- (void)dq_checkNetwork;

/** 基础Get网络请求
 * @param url      地址
 * @param params   请求参数
 * @param progress 进度
 * @param suc      成功
 * @param fail     失败
 */
- (void)dq_getRequestWithUrl:(NSString *)url
                parameters:(NSDictionary *)params
                  progress:(DQProcessBlock)progress
                   success:(DQSuccessBlock)suc
                  failture:(DQFailureBlock)fail;

/** 基础Post网络请求
 * @param url      地址
 * @param params   请求参数
 * @param progress 进度
 * @param suc      成功
 * @param fail     失败
 */
- (void)dq_postRequestWithUrl:(NSString *)url
                   parameters:(NSDictionary *)params
                     progress:(DQProcessBlock)progress
                      success:(DQSuccessBlock)suc
                     failture:(DQFailureBlock)fail;

/** 上传图片
 */
- (void)dq_uploadImage:(NSArray *)images
              progress:(DQProcessBlock)progress
               success:(DQSuccessBlock)suc
              failture:(DQFailureBlock)fail;

@end
