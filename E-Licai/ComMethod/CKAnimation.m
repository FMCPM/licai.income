//
//  CKAnimation.m
//  ahdxyp
//
//  Created by jiang junchen on 12-10-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CKAnimation.h"

#define CKDURATION      0.7 //动画持续时间

@implementation CKAnimation

+(void)startAnimation:(UIView *)view 
       withTransition:(UIViewAnimationTransition)transition 
          andDelegate:(id)delegate
    andFinishSelector:(SEL)selector
        andStartBlock:(void (^)(void))startblock
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:CKDURATION];
    [UIView setAnimationTransition:transition forView:view cache:YES];
    [UIView setAnimationDelegate:delegate];
    [UIView setAnimationDidStopSelector:selector];
    startblock();
    [UIView commitAnimations];
}


+(void)startAnimation:(UIView *)view 
    withAnimationType:(NSString*)type 
           andSubType:(NSString*)subtype
    andFinishDelegage:(id)delegate
    andAnimatingBlock:(void(^)(void))startblock
{
    CATransition *animation = [CATransition animation];
    animation.duration = CKDURATION;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.delegate = delegate;
    animation.type = type;
    if (subtype)
        animation.subtype = subtype;
    [[view layer] addAnimation:animation forKey:@"animation"];
    startblock();
}

@end
