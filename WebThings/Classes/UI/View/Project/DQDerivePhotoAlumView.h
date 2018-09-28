//
//  DQDerivePhotoAlumView.h
//  WebThings
//
//  Created by winton on 2017/10/16.
//  Copyright © 2017年 machinsight. All rights reserved.
//  项目管理-资质认证cell 图片view

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DQDerivePhotoAlumType) {
    KDQDerivePhotoAlumLeftStyle, //资质认证左对齐
    KDQDerivePhotoAlumRightStyle //项目管理右对齐
};

@interface DQDerivePhotoAlumView : UIView
@property (nonatomic, assign) NSIndexPath *indexPath;
- (instancetype)initWithFrame:(CGRect)frame
                         type:(DQDerivePhotoAlumType)type;
//引导进来的相册图片，多张/单张
- (void)configAlubmPhoto:(NSArray *)listArray;
@end

