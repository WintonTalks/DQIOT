//
//  ZLShowBigImgViewController.m
//  多选相册照片
//
//  Created by long on 15/11/25.
//  Copyright © 2015年 long. All rights reserved.
//

#import "ZLShowBigImgViewController.h"
#import <Photos/Photos.h>
#import "ZLBigImageCell.h"
#import "ZLDefine.h"
#import "ToastUtils.h"
#import "ZLPhotoBrowser.h"
#import "ZLPhotoModel.h"
#import "ZLPhotoManager.h"

@interface ZLShowBigImgViewController () <UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>
{
    UICollectionView *_collectionView;
    
    UIButton *_navRightBtn;
    
    //底部view
    UIView   *_bottomView;
    UIButton *_btnOriginalPhoto;
    UIButton *_btnDone;
    
    //双击的scrollView
    UIScrollView *_selectScrollView;
    NSInteger _currentPage;
    
    NSArray *_arrSelPhotosBackup;
    NSMutableArray *_arrSelAssets;
    NSArray *_arrSelAssetsBackup;
}

@property (nonatomic, strong) UILabel *labPhotosBytes;

@end

@implementation ZLShowBigImgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _currentPage = self.selectIndex+1;
    self.title = [NSString stringWithFormat:@"%ld/%ld", _currentPage, self.models.count];
    [self initNavBtns];
    [self initCollectionView];
    [self initBottomView];
    [self changeBtnDoneTitle];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_collectionView setContentOffset:CGPointMake(self.selectIndex*(kViewWidth+kItemMargin), 0)];
}

- (void)setModels:(NSArray<ZLPhotoModel *> *)models
{
    _models = models;
    if (self.arrSelPhotos) {
        _arrSelAssets = [NSMutableArray array];
        for (ZLPhotoModel *m in models) {
            [_arrSelAssets addObject:m.asset];
        }
        _arrSelAssetsBackup = _arrSelAssets.copy;
    }
}

- (void)setArrSelPhotos:(NSMutableArray<UIImage *> *)arrSelPhotos
{
    _arrSelPhotos = arrSelPhotos;
    _arrSelPhotosBackup = arrSelPhotos.copy;
}

- (void)initNavBtns
{
    //left nav btn
//    UIImage *navBackImg = GetImageWithName(@"back");
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(btnBack_Click) image:[UIImage imageNamed:@"back"]]; 
    
    //right nav btn
    _navRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _navRightBtn.frame = CGRectMake(0, 0, 25, 25);
    UIImage *normalImg = GetImageWithName(@"btn_circle.png");
    UIImage *selImg = GetImageWithName(@"btn_selected.png");
    [_navRightBtn setBackgroundImage:normalImg forState:UIControlStateNormal];
    [_navRightBtn setBackgroundImage:selImg forState:UIControlStateSelected];
    [_navRightBtn addTarget:self action:@selector(navRightBtn_Click:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_navRightBtn];
    
    if (self.models.count == 1) {
        _navRightBtn.selected = self.models.firstObject.isSelected;
    }
}

#pragma mark - 初始化CollectionView
- (void)initCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = kItemMargin;
    layout.sectionInset = UIEdgeInsetsMake(0, kItemMargin/2, 0, kItemMargin/2);
    layout.itemSize = self.view.bounds.size;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(-kItemMargin/2, 0, kViewWidth+kItemMargin, kViewHeight) collectionViewLayout:layout];
    [_collectionView registerClass:[ZLBigImageCell class] forCellWithReuseIdentifier:@"ZLBigImageCell"];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.pagingEnabled = YES;
    [self.view addSubview:_collectionView];
}

- (void)initBottomView
{
    ZLImageNavigationController *nav = (ZLImageNavigationController *)self.navigationController;
    
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 44, kViewWidth, 44)];
    _bottomView.backgroundColor = [UIColor whiteColor];
    
    _btnOriginalPhoto = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat btnOriWidth = GetMatchValue(GetLocalLanguageTextValue(ZLPhotoBrowserOriginalText), 15, YES, 30);
    _btnOriginalPhoto.frame = CGRectMake(12, 7, btnOriWidth+25, 30);
    [_btnOriginalPhoto setTitle:GetLocalLanguageTextValue(ZLPhotoBrowserOriginalText) forState:UIControlStateNormal];
    _btnOriginalPhoto.titleLabel.font = [UIFont systemFontOfSize:15];
    [_btnOriginalPhoto setTitleColor:kDoneButton_bgColor forState: UIControlStateNormal];
    UIImage *normalImg = GetImageWithName(@"btn_original_circle.png");
    UIImage *selImg = GetImageWithName(@"btn_selected.png");
    [_btnOriginalPhoto setImage:normalImg forState:UIControlStateNormal];
    [_btnOriginalPhoto setImage:selImg forState:UIControlStateSelected];
    [_btnOriginalPhoto setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 5)];
    [_btnOriginalPhoto addTarget:self action:@selector(btnOriginalImage_Click:) forControlEvents:UIControlEventTouchUpInside];
    _btnOriginalPhoto.selected = nav.isSelectOriginalPhoto;
    if (nav.arrSelectedModels.count > 0) {
        [self getPhotosBytes];
    }
    [_bottomView addSubview:_btnOriginalPhoto];
    
    self.labPhotosBytes = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_btnOriginalPhoto.frame)+5, 7, 80, 30)];
    self.labPhotosBytes.font = [UIFont systemFontOfSize:15];
    self.labPhotosBytes.textColor = kDoneButton_bgColor;
    [_bottomView addSubview:self.labPhotosBytes];
    
    _btnDone = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnDone.frame = CGRectMake(kViewWidth - 82, 7, 70, 30);
    [_btnDone setTitle:GetLocalLanguageTextValue(ZLPhotoBrowserDoneText) forState:UIControlStateNormal];
    _btnDone.titleLabel.font = [UIFont systemFontOfSize:15];
    _btnDone.layer.masksToBounds = YES;
    _btnDone.layer.cornerRadius = 3.0f;
    [_btnDone setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnDone setBackgroundColor:kDoneButton_bgColor];
    [_btnDone addTarget:self action:@selector(btnDone_Click:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_btnDone];
    
    [self.view addSubview:_bottomView];
    
    if (self.arrSelPhotos) {
        //预览用户已确定选择的照片，隐藏原图按钮
        _btnOriginalPhoto.hidden = YES;
    }
}

#pragma mark - UIButton Actions
- (void)btnOriginalImage_Click:(UIButton *)btn
{
    ZLImageNavigationController *nav = (ZLImageNavigationController *)self.navigationController;
    nav.isSelectOriginalPhoto = btn.selected = !btn.selected;
    if (btn.selected) {
        ZLPhotoModel *m = self.models[_currentPage-1];
        if (!m.isSelected) {
            [self navRightBtn_Click:_navRightBtn];
        } else {
            [self getPhotosBytes];
        }
    } else {
        self.labPhotosBytes.text = nil;
    }
}

- (void)btnDone_Click:(UIButton *)btn
{
    ZLImageNavigationController *nav = (ZLImageNavigationController *)self.navigationController;
    if (nav.arrSelectedModels.count == 0) {
        ZLPhotoModel *model = self.models[_currentPage-1];
        if (![ZLPhotoManager judgeAssetisInLocalAblum:model.asset]) {
            ShowToastLong(@"%@", GetLocalLanguageTextValue(ZLPhotoBrowserLoadingText));
            return;
        }
        
        [nav.arrSelectedModels addObject:model];
    }
    if (self.arrSelPhotos && self.btnDonePreviewBlock) {
        self.btnDonePreviewBlock(self.arrSelPhotos, _arrSelAssets);
    } else if (nav.callSelectImageBlock) {
        nav.callSelectImageBlock();
    }
}

- (void)btnBack_Click
{
    ZLImageNavigationController *nav = (ZLImageNavigationController *)self.navigationController;
    if (self.btnBackBlock) {
        self.btnBackBlock(nav.arrSelectedModels, nav.isSelectOriginalPhoto);
    }
    
    UIViewController *vc = [self.navigationController popViewControllerAnimated:YES];
    //由于collectionView的frame的width是大于该界面的width，所以设置这个颜色是为了pop时候隐藏collectionView的黑色背景
    _collectionView.backgroundColor = [UIColor clearColor];
    if (!vc) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)navRightBtn_Click:(UIButton *)btn
{
    ZLImageNavigationController *nav = (ZLImageNavigationController *)self.navigationController;
    
    ZLPhotoModel *model = self.models[_currentPage-1];
    if (!btn.selected) {
        //选中
        [btn.layer addAnimation:GetBtnStatusChangedAnimation() forKey:nil];
        if (nav.arrSelectedModels.count >= nav.maxSelectCount) {
            ShowToastLong(GetLocalLanguageTextValue(ZLPhotoBrowserMaxSelectCountText), nav.maxSelectCount);
            return;
        }
        if (![ZLPhotoManager judgeAssetisInLocalAblum:model.asset]) {
            ShowToastLong(@"%@", GetLocalLanguageTextValue(ZLPhotoBrowserLoadingText));
            return;
        }
        model.isSelected = YES;
        [nav.arrSelectedModels addObject:model];
        if (self.arrSelPhotos) {
            [self.arrSelPhotos addObject:_arrSelPhotosBackup[_currentPage-1]];
            [_arrSelAssets addObject:_arrSelAssetsBackup[_currentPage-1]];
        }
        [self getPhotosBytes];
    } else {
        //移除
        model.isSelected = NO;
        for (ZLPhotoModel *m in nav.arrSelectedModels) {
            if ([m.asset.localIdentifier isEqualToString:model.asset.localIdentifier]) {
                [nav.arrSelectedModels removeObject:m];
                break;
            }
        }
        if (self.arrSelPhotos) {
            for (PHAsset *asset in _arrSelAssets) {
                if ([asset isEqual:_arrSelAssetsBackup[_currentPage-1]]) {
                    [_arrSelAssets removeObject:asset];
                    break;
                }
            }
            [self.arrSelPhotos removeObject:_arrSelPhotosBackup[_currentPage-1]];
        }
    }
    
    btn.selected = !btn.selected;
    [self getPhotosBytes];
    [self changeBtnDoneTitle];
}

#pragma mark - 更新按钮、导航条等显示状态
- (void)changeBtnDoneTitle
{
    ZLImageNavigationController *nav = (ZLImageNavigationController *)self.navigationController;
    if (nav.arrSelectedModels.count > 0) {
        [_btnDone setTitle:[NSString stringWithFormat:@"%@(%ld)", GetLocalLanguageTextValue(ZLPhotoBrowserDoneText), nav.arrSelectedModels.count] forState:UIControlStateNormal];
    } else {
        [_btnDone setTitle:GetLocalLanguageTextValue(ZLPhotoBrowserDoneText) forState:UIControlStateNormal];
    }
}

- (void)getPhotosBytes
{
    ZLImageNavigationController *nav = (ZLImageNavigationController *)self.navigationController;
    if (!nav.isSelectOriginalPhoto) return;
    
    if (nav.arrSelectedModels.count > 0) {
        weakify(self);
        [ZLPhotoManager getPhotosBytesWithArray:nav.arrSelectedModels completion:^(NSString *photosBytes) {
            strongify(weakSelf);
            strongSelf.labPhotosBytes.text = [NSString stringWithFormat:@"(%@)", photosBytes];
        }];
    } else {
        self.labPhotosBytes.text = nil;
    }
}

- (void)showNavBarAndBottomView
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    CGRect frame = _bottomView.frame;
    frame.origin.y -= frame.size.height;
    [UIView animateWithDuration:0.3 animations:^{
        _bottomView.frame = frame;
    }];
}

- (void)hideNavBarAndBottomView
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    CGRect frame = _bottomView.frame;
    frame.origin.y += frame.size.height;
    [UIView animateWithDuration:0.3 animations:^{
        _bottomView.frame = frame;
    }];
}


#pragma mark - UICollectionDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.models.count;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    [(ZLBigImageCell *)cell resetCellStatus];
}

//- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    [(ZLBigImageCell *)cell resetCellStatus];
//}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZLBigImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZLBigImageCell" forIndexPath:indexPath];
    ZLPhotoModel *model = self.models[indexPath.row];
    
    cell.model = model;
    weakify(self);
    cell.singleTapCallBack = ^() {
        strongify(weakSelf);
        if (strongSelf.navigationController.navigationBar.isHidden) {
            [strongSelf showNavBarAndBottomView];
        } else {
            [strongSelf hideNavBarAndBottomView];
        }
    };
    
    return cell;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == (UIScrollView *)_collectionView) {
        //改变导航标题
        CGFloat page = scrollView.contentOffset.x/(kViewWidth+kItemMargin);
        NSString *str = [NSString stringWithFormat:@"%.0f", page];
        _currentPage = str.integerValue + 1;
        self.title = [NSString stringWithFormat:@"%ld/%ld", _currentPage, self.models.count];
        ZLPhotoModel *model = self.models[_currentPage-1];
        _navRightBtn.selected = model.isSelected;
    }
}

@end
