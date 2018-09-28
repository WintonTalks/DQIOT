//
//  DQMyCenterInterface.m
//  WebThings
//  个人中心
//  Created by Heidi on 2017/9/5.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DQBaseAPIInterface.h"
#import "DQMyCenterInterface.h"

@implementation DQMyCenterInterface

+ (DQMyCenterInterface *)sharedInstance
{
    static DQMyCenterInterface *singleton = nil;
    static dispatch_once_t pred = 0;
    dispatch_once(&pred, ^{
        singleton = [[self alloc] init];
    });
    return singleton;
}

/**
 登录接口
 
 @param username 账号
 @param password 密码
 */
- (void)dq_getLoginApi:(NSString *)username
              password:(NSString *)password
               success:(DQResultBlock)suc
              failture:(DQFailureBlock)fail
{
    NSDictionary *dict = @{@"username" : username,
                           @"password" : password};
    [[DQBaseAPIInterface sharedInstance] dq_postRequestWithUrl:API_Login parameters:dict progress:^(CGFloat percent) {
        
    } success:^(DQResultModel *returnValue) {
        if ([returnValue isRequestSuccess]) {
            UserModel *m = [UserModel mj_objectWithKeyValues:returnValue.data];
            suc(m);
        }
    } failture:^(NSError *error) {
        fail(error);
    }];
}

///获取验证码
- (void)dq_getAppVerifyApi:(NSString *)dn
                   success:(DQResultBlock)suc
                  failture:(DQFailureBlock)fail
{
    NSDictionary *dict = @{@"dn":dn};
    [[DQBaseAPIInterface sharedInstance] dq_postRequestWithUrl:API_AppVerify parameters:dict progress:^(CGFloat percent) {
        
    } success:^(DQResultModel *returnValue) {
        if ([returnValue isRequestSuccess]) {
            suc(@(1));
        } else {
            suc(nil);
        }
    } failture:^(NSError *error) {
        fail(error);
    }];
}

//忘记密码
- (void)dq_getUpdatepassdApi:(NSString *)dn
                        code:(NSString *)code
                         pwd:(NSString *)pwd
                     success:(DQResultBlock)suc
                    failture:(DQFailureBlock)fail
{
    NSDictionary *dict = @{@"dn" : dn,
                           @"code" : code,
                           @"pwd" : pwd};
    [[DQBaseAPIInterface sharedInstance] dq_postRequestWithUrl:API_UpdatePassd parameters:dict progress:^(CGFloat percent) {
        
    } success:^(DQResultModel *returnValue) {
        if ([returnValue isRequestSuccess]) {
            suc(@(1));
        } else {
            suc(nil);
        }
    } failture:^(NSError *error) {
        fail(error);
    }];
}

- (void)dq_getUserModifyApi:(UserModel *)model
                    success:(DQResultBlock)suc
                   failture:(DQFailureBlock)fail
{
    NSDictionary *dict = model.mj_keyValues;
    
    [[DQBaseAPIInterface sharedInstance] dq_postRequestWithUrl:API_ModifyUserFile parameters:dict progress:^(CGFloat percent) {
        
    } success:^(DQResultModel *returnValue) {
        if ([returnValue isRequestSuccess]) {
            suc(nil);
        }
    } failture:^(NSError *error) {
        fail(error);
    }];
}

/**
 修改用户头像

 */
- (void)dq_getUploadImageApi:(UIImage *)image
                     success:(DQResultBlock)suc
                    failture:(DQFailureBlock)fail
{
    NSString *url = [NSString stringWithFormat:@"%@%@",httpUrl,API_UpdateUserHeadImage];
    [[CKNetTools sharedCKNetTools] uploadWithImage:image WithURL:url WithParamater:nil WithProgressBlock:^(NSProgress *process) {
        
    } WithSuccessBlock:^(NSDictionary * returnValue) {
        NSString *success = [returnValue objectForKey:@"success"];
        if (success.intValue == 1) {
            suc(returnValue);
        } else {
            suc(nil);
        }
    } WithFailureBlock:^(NSError *error) {
        fail(error);
    }];
}

/**
 我的同事

 */
- (void)dq_getMyColleagueListApi:(UserModel *)model
                         success:(DQResultBlock)suc
                        failture:(DQFailureBlock)fail
{
    NSDictionary *dict = @{@"userid":@(model.userid)
                           ,@"type":[NSObject changeType:model.type],
                           @"usertype":[NSObject changeType:model.usertype]};
    [[DQBaseAPIInterface sharedInstance] dq_postRequestWithUrl:API_MyColleagueList parameters:dict progress:^(CGFloat percent) {
        
    } success:^(DQResultModel *returnValue) {
        if ([returnValue isRequestSuccess]) {
            NSMutableArray <UserModel *> *dataList = [UserModel mj_objectArrayWithKeyValuesArray:returnValue.data];
            suc(dataList);
        }
    } failture:^(NSError *error) {
        fail(error);
    }];
}

/**
 修改密码

 */
- (void)dq_getFixPassWordApi:(UserModel *)model
                     oldText:(NSString *)oldText
                     newText:(NSString *)newText
                     success:(DQResultBlock)suc
                    failture:(DQFailureBlock)fail
{
    NSDictionary *dict = @{@"userid":@(model.userid),
                           @"type":[NSObject changeType:model.type],
                           @"oldpassword":[Encrypt md5EncryptWithString:oldText],
                           @"newpassword":[Encrypt md5EncryptWithString:newText],
                           @"usertype":[NSObject changeType:model.usertype]};
    [[DQBaseAPIInterface sharedInstance] dq_postRequestWithUrl:API_FixPassWord parameters:dict progress:^(CGFloat percent) {
        
    } success:^(DQResultModel *returnValue) {
        if ([returnValue isRequestSuccess]) {
            suc(nil);
        }
    } failture:^(NSError *error) {
        fail(error);
    }];
}

/**
 意见反馈

 */
- (void)dq_getUserFeedBackApi:(UserModel *)model
                         text:(NSString *)text
                      success:(DQResultBlock)suc
                     failture:(DQFailureBlock)fail
{
    NSDictionary *dict = @{@"userid":@(model.userid),
                           @"type":[NSObject changeType:model.type],
                           @"msg":text,
                           @"usertype":[NSObject changeType:model.usertype]};
    [CKNetTools requestWithRequestType:POST WithURL:appendUrl(httpUrl, API_FeedBack) WithParamater:dict WithProgressBlock:^(NSProgress *process) {
    } WithSuccessBlock:^(id returnValue) {
        NSDictionary *dict = (NSDictionary *)returnValue;
        NSString *success = [NSString stringWithFormat:@"%@",[dict objectForKey:@"success"]];
        if (success.intValue == 1) {
            suc(success);
        }
    } WithFailureBlock:^(NSError *error) {
        fail(error);
    }];
}

@end
