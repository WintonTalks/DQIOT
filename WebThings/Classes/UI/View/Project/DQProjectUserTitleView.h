//
//  DQProjectUserTitleView.h
//  WebThings
//
//  Created by 孙文强 on 2017/9/29.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DQProjectUserTitleView;
typedef NS_ENUM(NSInteger, DQProjectUserTitleViewType) {
    KDQProjectUserAttendanceStyle = 1,//考勤
    KDQProjectUserQualificationStyle = 2,//资质
    KDQProjectUserTrainingStyle = 3,//培训
    KDQProjectUserEvaluationStyle = 4 //人员评价
};

typedef NS_ENUM(NSInteger, DQProjectManageInfoViewType) {
    KDQProjectManageTopSelectedStyle,
    KDQProjectManageBottomNormalStyle
};

@protocol DQProjectUserTitleViewDelegate <NSObject>
- (void)didProjectUserMentView:(DQProjectUserTitleView *)titleView
                          type:(DQProjectUserTitleViewType)type;
@end

@interface DQProjectUserTitleView : UIView
- (instancetype)initWithFrame:(CGRect)frame
           manageInfoViewType:(DQProjectManageInfoViewType)type;
@property (nonatomic, weak) id<DQProjectUserTitleViewDelegate> delegate;
@end
