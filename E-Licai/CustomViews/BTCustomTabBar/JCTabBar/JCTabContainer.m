//
//  JCTabContainer.m
//
//  Created by Joy Chiang on 12-2-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//


#import "JCTabContainer.h"
#import "UIView+Positioning.h"

#define kSelectionAnimation @"kSelectionAnimation"

////////////////////////////////////////////////////////////////

@implementation JCTabContainer

@synthesize tabItems = _tabItems;
@synthesize itemSpacing = _itemSpacing;
@synthesize selectionView = _selectionView;
@synthesize selectedIndex = _selectedIndex;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        self.itemSpacing = kTabSpacing;
        self.tabItems = [NSMutableArray array];
        self.selectionView = [[JCSelectionView alloc] initWithFrame:CGRectZero];
        [self addSubview:_selectionView];
        
        self.bounces = NO;
        self.pagingEnabled = YES;
        self.showsHorizontalScrollIndicator = NO;
    }
    return self;
}

- (void)layoutSubviews {
    CGFloat xOffset = 0.;
    CGFloat yOffset = 0.;
    CGFloat itemWidth = 0.;
    CGFloat itemHeight = 0.;
    
    NSUInteger tabItemCount = self.tabItems.count;
    BOOL aboveMaxItems = tabItemCount > 6 ? YES : NO;
    
    for (JCTabBarItem *item in self.tabItems) {
        [item sizeToFit];
        
        itemWidth = item.frame.size.width;
        itemHeight = item.frame.size.height;
        if (aboveMaxItems) {
            itemWidth = 320/(tabItemCount/2);
        }
        [item setFrame:CGRectMake(xOffset, yOffset, itemWidth, itemHeight)];
        
        xOffset += itemWidth;
    }

    _containerSize.width = xOffset;
    _containerSize.height = itemHeight;
    
    self.contentSize = CGSizeMake(xOffset, self.frame.size.height);
    
//    [self sizeToFit];
    [self centerInSuperView];
}

- (CGSize)sizeThatFits:(CGSize)size {
    return _containerSize;
}

- (void)addTabItem:(JCTabBarItem *)tabItem {
    [self.tabItems addObject:tabItem];
    [self addSubview:tabItem];
    [self setNeedsLayout];
}

- (BOOL)isItemSelected:(JCTabBarItem *)tabItem {
    return ([self.tabItems indexOfObject:tabItem] == self.selectedIndex);
} 

- (void)itemSelected:(JCTabBarItem *)tabItem {
    self.selectedIndex = [self.tabItems indexOfObject:tabItem];
    [self animateSelectionToItemAtIndex:self.selectedIndex];
    
    for (JCTabBarItem *item in self.tabItems) {
        [item setNeedsDisplay];
    }
    
    JCTabBar *tabBar = (JCTabBar *)[self superview];
    [tabBar didSelectItemAtIndex:self.selectedIndex];
}

- (void)itemSelectedByIndex:(int)itemIndex
{
    [self animateSelectionToItemAtIndex:itemIndex];
    
    for (JCTabBarItem *item in self.tabItems) {
        [item setNeedsDisplay];
    }
    
    JCTabBar *tabBar = (JCTabBar *)[self superview];
    [tabBar didSelectItemAtIndex:itemIndex];
}

- (void)animateSelectionToItemAtIndex:(NSUInteger)itemIndex {
    if (itemIndex < self.tabItems.count) {
        self.selectedIndex = itemIndex;
        JCTabBarItem *tabItem = [self.tabItems objectAtIndex:itemIndex];
        [UIView beginAnimations:kSelectionAnimation context:(void*)self.selectionView];
       // [UIView beginAnimations:kSelectionAnimation context:self.selectionView];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:(CGRectIsEmpty(self.selectionView.frame) ? 0. : kTabSelectionAnimationDuration)];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        self.selectionView.frame = tabItem.frame;
        [UIView commitAnimations];
    }
}

- (NSUInteger)numberOfTabItems {
    return [self.tabItems count];
}


@end