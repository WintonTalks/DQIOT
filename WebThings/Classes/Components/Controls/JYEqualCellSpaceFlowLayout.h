//
//  JYEqualCellSpaceFlowLayout.h
//  UICollectionViewDemo
//
//  Created by 飞迪1 on 2017/10/13.
//  Copyright © 2017年 CHC. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,AlignType){
    AlignWithLeft,
    AlignWithCenter,
    AlignWithRight
};
@interface JYEqualCellSpaceFlowLayout : UICollectionViewFlowLayout
@property (nonatomic, assign) CGFloat betweenOfCell;
@property (nonatomic, assign) AlignType cellType;
-(instancetype)initWthType : (AlignType)cellType;
-(instancetype)initWithType:(AlignType) cellType betweenOfCell:(CGFloat)betweenOfCell;

@end
