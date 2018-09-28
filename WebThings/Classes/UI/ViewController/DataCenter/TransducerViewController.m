//
//  TransducerViewController.m
//  WebThings
//
//  Created by machinsight on 2017/7/7.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "TransducerViewController.h"

@interface TransducerViewController ()

/**
 变频器型号
 */
@property (weak, nonatomic) IBOutlet UILabel *bpqxhLab;

/**
 工作频率
 */
@property (weak, nonatomic) IBOutlet UILabel *gzplLab;

/**
 输出功率
 */
@property (weak, nonatomic) IBOutlet UILabel *scglLab;

/**
 运行速度
 */
@property (weak, nonatomic) IBOutlet UILabel *yxsdLab;

/**
 输出电流
 */
@property (weak, nonatomic) IBOutlet UILabel *scdlLab;



/**
 输出电压
 */
@property (weak, nonatomic) IBOutlet UILabel *scdyLb;
/**
 工频模式
 */
@property (weak, nonatomic) IBOutlet UILabel *gpLab;
@property (weak, nonatomic) IBOutlet UIImageView *gpArrow;

/**
 变频模式
 */
@property (weak, nonatomic) IBOutlet UILabel *bpLab;
@property (weak, nonatomic) IBOutlet UIImageView *bpArrow;
@end

@implementation TransducerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.frame = CGRectMake(0, 0, 358, screenHeight - 68);
//    [AppDelegate storyBoradAutoLay:self.view];
    
    [ChangeAnchorPoint setAnchorPoint:CGPointMake(0.5, 1) forView:_gpArrow];
    [ChangeAnchorPoint setAnchorPoint:CGPointMake(0.5, 1) forView:_bpArrow];
    [self xzWithI:0 andView:_gpArrow];
    [self xzWithI:0 andView:_bpArrow];
    
    [self WithLab:_gpLab];
    [self WithLab:_bpLab];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma 旋转
- (void)xzWithI:(double)i andView:(UIImageView *)imgV{
    
    //算法
    CGFloat angle = 0;
    CGFloat base = 0.125*M_PI;
    if (i <= 6) {
        angle = -base*(6-i);
    }else{
        angle = base*(i-6);
    }
    
    imgV.transform = CGAffineTransformMakeRotation(angle);//一格，0.125*M_PI
}


- (NSAttributedString *)WithLab:(UILabel *)lab{
    NSString *text = lab.text;
    NSMutableAttributedString *aString = [[NSMutableAttributedString alloc]initWithString:text];
    
    NSString *HH = @"H";
    
    NSString *MM = @"M";
    
    NSString *SS = @"S";
    
    NSRange range1 = [text rangeOfString:HH];
    if (range1.length == 0) {
        return aString;
    }
    NSRange range2 = [text rangeOfString:MM];
    
    NSRange range3 = [text rangeOfString:SS];
    
    [aString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor]range:NSMakeRange(0, range1.location)];
    [aString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"DroidSans-Bold" size:20.f]range:NSMakeRange(0, range1.location)];
    //H
    [aString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor]range:range1];
    [aString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"DroidSansFallback" size:9.f]range:range1];
    
    
    [aString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor]range:NSMakeRange(range1.location+range1.length,range2.location-range1.length-range1.location)];
    [aString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"DroidSans-Bold" size:20.f]range:NSMakeRange(range1.location+range1.length,range2.location-range1.length-range1.location)];
    //M
    [aString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor]range:range2];
    [aString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"DroidSansFallback" size:9.f]range:range2];
    
    
    [aString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor]range:NSMakeRange(range2.location+range2.length,range3.location-range2.length-range2.location)];
    [aString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"DroidSans-Bold" size:20.f]range:NSMakeRange(range2.location+range2.length,range3.location-range2.length-range2.location)];
    //S
    [aString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor]range:range3];
    [aString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"DroidSansFallback" size:9.f]range:range3];
    
    lab.attributedText = aString;
    return aString;
    
}

- (void)setViewValuesWithModel:(DataCenterModel *)model{
    _bpqxhLab.text = appendUrl(@"变频器型号：", model.tdm == nil ? @"0":model.tdm);
    _gzplLab.text = [NSString stringWithFormat:@"工作频率：%@HZ",model.frp == nil ? @"0":model.frp];
    _scglLab.text = [NSString stringWithFormat:@"输出功率：%@W",model.pow  == nil ? @"0":model.pow];
    _yxsdLab.text = [NSString stringWithFormat:@"运行速度：%@M/S",model.spd  == nil ? @"0":model.spd];
    _scdyLb.text = [NSString stringWithFormat:@"输出电压：%@V",model.vol  == nil ? @"0":model.vol];
    _scdlLab.text = [NSString stringWithFormat:@"输出电流：%@A",model.cur  == nil ? @"0":model.cur];
    
    if (!model.cmt) {
        model.cmt = @"00:00:00";
    }
    _gpLab.text = [TransducerViewController getHMS:model.cmt];
    [self xzWithI:[TransducerViewController getAngle:model.cmt] andView:_gpArrow];
    [self WithLab:_gpLab];
    
    if (!model.pmt) {
        model.pmt = @"00:00:00";
    }
    _bpLab.text = [TransducerViewController getHMS:model.pmt];
    [self xzWithI:[TransducerViewController getAngle:model.pmt] andView:_bpArrow];
    [self WithLab:_bpLab];
}

+ (NSString *)getHMS:(NSString *)str{
   NSArray *a = [str componentsSeparatedByString:@":"];
    NSString *last = @"";
    if (a.count == 3) {
        last = [NSString stringWithFormat:@"%@H%@M%@S",a[0],a[1],a[2]];
    }
    return last;
}

+ (double)getAngle:(NSString *)str{
    NSArray *a = [str componentsSeparatedByString:@":"];
    double last = 0.00;
    if (a.count == 3) {
        last = [a[0] doubleValue] + [a[1] doubleValue]/60 + [a[2] doubleValue]/3600;
    }
    return last;
}

@end
