//
//  UIImage+CKKit.m
//  E-YellowPage
//
//  Created by jiangjunchen on 13-1-10.
//  Copyright (c) 2013年 ytinfo. All rights reserved.
//

#import "UIImage+CKKit.h"

@implementation UIImage (CKKit)
+(UIImage*)imageWithUrl:(NSString*)url
{
    __block UIImage *image;
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *myUrl = [NSURL URLWithString:url];
        NSData *myData = [NSData dataWithContentsOfURL:myUrl];
        image = [[UIImage alloc]initWithData:myData];
        
    });
    return image;
}

+(UIImage*)imageWithUnderImage:(UIImage*)unImg
                underImageRect:(CGRect)unRect
                    upperImage:(UIImage*)upImg
                upperImageRect:(CGRect)upRect
{
    CGRect unionRect = CGRectUnion(unRect, upRect);
    unRect = CGRectOffset(unRect, -unionRect.origin.x, -unionRect.origin.y);
    upRect = CGRectOffset(upRect, -unionRect.origin.x, -unionRect.origin.y);
    UIGraphicsBeginImageContextWithOptions(unionRect.size, NO, 0);
    [unImg drawInRect:unRect];
    [upImg drawInRect:upRect];
    UIImage *newImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImg;
}

@end
