//
//  DQPhotoBrowseCollectionCell.m
//  WebThings
//
//  Created by Eugene on 10/19/17.
//  Copyright © 2017 machinsight. All rights reserved.
//

#import "DQPhotoBrowseCollectionCell.h"
@interface DQPhotoBrowseCollectionCell ()

@property (nonatomic, strong) UIButton *deleteBtn;

@end

@implementation DQPhotoBrowseCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        _imageView = [[UIImageView alloc] init];
        _imageView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        [self addSubview:_imageView];

        _deleteBtn = [[UIButton alloc] init];
        _deleteBtn.frame = CGRectMake(self.frame.size.width-15, 0, 15, 15);
        [_deleteBtn setImage:[UIImage imageNamed:@"ic_photo_del"] forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(deletePhotoClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_deleteBtn];
    }
    return self;
}

- (void)deletePhotoClick:(UIButton *)sender {
    
    if (self.deletePhotoBlock) {
        self.deletePhotoBlock();
    }
}

@end
