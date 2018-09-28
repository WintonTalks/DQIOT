//
//  DQDeviceHeaderMentView.h
//  WebThings
//
//  Created by 孙文强 on 2017/9/28.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^DeviceHeaderMentViewBlock) (NSInteger index);
@interface DQDeviceHeaderMentView : UIView
@property (nonatomic, copy) DeviceHeaderMentViewBlock headerMentBlock;
@end
