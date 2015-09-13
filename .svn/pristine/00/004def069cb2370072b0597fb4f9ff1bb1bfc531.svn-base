//
//  UIView+Positioning.m
//
//  Created by Joy Chiang on 12-2-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIView+Positioning.h"
#import "UIView+Size.h"

@implementation UIView (Positioning)

- (void)centerInRect:(CGRect)rect {
  [self setCenter:CGPointMake(floorf(CGRectGetMidX(rect)) + ((int)floorf([self width]) % 2 ? .5 : 0) , floorf(CGRectGetMidY(rect)) + ((int)floorf([self height]) % 2 ? .5 : 0))];
}

- (void)centerVerticallyInRect:(CGRect)rect {
  [self setCenter:CGPointMake([self center].x, floorf(CGRectGetMidY(rect)) + ((int)floorf([self height]) % 2 ? .5 : 0))];
}

- (void)centerHorizontallyInRect:(CGRect)rect {
  [self setCenter:CGPointMake(floorf(CGRectGetMidX(rect)) + ((int)floorf([self width]) % 2 ? .5 : 0), [self center].y)];
}

- (void)centerInSuperView {
  [self centerInRect:[[self superview] bounds]];
}
- (void)centerVerticallyInSuperView {
  [self centerVerticallyInRect:[[self superview] bounds]];
}
- (void)centerHorizontallyInSuperView {
  [self centerHorizontallyInRect:[[self superview] bounds]];
}

- (void)centerHorizontallyBelow:(UIView *)view padding:(CGFloat)padding {
    // for now, could use screen relative positions.
  NSAssert([self superview] == [view superview], @"views must have the same parent");
  
  [self setCenter:CGPointMake([view center].x,
                              floorf(padding + CGRectGetMaxY([view frame]) + ([self height] / 2)))];
}

- (void)centerHorizontallyBelow:(UIView *)view {
  [self centerHorizontallyBelow:view padding:0];
}

@end