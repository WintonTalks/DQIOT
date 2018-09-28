//
//  EditDriverViewController.h
//  WebThings
//
//  Created by machinsight on 2017/7/19.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "EMIBaseViewController.h"
#import "DriverModel.h"

@class EditDriverViewController;
@protocol EditDriverViewControllerDelegate <NSObject>
- (void)didPopWithDriver:(DriverModel *)driver WithIndex:(NSInteger)index;

@end
@interface EditDriverViewController : EMIBaseViewController
@property (nonatomic, assign) id<EditDriverViewControllerDelegate> delegate;
@property (nonatomic, strong) DriverModel *dm;
@property (nonatomic, assign) NSInteger index;//记录修改的第几个
@end
