//
//  ServiceCommentViewController.m
//  WebThings
//
//  Created by machinsight on 2017/7/4.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "ServiceCommentViewController.h"
#import "EMICardView.h"
#import "XHStarRateView.h"
#import "AddServiceEvaluateWI.h"

@interface ServiceCommentViewController ()<UITextViewDelegate>{
    
}
@property (weak, nonatomic) IBOutlet EMICardView *topFatherV;
@property (weak, nonatomic) IBOutlet UITextView *tv;

@property CGFloat currentScore;
@end

@implementation ServiceCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"服务评价";
    
    [self initView];
    //[EMINavigationController addAppBar:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initView{
    [self rightNavBtn];
    
    XHStarRateView *starRateView3 = [[XHStarRateView alloc] initWithFrame:CGRectMake(25, 10, screenWidth-16-50, 78) finish:^(CGFloat currentScore) {
        self.currentScore = currentScore;
    }];
    [self.topFatherV addSubview:starRateView3];
    self.tv.delegate = self;
    [self.tv borderWid:1];
    [self.tv borderColor:[UIColor colorWithHexString:@"#E1E2E3"]];
}

- (UIBarButtonItem *)rightNavBtn{
    UIBarButtonItem *rightNav = [UIBarButtonItem itemWithTarget:self action:@selector(rightNavClicked) image:[UIImage imageNamed:@"ic_done"]];
    self.navigationItem.rightBarButtonItem = rightNav;
    return rightNav;
}

- (void)rightNavClicked{
    [self.view endEditing:YES];
    if (_currentScore == 0) {
        MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"请选择评级" actionTitle:@"" duration:3.0];
        [t show];
        return;
    }
    if (!_tv.text.length) {
        MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"评价内容不能为空" actionTitle:@"" duration:3.0];
        [t show];
        return;
    }
    [self fetchAdd];
}


#pragma hidekeyboard
- (IBAction)hideKeyBoard:(id)sender {
    [self.view endEditing:YES];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@"请写下您要对我们服务的评价"]) {
        textView.text = @"";
    }
    return YES;
}

/**
 新增
 */
- (void)fetchAdd{
    AddServiceEvaluateWI *lwi = [[AddServiceEvaluateWI alloc] init];
    NSArray *arr = @[@(self.baseUser.userid),self.baseUser.type,@(_projectid),@(_dm.deviceid),@(_currentScore),_tv.text,self.baseUser.usertype];
    NSDictionary *param = [lwi inBox:arr];
    [CKNetTools requestWithRequestType:POST WithURL:lwi.fullUrl WithParamater:param WithProgressBlock:^(NSProgress *process) {
        
    } WithSuccessBlock:^(id returnValue) {
        NSArray *temp = [lwi unBox:returnValue];
        if ([temp[0] integerValue] == 1) {
            [self.navigationController popViewControllerAnimated:YES];
            if (self.basedelegate && [self.basedelegate respondsToSelector:@selector(didPopFromNextVC)]) {
                [self.basedelegate didPopFromNextVC];
            };
        }
        
        
    } WithFailureBlock:^(NSError *error) {
        
    }];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
