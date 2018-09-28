//
//  RobotChatViewController.h
//  WebThings
//
//  Created by machinsight on 2017/6/28.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "EMIBaseViewController.h"
#import "ChatModel.h"
@interface RobotChatViewController : EMIBaseViewController
//-(void)say:(NSString *)content;
-(void)xiaoWeiSay:(NSString *)content;
-(void)addChatModel:(ChatModel *)model;
@end
