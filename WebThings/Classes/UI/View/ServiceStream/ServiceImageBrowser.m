//
//  ServiceImageBrowser.m
//  WebThings
//
//  Created by machinsight on 2017/7/1.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "ServiceImageBrowser.h"
#import "NSObject+JK.h"
#import "JKHUDManager.h"
#import "JKPhotoBrowser.h"
#import "JKViewController.h"

@interface ServiceImageBrowser()<JKPhotoManagerDelegate>
@property (nonatomic, copy) NSArray * imageModels;
@end
@implementation ServiceImageBrowser

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)setImgArrs:(NSArray *)imgArr {
    if (!_imgArr) {
        _imgArr = imgArr;
        [self setView];
        return;
    }
    if (_imgArr == imgArr) {
        return;
    } else {
        _imgArr = imgArr;
        for (UIView *item in self.subviews) {
            [item removeFromSuperview];
        }
        [self setView];
        return;
    }
    
}

- (void)setView {
    
    CGFloat margin = 5;
    CGFloat width = (self.frame.size.width - (margin * 4)) / 3;// 图片宽度 96
    CGFloat height = width*1.25;   // 图片高度

    NSMutableArray * mutArray = [NSMutableArray array];
    
    NSInteger count = _imgArr.count;
    for (NSInteger index = 0; index < count; index ++) {
        NSString * imageName = _imgArr[index];
        
        CGFloat x = (index%3)*width+((index%3)+1)*margin;
        CGFloat y = (index/3)*(height+margin) + 5;
        
        UIImageView * imageView = [[UIImageView alloc] init];
        if ([imageName hasPrefix:@"http"]) {
            [imageView setImageWithURL:[NSURL URLWithString:imageName] placeholderImage:[UIImage imageNamed:@"img_bill_default"]];
        } else {
            imageView.image = [UIImage imageNamed:imageName];
        }
        
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.tag = index + 1;
        [self addSubview:imageView];
        imageView.frame = CGRectMake(x, y, width, height);
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickedImageView:)];
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:tap];
        
        JKPhotoModel * model = [JKPhotoModel modelWithImageView:imageView
                                                    smallPicUrl:imageName
                                                           cell:nil
                                                    contentView:self];
        [mutArray addObject:model];
    }
    
    self.imageModels = mutArray.copy;
    
    CGRect rect = self.frame;
    rect.size.height = (ceilf(mutArray.count/3.0) * height) + (margin * (ceilf(mutArray.count/3.0) + 1));
    self.frame = rect;
}

- (CGFloat)getMaxHeight {
    CGFloat margin = 5;
    CGFloat width = (self.frame.size.width - (margin * 4)) / 3;// 图片宽度 96
    CGFloat height = width*1.25;   // 图片高度

    return (ceilf(self.imageModels.count/3.0) * height) +
    (margin * (ceilf(self.imageModels.count/3.0) + 1));
}

- (void)clickedImageView:(UITapGestureRecognizer *)tap {
    UIImageView * imageView = (UIImageView *)tap.view;
    JKPhotoBrowser().jk_itemArray = self.imageModels;
    JKPhotoBrowser().jk_currentIndex = imageView.tag - 1;
    JKPhotoBrowser().jk_showPageController = YES;
    //    JKPhotoBrowser().jk_hidesOriginalImageView = YES;
    [[JKPhotoManager sharedManager] jk_showPhotoBrowser];
    JKPhotoBrowser().jk_delegate = self;
    JKPhotoBrowser().jk_QRCodeRecognizerEnable = YES;
}

///**    返回占位图，一般是原来的小图    */
//- (UIImage *)jk_placeholderImageAtIndex:(NSInteger) index{
//    
//}

/**    返回大图URL    */
- (NSString *)jk_bigImageUrlAtIndex:(NSInteger) index{
    NSString *u = _imgArr[index];
    [u stringByReplacingOccurrencesOfString:@"/upload/" withString:@"/upload/compress"];
    return u;
}

@end
