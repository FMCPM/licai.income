//
//  JCTabBarItem.h
//
//  Created by Joy Chiang on 12-2-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#if NS_BLOCKS_AVAILABLE
typedef void(^JCTabExecutionBlock)(void);
#endif

@interface JCTabBarItem : UIButton

@property(nonatomic) CGFloat fixedWidth;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, retain) UIImage *icon;
@property(nonatomic, retain) UIFont  *titleFont;
@property(nonatomic, retain) UIColor *titleColor;
@property(nonatomic, retain) UIColor *titleSelectedColor;
@property(nonatomic, assign) NSInteger  m_iNewCountHint;

- (id)initWithTitle:(NSString *)title icon:(UIImage *)icon;
- (BOOL)isSelectedTabItem;

+ (JCTabBarItem *)tabItemWithTitle:(NSString *)title icon:(UIImage *)icon;
+ (JCTabBarItem *)tabItemWithFixedWidth:(CGFloat)fixedWidth;

#if NS_BLOCKS_AVAILABLE
@property(nonatomic, copy) JCTabExecutionBlock executeBlock;
+ (JCTabBarItem *)tabItemWithTitle:(NSString *)title icon:(UIImage *)icon executeBlock:(JCTabExecutionBlock)executeBlock;
#endif

@end