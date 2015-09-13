//
//  CustomBackgroundLayer.m
//
//  Created by Joy Chiang on 12-2-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//


#import "CustomBackgroundLayer.h"
#import "GlobalDefine.h"

@implementation CustomBackgroundLayer

- (id)init {
    if ((self = [super init]))
    {

        
        CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init] ;
        UIColor *startColor = RGBCOLOR(55, 55, 55);
        UIColor *endColor = RGBCOLOR(30, 30, 30);
        gradientLayer.frame = CGRectMake(0, 0, 320, 49);
        gradientLayer.colors = [NSArray arrayWithObjects:(id)[startColor CGColor], (id)[endColor CGColor], nil];
        [self insertSublayer:gradientLayer atIndex:0];
    }
    return self;
}

@end