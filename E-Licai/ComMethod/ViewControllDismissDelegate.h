//
//  ViewControllDismissDelegate.h
//  YTSearch
//
//  Created by jiangjunchen on 12-11-28.
//
//

#import <Foundation/Foundation.h>

@protocol ViewControllDismissDelegate <NSObject>
@optional
-(void)viewController:(UIViewController*)ctrl dismissAnimated:(BOOL)animated context:(NSString*)context;
@end
