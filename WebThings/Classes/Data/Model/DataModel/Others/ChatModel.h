//
//  ChatModel.h
//  WebThings
//
//  Created by machinsight on 2017/6/29.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 聊天模型
 */
@interface ChatModel : NSObject

@property NSString *checktype;/**
                    0机器人文字，居左，带头像
                    1用户语音文字，居右，无头像
                    2机器人的百度提醒，居中，无头像
                    3你可以让我做这些，居中，无头像
                    */
//@property NSString *headUrl;/**头像*/
@property (nonatomic, strong) NSString *contentStr;/**内容*/
@property (nonatomic, strong) id data;/**未知类型的其他模型*/
@property (nonatomic, strong) NSString *returnmsg;
/**
 cell的高度
 */
@property (nonatomic, assign) CGFloat cellHeight;

+ (ChatModel *)getType0ModelWithStr:(NSString *)cons;
+ (ChatModel *)getType1ModelWithStr:(NSString *)cons;
+ (ChatModel *)getType2ModelWithStr:(NSString *)cons;
//+ (ChatModel *)getType3ModelWithStr:(NSString *)cons;
@end
