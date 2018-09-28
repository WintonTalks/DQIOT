//
//  ScheduleCardCell.m
//  WebThings
//
//  Created by machinsight on 2017/7/4.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "ScheduleCardCell.h"
@interface ScheduleCardCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UIImageView *finishImg;

@end
@implementation ScheduleCardCell

+ (id)cellWithTableView:(UITableView *)tableview{
    ScheduleCardCell *cell = [tableview dequeueReusableCellWithIdentifier:@"ScheduleCardCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ScheduleCardCell" owner:nil options:nil] objectAtIndex:0];
    }
    return cell;
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
            
            
            if (subView.subviews.count > 1) {
                // 这里是左边的编辑按钮
                UIView *shareConfirmationView = subView.subviews[1];
                shareConfirmationView.backgroundColor = [UIColor clearColor];
                //            for (UIView *shareView in shareConfirmationView.subviews) {
                UIImageView *shareImage = [[UIImageView alloc] init];
                shareImage.contentMode = UIViewContentModeScaleToFill;
                shareImage.image = [UIImage imageNamed:@"ic_create_bg"];
                
                shareImage.frame = CGRectMake(0, 0, shareConfirmationView.frame.size.width, shareConfirmationView.frame.size.height);
                [shareConfirmationView addSubview:shareImage];
                
                UIImageView *shareiconImage = [[UIImageView alloc] init];
                shareiconImage.contentMode = UIViewContentModeScaleAspectFit;
                shareiconImage.image = [UIImage imageNamed:@"ic_create"];
                [shareImage addSubview:shareiconImage];
                shareiconImage.sd_layout.heightIs(23).widthIs(23).centerXEqualToView(shareImage).centerYEqualToView(shareImage);
                //            }
            }
           
        }
    }
}


- (void)setViewValuesWithModel:(RemindModel *)model{
    _titleLab.text = model.msg;
    _timeLab.text = model.date;
    if ([model.isfinish isEqualToString:@"已完成"]) {
        _finishImg.hidden = NO;
    }else{
        _finishImg.hidden = YES;
    }
}
@end
