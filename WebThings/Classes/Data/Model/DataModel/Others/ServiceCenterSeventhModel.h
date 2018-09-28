//
//  ServiceCenterSeventhModel.h
//  WebThings
//
//  Created by machinsight on 2017/7/3.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "ServiceCenterBaseModel.h"

@interface ServiceCenterSeventhModel : ServiceCenterBaseModel
//@property int type;
/**0新增设备维修单
 1列表
 */
+ (ServiceCenterSeventhModel *)getType0Model;

+ (ServiceCenterSeventhModel *)getType1Model;

+ (ServiceCenterSeventhModel *)getType2Model;
@end
