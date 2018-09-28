//
//  DQStarView.h
//  DQStarDemo
//
//  Created by winton on 2017/10/28.
//  Copyright © 2017年 winton. All rights reserved.
//

#import <UIKit/UIKit.h>
/** 选中星星的类型 */
typedef NS_ENUM(NSUInteger, DQStarViewStarType) {
    // 未选中
    Selected_noStar = 0,
    // 全部选中
    Selected_allStar
};

@interface DQStarView : UIView

#pragma mark - property
/** 星星_是否为选中状态 */
@property (nonatomic, assign) DQStarViewStarType selectedStarType;

@end
