//
//  UIImage+Resize.h
//  NewYunlu
//
//  Created by ChenQi on 12-11-5.
//  Copyright (c) 2012年 TCGROUP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Resize)


// 返回原图平铺图, edge为原图的不可拉伸区域

+ (UIImage *)resizableImageNamed:(NSString *)name;

+ (UIImage *)imageNamed:(NSString *)name edge:(UIEdgeInsets)edge;

- (UIImage *)imageResizable;

- (UIImage *)imageResize:(UIEdgeInsets)edge;


@end
