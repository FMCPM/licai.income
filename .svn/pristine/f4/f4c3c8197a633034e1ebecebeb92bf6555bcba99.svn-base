//
//  BTTabBarBackgroudLayer.m
//  jojo
//
//  Created by  jacob.Chiang on 12-11-9.
//  Copyright (c) 2012年 TCGROUP. All rights reserved.
//

#import "BTTabBarBackgroudLayer.h"
#import "UIImage+Resize.h"

#define KTABBARBACKGROUD_HEIGTH 49

@implementation BTTabBarBackgroudLayer

- (id)init {
    if ((self = [super init])) {
        CALayer *barBackgroundLayer = [CALayer layer];
        barBackgroundLayer.frame = CGRectMake(0, 0, 320.0f, KTABBARBACKGROUD_HEIGTH);
        // menuBar
        UIImage *image = [UIImage imageNamed:@"bg_bottom_bar.png"];
        barBackgroundLayer.contents = (id)image.CGImage;
        [self insertSublayer:barBackgroundLayer atIndex:0];
    }
    return self;
}

@end
