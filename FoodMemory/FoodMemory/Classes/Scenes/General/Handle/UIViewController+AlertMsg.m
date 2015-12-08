//
//  UIViewController+AlertMsg.m
//  FoodMemory
//
//  Created by morplcp on 15/12/5.
//  Copyright © 2015年 morplcp. All rights reserved.
//

#import "UIViewController+AlertMsg.h"

@implementation UIViewController (AlertMsg)

- (void)alert:(NSString *)msg{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        LCPLog(@"知道了");
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

- (UIViewController*)viewController:(UIView *)view {
    for (UIView* next = [view superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

@end
