//
//  WebThings
//
//  Created by machinsight on 2017/6/21.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "NewDeviceScrollView.h"
#import "EMICardView.h"
#import "FirstTableVCell.h"
#import "SecondTableVCell.h"
#import "DeviceModel.h"
#import "WarningModel.h"
#import "CK_ID_NameModel.h"
#import "DQAddProjectModel.h"
#import "DQWorkTypeModel.h"
#import "DQTrainTypeModel.h"

@interface NewDeviceScrollView()
<UITableViewDelegate,
UITableViewDataSource,
CAAnimationDelegate>
{
    BOOL ishideAni;//是否是影藏的动画
    NSMutableArray *_dataArray;
}

@property(nonatomic,strong)EMICardView *cardVew;/**外层卡片视图*/
//@property(nonatomic,strong)NSMutableArray *dataArray;

@property(nonatomic,strong)UITableView *firstTableV;/**第一个tableview*/
@end

@implementation NewDeviceScrollView

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
    _dataArray = [NSMutableArray array];
    ishideAni = NO;
    self.hidden = YES;
    self.backgroundColor = [UIColor whiteColor];
    [self cardVew];
    [self addSubview:self.firstTableV];
}

- (EMICardView *)cardVew{
    if (!_cardVew) {
        _cardVew = [[EMICardView alloc] init];
        [self addSubview:_cardVew];
        _cardVew.sd_layout.leftSpaceToView(self, 0).topSpaceToView(self, 0).rightSpaceToView(self, 0).bottomSpaceToView(self, 0);
    }
    return _cardVew;
}

- (UITableView *)firstTableV{
    if (!_firstTableV) {
        _firstTableV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height) style:UITableViewStylePlain];
        _firstTableV.showsVerticalScrollIndicator = NO;
        _firstTableV.delegate  =self;
        _firstTableV.dataSource = self;
        if (self.tag != 9527) {
            _firstTableV.separatorStyle = UITableViewCellSeparatorStyleNone;
        }
    }
    return _firstTableV;
}

#pragma UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.tag == 9527 ? 50 : 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.tag == 9527) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DQProjectCellWithIdentifier"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DQProjectCellWithIdentifier"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.font = [UIFont dq_mediumSystemFontOfSize:14];
            cell.textLabel.textColor = [UIColor colorWithHexString:COLOR_BLACK];
        }
        DQAddProjectModel *model = [_dataArray safeObjectAtIndex:indexPath.row];
        cell.textLabel.text = model.brand;
        return cell;
    }
    
    FirstTableVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pullCellWithIdentifier"];
    if (!cell) {
        cell = [[FirstTableVCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"pullCellWithIdentifier"];
    }
    [cell setImgvHide:YES];
    if (self.tag == 0) {
        DQAddProjectModel *model = [_dataArray safeObjectAtIndex:indexPath.row];
        [cell setViewWithValues:model.brand];
    } else if(self.tag == 1){
        id obj = [_dataArray safeObjectAtIndex:indexPath.row];
        if ([obj isKindOfClass:[DQDeviceModel class]]) {
            DQDeviceModel *model = (DQDeviceModel *)obj;
            [cell setViewWithValues:model.deviceno];
        } else if ([obj isKindOfClass:[DQSecondDeviceModel class]]) {
            DQSecondDeviceModel *deviceM = (DQSecondDeviceModel *)obj;
            [cell setViewWithValues:[NSString stringWithFormat:@"%@",deviceM.brand]];
        }
    } else if(self.tag == 1000){
        DeviceModel *m = (DeviceModel *)[_dataArray safeObjectAtIndex:indexPath.row];
        [cell setViewWithValues:m.deviceno];
    } else if(self.tag == 2000){
        [cell setViewWithValues:[_dataArray safeObjectAtIndex:indexPath.row]];
    } else if(self.tag == 3000){
        UserModel *m = (UserModel *)[_dataArray safeObjectAtIndex:indexPath.row];
        [cell setViewWithValues:m.name];
    } else if(self.tag == 4000){
        WarningModel *m = (WarningModel *)[_dataArray safeObjectAtIndex:indexPath.row];
        [cell setViewWithValues:m.warnname];
    } else if(self.tag == 5000){
        UserModel *m = (UserModel *)[_dataArray safeObjectAtIndex:indexPath.row];
        [cell setViewWithValues:m.name];
    } else if (self.tag == 6688){
        CK_ID_NameModel *m = (CK_ID_NameModel *)[_dataArray safeObjectAtIndex:indexPath.row];
        [cell setViewWithValues:m.cname];
    } else if (self.tag == 7000) {
        DQWorkTypeModel *typeModel = [_dataArray safeObjectAtIndex:indexPath.row];
        [cell setViewWithValues:typeModel.workcategory];
    } else if (self.tag == 9566) {
        DQTrainTypeModel *trainModel = [_dataArray safeObjectAtIndex:indexPath.row];
        [cell setViewWithValues:trainModel.type];
    }
    return cell;
}

#pragma UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectValue:withSelf:witnIndex:)]) {
        [_delegate didSelectValue:_dataArray[indexPath.row] withSelf:self witnIndex:indexPath.row];
    }
    [self disshow];
}

#pragma show
- (void)showWithFatherV:(UIView *)fatherV{
    ishideAni = NO;
    [fatherV addSubview:self];
    self.hidden = NO;
//    //动画，高度从1到223
//    [ChangeAnchorPoint setAnchorPoint:CGPointMake(0, 0) forView:self];
//    CABasicAnimation* animation = [CABasicAnimation animation];
//    animation.keyPath=@"transform.scale.y";
//    animation.fromValue= @(0);
//    animation.toValue= @(1);
//    animation.duration=0.3;
//    animation.timingFunction= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
//    animation.removedOnCompletion=NO;//动画结束了禁止删除
//    animation.fillMode= kCAFillModeForwards;//停在动画结束处
//    animation.delegate = self;
//    [self.layer addAnimation:animation forKey:@"basic"];
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1.0;
    }];
}

#pragma disshow
- (void)disshow {
    ishideAni = YES;
//    [ChangeAnchorPoint setAnchorPoint:CGPointMake(0, 0) forView:self];
//    CABasicAnimation* animation = [CABasicAnimation animation];
//    animation.keyPath=@"transform.scale.y";
//    animation.fromValue= @(1);
//    animation.toValue= @(0);
//    animation.duration=0.3;
//    animation.timingFunction= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
//    animation.removedOnCompletion=NO;//动画结束了禁止删除
//    animation.fillMode= kCAFillModeForwards;//停在动画结束处
//    animation.delegate = self;
//    [self.layer addAnimation:animation forKey:@"basic"];
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            self.hidden = YES;
        }
    }];
}

#pragma animationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if (ishideAni) {
        self.hidden = YES;
        [self removeFromSuperview];
    }
    [ChangeAnchorPoint setDefaultAnchorPointforView:self];
}

- (void)setData:(NSMutableArray *)data{
    [_dataArray removeAllObjects];
    [_dataArray addObjectsFromArray:data];
    [_firstTableV reloadData];
}

- (void)setDataList:(NSMutableArray *)dataList
{
    [_dataArray removeAllObjects];
    [_dataArray addObjectsFromArray:dataList];
    [_firstTableV reloadData];
}


@end
