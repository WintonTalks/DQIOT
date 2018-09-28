//
//  DQDeviceMaintainPhotoBrowseCell.m
//  WebThings
//
//  Created by Eugene on 10/19/17.
//  Copyright © 2017 machinsight. All rights reserved.
//

#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height
#define weakify(var)   __weak typeof(var) weakSelf = var
#define strongify(var) __strong typeof(var) strongSelf = var

#define kMaxSelectCount   6     // 设置最大选择图片数

#import <Photos/Photos.h>
#import "DQDeviceMaintainPhotoBrowseCell.h"
#import "DQPhotoBrowseCollectionCell.h"
#import "DQPhotoActionSheetManager.h"

#import "JKPhotoBrowser.h"

@interface DQDeviceMaintainPhotoBrowseCell ()<UICollectionViewDelegate,UICollectionViewDataSource,UINavigationControllerDelegate, UIImagePickerControllerDelegate>//PHPhotoLibraryChangeObserver

@property (nonatomic, strong) UICollectionView *colllectionView;

@property (nonatomic, strong) UIButton *cameraBtn;
@property (nonatomic, strong) UIButton *albumBtn;

@property (nonatomic, strong) NSMutableArray *dataAry;
@property (nonatomic, strong) NSMutableArray *imgModelAry;

@end

@implementation DQDeviceMaintainPhotoBrowseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initPhotoBrowseView];
    }
    return self;
}

- (void)initPhotoBrowseView {
    
    _dataAry = [[NSMutableArray alloc] init];
    _imgModelAry = [[NSMutableArray alloc] init];
    
//    UIView *lineView = [[UIView alloc] init];
//    lineView.frame = CGRectMake(kWidth/2, 17, 1, 20);
//    lineView.backgroundColor = [UIColor colorWithHexString:@"#D8D8D8"];
//    [self.contentView addSubview:lineView];
    
    [self.contentView addSubview:self.cameraBtn];
    [self.contentView addSubview:self.albumBtn];
    [self.contentView addSubview:self.colllectionView];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataAry.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DQPhotoBrowseCollectionCell *cell = (DQPhotoBrowseCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"kCellIdentifier" forIndexPath:indexPath];
    cell.imageView.image = _dataAry[indexPath.row];
    cell.deletePhotoBlock = ^{
        [_dataAry removeObjectAtIndex:indexPath.row];
        [_colllectionView reloadData];
        _reloadCellBlock(_dataAry);
        [self updateCollectionViewFrame];
    };
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
//    [_imgModelAry removeAllObjects];
//    for (int index = 0; index < _dataAry.count; index ++) {
//        NSString * imageName = [NSString stringWithFormat:@"img%zd.jpg",index];
//        DQPhotoBrowseCollectionCell *cell = (DQPhotoBrowseCollectionCell*)[_colllectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
//
//        JKPhotoModel * model = [JKPhotoModel modelWithImageView:cell.imageView
//                                                    smallPicUrl:imageName
//                                                           cell:nil
//                                                    contentView:self];
//        [_imgModelAry addObject:model];
//    }
//
//    JKPhotoBrowser().jk_itemArray = _imgModelAry;
//    JKPhotoBrowser().jk_currentIndex = indexPath.row;
//    JKPhotoBrowser().jk_showPageController = YES;
//    [[JKPhotoManager sharedManager] jk_showPhotoBrowser];
//    JKPhotoBrowser().jk_QRCodeRecognizerEnable = YES;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(110, 165);
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    weakify(self);
    [picker dismissViewControllerAnimated:YES completion:^{
        strongify(weakSelf);
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        [strongSelf.dataAry addObject:image];
        [strongSelf.colllectionView reloadData];
        _reloadCellBlock(_dataAry);
        [self updateCollectionViewFrame];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Actions
/** 获取相机 */
- (void)getCameraClick:(UIButton *)sender {
    
    if (_dataAry.count >= kMaxSelectCount) {
        [self showAlertWithTitle:@"提示" message:@"最多只可选择6张图片哦！"];
        return;
    }
    
    if (![self judgeIsHaveCameraAuthority]) {
        [self showAlertWithTitle:@"提示" message:@"请前往设置页面打开相册访问"];
        return;
    }
    // 拍照
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = NO;
        picker.videoQuality = UIImagePickerControllerQualityTypeLow;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        UIViewController *view = [self getCurrentViewController];
        [view presentViewController:picker animated:YES completion:nil];
    }
}

- (void)getAlbumClick:(UIButton *)sender {
    
    if (_dataAry.count >= kMaxSelectCount) {
        [self showAlertWithTitle:@"提示" message:@"最多只可选择6张图片哦！"];
        return;
    }
    
    NSInteger maxCount = (kMaxSelectCount - _dataAry.count) > 0 ? (kMaxSelectCount - _dataAry.count) : 0;
    DQPhotoActionSheetManager *manager = [[DQPhotoActionSheetManager alloc] init];
    [manager dq_showPhotoActionSheetWithController:[self getCurrentViewController]
                               showPreviewPhoto:NO
                               maxSelectCount:maxCount
                              didSelectedImages:^(NSArray<UIImage *> *images) {
        [_dataAry addObjectsFromArray:images];
        [_colllectionView reloadData];
        _reloadCellBlock(_dataAry);
        [self updateCollectionViewFrame];
//          [manager dq_uploadImageApi:^(NSArray *imagesUrl) {
//              _reloadCellBlock(imagesUrl);
//          }];
    }];
   
}

#pragma mark - Private

- (void)updateCollectionViewFrame {
    if (_dataAry.count > 0) {
        _colllectionView.height = 165;
    } else {
        _colllectionView.height = 0;
    }
}

#pragma mark 判断软件是否有相册、相机访问权限
- (BOOL)judgeIsHavePhotoAblumAuthority {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusAuthorized) {
        return YES;
    }
    return NO;
}

- (BOOL)judgeIsHaveCameraAuthority {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusRestricted ||
        status == AVAuthorizationStatusDenied) {
        return NO;
    }
    return YES;
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:action];
    
    UIViewController *view = [self getCurrentViewController];
    [view presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Getter And Setter
- (UICollectionView *)colllectionView {
    if (!_colllectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _colllectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 100, kWidth, 0) collectionViewLayout:layout];
        _colllectionView.backgroundColor = [UIColor whiteColor];
        _colllectionView.dataSource = self;
        _colllectionView.delegate = self;
        _colllectionView.showsHorizontalScrollIndicator = NO;
        _colllectionView.contentInset = UIEdgeInsetsMake(0, 10, 0, 10);
        [_colllectionView registerClass:[DQPhotoBrowseCollectionCell class] forCellWithReuseIdentifier:@"kCellIdentifier"];
    }
    return _colllectionView;
}

- (UIButton *)cameraBtn {
    if (!_cameraBtn) {
        _cameraBtn = [[UIButton alloc] initWithFrame:CGRectMake(kWidth/4-30, 20, 60, 60)];
        _cameraBtn.titleLabel.font = [UIFont dq_mediumSystemFontOfSize:14.0];
        [_cameraBtn setTitle:@"拍摄" forState:UIControlStateNormal];
        [_cameraBtn setTitleColor:[UIColor colorWithHexString:@"#7F7F7F"] forState:UIControlStateNormal];
        [_cameraBtn setImage:[UIImage imageNamed:@"ic_camera"] forState:UIControlStateNormal];
        [_cameraBtn addTarget:self action:@selector(getCameraClick:) forControlEvents:UIControlEventTouchUpInside];
        [_cameraBtn layoutButtonWithEdgeInsetsStyle:TQButtonEdgeInsetsStyleTop imageTitleSpace:15];
    }
    return _cameraBtn;
}

- (UIButton *)albumBtn {
    if (!_albumBtn) {
        _albumBtn = [[UIButton alloc] initWithFrame:CGRectMake((kWidth/4)*3-30, 20, 60, 60)];
        _albumBtn.titleLabel.font = [UIFont dq_mediumSystemFontOfSize:14.0];
        [_albumBtn setTitle:@"相册" forState:UIControlStateNormal];
        [_albumBtn setTitleColor:[UIColor colorWithHexString:@"#7F7F7F"] forState:UIControlStateNormal];
        [_albumBtn setImage:[UIImage imageNamed:@"ic_service_photo"] forState:UIControlStateNormal];
        [_albumBtn addTarget:self action:@selector(getAlbumClick:) forControlEvents:UIControlEventTouchUpInside];
        [_albumBtn layoutButtonWithEdgeInsetsStyle:TQButtonEdgeInsetsStyleTop imageTitleSpace:15];
    }
    return _albumBtn;
}
@end
