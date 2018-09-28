//
//  ImageTools.h
//  taojin
//
//  Created by machinsight on 17/4/23.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageTools : NSObject
+ (NSData *)zipImage:(NSData *)imgdata;
+ (NSString *)saveImage:(NSData *)data;
@end
