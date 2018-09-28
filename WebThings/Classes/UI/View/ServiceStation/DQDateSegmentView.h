//
//  DQDateSegmentView.h
//  WebThings
//
//  Created by Eugene on 10/25/17.
//  Copyright © 2017 machinsight. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DQDateSegmentView : UIView

/**
 字符串的DateFormatter 必须为 @"yyyy/MM/dd"
 */
@property (nonatomic, strong) NSString *dateString;

@end
