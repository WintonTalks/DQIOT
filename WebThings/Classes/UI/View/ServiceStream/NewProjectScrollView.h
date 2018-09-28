//
//  NewProjectScrollView.h
//  WebThings
//
//  Created by machinsight on 2017/6/21.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NewProjectScrollView;
@protocol NewProjectScrollViewDelegate <NSObject>

- (void)sureBtnClicked:(NSArray *)arr str:(NSString *)str;

@end
@interface NewProjectScrollView : UIView
@property (nonatomic,weak) id<NewProjectScrollViewDelegate> delegate;

- (void)showWithFatherV:(UIView *)fatherV;

- (void)disshow;

- (void)setDataArr:(NSMutableArray *)arr;
@end
