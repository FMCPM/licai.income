//
//  UINavigationController+CKKit.m
//  E-YellowPage
//
//  Created by jiangjunchen on 12-12-28.
//  Copyright (c) 2012年 ytinfo. All rights reserved.
//

#import "UINavigationController+CKKit.h"
#import "PrettyNavigationBar.h"

@implementation UINavigationController (CKKit)

-(id)initWithNavigationBarClass:(Class)navigationBarClass rootViewController:(UIViewController*)rootController;
{

    self = [self initWithNavigationBarClass:navigationBarClass toolbarClass:nil];
    if (self) {
        [self pushViewController:rootController animated:NO];
    }
    return self;
}
@end
