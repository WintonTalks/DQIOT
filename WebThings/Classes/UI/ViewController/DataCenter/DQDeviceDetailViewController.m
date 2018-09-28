//
//  DQDeviceDetailViewController.m
//  WebThings
//  设备详情
//  Created by Heidi on 2017/9/6.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "DQDeviceDetailViewController.h"
//#import "DQDeviceMapView.h"

#import "TransducerViewController.h"
#import "ElevatorViewController.h"
#import "MapViewController.h"

#import "DQDeviceInterface.h"

#import "GetWarnMonitorWI.h"
#import "AddProjectModel.h"
#import "DeviceTypeModel.h"

@interface DQDeviceDetailViewController ()
<UIScrollViewDelegate>
{
    UIScrollView *_bodyScroll;
    MapViewController *_mapCtl;
    TransducerViewController *_transducerCtl;
    ElevatorViewController *_elevatorCtl;
    NSMutableArray *_titleButtonArray;
    
    UIView *_animationView;
    
    BOOL _isBtnClick;       // 用来区别按钮点击和拖动
}

@end

@implementation DQDeviceDetailViewController

#pragma mark - Init
- (void)initSubviews {
    CGFloat width = screenWidth;
    CGFloat height = screenHeight - self.navigationBarHeight - 45;
    _bodyScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.navigationBarHeight + 45, width, height)];
    [_bodyScroll setContentSize:CGSizeMake(width * 3, height - 68)];
    _bodyScroll.bounces = NO;
    _bodyScroll.pagingEnabled = YES;
    _bodyScroll.showsVerticalScrollIndicator = NO;
    _bodyScroll.showsHorizontalScrollIndicator = NO;
    _bodyScroll.delegate = self;
    [self.view addSubview:_bodyScroll];
    
    _mapCtl = [[MapViewController alloc] init];
    _mapCtl.view.frame = CGRectMake(0, 0, width, height);
    [_bodyScroll addSubview:_mapCtl.view];

    _transducerCtl = [[TransducerViewController alloc]initWithNibName:@"TransducerViewController" bundle:nil];
    _transducerCtl.view.frame = CGRectMake(width, 0, width, height);
    [_bodyScroll addSubview:_transducerCtl.view];
    
    _elevatorCtl = [[ElevatorViewController alloc]initWithNibName:@"ElevatorViewController" bundle:nil];
    _elevatorCtl.view.frame = CGRectMake(width * 2, 0, width, height);
    [_bodyScroll addSubview:_elevatorCtl.view];
    
    NSArray *titles = @[@"设备信息", @"变频器", @"升降梯"];
    UIColor *blueColor = [UIColor colorWithHexString:COLOR_BLUE];
    for (int i = 0; i < 3; i ++) {
        UIColor *color = i == 0 ? blueColor : [UIColor colorWithHexString:COLOR_BLACK];

        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitleColor:color forState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
        button.frame = CGRectMake(width/3.0 * i, 68, width/3.0, 45);
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(onTabClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i + 1;
        [self.view addSubview:button];
        
        [_titleButtonArray addObject:button];
    }
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, _bodyScroll.frame.origin.y - 0.5, screenWidth, 0.5)];
    line.backgroundColor = [UIColor colorWithHexString:COLOR_LINE];
    [self.view addSubview:line];
    
    _animationView = [[UIView alloc] initWithFrame:CGRectMake(25, _bodyScroll.frame.origin.y - 2.0, width/3.0 - 50, 2.0)];
    _animationView.backgroundColor = blueColor;
    [self.view addSubview:_animationView];
}

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];

    [self initSubviews];
    //[EMINavigationController addAppBar:self];

    [self fetchDataWithId:_device.deviceid];
    self.title = _device.deviceno;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"DeviceDetail"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"DeviceDetail"];
}

#pragma mark - 
/// 获取设备运行信息
- (void)fetchDataWithId:(NSInteger)deviceid {
    GetWarnMonitorWI *lwi = [[GetWarnMonitorWI alloc] init];
    NSArray *arr = @[@(self.baseUser.userid),self.baseUser.type,@(deviceid),self.baseUser.usertype];
    NSDictionary *param = [lwi inBox:arr];
    [CKNetTools requestWithRequestType:POST WithURL:lwi.fullUrl WithParamater:param WithProgressBlock:^(NSProgress *process) {
        
    } WithSuccessBlock:^(id returnValue) {
        NSArray *temp = [lwi unBox:returnValue];
        if ([temp[0] integerValue] == 1) {
            DataCenterModel *model = temp[1];
            
            [_mapCtl setViewValuesWithModel:model];
            [_transducerCtl setViewValuesWithModel:model];
            [_elevatorCtl setViewValuesWithModel:model];
        }
        
    } WithFailureBlock:^(NSError *error) {
        
    }];
//    数据接口规范化之后再修改为新的请求
//    [[DQDeviceInterface sharedInstance]
//     dq_getWarningWithDeviceID:[NSString stringWithFormat:@"%ld", deviceid]
//     success:^(id result) {
//        
//         [_mapCtl setViewValuesWithModel:result];
//         [_transducerCtl setViewValuesWithModel:result];
//         [_elevatorCtl setViewValuesWithModel:result];
//
//     } failture:^(NSError *error) {
//         
//     }];
}

// 显示按钮颜色变化
- (void)showButtonAnimation:(NSInteger)index {
    
    UIButton *button = (UIButton *)[self.view viewWithTag:index + 1];
    for (int i = 0; i < 3; i ++) {
        if (i != index) {
            UIButton *btn = [button.superview viewWithTag:i + 1];
            [btn setTitleColor:[UIColor colorWithHexString:COLOR_BLACK] forState:UIControlStateNormal];
        }
    }
    
    [button setTitleColor:[UIColor colorWithHexString:COLOR_BLUE] forState:UIControlStateNormal];
}

// 指示条动画
- (void)beginViewAnimationWithIndex:(NSInteger)index completion:(void (^ __nullable)(BOOL finished))comp {

    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = _animationView.frame;
        rect.origin.x = _bodyScroll.frame.size.width/3.0 * index + 25;
        _animationView.frame = rect;
    } completion:^(BOOL finished) {
        comp(finished);
    }];
}

#pragma mark - Button clicks
// 点击Tab
- (void)onTabClick:(UIButton *)button {
    
    NSInteger index = button.tag - 1;

    [MobClick event:@"dc_detail_tab" label:[NSString stringWithFormat:@"%ld", index]];
    _isBtnClick = YES;
    
    [self showButtonAnimation:index];
    [self beginViewAnimationWithIndex:index completion:^(BOOL finished) {
        
    }];
    
    [_bodyScroll setContentOffset:CGPointMake(_bodyScroll.frame.size.width * index, 0) animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _isBtnClick = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;

    if (!_isBtnClick) {
        [self beginViewAnimationWithIndex:index completion:^(BOOL finished) {
            if (finished) {
                [self showButtonAnimation:index];
            }
        }];
    }
}

@end
