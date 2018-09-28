//
//  DQLocationManager.h
//  WebThings
//  定位管理
//  Created by Heidi on 2017/9/12.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#ifndef DQLocationManager_h
#define DQLocationManager_h

#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>

@interface DQLocationManager : NSObject
<BMKLocationServiceDelegate, BMKGeoCodeSearchDelegate>
{
//    BMKLocationService* _locService;
    BMKGeoCodeSearch *_geocodesearch;
    
    double _lat;
    double _lng;
}

@property (nonatomic, strong) CLLocation *userPosition;
@property (nonatomic, copy) DQFailureBlock errorBlock;
@property (nonatomic, copy) DQAddressReverse reverseBlock;

/// 是否能获取定位权限
- (BOOL)dq_canGetLocationAuthorization;
///// 开始定位
//- (void)dq_startLocation;
///// 停止定位
//- (void)dq_stopLocation;

/// 获取地址成功
- (void)dq_findRegeoWithLat:(double)lat
                        lng:(double)lng
                    failure:(DQFailureBlock)failure
                    reverse:(DQAddressReverse)reverse;


@end

#endif /* DQLocationManager_h */
