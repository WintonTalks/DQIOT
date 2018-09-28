
//
//  Header.h
//  WebThings
//  “三维”／商务往来中的新增按钮
//  Created by Heidi on 2017/10/10.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#ifndef DQServiceButtonView_h
#define DQServiceButtonView_h

@class DQLogicServiceBaseModel;

@interface DQServiceButtonView : UIView
{
    UIButton *_btnHandle;
    CALayer *_subLayer;
}

- (id)initWithFrame:(CGRect)frame logic:(DQLogicServiceBaseModel *)logic;

@end

#endif /* DQServiceButtonView_h */
