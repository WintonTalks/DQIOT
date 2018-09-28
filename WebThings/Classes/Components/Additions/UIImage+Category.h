//
//  UIImage+Category.h
//  WebThings
//
//  Created by Eugene on 2017/9/19.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Category)

/**
 *  返回一张可以随意拉伸不变形的图片
 *  @param name 图片名字
 */
+ (UIImage *)stretchableImageWithImgae:(NSString *)name;

/**
 * 压缩图片至指定大小
 */
+ (UIImage *)dq_compressImage:(UIImage *)image toByte:(NSUInteger)maxLength;


@end
