//
//  EditDriverViewController.m
//  WebThings
//
//  Created by machinsight on 2017/7/19.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "EditDriverViewController.h"
#import "DQAddNewDeriveView.h"
#import "EMICardView.h"
@interface EditDriverViewController ()<DQAddNewDeriveViewDelegate>
{
    EMICardView *_cardView;
}
@property (nonatomic, strong) DQAddNewDeriveView *fixDeriveView;
@end

@implementation EditDriverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"修改司机";
    [self initView];
    [self configDeriveInit];
    //[EMINavigationController addAppBar:self barHeight:64 shadowColor:[UIColor whiteColor]];
}

- (void)configDeriveInit
{
    self.fixDeriveView.infoModel = self.dm;
}

- (void)addNewDeriveWithModel:(DQAddNewDeriveView *)deriveView  model:(DriverModel *)addModel
{
    self.dm = addModel;
}

#pragma hidekeyboard
- (IBAction)hideKeyBoard:(id)sender {
    [self.view endEditing:YES];
}

- (void)initView
{
    UIBarButtonItem *rightNav = [UIBarButtonItem itemWithTarget:self action:@selector(rightNavClicked) image:[UIImage imageNamed:@"ic_done"]];
    self.navigationItem.rightBarButtonItem = rightNav;
    
    _cardView = [[EMICardView alloc] initWithFrame:CGRectMake(8, 77, screenWidth-16, self.view.height-77-10)];
    _cardView.backgroundColor = [UIColor whiteColor];
    //[UIColor colorWithHexString:@"#F3F4F5"];
    [self.view addSubview:_cardView];
    [_cardView addSubview:self.fixDeriveView];
}

- (void)rightNavClicked
{
    _dm = [self.fixDeriveView configInitDeriveModel];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didPopWithDriver:WithIndex:)]) {
        [self.delegate didPopWithDriver:_dm WithIndex:_index];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (DQAddNewDeriveView *)fixDeriveView
{
    if (!_fixDeriveView) {
        _fixDeriveView = [[DQAddNewDeriveView alloc] initWithFrame:CGRectMake(0, 0, _cardView.width, _cardView.height)];
        _fixDeriveView.delegate = self;
        _fixDeriveView.type = DQAddNewDeriveViewFixStyle;
    }
    return _fixDeriveView;
}

@end
