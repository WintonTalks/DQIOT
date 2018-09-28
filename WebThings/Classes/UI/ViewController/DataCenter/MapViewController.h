//
//  MapViewController.h
//  WebThings
//
//  Created by machinsight on 2017/7/10.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "EMIBaseViewController.h"
#import "DataCenterModel.h"
#import <BaiduMapAPI_Search/BMKSearchComponent.h>

@interface MapViewController : EMIBaseViewController
<BMKGeoCodeSearchDelegate>
{
//    UILabel *_kgmcsLab;        // 开关门次数
    UILabel *_ljTimeLab;                // 累计工作时间
//    UIScrollView *_scV;
    BMKMapView *_mapV;
    BMKLocationService *_locService;
    BMKGeoCodeSearch *_geocodesearch;
}

- (void)setViewValuesWithModel:(DataCenterModel *)model;

@end
