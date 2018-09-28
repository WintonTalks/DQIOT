//
//  ServiceCenterNinthModel.h
//  WebThings
//
//  Created by machinsight on 2017/7/4.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "ServiceCenterBaseModel.h"

@interface ServiceCenterNinthModel : ServiceCenterBaseModel
//@property int type;
/**0新增停租单
 1列表
 2费用清单
 */
+ (ServiceCenterNinthModel *)getType0Model;

+ (ServiceCenterNinthModel *)getType1Model;

+ (ServiceCenterNinthModel *)getType2Model;
@end
