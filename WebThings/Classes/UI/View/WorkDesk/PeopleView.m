//
//  PeopleView.m
//  WebThings
//
//  Created by machinsight on 2017/8/9.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "PeopleView.h"

@implementation PeopleView

//- (instancetype)initWithCoder:(NSCoder *)aDecoder{
//    self = [super initWithCoder:aDecoder];
//    if (self) {
//        [[NSBundle mainBundle] loadNibNamed:@"PeopleView" owner:self options:nil];
//        [self setup];
//    }
//    return self;
//}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"PeopleView" owner:self options:nil];
        [self setup];
    }
    return self;
}



- (void)awakeFromNib

{
    [super awakeFromNib];
    
    [[NSBundle mainBundle] loadNibNamed:@"PeopleView" owner:self options:nil];
    
    [self setup];
    
}


- (void)setup{
    [self addSubview:self.contentView];
    self.frame = CGRectMake(0, 0, screenWidth-16, 68);
    self.contentView.frame = CGRectMake(0, 0, screenWidth-16, 68);
    
}

- (void)setViewValuesWithModel:(UserModel *)model{
    if ([model.confirmresult isEqualToString:@"已完成"]) {
        _ywcImgV.hidden = NO;
    }else{
        _ywcImgV.hidden = YES;
    }
    if (model.headimg) {
        [_headImgV setImageWithURL:[NSURL URLWithString:model.headimg] placeholderImage:[_headImgV defaultImageWithName:model.name]];
    }else{
        _headImgV.image = [_headImgV defaultImageWithName:model.name];
    }
    
    
    _nameLab.text = model.name;
    _jobLab.text = model.usertype;
    _dnLab.text = model.dn;
    
    if ([model.isread isEqualToString:@"已读"]) {
        _ydImgV.image = [UIImage imageNamed:@"ic_yidu"];
    }else{
        _ydImgV.image = [UIImage imageNamed:@"ic_weidu"];
    }
}
@end
