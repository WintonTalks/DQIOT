//
//  ConverterModel.h
//  WebThings
//
//  Created by machinsight on 2017/7/10.
//  Copyright © 2017年 machinsight. All rights reserved.
//  变频器

#import <Foundation/Foundation.h>
//变频器型号：tdm
//工作频率:frq
//输出功率:pow
//运行速度:spd
//输出电压:vou
//输出电流:cur
//工平模式工作时间:pmhms
//变频模式工作时间:cmhms

@interface ConverterModel : NSObject
@property (nonatomic, strong) NSString *tdm;
@property (nonatomic, strong) NSString *frq;
@property (nonatomic, strong) NSString *pow;
@property (nonatomic, strong) NSString *spd;
@property (nonatomic, strong) NSString *vou;
@property (nonatomic, strong) NSString *cur;
@property (nonatomic, strong) NSString *pmhms;
@property (nonatomic, strong) NSString *cmhms;

@end
