//
//  EMICardView.h
//  WebThings
//
//  Created by machinsight on 2017/6/1.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDCShadowLayer.h"
#import "MaterialShadowElevations.h"

@interface EMICardView : UIView

/** 设置卡片的阴影类型 
 当value = 0时，无阴影效果，大于零且值越大阴影越明显 
 */
@property (nonatomic, assign) CGFloat layerShadowType;

@end
