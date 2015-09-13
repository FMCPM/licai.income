//
//  BTCustomTabBarController.m
//  jojo
//
//  Created by  jacob.Chiang on 12-11-9.
//  Copyright (c) 2012年 TCGROUP. All rights reserved.
//

#import "BTCustomTabBarController.h"
#import "BTSelectionView.h"
#import "BTTabBarBackgroudLayer.h"

@interface BTCustomTabBarController ()

@end

@implementation BTCustomTabBarController

@synthesize JCTabBar = _JCTabBar;

-(void)viewDidLoad
{
    [super viewDidLoad];
}

-(JCTabBar*)JCTabBar
{
    if (!_JCTabBar)
    {
        _JCTabBar = [[JCTabBar alloc] initWithFrame:self.tabBar.frame];
        [_JCTabBar setBackgroundLayer:[[BTTabBarBackgroudLayer alloc] init]];
        [_JCTabBar setSelectionView:[BTSelectionView createSelectView]];
        //[_JCTabBar setSelectionView:nil];
        [_JCTabBar setAutoresizingMask:self.tabBar.autoresizingMask];
        [_JCTabBar setDelegate:self];
        [_JCTabBar setItemSpacing:1];
        if (self.viewControllers.count) [self setViewControllers:self.viewControllers];
    }
    return _JCTabBar;
}

@end
