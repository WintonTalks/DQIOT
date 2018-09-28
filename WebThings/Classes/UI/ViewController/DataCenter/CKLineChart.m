//
//  CKLineChart.m
//  WebThings
//
//  Created by machinsight on 2017/7/18.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "CKLineChart.h"
#import "PNChartLabel.h"
@interface CKLineChart()
@property(nonatomic, strong) NSMutableArray *chartLineArray;  // Array[CAShapeLayer]
@property(nonatomic, strong) NSMutableArray *chartPointArray; // Array[CAShapeLayer] save the point layer
@property(nonatomic, strong) NSMutableArray *chartPath;       // Array of line path, one for each line.
@property(nonatomic, strong) NSMutableArray *pointPath;       // Array of point path, one for each line
@property(nonatomic, strong) NSMutableArray *endPointsOfPath;      // Array of start and end points of each line path, one for each line
//
@property(nonatomic, strong) CABasicAnimation *pathAnimation; // will be set to nil if _displayAnimation is NO

// display grade
@property(nonatomic, strong) NSMutableArray *gradeStringPaths;
@end
@implementation CKLineChart
#define IOS7_OR_LATER [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0
- (void)setXLabels:(NSArray *)xLabels {
   
}

- (void)setXLabels:(NSArray *)xLabels withWidth:(CGFloat)width {
    self.xLabels = xLabels;
    self.xLabelWidth = width;
    if (self.xChartLabels) {
        for (PNChartLabel *label in self.xChartLabels) {
            [label removeFromSuperview];
        }
    } else {
        self.xChartLabels = [NSMutableArray new];
    }
    
    NSString *labelText;
    
    if (self.showLabel) {
        for (int index = 0; index < xLabels.count; index++) {
            labelText = xLabels[index];
            
            NSInteger x = index * self.xLabelWidth;
            NSInteger y = self.chartMarginBottom + self.chartCavanHeight;
            
            PNChartLabel *label = [[PNChartLabel alloc] initWithFrame:CGRectMake(x, y, (NSInteger) self.xLabelWidth, (NSInteger) self.chartMarginBottom)];
            [label setTextAlignment:NSTextAlignmentCenter];
            label.text = labelText;
            [self setCustomStyleForXLabel:label];
            [self addSubview:label];
            [self.xChartLabels addObject:label];
        }
    }
}
- (void)setCustomStyleForXLabel:(UILabel *)label {
    if (self.xLabelFont) {
        label.font = self.xLabelFont;
    }
    
    if (self.xLabelColor) {
        label.textColor = self.xLabelColor;
    }
    
}



- (void)drawRect:(CGRect)rect {
    if (self.isShowCoordinateAxis) {
        CGFloat yAxisOffset = 10.f;
        
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        UIGraphicsPushContext(ctx);
        CGContextSetLineWidth(ctx, self.axisWidth);
        CGContextSetStrokeColorWithColor(ctx, [self.axisColor CGColor]);
        
        CGFloat xAxisWidth = CGRectGetWidth(rect) - (self.chartMarginLeft + self.chartMarginRight) / 2;
        CGFloat yAxisHeight = self.chartMarginBottom + self.chartCavanHeight;
        
        // draw coordinate axis
        CGContextMoveToPoint(ctx, self.chartMarginBottom + yAxisOffset, 0);
        CGContextAddLineToPoint(ctx, self.chartMarginBottom + yAxisOffset, yAxisHeight);
        CGContextAddLineToPoint(ctx, xAxisWidth, yAxisHeight);
        CGContextStrokePath(ctx);
        
        // draw y axis arrow
        CGContextMoveToPoint(ctx, self.chartMarginBottom + yAxisOffset - 3, 6);
        CGContextAddLineToPoint(ctx, self.chartMarginBottom + yAxisOffset, 0);
        CGContextAddLineToPoint(ctx, self.chartMarginBottom + yAxisOffset + 3, 6);
        CGContextStrokePath(ctx);
        
        // draw x axis arrow
        CGContextMoveToPoint(ctx, xAxisWidth - 6, yAxisHeight - 3);
        CGContextAddLineToPoint(ctx, xAxisWidth, yAxisHeight);
        CGContextAddLineToPoint(ctx, xAxisWidth - 6, yAxisHeight + 3);
        CGContextStrokePath(ctx);
        
        if (self.showLabel) {
            
            // draw x axis separator
            CGPoint point;
            for (NSUInteger i = 0; i < [self.xLabels count]; i++) {
                point = CGPointMake(2 * self.chartMarginLeft + (i * self.xLabelWidth), self.chartMarginBottom + self.chartCavanHeight);
                CGContextMoveToPoint(ctx, point.x, point.y - 2);
                CGContextAddLineToPoint(ctx, point.x, point.y);
                CGContextStrokePath(ctx);
            }
            
            // draw y axis separator
            CGFloat yStepHeight = self.chartCavanHeight / self.yLabelNum;
            for (NSUInteger i = 0; i < [self.xLabels count]; i++) {
                point = CGPointMake(self.chartMarginBottom + yAxisOffset, (self.chartCavanHeight - i * yStepHeight + self.yLabelHeight / 2));
                CGContextMoveToPoint(ctx, point.x, point.y);
                CGContextAddLineToPoint(ctx, point.x + 2, point.y);
                CGContextStrokePath(ctx);
            }
        }
        
        UIFont *font = [UIFont systemFontOfSize:11];
        
        // draw y unit
        if ([self.yUnit length]) {
            CGFloat height = [PNLineChart sizeOfString:self.yUnit withWidth:30.f font:font].height;
            CGRect drawRect = CGRectMake(self.chartMarginLeft + 10 + 5, 0, 30.f, height);
            [self drawTextInContext:ctx text:self.yUnit inRect:drawRect font:font];
        }
        
        // draw x unit
        if ([self.xUnit length]) {
            CGFloat height = [PNLineChart sizeOfString:self.xUnit withWidth:30.f font:font].height;
            CGRect drawRect = CGRectMake(CGRectGetWidth(rect) - self.chartMarginLeft + 5, self.chartMarginBottom + self.chartCavanHeight - height / 2, 25.f, height);
            [self drawTextInContext:ctx text:self.xUnit inRect:drawRect font:font];
        }
    }
    if (self.showYGridLines) {
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGFloat yAxisOffset = self.showLabel ? 10.f : 0.0f;
        CGPoint point;
        CGFloat yStepHeight = self.chartCavanHeight / self.yLabelNum;
        if (self.yGridLinesColor) {
            CGContextSetStrokeColorWithColor(ctx, self.yGridLinesColor.CGColor);
        } else {
            CGContextSetStrokeColorWithColor(ctx, [UIColor lightGrayColor].CGColor);
        }
        for (NSUInteger i = 0; i < self.yLabelNum; i++) {
            point = CGPointMake(self.chartMarginLeft + yAxisOffset, (self.chartCavanHeight - i * yStepHeight + self.yLabelHeight / 2));
            CGContextMoveToPoint(ctx, point.x, point.y);
            // add dotted style grid
            CGFloat dash[] = {6, 5};
            // dot diameter is 20 points
            CGContextSetLineWidth(ctx, 0.5);
            CGContextSetLineCap(ctx, kCGLineCapRound);
            CGContextSetLineDash(ctx, 0.0, dash, 2);
            CGContextAddLineToPoint(ctx, CGRectGetWidth(rect) - self.chartMarginLeft + 5, point.y);
            CGContextStrokePath(ctx);
        }
    }
    
//    [super drawRect:rect];
}


- (void)drawTextInContext:(CGContextRef)ctx text:(NSString *)text inRect:(CGRect)rect font:(UIFont *)font {
    if (IOS7_OR_LATER) {
        NSMutableParagraphStyle *priceParagraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        priceParagraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
        priceParagraphStyle.alignment = NSTextAlignmentLeft;
        
        [text drawInRect:rect
          withAttributes:@{NSParagraphStyleAttributeName : priceParagraphStyle, NSFontAttributeName : font}];
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [text drawInRect:rect
                withFont:font
           lineBreakMode:NSLineBreakByTruncatingTail
               alignment:NSTextAlignmentLeft];
#pragma clang diagnostic pop
    }
}



#pragma mark - Draw Chart

- (void)strokeChart {
    _chartPath = [[NSMutableArray alloc] init];
    _pointPath = [[NSMutableArray alloc] init];
    _gradeStringPaths = [NSMutableArray array];
    
    [self calculateChartPath:_chartPath andPointsPath:_pointPath andPathKeyPoints:self.pathPoints andPathStartEndPoints:_endPointsOfPath];
    // Draw each line
    for (NSUInteger lineIndex = 0; lineIndex < self.chartData.count; lineIndex++) {
        PNLineChartData *chartData = self.chartData[lineIndex];
        CAShapeLayer *chartLine = (CAShapeLayer *) self.chartLineArray[lineIndex];
        CAShapeLayer *pointLayer = (CAShapeLayer *) self.chartPointArray[lineIndex];
        UIGraphicsBeginImageContext(self.frame.size);
        // setup the color of the chart line
        if (chartData.color) {
            chartLine.strokeColor = [[chartData.color colorWithAlphaComponent:chartData.alpha] CGColor];
            if (chartData.inflexionPointColor) {
                pointLayer.strokeColor = [[chartData.inflexionPointColor
                                           colorWithAlphaComponent:chartData.alpha] CGColor];
            }
        } else {
            chartLine.strokeColor = [PNGreen CGColor];
            pointLayer.strokeColor = [PNGreen CGColor];
        }
        
        UIBezierPath *progressline = [_chartPath objectAtIndex:lineIndex];
        UIBezierPath *pointPath = [_pointPath objectAtIndex:lineIndex];
        
        chartLine.path = progressline.CGPath;
        pointLayer.path = pointPath.CGPath;
        
        [CATransaction begin];
        
        [chartLine addAnimation:self.pathAnimation forKey:@"strokeEndAnimation"];
        chartLine.strokeEnd = 1.0;
        
        // if you want cancel the point animation, conment this code, the point will show immediately
        if (chartData.inflexionPointStyle != PNLineChartPointStyleNone) {
            [pointLayer addAnimation:self.pathAnimation forKey:@"strokeEndAnimation"];
        }
        
        [CATransaction commit];
        
        NSMutableArray *textLayerArray = [self.gradeStringPaths objectAtIndex:lineIndex];
        for (CATextLayer *textLayer in textLayerArray) {
            CABasicAnimation *fadeAnimation = [self fadeAnimation];
            [textLayer addAnimation:fadeAnimation forKey:nil];
        }
        
        UIGraphicsEndImageContext();
    }
}


/**
 计算曲线值
 */
- (void)calculateChartPath:(NSMutableArray *)chartPath andPointsPath:(NSMutableArray *)pointsPath andPathKeyPoints:(NSMutableArray *)pathPoints andPathStartEndPoints:(NSMutableArray *)pointsOfPath {
    
    // Draw each line
    for (NSUInteger lineIndex = 0; lineIndex < self.chartData.count; lineIndex++) {
        PNLineChartData *chartData = self.chartData[lineIndex];
        
        CGFloat yValue;
        CGFloat innerGrade;
        
        UIBezierPath *progressline = [UIBezierPath bezierPath];
        
        UIBezierPath *pointPath = [UIBezierPath bezierPath];
        
        
        [chartPath insertObject:progressline atIndex:lineIndex];
        [pointsPath insertObject:pointPath atIndex:lineIndex];
        
        
        NSMutableArray *gradePathArray = [NSMutableArray array];
        [self.gradeStringPaths addObject:gradePathArray];
        
        NSMutableArray *linePointsArray = [[NSMutableArray alloc] init];
        NSMutableArray *lineStartEndPointsArray = [[NSMutableArray alloc] init];
        int last_x = 0;
        int last_y = 0;
        NSMutableArray<NSDictionary<NSString *, NSValue *> *> *progrssLinePaths = [NSMutableArray new];
        CGFloat inflexionWidth = chartData.inflexionPointWidth;
        
        for (NSUInteger i = 0; i < chartData.itemCount; i++) {
            
            yValue = chartData.getData(i).y;
            
            if (!(self.yValueMax - self.yValueMin)) {
                innerGrade = 0.5;
            } else {
                innerGrade = (yValue - self.yValueMin) / (self.yValueMax - self.yValueMin);
            }
            
//            int x = i * self.xLabelWidth + self.chartMarginLeft + self.xLabelWidth / 2.0;
            int x = i * self.xLabelWidth+self.xLabelWidth/2;
            
            int y = self.chartCavanHeight - (innerGrade * self.chartCavanHeight) + (self.yLabelHeight / 2) + self.chartMarginTop - self.chartMarginBottom;
            
            // Circular point
            if (chartData.inflexionPointStyle == PNLineChartPointStyleCircle) {
                
                CGRect circleRect = CGRectMake(x - inflexionWidth / 2, y - inflexionWidth / 2, inflexionWidth, inflexionWidth);
                CGPoint circleCenter = CGPointMake(circleRect.origin.x + (circleRect.size.width / 2), circleRect.origin.y + (circleRect.size.height / 2));
                
                [pointPath moveToPoint:CGPointMake(circleCenter.x + (inflexionWidth / 2), circleCenter.y)];
                [pointPath addArcWithCenter:circleCenter radius:inflexionWidth / 2 startAngle:0 endAngle:2 * M_PI clockwise:YES];
                
                //jet text display text
                if (chartData.showPointLabel) {
                    [gradePathArray addObject:[self createPointLabelFor:chartData.getData(i).rawY pointCenter:circleCenter width:inflexionWidth withChartData:chartData]];
                }
                
                if (i > 0) {
                    
                    // calculate the point for line
                    float distance = sqrt(pow(x - last_x, 2) + pow(y - last_y, 2));
                    float last_x1 = last_x + (inflexionWidth / 2) / distance * (x - last_x);
                    float last_y1 = last_y + (inflexionWidth / 2) / distance * (y - last_y);
                    float x1 = x - (inflexionWidth / 2) / distance * (x - last_x);
                    float y1 = y - (inflexionWidth / 2) / distance * (y - last_y);
                    
                    [progrssLinePaths addObject:@{@"from" : [NSValue valueWithCGPoint:CGPointMake(last_x1, last_y1)],
                                                  @"to" : [NSValue valueWithCGPoint:CGPointMake(x1, y1)]}];
                }
            }
            // Square point
            else if (chartData.inflexionPointStyle == PNLineChartPointStyleSquare) {
                
                CGRect squareRect = CGRectMake(x - inflexionWidth / 2, y - inflexionWidth / 2, inflexionWidth, inflexionWidth);
                CGPoint squareCenter = CGPointMake(squareRect.origin.x + (squareRect.size.width / 2), squareRect.origin.y + (squareRect.size.height / 2));
                
                [pointPath moveToPoint:CGPointMake(squareCenter.x - (inflexionWidth / 2), squareCenter.y - (inflexionWidth / 2))];
                [pointPath addLineToPoint:CGPointMake(squareCenter.x + (inflexionWidth / 2), squareCenter.y - (inflexionWidth / 2))];
                [pointPath addLineToPoint:CGPointMake(squareCenter.x + (inflexionWidth / 2), squareCenter.y + (inflexionWidth / 2))];
                [pointPath addLineToPoint:CGPointMake(squareCenter.x - (inflexionWidth / 2), squareCenter.y + (inflexionWidth / 2))];
                [pointPath closePath];
                
                // text display text
                if (chartData.showPointLabel) {
                    [gradePathArray addObject:[self createPointLabelFor:chartData.getData(i).rawY pointCenter:squareCenter width:inflexionWidth withChartData:chartData]];
                }
                
                if (i > 0) {
                    
                    // calculate the point for line
                    float distance = sqrt(pow(x - last_x, 2) + pow(y - last_y, 2));
                    float last_x1 = last_x + (inflexionWidth / 2);
                    float last_y1 = last_y + (inflexionWidth / 2) / distance * (y - last_y);
                    float x1 = x - (inflexionWidth / 2);
                    float y1 = y - (inflexionWidth / 2) / distance * (y - last_y);
                    
                    [progrssLinePaths addObject:@{@"from" : [NSValue valueWithCGPoint:CGPointMake(last_x1, last_y1)],
                                                  @"to" : [NSValue valueWithCGPoint:CGPointMake(x1, y1)]}];
                }
            }
            // Triangle point
            else if (chartData.inflexionPointStyle == PNLineChartPointStyleTriangle) {
                
                CGRect squareRect = CGRectMake(x - inflexionWidth / 2, y - inflexionWidth / 2, inflexionWidth, inflexionWidth);
                
                CGPoint startPoint = CGPointMake(squareRect.origin.x, squareRect.origin.y + squareRect.size.height);
                CGPoint endPoint = CGPointMake(squareRect.origin.x + (squareRect.size.width / 2), squareRect.origin.y);
                CGPoint middlePoint = CGPointMake(squareRect.origin.x + (squareRect.size.width), squareRect.origin.y + squareRect.size.height);
                
                [pointPath moveToPoint:startPoint];
                [pointPath addLineToPoint:middlePoint];
                [pointPath addLineToPoint:endPoint];
                [pointPath closePath];
                
                // text display text
                if (chartData.showPointLabel) {
                    [gradePathArray addObject:[self createPointLabelFor:chartData.getData(i).rawY pointCenter:middlePoint width:inflexionWidth withChartData:chartData]];
                }
                
                if (i > 0) {
                    // calculate the point for triangle
                    float distance = sqrt(pow(x - last_x, 2) + pow(y - last_y, 2)) * 1.4;
                    float last_x1 = last_x + (inflexionWidth / 2) / distance * (x - last_x);
                    float last_y1 = last_y + (inflexionWidth / 2) / distance * (y - last_y);
                    float x1 = x - (inflexionWidth / 2) / distance * (x - last_x);
                    float y1 = y - (inflexionWidth / 2) / distance * (y - last_y);
                    
                    [progrssLinePaths addObject:@{@"from" : [NSValue valueWithCGPoint:CGPointMake(last_x1, last_y1)],
                                                  @"to" : [NSValue valueWithCGPoint:CGPointMake(x1, y1)]}];
                }
            } else {
                
                if (i > 0) {
                    [progrssLinePaths addObject:@{@"from" : [NSValue valueWithCGPoint:CGPointMake(last_x, last_y)],
                                                  @"to" : [NSValue valueWithCGPoint:CGPointMake(x, y)]}];
                }
            }
            [linePointsArray addObject:[NSValue valueWithCGPoint:CGPointMake(x, y)]];
            last_x = x;
            last_y = y;
        }
        
        if (self.showSmoothLines && chartData.itemCount >= 4) {
            [progressline moveToPoint:[progrssLinePaths[0][@"from"] CGPointValue]];
            for (NSDictionary<NSString *, NSValue *> *item in progrssLinePaths) {
                CGPoint p1 = [item[@"from"] CGPointValue];
                CGPoint p2 = [item[@"to"] CGPointValue];
                [progressline moveToPoint:p1];
                CGPoint midPoint = [PNLineChart midPointBetweenPoint1:p1 andPoint2:p2];
                [progressline addQuadCurveToPoint:midPoint
                                     controlPoint:[PNLineChart controlPointBetweenPoint1:midPoint andPoint2:p1]];
                [progressline addQuadCurveToPoint:p2
                                     controlPoint:[PNLineChart controlPointBetweenPoint1:midPoint andPoint2:p2]];
            }
        } else {
            for (NSDictionary<NSString *, NSValue *> *item in progrssLinePaths) {
                if (item[@"from"]) {
                    [progressline moveToPoint:[item[@"from"] CGPointValue]];
                    [lineStartEndPointsArray addObject:item[@"from"]];
                }
                if (item[@"to"]) {
                    [progressline addLineToPoint:[item[@"to"] CGPointValue]];
                    [lineStartEndPointsArray addObject:item[@"to"]];
                }
            }
        }
        [pathPoints addObject:[linePointsArray copy]];
        [pointsOfPath addObject:[lineStartEndPointsArray copy]];
    }
}

- (void)prepareYLabelsWithData:(NSArray *)data {
    CGFloat yMax = 0.0f;
    CGFloat yMin = MAXFLOAT;
    NSMutableArray *yLabelsArray = [NSMutableArray new];
    
    for (PNLineChartData *chartData in data) {
        // create as many chart line layers as there are data-lines
        
        for (NSUInteger i = 0; i < chartData.itemCount; i++) {
            CGFloat yValue = chartData.getData(i).y;
            [yLabelsArray addObject:[NSString stringWithFormat:@"%2f", yValue]];
            yMax = fmaxf(yMax, yValue);
            yMin = fminf(yMin, yValue);
        }
    }
    
    
    // Min value for Y label
    if (yMax < 5) {
        yMax = 5.0f;
    }
    
    self.yValueMin = (self.yFixedValueMin > -FLT_MAX) ? self.yFixedValueMin : yMin;
    self.yValueMax = (self.yFixedValueMax > -FLT_MAX) ? self.yFixedValueMax : yMax + yMax / 10.0;
    
    if (self.showGenYLabels) {
        [self setYLabels];
    }
    
}

- (void)setYLabels {
    CGFloat yStep = (self.yValueMax - self.yValueMin) / self.yLabelNum;
    CGFloat yStepHeight = self.chartCavanHeight / self.yLabelNum;
    
    if (self.yChartLabels) {
        for (PNChartLabel *label in self.yChartLabels) {
            [label removeFromSuperview];
        }
    } else {
        self.yChartLabels = [NSMutableArray new];
    }
    
    if (yStep == 0.0) {
        PNChartLabel *minLabel = [[PNChartLabel alloc] initWithFrame:CGRectMake(0.0, (NSInteger) self.chartCavanHeight, (NSInteger) self.chartMarginBottom, (NSInteger) self.yLabelHeight)];
        minLabel.text = [self formatYLabel:0.0];
        [self setCustomStyleForYLabel:minLabel];
        [self addSubview:minLabel];
        [self.yChartLabels addObject:minLabel];
        
        PNChartLabel *midLabel = [[PNChartLabel alloc] initWithFrame:CGRectMake(0.0, (NSInteger) (self.chartCavanHeight / 2), (NSInteger) self.chartMarginBottom, (NSInteger) self.yLabelHeight)];
        midLabel.text = [self formatYLabel:self.yValueMax];
        [self setCustomStyleForYLabel:midLabel];
        [self addSubview:midLabel];
        [self.yChartLabels addObject:midLabel];
        
        PNChartLabel *maxLabel = [[PNChartLabel alloc] initWithFrame:CGRectMake(0.0, 0.0, (NSInteger) self.chartMarginBottom, (NSInteger) self.yLabelHeight)];
        maxLabel.text = [self formatYLabel:self.yValueMax * 2];
        [self setCustomStyleForYLabel:maxLabel];
        [self addSubview:maxLabel];
        [self.yChartLabels addObject:maxLabel];
        
    } else {
        NSInteger index = 0;
        NSInteger num = self.yLabelNum + 1;
        
        while (num > 0) {
            PNChartLabel *label = [[PNChartLabel alloc] initWithFrame:CGRectMake(0.0, (NSInteger) (self.chartCavanHeight - index * yStepHeight), (NSInteger) self.chartMarginBottom, (NSInteger) self.yLabelHeight)];
            [label setTextAlignment:NSTextAlignmentRight];
            label.text = [self formatYLabel:self.yValueMin + (yStep * index)];
            [self setCustomStyleForYLabel:label];
            [self addSubview:label];
            [self.yChartLabels addObject:label];
            index += 1;
            num -= 1;
        }
    }
}
- (void)setCustomStyleForYLabel:(UILabel *)label {
    if (self.yLabelFont) {
        label.font = self.yLabelFont;
    }
    
    if (self.yLabelColor) {
        label.textColor = self.yLabelColor;
    }
}
- (NSString *)formatYLabel:(double)value {
    
    if (self.yLabelBlockFormatter) {
        return self.yLabelBlockFormatter(value);
    }
    else {
        if (!self.thousandsSeparator) {
            NSString *format = self.yLabelFormat ?: @"%1.f";
            return [NSString stringWithFormat:format, value];
        }
        
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
        [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        return [numberFormatter stringFromNumber:[NSNumber numberWithDouble:value]];
    }
}
#pragma mark - Update Chart Data

- (void)updateChartData:(NSArray *)data {
    self.chartData = data;
    
    [self prepareYLabelsWithData:data];
    
    [self calculateChartPath:_chartPath andPointsPath:_pointPath andPathKeyPoints:self.pathPoints andPathStartEndPoints:_endPointsOfPath];
    
    for (NSUInteger lineIndex = 0; lineIndex < self.chartData.count; lineIndex++) {
        
        CAShapeLayer *chartLine = (CAShapeLayer *) self.chartLineArray[lineIndex];
        CAShapeLayer *pointLayer = (CAShapeLayer *) self.chartPointArray[lineIndex];
        
        
        UIBezierPath *progressline = [_chartPath objectAtIndex:lineIndex];
        UIBezierPath *pointPath = [_pointPath objectAtIndex:lineIndex];
        
        
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
        pathAnimation.fromValue = (id) chartLine.path;
        pathAnimation.toValue = (id) [progressline CGPath];
        pathAnimation.duration = 0.5f;
        pathAnimation.autoreverses = NO;
        pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [chartLine addAnimation:pathAnimation forKey:@"animationKey"];
        
        
        CABasicAnimation *pointPathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
        pointPathAnimation.fromValue = (id) pointLayer.path;
        pointPathAnimation.toValue = (id) [pointPath CGPath];
        pointPathAnimation.duration = 0.5f;
        pointPathAnimation.autoreverses = NO;
        pointPathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [pointLayer addAnimation:pointPathAnimation forKey:@"animationKey"];
        
        chartLine.path = progressline.CGPath;
        pointLayer.path = pointPath.CGPath;
        
        
    }
    
}
#pragma mark setter and getter

- (CATextLayer *)createPointLabelFor:(CGFloat)grade pointCenter:(CGPoint)pointCenter width:(CGFloat)width withChartData:(PNLineChartData *)chartData {
    CATextLayer *textLayer = [[CATextLayer alloc] init];
    [textLayer setAlignmentMode:kCAAlignmentCenter];
    [textLayer setForegroundColor:[chartData.pointLabelColor CGColor]];
    [textLayer setBackgroundColor:[[[UIColor whiteColor] colorWithAlphaComponent:0.8] CGColor]];
    [textLayer setCornerRadius:textLayer.fontSize / 8.0];
    
    if (chartData.pointLabelFont != nil) {
        [textLayer setFont:(__bridge CFTypeRef) (chartData.pointLabelFont)];
        textLayer.fontSize = [chartData.pointLabelFont pointSize];
    }
    
    CGFloat textHeight = textLayer.fontSize * 1.1;
    CGFloat textWidth = width * 8;
    CGFloat textStartPosY;
    
    textStartPosY = pointCenter.y - textLayer.fontSize;
    
    [self.layer addSublayer:textLayer];
    
    if (chartData.pointLabelFormat != nil) {
        [textLayer setString:[[NSString alloc] initWithFormat:chartData.pointLabelFormat, grade]];
    } else {
        [textLayer setString:[[NSString alloc] initWithFormat:self.yLabelFormat, grade]];
    }
    
    [textLayer setFrame:CGRectMake(0, 0, textWidth, textHeight)];
    [textLayer setPosition:CGPointMake(pointCenter.x, textStartPosY)];
    textLayer.contentsScale = [UIScreen mainScreen].scale;
    
    return textLayer;
}

- (CABasicAnimation *)fadeAnimation {
    CABasicAnimation *fadeAnimation = nil;
    if (self.displayAnimated) {
        fadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        fadeAnimation.fromValue = [NSNumber numberWithFloat:0.0];
        fadeAnimation.toValue = [NSNumber numberWithFloat:1.0];
        fadeAnimation.duration = 2.0;
    }
    return fadeAnimation;
}

- (CABasicAnimation *)pathAnimation {
    if (self.displayAnimated && !_pathAnimation) {
        _pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        _pathAnimation.duration = 1.0;
        _pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        _pathAnimation.fromValue = @0.0f;
        _pathAnimation.toValue = @1.0f;
    }
    return _pathAnimation;
}



#pragma mark - Touch at point

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchPoint:touches withEvent:event];
    [self touchKeyPoint:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchPoint:touches withEvent:event];
    [self touchKeyPoint:touches withEvent:event];
}

- (void)touchPoint:(NSSet *)touches withEvent:(UIEvent *)event {
    // Get the point user touched
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    
    for (NSInteger p = self.pathPoints.count - 1; p >= 0; p--) {
        NSArray *linePointsArray = _endPointsOfPath[p];
        
        for (int i = 0; i < (int) linePointsArray.count - 1; i += 2) {
            CGPoint p1 = [linePointsArray[i] CGPointValue];
            CGPoint p2 = [linePointsArray[i + 1] CGPointValue];
            
            // Closest distance from point to line
            float distance = fabs(((p2.x - p1.x) * (touchPoint.y - p1.y)) - ((p1.x - touchPoint.x) * (p1.y - p2.y)));
            distance /= hypot(p2.x - p1.x, p1.y - p2.y);
            
            if (distance <= 5.0) {
                // Conform to delegate parameters, figure out what bezier path this CGPoint belongs to.
                for (UIBezierPath *path in _chartPath) {
                    BOOL pointContainsPath = CGPathContainsPoint(path.CGPath, NULL, p1, NO);
                    
                    if (pointContainsPath) {
                        [self.delegate userClickedOnLinePoint:touchPoint lineIndex:[_chartPath indexOfObject:path]];
                        
                        return;
                    }
                }
            }
        }
    }
}

- (void)touchKeyPoint:(NSSet *)touches withEvent:(UIEvent *)event {
    // Get the point user touched
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    
    for (NSInteger p = self.pathPoints.count - 1; p >= 0; p--) {
        NSArray *linePointsArray = self.pathPoints[p];
        
        for (int i = 0; i < (int) linePointsArray.count - 1; i += 1) {
            CGPoint p1 = [linePointsArray[i] CGPointValue];
            CGPoint p2 = [linePointsArray[i + 1] CGPointValue];
            
            float distanceToP1 = fabs(hypot(touchPoint.x - p1.x, touchPoint.y - p1.y));
            float distanceToP2 = hypot(touchPoint.x - p2.x, touchPoint.y - p2.y);
            
            float distance = MIN(distanceToP1, distanceToP2);
            
            if (distance <= 10.0) {
                [self.delegate userClickedOnLineKeyPoint:touchPoint
                                           lineIndex:p
                                          pointIndex:(distance == distanceToP2 ? i + 1 : i)];
                
                return;
            }
        }
    }
}
@end
