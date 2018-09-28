//
//  EvaluateOriginCell.m
//  WebThings
//
//  Created by machinsight on 2017/8/8.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "EvaluateOriginCell.h"
#import "EMICardView.h"
#import "ServiceFinishBtn.h"
#import "XHStarRateView.h"
#import "rightFooterView.h"
#import "leftFooterView.h"

@interface EvaluateOriginCell()
@property (weak, nonatomic) IBOutlet EMICardView *fatherV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fatherVWid;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fatherVLeading;
@property (weak, nonatomic) IBOutlet UIView *topFatherV;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UIView *labFatherV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labFatherVHei;
@property (weak, nonatomic) IBOutlet UIView *bottomFatherV;
@property (weak, nonatomic) IBOutlet ServiceFinishBtn *finishBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *spaceHei;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLeading;
@property (weak, nonatomic) IBOutlet UIImageView *star1;
@property (weak, nonatomic) IBOutlet UIImageView *star2;
@property (weak, nonatomic) IBOutlet UIImageView *star3;
@property (weak, nonatomic) IBOutlet UIImageView *star4;
@property (weak, nonatomic) IBOutlet UIImageView *star5;
@property (weak, nonatomic) IBOutlet UILabel *starLab;

@property (nonatomic,strong)NSMutableArray <UIImageView *> *starArr;
@property (nonatomic,strong)NSMutableArray *starTextArr;

//@property (nonatomic,strong) XHStarRateView *starRateView3;

@property (nonatomic,strong)rightFooterView *rightFootV1;
@property (nonatomic,strong)leftFooterView *leftFootV1;
@end
@implementation EvaluateOriginCell

+ (id)cellWithTableView:(UITableView *)tableview{
    EvaluateOriginCell *cell = [tableview dequeueReusableCellWithIdentifier:@"EvaluateOriginCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"EvaluateOriginCell" owner:nil options:nil] objectAtIndex:0];
        cell.fatherVWid.constant = 245*autoSizeScaleX;
        cell.starArr = [NSMutableArray arrayWithObjects:cell.star1,cell.star2,cell.star3,cell.star4,cell.star5, nil];
        cell.starTextArr = [NSMutableArray arrayWithObjects:@"极差",@"较差",@"一般",@"不错",@"很棒", nil];
//        [cell initView];
    }
    
    return cell;
}

//- (void)initView{
//    if (!_starRateView3) {
//        _starRateView3 = [[XHStarRateView alloc] initWithFrame:CGRectMake(10, 8, 245*autoSizeScaleX-10-55, 25) finish:^(CGFloat currentScore) {
//        }];
//        _starRateView3.userInteractionEnabled = NO;
//        [_topFatherV addSubview:_starRateView3];
//    }
//}

- (void)setViewValuesWithModel:(ServiceCenterBaseModel *)model{

    
    if (model.direction == 0) {
        //0居左
        self.fatherVLeading.constant = 51;
//        _starRateView3.frame = CGRectMake(10, 8, 245*autoSizeScaleX-10-55, 14);
        self.topLeading.constant = 13;
    }else{
        //1居右
        self.fatherVLeading.constant = screenWidth-245*autoSizeScaleX-16;
//        _starRateView3.frame = CGRectMake(55, 8, 245*autoSizeScaleX-10-55, 14);
        self.topLeading.constant = 245*autoSizeScaleX-130;
    }
    
//    [_starRateView3 setCurrentScore:model.serviceevaluate.star];
    if (model.serviceevaluate.star != 0) {
        _starLab.text = _starTextArr[model.serviceevaluate.star-1];
        for (int i = 0; i < _starArr.count; i++) {
            if (i <= model.serviceevaluate.star-1) {
                [_starArr[i] setImage:[UIImage imageNamed:@"b27_icon_star_yellow"]];
            }
        }
    }
    
    _contentLab.text = model.serviceevaluate.note;
    
    if (model.direction == 0) {
        if (!_leftFootV1) {
            _leftFootV1 = [[leftFooterView alloc] init];
            [self.bottomFatherV addSubview:_leftFootV1];
            _leftFootV1.sd_layout.topSpaceToView(self.bottomFatherV, 0).leftSpaceToView(self.bottomFatherV, 0).rightSpaceToView(self.bottomFatherV, 0).heightIs(40);
        }
        [_leftFootV1 setViewValuesWithModel:model];
    }else{
        if (!_rightFootV1) {
            _rightFootV1 = [[rightFooterView alloc] init];
            [self.bottomFatherV addSubview:_rightFootV1];
            _rightFootV1.sd_layout.topSpaceToView(self.bottomFatherV, 0).leftSpaceToView(self.bottomFatherV, 0).rightSpaceToView(self.bottomFatherV, 0).heightIs(40);
        }
        [_rightFootV1 setViewValuesWithModel:model];
        
    }
    if (!model.isCEO && model.iszulin && model.enumstateid == 48 && model.isLast) {
        _finishBtn.hidden = NO;
        [_finishBtn setSureTag:7];
        [_finishBtn setBtnTitle:@"回复" Width:73];
    }
    
}

- (CGFloat)cellHeightWithModel:(ServiceCenterBaseModel *)model{
    CGFloat height = [AppUtils textHeightSystemFontString:_contentLab.text height:245*autoSizeScaleX-20 font:_contentLab.font];
    _labFatherVHei.constant = 12+height+1;
    if (!model.isCEO && model.iszulin && model.enumstateid == 48 && model.isLast) {
        return 137+height+1;
    }
    return 97+height+1;
}

- (void)setAction1:(SEL)action1 target:(id)target{
    [_finishBtn setAction1:action1 target:target];
    
}
@end
