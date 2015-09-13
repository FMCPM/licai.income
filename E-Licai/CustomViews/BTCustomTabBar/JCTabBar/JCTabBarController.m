//
//  JCTabBarController.m
//  Framework-iOS
//  Description:自定义UITabBarController控件
//
//  Created by lvzhuqiang on 2013-06-25.
//  Copyright (c) 2013年 __杭州云天信息技术有限公司__. All rights reserved.
//  Version 1.0
//

#import "JCTabBarController.h"
#import "CustomBackgroundLayer.h"
#import "CustomSelectionView.h"
#import "CustomTabItem.h"
#import "UIView+Size.h"
#import "GlobalDefine.h"


#define kUINavigationControllerPushPopAnimationDuration     0.35

//@interface JCTabBarController()
//@end

@implementation JCTabBarController

@synthesize JCTabBar = _JCTabBar;
@synthesize animationDirection = _animationDirection;
@synthesize m_nsHigleImageNameList = _nsHigleImageNameList;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.JCTabBar];
}

- (JCTabBar *)JCTabBar
{
    if (!_JCTabBar)
    {
        _JCTabBar = [[JCTabBar alloc] initWithFrame:self.tabBar.frame];
        [_JCTabBar setBackgroundLayer:[[CustomBackgroundLayer alloc] init] ];
        [_JCTabBar setSelectionView:[CustomSelectionView createSelectionView]];
        [_JCTabBar setAutoresizingMask:self.tabBar.autoresizingMask];
        [_JCTabBar setDelegate:self];
        if (self.viewControllers.count)
            [self setViewControllers:self.viewControllers];
    }
    return _JCTabBar;
}

- (void)addTabBarItemWithViewController:(UIViewController *)viewController andIndex:(NSInteger)iIndex
{
    if (viewController)
    {
        UIImage*pImage = nil;
        if(iIndex >-1 && (iIndex<_nsHigleImageNameList.count))
        {
            NSString*strImageName = [_nsHigleImageNameList objectAtIndex:iIndex];
            pImage = IMG_WITH_ARG_v2(strImageName);//[UIImage imageNamed:strImageName];
        }
        [self.JCTabBar addTabItem:[CustomTabItem tabItemWithTitle:viewController.tabBarItem.title icon:viewController.tabBarItem.image alternateIcon:pImage]];
        
    }
}

- (void)setViewControllers:(NSArray *)viewControllers {
    if (viewControllers && viewControllers.count)
    {
        [self.JCTabBar resetTabItems];
        
        int iIndex = -1;
        for (UIViewController *viewController in viewControllers)
        {
            iIndex++;
            [self addTabBarItemWithViewController:viewController andIndex:iIndex];
            if ([viewController isKindOfClass:[UINavigationController class]])
            {
                [(UINavigationController *)viewController setDelegate:self];
            }
        }
        [super setViewControllers:viewControllers];
        [self.moreNavigationController setDelegate:self];
        if (!IS_OS_5_OR_LATER) [self.JCTabBar setSelectedIndex:0];
    }
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    [self.JCTabBar setSelectedIndex:selectedIndex];
}

// tabBar中的itemIndex位置被选中
- (void)tabBar:(JCTabBar *)tabBar didSelectIndex:(NSUInteger)itemIndex {
    [super setSelectedIndex:itemIndex];
    JC_CALL_DELEGATE_WITH_ARGS(self.delegate, @selector(tabBarController:didSelectViewController:), self, self.selectedViewController);
}

// tabBar中的itemIndex位置将要被选中
- (BOOL)tabBar:(JCTabBar *)tabBar shouldSelectIndex:(NSUInteger)itemIndex {
    if ([self.delegate respondsToSelector:@selector(tabBarController:shouldSelectViewController:)]) {
        return [self.delegate tabBarController:self shouldSelectViewController:[self.viewControllers objectAtIndex:itemIndex]];
    }
    return YES;
}

// 显示tabBar
- (void)showTabBarWithAnimated:(BOOL)animated {
    self.JCTabBar.hidden = NO;
    [UIView animateWithDuration:animated ? kUINavigationControllerPushPopAnimationDuration : 0.0
            animations:^{ self.JCTabBar.transform = CGAffineTransformIdentity; }
            completion:NULL];
}

// 隐藏tabBar
- (void)hideTabBarWithAnimated:(BOOL)animated {
    CGFloat tx = self.tabBar.width * -1.0;
    CGFloat ty = 0.0;
    if (_animationDirection == PushPopAnimationUpDown) {
        tx = 0.0;
        ty = self.tabBar.height * 2.0;
    }
    [UIView animateWithDuration:animated ? kUINavigationControllerPushPopAnimationDuration : 0.0
            animations:^{ self.JCTabBar.transform = CGAffineTransformMakeTranslation(tx, ty); }
            completion:^(BOOL finished){
                self.JCTabBar.hidden = YES;
            }
    ];
}

// navigationController将要显示viewController视图控制器
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    /*
        当viewControllers超过5个时，系统自动在构建的视图控制器上包了一层moreNavigationController(该视图将剩余的控制器用列表的形式展示出来)
        所以当选中第5个以上的视图时，依照苹果设计规则moreNavigationController自动设置了backButton(More)按钮。所以此处手动隐藏该按钮，实际上目前
        显示的视图控制器处于moreNavigationController的第二层，第一层为moreNavigationController的列表。
        注意：采用该种方法来替代在超过5个viewControllers时系统自动处理成moreNavigationController的方式有一缺点：
             如果视图控制器在设计时并没有采用UINavigationController，则此时系统则会自动多包了一层moreNavigationController。
     */
    if (navigationController == self.moreNavigationController && self.moreNavigationController.viewControllers.count == 2) {
        [viewController.navigationItem setHidesBackButton:YES];
    } else {
        [viewController.navigationItem setHidesBackButton:NO];
    }
    
    self.tabBar.alpha = 0;
    if (viewController.hidesBottomBarWhenPushed == YES && self.JCTabBar.hidden == NO) {
        [self hideTabBarWithAnimated:animated];
    } else if(viewController.hidesBottomBarWhenPushed == NO && self.JCTabBar.hidden == YES) {
        [self showTabBarWithAnimated:animated];
    }
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
}



@end

////////////////////////////////////////////////////////////////////////////////

@implementation UIViewController (JCTabBarControllerItem)

@dynamic JCTabBarItem, JCTabBarController;

- (JCTabBarItem *)JCTabBarItem {
    return nil;
}

- (JCTabBarController *)JCTabBarController {
    UIViewController *viewController = self.parentViewController;
    while (!(viewController == nil || [viewController isKindOfClass:[JCTabBarController class]])) {
        viewController = viewController.parentViewController;
    }
    return (JCTabBarController *)viewController;
}

@end