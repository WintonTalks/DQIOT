//
//  MapViewController.m
//  WebThings
//
//  Created by machinsight on 2017/7/10.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "MapViewController.h"
#import "TransducerViewController.h"
#import "MDCShadowLayer.h"

#import "DQAnnotationView.h"

#import "DQLocationManager.h"

@interface MapViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate>

@property (nonatomic, strong) DataCenterModel *data;

@end

@implementation MapViewController

#pragma mark - Init
- (void)initSubviews {
    
    CGRect rect = self.view.frame;
    CGFloat height = rect.size.height - 45;
    CGFloat width = rect.size.width;
    
    // 地图
    _mapV = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, width, height - self.navigationBarHeight)];
    _mapV.zoomLevel = 15;
    _mapV.delegate = self;
    [self.view addSubview:_mapV];

    // 底部白色层
    UIView *stateView = [[UIView alloc] initWithFrame:
                         CGRectMake(10, height - 65 - self.navigationBarHeight, width - 20, 55)];
    stateView.backgroundColor = [UIColor whiteColor];
    stateView.layer.cornerRadius = 2.0;
    stateView.layer.masksToBounds = NO;
    stateView.layer.shadowRadius = 3.0;
    stateView.layer.shadowOpacity = 0.5;
    stateView.layer.shadowOffset = CGSizeMake(0, 2);
    stateView.layer.shadowColor = [UIColor blackColor].CGColor;
    [self.view addSubview:stateView];
    
    UIImageView *iconTime = [[UIImageView alloc] initWithFrame:CGRectMake(15, 55/2.0 - 14, 28, 28)];
    iconTime.image = [UIImage imageNamed:@"data_ic_time"];
    [stateView addSubview:iconTime];
    
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 11, width - 60, 12)];
    tipsLabel.font = [UIFont systemFontOfSize:10];
    tipsLabel.textColor = [UIColor grayColor];
    tipsLabel.text = @"累计工作时间";
    [stateView addSubview:tipsLabel];
    
    _ljTimeLab = [[UILabel alloc] initWithFrame:CGRectMake(50, 23, width - 60, 22)];
    _ljTimeLab.font = [UIFont boldSystemFontOfSize:20];
    _ljTimeLab.text = @"00H00M00S";
    _ljTimeLab.textColor = [UIColor colorWithHexString:COLOR_BLACK];
    [stateView addSubview:_ljTimeLab];
    
    UIButton *btnLocation = [UIButton buttonWithType:UIButtonTypeCustom];
    btnLocation.frame = CGRectMake(16, stateView.frame.origin.y - 80, 40, 40);
    [btnLocation setBackgroundImage:[UIImage imageNamed:@"icon_location"] forState:UIControlStateNormal];
    [btnLocation setBackgroundImage:[UIImage imageNamed:@"icon_location_sel"] forState:UIControlStateHighlighted];
    [btnLocation addTarget:self action:@selector(onDevicePositionClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnLocation];
}

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];

    _geocodesearch = [[BMKGeoCodeSearch alloc]init];
    _geocodesearch.delegate = self;

    [self initSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    _mapV.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    _mapV.delegate = nil;
}

#pragma mark - Button clicks
// 定位按钮，显示机器位置定位
- (void)onDevicePositionClick {
    NSArray *latArr = [_data.lat componentsSeparatedByString:@","];
    NSArray *lgtArr = [_data.lgt componentsSeparatedByString:@","];
    CLLocationCoordinate2D deviceLocation = CLLocationCoordinate2DMake([latArr[0] doubleValue], [lgtArr[0] doubleValue]);

    [_mapV setCenterCoordinate:deviceLocation];
}

#pragma BMKMapViewDelegate
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation {
    /*
     if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
     NSString *AnnotationViewID = @"DQMapAnnotation";
     DQAnnotationView *annotationView = (DQAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
     if (annotationView == nil) {
     annotationView = [[DQAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
     }
     annotationView.image = [UIImage imageNamed:@"data_ic_position"];
     return annotationView;
     }
     */
    BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"DQMapAnnotation"];
    newAnnotationView.animatesDrop = YES;//设置该标点动画显示
    newAnnotationView.annotation = annotation;
    newAnnotationView.image = [UIImage imageNamed:@"data_ic_position"];
    newAnnotationView.size = CGSizeMake(35, 35);
    newAnnotationView.canShowCallout = YES;
    newAnnotationView.selected = YES;
    return newAnnotationView;

//    return nil;
}

//
- (void)addAnnotationWithLocation:(CLLocationCoordinate2D)location {
    
    
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc] init];
    reverseGeocodeSearchOption.reverseGeoPoint = CLLocationCoordinate2DMake(location.latitude, location.longitude);
    BOOL flag = [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    if(flag)
    {
        DQLog(@"反geo检索发送成功");
    }
    else
    {
        DQLog(@"反geo检索发送失败");
    }
}

- (NSAttributedString *)WithLab:(UILabel *)lab{
    NSString *text = lab.text;
    NSMutableAttributedString *aString = [[NSMutableAttributedString alloc]initWithString:text];

    if (text.length > 0) {
        
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

    }
    return aString;
}

- (void)setViewValuesWithModel:(DataCenterModel *)model{
    self.data = model;
    
    if (!model.ont) {
        model.ont = @"00:00:00";
    }
    _ljTimeLab.text = [TransducerViewController getHMS:model.ont];
    [self WithLab:_ljTimeLab];
    
    if (model.lat && model.lgt) {
        // 大头针1
        NSArray *latArr = [model.lat componentsSeparatedByString:@","];
        NSArray *lgtArr = [model.lgt componentsSeparatedByString:@","];
        CLLocationCoordinate2D location1 = CLLocationCoordinate2DMake([latArr[0] doubleValue], [lgtArr[0] doubleValue]);
        //百度地图
        [self addAnnotationWithLocation:location1];
    }else{
        //初始化BMKLocationService
        if (!_locService) {
            _locService = [[BMKLocationService alloc]init];
            _locService.delegate = self;
        }
        //启动LocationService
        [_locService startUserLocationService];
    }
}

- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher
                           result:(BMKReverseGeoCodeResult *)result
                        errorCode:(BMKSearchErrorCode)error
{
    if (error == 0) {
        NSArray *latArr = [_data.lat componentsSeparatedByString:@","];
        NSArray *lgtArr = [_data.lgt componentsSeparatedByString:@","];
        CLLocationCoordinate2D deviceLocation = CLLocationCoordinate2DMake([latArr[0] doubleValue], [lgtArr[0] doubleValue]);

        [_mapV setCenterCoordinate:deviceLocation];
        
        NSString *address = result.address;
        BMKPointAnnotation *annotation1 = [[BMKPointAnnotation alloc]init];
        annotation1.coordinate = deviceLocation;
        annotation1.title = address;
        [_mapV addAnnotation:annotation1];
    }
}

#pragma BMKLocationServicedelegate
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    //NSLog(@"heading is %@",userLocation.heading);
    
}

//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
//    [self addAnnotationWithLocation:userLocation.location.coordinate];
//    //获取到后停止定位
//    [_locService stopUserLocationService];
}

@end
