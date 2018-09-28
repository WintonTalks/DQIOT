//
//  DQPhotoBrowseCollectionCell.h
//  WebThings
//
//  Created by Eugene on 10/19/17.
//  Copyright © 2017 machinsight. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DQPhotoBrowseCollectionCell : UICollectionViewCell

@property (nonatomic, copy) void (^deletePhotoBlock)();
@property (nonatomic, strong) UIImageView *imageView;

@end
