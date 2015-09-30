//
//  Skin.m
//  EBook
//
//  Created by Jacob Chiang on 12-5-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIOwnSkin.h"
#import "UIColor+Hex.h"
#import "GlobalDefine.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIOwnSkin

// 返回UINavigationBar  返回 按钮
+ (UIBarButtonItem *)backItemTarget:(id)target action:(SEL)action{
    
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [button setBackgroundColor:[UIColor clearColor]];
    
    button.frame = CGRectMake(0, 0, 60, 40);
    
    UIImageView* pImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 11, 10, 17)];
    pImageView.image = [UIImage imageNamed:@"navbar_back.png"];
    [button addSubview:pImageView];
    
    UILabel* pLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 45, 20)];
    pLabel.textColor = COLOR_FONT_2;
    pLabel.textAlignment  = UITextAlignmentLeft;
    pLabel.text  = @"返回";
    pLabel.font  =[UIFont systemFontOfSize:14];
    [button addSubview:pLabel];
    
    //UIImage *imageNormal = [UIImage imageNamed:@"navbar_back.png"];
    
   // [button setBackgroundImage:imageNormal forState:UIControlStateNormal];
    //暂时不设置选中后的背景（2013.10.11）
    //UIImage *imageSelect = [UIImage imageNamed:@"navbar_back_select"];
    //[button setBackgroundImage:imageSelect forState:UIControlStateHighlighted];
    
   // button.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [button addTarget:(target) action:(action) forControlEvents:(UIControlEventTouchUpInside)];
   // button.bounds = CGRectMake(0, 0, imageNormal.size.width/2, imageNormal.size.height/2);
    
    UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc] initWithCustomView:(button)];
    return barBtnItem;
}

// 顶部导航栏的搜索按钮
+(UIBarButtonItem*)topSearchItemTarget:(id)target action:(SEL)action{
    
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [button setBackgroundColor:[UIColor clearColor]];
    UIImage *imageNormal = [UIImage imageNamed:@"btn_search@2x.png"];
    UIImage *imageSelect = [UIImage imageNamed:@"btn_search_selected@2x.png"];
    [button setBackgroundImage:imageNormal forState:UIControlStateNormal];
    [button setBackgroundImage:imageSelect forState:UIControlStateHighlighted];
    
    [button addTarget:(target) action:(action) forControlEvents:(UIControlEventTouchUpInside)];
    button.bounds = CGRectMake(0, 0, imageNormal.size.width/2+5, imageNormal.size.height/2+5);
    
    UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc] initWithCustomView:(button)];
    return barBtnItem;
}

// 返回 刷新 按钮
+(UIBarButtonItem*)refushItemTarget:(id)target action:(SEL)action{
    
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [button setBackgroundColor:[UIColor clearColor]];
    UIImage *imageNormal = [UIImage imageNamed:@"refresh_normal.png"];
    UIImage *imageSelect = [UIImage imageNamed:@"refresh_selected.png"];
    [button setBackgroundImage:imageNormal forState:UIControlStateNormal];
    [button setBackgroundImage:imageSelect forState:UIControlStateHighlighted];
    
    [button addTarget:(target) action:(action) forControlEvents:(UIControlEventTouchUpInside)];
    button.bounds = CGRectMake(0, 0, imageNormal.size.width/2, imageNormal.size.height/2);
    
    UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc] initWithCustomView:(button)];
    return barBtnItem;
}

//
+(UIBarButtonItem*)dropArrowItemTarget:(id)target action:(SEL)action{
    
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [button setBackgroundColor:[UIColor clearColor]];
    UIImage *pImage = [UIImage imageNamed:@"bg_downarrow.png"];
    button.imageView.image = pImage;
    /*
     UIImage *imageNormal = [UIImage imageNamed:@"refresh_normal.png"];
     UIImage *imageSelect = [UIImage imageNamed:@"refresh_selected.png"];
     [button setBackgroundImage:imageNormal forState:UIControlStateNormal];
     [button setBackgroundImage:imageSelect forState:UIControlStateHighlighted];*/
    
    [button addTarget:(target) action:(action) forControlEvents:(UIControlEventTouchUpInside)];
    button.bounds = CGRectMake(0, 0, pImage.size.width/2, pImage.size.height/2);
    
    UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc] initWithCustomView:(button)];
    return barBtnItem;
}


// 自定义 文字 按钮
+(UIBarButtonItem*)textItemTarget:(id)target action:(SEL)action text:(NSString*)text
{
    
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [button setBackgroundColor:[UIColor clearColor]];
    UIImage *imageNormal = [UIImage imageNamed:@"textbaritem_normal"];
    UIImage *imageSelect = [UIImage imageNamed:@"textbaritem_select"];
    [button setBackgroundImage:imageNormal forState:UIControlStateNormal];
    [button setBackgroundImage:imageSelect forState:UIControlStateHighlighted];
    [button addTarget:(target) action:(action) forControlEvents:(UIControlEventTouchUpInside)];
    [button setTitle:text forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15.0];
    button.titleLabel.textColor= [UIColor redColor];
    button.bounds = CGRectMake(0, 0, imageNormal.size.width, imageNormal.size.height);
    
    UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc] initWithCustomView:(button)];
    
    return barBtnItem;
    
}

+(UIBarButtonItem*)textItemTarget:(id)target action:(SEL)action text:(NSString*)text selectText:(NSString*)selecttext;
{
    
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [button setBackgroundColor:[UIColor clearColor]];
    UIImage *imageNormal = [UIImage imageNamed:@"textbaritem_normal"];
    UIImage *imageSelect = [UIImage imageNamed:@"textbaritem_select"];
    [button setBackgroundImage:imageNormal forState:UIControlStateNormal];
    [button setBackgroundImage:imageSelect forState:UIControlStateHighlighted];
    [button addTarget:(target) action:(action) forControlEvents:(UIControlEventTouchUpInside)];
    [button setTitle:text forState:UIControlStateNormal];
    [button setTitle:selecttext forState:UIControlStateSelected];
    button.titleLabel.font = [UIFont systemFontOfSize:15.0];
    button.titleLabel.textColor= [UIColor redColor];
    button.bounds = CGRectMake(0, 0, imageNormal.size.width, imageNormal.size.height);
    
    UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc] initWithCustomView:(button)];
    
    return barBtnItem;
    
}


// 自定义 文字 按钮 选中内容不同
+(UIBarButtonItem*)navTextItemTarget:(id)target action:(SEL)action text:(NSString*)text andWidth:(NSInteger)iWidth
{
    
    
    UIBarButtonItem *pBarBtn = [[UIBarButtonItem alloc]
                                initWithTitle:text style:UIBarButtonItemStylePlain target:target action:action];
    //modify by lzq at 2014-03-16,去除背景
    
    if(SYSTEM_VESION < 7.0)
    {
        pBarBtn.tintColor = [UIColor blackColor];
        return pBarBtn;
    }

    NSDictionary* textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    COLOR_FONT_2,UITextAttributeTextColor,
                                    [UIFont boldSystemFontOfSize:14],UITextAttributeFont,
                                    [UIColor clearColor],UITextAttributeTextShadowColor,
                                    [NSValue valueWithCGSize:CGSizeMake(1, 1)],UITextAttributeTextShadowOffset,
                                    nil];
    
    [pBarBtn setTitleTextAttributes:textAttributes forState:0];
    return pBarBtn;
    
}

+ (UIBarButtonItem *)spreadBtnTarget:(id)target action:(SEL)action
{
    
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [button setBackgroundColor:[UIColor clearColor]];
    UIImage *imageNormal = [UIImage imageNamed:@"spread_btn_normal"];
    UIImage *imageSelect = [UIImage imageNamed:@"spread_btn_highlight"];
    [button setBackgroundImage:imageNormal forState:UIControlStateNormal];
    [button setBackgroundImage:imageSelect forState:UIControlStateHighlighted];
    
    [button addTarget:(target) action:(action) forControlEvents:(UIControlEventTouchUpInside)];
    button.bounds = CGRectMake(0, 0, imageNormal.size.width, imageNormal.size.height);
    
    UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc] initWithCustomView:(button)];
    return barBtnItem;
    
}

+ (UIBarButtonItem *)mapBtnTarget:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [button setBackgroundColor:[UIColor clearColor]];
    UIImage *imageNormal = [UIImage imageNamed:@"map_icon_normal"];
    UIImage *imageSelect = [UIImage imageNamed:@"map_icon_highlight"];
    [button setBackgroundImage:imageNormal forState:UIControlStateNormal];
    [button setBackgroundImage:imageSelect forState:UIControlStateHighlighted];
    
    [button addTarget:(target) action:(action) forControlEvents:(UIControlEventTouchUpInside)];
    button.bounds = CGRectMake(0, 0, imageNormal.size.width, imageNormal.size.height);
    
    UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc] initWithCustomView:(button)];
    return barBtnItem;
}

+ (UIBarButtonItem *)imageBtnTarget:(NSString*)strImageName andTarget:(id)target action:(SEL)action andWidth:(NSInteger)iWidth andHeight:(NSInteger)iHeight
{
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    //[button setBackgroundColor:[UIColor clearColor]];
    
    UIImage *imageNormal = [UIImage imageNamed:strImageName];
    UIImageView* pImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, iWidth, iHeight)];
    pImageView.image = imageNormal;
    [button addSubview:pImageView];
    
    
   // [button setBackgroundImage:imageNormal forState:UIControlStateNormal];
    //[button setBackgroundImage:imageSelect forState:UIControlStateHighlighted];
    
    [button addTarget:(target) action:(action) forControlEvents:(UIControlEventTouchUpInside)];
   // if(iWidth < 30)
   //     iHeight = 21;
    button.bounds = CGRectMake(0, 0, iWidth, iHeight);
    
    UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc] initWithCustomView:(button)];
    return barBtnItem;
}

//
+(UIBarButtonItem *)topBarImageBtnTarget:(NSString*)strImageName andTarget:(id)target action:(SEL)action andLeft:(NSInteger)iLeft andTop:(NSInteger)iTop andWidth:(NSInteger)iWidth andHeight:(NSInteger)iHeight
{
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [button setBackgroundColor:[UIColor clearColor]];
    UIImage *imageNormal = [UIImage imageNamed:strImageName];
    [button setBackgroundImage:imageNormal forState:UIControlStateNormal];
    
    
    [button addTarget:(target) action:(action) forControlEvents:(UIControlEventTouchUpInside)];
    
    button.bounds = CGRectMake(iLeft, iTop, iWidth, iHeight);
    
    UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc] initWithCustomView:(button)];
    return barBtnItem;
}

// 设置 背景 图片
+(UIColor*)backgroundColor:(CGRect)frame{
    
    UIImage *bgImg = [[UIImage imageNamed:@"contact_cell_bg"] resizableImageWithCapInsets:
                      UIEdgeInsetsMake(frame.origin.x, frame.origin.y, frame.size.height, frame.size.width)];
    
    return [UIColor colorWithPatternImage:bgImg];
}

// 小纹理 背景 图片
+(UIColor*)smallTextureBackgroudColor:(CGRect)frame
{
    UIImage *bgImg = [[UIImage imageNamed:@"person_info_bg.png"] resizableImageWithCapInsets:
                      UIEdgeInsetsMake(frame.origin.x, frame.origin.y, frame.size.height, frame.size.width)];
    return [UIColor colorWithPatternImage:bgImg];
}

//导航条上的标题视图
+(UILabel*)navibarTitleView:(NSString*)strTitle andFrame:(CGRect)rcFame
{
    UILabel* pLabel = [[UILabel alloc] initWithFrame:rcFame];
    pLabel.backgroundColor = [UIColor clearColor];
    pLabel.font = [UIFont boldSystemFontOfSize:16];
    pLabel.text = strTitle;
    pLabel.textColor = COLOR_FONT_1;
    pLabel.textAlignment = UITextAlignmentCenter;
    
    return  pLabel;
}



+(CGRect)getViewRectByIosVersion:(CGRect)frame
{
    CGRect rcView = frame;
    /*
    if([[[UIDevice currentDevice] systemVersion]floatValue] >= 7.0)
    {
        rcView = CGRectMake(0, 20, frame.size.width, frame.size.height-20);
    }
  */
    return rcView;
}

//设置按钮的背景
+(void)setButtonBackground:(UIButton*)pButton 
{
    if(pButton == nil)
        return;
    [pButton setBackgroundColor:COLOR_BUTTON_RECT];
    pButton.layer.borderWidth = 1.0f;
    pButton.layer.borderColor = COLOR_BUTTON_RECT.CGColor;
    [pButton.layer setMasksToBounds:YES];
    pButton.layer.cornerRadius = 5.0f;
    [pButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [pButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [pButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    pButton.titleLabel.font = [UIFont systemFontOfSize:14];
    
}

//给按钮设置指定的背景色
+(void)setButtonBackground:(UIButton*)pButton andColor:(UIColor*)bColor
{
    if(pButton == nil)
        return;
    [pButton setBackgroundColor:bColor];
    pButton.layer.borderWidth = 1.0f;
    pButton.layer.borderColor = bColor.CGColor;
    [pButton.layer setMasksToBounds:YES];
    pButton.layer.cornerRadius = 5.0f;
    pButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [pButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [pButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [pButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];

}

//设置按钮的默认背景
+(void)setButtonFontRect:(UIButton*)pButton
{
    if(pButton == nil)
        return;
    [pButton setBackgroundColor:[UIColor whiteColor]];
    pButton.layer.borderWidth = 1.0f;
    pButton.layer.borderColor = COLOR_BUTTON_RECT.CGColor;
    [pButton.layer setMasksToBounds:YES];
    pButton.layer.cornerRadius = 5.0f;
    [pButton setTitleColor:COLOR_BUTTON_FONT forState:UIControlStateNormal];
    [pButton setTitleColor:COLOR_BUTTON_FONT forState:UIControlStateHighlighted];
    //pButton.titleLabel.shadowColor = [UIColor whiteColor];
    //pButton.titleLabel.shadowOffset = CGSizeMake(2, 2);
}

//给按钮的边框设置指定的颜色
+(void)setButtonFontRect:(UIButton*)pButton andColor:(UIColor*)bColor
{
    if(pButton == nil)
        return;
    [pButton setBackgroundColor:[UIColor whiteColor]];
    pButton.layer.borderWidth = 1.0f;
    pButton.layer.borderColor = bColor.CGColor;
    [pButton.layer setMasksToBounds:YES];
    pButton.layer.cornerRadius = 5.0f;
    [pButton setTitleColor:bColor forState:UIControlStateNormal];
    [pButton setTitleColor:bColor forState:UIControlStateHighlighted];
}


//创建红点背景的Label
+(void)createOrangePointLabel:(UITableViewCell*)pCellObj andX:(NSInteger)iX andY:(NSInteger)iY andTag:(NSInteger)iTag
{
    
    UIImageView* pSmallImgView = [[UIImageView alloc] initWithFrame:CGRectMake(iX, iY, 24, 24)];
    pSmallImgView.tag = iTag+100;
    pSmallImgView.image = [UIImage imageNamed:@"orangepoint_count.png"];
    [pCellObj.contentView addSubview:pSmallImgView];
    
    //新消息的数量
    UILabel*pLabel = [[UILabel alloc] initWithFrame:CGRectMake(iX, iY+2, 24, 18)];
    pLabel.textColor = [UIColor whiteColor];
    pLabel.backgroundColor = [UIColor clearColor];
    pLabel.font  = [UIFont boldSystemFontOfSize:12];
    pLabel.tag = iTag;
    pLabel.textAlignment = UITextAlignmentCenter;
    [pCellObj.contentView addSubview:pLabel];
}


//设置红点的现实
+(void)setOrangePointLabelText:(UITableViewCell*)pCellObj andText:(NSString*)strText andTag:(NSInteger)iTag
{
    UILabel*pCountLabel = (UILabel*)[pCellObj.contentView viewWithTag:iTag];
    UIImageView* pPointView = (UIImageView*)[pCellObj.contentView viewWithTag:iTag+100];
    if(pCountLabel == nil || pPointView == nil)
        return;
    
    if(strText.length < 1 || [strText isEqualToString:@"0"])
    {
        [pCountLabel setHidden:YES];
        [pPointView setHidden:YES];
        return;
    }
    
    [pCountLabel setHidden:NO];
    [pPointView setHidden:NO];
    
    //根据strText的长度，设置背景的区域
    /*
    CGRect framePoint = pPointView.frame;
    framePoint.size.width = strText.length*12;
    if(framePoint.size.width < 24)
        framePoint.size.width = 24;
    framePoint.size.height = framePoint.size.width;

    if(framePoint.size.width > 30)
    {
        framePoint.size.width = 30;
        framePoint.size.height = 24;
    }
    pPointView.frame = framePoint;
    
    //
    CGRect rcLabelFrame = pCountLabel.frame;
    rcLabelFrame.size.width = framePoint.size.width;
    rcLabelFrame.origin.y =(framePoint.size.height - 18)/2+framePoint.origin.y;
    pCountLabel.frame = rcLabelFrame;
    
    */
    if(strText.length > 2)
    {
        //strText = @"..";
        strText = @"99+";
    }
    pCountLabel.text = strText;
    
}
//获取控件所在的tableCell的对象，主要是不同的ios版本下，这个层次有所不同
+(UITableViewCell*)getSuperTableViewCell:(id)sender
{
    
    UIView* pSenderView = sender;
    if(pSenderView == nil)
        return nil;
    UITableViewCell* pCellObj = nil;
    while (true) {
        
        UIView* pSuperView = [pSenderView superview];
        if(pSenderView == nil)
            return nil;
        if([pSenderView isKindOfClass:[UITableViewCell class]])
        {
            pCellObj = (UITableViewCell*)pSenderView;
            return pCellObj;
        }
        pSenderView = pSuperView;
    }
    return nil;
}

@end
