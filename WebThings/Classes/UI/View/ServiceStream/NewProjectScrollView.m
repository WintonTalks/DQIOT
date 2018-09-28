//
//  NewProjectScrollView.m
//  WebThings
//
//  Created by machinsight on 2017/6/21.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "NewProjectScrollView.h"
#import "EMICardView.h"
#import "FirstTableVCell.h"
#import "SecondTableVCell.h"
#import "DeviceTypeModel.h"
#import "DQAddProjectModel.h"

@interface NewProjectScrollView()<UITableViewDelegate,UITableViewDataSource,CAAnimationDelegate,SecondTableVCellDelegate>
{
    BOOL ishideAni;//是否是影藏的动画
    UILabel *_titleLabel;
    UITableView *_secondTableV;
}

@property (nonatomic, strong) EMICardView *cardVew;/**外层卡片视图*/
@property (nonatomic, strong) UIScrollView *infoView;/**滑动视图*/
@property (nonatomic, strong) UITableView *firstTableV;/**第一个tableview*/
@property (nonatomic, strong) UIView *secondView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *secondArr;
@property (nonatomic, strong) NSMutableArray *selectedSecondArr;//型号是否被选中，数量和secondArr一样多，默认都为NO

@end

@implementation NewProjectScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self configUI];
        
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self configUI];
    }
    return self;
}

- (void)configUI
{
    [self addSubview:self.cardVew];
    [self addSubview:self.infoView];
    [self.infoView addSubview:self.firstTableV];
    [self.infoView addSubview:self.secondView];
    [self.secondView addSubview:self.topView];
    if (!_secondTableV) {
        _secondTableV = [[UITableView alloc] initWithFrame:CGRectMake(0, self.topView.bottom, self.width, self.secondView.height-self.topView.bottom) style:UITableViewStylePlain];
        _secondTableV.delegate = self;
        _secondTableV.dataSource = self;
        _secondTableV.showsVerticalScrollIndicator = NO;
        _secondTableV.tag = 2000;
        _secondTableV.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.secondView addSubview:_secondTableV];
    }
}

- (EMICardView *)cardVew
{
    if (!_cardVew) {
        _cardVew = [[EMICardView alloc] initWithFrame:self.bounds];
    }
    return _cardVew;
}

- (UIScrollView *)infoView
{
    if (!_infoView) {
        _infoView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _infoView.showsVerticalScrollIndicator = false;
        _infoView.showsHorizontalScrollIndicator = false;
        _infoView.bounces = true;
        _infoView.bouncesZoom = true;
        _infoView.contentSize = CGSizeMake(self.width*2, self.height);
    }
    return _infoView;
}

- (UITableView *)firstTableV
{
    if (!_firstTableV) {
        _firstTableV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height) style:UITableViewStylePlain];
        _firstTableV.delegate = self;
        _firstTableV.dataSource = self;
        _firstTableV.showsVerticalScrollIndicator = false;
        _firstTableV.tag = 1000;
        _firstTableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _firstTableV;
}

- (UIView *)secondView
{
    if (!_secondView) {
        _secondView = [[UIView alloc ] initWithFrame:CGRectMake(self.width, 0, self.width, self.height)];
        _secondView.backgroundColor = [UIColor whiteColor];
        _secondView.userInteractionEnabled = true;
    }
    return _secondView;
}

- (UIView *)topView
{
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 46)];
        _topView.backgroundColor = [UIColor whiteColor];
        _topView.userInteractionEnabled = true;
        UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(0, 45, self.width, 1)];
        lineV.backgroundColor = [UIColor colorWithHexString:@"#EBECED"];
        [_topView addSubview:lineV];
        
        MDCFlatButton *backBtn = [[MDCFlatButton alloc] initWithFrame:CGRectMake(12, 13, 20, 20)];
        [backBtn setInkColor:[UIColor lightGrayColor]];
        [backBtn setBackgroundImage:[UIImage imageNamed:@"small_back"] forState:UIControlStateNormal];
        [backBtn setBackgroundImage:[UIImage imageNamed:@"small_back"] forState:UIControlStateHighlighted];
        [backBtn addTarget:self action:@selector(onSmallBackClick) forControlEvents:UIControlEventTouchUpInside];
        [_topView addSubview:backBtn];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(backBtn.right+10, backBtn.top, 0, 18)];
        _titleLabel.textColor = [UIColor colorWithHexString:COLOR_BLACK];
        _titleLabel.font = [UIFont dq_regularSystemFontOfSize:14];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        [_topView addSubview:_titleLabel];
        
        /**第二页顶部导航栏完成按钮*/
        MDCFlatButton *sureBtn = [[MDCFlatButton alloc] initWithFrame:CGRectMake(_topView.width-20-12, backBtn.top, 20, 20)];
        [sureBtn setInkColor:[UIColor lightGrayColor]];
        [sureBtn setBackgroundImage:[UIImage imageNamed:@"ic_done"] forState:UIControlStateNormal];
        [sureBtn setBackgroundImage:[UIImage imageNamed:@"ic_done"] forState:UIControlStateHighlighted];
        [sureBtn addTarget:self action:@selector(onSureBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_topView addSubview:sureBtn];
    }
    return _topView;
}

#pragma UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 1000) {
        return _dataSource.count;
    }
    return _secondArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1000) {
        FirstTableVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FirstTableVCellWithIdentifier"];
        if (!cell) {
            cell = [[FirstTableVCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"FirstTableVCellWithIdentifier"];
        }
        [cell setImgvHide:false];
        DQAddProjectModel *model = [_dataSource safeObjectAtIndex:indexPath.row];
        [cell setViewWithValues:[NSObject changeType:model.brand]];
        return cell;
    }
    
    SecondTableVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"checkCellWithIdentifier"];
    if (!cell) {
        cell = [[SecondTableVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"checkCellWithIdentifier"];
    }
    DQSecondDeviceModel *deviceModel = [self.secondArr safeObjectAtIndex:indexPath.row];
    cell.thisIndexPath = indexPath;
    cell.delegate = self;
    cell.checkState = [_selectedSecondArr containsObject:deviceModel];
    [cell setViewWithValues:[NSObject changeType:deviceModel.brand]];
    return cell;
}

#pragma UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (tableView.tag == 1000) {
        DQAddProjectModel *model = [_dataSource safeObjectAtIndex:indexPath.row];
        CGFloat width = [AppUtils textWidthSystemFontString:model.brand height:20 font:_titleLabel.font];
        _titleLabel.width = width;
        _titleLabel.text = model.brand;
        
        self.secondArr = model.secondArray;
        [_secondTableV reloadData];
        [self.infoView setContentOffset:CGPointMake(self.width, 0)  animated:true];
    }
}

#pragma SecondTableVCellDelegate
- (void)cellcekBtnClicked:(CKCheckBoxButton *)sender indexPath:(NSIndexPath *)indexPath
{
    self.selectedSecondArr[indexPath.row] = @(sender.isOn);
}

#pragma 返回
- (void)onSmallBackClick
{
    [self.selectedSecondArr removeAllObjects];
    [_secondTableV reloadData];
    [self.infoView setContentOffset:CGPointMake(0, 0) animated:true];
}

#pragma 完成
- (void)onSureBtnClick
{
    [self disshow];
    NSMutableArray *retArr = [NSMutableArray array];
    NSString *str = [NSString stringWithFormat:@"%@-",_titleLabel.text];
    for (int i = 0; i < self.selectedSecondArr.count; i++) {
        DQSecondDeviceModel *deviceModel = [self.secondArr safeObjectAtIndex:i];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:@(0) forKey:@"count"];
        [dic setObject:_titleLabel.text forKey:@"brand"];
        [dic setObject:[NSString stringWithFormat:@"%ld",(long)deviceModel.deviceID] forKey:@"modelid"];
        [dic setObject:deviceModel.model forKey:@"model"];
        [retArr safeAddObject:dic];
        str = [NSString stringWithFormat:@"%@%@,",str,deviceModel.model];
    }
    //去除最后一个逗号
    str = [str substringToIndex:str.length-1];
    
    if (retArr.count == 0) {
        return;
    }
    if (_delegate && [_delegate respondsToSelector:@selector(sureBtnClicked:str:)]) {
        [_delegate sureBtnClicked:[DeviceTypeModel mj_objectArrayWithKeyValuesArray:retArr] str:str];
    }
}

#pragma show
- (void)showWithFatherV:(UIView *)fatherV
{
    ishideAni = NO;
    [fatherV addSubview:self];
    self.hidden = NO;
    //动画，高度从1到223
    [ChangeAnchorPoint setAnchorPoint:CGPointMake(0, 0) forView:self];
    CABasicAnimation* animation = [CABasicAnimation animation];
    animation.keyPath=@"transform.scale.y";
    animation.fromValue= @(0);
    animation.toValue= @(1);
    animation.duration=0.3;
    animation.timingFunction= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    animation.removedOnCompletion=NO;//动画结束了禁止删除
    animation.fillMode= kCAFillModeForwards;//停在动画结束处
    animation.delegate = self;
    [self.layer addAnimation:animation forKey:@"basic"];
    
    [self.infoView setContentOffset:CGPointMake(0, 0)  animated:YES];
    //    self.secondArr = [NSMutableArray array];
    [self.firstTableV reloadData];
}


#pragma disshow
- (void)disshow{
    ishideAni = YES;
    [ChangeAnchorPoint setAnchorPoint:CGPointMake(0, 0) forView:self];
    CABasicAnimation* animation = [CABasicAnimation animation];
    animation.keyPath=@"transform.scale.y";
    animation.fromValue= @(1);
    animation.toValue= @(0);
    animation.duration=0.3;
    animation.timingFunction= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    animation.removedOnCompletion=NO;//动画结束了禁止删除
    animation.fillMode= kCAFillModeForwards;//停在动画结束处
    animation.delegate = self;
    [self.layer addAnimation:animation forKey:@"basic"];
}
#pragma animationDelegate
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if (ishideAni) {
        self.hidden = YES;
        [self removeFromSuperview];
    }
    [ChangeAnchorPoint setDefaultAnchorPointforView:self];
}

- (void)setDataArr:(NSMutableArray *)arr{
    _dataSource = arr;
    [self.firstTableV reloadData];
}

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}

- (NSMutableArray *)secondArr
{
    if (!_secondArr) {
        _secondArr = [NSMutableArray new];
    }
    return _secondArr;
}

- (NSMutableArray *)selectedSecondArr
{
    if (!_selectedSecondArr) {
        _selectedSecondArr = [NSMutableArray new];
    }
    return _selectedSecondArr;
}

@end
