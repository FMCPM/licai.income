//
//  CustomSelectionView.m
//
//  Created by Joy Chiang on 12-2-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CustomSelectionView.h"
#import "UIView+InnerShadow.h"
#import "UIColor+Hex.h"

#define kTriangleHeight 5.

@implementation CustomSelectionView

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        self.layer.shadowColor = [[UIColor clearColor] CGColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5] set];
    [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:0] fill];
    
//    UIBezierPath *trianglePath = [UIBezierPath bezierPath];
//    [trianglePath moveToPoint:CGPointMake(rect.size.width / 2 - kTriangleHeight, kTriangleHeight)];
//    [trianglePath addLineToPoint:CGPointMake(rect.size.width / 2, 0.)];
//    [trianglePath addLineToPoint:CGPointMake(rect.size.width / 2 + kTriangleHeight, kTriangleHeight)];
//    [trianglePath closePath];
//    [trianglePath fill];
}

+ (CustomSelectionView *)createSelectionView
{
    CustomSelectionView *selectionView = [[CustomSelectionView alloc] initWithFrame:CGRectZero] ;
    return selectionView;
}

@end