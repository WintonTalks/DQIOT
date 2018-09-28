//
//  DQAnnotationView.m
//  WebThings
//
//  Created by Heidi on 2017/9/15.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DQAnnotationView.h"

@implementation DQAnnotationView

- (id)initWithAnnotation:(id <BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        //        [self setBounds:CGRectMake(0.f, 0.f, 30.f, 30.f)];
        [self setBounds:CGRectMake(0.f, 0.f, 32.f, 32.f)];
        
        [self setBackgroundColor:[UIColor clearColor]];
        
        _annotationImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _annotationImageView.contentMode = UIViewContentModeCenter;
        [self addSubview:_annotationImageView];
    }
    return self;
}

- (void)setAnnotationImage:(UIImage *)image {
    _annotationImageView.image = image;
}

@end
