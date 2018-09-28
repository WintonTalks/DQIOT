
//  BusinessCenterCell.m
//  WebThings
//
//  Created by machinsight on 2017/6/12.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "BusinessCenterCell.h"
#import "EMICardView.h"
#import "DQProgressView.h"

@interface BusinessCenterCell()
@property (weak, nonatomic) IBOutlet UILabel *projectNameLab;//项目名称
@property (weak, nonatomic) IBOutlet UILabel *czfNameLab;//承租方
@property (weak, nonatomic) IBOutlet UILabel *totalMoneyLab;//合计金额

@property (weak, nonatomic) IBOutlet UILabel *yazLab;//已安装
@property (weak, nonatomic) IBOutlet UILabel *jccfLab;//进出场费
@property (weak, nonatomic) IBOutlet UILabel *sjfyLab;//司机费用
@property (weak, nonatomic) IBOutlet UILabel *zjLab;//租金
@property (weak, nonatomic) IBOutlet UILabel *yjjcsjLab;//预计进场时间
@property (weak, nonatomic) IBOutlet UILabel *yjccsjLab;//预计出场时间

@property (weak, nonatomic) IBOutlet UIImageView *topBg;
@property (weak, nonatomic) IBOutlet UIImageView *finishImgV;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (strong, nonatomic) DQProgressView *progressCustomView;

@property (weak, nonatomic) IBOutlet EMICardView *emiCardView;

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@end
@implementation BusinessCenterCell

+ (id)cellWithTableView:(UITableView *)tableview {
    
    BusinessCenterCell *cell = [tableview dequeueReusableCellWithIdentifier:@"BusinessCenterCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BusinessCenterCell" owner:nil options:nil] safeObjectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell initBusinessView];
    }

    return cell;
}

- (void)initBusinessView {
    
    _progressCustomView = [[DQProgressView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.yazLab.frame), CGRectGetMaxY(self.yazLab.frame)+16, screenWidth-52, 10)];
    [self.bottomView addSubview:_progressCustomView];
    
    self.contentView.backgroundColor = [UIColor colorWithHexString:COLOR_BG];
}

- (void)setViewWithValues:(AddProjectModel *)model
{
    _emiCardView.layer.masksToBounds = YES;
    _emiCardView.layer.borderWidth = 1.0;
    _emiCardView.layer.borderColor = [UIColor colorWithHexString:@"DADADA"].CGColor;
    
    if ([[AppUtils readUser].type  isEqualToString:@"租赁商"]) {
        _czfNameLab.text = [NSString stringWithFormat:@"承租方：%@",model.needorgname];
    } else {
        _czfNameLab.text = [NSString stringWithFormat:@"租赁商：%@",model.provideorgname];
    }
    _projectNameLab.text = model.projectname;
    _totalMoneyLab.text = [AppUtils formatMoney:(int)model.totalprice];
    _yazLab.text = [NSString stringWithFormat:@"已安装%ld（共%ld台）",(long)model.installcount,(long)model.devicenum];
    
    // 修改progressView高度（修改高度的value有限）
    _progressView.hidden = YES;
//    CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 6.0f);
//    _progressView.transform = transform;
//    _progressView.progress = (double)model.installcount/(double)model.devicenum;
//    //_progressView.progressImage = [UIImage imageNamed:@"business_items_progress"];
//    if (_progressView.progress == 1) {
//        _progressView.progressImage = [UIImage stretchableImageWithImgae:@"business_items_progress"];
//    }
    
    if (model.installcount == false) {
        model.installcount = 0;
    }
    
    if (model.devicenum == false) {
        _progressCustomView.progress = 0;
    } else {
        _progressCustomView.progress = (double)model.installcount/(double)model.devicenum;
    }
    
    NSRange range = [_yazLab.text rangeOfString:@"（"];//匹配得到的下标
    range = NSMakeRange(range.location, _yazLab.text.length-range.location);
    _yazLab.attributedText = [_yazLab.text textDesplaydiffentColor:[UIColor colorWithHexString:@"909090"] font:[UIFont boldSystemFontOfSize:13] range:range];
    
    _jccfLab.text = [NSString stringWithFormat:@"%ld",model.intoutprice];
    _sjfyLab.text = [NSString stringWithFormat:@"%ld",model.driverrent];
    _zjLab.text = [NSString stringWithFormat:@"%ld",model.realrent];
    _yjjcsjLab.text = [self getTimeStr:model.indate];
    _yjccsjLab.text = [self getTimeStr:model.outdate];
    
    if (model.isfinish == 2) {//未完成
        _topBg.image = [UIImage imageNamed:@"service_center_title_bj"];
        _finishImgV.hidden = YES;
    }else{
        _topBg.image = [UIImage imageNamed:@"service_center_title_bj_gray"];
        _finishImgV.hidden = NO;
    }
}

- (NSString *)getTimeStr:(NSString *)timeStr
{
    if ([timeStr containsString:@":"]) {
        return [timeStr substringToIndex:10];
    } else {
        return timeStr;
    }
}
@end
