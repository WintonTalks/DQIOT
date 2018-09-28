//
//  DQLocationManager.m
//  WebThings
//  定位管理
//  Created by Heidi on 2017/9/12.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DQLocationManager.h"

@implementation DQLocationManager

//+ (DQLocationManager*)sharedInstance
//{
//    static DQLocationManager *sharedInstance = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        sharedInstance = [[DQLocationManager alloc] init];
//        // Do any other initialisation stuff here
//    });
//    return sharedInstance;
//}

- (id)init
{
    self = [super init];
    if(self)
    {
//        _locService = [[BMKLocationService alloc] init];
//        _locService.delegate = self;
        
        _geocodesearch = [[BMKGeoCodeSearch alloc]init];
        _geocodesearch.delegate = self;
    }
    
    return self;
}

/// 是否能获取定位权限
- (BOOL)dq_canGetLocationAuthorization {
    const BOOL bRet = [CLLocationManager locationServicesEnabled];
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    if(bRet && (status == kCLAuthorizationStatusNotDetermined ||
                status ==  kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusAuthorizedAlways))
    {
        return YES;
    }
    else {
        return NO;
    }
}

/// 开始定位
- (void)dq_startLocation {

//    [_locService startUserLocationService];
}

/// 停止定位
- (void)dq_stopLocation {
//    [_locService stopUserLocationService];
}

/// 获取地址成功
- (void)dq_findRegeoWithLat:(double)lat
                        lng:(double)lng
                    failure:(DQFailureBlock)failure
                    reverse:(DQAddressReverse)reverse {
    self.errorBlock = failure;
    self.reverseBlock = reverse;
    _lat = lat;
    _lng = lng;

    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc] init];
    reverseGeocodeSearchOption.reverseGeoPoint = CLLocationCoordinate2DMake(lat, lng);
    BOOL flag = [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    if(flag)
    {
        DQLog(@"反geo检索发送成功");
    }
    else
    {
        DQLog(@"反geo检索发送失败");
    }
}

#pragma mark - BMKLocationServiceDelegate
/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    
//    self.userPosition = userLocation;
//    self.successBlock(userLocation.location.coordinate.latitude, userLocation.location.coordinate.latitude);

}
- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {
    DQLog(@"onGetGeoCodeResult");
}
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher
                            result:(BMKReverseGeoCodeResult *)result
                         errorCode:(BMKSearchErrorCode)error
{
    DQLog(@"onGetReverseGeoCodeResult");

    if (error == 0) {
        if (self.reverseBlock) {
            self.reverseBlock(result.address, result.cityCode);
        }
    }
}


@end
