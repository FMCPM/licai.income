//
//  CustomTabItem.m
//
//  Created by Joy Chiang on 12-2-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CustomTabItem.h"
#import "JCTabContainer.h"
#import "UIColor+Hex.h"
#import "GlobalDefine.h"
#import "UaConfiguration.h"

@implementation CustomTabItem

@synthesize alternateIcon = _alternateIcon;

+ (CustomTabItem *)tabItemWithTitle:(NSString *)title icon:(UIImage *)icon alternateIcon:(UIImage *)alternativeIcon {
    CustomTabItem *tabItem = [[CustomTabItem alloc] initWithTitle:title icon:icon] ;
    tabItem.titleColor = COLOR_FONT_2;
    tabItem.titleSelectedColor = COLOR_FONT_3;
    tabItem.alternateIcon = alternativeIcon;
    tabItem.titleFont = [UIFont systemFontOfSize:13];
    if([title isEqualToString:@"更多"] == true)
    {
        UIImageView* pRedPointView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 2, 10, 10)];
        pRedPointView.image = [UIImage imageNamed:@"orangepoint_count.png"];
        [tabItem addSubview:pRedPointView];
        
        [UaConfiguration sharedInstance].m_uiBuyCarHintImgView = pRedPointView;
        /*
        UILabel* pLabel = [[UILabel alloc] initWithFrame:CGRectMake(38, 4, 20, 16)];
        pLabel.backgroundColor = [UIColor clearColor];
        pLabel.textAlignment  = UITextAlignmentCenter;
        pLabel.textColor = [UIColor whiteColor];
        pLabel.text = @"";
        pLabel.font = [UIFont boldSystemFontOfSize:12];
       // [UaConfiguration sharedInstance].m_uiBuyCarHintLabel = pLabel;
        [pRedPointView setHidden:YES];
        [pLabel setHidden:YES];
        [tabItem addSubview:pLabel];
         */
    }
    else
        tabItem.m_iNewCountHint = 0;
    return tabItem;
}

- (CGSize)sizeThatFits:(CGSize)size {
    JCTabContainer *tabContainer = (JCTabContainer *)[self superview];
    NSUInteger itemCount = [tabContainer numberOfTabItems];
    if (itemCount > 0) {
        return CGSizeMake(320/itemCount, tabContainer.frame.size.height);
    }
    return CGSizeZero;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
   // UIColor *shadowColor = [UIColor blackColor];
    UIColor *shadowColor = [UIColor clearColor];
    CGContextSetShadowWithColor(context, CGSizeMake(0.0f, 1.0f), 1.0f, [shadowColor CGColor]);
    CGContextSaveGState(context);
   
    CGFloat yOffset = 0.0;
    
    UIImage *iconImage = [self isSelectedTabItem] ? (self.alternateIcon==nil?self.icon:self.alternateIcon) : self.icon;
    if (iconImage)
    {
        CGFloat iconMarginWidth = (rect.size.width - iconImage.size.width) / 2;
        if (!self.title || !self.title.length)
            yOffset = (rect.size.height - iconImage.size.height) / 2;
        else
            yOffset = yOffset+5;
        [iconImage drawAtPoint:CGPointMake(iconMarginWidth, yOffset)];

        yOffset += iconImage.size.height;
    }
    
    if (self.title && self.title.length)
    {
        CGSize titleSize = [self.title sizeWithFont:self.titleFont];
        CGFloat titleMarginWidth = (rect.size.width - titleSize.width) / 2;
        yOffset = (iconImage == nil ? (rect.size.height - titleSize.height) / 2 : yOffset);
        
        UIColor *textColor = [self isSelectedTabItem] ? self.titleSelectedColor : self.titleColor;
        [textColor set];
        [self.title drawAtPoint:CGPointMake(titleMarginWidth, yOffset+4) withFont:self.titleFont];
    }
    
}

- (void)dealloc {
    self.alternateIcon = nil;

}

@end
