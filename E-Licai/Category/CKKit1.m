//
//  CKKit.m
//  YTSearch
//
//  Created by jiangjunchen on 12-11-26.
//
//
#import "CKKit1.h"
@interface CKKit (Private)
+ (void) fixShadow:(CGContextRef)ctx rect:(CGRect)rect;
@end

@implementation CKKit

+(void) drawShadow:(CGRect)rect shadowOpacity:(CGFloat)opacity
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
        UIColor *shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:opacity];
        CGContextSetShadowWithColor(ctx, CGSizeMake(0, 4), 3, shadowColor.CGColor);
    
}
+ (void) makeCall:(NSString *)phoneNumber
{
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneNumber]];
    NSLog(@"%@",phoneURL);
    UIWebView* callPhoneWebView = [[UIWebView alloc] init];
    NSURLRequest *request = [NSURLRequest requestWithURL:phoneURL];
    [callPhoneWebView loadRequest:request];
}


@end
