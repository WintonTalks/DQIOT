//
//  NewDriverCell.m
//  WebThings
//
//  Created by machinsight on 2017/6/22.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "NewDriverCell.h"
@interface NewDriverCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *rentType;
@property (weak, nonatomic) IBOutlet UILabel *gzLab;

@end
@implementation NewDriverCell

+ (id)cellWithTableView:(UITableView *)tableview{
    NewDriverCell *cell = [tableview dequeueReusableCellWithIdentifier:@"NewDriverCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"NewDriverCell" owner:nil options:nil] objectAtIndex:0];
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
            deleteConfirmationView.backgroundColor = [UIColor clearColor];

            UIImageView *deleteImage = [[UIImageView alloc] init];
            deleteImage.contentMode = UIViewContentModeScaleToFill;
            deleteImage.image = [UIImage imageNamed:@"ic_delete_bg"];
            
            deleteImage.frame = CGRectMake(0, 0, deleteConfirmationView.frame.size.width, deleteConfirmationView.frame.size.height);
            [deleteConfirmationView addSubview:deleteImage];
            
            UIImageView *deleteiconImage = [[UIImageView alloc] initWithFrame:CGRectMake((deleteImage.width-23)/2, (deleteImage.height-23)/2, 23, 23)];
            deleteiconImage.contentMode = UIViewContentModeScaleAspectFit;
            deleteiconImage.image = [UIImage imageNamed:@"ic_delete"];
            [deleteImage addSubview:deleteiconImage];
            
            // 这里是左边的编辑按钮
            UIView *shareConfirmationView = subView.subviews[1];
            shareConfirmationView.backgroundColor = [UIColor clearColor];
            //            for (UIView *shareView in shareConfirmationView.subviews) {
            UIImageView *shareImage = [[UIImageView alloc] init];
            shareImage.contentMode = UIViewContentModeScaleToFill;
            shareImage.image = [UIImage imageNamed:@"ic_create_bg"];
            shareImage.frame = CGRectMake(0, 0, shareConfirmationView.frame.size.width, shareConfirmationView.frame.size.height);
            [shareConfirmationView addSubview:shareImage];
            
            UIImageView *shareiconImage = [[UIImageView alloc] initWithFrame:CGRectMake((shareImage.width-23)/2, (shareImage.height-23)/2, 23, 23)];
            shareiconImage.contentMode = UIViewContentModeScaleAspectFit;
            shareiconImage.image = [UIImage imageNamed:@"ic_create"];
            [shareImage addSubview:shareiconImage];
        }
    }
}


- (void)setViewWithValues:(DriverModel *)m
{
    _nameLab.text = m.name;
    _rentType.text = [NSString stringWithFormat:@"工资类型：%@",m.renttype];
    _gzLab.text = [NSString stringWithFormat:@"%ld",(long)m.rent];
}
@end
