//
//  PushAlert.h
//  WebThings
//
//  Created by machinsight on 2017/8/11.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PushModel.h"

@interface PushAlert : UIControl
@property(nonatomic,strong)PushModel *m;
- (void)show;
@end
