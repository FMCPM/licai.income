//
//  UIImage+Thumbnail.m
//  ahdxyp
//
//  Created by jiang junchen on 12-8-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIImage+Thumbnail.h"

@implementation UIImage (Thumbnail)

-(UIImage *)generatePhotoThumbnailWithSize:(CGSize)thumbnail_size
{
    CGSize size = self.size;
    CGFloat scale = self.size.width/self.size.height;
    CGFloat thumbnail_x = 0.0;
    CGFloat thumbnail_y = 0.0;
    CGFloat thumbnail_scale = thumbnail_size.width/thumbnail_size.height;
    if (scale > thumbnail_scale) {
        size.width = self.size.height*thumbnail_scale;
        thumbnail_x = (self.size.width - size.width)/2;
    }
    else {
        size.height = self.size.width/thumbnail_scale;
        thumbnail_y = (self.size.height - size.height)/2;

    }
    CGRect temp_rect = CGRectMake(thumbnail_x, thumbnail_y, size.width, size.height);
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, temp_rect);
 //   CGFloat scale_screen = [UIScreen mainScreen].scale;
  //  thumbnail_size.height *= scale_screen;
  //  thumbnail_size.width *= scale_screen;
    CGRect thumbnail_rect = CGRectMake(0, 0, thumbnail_size.width, thumbnail_size.height);
  //  UIGraphicsBeginImageContext(thumbnail_size);  
    UIGraphicsBeginImageContextWithOptions(thumbnail_size, NO, 0.0);
    [[UIImage imageWithCGImage:imageRef] drawInRect:thumbnail_rect];  
    UIImage *thumbnail = UIGraphicsGetImageFromCurrentImageContext();  
    UIGraphicsEndImageContext();  
    CGImageRelease(imageRef);
  //  UIImage *temp_img = [UIImage imageWithCGImage:imageRef];
    /*
    CGRect thumbnail_rect = CGRectMake(0, 0, thumbnail_size.width, thumbnail_size.height);
    UIGraphicsBeginImageContext(thumbnail_size);
    [temp_img drawInRect:thumbnail_rect];
    UIImage *thumbnail = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRelease(imageRef);
     */
    return thumbnail;    
}


static void addRoundedRectToPath(CGContextRef context, CGRect rect, float radius, UIImageRoundedCorner cornerMask)
{
//原点在左下方，y方向向上。移动到线条2的起点。
    
    CGContextMoveToPoint(context, rect.origin.x, rect.origin.y + radius);
    //画出线条2, 目前画线的起始点已经移动到线条2的结束地方了。
    CGContextAddLineToPoint(context, rect.origin.x, rect.origin.y + rect.size.height - radius);
   //如果左上角需要画圆角，画出一个弧线出来。    
    if (cornerMask & UIImageRoundedCornerTopLeft) {
        //已左上的正方形的右下脚为圆心，半径为radius， 180度到90度画一个弧线，
        CGContextAddArc(context, rect.origin.x + radius, rect.origin.y + rect.size.height - radius,
                        radius, M_PI, M_PI / 2, 1);
    }
    else {
        //如果不需要画左上角的弧度。从线2终点，画到线3的终点，
        CGContextAddLineToPoint(context, rect.origin.x, rect.origin.y + rect.size.height);
        //线3终点，画到线4的起点
        CGContextAddLineToPoint(context, rect.origin.x + radius, rect.origin.y + rect.size.height);     
    }
    //画线4的起始，到线4的终点
    CGContextAddLineToPoint(context, rect.origin.x + rect.size.width - radius,
                            rect.origin.y + rect.size.height);
    
    //画右上角
    
    if (cornerMask & UIImageRoundedCornerTopRight) {
        
        CGContextAddArc(context, rect.origin.x + rect.size.width - radius,
                        
                        rect.origin.y + rect.size.height - radius, radius, M_PI / 2, 0.0f, 1);
        
    }
    else {
        
        CGContextAddLineToPoint(context, rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
        
        CGContextAddLineToPoint(context, rect.origin.x + rect.size.width, rect.origin.y + rect.size.height - radius);
        
    }   
    CGContextAddLineToPoint(context, rect.origin.x + rect.size.width, rect.origin.y + radius);
   
    //画右下角弧线
    if (cornerMask & UIImageRoundedCornerBottomRight) {
        
        CGContextAddArc(context, rect.origin.x + rect.size.width - radius, rect.origin.y + radius,
                        
                        radius, 0.0f, -M_PI / 2, 1);      
    }
    
    else {        
        CGContextAddLineToPoint(context, rect.origin.x + rect.size.width, rect.origin.y);
        CGContextAddLineToPoint(context, rect.origin.x + rect.size.width - radius, rect.origin.y);
    }
    CGContextAddLineToPoint(context, rect.origin.x + radius, rect.origin.y);
   //画左下角弧线
    if (cornerMask & UIImageRoundedCornerBottomLeft) {
        
        CGContextAddArc(context, rect.origin.x + radius, rect.origin.y + radius, radius,
                        
                        -M_PI / 2, M_PI, 1);
    }
    else {
        CGContextAddLineToPoint(context, rect.origin.x, rect.origin.y);
        CGContextAddLineToPoint(context, rect.origin.x, rect.origin.y + radius);
    }  
    CGContextClosePath(context);
}

- (UIImage *)roundedRectWith:(float)radius

{
    
    return [self roundedRectWith:radius cornerMask:UIImageRoundedCornerBottomLeft | UIImageRoundedCornerBottomRight | UIImageRoundedCornerTopLeft | UIImageRoundedCornerTopRight];
    
}



- (UIImage *)roundedRectWith:(float)radius cornerMask:(UIImageRoundedCorner)cornerMask

{
    UIImageView *bkImageViewTmp = [[UIImageView alloc] initWithImage:self];  
    int w = self.size.width;
    int h = self.size.height;  
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
   // CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    CGContextBeginPath(context);    
    addRoundedRectToPath(context,bkImageViewTmp.frame, radius, cornerMask);    
    CGContextClosePath(context);    
    CGContextClip(context);
    [self drawInRect:CGRectMake(0, 0, w, h)];
  //  CGContextDrawImage(context, CGRectMake(0, 0, w, h), self.CGImage);
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
   
    UIImage    *newImage = [UIImage imageWithCGImage:imageMasked];
  
    CGImageRelease(imageMasked);

    return newImage;
    
}
@end
