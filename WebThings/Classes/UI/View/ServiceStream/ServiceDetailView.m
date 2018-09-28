//
//  ServiceDetailView.m
//  WebThings
//
//  Created by machinsight on 2017/6/27.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "ServiceDetailView.h"
@interface ServiceDetailView()

@end

@implementation ServiceDetailView

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"ServiceDetailView" owner:self options:nil];
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
   
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"ServiceDetailView" owner:self options:nil];
        [self setup];
    }
    return self;
}

- (void)setup{
    [self addSubview:self.contentView];
    self.frame = CGRectMake(0, 0, 245*autoSizeScaleX, 32);
    self.contentView.frame = CGRectMake(0, 0, 245*autoSizeScaleX, 32);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [[NSBundle mainBundle] loadNibNamed:@"ServiceDetailView" owner:self options:nil];
    
    [self setup];
    
}


- (void)setViewValuesWithTitle:(NSString *)title WithContent:(NSString *)content{
    _titleLab.text = title;
    _contentLab.text = content;
}
@end
