//
//  UILabel+CKKit.m
//  YTSearch
//
//  Created by jiangjunchen on 12-11-20.
//
//

#import "UILabel+CKKit.h"

#define LABEL_TEXT_MARGIN 5.0
@implementation UILabel (CKKit)


-(void)setFitSize
{
    self.numberOfLines = 0;
    self.lineBreakMode = UILineBreakModeClip;
    CGSize textSize = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(self.bounds.size.width-2*LABEL_TEXT_MARGIN, 10000) lineBreakMode:UILineBreakModeWordWrap];
    CGRect frame = self.frame;
    frame.size = textSize;
    self.frame = frame;
}

+(CGFloat)getFitTextHeightWithText:(NSString*)text andWidth:(CGFloat)width andFont:(UIFont*)font
{
    CGSize textSize = [text sizeWithFont:font constrainedToSize:CGSizeMake(width-2*LABEL_TEXT_MARGIN, 10000) lineBreakMode:UILineBreakModeWordWrap];
    return textSize.height+10;//add by lzq at 2014-03-31,加上10个像素后，显示比较正常
}
@end
