//
//  DQClipImageController.h
//  WebThings
//  添加商务往来／整改意见
//  Created by Heidi on 2017/10/16.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#ifndef DQClipImageController_h
#define DQClipImageController_h

#import "EMIBaseViewController.h"
#import "CXCliper.h"

@interface DQClipImageController : EMIBaseViewController
{
    UIView *_cropView;
    UIImageView *_imageView;
    CXCliper *_cliper;
}

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) CGRect clipRect;
@property (nonatomic, copy) DQResult2Block clipFinished;

@end

#endif /* DQClipImageController_h */
