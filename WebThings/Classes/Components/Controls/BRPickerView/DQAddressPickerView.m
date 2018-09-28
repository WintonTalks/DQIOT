//
//  DQAddressPickerView.m
//  WebThings
//
//  Created by winton on 2017/10/17.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "DQAddressPickerView.h"

@interface DQAddressPickerView ()
<UIPickerViewDelegate,
UIPickerViewDataSource>
@property (strong, nonatomic) NSDictionary *pickerDic;
@property (strong, nonatomic) NSArray *selectedArray;
@property (strong, nonatomic) NSArray *provinceArray;
@property (strong, nonatomic) NSArray *cityArray;
@property (strong, nonatomic) NSArray *townArray;
@property (strong, nonatomic) UIPickerView *pickView;
@property (strong, nonatomic) UILabel *titleLabel;
@end

@implementation DQAddressPickerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        self.userInteractionEnabled = true;
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onRMSuperClick)]];
        [self getAddressInformation];
        [self setBaseView];
    }
    return self;
}

- (void)getAddressInformation
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Address" ofType:@"plist"];
    self.pickerDic = [[NSDictionary alloc] initWithContentsOfFile:path];
    self.provinceArray = [self.pickerDic allKeys];
    self.selectedArray = [self.pickerDic objectForKey:[[self.pickerDic allKeys] safeObjectAtIndex:0]];
    if (self.selectedArray.count > 0) {
        self.cityArray = [[self.selectedArray safeObjectAtIndex:0] allKeys];
    }
    if (self.cityArray.count > 0) {
        self.townArray = [[self.selectedArray safeObjectAtIndex:0] objectForKey:[self.cityArray safeObjectAtIndex:0]];
    }
}

- (void)setBaseView
{
    CGFloat height = self.frame.size.height;
    CGFloat width = self.frame.size.width;
    UIView *selectView = [[UIView alloc] initWithFrame:CGRectMake(0, height-kDatePicHeight-kTopViewHeight, width, kTopViewHeight)];
    selectView.backgroundColor = RGB_HEX(0xFDFDFD, 1.0f);
   
    UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancleBtn setTitle:@"取消" forState:0];
    [cancleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cancleBtn.titleLabel.font = [UIFont dq_regularSystemFontOfSize:14];
    cancleBtn.frame = CGRectMake(10, 0, 60, 30);
    [cancleBtn addTarget:self action:@selector(dateCancleAction) forControlEvents:UIControlEventTouchUpInside];
    [selectView addSubview:cancleBtn];
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((selectView.width-110)/2, 0, 110, cancleBtn.height)];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.font = [UIFont dq_regularSystemFontOfSize:14];
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [selectView addSubview:_titleLabel];
    
    UIButton *ensureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [ensureBtn setTitle:@"确定" forState:0];
    [ensureBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    ensureBtn.frame = CGRectMake(width - 60, cancleBtn.top, 60, 30);
    ensureBtn.titleLabel.font = [UIFont dq_regularSystemFontOfSize:14];
    [ensureBtn addTarget:self action:@selector(dateEnsureAction) forControlEvents:UIControlEventTouchUpInside];
    [selectView addSubview:ensureBtn];
    [self addSubview:selectView];
    
    self.pickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, height-kDatePicHeight , width,  kDatePicHeight)];
    self.pickView.delegate   = self;
    self.pickView.dataSource = self;
    self.pickView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.pickView];
    [self.pickView reloadAllComponents];
    [self updateAddress];
    
}

- (void)configTitle:(NSString *)title
{
    _titleLabel.text = title;
}

- (void)onRMSuperClick
{
    [self removeFromSuperview];
}

- (void)updateAddressAtProvince:(NSString *)province
                           city:(NSString *)city
                           town:(NSString *)town
{
    if (!province || !city || !town) {
        return;
    }
    
    self.province = province;
    self.city = city;
    self.area = town;
    if (self.province) {
        for (NSInteger i = 0; i < self.provinceArray.count; i++) {
            NSString *city = [self.provinceArray safeObjectAtIndex:i];
            NSInteger select = 0;
            if ([city isEqualToString:self.province]) {
                select = i;
                [self.pickView selectRow:i inComponent:0 animated:YES];
                break;
            }
        }
        self.cityArray = [self.pickerDic[self.province][0] allKeys];
        for (NSInteger i = 0; i < self.cityArray.count; i++) {
            NSString *city = self.cityArray[i];
            if ([city isEqualToString:self.city]) {
                [self.pickView selectRow:i inComponent:1 animated:YES];
                break;
            }
        }
        self.townArray = self.pickerDic[self.province][0][self.city];
        for (NSInteger i = 0; i < self.townArray.count; i++) {
            NSString *town = self.townArray[i];
            if ([town isEqualToString:self.area]) {
                [self.pickView selectRow:i inComponent:2 animated:YES];
                break;
            }
        }
    }
    [self.pickView reloadAllComponents];
    [self updateAddress];
}

- (void)dateCancleAction
{
    [self removeFromSuperview];
}

- (void)dateEnsureAction
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didAddressPickerWithProvince:city:area:pickerView:)]) {
        [self.delegate didAddressPickerWithProvince:self.province city:self.city area:self.area pickerView:self];
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row
          forComponent:(NSInteger)component
           reusingView:(UIView *)view
{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        pickerLabel.textAlignment = NSTextAlignmentCenter;
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont dq_mediumSystemFontOfSize:14]];
    }
    pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return self.provinceArray.count;
    } else if (component == 1) {
        return self.cityArray.count;
    } else {
        return self.townArray.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return [self.provinceArray safeObjectAtIndex:row];
    } else if (component == 1) {
        return [self.cityArray safeObjectAtIndex:row];
    } else {
        return [self.townArray safeObjectAtIndex:row];
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40.f;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return self.frame.size.width / 3;
}

- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component
{
    if (component == 0) {
        self.selectedArray = [self.pickerDic objectForKey:[self.provinceArray objectAtIndex:row]];
        if (self.selectedArray.count > 0) {
            self.cityArray = [[self.selectedArray safeObjectAtIndex:0] allKeys];
        } else {
            self.cityArray = @[];
        }
        if (self.cityArray.count > 0) {
            self.townArray = [[self.selectedArray safeObjectAtIndex:0] objectForKey:[self.cityArray objectAtIndex:0]];
        } else {
            self.townArray = @[];
        }
        [pickerView reloadComponent:1];
        [pickerView selectedRowInComponent:1];
        [pickerView reloadComponent:2];
        [pickerView selectedRowInComponent:2];
    }
    if (component == 1) {
        self.selectedArray = [self.pickerDic objectForKey:[self.provinceArray objectAtIndex:[self.pickView selectedRowInComponent:0]]];
        NSDictionary *dic = self.selectedArray.firstObject;
        NSString *stirng = self.cityArray[row];
        for (NSString *string in dic.allKeys) {
            if ([stirng isEqualToString:string]) {
                self.townArray = dic[string];
            }
        }
        [pickerView reloadComponent:2];
        [pickerView selectedRowInComponent:2];
    }
    if (component == 2) {
        [pickerView reloadComponent:2];
        [pickerView selectedRowInComponent:2];
    }
    [self updateAddress];
}

- (void)updateAddress {
    self.province = [self.provinceArray objectAtIndex:[self.pickView selectedRowInComponent:0]];
    self.city  = [self.cityArray objectAtIndex:[self.pickView selectedRowInComponent:1]];
    self.area  = [self.townArray objectAtIndex:[self.pickView selectedRowInComponent:2]];
}


@end
