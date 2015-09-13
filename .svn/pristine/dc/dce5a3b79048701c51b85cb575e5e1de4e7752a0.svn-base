//
//  JCTabContainer.h
//
//  Created by Joy Chiang on 12-2-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "JCTabBar.h"
#import <UIKit/UIKit.h>
#import "JCSelectionView.h"

@interface JCTabContainer : UIScrollView {
    CGSize _containerSize;
}

@property(nonatomic, assign) CGFloat itemSpacing;
@property(nonatomic, assign) NSUInteger selectedIndex;
@property(nonatomic, retain) NSMutableArray *tabItems;
@property(nonatomic, retain) JCSelectionView *selectionView;

- (NSUInteger)numberOfTabItems;
- (void)addTabItem:(JCTabBarItem *)tabItem;
- (void)itemSelected:(JCTabBarItem *)tabItem;
- (BOOL)isItemSelected:(JCTabBarItem *)tabItem;
- (void)animateSelectionToItemAtIndex:(NSUInteger)itemIndex;

- (void)itemSelectedByIndex:(int)itemIndex;
@end