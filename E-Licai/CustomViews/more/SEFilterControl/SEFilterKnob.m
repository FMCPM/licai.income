//
//  SEFilterKnob.m
//  SEFilterControl_Test
//
//  Created by Shady A. Elyaski on 6/15/12.
//  Copyright (c) 2012 mash, ltd. All rights reserved.
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "SEFilterKnob.h"

@implementation SEFilterKnob
@synthesize handlerColor;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setHandlerColor:[UIColor colorWithRed:230/255.f green:230/255.f blue:230/255.f alpha:1]];
    }
    return self;
}

-(void) setHandlerColor:(UIColor *)hc{
    //[handlerColor release];
    handlerColor = nil;
    
    handlerColor = hc;//[hc retain];
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGFloat width = rect.size.width;
    CGColorRef shadowColor = [UIColor colorWithRed:0 green:0
                                              blue:0 alpha:.4f].CGColor;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    
    //Draw Main Cirlce
    
    CGContextSaveGState(context);
    
    CGContextSetShadowWithColor(context, CGSizeMake(0, width/10.0), width/10.0, shadowColor);
    
    CGContextSetStrokeColorWithColor(context, handlerColor.CGColor);
    CGFloat lineWidth = floor(width/3.0);
    CGContextSetLineWidth(context, lineWidth);
    CGContextStrokeEllipseInRect(context, CGRectMake(lineWidth/2.0+1, lineWidth/2.0+1, width-lineWidth-2.0, width-lineWidth-2.0));
    
    CGContextRestoreGState(context);
    
    //Draw Outer Outline
    
    CGContextSaveGState(context);
    
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:.5 alpha:.6f].CGColor);
    CGContextSetLineWidth(context, 1);
    CGContextStrokeEllipseInRect(context, CGRectMake(1.5f, 1.5f, width-3.0f, width-3.0f));
    
    CGContextRestoreGState(context);
    
    //Draw Inner Outline
    
    CGContextSaveGState(context);
    
    //    CGContextSetShadowWithColor(context, CGSizeMake(0, -4), 10.f, shadowColor);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:.5 alpha:.6f].CGColor);
    CGContextSetLineWidth(context, 1);
    CGContextStrokeEllipseInRect(context, CGRectMake(lineWidth+1.5f, lineWidth+1.5f, width-2*lineWidth-2.5f, width-2*lineWidth-2.5f));
    
    CGContextRestoreGState(context);
    
    
    CGFloat colors[8] = { 0,0, 0, 0,
        0, 0, 0, .6};
    CGColorSpaceRef baseSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(baseSpace, colors, NULL, 2);
    
    CGContextSaveGState(context);
    CGContextAddEllipseInRect(context, CGRectMake(1.5f, 1.5f, width-3.0f, width-3.0f));
    CGContextClip(context);
    CGContextDrawLinearGradient (context, gradient, CGPointMake(0, 0), CGPointMake(0,rect.size.height), 0);
    CGContextRestoreGState(context);
}

@end
