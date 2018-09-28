//
//  DQPopupListView.m
//   
//
//  Created by Eugene on 10/18/17.
//  Copyright © 2017 Eugene. All rights reserved.
//

#import "DQPopupListView.h"

@interface DQPopupListView ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSArray *dataSource; //城市的数组

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView *backgroundView;

@end

@implementation DQPopupListView

static DQPopupListView *manager = nil;

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[DQPopupListView alloc] init];
    });
    return manager;
}

- (instancetype)init {
    
    self = [super init];
    if (self) {
        [self initPageView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self initPageView];
    }
    return self;
}


- (void)showPopListWithDataSource:(NSArray <NSString *>*)ary {
    
    [self initPageView];
    [self showAnimation];

    _dataSource = ary;
    [self.tableView reloadData];
}

- (void)initPageView {
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    self.backgroundView.frame = CGRectMake(0, 0, screenSize.width, screenSize.height);
    self.backgroundView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.4];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellIdentifier"];
    [self.backgroundView addSubview:self.tableView];
    
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    [window addSubview:self.backgroundView];
    [window bringSubviewToFront:self.backgroundView];
    
    self.tableView.center = window.center;
    self.tableView.bounds = CGRectMake(10, 0, screenSize.width-20, (screenSize.width-20)*1.13);
    self.tableView.center = self.backgroundView.center;
}

- (void)dismiss {

    [self.tableView removeFromSuperview];
    [self.backgroundView removeFromSuperview];
    self.tableView = nil;
    self.backgroundView = nil;
}

#pragma mark - Animation
- (void)showAnimation {
    
    self.tableView.alpha = 0;
    [UIView animateWithDuration:0.2 animations:^{
        self.tableView.alpha = 1;
    } completion:^(BOOL finished) {
    }];
}

- (void)dismissAnimation {
    
    self.tableView.alpha = 1;
    [UIView animateWithDuration:0.2 animations:^{
        self.tableView.alpha = 0;
    } completion:^(BOOL finished) {
        [self dismiss];
    }];
}

    //添加手势
- (void)tapGesture:(UITapGestureRecognizer *)sender {
    [self dismissAnimation];
}

#pragma mark - Delegate And DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    cell.textLabel.font = [UIFont dq_regularSystemFontOfSize:14.0];
    cell.textLabel.text = _dataSource[indexPath.row];
    cell.textLabel.textColor = [UIColor colorWithHexString:@"#1D1D1D"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
    if (_didSelectBlock) {
      _didSelectBlock(_dataSource[indexPath.row]);
    }
    [self dismissAnimation];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

#pragma mark - UIGestureRecognizerDelegate
//防止手势冲突
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return  YES;
}

#pragma mark - Getter And Setter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.layer.cornerRadius = 8.0f;
    }
    return _tableView;
}

- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc]init];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
        tap.delegate = self;
        [_backgroundView addGestureRecognizer:tap];
    }
    return _backgroundView;
}

@end
