//
//  DQNewBusContactController.m
//  WebThings
//  添加商务往来／整改意见
//  Created by Heidi on 2017/10/16.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DQNewBusContactController.h"
#import "DQTextFiledInfoCell.h"
#import "DQTextFieldArrowForCell.h"

#import "DateTimePickerView.h"
#import "NSDate+BRAdd.h"
#import "MDSnackbar.h"

#import "DQBusinessContactInterface.h"

@interface DQNewBusContactController () <DateTimePickerViewDelegate>

@end

@implementation DQNewBusContactController

#pragma mark - Getter
- (UILabel *)labelWithFrame:(CGRect)frame
                      title:(NSString *)title
                  textAlign:(NSTextAlignment)align
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.font = [UIFont systemFontOfSize:16];
    label.text = title;
    label.textColor = [UIColor colorWithHexString:COLOR_BLACK];
    label.textAlignment = align;
    
    return label;
}

#pragma mark - Init
- (void)initSubviews {
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = _titleStr;

    CGFloat y = self.navigationBarHeight + 16;
    CGFloat width = screenWidth - 32;

    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(onSubmitClick) title:@"提交"]; 
    
    if (@available(iOS 11.0, *)) {
        _contentView.contentInset = UIEdgeInsetsMake(-64.,0,0,0);
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

    _contentView = [[UITextView alloc]
                    initWithFrame:CGRectMake(16, y,
                                             screenWidth - 32, 148)];
    _contentView.backgroundColor = [UIColor colorWithHexString:COLOR_BG];
    _contentView.font = [UIFont systemFontOfSize:14];
    _contentView.delegate = self;
    [self.view addSubview:_contentView];
    
    _placeHolder = [[UILabel alloc] initWithFrame:CGRectMake(21, y + 8, _contentView.width, 16)];
    _placeHolder.font = [UIFont systemFontOfSize:14];
    _placeHolder.textColor = [UIColor colorWithHexString:COLOR_TITLE_GRAY];
    _placeHolder.text = _enumState == DQEnumStateBusContactAdd ? @"请输入商务往来内容" : @"请输入整改意见内容";
    [self.view addSubview:_placeHolder];
    
    y += _contentView.frame.size.height + 10;

    UIView *selectView = [[UIView alloc] initWithFrame:CGRectMake(16, y, width, 44)];
    [self.view addSubview:selectView];
    
    UILabel *label = [self
                      labelWithFrame:CGRectMake(0, 0, (width - 41) / 2.0, 44)
                      title:@"检查日期"
                      textAlign:NSTextAlignmentLeft];
    [selectView addSubview:label];
    
    _lblTimeLabel = [self
                      labelWithFrame:CGRectMake((width - 41) / 2.0, 0, (width - 41) / 2.0, 44)
                      title:@"请选择"
                      textAlign:NSTextAlignmentRight];
    _lblTimeLabel.textColor = [UIColor colorWithHexString:COLOR_TITLE_GRAY];
    [selectView addSubview:_lblTimeLabel];
    
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(width - 16, 22 - 8, 9, 16)];
    icon.image = [UIImage imageNamed:@"icon_indictor"];
    [selectView addSubview:icon];
    
    //[EMINavigationController addAppBar:self];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = selectView.frame;
    [button addTarget:self
               action:@selector(onDateSelect)
     forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self.view addGestureRecognizer:tapGesture];
}

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSubviews];
}

#pragma mark -
/** 收起键盘 */
- (void)tap {
    [_contentView resignFirstResponder];
}

/** 检查输入合法性 */
- (BOOL)isAvailable {
    NSString *time = _lblTimeLabel.text;
    NSString *content = _contentView.text;
    
    if ([time isEqualToString:@"请选择"]) {
        MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"请选择检查日期"
                                             actionTitle:@"" duration:3.0];
        [t show];
        
        return NO;
    }
    if (content.length < 1) {
        MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"请输入内容"
                                             actionTitle:@"" duration:3.0];
        [t show];
        return NO;
    }
    return YES;
}

#pragma mark - Button clicks
- (void)onSubmitClick {
    [_contentView resignFirstResponder];

    if (![self isAvailable]) {
        return;
    }
    NSString *time = _lblTimeLabel.text;
    NSString *content = [_contentView.text dq_filterEmoji];

    if (_enumState == DQEnumStateBusContactAdd) {   // 添加商务往来
        [[DQBusinessContactInterface sharedInstance]
         dq_addBusContProjID:@(_projectID)
         date:time
         content:content
         success:^(id result) {
             
//             MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"添加成功"
//                                                  actionTitle:@"" duration:3.0];
//             [t show];
             [self.navigationController popViewControllerAnimated:YES];
             
         } failture:^(NSError *error) {
             MDSnackbar *t = [[MDSnackbar alloc] initWithText:error.domain
                                                  actionTitle:@"添加失败" duration:3.0];
             [t show];
         }];
    } else if (_enumState == DQEnumStateBusConAdviceAdd) {  // 添加整改意见
        [[DQBusinessContactInterface sharedInstance]
         dq_addBusContAdviceProjID:@(_projectID)
         date:time
         content:content
         businessid:_businessID
         success:^(id result) {
             [self.navigationController popViewControllerAnimated:YES];
         } failture:^(NSError *error) {
             MDSnackbar *t = [[MDSnackbar alloc] initWithText:error.domain
                                                  actionTitle:@"添加失败" duration:3.0];
             [t show];
         }];
    }
}

#pragma mark - Tap
- (void)onDateSelect {
    [_contentView resignFirstResponder];

    DateTimePickerView *pickerView = [[DateTimePickerView alloc] init];
    pickerView.delegate = self;
    pickerView.minDate = [NSDate date];
    pickerView.pickerViewMode = DatePickerViewDateTimeMode;
    [self.view addSubview:pickerView];
    [pickerView showDateTimePickerView];
}

#pragma mark - delegate
- (void)didClickFinishDateTimePickerView:(NSString *)date{
    _lblTimeLabel.text = [date stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
    _lblTimeLabel.textColor = [UIColor colorWithHexString:COLOR_BLACK];
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView
shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text {
    BOOL hide = range.location != 0 || text.length > 0;
//    if (text.length < 1 && textView.text.length <= 1) {
//        hide = NO;
//    }
    _placeHolder.hidden = hide;
    
    return YES;
}

@end
