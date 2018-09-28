//
//  ServiceTakePhotoCell.h
//  WebThings
//
//  Created by machinsight on 2017/6/30.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "EMINormalTableViewCell.h"
#import "ImgButton.h"
@class ServiceTakePhotoCell;
@protocol ServiceTakePhotoCellDelegate <NSObject>

- (void)takePhoto:(ImgButton *)btn;

@end
@interface ServiceTakePhotoCell : EMINormalTableViewCell

@property (nonatomic, weak) id<ServiceTakePhotoCellDelegate> delegate;


- (void)setBtnTitle:(NSString *)title andTag:(NSInteger)tag;

- (void)setBtnWidth:(CGFloat)width;

- (void)setBtnImage:(NSString *)str;

- (void)setBtnBgColor:(UIColor *)cor;

- (void)setLineHide:(BOOL)hide;
@end
