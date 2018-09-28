//
//  ServiceCenterSixthModel.h
//  WebThings
//
//  Created by machinsight on 2017/7/3.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "ServiceCenterBaseModel.h"

@interface ServiceCenterSixthModel : ServiceCenterBaseModel

//@property int type;
/**0新增设备维保单
 1列表
 */
+ (ServiceCenterSixthModel *)getType0Model;

+ (ServiceCenterSixthModel *)getType1Model;

+ (ServiceCenterSixthModel *)getType2Model;
@end
