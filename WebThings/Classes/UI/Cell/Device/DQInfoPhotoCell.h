//
//  DQInfoPhotoCell.h
//  WebThings
//
//  Created by winton on 2017/10/30.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DQInfoPhotoCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *picView;

- (void)configMangerPhotoImageView:(id)image;
@end
