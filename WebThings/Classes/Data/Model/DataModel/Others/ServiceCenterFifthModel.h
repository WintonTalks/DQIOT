//
//  ServiceCenteFifthModel.h
//  WebThings
//
//  Created by machinsight on 2017/7/3.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "ServiceCenterBaseModel.h"

@interface ServiceCenterFifthModel : ServiceCenterBaseModel
//@property int type;
/**0司机信息
 1已完成
 */

+ (ServiceCenterFifthModel *)getType0Model;

+ (ServiceCenterFifthModel *)getType1Model;

+ (ServiceCenterFifthModel *)getType2Model;
@end
