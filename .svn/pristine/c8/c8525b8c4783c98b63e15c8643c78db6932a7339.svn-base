//
//  JCTabBarController.h
//  Framework-iOS
//  Description:自定义UITabBarController控件
//
//  Created by lvzhuqiang on 2013-06-25.
//  Copyright (c) 2013年 __杭州云天信息技术有限公司__. All rights reserved.
//  Version 1.0
//

#import <UIKit/UIKit.h>
#import "JCTabBar.h"

typedef enum {
    PushPopAnimationLeftRight = 0,
    PushPopAnimationUpDown
} PushPopAnimationDirection;

@interface JCTabBarController : UITabBarController<UINavigationControllerDelegate, JCTabBarDelegate>

@property(nonatomic, readonly) JCTabBar *JCTabBar;
@property(nonatomic, assign) PushPopAnimationDirection animationDirection;// viewController转换时tabBar隐藏或显示动画方向，默认为系统的左右移动
@property(nonatomic, strong) NSArray*   m_nsHigleImageNameList;

- (void)addTabBarItemWithViewController:(UIViewController *)viewController andIndex:(NSInteger)iIndex;// 添加tabBarItem，自定义JCTabBarItem时需重写该方法

@end

//////////////////////////////////////////////////////////////////////////////////////

@interface UIViewController (JCTabBarControllerItem)

@property(nonatomic, retain) JCTabBarItem *JCTabBarItem;
@property(nonatomic, readonly, retain) JCTabBarController *JCTabBarController;

@end