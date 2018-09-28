//
//  RobotLockCell.m
//  WebThings
//
//  Created by Henry on 2017/8/1.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "RobotLockCell.h"



@implementation RobotLockCell

- (IBAction)lockMachine:(id)sender {
    if (_robotDelegate) {
        [_robotDelegate lockMachine];
    }
}

+ (id)cellWithTableView:(UITableView *)tableview delegate:(id<RobotLockDelegate>)delegate{
    
    RobotLockCell *cell = [tableview dequeueReusableCellWithIdentifier:@"RobotLockCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RobotLockCell" owner:nil options:nil] objectAtIndex:0];
    }
    cell.robotDelegate = delegate;
    return cell;
}

-(CGFloat)cellHeight{
    return 63;
}
@end
