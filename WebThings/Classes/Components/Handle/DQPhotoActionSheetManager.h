//
//  DQPhotoActionSheetManager.h
//  WebThings
//
//  Created by Eugene on 10/19/17.
//  Copyright © 2017 machinsight. All rights reserved.
// ZLPhotoActionSheet 图片选择器的管理类

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

typedef void (^DQFinishedUpload) (NSArray *images);

@interface DQPhotoActionSheetManager : NSObject

/**
 * viewController : 需要显示photoActionSheet的当前类
 * @parma isShow YES弹出预览模式 当为NO时，直接进入相册
 * @parma count 照片最大选择数,默认为6张
 block回调选中图片
 */
- (void)dq_showPhotoActionSheetWithController:(UIViewController *)viewController
                         showPreviewPhoto:(BOOL)isShow
                         didSelectedImages:(void(^)(NSArray<UIImage*>*))imageAry;

/**
 * viewController : 需要显示photoActionSheet的当前类
 * @parma isShow YES弹出预览模式 当为NO时，直接进入相册
 * @parma count 设置照片最大选择数 默认为6张
 block回调选中图片
 */
- (void)dq_showPhotoActionSheetWithController:(UIViewController *)viewController
                             showPreviewPhoto:(BOOL)isShow
                               maxSelectCount:(NSInteger)count
                            didSelectedImages:(void(^)(NSArray<UIImage*>*))imageAry;

/**
 上传图片到服务器，然后获取返回的图片网络路径
 */
- (void)dq_uploadImageApi:(DQFinishedUpload)imageUrls;

@end
