//
//  UIImage+Resize.m
//  NewYunlu
//
//  Created by ChenQi on 12-11-5.
//  Copyright (c) 2012年 TCGROUP. All rights reserved.
//

#import <Foundation/NSObjCRuntime.h>

#import "UIImage+Resize.h"


#ifndef __IPHONE_6_0

#if (__cplusplus && __cplusplus >= 201103L && (__has_extension(cxx_strong_enums) || __has_feature(objc_fixed_enum))) || (!__cplusplus && __has_feature(objc_fixed_enum))
#define NS_ENUM(_type, _name) enum _name : _type _name; enum _name : _type
#if (__cplusplus)
#define NS_OPTIONS(_type, _name) _type _name; enum : _type
#else
#define NS_OPTIONS(_type, _name) enum _name : _type _name; enum _name : _type
#endif
#else
#define NS_ENUM(_type, _name) _type _name; enum
#define NS_OPTIONS(_type, _name) _type _name; enum
#endif

typedef NS_ENUM(NSInteger, UIImageResizingMode) {
    UIImageResizingModeTile,
    UIImageResizingModeStretch,
};

@interface UIImage (IOS6)
- (UIImage *)resizableImageWithCapInsets:(UIEdgeInsets)capInsets resizingMode:(UIImageResizingMode)resizingMode;
@end

#endif

@implementation UIImage (Resize)


+ (UIImage *)resizableImageNamed:(NSString *)name
{
    return [UIImage imageNamed:name edge:UIEdgeInsetsZero];
}

+ (UIImage *)imageNamed:(NSString *)name edge:(UIEdgeInsets)edge
{
    if (nil == name || name.length < 1)
    {
        return nil;
    }
    
    return [[UIImage imageNamed:name] imageResize:edge];
}

- (UIImage *)imageResizable
{
    return [self imageResize:UIEdgeInsetsZero];
}

- (UIImage *)imageResize:(UIEdgeInsets)edge
{
    if ([self respondsToSelector:@selector(resizableImageWithCapInsets:resizingMode:)])
    {
        // iOS 6.x code
        return  [self resizableImageWithCapInsets:edge resizingMode:UIImageResizingModeTile];
    }
    else if ([self respondsToSelector:@selector(resizableImageWithCapInsets:)])
    {
        // iOS 5.x code
        return  [self resizableImageWithCapInsets:edge];
    }
    else
    {
        // iOS 4.x code
        return [self stretchableImageWithLeftCapWidth:edge.top topCapHeight:edge.bottom];
    }
}



@end
