//
//  DQPhoneManager.m
//  WebThings
//
//  Created by Eugene on 10/28/17.
//  Copyright © 2017 陈凯. All rights reserved.
//

#import "DQPhoneManager.h"
#import "DQAlert.h"

@interface DQPhoneManager () {
 
    DQAlert *_alertView;
}
@end

@implementation DQPhoneManager

+ (instancetype)sharedManager {
    static DQPhoneManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[DQPhoneManager alloc]init];
    });
    return manager;
}

- (void)dq_callUpNumber:(NSString *)number {
    
    NSMutableString *phoneNo = [[NSMutableString alloc] initWithFormat:@"tel:%@",number];

    _alertView = [[DQAlert alloc] init];
    [_alertView showAlertWithTitle:number okBtn:@"呼叫" cancelBtn:@"取消" okClick:^(NSInteger index) {
        // Typical usage
        [self openScheme:phoneNo];
    } cancelClick:^(NSInteger index) {
        
    }];

}

- (void)openScheme:(NSString *)scheme {
    
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *URL = [NSURL URLWithString:scheme];
    
    if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
        [application openURL:URL options:@{}
           completionHandler:^(BOOL success) {
               
           }];
    } else {
        BOOL success = [application openURL:URL];
    }
}


    //    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"拨号" message:number preferredStyle:UIAlertControllerStyleAlert];
    //    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    //    }];
    //
    //    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"呼叫" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    //        // Typical usage
    //        [[self class] openScheme:phoneNo failBlock:failBlock];
    //    }];
    //
    //        // Add the actions.
    //    [alertController addAction:cancelAction];
    //    [alertController addAction:otherAction];
    //    [viewController presentViewController:alertController animated:YES completion:nil];
@end
