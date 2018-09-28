//
//  ServiceScreamSection.h
//  WebThings
//
//  Created by machinsight on 2017/6/27.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceCenterBaseModel.h"

@class ServiceScreamSection;
@protocol ServiceScreamSectionDelegate <NSObject>

- (void)sectionBtnClicked:(NSInteger)index;

@end

@interface ServiceScreamSection : UIView

@property (nonatomic, weak) id<ServiceScreamSectionDelegate> delegate;


- (void)setDelegate:(id<ServiceScreamSectionDelegate>)delegate;
- (void)setIsOpen:(BOOL)isOpen;

- (void)setViewValuesWithModel:(ServiceCenterBaseModel *)model;
@end
