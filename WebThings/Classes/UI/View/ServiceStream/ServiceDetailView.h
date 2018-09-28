//
//  ServiceDetailView.h
//  WebThings
//
//  Created by machinsight on 2017/6/27.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ServiceDetailView : UIView
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (nonatomic, retain) IBOutlet UIView *contentView;


- (void)setViewValuesWithTitle:(NSString *)title WithContent:(NSString *)content;
@end
