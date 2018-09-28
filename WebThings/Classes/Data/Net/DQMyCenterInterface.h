//
//  DQMyCenterInterface.h
//  WebThings
//  个人中心
//  Created by Heidi on 2017/9/5.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#ifndef DQMyCenterInterface_h
#define DQMyCenterInterface_h


@interface DQMyCenterInterface : NSObject

+ (DQMyCenterInterface *)sharedInstance;

/**
 登录接口

 @param username 账号
 @param password 密码
 */
- (void)dq_getLoginApi:(NSString *)username
              password:(NSString *)password
               success:(DQResultBlock)suc
              failture:(DQFailureBlock)fail;

///获取验证码
- (void)dq_getAppVerifyApi:(NSString *)dn
                   success:(DQResultBlock)suc
                  failture:(DQFailureBlock)fail;

//忘记密码
- (void)dq_getUpdatepassdApi:(NSString *)dn
                        code:(NSString *)code
                         pwd:(NSString *)pwd
                     success:(DQResultBlock)suc
                    failture:(DQFailureBlock)fail;


/**
 修改用户资料
 
 */
- (void)dq_getUserModifyApi:(UserModel *)model
                    success:(DQResultBlock)suc
                   failture:(DQFailureBlock)fail;

/**
 修改用户头像
 
 */
- (void)dq_getUploadImageApi:(UIImage *)image
                     success:(DQResultBlock)suc
                    failture:(DQFailureBlock)fail;


/**
 我的同事
 
 */
- (void)dq_getMyColleagueListApi:(UserModel *)model
                         success:(DQResultBlock)suc
                        failture:(DQFailureBlock)fail;

/**
 修改密码

 */
- (void)dq_getFixPassWordApi:(UserModel *)model
                     oldText:(NSString *)oldText
                     newText:(NSString *)newText
                     success:(DQResultBlock)suc
                    failture:(DQFailureBlock)fail;

/**
 意见反馈
 
 */
- (void)dq_getUserFeedBackApi:(UserModel *)model
                         text:(NSString *)text
                      success:(DQResultBlock)suc
                     failture:(DQFailureBlock)fail;

@end


#endif /* DQMyCenterInterface_h */
