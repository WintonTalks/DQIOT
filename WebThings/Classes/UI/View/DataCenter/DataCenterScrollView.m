//
//  DataCenterScrollView.m
//  WebThings
//
//  Created by machinsight on 2017/7/6.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "DataCenterScrollView.h"
#import "EMICardView.h"
#import "FirstTableVCell.h"
#import "SecondTableVCell.h"
#import "DeviceModel.h"

@interface DataCenterScrollView()<UITableViewDelegate,UITableViewDataSource,CAAnimationDelegate>{
    BOOL ishideAni;//是否是影藏的动画
}

@property(nonatomic,strong)EMICardView *cardVew;/**外层卡片视图*/

@property(nonatomic,strong)UIScrollView *scV;/**滑动视图*/

@property(nonatomic,strong)UIView *firstV;/**第一页*/

@property(nonatomic,strong)UITableView *firstTableV;/**第一个tableview*/
@property(nonatomic,strong)NSArray <AddProjectModel *> *firstData;

@property(nonatomic,strong)UIView *secondV;/**第二页*/
@property(nonatomic,strong)UIView *secondTopV;/**第二页顶部导航栏*/
@property(nonatomic,strong)MDCFlatButton *backBtn;/**第二页顶部导航栏返回按钮*/
@property(nonatomic,strong)UILabel *secondTitleLab;/**第二页顶部导航栏标题*/
@property(nonatomic,strong)MDCFlatButton *sureBtn;/**第二页顶部导航栏完成按钮*/
@property(nonatomic,strong)UITableView *secondTableV;/**第二个tableview*/

@property(nonatomic,strong)NSMutableArray <DeviceModel *> *secondData;

@property(nonatomic,strong)NSMutableArray <NSMutableArray <DeviceModel *> *> *outData;

@property(nonatomic,strong)NSString *selectedProjectName;
@property(nonatomic,assign)NSInteger selectedProjectId;
@end
@implementation DataCenterScrollView

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup{
    ishideAni = NO;
    self.hidden = YES;
    self.backgroundColor = [UIColor whiteColor];
    [self cardVew];
    [self scV];
    [self firstV];
    [self firstTableV];
    [self secondV];
    [self secondTopV];
    [self backBtn];
    [self secondTitleLab];
//    [self sureBtn];
    [self secondTableV];
}

- (EMICardView *)cardVew{
    if (!_cardVew) {
        _cardVew = [[EMICardView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [self addSubview:_cardVew];
//        _cardVew.sd_layout.leftSpaceToView(self, 0).topSpaceToView(self, 0).rightSpaceToView(self, 0).bottomSpaceToView(self, 0);
    }
    return _cardVew;
}

- (UIScrollView *)scV{
    if (!_scV) {
        _scV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _scV.scrollEnabled = NO;
        _scV.pagingEnabled = YES;
        _scV.contentSize = CGSizeMake(self.frame.size.width*2, 0);
        [_cardVew addSubview:_scV];
//        _scV.sd_layout.leftSpaceToView(_cardVew, 0).topSpaceToView(_cardVew, 0).rightSpaceToView(_cardVew, 0).bottomSpaceToView(_cardVew, 0);
    }
    return _scV;
}

- (UIView *)firstV{
    if (!_firstV) {
        _firstV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [_scV addSubview:_firstV];
    }
    return _firstV;
}

- (UITableView *)firstTableV{
    if (!_firstTableV) {
        _firstTableV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [_firstV addSubview:_firstTableV];
        _firstTableV.showsVerticalScrollIndicator = NO;
        _firstTableV.delegate  =self;
        _firstTableV.tag = 1000;
        _firstTableV.dataSource = self;
        _firstTableV.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _firstTableV.sd_layout.leftSpaceToView(_firstV, 0).topSpaceToView(_firstV, 0).rightSpaceToView(_firstV, 0).bottomSpaceToView(_firstV, 0);
    }
    return _firstTableV;
}

- (UIView *)secondV{
    if (!_secondV) {
        _secondV = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];
        [_scV addSubview:_secondV];
    }
    return _secondV;
}
- (UIView *)secondTopV{
    if (!_secondTopV) {
        _secondTopV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 46)];
        [_secondV addSubview:_secondTopV];
//        _secondTopV.sd_layout.leftSpaceToView(_secondV, 0).topSpaceToView(_secondV, 0).rightSpaceToView(_secondV, 0).heightIs(46);
        UIView *lineV = [[UIView alloc] init];
        [_secondTopV addSubview:lineV];
        lineV.backgroundColor = [UIColor colorWithHexString:@"#EBECED"];
        lineV.sd_layout.leftSpaceToView(_secondTopV, 12).rightSpaceToView(_secondTopV, 12).bottomSpaceToView(_secondTopV, 0).heightIs(1);
    }
    return _secondTopV;
}
- (MDCFlatButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [[MDCFlatButton alloc] initWithFrame:CGRectMake(8, 8, 20, 20)];
        [_secondTopV addSubview:_backBtn];
        [_backBtn setInkColor:[UIColor lightGrayColor]];
        [_backBtn setBackgroundImage:[UIImage imageNamed:@"small_back"] forState:UIControlStateNormal];
        [_backBtn setBackgroundImage:[UIImage imageNamed:@"small_back"] forState:UIControlStateHighlighted];
        // 监听按钮点击
//        _backBtn.sd_layout.leftSpaceToView(_secondTopV, 8).centerYEqualToView(_secondTopV).heightIs(20).widthIs(20);
    }
    return _backBtn;
}
- (UILabel *)secondTitleLab{
    if (!_secondTitleLab) {
        _secondTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(40, 12, 150, 15)];
        _secondTitleLab.textColor = [UIColor colorWithHexString:@"#202425"];
        _secondTitleLab.font = [UIFont fontWithName:@"DroidSans-Bold" size:14];
        [_secondTopV addSubview:_secondTitleLab];
//        _secondTitleLab.sd_layout.leftSpaceToView(_backBtn, 14).centerYEqualToView(_secondTopV).heightIs(15).widthIs(150);
        _secondTitleLab.text = @"标题";
        
        UIButton *btnBack = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, _secondTopV.frame.size.width, _secondTopV.frame.size.height)];
        [btnBack addTarget:self action:@selector(smallback) forControlEvents:UIControlEventTouchUpInside];
        [_secondTopV addSubview:btnBack];
    }
    return _secondTitleLab;
}
- (MDCFlatButton *)sureBtn{
    if (!_sureBtn) {
        _sureBtn = [[MDCFlatButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 12, 0, 15, 15)];
        [_secondTopV addSubview:_sureBtn];
        [_sureBtn setInkColor:[UIColor lightGrayColor]];
        [_sureBtn setBackgroundImage:[UIImage imageNamed:@"ic_done"] forState:UIControlStateNormal];
        [_sureBtn setBackgroundImage:[UIImage imageNamed:@"ic_done"] forState:UIControlStateHighlighted];
        // 监听按钮点击
        [_sureBtn addTarget:self action:@selector(smallsure) forControlEvents:UIControlEventTouchUpInside];
//        _sureBtn.sd_layout.rightSpaceToView(_secondTopV, 12).centerYEqualToView(_secondTopV).heightIs(15).widthIs(15);
    }
    return _sureBtn;
}
- (UITableView *)secondTableV{
    if (!_secondTableV) {
        _secondTableV = [[UITableView alloc] initWithFrame:CGRectMake(0, 46, self.frame.size.width, self.frame.size.height)];
        [_secondV addSubview:_secondTableV];
        _secondTableV.delegate  =self;
        _secondTableV.showsVerticalScrollIndicator = NO;
        _secondTableV.tag = 2000;
        _secondTableV.dataSource = self;
        _secondTableV.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _secondTableV.sd_layout.leftSpaceToView(_secondV, 0).topSpaceToView(_secondTopV, 0).rightSpaceToView(_secondV, 0).bottomSpaceToView(_secondV, 0);
    }
    return _secondTableV;
}
#pragma UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (tableView.tag) {
        case 1000:
            if (_firstData.count) {
                return _firstData.count;
            }else{
                return 0;
            }
            break;
            
        default:
            if (_secondData.count) {
                return _secondData.count;
            }else{
                return 0;
            }
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (tableView.tag) {
        case 1000:
        {
            FirstTableVCell *cell = [FirstTableVCell cellWithTableView:tableView];
            [cell setViewWithValues:_firstData[indexPath.row].projectname];
            return cell;
        }
            break;
            
        default:
        {
            FirstTableVCell *cell = [FirstTableVCell cellWithTableView:tableView];
            [cell setViewWithValues:_secondData[indexPath.row].deviceno];
            [cell setImgvHide:YES];
            return cell;
        }
            break;
    }
}

#pragma UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (tableView.tag == 1000) {
        //懒加载，若还没有数据，就去请求，若有就不
        if (!_outData[indexPath.row].count) {
            //先清空，防止误点
            _secondData = [NSMutableArray array];
            [_secondTableV reloadData];
            
            [self fetchDeviceListWithIndexPath:indexPath];
        }else{
            _secondData = _outData[indexPath.row];
            [_secondTableV reloadData];
        }
        _selectedProjectName = _firstData[indexPath.row].projectname;
        _selectedProjectId = _firstData[indexPath.row].projectid;
        _secondTitleLab.text = _firstData[indexPath.row].projectname;
        [_scV setContentOffset:CGPointMake(self.frame.size.width, 0)  animated:YES];
    }else{
        NSString *str = [NSString stringWithFormat:@"%@-%@",_selectedProjectName,_secondData[indexPath.row].deviceno];
        if (_delegate && [_delegate respondsToSelector:@selector(didSelectSecondCellWithDeviceId:WithStr:WithProjectId:)]) {
            [_delegate didSelectSecondCellWithDeviceId:_secondData[indexPath.row].deviceid WithStr:str WithProjectId:_selectedProjectId];
        }
    }
}
#pragma 返回
- (void)smallback{
    [_scV setContentOffset:CGPointMake(0, 0)  animated:YES];
}
#pragma 完成
- (void)smallsure{
    
    [self disshow];
}
#pragma show
- (void)showWithFatherV:(UIView *)fatherV{
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
    
    [_scV setContentOffset:CGPointMake(0, 0)  animated:YES];
    self.secondData = [NSMutableArray array];
    [self.secondTableV reloadData];
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



- (void)setFirstData:(NSArray <AddProjectModel *> *)arr{
    _firstData = arr;
    [_firstTableV reloadData];
    if (!_outData) {
        _outData = [NSMutableArray array];
    }
    [_outData removeAllObjects];
    for (int i = 0; i<_firstData.count; i++) {
        NSMutableArray *ta = [NSMutableArray array];
        [_outData addObject:ta];
    }
}

/**
 请求设备列表
 */
- (void)fetchDeviceListWithIndexPath:(NSIndexPath *)indexPath
{
    AddProjectModel *model = [_firstData safeObjectAtIndex:indexPath.row];
    [[DQDeviceInterface sharedInstance] dq_getConfigDeviceList:model.projectid success:^(id result) {
        if (result) {
            self.secondData = result;
            self.outData[indexPath.row] = result;
            [self.secondTableV reloadData];
        }
    } failture:^(NSError *error) {
        
    }];
}
@end
