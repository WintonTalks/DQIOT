//
//  ChatModel.m
//  WebThings
//
//  Created by machinsight on 2017/6/29.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "ChatModel.h"
#import "CheckStringConfig.h"
@implementation ChatModel
+ (ChatModel *)getType0ModelWithStr:(NSString *)cons{
    ChatModel *m = [[ChatModel alloc] init];
    m.checktype = TYPE_XIAOWEI;
//    m.headUrl = @"tab_3_selected";
//    m.contentStr = cons;
    m.data = cons;
    return m;
}

+ (ChatModel *)getType1ModelWithStr:(NSString *)cons{
    ChatModel *m = [[ChatModel alloc] init];
    m.checktype = TYPE_SAY;
//    m.contentStr = cons;
    m.data = cons;
    return m;
}

+ (ChatModel *)getType2ModelWithStr:(NSString *)cons{
    ChatModel *m = [[ChatModel alloc] init];
    m.checktype = TYPE_BAIDU;
//    m.contentStr = cons;
    m.data = cons;
    return m;
}

//+ (ChatModel *)getType3ModelWithStr:(NSString *)cons{
//    ChatModel *m = [[ChatModel alloc] init];
//    m.checktype = 3;
//    m.contentStr = cons;
//    return m;
//}
@end
