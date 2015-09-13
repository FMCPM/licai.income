//
//  UIImageView+CKKit.m
//  E-YellowPage
//
//  Created by jiangjunchen on 13-1-10.
//  Copyright (c) 2013年 ytinfo. All rights reserved.
//

#import "UIImageView+CKKit.h"

@implementation UIImageView (CKKit)
-(void)setAsyncUrlImage:(UIImage *)newImage
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.image = newImage;
    });
}
@end
