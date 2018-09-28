//
//  MascroDefinition.h
//  WebThings
//
//  Created by 孙文强 on 2017/9/7.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <Foundation/Foundation.h>

// -- 关键字宏 --
#define KUserLoginKey    @"Login_Key"
#define kMUpUserFileKey  @"Update_User_File"
#define DEBUG 1

// -- 功能性宏 --
// Log输出
#ifdef DEBUG
#define DQLog( s, ... ) NSLog( @"<%@:(%d)> %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else



#endif
