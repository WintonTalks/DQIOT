//
//  ServiceBohuiView.m
//  WebThings
//
//  Created by machinsight on 2017/7/31.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "ServiceBohuiView.h"

@interface ServiceBohuiView()

@end

@implementation ServiceBohuiView
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"ServiceBohuiView" owner:self options:nil];
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"ServiceBohuiView" owner:self options:nil];
        [self setup];
    }
    return self;
}

- (void)setup{
    [self addSubview:self.contentView];
    self.contentView.frame = CGRectMake(0, 0, 245*autoSizeScaleX, 41);
}

- (void)awakeFromNib

{
    [super awakeFromNib];
    
    [[NSBundle mainBundle] loadNibNamed:@"ServiceBohuiView" owner:self options:nil];
    [self setup];
    
}

@end
