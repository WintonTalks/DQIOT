//
//  CKAlertContainerView.m
//  WebThings
//
//  Created by machinsight on 2017/6/22.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "CKAlertContainerView.h"
#import "CKAlertView.h"
@interface CKAlertContainerView()
@property(nonatomic,strong)UIView *alertV;
@end
@implementation CKAlertContainerView{
    UIView *popupHolder;
}
- (instancetype)init {
    self = [super init];
    if (self) {
        UIView *view = [MDDeviceHelper getMainView];
        [self setFrame:view.bounds];
        
        popupHolder = [[UIView alloc] init];
        popupHolder.layer.shadowOpacity = 0.5;
        popupHolder.layer.shadowRadius = 8;
        popupHolder.layer.shadowColor = [[UIColor blackColor] CGColor];
        popupHolder.layer.shadowOffset = CGSizeMake(0, 2.5);
        
        [popupHolder
         setFrame:CGRectMake((screenWidth-298)/2, (screenHeight-175)/2, 298, 175)];
        

        [self
         setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.5]];
        self.hidden = YES;
        [self addTarget:self
                 action:@selector(btnClick:)
       forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:popupHolder];
    }
    return self;
}

- (void)addView:(UIView *)view{
//    _alertV = [[CKAlertView alloc] initWithFrame:CGRectMake(0, 0, 298, 175)];
    _alertV = view;
    [popupHolder addSubview:_alertV];
    
}

- (void)show {
    [self addSelfToMainWindow];
    self.hidden = NO;
}
- (void)btnClick:(id)sender {
    self.hidden = YES;
}
- (void)addSelfToMainWindow {
    UIView *view = [MDDeviceHelper getMainView];
    [self setFrame:view.bounds];
    [view addSubview:self];
}


@end
