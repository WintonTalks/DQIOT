//
//  ServiceTakePhotoCell.m
//  WebThings
//
//  Created by machinsight on 2017/6/30.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "ServiceTakePhotoCell.h"

@interface ServiceTakePhotoCell()
@property(nonatomic,strong)ImgButton *tjsjBtn;

@property (weak, nonatomic) IBOutlet UIView *lineV;
@end
@implementation ServiceTakePhotoCell

+ (id)cellWithTableView:(UITableView *)tableview{
    ServiceTakePhotoCell *cell = [tableview dequeueReusableCellWithIdentifier:@"ServiceTakePhotoCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ServiceTakePhotoCell" owner:nil options:nil] objectAtIndex:0];
        [cell setView];
    }else{
//        cell.tjsjBtn.sd_layout.widthIs(0);
    }
    
    return cell;
}


- (void)setView{
#pragma 添加报装资料按钮
    _tjsjBtn = [[ImgButton alloc] initWithFrame:CGRectMake(59, 0, 140, 31)];
    [_tjsjBtn setImg:[UIImage imageNamed:@"ic_photo"]];
    [_tjsjBtn addTarget:self action:@selector(newDriver:) forControlEvents:UIControlEventTouchUpInside];
    [_tjsjBtn setBackgroundColor:[UIColor colorWithHexString:@"#3E7ADE"]];
    [_tjsjBtn setRippleColor:[UIColor colorWithHexString:@"#417EE8" alpha:0.16]];
    [self.contentView addSubview:_tjsjBtn];
    [_tjsjBtn withRadius:2];
}

- (void)newDriver:(ImgButton *)sender{
    if ([_delegate respondsToSelector:@selector(takePhoto:)]) {
        [_delegate takePhoto:sender];
    }
}

- (void)setBtnTitle:(NSString *)title andTag:(NSInteger)tag {
    [_tjsjBtn setCk_title:title];
    _tjsjBtn.tag = tag;
}

- (void)setBtnWidth:(CGFloat)width{
    _tjsjBtn.sd_layout.widthIs(width);
}
- (void)setBtnImage:(NSString *)str{
    [_tjsjBtn setImg:[UIImage imageNamed:str]];
}
- (void)setBtnBgColor:(UIColor *)cor {
    [_tjsjBtn setBackgroundColor:cor];
}
- (void)setLineHide:(BOOL)hide{
    _lineV.hidden = hide;
    if (hide) {
//        _tjsjBtn.sd_layout.topSpaceToView(self.contentView, 30);
    }
}
@end
