//
//  ZLCollectionCellLayout.h
//  WebThings
//
//  Created by machinsight on 2017/6/14.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZLCollectionCellLayout;
@protocol ZLCollectionCellLayoutDelegate <NSObject>

@required
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
/**
 是否需要缩放

 @return 1放大，2缩小，0不变
 */
- (NSInteger)needScale;

@end
@interface ZLCollectionCellLayout : UICollectionViewLayout
@property (nonatomic,   weak) id<ZLCollectionCellLayoutDelegate> zldelegate;

@property (nonatomic, assign) CGFloat internalItemSpacing;
@property (nonatomic, assign) NSInteger itemCount;
@property (nonatomic, assign) CGSize itemSize;
@property (nonatomic, assign) UIEdgeInsets sectionEdgeInsets;
@end
