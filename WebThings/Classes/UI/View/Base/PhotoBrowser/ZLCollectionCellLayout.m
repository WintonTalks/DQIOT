//
//  ZLCollectionCellLayout.m
//  WebThings
//
//  Created by machinsight on 2017/6/14.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "ZLCollectionCellLayout.h"

@implementation ZLCollectionCellLayout

- (void)prepareLayout{
    [super prepareLayout];

    _itemCount = [self.collectionView numberOfItemsInSection:0];
    
    if(_internalItemSpacing == 0)
        _internalItemSpacing = 5;
    
    if(_sectionEdgeInsets.top == 0 && _sectionEdgeInsets.bottom == 0 && _sectionEdgeInsets.left == 0 && _sectionEdgeInsets.right == 0)
        _sectionEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
}
-(CGSize)collectionViewContentSize {
    
    
    
    CGSize s = self.collectionView.contentSize;
    
    if (CGSizeEqualToSize(s, CGSizeMake(0, 155))) {
        CGFloat x = _sectionEdgeInsets.right;
        for (NSInteger i=0 ; i < _itemCount; i++) {
            NSIndexPath* indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            _itemSize = [_zldelegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPath];
            x = x+_itemSize.width+_sectionEdgeInsets.right;
            
            
        }
        x = x+_sectionEdgeInsets.right;
        return CGSizeMake(x, 0);
    }else{
        
        if ([_zldelegate needScale] == 1) {
            //放大
            CGFloat x = _sectionEdgeInsets.right*1.276;
            for (NSInteger i=0 ; i < _itemCount; i++) {
                NSIndexPath* indexPath = [NSIndexPath indexPathForItem:i inSection:0];
                _itemSize = [_zldelegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPath];
                x = x+_itemSize.width+_sectionEdgeInsets.right*1.276;
                
                if (_itemCount-1 == i) {
                    if (screenWidth == 375) {
                        x = x+_itemSize.width*0.5;
                    }
                    if (screenWidth == 414) {
                        x = x+_itemSize.width*0.33;
                    }
                    
                }
            }
            x = x+_sectionEdgeInsets.right*1.276;
            
            return CGSizeMake(x, 0);
        }else if([_zldelegate needScale] == 2){
            //缩小
            CGFloat x = _sectionEdgeInsets.right;
            for (NSInteger i=0 ; i < _itemCount; i++) {
                NSIndexPath* indexPath = [NSIndexPath indexPathForItem:i inSection:0];
                _itemSize = [_zldelegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPath];
                x = x+_itemSize.width+_sectionEdgeInsets.right;
                
                
            }
            x = x+_sectionEdgeInsets.right;
            return CGSizeMake(x, 0);
        }else{
            return s;
        }
    }
    
    
}
-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes* attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    CGFloat x = _sectionEdgeInsets.right;
    for (NSInteger i=0 ; i < indexPath.row; i++) {
        NSIndexPath* tempindexPath = [NSIndexPath indexPathForItem:i inSection:0];
        _itemSize = [_zldelegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:tempindexPath];
        x = x+_itemSize.width+_sectionEdgeInsets.right;
    }
    _itemSize = [_zldelegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPath];
    attr.size = _itemSize;
    attr.frame = CGRectMake(x, 0, _itemSize.width, _itemSize.height);
    return attr;
}
/**
 *  这个方法的返回值是一个数组(数组里存放在rect范围内所有元素的布局属性)
 *  这个方法的返回值  决定了rect范围内所有元素的排布（frame）
 */
-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray* attributes = [NSMutableArray array];
    
    CGFloat x = _sectionEdgeInsets.right;
    for (NSInteger i=0 ; i < _itemCount; i++) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        _itemSize = [_zldelegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPath];
        UICollectionViewLayoutAttributes* attr = [self layoutAttributesForItemAtIndexPath:indexPath];
        attr.size = _itemSize;
        attr.frame = CGRectMake(x, 0, _itemSize.width, _itemSize.height);
        x = x+_itemSize.width+_sectionEdgeInsets.right;
        [attributes addObject:attr];
    }
    
    return attributes;
}

/*!
 *  多次调用 只要滑出范围就会 调用
 *  当CollectionView的显示范围发生改变的时候，是否重新发生布局
 *  一旦重新刷新 布局，就会重新调用
 *  1.layoutAttributesForElementsInRect：方法
 *  2.preparelayout方法
 */
-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}
@end
