//
//  PrettyNavigationBar.m
//  PrettyExample
//
//  Created by Víctor on 01/03/12.

// Copyright (c) 2012 Victor Pena Placer (@vicpenap)
// http://www.victorpena.es/
// 
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy of
// this software and associated documentation files (the "Software"), to deal in
// the Software without restriction, including without limitation the rights to
// use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
// the Software, and to permit persons to whom the Software is furnished to do so,
// subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.


#import "PrettyNavigationBar.h"
#import <QuartzCore/QuartzCore.h>
#import "PrettyDrawing.h"
#import <math.h>

@implementation PrettyNavigationBar
@synthesize shadowOpacity, gradientEndColor, gradientStartColor, topLineColor, bottomLineColor, roundedCornerRadius, roundedCornerColor, backgroundImage;

#define default_shadow_opacity 0.1
#define default_roundedcorner_color     [UIColor whiteColor]
/*

#define default_gradient_end_color      [UIColor colorWithHex:0x297CB7]
#define default_gradient_start_color    [UIColor colorWithHex:0x53A4DE]
#define default_top_line_color          [UIColor colorWithHex:0x84B7D5]
#define default_bottom_line_color       [UIColor colorWithHex:0x186399]
#define default_tint_color              [UIColor colorWithHex:0x3D89BF]

*/
- (void)dealloc {
    self.gradientStartColor = nil;;
    self.gradientEndColor = nil;
    self.topLineColor = nil;
    self.bottomLineColor = nil;
    self.roundedCornerColor = nil;    
}

-(void)setPrettyNavBarColor
{

    //modify by lzq at 2014-1-03-13:导航条改成背景图
   //self.tintColor = [UIColor colorWithHex:0x303030];
    self.tintColor = [UIColor whiteColor];
    self.backgroundImage = [UIImage imageNamed:@"bg_top_navbar.png"];

    /*
    self.topLineColor = [UIColor colorWithRed:255.0/255 green:155.0/255 blue:19.0/255 alpha:1.0];
    self.gradientStartColor = [UIColor colorWithRed:255.0/255 green:123.0/255 blue:19.0/255 alpha:1.0];
    self.gradientEndColor = [UIColor colorWithRed:255.0/255 green:97.0/255 blue:22.0/255 alpha:1.0];
    self.bottomLineColor = [UIColor colorWithRed:218.0/255 green:102.0/255 blue:22.0/255 alpha:1.0];
    self.tintColor = self.gradientStartColor;
     */
}

- (void) initializeVars 
{
    self.contentMode = UIViewContentModeRedraw;
    self.shadowOpacity = default_shadow_opacity;
    /*
    self.gradientStartColor = default_gradient_start_color;
    self.gradientEndColor = default_gradient_end_color;
    self.topLineColor = default_top_line_color;
    self.bottomLineColor = default_bottom_line_color;
    self.tintColor = default_tint_color;
     */
    self.roundedCornerColor = default_roundedcorner_color;
    self.roundedCornerRadius = 0.0;
    self.backgroundColor = [UIColor whiteColor];
    [self setPrettyNavBarColor];
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self initializeVars];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeVars];
    }
    return self;
}


- (id)init {
    self = [super init];
    if (self) {
        [self initializeVars];
    }
    return self;
}


-(void) drawLeftRoundedCornerAtPoint:(CGPoint)point withRadius:(CGFloat)radius withTransformation:(CGAffineTransform)transform {
    
    // create the path. has to be done this way to allow use of the transform
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, &transform, point.x, point.y);
    CGPathAddLineToPoint(path, &transform, point.x, point.y + radius);
    CGPathAddArc(path, &transform, point.x + radius, point.y + radius, radius, (180) * M_PI/180, (-90) * M_PI/180, 0);
    CGPathAddLineToPoint(path, &transform, point.x, point.y);
    
    // fill the path to create the illusion that the corner is rounded
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddPath(context, path);
    CGContextSetFillColorWithColor(context, [self.roundedCornerColor CGColor]);
    CGContextFillPath(context);

    // appropriate memory management
    CGPathRelease(path);
}


-(void)clipRoundedCornerWithRadius:(CGFloat)radius
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGMutablePathRef path = CGPathCreateMutable();
    CGAffineTransform transform = CGAffineTransformMakeRotation(0);
    CGPathMoveToPoint(path, &transform, 0, self.bounds.size.height);
    CGPathAddLineToPoint(path, &transform, 0, radius);
    CGPathAddArc(path, &transform, radius, radius, radius, (180) * M_PI/180, (-90) * M_PI/180, 0);
    CGPathAddLineToPoint(path, &transform, self.bounds.size.width-radius, 0);
    CGPathAddArc(path, &transform, self.bounds.size.width-radius, radius, radius, (-90) * M_PI/180, 0, 0);
    CGPathAddLineToPoint(path, &transform, self.bounds.size.width, self.bounds.size.height);
    CGPathAddLineToPoint(path, &transform, 0, self.bounds.size.height);
    CGContextAddPath(context, path);
    CGContextClip(context);
    CGPathRelease(path);
    
}

- (void) drawTopLine:(CGRect)rect {
    [PrettyDrawing drawLineAtPosition:LinePositionTop rect:rect color:self.topLineColor];
}


- (void) drawBottomLine:(CGRect)rect {
    [PrettyDrawing drawLineAtPosition:LinePositionBottom rect:rect color:self.bottomLineColor];
}

- (void) drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    if (self.roundedCornerRadius > 0) {
        /*
         // draw the left rounded corner with a transform of 0 because nothing should be changed
         [self drawLeftRoundedCornerAtPoint:CGPointMake(0, 0) withRadius:self.roundedCornerRadius withTransformation:CGAffineTransformMakeRotation(0)];
         
         // draw the right rounded corner with a 90degree transform. this means the x and y coords are flipped which means the point must also flip
         [self drawLeftRoundedCornerAtPoint:CGPointMake(0, -self.frame.size.width) withRadius:self.roundedCornerRadius withTransformation:CGAffineTransformMakeRotation((90) * M_PI/180)];
         */
        [self clipRoundedCornerWithRadius:self.roundedCornerRadius];
    }
    
    if (self.backgroundImage) {
        [self.backgroundImage drawInRect:rect];
    }
    else {
        [PrettyDrawing drawGradient:rect fromColor:self.gradientStartColor toColor:self.gradientEndColor];
        [self drawTopLine:rect];
        [self drawBottomLine:rect];
    }
    //modif by lzq at 2014-12-30:导航栏不需要划线
    //[self dropShadow:self.shadowOpacity];
}
- (void) dropShadow:(float)opacity {
    self.layer.masksToBounds = NO;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    self.layer.shadowOpacity = opacity;
    CGRect rect = self.bounds;
    rect.origin.y = self.roundedCornerRadius;
    rect.size.height -= self.roundedCornerRadius;
    rect = CGRectInset(rect, ceil(opacity), 0);
    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:rect].CGPath;
}
@end
