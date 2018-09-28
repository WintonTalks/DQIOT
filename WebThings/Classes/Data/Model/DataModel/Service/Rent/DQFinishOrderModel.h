//
//  DQFinishOrderModel.h
//  WebThings
//
//  Created by Eugene on 10/29/17.
//  Copyright © 2017 machinsight. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DQFinishOrderModel : NSObject

@property (nonatomic, strong) NSDictionary *manager;// 负责人
@property (nonatomic, strong) NSArray *workers;// 完成单工作人员列表

@property (nonatomic, copy) NSString *startDate;/** 开始时间 */
@property (nonatomic, copy) NSString *endDate;/** 结束时间 */

@property (nonatomic, copy) NSString *result;/** 结果 */
@property (nonatomic, copy) NSString *des;/** 说明 */
@property (nonatomic, copy) NSString *expend;/** 配件消耗 */
@property (nonatomic, copy) NSString *imgs;/** 图片 */

@end

/** finshorder =                 {
 des = "\U8bf4\U660e\U56fe\U62c9\U554a";
 end = "2017/10/28";
 expend = "\U914d\U4ef6\U9065\U9065\U65e0\U671f";
 imgs = "/upload/81f6d2dc-316d-41be-b94f-dc273774121f.jpg,/upload/02fda938-339e-4af6-a15b-8e6df82cf7ce.jpg";
 manager =                     {
 name = "\U674e\U5a9b";
 userid = 326;
 };
 result = "\U7ed3\U5a5a\U9ed8\U9ed8\U627e\U6211";
 start = "2017/10/27";
 workers =                     (
 {
 dn = 13851621541;
 name = "\U5173\U798f\U8fbe";
 userid = 325;
 },
 {
 dn = 13521541214;
 name = "\U674e\U5a9b";
 userid = 326;
 },
 {
 dn = 13562515412;
 name = "\U7ae5\U5149\U9f13";
 userid = 327;
 },
 {
 dn = 13952289089;
 name = "\U6d4b\U8bd5\U5de5\U4eba";
 userid = 343;
 }
 );
 }; */
