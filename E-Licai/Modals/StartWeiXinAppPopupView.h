//
//  StartWeiXinAppPopupView.h
//
//  叮叮理财 - 更多 - 关注我们
//
//  Created by jiang junchen on 12-11-15.
//  Copyright (c) 2015年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol StartWeiXinAppPopupViewDelegate;

@interface StartWeiXinAppPopupView : UIView
{

    
}


@property (strong, nonatomic) id <StartWeiXinAppPopupViewDelegate> m_startWXDelegate;

-(id)initWithFrame:(CGRect)frame andViewTitle:(NSString*)strTittle;

@end


@protocol StartWeiXinAppPopupViewDelegate <NSObject>
@optional
-(void)onEndSelectedStartWeiXinApp:(NSInteger)iSelectedFlag;
@end