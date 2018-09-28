//
//  HeadImgV.h
//  WebThings
//
//  Created by machinsight on 2017/7/3.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <UIKit/UIKit.h>
IB_DESIGNABLE
@interface HeadImgV : UIImageView
@property(nonatomic) IBInspectable CGFloat radius;
@property(null_unspecified, nonatomic) IBInspectable UIColor *borderColor;


/**
 根据首字母获取默认头像

 @param str 姓名
 @return 头像
 */
- (UIImage *_Nonnull)defaultImageWithName:(NSString *_Nonnull)str;
@end
