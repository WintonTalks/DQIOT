//
//  DQServiceReportView.m
//  WebThings
//  设备清算单／设备安装报告单
//  Created by Heidi on 2017/10/10.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DQServiceReportView.h"

#import "DQServiceReportInfoCell.h"

@implementation DQServiceReportView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _dataArray = [NSMutableArray arrayWithCapacity:0];

        self.layer.cornerRadius = 5.0;
        self.layer.masksToBounds = YES;
        self.layer.borderColor = [UIColor colorWithHexString:COLOR_GREEN].CGColor;
        self.layer.borderWidth = 0.5;

        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 1, frame.size.width, 51)];
        bgView.backgroundColor = [UIColor colorWithHexString:COLOR_GREEN_LIGHT];
        [self addSubview:bgView];
        
        _lblTitle = [[UILabel alloc] initWithFrame:bgView.frame];
        _lblTitle.font = [UIFont boldSystemFontOfSize:20];
        _lblTitle.textColor = [UIColor colorWithHexString:COLOR_GREEN];
        _lblTitle.textAlignment = NSTextAlignmentCenter;
        [bgView addSubview:_lblTitle];

        _mainTable = [[UITableView alloc]
                      initWithFrame:CGRectMake(0, bgView.frame.size.height + 16,
                                               frame.size.width, frame.size.height)
                      style:UITableViewStylePlain];
        _mainTable.dataSource = self;
        _mainTable.delegate = self;
        _mainTable.rowHeight = kHEIHGT_REPORTCELL;
        _mainTable.scrollEnabled = NO;
        _mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:_mainTable];
        
        _imgPass = [[UIImageView alloc] initWithFrame:
                    CGRectMake(frame.size.width - 44 - 68,
                               frame.size.height - 30 - 53, 68, 53)];
        _imgPass.image = [UIImage imageNamed:@"flow_of_service_zhang"];
        [self addSubview:_imgPass];
    }
    return self;
}

- (void)setData:(NSArray *)data {
    [_dataArray removeAllObjects];
    [_dataArray addObjectsFromArray:data];
    [_mainTable reloadData];
    
    _lblTitle.text = [NSObject changeType:_titleStr];

    // 根据数据条数重置View高度
    CGRect rect = self.frame;
    rect.size.height = kHEIHGT_REPORTCELL * [data count] + 52 + 25;
    self.frame = rect;
    _mainTable.frame = CGRectMake(0, 52 + 25, self.frame.size.width, kHEIHGT_REPORTCELL * [data count]);
    // 重置“通过”图片的位置
    _imgPass.frame = CGRectMake(rect.size.width - 44 - 68,
                                rect.size.height - 30 - 53, 68, 53);
    _imgPass.hidden = !_isPassed;
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"DQServiceReportInfoCell";
    DQServiceReportInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[DQServiceReportInfoCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }
    [cell setTitle:_dataArray[indexPath.row]];
    
    return cell;
}

@end
