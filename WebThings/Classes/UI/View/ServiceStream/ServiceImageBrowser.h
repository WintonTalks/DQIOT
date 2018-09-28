//
//  ServiceImageBrowser.h
//  WebThings
//
//  Created by machinsight on 2017/7/1.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ServiceImageBrowser : UIView
@property(nonatomic,strong)NSArray *imgArr;
- (void)setImgArrs:(NSArray *)imgArr;

- (CGFloat)getMaxHeight;

@end
