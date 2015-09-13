//
//  JCSelectionView.m
//
//  Created by Joy Chiang on 12-2-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "JCSelectionView.h"
#import "UIColor+Hex.h"
#import "UIView+InnerShadow.h"

@implementation JCSelectionView

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self setBackgroundColor:[UIColor clearColor]];
        self.layer.shadowOffset = CGSizeMake(0, 1);
        self.layer.shadowRadius = 1.;
        self.layer.shadowColor = [[UIColor whiteColor] CGColor];
        self.layer.shadowOpacity = 0.4;
        self.clipsToBounds = NO;
    }
    return self;
}

- (void)layoutSubviews {
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [self drawInnerShadowInRect:rect fillColor:[UIColor colorWithHex:0x252525]];
}



@end