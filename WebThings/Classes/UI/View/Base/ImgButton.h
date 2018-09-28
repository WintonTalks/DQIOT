//
//  ImgButton.h
//  WebThings
//
//  Created by machinsight on 2017/6/19.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
IB_DESIGNABLE
@interface ImgButton : UIControl
@property(null_unspecified, nonatomic) IBInspectable UIImage *img;
@property(null_unspecified, nonatomic) IBInspectable NSString *ck_title;
@property(nonatomic) IBInspectable UIColor *rippleColor;
@end
NS_ASSUME_NONNULL_END
