//
//  XWBJView.h
//  WebThings
//
//  Created by machinsight on 2017/7/6.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataCenterModel.h"

@class XWBJView;
@protocol XWBJViewDelegate <NSObject>

@optional
- (void)yhsBtnClicked;
- (void)ywxBtnClicked;

@end

@interface XWBJView : UIView

@property (nonatomic ,weak) id<XWBJViewDelegate> delegate;

- (void)showWithFatherV:(UIView *)fatherV;

- (void)disshow;

- (void)setViewValuesWithModel:(DataCenterModel *)model;
@end
