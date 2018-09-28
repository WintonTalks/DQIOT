//
//  DQServiceBillView.m
//  WebThings
//
//  Created by Heidi on 2017/10/10.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DQServiceBillView.h"

#import "DQServiceInfoCell.h"

@implementation DQServiceBillView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _dataArray = [NSMutableArray arrayWithCapacity:0];

        _mainTable = [[UITableView alloc]
                      initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)
                      style:UITableViewStylePlain];
        _mainTable.dataSource = self;
        _mainTable.delegate = self;
        _mainTable.scrollEnabled = NO;
        _mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTable.backgroundColor = [UIColor clearColor];
        [self addSubview:_mainTable];
    }
    return self;
}

- (void)setData:(NSArray *)data {
    [_dataArray removeAllObjects];
    [_dataArray addObjectsFromArray:data];

    [_mainTable reloadData];
    
    // 根据数据条数重置View高度
    CGRect rect = _mainTable.frame;
    rect.size.height = [self getViewHeight];
    _mainTable.frame = rect;
}

- (CGFloat)getViewHeight {
    CGFloat height = 0;
    for (NSDictionary *dict in _dataArray) {

        CGSize size = [AppUtils
                       textSizeFromTextString:dict[@"value"]
                       width:kWIDTH_BILLCELL
                       height:1000
                       font:[UIFont boldSystemFontOfSize:14]];
        if (size.height < 20) {
            height += 30;
        } else {
            height += size.height + 16;
        }
    }
    
    return height;
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 30;
    NSDictionary *dict = _dataArray[indexPath.row];
    NSString *str = dict[@"value"];
    CGSize size = [AppUtils
                   textSizeFromTextString:str
                   width:kWIDTH_BILLCELL
                   height:1000
                   font:[UIFont boldSystemFontOfSize:14]];
    if (size.height > 20) {
        height = ceil(size.height) + 16;
    }

    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ServiceBillCellIdentifier";
    DQServiceInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[DQServiceInfoCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
    }
    [cell setData:_dataArray[indexPath.row]];
    
    return cell;
}

@end
