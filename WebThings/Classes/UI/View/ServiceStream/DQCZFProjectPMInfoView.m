//
//  DQCZFProjectPMInfoView.m
//  WebThings
//
//  Created by winton on 2017/10/30.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "DQCZFProjectPMInfoView.h"
#import "DQProjectPullCell.h"

@interface DQCZFProjectPMInfoView()
<UITableViewDelegate,
UITableViewDataSource,
DQProjectPullCellDelegate>
{
    UILabel *_titleLabel;
}
@property (nonatomic, strong) UITableView *pullTableView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) NSMutableArray *infoDataArray;
@property (nonatomic, assign) DQCZFProjectPMWithType pmType;
@property (nonatomic, strong) NSMutableArray *checkArray;
@end

@implementation DQCZFProjectPMInfoView

- (instancetype)initWithFrame:(CGRect)frame
                       pmType:(DQCZFProjectPMWithType)pmType
{
    self = [super initWithFrame:frame];
    if (self) {
        self.pmType = pmType;
        [self addThePullMangerView];
    }
    return self;
}

- (void)onInBtnClicked
{
    
    
    
}

#pragma mark -UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.infoDataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DQProjectPullCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProjectPullCellIdentifier"];
    if (!cell) {
        cell = [[DQProjectPullCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ProjectPullCellIdentifier"];
        cell.delegate = self;
    }
    NSString *pmName = [self.infoDataArray safeObjectAtIndex:indexPath.row];
    [cell configProjectWithName:pmName];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.pmType == KDQCZFProjectPM_Forbidden_Style) {
        return;
    }
    
    
}

#pragma mark -DQProjectPullCellDelegate
- (void)didOnProjectPullCell:(DQProjectPullCell *)pullCell
{
    if (self.pmType == KDQCZFProjectPM_Forbidden_Style) {
        return;
    }
    
    
}

- (void)showWithFatherV:(UIView *)fatherV
{
    [fatherV addSubview:self];
    self.hidden = false;
}

- (void)disshow
{
    [UIView animateWithDuration:0.25 animations:^{
        [self removeFromSuperview];
    }];
}

- (void)reloadPMData:(NSMutableArray *)pmArr
{
    self.infoDataArray = pmArr;
    [self.pullTableView reloadData];
}

#pragma mark -UI
- (void)addThePullMangerView
{
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 50)];
    _headerView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_headerView];
    
    NSString *text = nil;
    if (self.pmType == KDQCZFProjectPM_Edit_Style) {
        text = @"承租方项目经理";
    } else {
        text = @"租赁方项目经理";
    }
    UIFont *font = [UIFont dq_regularSystemFontOfSize:14];
    CGFloat width = [AppUtils textWidthSystemFontString:text height:14 font:font];
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 18, width, 14)];
    _titleLabel.text = text;
    _titleLabel.font = font;
    _titleLabel.textColor = [UIColor colorWithHexString:COLOR_BLACK];
    [self addSubview:_titleLabel];
    
    UIButton *infoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    infoBtn.frame = CGRectMake(self.width-20-16, 15, 20, 20);
    [infoBtn setImage:ImageNamed(@"ic_done") forState:UIControlStateNormal];
    [infoBtn addTarget:self action:@selector(onInBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:infoBtn];
    
    _pullTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _headerView.bottom, self.width, self.height-_headerView.bottom)];
    _pullTableView.delegate = self;
    _pullTableView.dataSource = self;
    _pullTableView.separatorColor = [UIColor clearColor];
    _pullTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _pullTableView.showsVerticalScrollIndicator = false;
    if (@available(iOS 11.0, *)) {
        _pullTableView.estimatedRowHeight = 0;
        _pullTableView.estimatedSectionHeaderHeight = 0;
        _pullTableView.estimatedSectionFooterHeight = 0;
        _pullTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [self addSubview:_pullTableView];
}

- (NSMutableArray *)infoDataArray
{
    if (!_infoDataArray) {
        _infoDataArray = [NSMutableArray new];
    }
    return _infoDataArray;
}

@end
