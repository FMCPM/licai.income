//
//  UIColor+CKKit.m
//  YTSearch
//
//  Created by jiang junchen on 12-11-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIColor+CKKit.h"

@implementation UIColor (CKKit)

+ (UIColor *) colorWithHex:(int)hex {
    return [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0
                           green:((float)((hex & 0xFF00) >> 8))/255.0 
                            blue:((float)(hex & 0xFF))/255.0 alpha:1.0];
}
@end
