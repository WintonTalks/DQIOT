//
//  ServiceFinishedView.m
//  WebThings
//
//  Created by machinsight on 2017/6/27.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "ServiceFinishedLeftView.h"
@interface ServiceFinishedLeftView()
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIImageView *imgV;

@end

@implementation ServiceFinishedLeftView
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"ServiceFinishedLeftView" owner:self options:nil];
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"ServiceFinishedLeftView" owner:self options:nil];
        [self setup];
    }
    return self;
}

- (void)setup{
    [self addSubview:self.contentView];
    self.frame = CGRectMake(0, 0, 245*autoSizeScaleX, 41);
    self.contentView.frame = CGRectMake(0, 0, 245*autoSizeScaleX, 41);
}

- (void)awakeFromNib

{
    [super awakeFromNib];
    
    [[NSBundle mainBundle] loadNibNamed:@"ServiceFinishedLeftView" owner:self options:nil];
    [self setup];
    
}

- (void)setViewValuesWithModel:(ServiceCenterBaseModel *)model{
    _titleLab.text = model.title;
    
    if (model.enumstateid == 31) {
        _imgV.image = [UIImage imageNamed:@"ic_close_fuwu"];
        _titleLab.textColor = [UIColor colorWithHexString:@"#D93D2D"];
    }
}
@end
