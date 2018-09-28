//
//  DQDataCenterView.h
//  WebThings
//
//  Created by Heidi on 2017/9/14.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#ifndef DQDataCenterView_h
#define DQDataCenterView_h
#import <UIKit/UIKit.h>
#import "DQDefine.h"

@interface DQDataCenterView : UIView
<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_mainTable;
    NSMutableArray *_projectArray;
    
    NSMutableArray *_foldArray;     // 用来控制Section展开和收起
}

@property (nonatomic, copy)  DQResultBlock reportClick;
@property (nonatomic, copy)  DQResult2Block deviceClick;
@property (nonatomic, copy)  DQResultBlock refresh;

/// 初始化，并传入下拉刷新处理的函数
- (id)initWithFrame:(CGRect)frame refreshSelector:(SEL)selector target:(id)tar;

/// 停止刷新
- (void)endRefresh;

/// 处理请求数据并展示
- (void)handleResultData:(NSArray *)result;

- (NSArray *)dataArray;

@end

#endif /* DQDataCenterView_h */
