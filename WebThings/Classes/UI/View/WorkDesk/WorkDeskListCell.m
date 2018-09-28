//
//  WorkDeskListCell.m
//  WebThings
//
//  Created by machinsight on 2017/7/5.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "WorkDeskListCell.h"
#import "EMICardView.h"

@interface WorkDeskListCell()
@property (weak, nonatomic) IBOutlet EMICardView *cardView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *mesStateImageView;

@property (nonatomic,strong)DWMsgModel *thisModel;

@end
@implementation WorkDeskListCell

+ (id)cellWithTableView:(UITableView *)tableview {
    WorkDeskListCell *cell = [tableview dequeueReusableCellWithIdentifier:@"WorkDeskListCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"WorkDeskListCell" owner:nil options:nil] objectAtIndex:0];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.layer.cornerRadius = 4;
    self.contentView.layer.cornerRadius = 4;
    self.contentView.backgroundColor = [UIColor colorWithHexString:COLOR_BG];
    
}

- (void)hideCardV {
    _cardView.hidden = YES;
}

- (void)setViewValues:(DWMsgModel *)model {
    _thisModel = model;
    
    _titleLabel.text = model.noticetype;
    _dateLabel.text = model.cdate;
    _descLabel.text = [NSString stringWithFormat:@"%@ - %@%@设备%@",model.projectname,model.model,model.address,model.msg];
    
    if ([model.isread isEqualToString:@"未读"]) {
        _titleLabel.textColor = [UIColor colorWithHexString:@"000000"];
        _dateLabel.textColor = [UIColor colorWithHexString:@"C2C2C2"];
        _descLabel.textColor = [UIColor colorWithHexString:@"777777"];
        
        _mesStateImageView.image = [UIImage imageNamed:@"business_unread_mes"];
        _cardView.backgroundColor = [UIColor colorWithHexString:@"4480E2" alpha:0.2];
    } else {
        [self messageAlreadyReadColor:[UIColor colorWithHexString:@"#BBBBBB"]];
        _mesStateImageView.image = [UIImage imageNamed:@"business_read_mes"];
        _cardView.backgroundColor = [UIColor colorWithHexString:COLOR_BG];
    }
}

- (void)judgeIsYiDu {
    
    if ([_thisModel.isread isEqualToString:@"未读"]) {
        _titleLabel.textColor = [UIColor colorWithHexString:@"000000"];
        _dateLabel.textColor = [UIColor colorWithHexString:@"C2C2C2"];
        _descLabel.textColor = [UIColor colorWithHexString:@"777777"];
        _mesStateImageView.image = [UIImage imageNamed:@"business_unread_mes"];
        _cardView.backgroundColor = [UIColor colorWithHexString:@"4480E2" alpha:0.2];
    } else {
        [self messageAlreadyReadColor:[UIColor colorWithHexString:@"#BBBBBB"]];
        _mesStateImageView.image = [UIImage imageNamed:@"business_read_mes"];
        _cardView.backgroundColor = [UIColor colorWithHexString:COLOR_BG];
    }
}

- (void)messageAlreadyReadColor:(UIColor *)color {
        _titleLabel.textColor = color;
        _dateLabel.textColor = color;
        _descLabel.textColor = color;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];
    
    if ([_thisModel.isread isEqualToString:@"未读"] && selected) {
        _cardView.backgroundColor = [UIColor colorWithHexString:@"4480E2" alpha:0.5];
    }

}

@end
