//
//  ServiceCenterTenthModel.h
//  WebThings
//
//  Created by machinsight on 2017/7/4.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "ServiceCenterBaseModel.h"

@interface ServiceCenterTenthModel : ServiceCenterBaseModel
//@property int type;
/**0新增服务评价
 */
+ (ServiceCenterTenthModel *)getType0Model;

+ (ServiceCenterTenthModel *)getType1Model;

+ (ServiceCenterTenthModel *)getType2Model;
@end
