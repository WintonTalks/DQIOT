//
//  CheckModel.h
//  WebThings
//
//  Created by machinsight on 2017/7/13.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <Foundation/Foundation.h>
//检查项目的类型:checktype
//    状态：checkstate
@interface CheckModel : NSObject
@property (nonatomic, strong) NSString *checktype;
@property (nonatomic, strong) NSString *checkstate;
@property (nonatomic, strong) NSArray *states;

- (UIColor *)getColor;
- (CGFloat)cellForHeight;
@end
