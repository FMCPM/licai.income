//
//  UISearchBar+CKSearch.h
//  YTSearch
//
//  Created by jiang junchen on 12-11-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UISearchBar (CKSearch)

-(void) setCKSearchReturnKeyType:(UIReturnKeyType)type;
-(void)setCKSearchCancelBtnTitle:(NSString*)str;
-(void)setCKSearchCancelBtnTitleColor:(UIColor *)color forState:(UIControlState)state;
-(void) setBackgroundClear;
@end
