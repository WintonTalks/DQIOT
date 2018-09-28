//
//  DQDateInfoHerderView.h
//  WebThings
//
//  Created by winton on 2017/10/10.
//  Copyright © 2017年 machinsight. All rights reserved.
//  培训记录的时间头视图

#import <UIKit/UIKit.h>

@interface DQDateInfoHerderView : UIView
- (void)configDateInfoClick:(NSString *)date
                       week:(NSString *)week
                     number:(NSInteger)number;
@end
