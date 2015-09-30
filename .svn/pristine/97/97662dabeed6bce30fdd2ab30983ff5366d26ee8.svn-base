//
//  BarBackgroundLayer.m
//
//  Created by Joy Chiang on 12-2-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BarBackgroundLayer.h"
#import "UIColor+Hex.h"

@implementation BarBackgroundLayer

- (id)init {
    if ((self = [super init]))
    {
        CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init] ;
        UIColor *startColor = [UIColor colorWithHex:0x282928];
        UIColor *endColor = [UIColor colorWithHex:0x4a4b4a];
        gradientLayer.frame = CGRectMake(0, 0, 320, 49);
        gradientLayer.colors = [NSArray arrayWithObjects:(id)[startColor CGColor], (id)[endColor CGColor], nil];
        [self insertSublayer:gradientLayer atIndex:0];
    }
    return self;
}

@end