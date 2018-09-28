//
//  ZLPhotoActionSheet.m
//  多选相册照片
//
//  Created by long on 15/11/25.
//  Copyright © 2015年 long. All rights reserved.
//

#import "ZLPhotoActionSheet.h"
#import <Photos/Photos.h>
#import "ZLCollectionCell.h"
#import "ZLDefine.h"
#import "ZLPhotoModel.h"
#import "ZLPhotoManager.h"
#import "ZLPhotoBrowser.h"
#import "ZLShowBigImgViewController.h"
#import "ZLThumbnailViewController.h"
#import "ZLNoAuthorityViewController.h"
#import "ToastUtils.h"
#import <objc/runtime.h>
#import "ZLShowGifViewController.h"
#import "ZLShowVideoViewController.h"
#import "ZLCollectionCellLayout.h"

#define kBaseViewHeight (self.maxPreviewCount ? 300 : 142)

double const ScalePhotoWidth = 1000;

@interface ZLPhotoActionSheet () <ZLCollectionCellLayoutDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate, PHPhotoLibraryChangeObserver, CAAnimationDelegate>//UICollectionViewDelegateFlowLayout

@property (weak, nonatomic) IBOutlet UIButton *btnCamera;
@property (weak, nonatomic) IBOutlet UIButton *btnAblum;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UIView *baseView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verColHeight;
@property (weak, nonatomic) IBOutlet UIView *btnFinishFatherView;
@property (weak, nonatomic) IBOutlet UIButton *btnFinish;

@property (weak, nonatomic) IBOutlet UIView *photoFatherView;

@property (nonatomic, assign) BOOL animate;
@property (nonatomic, assign) BOOL preview;

@property (nonatomic, strong) NSMutableArray<ZLPhotoModel *> *arrDataSources;

@property (nonatomic, copy) NSMutableArray<ZLPhotoModel *> *arrSelectedModels;

@property (nonatomic, assign) BOOL isSelectOriginalPhoto;
@property (nonatomic, assign) UIStatusBarStyle previousStatusBarStyle;
@property (nonatomic, assign) BOOL senderTabBarIsShow;
@property (nonatomic, strong) UILabel *placeholderLabel;


@property(nonatomic,assign)NSInteger needScaleFlag;
@end

@implementation ZLPhotoActionSheet

- (void)dealloc
{
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}

- (NSMutableArray<ZLPhotoModel *> *)arrDataSources
{
    if (!_arrDataSources) {
        _arrDataSources = [NSMutableArray array];
    }
    return _arrDataSources;
}

- (NSMutableArray<ZLPhotoModel *> *)arrSelectedModels
{
    if (!_arrSelectedModels) {
        _arrSelectedModels = [NSMutableArray array];
    }
    return _arrSelectedModels;
}

- (UILabel *)placeholderLabel
{
    if (!_placeholderLabel) {
        _placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kViewWidth, 100)];
        _placeholderLabel.text = GetLocalLanguageTextValue(ZLPhotoBrowserNoPhotoText);
        _placeholderLabel.textAlignment = NSTextAlignmentCenter;
        _placeholderLabel.textColor = [UIColor darkGrayColor];
        _placeholderLabel.font = [UIFont systemFontOfSize:15];
        _placeholderLabel.center = self.collectionView.center;
        [self.collectionView addSubview:_placeholderLabel];
        _placeholderLabel.hidden = YES;
    }
    return _placeholderLabel;
}

- (void)setArrSelectedAssets:(NSMutableArray<PHAsset *> *)arrSelectedAssets
{
    _arrSelectedAssets = arrSelectedAssets;
    [self.arrSelectedModels removeAllObjects];
    for (PHAsset *asset in arrSelectedAssets) {
        if (asset.mediaType != PHAssetMediaTypeImage) {
            //选择的视频和gif不做保存
            continue;
        }
        ZLPhotoModel *model = [ZLPhotoModel modelWithAsset:asset type:ZLAssetMediaTypeImage duration:nil];
        model.isSelected = YES;
        [self.arrSelectedModels addObject:model];
    }
}

- (instancetype)init
{
    self = [[kZLPhotoBrowserBundle loadNibNamed:@"ZLPhotoActionSheet" owner:self options:nil] lastObject];
    if (self) {
//        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//        layout.minimumInteritemSpacing = 3;
//        layout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5);
        ZLCollectionCellLayout *layout = [[ZLCollectionCellLayout alloc] init];
        layout.zldelegate = self;
        self.collectionView.collectionViewLayout = layout;
        self.collectionView.backgroundColor = [UIColor whiteColor];
        [self.collectionView registerClass:NSClassFromString(@"ZLCollectionCell") forCellWithReuseIdentifier:@"ZLCollectionCell"];
        self.collectionView.frame = CGRectMake(0, 3, screenWidth, 150);
        self.maxSelectCount = 10;
        self.maxPreviewCount = 20;
        self.cellCornerRadio = .0;
        self.allowSelectImage = YES;
        self.allowSelectVideo = YES;
        self.allowSelectGif = YES;
        self.allowTakePhotoInLibrary = YES;
        self.sortAscending = YES;
        
        if (![self judgeIsHavePhotoAblumAuthority]) {
            //注册实施监听相册变化
            [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
        }
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
//    [self.btnCamera setTitle:GetLocalLanguageTextValue(ZLPhotoBrowserCameraText) forState:UIControlStateNormal];
//    [self.btnAblum setTitle:GetLocalLanguageTextValue(ZLPhotoBrowserAblumText) forState:UIControlStateNormal];
    [self.btnCancel setTitle:GetLocalLanguageTextValue(ZLPhotoBrowserCancelText) forState:UIControlStateNormal];
    [self resetSubViewState];
}

//相册变化回调
- (void)photoLibraryDidChange:(PHChange *)changeInstance
{
    dispatch_sync(dispatch_get_main_queue(), ^{
        if (self.preview) {
            [self loadPhotoFromAlbum];
            [self show];
        } else {
            [self btnPhotoLibrary_Click:nil];
        }
        [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
    });
}

- (void)showPreviewAnimated:(BOOL)animate sender:(UIViewController *)sender
{
    self.sender = sender;
    [self showPreviewAnimated:animate];
}

- (void)showPreviewAnimated:(BOOL)animate
{
    [self showPreview:YES animate:animate];
}

- (void)showPhotoLibraryWithSender:(UIViewController *)sender
{
    self.sender = sender;
    [self showPhotoLibrary];
}

- (void)showPhotoLibrary
{
    [self showPreview:NO animate:NO];
}

- (void)showPreview:(BOOL)preview animate:(BOOL)animate
{
    if (!self.allowSelectImage && self.arrSelectedModels.count) {
        [self.arrSelectedAssets removeAllObjects];
        [self.arrSelectedModels removeAllObjects];
    }
    self.animate = animate;
    self.preview = preview;
    self.previousStatusBarStyle = [UIApplication sharedApplication].statusBarStyle;
    
    [ZLPhotoManager setSortAscending:self.sortAscending];
    
    if (!self.maxPreviewCount) {
        self.verColHeight.constant = .0;
    }
    
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted ||
        status == PHAuthorizationStatusDenied) {
        [self showNoAuthorityVC];
    } else if (status == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            
        }];
    }
    
    [self addAssociatedOnSender];
    if (preview) {
        if (status == PHAuthorizationStatusAuthorized) {
            [self loadPhotoFromAlbum];
            [self show];
        } else if (status == PHAuthorizationStatusRestricted ||
                   status == PHAuthorizationStatusDenied) {
            [self showNoAuthorityVC];
        }
    } else {
        if (status == PHAuthorizationStatusAuthorized) {
            [self btnPhotoLibrary_Click:nil];
        } else if (status == PHAuthorizationStatusRestricted ||
                   status == PHAuthorizationStatusDenied) {
            [self showNoAuthorityVC];
        }
    }
}

- (void)previewSelectedPhotos:(NSArray<UIImage *> *)photos assets:(NSArray<PHAsset *> *)assets index:(NSInteger)index
{
    [self addAssociatedOnSender];
    
    self.arrSelectedAssets = [NSMutableArray arrayWithArray:assets];
    ZLShowBigImgViewController *svc = [[ZLShowBigImgViewController alloc] init];
    ZLImageNavigationController *nav = [self getImageNavWithRootVC:svc];
    svc.selectIndex = index;
    svc.arrSelPhotos = [NSMutableArray arrayWithArray:photos];
    svc.models = self.arrSelectedModels;
    weakify(self);
    __weak typeof(nav) weakNav = nav;
    [svc setBtnDonePreviewBlock:^(NSArray<UIImage *> *photos, NSArray<PHAsset *> *assets) {
        strongify(weakSelf);
        __strong typeof(weakNav) strongNav = weakNav;
        if (strongSelf.selectImageBlock) {
            strongSelf.selectImageBlock(photos, assets, NO);
        }
        [strongNav dismissViewControllerAnimated:YES completion:nil];
    }];
    [self.sender showDetailViewController:nav sender:nil];
}

static char RelatedKey;
- (void)addAssociatedOnSender
{
    BOOL selfInstanceIsClassVar = NO;
    unsigned int count = 0;
    Ivar *vars = class_copyIvarList(self.sender.class, &count);
    for (int i = 0; i < count; i++) {
        Ivar var = vars[i];
        const char * type = ivar_getTypeEncoding(var);
        NSString *className = [NSString stringWithUTF8String:type];
        if ([className isEqualToString:[NSString stringWithFormat:@"@\"%@\"", NSStringFromClass(self.class)]]) {
            selfInstanceIsClassVar = YES;
        }
    }
    if (!selfInstanceIsClassVar) {
        objc_setAssociatedObject(self.sender, &RelatedKey, self, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

#pragma mark - 判断软件是否有相册、相机访问权限
- (BOOL)judgeIsHavePhotoAblumAuthority
{
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusAuthorized) {
        return YES;
    }
    return NO;
}

- (BOOL)judgeIsHaveCameraAuthority
{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusRestricted ||
        status == AVAuthorizationStatusDenied) {
        return NO;
    }
    return YES;
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:GetLocalLanguageTextValue(ZLPhotoBrowserOKText) style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:action];
    [self.sender presentViewController:alert animated:YES completion:nil];
}

- (void)loadPhotoFromAlbum
{
    [self.arrDataSources removeAllObjects];
    //因为预览界面需快速选择最近图片，所以不受self.sortAscending限制，
    [self.arrDataSources addObjectsFromArray:[ZLPhotoManager getAllAssetInPhotoAlbumWithAscending:NO limitCount:self.maxPreviewCount allowSelectVideo:self.allowSelectVideo allowSelectImage:self.allowSelectImage allowSelectGif:YES]];
    [ZLPhotoManager markSelcectModelInArr:self.arrDataSources selArr:self.arrSelectedModels];
    [self.collectionView reloadData];
}

#pragma mark - 显示隐藏视图及相关动画
- (void)resetSubViewState
{
    self.hidden = NO;
    self.baseView.hidden = NO;
    [self changeFinishBtnTitle];
    [self.collectionView setContentOffset:CGPointZero];
}

- (void)show
{
    self.frame = self.sender.view.bounds;
    [self.sender.view addSubview:self];
    if (self.sender.tabBarController.tabBar.hidden == NO) {
        self.senderTabBarIsShow = YES;
        self.sender.tabBarController.tabBar.hidden = YES;
    }
    
    if (self.animate) {
        __block CGRect frame = self.baseView.frame;
        frame.origin.y += kBaseViewHeight;
        self.baseView.frame = frame;
        [UIView animateWithDuration:0.2 animations:^{
            frame.origin.y -= kBaseViewHeight;
            self.baseView.frame = frame;
        } completion:nil];
    }
}

- (void)hide
{
    if (self.animate) {
        __block CGRect frame = self.baseView.frame;
        frame.origin.y += kBaseViewHeight;
        [UIView animateWithDuration:0.2 animations:^{
            self.baseView.frame = frame;
        } completion:^(BOOL finished) {
            self.hidden = YES;
            [self removeFromSuperview];
        }];
    } else {
        self.hidden = YES;
        [self removeFromSuperview];
    }
    if (self.senderTabBarIsShow) {
        self.sender.tabBarController.tabBar.hidden = NO;
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    self.hidden = YES;
    [self removeFromSuperview];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self hide];
}

#pragma mark - UIButton Action
- (IBAction)btnCamera_Click:(id)sender
{
    if (![self judgeIsHaveCameraAuthority]) {
        NSString *message = [NSString stringWithFormat:GetLocalLanguageTextValue(ZLPhotoBrowserNoCameraAuthorityText), [[NSBundle mainBundle].infoDictionary valueForKey:(__bridge NSString *)kCFBundleNameKey]];
        [self showAlertWithTitle:nil message:message];
        [self hide];
        return;
    }
    //拍照
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = NO;
        picker.videoQuality = UIImagePickerControllerQualityTypeLow;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self.sender presentViewController:picker animated:YES completion:nil];
    }
}

- (IBAction)btnPhotoLibrary_Click:(id)sender
{
    if (![self judgeIsHavePhotoAblumAuthority]) {
        [self showNoAuthorityVC];
    } else {
        self.animate = NO;
        [self pushThumbnailViewController];
    }
}

- (IBAction)btnCancel_Click:(id)sender
{
//    if (self.arrSelectedModels.count) {
//        [self requestSelPhotos:nil];
//        return;
//    }
    [self hide];
}
- (IBAction)btnFinish_Click:(id)sender {
    [self requestSelPhotos:nil];
}

- (void)changeFinishBtnTitle
{
    if (self.arrSelectedModels.count > 0) {
        [self.btnFinish setTitle:[NSString stringWithFormat:@"%@(%ld)", @"完成", self.arrSelectedModels.count] forState:UIControlStateNormal];
        
    }
}

#pragma mark - 请求所选择图片、回调
- (void)requestSelPhotos:(UIViewController *)vc
{
    ZLProgressHUD *hud = [[ZLProgressHUD alloc] init];
    [hud show];
    
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:self.arrSelectedModels.count];
    NSMutableArray *assets = [NSMutableArray arrayWithCapacity:self.arrSelectedModels.count];
    for (int i = 0; i < self.arrSelectedModels.count; i++) {
        [photos addObject:@""];
        [assets addObject:@""];
    }
    
    weakify(self);
    for (int i = 0; i < self.arrSelectedModels.count; i++) {
        ZLPhotoModel *model = self.arrSelectedModels[i];
        [ZLPhotoManager requestSelectedImageForAsset:model isOriginal:self.isSelectOriginalPhoto completion:^(UIImage *image, NSDictionary *info) {
            if ([[info objectForKey:PHImageResultIsDegradedKey] boolValue]) return;
            
            strongify(weakSelf);
            if (image) {
                [photos replaceObjectAtIndex:i withObject:[self scaleImage:image]];
                [assets replaceObjectAtIndex:i withObject:model.asset];
            }
            
            for (id obj in photos) {
                if ([obj isKindOfClass:[NSString class]]) return;
            }
            
            [hud hide];
            if (strongSelf.selectImageBlock) {
                strongSelf.selectImageBlock(photos, assets, strongSelf.isSelectOriginalPhoto);
            }
            [strongSelf hide];
            [vc dismissViewControllerAnimated:YES completion:nil];
        }];
    }
}

/**
 * @brief 这里对拿到的图片进行缩放，不然原图直接返回的话会造成内存暴涨
 */
- (UIImage *)scaleImage:(UIImage *)image
{
    CGSize size = CGSizeMake(ScalePhotoWidth, ScalePhotoWidth * image.size.height / image.size.width);
    if (image.size.width < size.width
        ) {
        return image;
    }
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - UICollectionDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.arrDataSources.count == 0) {
        self.placeholderLabel.hidden = NO;
    } else {
        self.placeholderLabel.hidden = YES;
    }
    return self.arrDataSources.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZLCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZLCollectionCell" forIndexPath:indexPath];
    [cell addBtnSelect];
    ZLPhotoModel *model = self.arrDataSources[indexPath.row];
    if (self.arrSelectedModels.count > 0) {
        cell.btnSelect.hidden = NO;
        self.btnFinishFatherView.hidden = NO;
        self.photoFatherView.hidden = YES;
    }else{
        cell.btnSelect.hidden = YES;
        self.btnFinishFatherView.hidden = YES;
        self.photoFatherView.hidden = NO;
    }
    weakify(self);
    __weak typeof(cell) weakCell = cell;
    cell.selectedBlock = ^(BOOL selected) {
        strongify(weakSelf);
        __strong typeof(weakCell) strongCell = weakCell;
        if (!selected) {
            //选中
            if (strongSelf.arrSelectedModels.count >= strongSelf.maxSelectCount) {
                ShowToastLong(GetLocalLanguageTextValue(ZLPhotoBrowserMaxSelectCountText), strongSelf.maxSelectCount);
                return;
            }
            if (![ZLPhotoManager judgeAssetisInLocalAblum:model.asset]) {
                ShowToastLong(@"%@", GetLocalLanguageTextValue(ZLPhotoBrowseriCloudPhotoText));
                return;
            }
            model.isSelected = YES;
            [strongSelf.arrSelectedModels addObject:model];
            if (strongSelf.arrSelectedModels.count == 1) {
                strongSelf.needScaleFlag = 1;//放大
                [strongSelf setAnchorPoint:CGPointMake(0, 0) forView:strongSelf.collectionView];
                [UIView animateWithDuration:0.3 animations:^{
                    strongSelf.collectionView.transform = CGAffineTransformMakeScale(1.276,1.276);
                } completion:^(BOOL finished) {
                    [strongSelf setDefaultAnchorPointforView:strongSelf.collectionView];
                }];
            }
            else{
                strongSelf.needScaleFlag = 0;
            }
            strongCell.btnSelect.selected = YES;
        } else {
            strongCell.btnSelect.selected = NO;
            model.isSelected = NO;
            for (ZLPhotoModel *m in strongSelf.arrSelectedModels) {
                if ([m.asset.localIdentifier isEqualToString:model.asset.localIdentifier]) {
                    [strongSelf.arrSelectedModels removeObject:m];
                    break;
                }
            }
            if (strongSelf.arrSelectedModels.count == 0) {
                strongSelf.needScaleFlag = 2;//缩小
                [strongSelf setAnchorPoint:CGPointMake(0, 0) forView:strongSelf.collectionView];
                [UIView animateWithDuration:0.3 animations:^{
                    strongSelf.collectionView.transform = CGAffineTransformMakeScale(1,1);
                } completion:^(BOOL finished) {
                    [strongSelf setDefaultAnchorPointforView:strongSelf.collectionView];
                }];
            }
            else{
                strongSelf.needScaleFlag = 0;
            }
        }
        [strongSelf changeFinishBtnTitle];
        [strongSelf.collectionView reloadData];
//        [collectionView reloadItemsAtIndexPaths:[collectionView indexPathsForVisibleItems]];
    };
    
    cell.isSelectedImage = ^BOOL() {
        strongify(weakSelf);
        return strongSelf.arrSelectedModels.count > 0;
    };
    cell.allSelectGif = self.allowSelectGif;
    cell.cornerRadio = self.cellCornerRadio;
    cell.model = model;
    
    return cell;
}
- (NSInteger)needScale{
    return _needScaleFlag;
}
#pragma mark - ZLCollectionCellDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZLPhotoModel *model = self.arrDataSources[indexPath.row];
    return [self getSizeWithAsset:model.asset];
}

//#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    ZLPhotoModel *model = self.arrDataSources[indexPath.row];
    if (model.type == ZLAssetMediaTypeVideo) {
        if (self.arrSelectedModels.count > 0) {
            ShowToastLong(@"%@", [NSBundle zlLocalizedStringForKey:ZLPhotoBrowserCannotSelectVideo]);
            return;
        }
        //跳转预览视频
        [self pushVideoViewControllerWithModel:model];
    } else if (self.allowSelectGif && model.type == ZLAssetMediaTypeGif) {
        if (self.arrSelectedModels.count > 0) {
            ShowToastLong(@"%@", [NSBundle zlLocalizedStringForKey:ZLPhotoBrowserCannotSelectGIF]);
            return;
        }
        //跳转预览GIF
        [self pushGifViewControllerWithModel:model];
    } else {
        NSArray *arr = [ZLPhotoManager getAllAssetInPhotoAlbumWithAscending:self.sortAscending limitCount:NSIntegerMax allowSelectVideo:NO allowSelectImage:self.allowSelectImage allowSelectGif:!self.allowSelectGif];
        
        NSMutableArray *selIdentifiers = [NSMutableArray array];
        for (ZLPhotoModel *m in self.arrSelectedModels) {
            [selIdentifiers addObject:m.asset.localIdentifier];
        }
        
        int i = 0;
        BOOL isFind = NO;
        for (ZLPhotoModel *m in arr) {
            if ([m.asset.localIdentifier isEqualToString:model.asset.localIdentifier]) {
                isFind = YES;
            }
            if ([selIdentifiers containsObject:m.asset.localIdentifier]) {
                m.isSelected = YES;
            }
            if (!isFind) {
                i++;
            }
        }
        
        [self pushBigImageViewControllerWithModels:arr index:i];
    }
     */
    ZLCollectionCell *cell = (ZLCollectionCell *)[self collectionView:collectionView cellForItemAtIndexPath:indexPath];
    ZLPhotoModel *model = self.arrDataSources[indexPath.row];
    weakify(self);
    __weak typeof(cell) weakCell = cell;
    [cell setBlockWithClick:^(BOOL selected) {
        strongify(weakSelf);
        __strong typeof(weakCell) strongCell = weakCell;
        if (!selected) {
            //选中
            if (strongSelf.arrSelectedModels.count >= strongSelf.maxSelectCount) {
                ShowToastLong(GetLocalLanguageTextValue(ZLPhotoBrowserMaxSelectCountText), strongSelf.maxSelectCount);
                return;
            }
            if (![ZLPhotoManager judgeAssetisInLocalAblum:model.asset]) {
                ShowToastLong(@"%@", GetLocalLanguageTextValue(ZLPhotoBrowseriCloudPhotoText));
                return;
            }
            
            model.isSelected = YES;
            [strongSelf.arrSelectedModels addObject:model];
            if (strongSelf.arrSelectedModels.count == 1) {
                strongSelf.needScaleFlag = 1;//放大
                [strongSelf setAnchorPoint:CGPointMake(0, 0) forView:strongSelf.collectionView];
                [UIView animateWithDuration:0.3 animations:^{
                    strongSelf.collectionView.transform = CGAffineTransformMakeScale(1.276,1.276);
                } completion:^(BOOL finished) {
                    [strongSelf setDefaultAnchorPointforView:strongSelf.collectionView];
                }];
            }
            else{
                strongSelf.needScaleFlag = 0;
            }
            strongCell.btnSelect.selected = YES;
        } else {
            strongCell.btnSelect.selected = NO;
            model.isSelected = NO;
            for (ZLPhotoModel *m in strongSelf.arrSelectedModels) {
                if ([m.asset.localIdentifier isEqualToString:model.asset.localIdentifier]) {
                    [strongSelf.arrSelectedModels removeObject:m];
                    break;
                }
            }
            if (strongSelf.arrSelectedModels.count == 0) {
                strongSelf.needScaleFlag = 2;//缩小
                [strongSelf setAnchorPoint:CGPointMake(0, 0) forView:strongSelf.collectionView];
                [UIView animateWithDuration:0.3 animations:^{
                    strongSelf.collectionView.transform = CGAffineTransformMakeScale(1,1);
                } completion:^(BOOL finished) {
                    [strongSelf setDefaultAnchorPointforView:strongSelf.collectionView];
                }];
            }
            else{
                strongSelf.needScaleFlag = 0;
            }
        }
        [strongSelf changeFinishBtnTitle];
        //        [collectionView reloadItemsAtIndexPaths:[collectionView indexPathsForVisibleItems]];
    }];
    [self.collectionView reloadData];
}

#pragma mark - 显示无权限视图
- (void)showNoAuthorityVC
{
    //无相册访问权限
    ZLNoAuthorityViewController *nvc = [[ZLNoAuthorityViewController alloc] initWithNibName:@"ZLNoAuthorityViewController" bundle:kZLPhotoBrowserBundle];
    [self.sender showDetailViewController:[self getImageNavWithRootVC:nvc] sender:nil];
}

- (ZLImageNavigationController *)getImageNavWithRootVC:(UIViewController *)rootVC
{
    ZLImageNavigationController *nav = [[ZLImageNavigationController alloc] initWithRootViewController:rootVC];
    nav.previousStatusBarStyle = self.previousStatusBarStyle;
    nav.maxSelectCount = self.maxSelectCount;
    nav.cellCornerRadio = self.cellCornerRadio;
    nav.allowSelectVideo = self.allowSelectVideo;
    nav.allowSelectImage = self.allowSelectImage;
    nav.allowSelectGif = self.allowSelectGif;
    nav.allowTakePhotoInLibrary = self.allowTakePhotoInLibrary;
    nav.sortAscending = self.sortAscending;
    nav.isSelectOriginalPhoto = self.isSelectOriginalPhoto;
    [nav.arrSelectedModels removeAllObjects];
    [nav.arrSelectedModels addObjectsFromArray:self.arrSelectedModels];
    
    weakify(self);
    __weak typeof(nav) weakNav = nav;
    [nav setCallSelectImageBlock:^{
        strongify(weakSelf);
        __strong typeof(weakNav) strongNav = weakNav;
        strongSelf.isSelectOriginalPhoto = strongNav.isSelectOriginalPhoto;
        [strongSelf.arrSelectedModels removeAllObjects];
        [strongSelf.arrSelectedModels addObjectsFromArray:strongNav.arrSelectedModels];
        [strongSelf requestSelPhotos:strongNav];
    }];
    [nav setCallSelectGifBlock:^(UIImage *gif, PHAsset *asset) {
        strongify(weakSelf);
        __strong typeof(weakNav) strongNav = weakNav;
        if (strongSelf.selectGifBlock) {
            strongSelf.selectGifBlock(gif, asset);
        }
        [strongSelf hide];
        [strongNav dismissViewControllerAnimated:YES completion:nil];
    }];
    [nav setCallSelectVideoBlock:^(UIImage *coverImage, PHAsset *asset) {
        strongify(weakSelf);
        __strong typeof(weakNav) strongNav = weakNav;
        if (strongSelf.selectVideoBlock) {
            strongSelf.selectVideoBlock(coverImage, asset);
        }
        [strongSelf hide];
        [strongNav dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [nav setCancelBlock:^{
        strongify(weakSelf);
        [strongSelf hide];
    }];
    
    return nav;
}

//预览界面
- (void)pushThumbnailViewController
{
    ZLPhotoBrowser *photoBrowser = [[ZLPhotoBrowser alloc] init];
    ZLImageNavigationController *nav = [self getImageNavWithRootVC:photoBrowser];
    ZLThumbnailViewController *tvc = [[ZLThumbnailViewController alloc] initWithNibName:@"ZLThumbnailViewController" bundle:kZLPhotoBrowserBundle];
    ZLAlbumListModel *m = [ZLPhotoManager getCameraRollAlbumList:self.allowSelectVideo allowSelectImage:self.allowSelectImage];
    tvc.albumListModel = m;
    [nav pushViewController:tvc animated:YES];
    [self.sender showDetailViewController:nav sender:nil];
}

//查看大图界面
- (void)pushBigImageViewControllerWithModels:(NSArray<ZLPhotoModel *> *)models index:(NSInteger)index
{
    ZLShowBigImgViewController *svc = [[ZLShowBigImgViewController alloc] init];
    ZLImageNavigationController *nav = [self getImageNavWithRootVC:svc];
    
    svc.models = models;
    svc.selectIndex = index;
    weakify(self);
    [svc setBtnBackBlock:^(NSArray<ZLPhotoModel *> *selectedModels, BOOL isOriginal) {
        strongify(weakSelf);
        [ZLPhotoManager markSelcectModelInArr:strongSelf.arrDataSources selArr:selectedModels];
        strongSelf.isSelectOriginalPhoto = isOriginal;
        [strongSelf.arrSelectedModels removeAllObjects];
        [strongSelf.arrSelectedModels addObjectsFromArray:selectedModels];
        [strongSelf.collectionView reloadData];
        [strongSelf changeFinishBtnTitle];
    }];
    
    [self.sender showDetailViewController:nav sender:nil];
}

- (void)pushGifViewControllerWithModel:(ZLPhotoModel *)model
{
    ZLShowGifViewController *vc = [[ZLShowGifViewController alloc] init];
    vc.model = model;
    ZLImageNavigationController *nav = [self getImageNavWithRootVC:vc];
    [self.sender showDetailViewController:nav sender:nil];
}

- (void)pushVideoViewControllerWithModel:(ZLPhotoModel *)model
{
    ZLShowVideoViewController *vc = [[ZLShowVideoViewController alloc] init];
    vc.model = model;
    ZLImageNavigationController *nav = [self getImageNavWithRootVC:vc];
    [self.sender showDetailViewController:nav sender:nil];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    weakify(self);
    [picker dismissViewControllerAnimated:YES completion:^{
        strongify(weakSelf);
        if (strongSelf.selectImageBlock) {
            UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
            ZLProgressHUD *hud = [[ZLProgressHUD alloc] init];
            [hud show];
            
            [ZLPhotoManager saveImageToAblum:image completion:^(BOOL suc, PHAsset *asset) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (suc) {
                        ZLPhotoModel *model = [ZLPhotoModel modelWithAsset:asset type:ZLAssetMediaTypeImage duration:nil];
                        [strongSelf handleDataArray:model];
                    } else {
                        ShowToastLong(@"%@", GetLocalLanguageTextValue(ZLPhotoBrowserSaveImageErrorText));
                    }
                    [hud hide];
                });
            }];
        }
    }];
}

- (void)handleDataArray:(ZLPhotoModel *)model
{
    [self.arrDataSources insertObject:model atIndex:0];
    if (self.arrSelectedModels.count < self.maxSelectCount) {
        model.isSelected = YES;
        [self.arrSelectedModels addObject:model];
    }
    if (self.arrSelectedModels.count == 1) {
        self.needScaleFlag = 1;//放大
        [self setAnchorPoint:CGPointMake(0, 0) forView:self.collectionView];
        [UIView animateWithDuration:0.3 animations:^{
            self.collectionView.transform = CGAffineTransformMakeScale(1.276,1.276);
        } completion:^(BOOL finished) {
            [self setDefaultAnchorPointforView:self.collectionView];
        }];
    }
    else{
        self.needScaleFlag = 0;
    }
    [self.collectionView reloadData];
    [self changeFinishBtnTitle];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 获取图片及图片尺寸的相关方法
- (CGSize)getSizeWithAsset:(PHAsset *)asset
{
    CGFloat constant = 0;
    if (self.arrSelectedModels.count > 0) {
        constant = 150*1.276;
    }else{
        constant = 150;
    }
//    self.verColHeight.constant = constant;
//    CGFloat width  = (CGFloat)asset.pixelWidth;
//    CGFloat height = (CGFloat)asset.pixelHeight;
//    CGFloat scale = MAX(0.5, width/height);
    
//    return CGSizeMake(self.collectionView.frame.size.height*scale, self.collectionView.frame.size.height);
//    return CGSizeMake(150*scale, 150);
    return CGSizeMake(100, 150);
}

//支点
- (void)setAnchorPoint:(CGPoint)anchorPoint forView:(UIView *)view
{
    CGPoint oldOrigin = view.frame.origin;
    view.layer.anchorPoint = anchorPoint;
    CGPoint newOrigin = view.frame.origin;
    
    CGPoint transition;
    transition.x = newOrigin.x - oldOrigin.x;
    transition.y = newOrigin.y - oldOrigin.y;
    
    view.center = CGPointMake (view.center.x - transition.x, view.center.y - transition.y);
}
//恢复默认支点
- (void)setDefaultAnchorPointforView:(UIView *)view
{
    [self setAnchorPoint:CGPointMake(0.5f, 0.5f) forView:view];
}
@end
