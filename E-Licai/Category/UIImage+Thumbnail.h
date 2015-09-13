//
//  UIImage+Thumbnail.h
//  ahdxyp
//
//  Created by jiang junchen on 12-8-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    UIImageRoundedCornerTopLeft = 1,
    UIImageRoundedCornerTopRight = 1 << 1,
    UIImageRoundedCornerBottomRight = 1 << 2,
    UIImageRoundedCornerBottomLeft = 1 << 3
    } UIImageRoundedCorner;

@interface UIImage (Thumbnail)
//-(UIImage *)generatePhotoThumbnail:(UIImage *)image;
-(UIImage *)generatePhotoThumbnailWithSize:(CGSize)thumbnail_size;
- (UIImage *)roundedRectWith:(float)radius;
- (UIImage *)roundedRectWith:(float)radius cornerMask:(UIImageRoundedCorner)cornerMask;
@end
