//
//  PPiFlatSegmentedControl.h
//  PPiFlatSegmentedControl
//
//  Created by Pedro Piñera Buendía on 12/08/13.
//  Copyright (c) 2013 PPinera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol OwnSegmentedControlDelegate<NSObject>
@optional
-(void)didChangeSegmentedIndex:(UIButton*)pButton selectedIndex:(NSInteger)iBtnIndex;

@end

@interface OwnSegmentedControl : UIView
{
    NSMutableArray *m_arSegments;
    UIButton*   m_pCurButton;
    UIView*     m_pLeftCorner;
    UIView*     m_pRightCorner;
    int         m_iSegButtonCount;
}


- (id)initWithFrame:(CGRect)frame items:(NSArray*)segItems;

- (id)initWithFrame:(CGRect)frame items:(NSArray*)segItems tintColor:(UIColor *)color;

@property (nonatomic,strong) id<OwnSegmentedControlDelegate> m_segDelegate;

@end




