//
//  leftFooterView.m
//  WebThings
//
//  Created by machinsight on 2017/6/27.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "leftFooterView.h"
@interface leftFooterView()

@end
@implementation leftFooterView
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"leftFooterView" owner:self options:nil];
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"leftFooterView" owner:self options:nil];
        [self setup];
    }
    return self;
}

- (void)setup{
    [self addSubview:self.contentView];
    self.frame = CGRectMake(0, 0, 245*autoSizeScaleX, 40);
    self.contentView.frame = CGRectMake(0, 0, 245*autoSizeScaleX, 40);
}

- (void)awakeFromNib

{
    [super awakeFromNib];
    
    [[NSBundle mainBundle] loadNibNamed:@"leftFooterView" owner:self options:nil];
    
    [self setup];
    
}


- (void)setViewValuesWithModel:(ServiceCenterBaseModel *)model{
    [_headImgV setImageWithURL:[NSURL URLWithString:appendUrl(imgUrl, model.sendheadimg)] placeholderImage:[_headImgV defaultImageWithName:model.sendname]];
    
    _nameLab.text = model.sendname;
    _positionLab.text = model.sendusertypename;
    _timeLab.text = [DateTools getpointerTimeStrWithFormat:@"yyyy/MM/dd HH:mm" WithOriginStr:model.sendtime WithOrignFormat:@"yyyy/MM/dd HH:mm:ss"];
}
@end
