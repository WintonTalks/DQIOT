//
//  ServiceImageCell.m
//  WebThings
//
//  Created by machinsight on 2017/7/1.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "ServiceImageCell.h"
#import "EMICardView.h"
#import "ServiceImageBrowser.h"
#import "rightFooterView.h"
#import "leftFooterView.h"
#import "ServiceBtnView.h"
#import "MsgattachmentListModel.h"

@interface ServiceImageCell()
@property (weak, nonatomic) IBOutlet EMICardView *fatherV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fatherVLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fatherVWidth;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIView *imgFatherV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgFatherVHei;

@property (nonatomic,strong)ServiceImageBrowser *imgBrowser;

@property (weak, nonatomic) IBOutlet UIView *bottomFatherV;

@property (nonatomic,strong)rightFooterView *rightFootV1;
@property (nonatomic,strong)leftFooterView *leftFootV1;

@property (nonatomic,strong)ServiceBtnView *serviceBtnFatherV;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *spaceVHei;//最下面的0间距

@end

@implementation ServiceImageCell

+ (id)cellWithTableView:(UITableView *)tableview{
    ServiceImageCell *cell = [tableview dequeueReusableCellWithIdentifier:@"ServiceImageCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ServiceImageCell" owner:nil options:nil] objectAtIndex:0];
        [cell setView];
        cell.fatherVWidth.constant = 245*autoSizeScaleX;
    }else{
        if (cell.serviceBtnFatherV) {
            [cell.serviceBtnFatherV removeFromSuperview];
            cell.serviceBtnFatherV = nil;
        }
    }
    
    return cell;
}


- (void)setView{
    if (!_imgBrowser) {
        _imgBrowser = [[ServiceImageBrowser alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 154)];
        [_imgFatherV addSubview:_imgBrowser];
//        _imgBrowser.sd_layout.leftSpaceToView(_imgFatherV, 0).rightSpaceToView(_imgFatherV, 0).topSpaceToView(_imgFatherV, 0).bottomSpaceToView(_imgFatherV, 0);
    }
}

- (void)setViewValuesWithModel:(ServiceCenterBaseModel *)model{
    
    _titleLab.text = model.title;
    
    if (model.isLastCommit) {
        _spaceVHei.constant = 15;
    }else{
        if (model.isLastSecondSure) {
            _spaceVHei.constant = 2;
        }else{
            _spaceVHei.constant = 0;
        }
    }
    
    if (model.direction == 0) {
        //0居左
        self.fatherVLeading.constant = 51;
    }else{
        //1居右
        self.fatherVLeading.constant = screenWidth-245*autoSizeScaleX-16;
    }
    NSMutableArray *imgArrs = [NSMutableArray array];
    for (MsgattachmentListModel *item in model.msgattachmentList) {
        [imgArrs addObject:appendUrl(imgUrl, item.fileurl)];
        if (imgArrs.count == 6) {
            break;//最多展示6条
        }
    }
    
    switch (imgArrs.count) {
        case 0:
            _imgFatherVHei.constant = 0;
            break;
        case 1:
            _imgFatherVHei.constant = 154;
            break;
        case 2:
            _imgFatherVHei.constant = (245*autoSizeScaleX-12)/2;
            break;
        case 3:
            _imgFatherVHei.constant = (245*autoSizeScaleX-16)/3;
            break;
        default:
            _imgFatherVHei.constant = (245*autoSizeScaleX-16)/3*2+5;
            break;
    }
    
    [_imgBrowser setImgArrs:imgArrs];
    
    CGRect rect = _bottomFatherV.frame;
    
    CGFloat width = rect.size.width;
    if (model.direction == 0) {
        if (!_leftFootV1) {
            _leftFootV1 = [[leftFooterView alloc] initWithFrame:CGRectMake(0, 0, width, 40)];
            [self.bottomFatherV addSubview:_leftFootV1];
        }
        [_leftFootV1 setViewValuesWithModel:model];
        if (model.isLastCommit) {
            //确认驳回按钮
            if (!_serviceBtnFatherV) {
                _serviceBtnFatherV = [[ServiceBtnView alloc] init];
                _serviceBtnFatherV.backgroundColor = [UIColor redColor];
                [self.bottomFatherV addSubview:_serviceBtnFatherV];
            }
            _serviceBtnFatherV.frame = CGRectMake(0, 40, width, 50);
        }
    }else{
        if (!_rightFootV1) {
            _rightFootV1 = [[rightFooterView alloc] initWithFrame:CGRectMake(0, 0, width, 40)];
            [self.bottomFatherV addSubview:_rightFootV1];
        }
        [_rightFootV1 setViewValuesWithModel:model];
        
    }
}

- (void)setAction1:(SEL)action1 Action2:(SEL)action2 target:(id)target{
    if (_serviceBtnFatherV) {
        [_serviceBtnFatherV setAction1:action1 Action2:action2 target:target];
    }
}
- (void)setBtnTag1:(NSInteger)tag1 Tag2:(NSInteger)tag2{
    if (_serviceBtnFatherV) {
        [_serviceBtnFatherV setSureTag:tag1 againstTag:tag2];
    }
}

@end
