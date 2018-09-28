//
//  DQInfoPhotoCell.m
//  WebThings
//
//  Created by winton on 2017/10/30.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "DQInfoPhotoCell.h"

@implementation DQInfoPhotoCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        _picView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _picView.clipsToBounds = true;
        //  [_picView setContentScaleFactor:[[UIScreen mainScreen] scale]];
        _picView.contentMode =  UIViewContentModeScaleAspectFill;
        _picView.layer.masksToBounds = true;
        _picView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [self.contentView addSubview:_picView];
    }
    return self;
}

- (void)configMangerPhotoImageView:(id)image
{
    if ([image isKindOfClass:[UIImage class]]) {
        _picView.image = image;
    } else {
        NSString *urlString = [NSString stringWithFormat:@"%@",image];
        [_picView yy_setImageWithURL:ADDURL(urlString) options:0];
    }
    _picView.frame = self.contentView.bounds;
}

@end
