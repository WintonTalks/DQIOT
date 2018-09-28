
//
//  Header.h
//  WebThings
//
//  Created by Heidi on 2017/10/10.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#ifndef DQServiceBillView_h
#define DQServiceBillView_h

@interface DQServiceBillView : UIView
<UITableViewDataSource, UITableViewDelegate> {
    UITableView *_mainTable;
    NSMutableArray *_dataArray;
}

- (void)setData:(NSArray *)data;
// View的总高度
- (CGFloat)getViewHeight;

@end

#endif /* DQServiceBillView_h */
