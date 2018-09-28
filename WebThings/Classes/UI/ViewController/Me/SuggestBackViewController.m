//
//  SuggestBackViewController.m
//  WebThings
//
//  Created by machinsight on 2017/7/4.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "SuggestBackViewController.h"

@interface SuggestBackViewController ()
{
    UITextView *_mTextView;
    UIView *_infoView;
}
@end

static NSString *text = @"请写下您对我们要说的话";

@implementation SuggestBackViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    // [EMINavigationController addAppBar:self barHeight:64 shadowColor:[UIColor whiteColor]];
}

- (void)initView
{
    self.title = @"意见反馈";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(rightNavClicked) title:@"提交"];
    
    _infoView = [[UIView alloc] initWithFrame:CGRectMake(0, 74, screenWidth, screenHeight-74)];
    _infoView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_infoView];
    
    _mTextView = [[UITextView alloc] initWithFrame:CGRectMake(16, 16, _infoView.width-32, 148)];
    _mTextView.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7"];
    [_mTextView jk_addPlaceHolder:text];
    _mTextView.textColor = [UIColor colorWithHexString:COLOR_BLACK];
    _mTextView.font = [UIFont dq_mediumSystemFontOfSize:16];
    _mTextView.textAlignment = NSTextAlignmentLeft;
    [_infoView addSubview:_mTextView];
    
    if (@available(iOS 11.0, *)) {
        //_mTextView.contentInset = UIEdgeInsetsMake(-74.,0,0,0);
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)rightNavClicked
{
    [self.view endEditing:true];
    [MobClick event:@"usercenter_submit_proposal"];
    if (!_mTextView.text.length) {
        MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"输入内容部不能为空" actionTitle:@"" duration:3.0];
        [t show];
        return;
    }
    [self fetchSubmit];
}

- (void)fetchSubmit
{
    [[DQMyCenterInterface sharedInstance] dq_getUserFeedBackApi:self.baseUser text:_mTextView.text success:^(id result) {
        //成功
        MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"提交成功" actionTitle:@"" duration:3.0];
        [t show];
        [self.navigationController popViewControllerAnimated:YES];
    } failture:^(NSError *error) {
        
    }];
}

@end
