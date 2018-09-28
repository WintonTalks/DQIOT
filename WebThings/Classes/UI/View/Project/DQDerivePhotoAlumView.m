//
//  DQDerivePhotoAlumView.m
//  WebThings
//
//  Created by winton on 2017/10/16.
//  Copyright © 2017年 machinsight. All rights reserved.
//  项目管理-资质认证cell 图片view

#import "DQDerivePhotoAlumView.h"
#import "JYEqualCellSpaceFlowLayout.h"
#import "DQInfoPhotoCell.h"
#import "YYPhotoBrowseView.h"

@interface DQDerivePhotoAlumView()
<UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *photoMangerView;
@property (nonatomic, strong) NSMutableArray *picListArray;
@property (nonatomic) DQDerivePhotoAlumType type;
@property (nonatomic, strong) NSMutableArray *addPhotoArr;
@end

static NSString *CellWithReuseIdentifier = @"InfoPhotoReuseIdentifier";

@implementation DQDerivePhotoAlumView

- (instancetype)initWithFrame:(CGRect)frame
                         type:(DQDerivePhotoAlumType)type
{
    self = [super initWithFrame:frame];
    if (self) {
        self.type = type;
        [self addThumPhotoView];
    }
    return self;
}

- (void)addThumPhotoView
{
    self.backgroundColor = [UIColor clearColor];
    AlignType layoutType = (self.type == KDQDerivePhotoAlumLeftStyle) ? AlignWithLeft : AlignWithRight;
    CGFloat weenWidth = (self.type == KDQDerivePhotoAlumLeftStyle) ? 8.f : 16.f;
    JYEqualCellSpaceFlowLayout * flowLayout = [[JYEqualCellSpaceFlowLayout alloc] initWithType:layoutType betweenOfCell:weenWidth];
    _photoMangerView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height) collectionViewLayout:flowLayout];
    _photoMangerView.backgroundColor = [UIColor whiteColor];
    _photoMangerView.delegate = self;
    _photoMangerView.dataSource = self;
    [_photoMangerView registerClass:[DQInfoPhotoCell class] forCellWithReuseIdentifier:CellWithReuseIdentifier];
    [self addSubview:_photoMangerView];
}

//引导进来的相册图片，多张/单张
- (void)configAlubmPhoto:(NSArray *)listArray
{
    self.picListArray = listArray.mutableCopy;
    [self.addPhotoArr removeAllObjects];
    [_photoMangerView reloadData];
}

#pragma mark-UICollectionViewDataSource && UICollectionViewDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.picListArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DQInfoPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellWithReuseIdentifier forIndexPath:indexPath];
    NSString *urlString = [NSString stringWithFormat:@"%@",[self.picListArray safeObjectAtIndex:indexPath.row]];
    [cell configMangerPhotoImageView:urlString];
    [self.addPhotoArr safeAddObject:cell.picView];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(120, 80);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (self.type == KDQDerivePhotoAlumLeftStyle) {
        return UIEdgeInsetsMake(0, 0, 8, 8);
    }
    return UIEdgeInsetsMake(0, 8, 8, 0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *items = [NSMutableArray array];
    NSInteger selectIndex = indexPath.row;
    UIView *fromView = nil;
    for (int i = 0; i < self.picListArray.count; i++) {
        id obj = [self.picListArray safeObjectAtIndex:i];
        YYPhotoGroupItem *item = [YYPhotoGroupItem new];
        item.thumbView = [self.addPhotoArr safeObjectAtIndex:i];
        NSURL *url = ADDURL(obj);
        item.largeImageURL = url;
        [items safeAddObject:item];
        if (i == selectIndex) {
            fromView = [self.addPhotoArr safeObjectAtIndex:i];
        }
    }
    UIViewController *mainVC = [self getConfigViewController];
    YYPhotoBrowseView *groupView = [[YYPhotoBrowseView alloc] initWithGroupItems:items];
    [groupView presentFromImageView:fromView toContainer:mainVC.navigationController.view animated:true completion:nil];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _photoMangerView.frame = self.bounds;
}

- (NSMutableArray *)picListArray
{
    if (!_picListArray) {
        _picListArray = [NSMutableArray new];
    }
    return _picListArray;
}

- (NSMutableArray *)addPhotoArr
{
    if (!_addPhotoArr) {
        _addPhotoArr = [NSMutableArray new];
    }
    return _addPhotoArr;
}

@end
