//
//  UIView+CKKit.m
//  YTSearch
//
//  Created by jiangjunchen on 12-11-25.
//
//

#import "UIView+CKKit.h"

@implementation UIView (CKKit)
-(UIViewController *)viewController {
    for (UIView *next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}
@end
