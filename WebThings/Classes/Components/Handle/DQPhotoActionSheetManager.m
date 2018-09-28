//
//  DQPhotoActionSheetManager.m
//  WebThings
//
//  Created by Eugene on 10/19/17.
//  Copyright © 2017 machinsight. All rights reserved.
//

#import "DQPhotoActionSheetManager.h"
#import "ZLDefine.h"
#import "ZLPhotoActionSheet.h"
#import "DQBaseAPIInterface.h"


@interface DQPhotoActionSheetManager ()

@property (nonatomic, strong) NSMutableArray<PHAsset *> *lastSelectAssets;
@property (nonatomic, strong) NSMutableArray<UIImage *> *lastSelectPhotos;

@property (nonatomic, strong) ZLPhotoActionSheet *actionSheet;

@property (nonatomic, strong) UIViewController *viewController;

@end

@implementation DQPhotoActionSheetManager

//+ (instancetype)sharedManager {
//    static DQPhotoActionSheetManager * manager = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        manager = [[DQPhotoActionSheetManager alloc]init];
//    });
//    return manager;
//}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initActionSheet];
    }
    return self;
}

- (void)initActionSheet {
    
    ZLPhotoActionSheet *actionSheet = [[ZLPhotoActionSheet alloc] init];
    _actionSheet = actionSheet;
}

- (void)dq_showPhotoActionSheetWithController:(UIViewController *)viewController
                          showPreviewPhoto:(BOOL)isShow
                         didSelectedImages:(void(^)(NSArray<UIImage*>*))imageAry {
    
    [self dq_showPhotoActionSheetWithController:viewController showPreviewPhoto:YES maxSelectCount:kNUMBER_MAXPHOTO didSelectedImages:imageAry];
}

- (void)dq_showPhotoActionSheetWithController:(UIViewController *)viewController showPreviewPhoto:(BOOL)isShow maxSelectCount:(NSInteger)count didSelectedImages:(void (^)(NSArray<UIImage *> *))imageAry {
    
    _viewController = viewController;
    _actionSheet.sortAscending = NO;
    _actionSheet.allowSelectImage = YES;
    _actionSheet.allowSelectGif = NO;
    _actionSheet.allowSelectVideo = NO;
    _actionSheet.allowTakePhotoInLibrary = NO;
    //设置照片最大预览数
    _actionSheet.maxPreviewCount = 9;
    //设置照片最大选择数
    _actionSheet.maxSelectCount = count;
    //_actionSheet.cellCornerRadio = 0;
    _actionSheet.sender = viewController;
    
    NSMutableArray *arr = [NSMutableArray array];
    for (PHAsset *asset in self.lastSelectAssets) {
        if (asset.mediaType == PHAssetMediaTypeImage && ![[asset valueForKey:@"filename"] hasSuffix:@"GIF"]) {
            [arr addObject:asset];
        }
    }
    
    [_lastSelectPhotos removeAllObjects];
    
    // actionSheet.arrSelectedAssets = nil;
    weakify(self);
    [_actionSheet setSelectImageBlock:^(NSArray<UIImage *> * _Nonnull images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
        
        strongify(weakSelf);
        strongSelf.lastSelectAssets = assets.mutableCopy;
        strongSelf.lastSelectPhotos = images.mutableCopy;
        DQLog(@"\n ============== image:%@", images);
        
            // block 返回images
        imageAry(images);
        
    }];
    
    [self showPreviewPhoto:isShow];
}

- (void)showPreviewPhoto:(BOOL)isShow {
    
    if (isShow) {
        [_actionSheet showPreviewAnimated:YES];
    } else {
        [_actionSheet showPhotoLibrary];
    }
}

/** 上传图片到服务器，然后获取返回的图片网络路径 */
- (void)dq_uploadImageApi:(DQFinishedUpload)imageUrls {

    if (self.lastSelectPhotos.count == 0) {
        [self showMessage:@"请选择图片后重新上传"];
        return;
    }
    
    [[DQBaseAPIInterface sharedInstance]
     dq_uploadImage:self.lastSelectPhotos
     progress:^(CGFloat percent) {

     } success:^(DQResultModel *returnValue) {

         if ([returnValue isRequestSuccess]) {
             [MBProgressHUD hideAllHUDsForView:_viewController.view animated:YES];
             imageUrls(returnValue.imgpath);
         } else {
             [self showMessage:@"图片上传失败"];
         }

     } failture:^(NSError *error) {
         [MBProgressHUD hideAllHUDsForView:_viewController.view animated:YES];
     }];

}

- (void)showMessage:(NSString *)msg {
    
    [MBProgressHUD hideAllHUDsForView:_viewController.view animated:YES];
     MDSnackbar *bar = [[MDSnackbar alloc] initWithText:msg actionTitle:@"" duration:3.0];
    [bar show];
}

@end
