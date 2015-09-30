//
//  PrettyToolbar.m
//  PrettyExample
//
//  Created by Seth Gholson on 4/25/12.

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

#import "PrettyToolbar.h"
#import <QuartzCore/QuartzCore.h>
#import "PrettyDrawing.h"

@implementation PrettyToolbar
@synthesize shadowOpacity, gradientEndColor, gradientStartColor, topLineColor, bottomLineColor;

#define default_shadow_opacity 0.5
#define default_gradient_end_color      [UIColor colorWithHex:0x297CB7]
#define default_gradient_start_color    [UIColor colorWithHex:0x53A4DE]
#define default_top_line_color          [UIColor colorWithHex:0x4F94C4]
#define default_bottom_line_color       [UIColor colorWithHex:0x186399]
#define default_tint_color              [UIColor colorWithHex:0x3D89BF]

-(void)setPrettyToolBarColor
{
    self.shadowOpacity = default_shadow_opacity;
    self.gradientStartColor = [UIColor colorWithRed:250.0/255 green:169.0/255 blue:19.0/255 alpha:1.0];
    self.gradientEndColor = [UIColor colorWithRed:225.0/255 green:80.0/255 blue:19.0/255 alpha:1.0];
    self.bottomLineColor = [UIColor colorWithRed:172.0/255 green:50.0/255 blue:12.0/255 alpha:1.0];
    self.topLineColor = [UIColor colorWithRed:172.0/255 green:50.0/255 blue:12.0/255 alpha:1.0];
    self.tintColor = [UIColor colorWithRed:236.0/255 green:119.0/255 blue:19.0/255 alpha:1.0];
}

- (void) initializeVars 
{
    self.contentMode = UIViewContentModeRedraw;
    [self setPrettyToolBarColor];
    /*
    self.shadowOpacity = default_shadow_opacity;
    self.gradientStartColor = default_gradient_start_color;
    self.gradientEndColor = default_gradient_end_color;
    self.topLineColor = default_top_line_color;
    self.bottomLineColor = default_bottom_line_color;
    self.tintColor = default_tint_color;
     */
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



- (void) drawTopLine:(CGRect)rect {
    [PrettyDrawing drawLineAtPosition:LinePositionTop rect:rect color:self.topLineColor];
}


- (void) drawBottomLine:(CGRect)rect {
    [PrettyDrawing drawLineAtPosition:LinePositionBottom rect:rect color:self.bottomLineColor];
}

- (void) drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    [self dropShadowWithOpacity:self.shadowOpacity];
    [PrettyDrawing drawGradient:rect fromColor:self.gradientStartColor toColor:self.gradientEndColor];
    [self drawTopLine:rect];        
    [self drawBottomLine:rect];
}

@end
