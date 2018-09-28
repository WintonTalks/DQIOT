//
//  RemindMsgCell.h
//  WebThings
//
//  Created by Henry on 2017/8/2.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RobotRemindMsgDelegate <NSObject>

-(void)onConfirmDate:(NSString *)date;

@end

@interface RemindMsgCell : UITableViewCell
@property (nonatomic,strong)NSString *msg;
@property (nonatomic,  weak) id<RobotRemindMsgDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *remindMsg;
//@property(nonatomic,assign)id<RobotRemindMsgDelegate> delegate;
+(instancetype)cellWithTableView:(UITableView *)tableView data:(id)data;

- (CGFloat)cellHeight;


@end
