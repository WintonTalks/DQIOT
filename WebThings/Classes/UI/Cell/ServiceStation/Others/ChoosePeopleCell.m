//
//  ChoosePeopleCell.m
//  WebThings
//
//  Created by machinsight on 2017/7/3.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "ChoosePeopleCell.h"

@interface ChoosePeopleCell()<CKCheckBoxButtonDelegate>

@end
@implementation ChoosePeopleCell

+ (id)cellWithTableView:(UITableView *)tableview{
    ChoosePeopleCell *cell = [tableview dequeueReusableCellWithIdentifier:@"ChoosePeopleCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ChoosePeopleCell" owner:nil options:nil] objectAtIndex:0];
    }
    if (!cell.cekBtn) {
#pragma 复选框
        cell.cekBtn = [[CKCheckBoxButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(cell.contentView.frame)-20, CGRectGetMidY(cell.contentView.frame), 23, 23)];
        [cell.contentView addSubview:cell.cekBtn];
        //cell.cekBtn.sd_layout.rightSpaceToView(cell.contentView, 15).centerYEqualToView(cell.headV).widthIs(23).heightIs(23);
        cell.cekBtn.rippleColor = [UIColor colorWithHexString:@"#DFEBFB"];
        cell.cekBtn.isOn = NO;
        cell.cekBtn.delegate = cell;
    }
    return cell;
}

#pragma CKCheckBoxButtondelegate
- (void)btnClicked:(CKCheckBoxButton *)btn{
    if (_delegate && [_delegate respondsToSelector:@selector(cellcekBtnClicked:indexPath:)]) {
        [_delegate cellcekBtnClicked:btn indexPath:self.thisIndexPath];
    }
}


- (void)setViewValues:(UserModel *)model{
    if (model.headimg) {
        [_headV setImageWithURL:[NSURL URLWithString:model.headimg] placeholderImage:[_headV defaultImageWithName:model.name]];
    }else{
        _headV.image = [_headV defaultImageWithName:model.name];
    }
    _headV.layer.cornerRadius = 19.5;
    _headV.layer.masksToBounds = true;
    
    _nameLab.text = model.name;
    _jobLab.text = model.usertype;
    _phoneLab.text = model.dn;
}

/**
 拨打电话

 @param sender sender
 */
- (IBAction)phoneBtnClicked:(id)sender {
    [MobClick event:@"userCallMobileClick"];
    
    NSMutableString* str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",self.phoneLab.text];
    // NSLog(@"str======%@",str);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}
@end
