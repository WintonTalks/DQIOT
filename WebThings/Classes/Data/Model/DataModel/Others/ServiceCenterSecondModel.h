//
//  ServiceCenterSecondModel.h
//  WebThings
//
//  Created by machinsight on 2017/6/30.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "ServiceCenterBaseModel.h"
/**
 服务流第二环节
 */
@interface ServiceCenterSecondModel : ServiceCenterBaseModel
//@property int type;
/**0拍照按钮
    1.显示照片
    2.已完成
 */

+ (ServiceCenterSecondModel *)getType0Model;

+ (ServiceCenterSecondModel *)getType1Model;

+ (ServiceCenterSecondModel *)getType2Model;
@end
