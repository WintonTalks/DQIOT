//
//  WorkDeskBaseCell.m
//  WebThings
//
//  Created by machinsight on 2017/8/9.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "WorkDeskBaseCell.h"


@implementation WorkDeskBaseCell

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


- (CGFloat)cellCloseHeight{
    return 86.f;
}
@end
