//
//  JCTabBarItem.m
//
//  Created by Joy Chiang on 12-2-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "JCTabBarItem.h"
#import "JCTabContainer.h"
#import "GlobalDefine.h"

@implementation JCTabBarItem

@synthesize icon = _icon;
@synthesize title = _title;
@synthesize titleFont = _titleFont;
@synthesize titleColor = _titleColor;
@synthesize fixedWidth = _fixedWidth;
@synthesize executeBlock = _executeBlock;
@synthesize titleSelectedColor = _titleSelectedColor;
@synthesize m_iNewCountHint = _iNewCountHint;

- (id)initWithTitle:(NSString *)title icon:(UIImage *)icon {
    if ((self = [super init])) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self setIsAccessibilityElement:YES];
        [self setAccessibilityLabel:title];
        
        self.icon = icon;
        self.title = title;
        self.titleFont = kTabItemFont;
        self.titleColor = kTabItemTextColor;
        self.titleSelectedColor = RGBCOLOR(65, 133, 213);
        
        [self addTarget:self action:@selector(itemTappedUp) forControlEvents:UIControlEventTouchUpInside];
        [self addTarget:self action:@selector(itemDoubleTapped) forControlEvents:(UIControlEventTouchDownRepeat)];
    }
    return self;
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize titleSize = [self.title sizeWithFont:_titleFont];
    
    CGFloat width = titleSize.width;
    
    if (self.icon) {
        width += [self.icon size].width;
    }
    if (self.icon && self.title) {
        width += kTabItemIconMargin;
    }
    
    width += (kTabItemPadding.width * 2);
    
    CGFloat height = (titleSize.height > [self.icon size].height) ? titleSize.height : [self.icon size].height;
    
    height += (kTabItemPadding.height * 2);
    
    if (self.fixedWidth > 0) {
        width = self.fixedWidth;
        height = 1.;
    }
    
    return CGSizeMake(width, height);
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIColor *shadowColor = [UIColor blackColor];
    CGContextSetShadowWithColor(context, CGSizeMake(0.0f, 1.0f), 1.0f, [shadowColor CGColor]);
    CGContextSaveGState(context);
    
    if (self.highlighted) {
        CGRect bounds = CGRectInset(rect, 2., 2.);
        CGFloat radius = 0.5f * CGRectGetHeight(bounds);
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:bounds cornerRadius:radius];
        [[UIColor colorWithWhite:1. alpha:0.3] set];
        path.lineWidth = 2.;
        [path stroke];
    }
    
    CGFloat xOffset = kTabItemPadding.width;
    
    if (self.icon) {
        [self.icon drawAtPoint:CGPointMake(xOffset, kTabItemPadding.height)];
        xOffset += [self.icon size].width + kTabItemIconMargin;
    }
    
    [_titleColor set];
    CGFloat heightTitle = [self.title sizeWithFont:_titleFont].height;
    CGFloat titleYOffset = (self.bounds.size.height - heightTitle) / 2;
    [self.title drawAtPoint:CGPointMake(xOffset, titleYOffset) withFont:_titleFont];
    
    CGContextRestoreGState(context);
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    [self setNeedsDisplay];
}

- (BOOL)isSelectedTabItem {
    JCTabContainer *tabContainer = (JCTabContainer *)[self superview];
    return [tabContainer isItemSelected:self];
}

- (void)itemTappedUp {
    JCTabContainer *tabContainer = (JCTabContainer *)[self superview];
    JCTabBar *tabBar = (JCTabBar *)[tabContainer superview];
    BOOL shouldSelect = [tabBar.delegate tabBar:tabBar shouldSelectIndex:[tabContainer.tabItems indexOfObject:self]];
    if (![self isSelectedTabItem] && shouldSelect) {
        [tabContainer itemSelected:self];
        
#ifdef NS_BLOCKS_AVAILABLE
        if (_executeBlock) {
            _executeBlock();
        }
#endif
    }
}

- (void)itemDoubleTapped {
//    NSLog(@"====itemDoubleTapped====");
}

+ (JCTabBarItem *)tabItemWithTitle:(NSString *)title icon:(UIImage *)icon {
    JCTabBarItem *tabItem = [[JCTabBarItem alloc] initWithTitle:title icon:icon];
    return tabItem;
}

+ (JCTabBarItem *)tabItemWithFixedWidth:(CGFloat)fixedWidth {
    JCTabBarItem *tabItem = [JCTabBarItem tabItemWithTitle:nil icon:nil];
    tabItem.fixedWidth = fixedWidth;
    return tabItem;
}

#ifdef NS_BLOCKS_AVAILABLE
+ (JCTabBarItem *)tabItemWithTitle:(NSString *)title icon:(UIImage *)icon executeBlock:(JCTabExecutionBlock)executeBlock {
    JCTabBarItem *tabItem = [JCTabBarItem tabItemWithTitle:title icon:icon];
    tabItem.executeBlock = executeBlock;
    return tabItem;
}
#endif

- (void)dealloc {
    self.icon = nil;
    self.title = nil;
    self.titleFont = nil;
    self.titleColor = nil;
    self.executeBlock = nil;
    self.titleSelectedColor = nil;
    //[super dealloc];
}

@end