//  StartWeiXinAppPopupView.m
//
//  叮叮理财 - 更多 - 关注我们
//
//  Created by jiang junchen on 12-11-15.
//  Copyright (c) 2015年 __MyCompanyName__. All rights reserved.
//

#import "StartWeiXinAppPopupView.h"
#import "UaConfiguration.h"
#import "UIOwnSkin.h"
#import "CustomViews.h"
#import "UIColor+Hex.h"
#import "GlobalDefine.h"

 
@implementation StartWeiXinAppPopupView
@synthesize m_startWXDelegate = _startWXDelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
       // [self initializeWithFrame:frame];

    }
    return self;
}


-(id)initWithFrame:(CGRect)frame andViewTitle:(NSString*)strTittle
{
    

    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        int iTitleHeight = frame.size.height - 65;
        UILabel* pLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, frame.size.width-20, iTitleHeight)];
        
        pLabel.numberOfLines = 0;
        pLabel.backgroundColor = [UIColor clearColor];
        pLabel.font = [UIFont systemFontOfSize:14];
        pLabel.textColor = COLOR_FONT_1;
        pLabel.text = strTittle;
        pLabel.textAlignment = UITextAlignmentLeft;
        [self addSubview:pLabel];
        
        int iTopY = iTitleHeight + 15;
        
        int iLeftX = (frame.size.width - 120*2-20)/2;
        UIButton* pButton = [UIButton buttonWithType:UIButtonTypeCustom];
        pButton.frame = CGRectMake(iLeftX, iTopY, 120, 35);
        [pButton setTitle:@"取消" forState:UIControlStateNormal];
        pButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [pButton addTarget:self action:@selector(actionCancelClicked:) forControlEvents:UIControlEventTouchUpInside];
        [UIOwnSkin setButtonFontRect:pButton andColor:COLOR_BTN_BORDER_1];
        pButton.tag = 2001;
        [self addSubview:pButton];
        
        pButton = [UIButton buttonWithType:UIButtonTypeCustom];
        pButton.frame = CGRectMake(iLeftX+140, iTopY, 120, 35);
        [pButton setTitle:@"去关注" forState:UIControlStateNormal];
        pButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [pButton addTarget:self action:@selector(actionStartAppClicked:) forControlEvents:UIControlEventTouchUpInside];
        [UIOwnSkin setButtonBackground:pButton andColor:COLOR_BTN_BORDER_3];
        pButton.tag = 2002;
        [self addSubview:pButton];

        
    }
    return self;
}



-(void) actionCancelClicked:(id)sender
{
    if (_startWXDelegate)
    {
        
        if([_startWXDelegate respondsToSelector:@selector(onEndSelectedStartWeiXinApp:)])
        {
            [_startWXDelegate onEndSelectedStartWeiXinApp:0];
        }
        
    }
}

-(void) actionStartAppClicked:(id)sender
{
    if (_startWXDelegate)
    {
        
        if([_startWXDelegate respondsToSelector:@selector(onEndSelectedStartWeiXinApp:)])
        {
            [_startWXDelegate onEndSelectedStartWeiXinApp:1];
        }
        
    }
}


@end
