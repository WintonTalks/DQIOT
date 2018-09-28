//
//  ServiceFinishBtn.h
//  WebThings
//
//  Created by machinsight on 2017/8/5.
//  Copyright © 2017年 machinsight. All rights reserved.
//  已完成的按钮

#import <UIKit/UIKit.h>

@interface ServiceFinishBtn : UIView
@property (nonatomic, retain) IBOutlet UIView *contentView;

- (void)setSureTag:(NSInteger)tag1 ;
//0:已确认时间并发起维保190
//1:我已完成维保140
//2：已确认时间并发起维修190
//3:我已完成维修140
//4:已确认时间并发起加高180
//5：我已完成加高140
//6：费用已缴清
//7：回复

- (void)setAction1:(SEL)action1 target:(id)target;

- (void)setBtnTitle:(NSString *)title Width:(CGFloat)wid;
@end
