//
//  UIBarButtonItem+Extension.h
//  EMINest
//
//  Created by WongSuechang on 14-2-22.
//  Copyright (c) 2016年 emi365. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"

@implementation UIBarButtonItem (Extension)

+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(UIImage *)image {
    return [self itemWithTarget:target action:action nomalImage:image higeLightedImage:nil imageEdgeInsets:UIEdgeInsetsZero];
}

+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(UIImage *)image imageEdgeInsets:(UIEdgeInsets)imageEdgeInsets {
    return [self itemWithTarget:target action:action nomalImage:image higeLightedImage:nil imageEdgeInsets:imageEdgeInsets];
}

+ (UIBarButtonItem *)itemWithTarget:(id)target
                            action:(SEL)action
                        nomalImage:(UIImage *)nomalImage
                  higeLightedImage:(UIImage *)higeLightedImage
                   imageEdgeInsets:(UIEdgeInsets)imageEdgeInsets {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    [button setImage:[nomalImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    if (higeLightedImage) {
        [button setImage:higeLightedImage forState:UIControlStateHighlighted];
    }
    [button sizeToFit];
    if (button.bounds.size.width < 40) {
        CGFloat width = 40 / button.bounds.size.height * button.bounds.size.width;
        button.bounds = CGRectMake(0, 0, width, 40);
    }
    button.imageEdgeInsets = imageEdgeInsets;
    
//    if (@available(iOS 11.0,*)) {
       return [[UIBarButtonItem alloc] initWithCustomView:button];
//    } else {
//       return [[UIBarButtonItem alloc] initWithImage:nomalImage style:UIBarButtonItemStylePlain target:target action:action];
//    }
}

+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action title:(NSString *)title {
    return [self itemWithTarget:target action:action title:title font:nil titleColor:nil highlightedColor:nil titleEdgeInsets:UIEdgeInsetsZero];
}

+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action title:(NSString *)title titleEdgeInsets:(UIEdgeInsets)titleEdgeInsets {
    return [self itemWithTarget:target action:action title:title font:nil titleColor:nil highlightedColor:nil titleEdgeInsets:titleEdgeInsets];
}

+ (UIBarButtonItem *)itemWithTarget:(id)target
                            action:(SEL)action
                             title:(NSString *)title
                              font:(UIFont *)font
                        titleColor:(UIColor *)titleColor
                  highlightedColor:(UIColor *)highlightedColor
                   titleEdgeInsets:(UIEdgeInsets)titleEdgeInsets {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = font?font:[UIFont dq_boldSystemFontOfSize:14.0];
    [button setTitleColor:titleColor?titleColor:[UIColor colorWithHexString:@"#1D1D1D"] forState:UIControlStateNormal];
    [button setTitleColor:highlightedColor?highlightedColor:nil forState:UIControlStateHighlighted];
    
    [button sizeToFit];
    if (button.bounds.size.width < 40) {
        CGFloat width = 40 / button.bounds.size.height * button.bounds.size.width;
        button.bounds = CGRectMake(0, 0, width, 40);
    }
    button.titleEdgeInsets = titleEdgeInsets;
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

+ (UIBarButtonItem *)fixedSpaceWithWidth:(CGFloat)width {
    
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpace.width = width;
    return fixedSpace;
}

@end
