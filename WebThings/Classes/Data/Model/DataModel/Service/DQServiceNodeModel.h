//
//  DQServiceNodeModel.h
//  WebThings
//  服务流(业务站)根节点数据
//  Created by Heidi on 2017/9/25.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#ifndef DQServiceNodeModel_h
#define DQServiceNodeModel_h
#import "DQEnum.h"

@interface DQServiceNodeModel : NSObject

// ------------ 接口返回数据
@property (nonatomic, copy) NSString *flowtype;         // 服务流名（前期沟通、设备报装…）
@property (nonatomic, assign) BOOL canclick;       // 是否可以点击 0.不可以 1.可以
@property (nonatomic, assign) BOOL isfinish;       // 是否已完成 0.未完成  1.已完成

// ------------ 以下为自定义数据
//@property (nonatomic, assign) NSInteger parentId;        // 父节点的id，如果为-1表示该节点为根节点
@property (nonatomic, assign) DQFlowType nodeIndex;         // 本节点的index  0.前期沟通 1.设备报装 2.设备安装...
@property (nonatomic, copy) NSString *name;              // 本节点的名称
//@property (nonatomic, assign) NSInteger depth;           // 该节点的深度
//@property (nonatomic, assign) BOOL expand;               // 该节点是否处于展开状态

@end

#endif /* DQServiceNodeModel_h */
