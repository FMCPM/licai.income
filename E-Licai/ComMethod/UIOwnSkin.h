//
//  Skin.h
//  EBook
//
//  Created by Jacob Chiang on 12-5-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
/**
 * 放置 公用的 按钮或者 皮肤
 ***/

#import <Foundation/Foundation.h>
#import "UIImage+Resize.h"


@interface UIOwnSkin : NSObject

// 返回UINavigationBar  返回 按钮
+ (UIBarButtonItem *)backItemTarget:(id)target action:(SEL)action;
// 顶部导航栏的搜索按钮
+(UIBarButtonItem*)topSearchItemTarget:(id)target action:(SEL)action;
// 返回 刷新 按钮
+(UIBarButtonItem*)refushItemTarget:(id)target action:(SEL)action;

// 自定义 文字 按钮
+(UIBarButtonItem*)textItemTarget:(id)target action:(SEL)action text:(NSString*)text;

// 自定义 文字按钮，选中和不选择 文字变化
+(UIBarButtonItem*)textItemTarget:(id)target action:(SEL)action text:(NSString*)text selectText:(NSString*)selecttext;

+ (UIBarButtonItem *)spreadBtnTarget:(id)target action:(SEL)action;

// 地图按钮
+ (UIBarButtonItem *)mapBtnTarget:(id)target action:(SEL)action;

// 设置 背景 图片
+(UIColor*)backgroundColor:(CGRect)frame;

//图片按钮
+ (UIBarButtonItem *)imageBtnTarget:(NSString*)strImageName andTarget:(id)target action:(SEL)action andWidth:(NSInteger)iWidth andHeight:(NSInteger)iHeight;

//
+ (UIBarButtonItem *)topBarImageBtnTarget:(NSString*)strImageName andTarget:(id)target action:(SEL)action andLeft:(NSInteger)iLeft andTop:(NSInteger)iTop andWidth:(NSInteger)iWidth andHeight:(NSInteger)iHeight;

// 小纹理 背景 图片
+(UIColor*)smallTextureBackgroudColor:(CGRect)frame;

+(UIBarButtonItem*)dropArrowItemTarget:(id)target action:(SEL)action;

+(UIBarButtonItem*)navTextItemTarget:(id)target action:(SEL)action text:(NSString*)text andWidth:(NSInteger)iWidth;

+(UIBarButtonItem*)navTextItemTarget:(id)target action:(SEL)action text:(NSString*)text andWidth:(NSInteger)iWidth color:(UIColor *)color;

//导航条上的标题视图
+(UILabel*)navibarTitleView:(NSString*)strTitle andFrame:(CGRect)rcFame;

//根据当前的ios的版本信息，获取正确的视图的位置;
+(CGRect)getViewRectByIosVersion:(CGRect)frame;
//设置按钮的背景
+(void)setButtonBackground:(UIButton*)pButton bgColor:(UIColor *)bgColor tColor:(UIColor *)tColor;
//设置按钮的默认背景
+(void)setButtonBackground:(UIButton*)pButton;
//给按钮设置指定的背景色
+(void)setButtonBackground:(UIButton*)pButton andColor:(UIColor*)bColor;
//设置按钮的边框的颜色
+(void)setButtonFontRect:(UIButton*)pButton;
//给按钮的边框设置指定的颜色
+(void)setButtonFontRect:(UIButton*)pButton andColor:(UIColor*)bColor;
//创建红点背景的Label
+(void)createOrangePointLabel:(UITableViewCell*)pCellObj andX:(NSInteger)iX andY:(NSInteger)iY andTag:(NSInteger)iTag;
//设置红点背景的Label
+(void)setOrangePointLabelText:(UITableViewCell*)pCellObj andText:(NSString*)strText andTag:(NSInteger)iTag;
//获取控件所在的tableCell的对象，主要是不同的ios版本下，这个层次有所不同
+(UITableViewCell*)getSuperTableViewCell:(id)sender;

@end
