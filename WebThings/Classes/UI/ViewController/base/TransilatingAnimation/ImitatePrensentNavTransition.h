//
//  ImitatePrensentNavTransition.h
//  WebThings
//
//  Created by machinsight on 2017/8/18.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImitatePrensentNavTransition : NSObject<UIViewControllerAnimatedTransitioning>
@property (getter=isReverse) BOOL reverse;
@end
