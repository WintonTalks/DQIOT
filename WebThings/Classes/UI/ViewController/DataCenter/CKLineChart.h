//
//  CKLineChart.h
//  WebThings
//
//  Created by machinsight on 2017/7/18.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <PNChart/PNChart.h>

@interface CKLineChart : PNLineChart
- (void)setXLabels:(NSArray *)xLabels withWidth:(CGFloat)width;
@end
