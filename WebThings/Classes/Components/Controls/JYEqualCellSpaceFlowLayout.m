//
//  JYEqualCellSpaceFlowLayout.m
//  UICollectionViewDemo
//
//  Created by 飞迪1 on 2017/10/13.
//  Copyright © 2017年 CHC. All rights reserved.
//

#import "JYEqualCellSpaceFlowLayout.h"
@interface JYEqualCellSpaceFlowLayout(){
    CGFloat _sumCellWidth ;
}
@end

@implementation JYEqualCellSpaceFlowLayout
-(instancetype)init{
    return [self initWithType:AlignWithCenter betweenOfCell:5.0];
}
-(void)setBetweenOfCell:(CGFloat)betweenOfCell{
    _betweenOfCell = betweenOfCell;
    self.minimumInteritemSpacing = betweenOfCell;
}
-(instancetype)initWthType:(AlignType)cellType{
    return [self initWithType:cellType betweenOfCell:5.0];
}
-(instancetype)initWithType:(AlignType)cellType
              betweenOfCell:(CGFloat)betweenOfCell
{
    self = [super init];
    if (self){
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.minimumLineSpacing = 5;
        self.minimumInteritemSpacing = 5;
        self.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
        _betweenOfCell = betweenOfCell;
        _cellType = cellType;
    }
    return self;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray * layoutAttributes_t = [super layoutAttributesForElementsInRect:rect];
    NSArray * layoutAttributes = [[NSArray alloc]initWithArray:layoutAttributes_t copyItems:YES];
    NSMutableArray * layoutAttributesTemp = [[NSMutableArray alloc]init];
    for (NSUInteger index = 0; index < layoutAttributes.count ; index++) {
        
        UICollectionViewLayoutAttributes *currentAttr = layoutAttributes[index];
        UICollectionViewLayoutAttributes *previousAttr = index == 0 ? nil : layoutAttributes[index-1];
        UICollectionViewLayoutAttributes *nextAttr = index + 1 == layoutAttributes.count ?
        nil : layoutAttributes[index+1];
     
        [layoutAttributesTemp addObject:currentAttr];
        _sumCellWidth += currentAttr.frame.size.width;
        
        CGFloat previousY = previousAttr == nil ? 0 : CGRectGetMaxY(previousAttr.frame);
        CGFloat currentY = CGRectGetMaxY(currentAttr.frame);
        CGFloat nextY = nextAttr == nil ? 0 : CGRectGetMaxY(nextAttr.frame);
        if (currentY != previousY && currentY != nextY){
            if ([currentAttr.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]) {
                [layoutAttributesTemp removeAllObjects];
                _sumCellWidth = 0.0;
            }else if ([currentAttr.representedElementKind isEqualToString:UICollectionElementKindSectionFooter]){
                [layoutAttributesTemp removeAllObjects];
                _sumCellWidth = 0.0;
            }else{
                [self setCellFrameWith:layoutAttributesTemp];
            }
        }
        else if( currentY != nextY) {
            [self setCellFrameWith:layoutAttributesTemp];
        }
    }
    return layoutAttributes;
}

-(void)setCellFrameWith:(NSMutableArray*)layoutAttributes
{
    CGFloat nowWidth = 0.0;
    switch (_cellType) {
        case AlignWithLeft:
            nowWidth = self.sectionInset.left;
            for (UICollectionViewLayoutAttributes * attributes in layoutAttributes) {
                CGRect nowFrame = attributes.frame;
                nowFrame.origin.x = nowWidth;
                attributes.frame = nowFrame;
                nowWidth += nowFrame.size.width + self.betweenOfCell;
            }
            _sumCellWidth = 0.0;
            [layoutAttributes removeAllObjects];
            break;
            
        case AlignWithCenter:
            nowWidth = (self.collectionView.frame.size.width - _sumCellWidth - ((layoutAttributes.count - 1) * _betweenOfCell)) / 2;
            for (UICollectionViewLayoutAttributes * attributes in layoutAttributes) {
                CGRect nowFrame = attributes.frame;
                nowFrame.origin.x = nowWidth;
                attributes.frame = nowFrame;
                nowWidth += nowFrame.size.width + self.betweenOfCell;
            }
            _sumCellWidth = 0.0;
            [layoutAttributes removeAllObjects];
            break;
            
        case AlignWithRight:
            nowWidth = self.collectionView.frame.size.width - self.sectionInset.right;
            for (NSInteger index = layoutAttributes.count - 1 ; index >= 0 ; index-- ) {
                UICollectionViewLayoutAttributes * attributes = layoutAttributes[index];
                CGRect nowFrame = attributes.frame;
                nowFrame.origin.x = nowWidth - nowFrame.size.width;
                attributes.frame = nowFrame;
                nowWidth = nowWidth - nowFrame.size.width - _betweenOfCell;
            }
            _sumCellWidth = 0.0;
            [layoutAttributes removeAllObjects];
            break;
    }
}

@end
