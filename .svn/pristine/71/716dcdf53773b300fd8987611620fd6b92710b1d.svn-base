//
//  PPiFlatSwitch.m
//  PPiFlatSwitch
//
//  Created by Pedro Piñera Buendía on 12/08/13.
//  Copyright (c) 2013 PPinera. All rights reserved.
//

#import "OwnSegmentedControl.h"
#import "GlobalDefine.h"


#define segment_corner 10.0

@interface OwnSegmentedControl()

@end


@implementation OwnSegmentedControl
@synthesize m_segDelegate = _segDelegate;


- (id)initWithFrame:(CGRect)frame items:(NSArray*)segItems
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
        //Background Color
        self.backgroundColor=[UIColor whiteColor];
        if(segItems == nil)
            return self;
        
        m_iSegButtonCount = segItems.count;
        
        //计算button的宽度
        float buttonWith= frame.size.width/segItems.count;
        
        m_pLeftCorner = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, frame.size.height)];
        m_pLeftCorner.backgroundColor = [UIColor whiteColor];
        m_pLeftCorner.layer.cornerRadius= segment_corner;
        m_pLeftCorner.layer.borderColor = COLOR_FONT_3.CGColor;
        m_pLeftCorner.layer.borderWidth = 0.5f;
        [self addSubview:m_pLeftCorner];
        
        m_pRightCorner = [[UIView alloc] initWithFrame:CGRectMake(frame.size.width-20, 0, 20, frame.size.height)];
        m_pRightCorner.backgroundColor = [UIColor whiteColor];
        m_pRightCorner.layer.cornerRadius= segment_corner;
        m_pRightCorner.layer.borderColor = COLOR_FONT_3.CGColor;
        m_pRightCorner.layer.borderWidth = 0.5f;
        [self addSubview:m_pRightCorner];
        
        
        for(int i=0;i<segItems.count;i++)
        {
            NSString* strText = [segItems objectAtIndex:i];
            UIButton* pButton = [UIButton buttonWithType:UIButtonTypeCustom];
            pButton.tag = 200+i+1;
            
            if(i == 0)
            {
                pButton.frame = CGRectMake(buttonWith*i+10, 0, buttonWith-10, frame.size.height);
            }
            else if(i == (m_iSegButtonCount-1))
            {
                pButton.frame = CGRectMake(buttonWith*i, 0, buttonWith-10, frame.size.height);
              
            }
            else
            {
                pButton.frame = CGRectMake(buttonWith*i, 0, buttonWith, frame.size.height);

            }
            pButton.backgroundColor = [UIColor whiteColor];
            [pButton setTitle:strText forState:UIControlStateNormal];
            [pButton setTitleColor:COLOR_FONT_1 forState:UIControlStateNormal];
            [pButton addTarget:self action:@selector(segmentSelected:) forControlEvents:UIControlEventTouchUpInside];
            pButton.titleLabel.font = [UIFont systemFontOfSize:14];
            [self addSubview:pButton];
            
            //分割线暂时不画线
            /*
            if(i!=0)
            {
                UIView *separatorView=[[UIView alloc] initWithFrame:CGRectMake(i*buttonWith, 0, 1, frame.size.height)];
                separatorView.backgroundColor = COLOR_FONT_3;
                [self addSubview:separatorView];

            }
            */
            if(i == 0)
                m_pCurButton = pButton;
        }
        
        //Applying corners
        self.layer.masksToBounds= YES;
        self.layer.cornerRadius= segment_corner;
        self.layer.borderColor = COLOR_FONT_3.CGColor;
        self.layer.borderWidth = 0.5f;
        //
        [self setButtonShowType:m_pCurButton andSel:YES];
    }
    return self;
}

#pragma mark - Actions
-(void)segmentSelected:(id)sender
{
    UIButton* pButton = (UIButton*)sender;
    if(pButton == nil)
        return;
    if(m_pCurButton)
    {
        [self setButtonShowType:m_pCurButton andSel:NO];
    }
    m_pCurButton = pButton;
    [self setButtonShowType:pButton andSel:YES];
    if(_segDelegate == nil)
        return;

    if([_segDelegate respondsToSelector:@selector(didChangeSegmentedIndex:selectedIndex:)])
    {
        [_segDelegate didChangeSegmentedIndex:pButton selectedIndex:pButton.tag-201];
    }

}

//
-(void)setButtonShowType:(UIButton*)pButton andSel:(BOOL)blSelFlag
{

    if(pButton == nil)
        return;
    
    int iBtnIndex = pButton.tag - 200;
    if(iBtnIndex == 1)//第一个按钮
    {
        if(blSelFlag == YES)//选中
        {
            m_pLeftCorner.backgroundColor = COLOR_FONT_3;
            [pButton setBackgroundColor:COLOR_VIEW_BK_03];
            [pButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        else
        {
            m_pLeftCorner.backgroundColor = [UIColor whiteColor];
            pButton.backgroundColor = [UIColor whiteColor];
            [pButton setTitleColor:COLOR_FONT_1 forState:UIControlStateNormal];
          
        }
        return;
        
    }
    //最后一个按钮
    if(iBtnIndex == m_iSegButtonCount)
    {
        if(blSelFlag == YES)//选中
        {
            m_pRightCorner.backgroundColor = COLOR_FONT_3;
            [pButton setBackgroundColor:COLOR_FONT_3];
            [pButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        else
        {
            m_pRightCorner.backgroundColor = [UIColor whiteColor];
            [pButton setBackgroundColor:[UIColor whiteColor]];
            [pButton setTitleColor:COLOR_FONT_1 forState:UIControlStateNormal];
            
        }
        return;
    }
    
    if(blSelFlag == YES)
    {
        [pButton setBackgroundColor:COLOR_FONT_3];
        [pButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    }
    else
    {
        [pButton setBackgroundColor:[UIColor whiteColor]];
        [pButton setTitleColor:COLOR_FONT_1 forState:UIControlStateNormal];
        
    }
}

@end

