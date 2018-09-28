//
//  RobotLockCell.h
//  WebThings
//
//  Created by Henry on 2017/8/1.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMINormalTableViewCell.h"

@protocol RobotLockDelegate <NSObject>
@optional
-(void)lockMachine;

@end


@interface RobotLockCell : EMINormalTableViewCell
@property (nonatomic, weak) id<RobotLockDelegate> robotDelegate;
+(instancetype)cellWithTableView:(UITableView *)tableView delegate:(id<RobotLockDelegate>)delegate;

- (CGFloat)cellHeight;
@end
