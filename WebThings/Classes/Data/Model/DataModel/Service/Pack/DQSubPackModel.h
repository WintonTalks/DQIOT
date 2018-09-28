//
//  DQSubPackModel.h
//  WebThings
//  设备报装
//  Created by Heidi on 2017/9/25.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#ifndef DQSubPackModel_h
#define DQSubPackModel_h
#import "DQEnum.h"

#import "DQServiceSubNodeModel.h"

@interface DQSubPackModel : DQServiceSubNodeModel

@property (nonatomic, strong) NSArray *msgattachmentList; //图片集合

@end

#endif /* DQSubPackModel_h */
