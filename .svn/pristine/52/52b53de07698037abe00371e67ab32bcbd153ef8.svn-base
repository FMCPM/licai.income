//
//  JCTabBar.h
//
//  Created by Joy Chiang on 12-2-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCTabBarItem.h"
#import "JCPageControl.h"
#import "JCTabConstants.h"
#import "JCTabContainer.h"
#import "JCSelectionView.h"
#import <QuartzCore/QuartzCore.h>

@protocol JCTabBarDelegate;

@class JCTabContainer;

@interface JCTabBar : UIView<UIScrollViewDelegate>

@property(nonatomic, readonly) JCPageControl *pageControl;
@property(nonatomic, assign) id<JCTabBarDelegate> delegate;
@property(nonatomic,retain) JCTabContainer *tabContainer;

- (void)resetTabItems;
- (void)addTabItem:(JCTabBarItem *)tabItem;
- (void)setSelectedIndex:(NSUInteger)itemIndex;
- (void)didSelectItemAtIndex:(NSUInteger)itemIndex;
- (void)addTabItemWithTitle:(NSString *)title icon:(UIImage *)icon;

- (void)setItemSpacing:(CGFloat)itemSpacing;
- (void)setBackgroundLayer:(CALayer *)backgroundLayer;
- (void)setSelectionView:(JCSelectionView *)selectionView;

#if NS_BLOCKS_AVAILABLE
- (void)addTabItemWithTitle:(NSString *)title icon:(UIImage *)icon executeBlock:(JCTabExecutionBlock)executeBlock;
#endif

@end

//////////////////////////////////////////////////////////////////////////

@protocol JCTabBarDelegate
- (void)tabBar:(JCTabBar *)tabBar didSelectIndex:(NSUInteger)itemIndex;
- (BOOL)tabBar:(JCTabBar *)tabBar shouldSelectIndex:(NSUInteger)itemIndex;
@end