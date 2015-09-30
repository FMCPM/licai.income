//
//  JCTabBar.m
//
//  Created by Joy Chiang on 12-2-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "JCTabBar.h"
#import "BarBackgroundLayer.h"
#import "UIView+Positioning.h"


@implementation JCTabBar

@synthesize delegate = _delegate;
@synthesize pageControl = _pageControl;
@synthesize tabContainer = _tabContainer;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self setBackgroundLayer:[[BarBackgroundLayer alloc] init] ];
        self.tabContainer = [[JCTabContainer alloc] initWithFrame:self.bounds];
        self.tabContainer.delegate = self;
        [self addSubview:self.tabContainer];
    }
    return self;
}

- (JCPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[JCPageControl alloc] initWithFrame:CGRectMake(0, 8, 320, 6)];
        _pageControl.pageControlStyle = PageControlStyleThumb;
        _pageControl.numberOfPages = 2;
        _pageControl.currentPage = 0;
        [self addSubview:_pageControl];
    }
    return _pageControl;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = self.tabContainer.frame.size.width;
    NSInteger page = (NSInteger)floor((self.tabContainer.contentOffset.x * 2.0f + pageWidth) / (pageWidth * 2.0f));
    self.pageControl.currentPage = page;
}

- (void)setBackgroundLayer:(CALayer *)backgroundLayer {
    CALayer *oldBackground = [[self.layer sublayers] objectAtIndex:0];
    if (oldBackground) {
        [self.layer replaceSublayer:oldBackground with:backgroundLayer];
    } else {
        [self.layer insertSublayer:backgroundLayer atIndex:0];
    }
}

- (void)layoutSubviews {
    [self.tabContainer centerInSuperView];
}

- (void)didSelectItemAtIndex:(NSUInteger)itemIndex {
    if (self.delegate) {
        [self.delegate tabBar:self didSelectIndex:itemIndex];
    }
}

- (void)resetTabItems {
    [self.tabContainer.tabItems makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.tabContainer.tabItems removeAllObjects];
}

- (void)addTabItem:(JCTabBarItem *)tabItem {
    [self.tabContainer addTabItem:tabItem];
}

- (void)addTabItemWithTitle:(NSString *)title icon:(UIImage *)icon {
    JCTabBarItem *tabItem = [JCTabBarItem tabItemWithTitle:title icon:icon];
    [self addTabItem:tabItem];
}

#if NS_BLOCKS_AVAILABLE
- (void)addTabItemWithTitle:(NSString *)title icon:(UIImage *)icon executeBlock:(JCTabExecutionBlock)executeBlock {
    JCTabBarItem * tabItem = [JCTabBarItem tabItemWithTitle:title icon:icon executeBlock:executeBlock];
    [self addTabItem:tabItem];
}
#endif

- (void)setSelectedIndex:(NSUInteger)itemIndex {
    [self.tabContainer layoutSubviews];
    [self didSelectItemAtIndex:itemIndex];
    [self.tabContainer animateSelectionToItemAtIndex:itemIndex];
}

- (void)setSelectionView:(JCSelectionView *)selectionView {
    [[self.tabContainer selectionView] removeFromSuperview];
    [self.tabContainer setSelectionView:selectionView];
    if (selectionView) [self.tabContainer insertSubview:selectionView atIndex:0];
}

- (void)setItemSpacing:(CGFloat)itemSpacing {
    [self.tabContainer setItemSpacing:itemSpacing];
    [self.tabContainer setNeedsLayout];
}

- (void)dealloc {
    self.delegate = nil;
    self.tabContainer = nil;

}

@end