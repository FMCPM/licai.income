//
//  BTSelectionView.m
//  jojo
//
//  Created by  jacob.Chiang on 12-11-9.
//  Copyright (c) 2012年 TCGROUP. All rights reserved.
//

#import "BTSelectionView.h"
#import "GlobalDefine.h"
#import <QuartzCore/QuartzCore.h>

@implementation BTSelectionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
       [self setBackgroundColor:[UIColor clearColor]];
        self.layer.shadowOffset = CGSizeMake(0, 1);
        self.layer.shadowRadius = 1.;
        self.layer.shadowColor = [[UIColor whiteColor] CGColor];
        self.layer.shadowOpacity = 0.4;
        self.clipsToBounds = NO;
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{

    // Drawing code
/* 暂时不要这个图片了
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [RGBCOLOR(216,87,39) CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [img drawInRect:rect];
*/
    //[[UIImage imageNamed:@"selectview_bg.png"] drawInRect:rect];
}


+(BTSelectionView*)createSelectView
{
    BTSelectionView *selectionView = [[BTSelectionView alloc] initWithFrame:CGRectZero];
    return selectionView;
}



@end
