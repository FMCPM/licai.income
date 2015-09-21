//
//  UIView+Positioning.h
//
//  Created by Joy Chiang on 12-2-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Positioning)

- (void)centerInRect:(CGRect)rect;
- (void)centerVerticallyInRect:(CGRect)rect;
- (void)centerHorizontallyInRect:(CGRect)rect;

- (void)centerInSuperView;
- (void)centerVerticallyInSuperView;
- (void)centerHorizontallyInSuperView;

- (void)centerHorizontallyBelow:(UIView *)view padding:(CGFloat)padding;
- (void)centerHorizontallyBelow:(UIView *)view;

@end