//
//  ServiceCenterThirdModel.h
//  WebThings
//
//  Created by machinsight on 2017/7/1.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "ServiceCenterBaseModel.h"
/**
 服务流第二环节
 */
@interface ServiceCenterThirdModel : ServiceCenterBaseModel
//@property int type;
/**0拍照按钮
    1右侧已完成
 2报告
 */

+ (ServiceCenterThirdModel *)getType0Model;

+ (ServiceCenterThirdModel *)getType1Model;

+ (ServiceCenterThirdModel *)getType2Model;
@end
