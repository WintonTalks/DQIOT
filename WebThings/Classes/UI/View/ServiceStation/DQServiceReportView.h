
//
//  DQServiceReportView.h
//  WebThings
//  设备清算单／设备安装报告单
//  Created by Heidi on 2017/10/10.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#ifndef DQServiceReportView_h
#define DQServiceReportView_h

@interface DQServiceReportView : UIView
<UITableViewDataSource, UITableViewDelegate> {
    UITableView *_mainTable;
    NSMutableArray *_dataArray;
    UIImageView *_imgPass;
    UILabel *_lblTitle;
}

@property (nonatomic, copy) NSString *titleStr;
@property (nonatomic, assign) BOOL isPassed;

- (void)setData:(NSArray *)data;

@end

#endif /* DQServiceReportView_h */
