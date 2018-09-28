//
//  DQProjectPullCell.h
//  WebThings
//
//  Created by winton on 2017/10/30.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DQProjectPullCell;

@protocol DQProjectPullCellDelegate <NSObject>
- (void)didOnProjectPullCell:(DQProjectPullCell *)pullCell;
@end

@interface DQProjectPullCell : UITableViewCell
@property (nonatomic,   weak) id<DQProjectPullCellDelegate>delegate;
@property (nonatomic, assign) BOOL checkState;
- (void)configProjectWithName:(NSString *)title;
@end
