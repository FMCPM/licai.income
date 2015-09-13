//
//  UILabel+CKKit.h
//  YTSearch
//
//  Created by jiangjunchen on 12-11-20.
//
//

#import <UIKit/UIKit.h>

@interface UILabel (CKKit)

-(void)setFitSize;
+(CGFloat)getFitTextHeightWithText:(NSString*)text andWidth:(CGFloat)width andFont:(UIFont*)font;
@end
