//
//  LoginTextField.h
//  WebThings
//
//  Created by machinsight on 2017/7/12.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LoginTextField;
@protocol LoginTextFieldDelegate <NSObject>
- (void)textFieldDidEndEditing:(LoginTextField *)sender;
@end
@interface LoginTextField : UIControl
@property (nonatomic,  weak) id<LoginTextFieldDelegate> delegate;
@property (nonatomic,strong) UILabel *floatlab;
@property (nonatomic,strong) UITextField *textField;
@property (nonatomic,strong) UILabel *errorLab;
@property (nonatomic,assign) BOOL hasError;
@property (nonatomic,strong) NSString *placeH;
@property (nonatomic,strong) NSString *errorMsg;


- (void)setText:(NSString *)text;
@end
