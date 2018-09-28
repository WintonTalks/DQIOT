//
//  DQProjectSectionHeaderView.h
//  WebThings
//  项目SectionView
//  Created by Heidi on 2017/9/8.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#ifndef DQProjectSectionHeaderView_h
#define DQProjectSectionHeaderView_h

#import <UIKit/UIKit.h>

@class AddProjectModel;

@interface DQProjectSectionHeaderView : UITableViewHeaderFooterView {
    UILabel *_titleLabel;
    UILabel *_moreLabel;
    UIImageView *_icon;
    UIButton *_button;
}

@property (nonatomic, copy) DQResultBlock clicked;
@property (nonatomic, assign) BOOL isFold;

- (void)setProject:(AddProjectModel *)project;

@end

#endif /* DQProjectSectionHeaderView_h */
