//
//  DQPopupListView.h
//
//
//  Created by Eugene on 10/18/17.
//  Copyright © 2017 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DQPopupListView : UIView

@property (nonatomic,copy) void(^didSelectBlock)(id modle);

+ (instancetype)shareInstance;

- (void)showPopListWithDataSource:(NSArray <NSString *>*)ary;

- (void)dismiss;

@end
