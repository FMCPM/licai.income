//
//  UISearchBar+CKSearch.m
//  YTSearch
//
//  Created by jiang junchen on 12-11-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UISearchBar+CKSearch.h"

@implementation UISearchBar (CKSearch)

-(void) setCKSearchReturnKeyType:(UIReturnKeyType)type
{
    for (UIView *searchBarSubview in self.subviews)
    {
        if ([searchBarSubview conformsToProtocol:@protocol(UITextInputTraits)])
        {
            [(UITextField *)searchBarSubview setReturnKeyType:type];  
            //类型自己选吧
        }
    }
}

-(void)setCKSearchCancelBtnTitle:(NSString*)str
{
    for(id cc in [self subviews])
    {
        if([cc isKindOfClass:[UIButton class]])
        {
            UIButton *btn = (UIButton *)cc;
            [btn setTitle:str  forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [btn setEnabled:YES];
        }
    }
}

-(void)setCKSearchCancelBtnTitleColor:(UIColor *)color forState:(UIControlState)state
{
    for(id cc in [self subviews])
    {
        if([cc isKindOfClass:[UIButton class]])
        {
            UIButton *btn = (UIButton *)cc;
            [btn setTitleColor:color forState:state];
        }
    }
}

-(void) setBackgroundClear
{
    for (UIView *subview in self.subviews)
    {
        if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")])
        {
            [subview removeFromSuperview];
        }
    }
}
@end
