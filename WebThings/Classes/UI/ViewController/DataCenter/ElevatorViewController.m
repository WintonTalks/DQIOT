//
//  ElevatorViewController.m
//  WebThings
//
//  Created by machinsight on 2017/7/10.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "ElevatorViewController.h"
#import "CKLineChart.h"
#import "EMICardView.h"

@interface ElevatorViewController ()<PNChartDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scV;

/**
 载重量
 */
@property (weak, nonatomic) IBOutlet UILabel *zzlLab;

/**
 超载
 */
@property (weak, nonatomic) IBOutlet UILabel *czLab;

/**
 超载量
 */
@property (weak, nonatomic) IBOutlet UILabel *czlLab;
@property (weak, nonatomic) IBOutlet UIView *chartFatherV;
@property (nonatomic,strong) CKLineChart *lineChart;

/**
 上极限
 */
@property (weak, nonatomic) IBOutlet UILabel *sjxLab;

/**
 下极限
 */
@property (weak, nonatomic) IBOutlet UILabel *xjxLab;

/**
 上行超速
 */
@property (weak, nonatomic) IBOutlet UILabel *sxcsLab;

/**
 下行超速
 */
@property (weak, nonatomic) IBOutlet UILabel *xxcsLab;

/**
 严重超速
 */
@property (weak, nonatomic) IBOutlet UILabel *yzcsLab;

/**
 电机过热
 */
@property (weak, nonatomic) IBOutlet UILabel *djgrLab;

@property (weak, nonatomic) IBOutlet EMICardView *alertV;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *countLab;

@property (nonatomic,strong) NSMutableArray *xLabArr;
@property (nonatomic,strong) NSMutableArray *pointLabArr;

@end

@implementation ElevatorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initView];
}

- (void)initView{
//    self.view.frame = CGRectMake(0, 0, 358, 370);
    [AppDelegate storyBoradAutoLay:self.view];
    _scV.frame = CGRectMake(0, 0, screenWidth, screenHeight - 68 - 45);
    _scV.contentSize = CGSizeMake(screenWidth, 625);
    
    [self WithLab:_sjxLab];
    [self WithLab:_xjxLab];
    [self WithLab:_sxcsLab];
    [self WithLab:_xxcsLab];
    [self WithLab:_yzcsLab];
    [self WithLab:_djgrLab];
    
    [self lineChart];
}

- (PNLineChart *)lineChart{
    if (!_lineChart) {
        
        self.lineChart = [[CKLineChart alloc] initWithFrame:self.chartFatherV.bounds];
        
        self.lineChart.backgroundColor = [UIColor colorWithHexString:@"#F8F9FA"];
        self.lineChart.yGridLinesColor = [UIColor colorWithHexString:@"#E5E5E5"];
        [self.lineChart.chartData enumerateObjectsUsingBlock:^(PNLineChartData *obj, NSUInteger idx, BOOL *stop) {
            obj.pointLabelColor = [UIColor colorWithHexString:@"#BEBFC0"];
        }];
        
        self.lineChart.showCoordinateAxis = NO;//是否显示坐标轴
        self.lineChart.yLabelFormat = @"%1.0f";
        self.lineChart.xLabelFont = [UIFont fontWithName:@"Helvetica-Light" size:8.0];
//        self.lineChart.chartMarginLeft = 0;
        _xLabArr = [NSMutableArray arrayWithArray:@[@"启动升降机系统", @"上行操作杆拨动", @"下行操作杆拨动", @"按内/外急停按键"]];
        [self.lineChart setXLabels:_xLabArr withWidth:self.chartFatherV.frame.size.width/4];
        self.lineChart.yLabelColor = [UIColor colorWithHexString:@"#BEBFC0"];
        self.lineChart.xLabelColor = [UIColor colorWithHexString:@"#BEBFC0"];
        
        self.lineChart.axisColor = [UIColor colorWithHexString:@"#BEBFC0"];//坐标轴颜色
        // added an example to show how yGridLines can be enabled
        // the color is set to clearColor so that the demo remains the same
        self.lineChart.showGenYLabels = NO;
        self.lineChart.showYGridLines = YES;
        
        //Use yFixedValueMax and yFixedValueMin to Fix the Max and Min Y Value
        //Only if you needed
        self.lineChart.yFixedValueMax = 25;
        self.lineChart.yFixedValueMin = 0;
        
        [self.lineChart setYLabels:@[
                                     @"0",
                                     @"5",
                                     @"10",
                                     @"15",
                                     @"20",
                                     @"25"
                                     ]
         ];
        
        self.lineChart.delegate = self;
        
        [self.chartFatherV addSubview:self.lineChart];
        
        self.lineChart.legendStyle = PNLegendItemStyleStacked;
        self.lineChart.legendFont = [UIFont boldSystemFontOfSize:12.0f];
        self.lineChart.legendFontColor = [UIColor redColor];
        
//        UIView *legend = [self.lineChart getLegendWithMaxWidth:320];
//        [legend setFrame:CGRectMake(30, 340, legend.frame.size.width, legend.frame.size.width)];
//        [self.chartFatherV addSubview:legend];
        
    }
    return _lineChart;
}

/**
 * Callback method that gets invoked when the user taps on the chart line.
 */
- (void)userClickedOnLinePoint:(CGPoint)point lineIndex:(NSInteger)lineIndex{
    
}
/**
 * Callback method that gets invoked when the user taps on a chart line key point.
 */
- (void)userClickedOnLineKeyPoint:(CGPoint)point
                        lineIndex:(NSInteger)lineIndex
                       pointIndex:(NSInteger)pointIndex{
    [self setalertWithIndex:pointIndex value:_pointLabArr[pointIndex]];
}

- (NSAttributedString *)WithLab:(UILabel *)lab{
    NSString *text = lab.text;
    NSMutableAttributedString *aString = [[NSMutableAttributedString alloc]initWithString:text];
    
    NSString *HH = @"次";
    
    
    NSRange range1 = [text rangeOfString:HH];
    

    
    [aString addAttribute:NSForegroundColorAttributeName value:lab.textColor range:NSMakeRange(0, range1.location)];
    [aString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"DroidSans-Bold" size:25.f]range:NSMakeRange(0, range1.location)];
    //H
    [aString addAttribute:NSForegroundColorAttributeName value:lab.textColor range:range1];
    [aString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"DroidSans-Bold" size:12.f]range:range1];
    
    
    lab.attributedText = aString;
    return aString;
}


/**
 设置弹出框

 @param index 第几个
 @param value 值
 */
- (void)setalertWithIndex:(NSInteger)index value:(id)value{
    [self.chartFatherV bringSubviewToFront:_alertV];
    _titleLab.text = _xLabArr[index];
    _countLab.text = [NSString stringWithFormat:@"%ld次",[value longValue]];
    [self WithLab:_countLab];
    _alertV.hidden = NO;
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3/*延迟执行时间*/ * NSEC_PER_SEC));
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        self.alertV.hidden = YES;
    });
}


- (void)setViewValuesWithModel:(DataCenterModel *)model{
    _zzlLab.text = [NSString stringWithFormat:@"载重量：%@KG",model.nld  == nil ? @"0":model.nld];
    _czLab.text = [NSString stringWithFormat:@"超载：%@次",model.olt  == nil ? @"0":model.olt];
    _czlLab.text = [NSString stringWithFormat:@"超载量：%@KG",model.olw  == nil ? @"0":model.olw];
    
    
    // Line Chart #2
    NSArray *data02Array = @[@0, @([model.utt integerValue]), @([model.dtt integerValue]), @([model.est integerValue])];
    _pointLabArr = [NSMutableArray arrayWithArray:data02Array];
    PNLineChartData *data02 = [PNLineChartData new];
    data02.dataTitle = @"Beta";
    data02.pointLabelColor = [UIColor colorWithHexString:@"#BEBFC0"];
    data02.color = [UIColor colorWithHexString:@"#0077FF"];
    data02.alpha = 0.5f;
    data02.itemCount = data02Array.count;
    data02.inflexionPointStyle = PNLineChartPointStyleCircle;
    data02.getData = ^(NSUInteger index) {
        CGFloat yValue = [data02Array[index] floatValue];
        return [PNLineChartDataItem dataItemWithY:yValue];
    };
    
    self.lineChart.chartData = @[data02];
    [self.lineChart.chartData enumerateObjectsUsingBlock:^(PNLineChartData *obj, NSUInteger idx, BOOL *stop) {
        obj.pointLabelColor = [UIColor colorWithHexString:@"#BEBFC0"];
    }];
    
    [self.lineChart strokeChart];
    
    _sjxLab.text = [NSString stringWithFormat:@"%@次",model.ult  == nil ? @"0":model.ult];
    [self WithLab:_sjxLab];
    _xjxLab.text = [NSString stringWithFormat:@"%@次",model.dlt  == nil ? @"0":model.dlt];
    [self WithLab:_xjxLab];
    _sxcsLab.text = @"0次";
    [self WithLab:_sxcsLab];
    _xxcsLab.text = @"0次";
    [self WithLab:_xxcsLab];
    _yzcsLab.text = [NSString stringWithFormat:@"%@次",model.uel  == nil ? @"0":model.uel];
    [self WithLab:_yzcsLab];
    _djgrLab.text = [NSString stringWithFormat:@"%@次",model.ovh  == nil ? @"0":model.ovh];
    [self WithLab:_djgrLab];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
