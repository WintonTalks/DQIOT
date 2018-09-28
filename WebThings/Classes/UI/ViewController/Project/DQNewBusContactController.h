//
//  DQNewBusContactController.h
//  WebThings
//  添加商务往来／整改意见
//  Created by Heidi on 2017/10/16.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#ifndef DQNewBusContactController_h
#define DQNewBusContactController_h

#import "EMIBaseViewController.h"

@class DQTextFieldArrowForCell;

@interface DQNewBusContactController : EMIBaseViewController
<UITextViewDelegate>
{
    UITextView *_contentView;
    UILabel *_lblTimeLabel;
    UILabel *_placeHolder;
}

@property (nonatomic, assign) DQEnumState enumState;
@property (nonatomic, copy) NSString *titleStr;
@property (nonatomic, assign) NSInteger projectID;
@property (nonatomic, copy) NSString *businessID;

@end

#endif /* DQNewBusContactController_h */
