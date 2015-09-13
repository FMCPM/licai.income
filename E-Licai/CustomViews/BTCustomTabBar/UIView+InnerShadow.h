//
//  UIView+InnerShadow.h
//
//  Created by Joy Chiang on 12-2-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface UIView (InnerShadow)

- (void)drawInnerShadowInRect:(CGRect)rect fillColor:(UIColor *)fillColor;
- (void)drawInnerShadowInRect:(CGRect)rect radius:(CGFloat)radius fillColor:(UIColor *)fillColor;

@end

//////////////////////////////////////////////////////////////////////////////

CGRect rectFor1PxStroke(CGRect rect);
void drawLinearGradient(CGContextRef context, CGRect rect, CGColorRef startColor, 
                        CGColorRef  endColor);
void draw1PxStroke(CGContextRef context, CGPoint startPoint, CGPoint endPoint, 
                   CGColorRef color);
void drawGlossAndGradient(CGContextRef context, CGRect rect, CGColorRef startColor, 
                          CGColorRef endColor);
static inline double radians (double degrees) { return degrees * M_PI/180; }
CGMutablePathRef createArcPathFromBottomOfRect(CGRect rect, CGFloat arcHeight);