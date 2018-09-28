//
//  DQResultModel.h
//  WebThings
//
//  Created by Heidi on 2017/9/7.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#ifndef DQResultModel_h
#define DQResultModel_h

@interface DQResultModel : NSObject

@property (nonatomic, assign) NSInteger success;    // success: 1.成功
@property (nonatomic, assign) id data;
@property (nonatomic, strong) NSArray *list;
@property (nonatomic, copy) NSString *msg;
// 适配老的接口,错误信息
@property (nonatomic, copy) NSString *failinfor;
// 上传图片接口返回
@property (nonatomic, strong) NSArray *imgpath;

/// 请求成功
- (BOOL)isRequestSuccess;

@end

#endif /* DQResultModel_h */
