//
//  RobotUserView.h
//  WebThings
//
//  Created by Henry on 2017/8/1.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"

@interface RobotUserView : UIView

//-(void)setUser:(UserModel *)user;
+(instancetype)viewWithUser:(UserModel *)user;

@end
