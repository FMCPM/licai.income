//
//  UIImage+MyImage.m
//  YTSearch
//
//  Created by jiang junchen on 12-10-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIImage+MyImage.h"

@implementation UIImage (MyImage)
+(UIImage *)myImageWithName:(NSString*)name ofType:(NSString*)type
{
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:type];
    return [UIImage imageWithContentsOfFile:path];
}
@end
