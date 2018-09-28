//
//  EMIBaseViewController.m
//  WebThings
//
//  Created by machinsight on 2017/5/31.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "EMIBaseViewController.h"
#import "PushTransition.h"
#import "PopTransition.h"
#import "FABAnimation.h"
#import "CardTransition.h"
#import "ImitatePrensentNavTransition.h"
#import <UMMobClick/MobClick.h>

@interface EMIBaseViewController ()<UINavigationControllerDelegate>

@end

@implementation EMIBaseViewController

#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F3F4F5"];
    _baseUser = [AppUtils readUser];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _baseUser = [AppUtils readUser];
//    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

// 必须在viewDidAppear或者viewWillAppear中写，因为每次都需要将delegate设为当前界面
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
//    [MobClick endLogPageView:NSStringFromClass([self class])];
}

#pragma mark - Delegate
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
//    if (operation == UINavigationControllerOperationPush){ // 就是在这里判断是哪种动画类型
//        if (_pushType == 0) {
//            return [[PushTransition alloc] init]; // 返回push动画的类
//        }else if(_pushType == 1){
//            //回复默认动画
//            _pushType = 0;
//            FABAnimation *ani = [[FABAnimation alloc] initWithAnimatedView:self.animationView];
//            ani.cardVFrame = _cardVFrame;
//            ani.reverse = NO;
//            return ani;
//        }else if(_pushType == 2){
//            _pushType = 0;
//            CardTransition *ani = [[CardTransition alloc] init];
//            ani.cardVFrame = _cardVFrame;
//            ani.toCardFrame = _tocardVFrame;
//            ani.reverse = NO;
//            return ani;
//        }else if(_pushType == 3){
//            _pushType = 0;
//            ImitatePrensentNavTransition *ani = [[ImitatePrensentNavTransition alloc] init];
//            ani.reverse = NO;
//            return ani;
//        }
//
//    }else{
//        if (_pushType == 0) {
//            return [[PopTransition alloc] init];
//        }else if(_pushType == 1){
//            //回复默认动画
//            _pushType = 0;
//            FABAnimation *ani = [[FABAnimation alloc] initWithAnimatedView:self.animationView];
//            ani.cardVFrame = _cardVFrame;
//            ani.reverse = YES;
//            return ani;
//        }else if(_pushType == 2){
//            _pushType = 0;
//            CardTransition *ani = [[CardTransition alloc] init];
//            ani.cardVFrame = _cardVFrame;
//            ani.toCardFrame = _tocardVFrame;
//            ani.reverse = YES;
//            return ani;
//        }else if(_pushType == 3){
//            _pushType = 0;
//            ImitatePrensentNavTransition *ani = [[ImitatePrensentNavTransition alloc] init];
//            ani.reverse = YES;
//            return ani;
//        }
//    }
    return nil;
}

#pragma mark - Getter and Setter
/** 导航条的高度 */
- (CGFloat)navigationBarHeight {
    CGFloat height = self.appBar.headerViewController.headerView.frame.size.height;
    return height < 64 ? 64 : height;
}

- (BOOL)isZuLin {
    if ([[AppUtils readUser].type  isEqualToString:@"租赁商"]) {
        return YES;
    }
    return NO;
}

- (BOOL)isCEO {
    if ([[AppUtils readUser].usertype isEqualToString:@"CEO"]) {
        //CEO只能看看，无操作权限
        return YES;
    }
    return NO;
}

@end
