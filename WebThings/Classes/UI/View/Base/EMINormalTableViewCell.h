//
//  EMINormalTableViewCell.h
//  WebThings
//
//  Created by machinsight on 2017/6/30.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceCenterBaseModel.h"

//@protocol RobotOptDelegate <NSObject>
//
//-(void)onConfirm:(id)data;
//
//@end

@interface EMINormalTableViewCell : UITableViewCell

@property (nonatomic,strong) UserModel *baseUser;

+ (id)cellWithTableView:(UITableView *)tableview;

@property (nonatomic,strong)ServiceCenterBaseModel *baseServiceModel;

@end
