//
//  ServiceCenterEighthModel.h
//  WebThings
//
//  Created by machinsight on 2017/7/4.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "ServiceCenterBaseModel.h"

@interface ServiceCenterEighthModel : ServiceCenterBaseModel
//@property int type;
/**0新增服务要求表
 1列表
 */
+ (ServiceCenterEighthModel *)getType0Model;

+ (ServiceCenterEighthModel *)getType1Model;

+ (ServiceCenterEighthModel *)getType2Model;
@end
