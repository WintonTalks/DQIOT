//
//  WTScrollViewKeyboardManager.m
//  WTScrollViewKeyboardManager
//
//  Created by Andrew Carter on 10/7/13.
//  Copyright (c) 2013 WillowTree Apps. All rights reserved.
//

#import "WTScrollViewKeyboardManager.h"

@implementation WTScrollViewKeyboardManager

#pragma mark - Accessors

- (void)setScrollView:(UIScrollView *)scrollView
{
    _scrollView = scrollView;
}

#pragma mark Instance Methods

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self setShouldFlashScrollIndicators:YES];
        [self setContentInsetsWithKeyboard:UIEdgeInsetsZero];
        [self setContentInsetsWithoutKeyboard:UIEdgeInsetsZero];
        [self setScrollIndicatorInsetsWithKeyboard:UIEdgeInsetsZero];
        [self setScrollIndicatorInsetsWithKeyboard:UIEdgeInsetsZero];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardDidShow:)
                                                     name:UIKeyboardDidShowNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardDidHide:)
                                                     name:UIKeyboardDidHideNotification
                                                   object:nil];
    }
    return self;
}

- (instancetype)initWithScrollView:(UIScrollView *)scrollView viewController:(UIViewController *)viewController
{
    self = [self init];
    if (self)
    {
        [self setScrollView:scrollView];
        [self setViewController:viewController];
    }
    return self;
}

- (void)keyboardDidShow:(NSNotification *)notification
{
    if ([[self delegate] respondsToSelector:@selector(keyboardDidShow:userInfo:)])
    {
        [[self delegate] keyboardDidShow:self userInfo:[notification userInfo]];
    }
}

- (void)keyboardDidHide:(NSNotification *)notification
{
    if ([[self delegate] respondsToSelector:@selector(keyboardDidHide:userInfo:)])
    {
        [[self delegate] keyboardDidHide:self userInfo:[notification userInfo]];
    }
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    
    if ([[self delegate] respondsToSelector:@selector(keyboardWillShow:userInfo:)])
    {
        [[self delegate] keyboardWillShow:self userInfo:userInfo];
    }
    
    CGRect keyboardFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardFrame = [[self scrollView] convertRect:keyboardFrame fromView:nil];
    CGFloat minY = CGRectGetMinY(keyboardFrame);
    CGFloat height = CGRectGetHeight([[self scrollView] bounds]) - minY + [[self scrollView] contentOffset].y;
    
    
    [UIView animateWithDuration:[userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue]
                          delay:0.0f
                        options:[userInfo[UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue]
                     animations:^{
                         
                         UIEdgeInsets contentInsets = [self contentInsetsWithKeyboard];
                         UIEdgeInsets scrollInsets = [self scrollIndicatorInsetsWithKeyboard];
                         
                         [[self scrollView] setContentInset:UIEdgeInsetsMake([[self viewController] topLayoutGuide].length + contentInsets.top,
                                                                             contentInsets.left,
                                                                             height + contentInsets.bottom,
                                                                             contentInsets.right)];
                         [[self scrollView] setScrollIndicatorInsets:UIEdgeInsetsMake([[self viewController] topLayoutGuide].length + scrollInsets.top,
                                                                                      scrollInsets.left,
                                                                                      height + scrollInsets.bottom,
                                                                                      scrollInsets.right)];
                         
                         
                     } completion:^(BOOL finished) {
                         
                         if ([self shouldFlashScrollIndicators])
                         {
                             [[self scrollView] flashScrollIndicators];
                         }
                         
                     }];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    
    if ([[self delegate] respondsToSelector:@selector(keyboardWillHide:userInfo:)])
    {
        [[self delegate] keyboardWillHide:self userInfo:userInfo];
    }
    
    [UIView animateWithDuration:[userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue]
                          delay:0.0f
                        options:[userInfo[UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue]
                     animations:^{
                         
                         UIEdgeInsets contentInsets = [self contentInsetsWithoutKeyboard];
                         UIEdgeInsets scrollInsets = [self scrollIndicatorInsetsWithoutKeyboard];
                         
                         [[self scrollView] setContentInset:contentInsets];
                         [[self scrollView] setScrollIndicatorInsets:scrollInsets];
                         
                         
                     } completion:^(BOOL finished) {
                         
                         if ([self shouldFlashScrollIndicators])
                         {
                             [[self scrollView] flashScrollIndicators];
                         }
                         
                     }];
}

@end
