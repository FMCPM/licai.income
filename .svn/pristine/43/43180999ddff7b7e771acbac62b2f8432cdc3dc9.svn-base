//
//  CKAnimation.h
//  ahdxyp
//
//  Created by jiang junchen on 12-10-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
@interface CKAnimation : NSObject

/********************UIViewAnimationTransition****************************************
 UIViewAnimationTransitionCurlDown;            UIViewAnimationTransitionCurlUp;   
 UIViewAnimationTransitionFlipFromLeft;        UIViewAnimationTransitionFlipFromRight
 ************************************************************************************/
+(void)startAnimation:(UIView *)view 
       withTransition:(UIViewAnimationTransition)transition 
          andDelegate:(id)delegate
    andFinishSelector:(SEL)selector
        andStartBlock:(void (^)(void))startblock;

/********************AnimationTypes***************************************************
 kCATransitionFade;        kCATransitionPush;          kCATransitionReveal;
 kCATransitionMoveIn;      @"cube";                    @"suckEffect";  
 @"oglFlip";               @"rippleEffect";            @"pageCurl";    
 @"pageUnCurl";            @"cameraIrisHollowOpen";    @"cameraIrisHollowClose";
 ************************************************************************************/
+(void)startAnimation:(UIView *)view 
    withAnimationType:(NSString*)type 
           andSubType:(NSString*)subtype
    andFinishDelegage:(id)delegate
    andAnimatingBlock:(void(^)(void))startblock;
@end
