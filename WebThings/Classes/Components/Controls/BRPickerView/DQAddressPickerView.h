//
//  DQAddressPickerView.h
//  WebThings
//
//  Created by winton on 2017/10/17.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kDatePicHeight 200
#define kTopViewHeight 44

#define SCREEN_BOUNDS [UIScreen mainScreen].bounds

/// RGB颜色(16进制)
#define RGB_HEX(rgbValue, a) \
[UIColor colorWithRed:((CGFloat)((rgbValue & 0xFF0000) >> 16)) / 255.0 \
green:((CGFloat)((rgbValue & 0xFF00) >> 8)) / 255.0 \
blue:((CGFloat)(rgbValue & 0xFF)) / 255.0 alpha:(a)]
@class DQAddressPickerView;

@protocol DQAddressPickerViewDelegate <NSObject>
@optional
/** 代理方法返回省市区*/
- (void)didAddressPickerWithProvince:(NSString *)province
                               city:(NSString *)city
                               area:(NSString *)area
                          pickerView:(DQAddressPickerView *)pickerView;
@end

@interface DQAddressPickerView : UIView
@property (nonatomic,   weak) id<DQAddressPickerViewDelegate> delegate;
/** 省 */
@property (nonatomic, strong) NSString *province;
/** 市 */
@property (nonatomic, strong) NSString *city;
/** 区 */
@property (nonatomic, strong) NSString *area;
- (void)configTitle:(NSString *)title;
- (void)updateAddressAtProvince:(NSString *)province city:(NSString *)city town:(NSString *)town;
@end

