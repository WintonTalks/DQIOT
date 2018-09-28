//
//  ChooseDriversViewController.h
//  WebThings
//
//  Created by machinsight on 2017/7/17.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "EMIBaseViewController.h"

@class ChooseDriversViewController;

@protocol ChooseDriversViewControllerDelegate <NSObject>

- (void)didPopWithDriverModel:(UserModel *)model;

@end

@interface ChooseDriversViewController : EMIBaseViewController
@property (nonatomic,weak) id<ChooseDriversViewControllerDelegate> delegate;
@end
