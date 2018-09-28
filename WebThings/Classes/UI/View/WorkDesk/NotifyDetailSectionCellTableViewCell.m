//
//  NotifyDetailSectionCellTableViewCell.m
//  WebThings
//
//  Created by machinsight on 2017/7/5.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "NotifyDetailSectionCellTableViewCell.h"
#import "CKCheckBoxButton.h"
@interface NotifyDetailSectionCellTableViewCell()<CKCheckBoxButtonDelegate>
@property (nonatomic,strong)CKCheckBoxButton *cekBtn;/**< 多选框*/
@property (weak, nonatomic) IBOutlet UILabel *companyLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@end



@implementation NotifyDetailSectionCellTableViewCell

+ (id)cellWithTableView:(UITableView *)tableview{
    NotifyDetailSectionCellTableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:@"NotifyDetailSectionCellTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"NotifyDetailSectionCellTableViewCell" owner:nil options:nil] objectAtIndex:0];
    }
    if (!cell.cekBtn) {
#pragma 复选框
        cell.cekBtn = [[CKCheckBoxButton alloc] initWithFrame:CGRectMake(0, 0, 23, 23)];
        [cell.contentView addSubview:cell.cekBtn];
        cell.cekBtn.sd_layout.rightSpaceToView(cell.contentView, 15).centerYEqualToView(cell.contentView).widthIs(23).heightIs(23);
        cell.cekBtn.rippleColor = [UIColor colorWithHexString:@"#DFEBFB"];
        cell.cekBtn.isOn = YES;
        cell.cekBtn.hidden = YES;
        cell.cekBtn.delegate = cell;
    }
    return cell;
}

#pragma CKCheckBoxButtondelegate
- (void)btnClicked:(CKCheckBoxButton *)btn{
    
}


- (void)setCheckBtnHide:(BOOL)hide{
    _cekBtn.hidden = hide;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    for (UIView *subView in self.subviews) {
        if([subView isKindOfClass:NSClassFromString(@"UITableViewCellDeleteConfirmationView")]) {
            
            // 拿到subView之后再获取子控件
            subView.backgroundColor = [UIColor clearColor];
            // 因为上面删除按钮是第一个加的所以下标是0
            UIView *deleteConfirmationView = subView.subviews[0];
            //改背景颜色
            deleteConfirmationView.backgroundColor = [UIColor clearColor];
            //            for (UIView *deleteView in deleteConfirmationView.subviews) {
            //                NSLog(@"%@",deleteConfirmationView.subviews);
            UIImageView *deleteImage = [[UIImageView alloc] init];
            deleteImage.contentMode = UIViewContentModeScaleToFill;
            deleteImage.image = [UIImage imageNamed:@"ic_delete_bg"];
            
            deleteImage.frame = CGRectMake(0, 0, deleteConfirmationView.frame.size.width, deleteConfirmationView.frame.size.height);
            [deleteConfirmationView addSubview:deleteImage];
            
            UIImageView *deleteiconImage = [[UIImageView alloc] init];
            deleteiconImage.contentMode = UIViewContentModeScaleAspectFit;
            deleteiconImage.image = [UIImage imageNamed:@"ic_delete"];
            [deleteImage addSubview:deleteiconImage];
            deleteiconImage.sd_layout.heightIs(23).widthIs(23).centerXEqualToView(deleteImage).centerYEqualToView(deleteImage);
            //            }
            
        }
    }
}
@end
