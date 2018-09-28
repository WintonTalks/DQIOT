//
//  CKRefreshHeader.m
//  WebThings
//
//  Created by machinsight on 2017/7/10.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "CKRefreshHeader.h"

@implementation CKRefreshHeader

- (void)prepare{
    [super prepare];
    self.lastUpdatedTimeLabel.hidden = YES;
    self.stateLabel.hidden = YES;
    // 设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=2; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"refresh%zd", i]];
        [idleImages safeAddObject:image];
    }
    [self setImages:idleImages forState:MJRefreshStateIdle];
    
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 3; i<=4; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"refresh%zd", i]];
        [refreshingImages addObject:image];
    }
    [self setImages:refreshingImages forState:MJRefreshStatePulling];
    
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    NSMutableArray *nowrefreshingImages = [NSMutableArray array];
    for (NSUInteger i = 5; i<=22; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"refresh%zd", i]];
        [nowrefreshingImages addObject:image];
    }
    // 设置正在刷新状态的动画图片
    [self setImages:nowrefreshingImages forState:MJRefreshStateRefreshing];
}

@end
