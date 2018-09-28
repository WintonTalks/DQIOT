//
//  DQBusinessDealingsView.h
//  WebThings
//
//  Created by winton on 2017/10/10.
//  Copyright © 2017年 machinsight. All rights reserved.
//  Done By Heidi 2017/10/13
//  商务往来

#import <UIKit/UIKit.h>

@class DQLogicBusinessContractModel;

@interface DQBusinessDealingsView : UIView
<UITableViewDelegate, UITableViewDataSource,
UIScrollViewDelegate> {
    UITableView *_mainTable;
    NSMutableArray *_dataArray;
    
    DQLogicBusinessContractModel *_btnLogic;
    
    NSMutableArray *_foldSections;    // 收起的Sections
}

@property (nonatomic, strong) UINavigationController *navCtl;
@property (nonatomic, assign) NSInteger projectID;

- (void)reloadData;

@end
