//
//  PushAlert.m
//  WebThings
//
//  Created by machinsight on 2017/8/11.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "PushAlert.h"
#import "PushWXView.h"
@interface PushAlert()
@property (nonatomic,strong)PushWXView *pwxV;
@end
@implementation PushAlert{
}

- (instancetype)init{
    self = [super init];
    if (self) {
        UIView *view = [MDDeviceHelper getMainView];
        [self setFrame:view.bounds];
        
        if (!_pwxV) {
            _pwxV = [[PushWXView alloc] init];
            [self addSubview:_pwxV];
        }
        [self setBackgroundColor:[UIColor colorWithHexString:@"000000" alpha:0.5]];
        [self addTarget:self
                 action:@selector(btnClick:)
       forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}


- (void)btnClick:(PushAlert *)sender{
    self.hidden = YES;
}

- (void)show {
    _pwxV.m = _m;
    [_pwxV setViewValues];
    [self addSelfToMainWindow];
    self.hidden = NO;
    
}

- (void)addSelfToMainWindow {
    UIView *view = [MDDeviceHelper getMainView];
    [self setFrame:view.bounds];
    [view addSubview:self];
}
@end
