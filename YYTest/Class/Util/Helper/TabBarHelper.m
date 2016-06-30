//
//  TabBarHelper.m
//  YYTest
//
//  Created by chengxianghe on 16/1/20.
//  Copyright © 2016年 CXH. All rights reserved.
//

#import "TabBarHelper.h"

@implementation TabBarHelper
+ (void)hidesTabBar:(BOOL)isHidden {
    UITabBarController *tab = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    if (tab.view.subviews == nil) { return; }
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    
    for (UIView *view in tab.view.subviews) {
        if ([view isKindOfClass:[UITabBar class]]) {
            if (isHidden) {
                view.frame = CGRectMake(view.frame.origin.x, [UIScreen mainScreen].bounds.size.height, view.frame.size.width, view.frame.size.height);
            }else{
                view.frame = CGRectMake(view.frame.origin.x, [UIScreen mainScreen].bounds.size.height - 49, view.frame.size.width, view.frame.size.height);
            }
        } else {
            if ([view isKindOfClass:NSClassFromString(@"UITransitionView")]) {
                if (isHidden) {
                    view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, [UIScreen mainScreen].bounds.size.height);
                }else{
                    view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, [UIScreen mainScreen].bounds.size.height - 49);
                }
            }
        }
    }
    
    [UIView commitAnimations];
}
@end
