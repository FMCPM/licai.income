//
//  RatingViewController.m
//  RatingController
//
//  Created by Ajay on 2/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "RatingView.h"

@implementation RatingView

@synthesize m_uiImageView1, m_uiImageView2, m_uiImageView3, m_uiImageView4, m_uiImageView5;
@synthesize m_iMarkValue;


//创建视图
-(void)createRatingViews:(bool)blUpdate andHeight:(NSInteger)iHeight andSpan:(NSInteger)iSpan
{
    if(m_blHaveCreateView == true)
        return ;   
    m_blCanUpdate  = blUpdate;
    m_uiImageView1 = [[UIImageView alloc] init];
    m_uiImageView2 = [[UIImageView alloc] init];
    m_uiImageView3 = [[UIImageView alloc] init];
    m_uiImageView4 = [[UIImageView alloc] init];
    m_uiImageView5 = [[UIImageView alloc] init];
        
  //  m_unselectedImage     = [UIImage imageNamed:@"star0"];
  //  m_partlySelectedImage = [UIImage imageNamed:@"star1"];
  //  m_fullySelectedImage  = [UIImage imageNamed:@"star2"];
    
    m_unselectedImage     = [UIImage imageNamed:@"ico_star_big_unselect.png"];
    m_partlySelectedImage = [UIImage imageNamed:@"ico_star_big_select.png"];
    m_fullySelectedImage  = [UIImage imageNamed:@"ico_star_big_select.png"];
  
    
    if(iHeight < 16)
    {
        iHeight = 16;
    }
    m_fStarImgHeight = iHeight;
    m_fStarImgWidth  = iHeight;
    
    if(iSpan < 5)
        iSpan = 5;
    m_iSpanValue = iSpan;
    //显示
	[m_uiImageView1 setFrame:CGRectMake(0,         0, m_fStarImgWidth, m_fStarImgHeight)];
	[m_uiImageView2 setFrame:CGRectMake(m_fStarImgWidth+iSpan,     0, m_fStarImgWidth, m_fStarImgHeight)];
	[m_uiImageView3 setFrame:CGRectMake(2 * (m_fStarImgWidth+iSpan), 0, m_fStarImgWidth, m_fStarImgHeight)];
	[m_uiImageView4 setFrame:CGRectMake(3 * (m_fStarImgWidth+iSpan), 0, m_fStarImgWidth, m_fStarImgHeight)];
	[m_uiImageView5 setFrame:CGRectMake(4 * (m_fStarImgWidth+iSpan), 0, m_fStarImgWidth, m_fStarImgHeight)];
	
	[m_uiImageView1 setUserInteractionEnabled:NO];
	[m_uiImageView2 setUserInteractionEnabled:NO];
	[m_uiImageView3 setUserInteractionEnabled:NO];
	[m_uiImageView4 setUserInteractionEnabled:NO];
	[m_uiImageView5 setUserInteractionEnabled:NO];
	
	[self addSubview:m_uiImageView1];
	[self addSubview:m_uiImageView2];
	[self addSubview:m_uiImageView3];
	[self addSubview:m_uiImageView4];
	[self addSubview:m_uiImageView5];
	
    if(m_arImageViewList == NULL)
    {
        m_arImageViewList = [[NSArray alloc] initWithObjects:m_uiImageView1,m_uiImageView2,m_uiImageView3,m_uiImageView4,m_uiImageView5, nil];
    }   
    m_blHaveCreateView = true;
    //设置自己视图的大小
	CGRect frame = [self frame];
	frame.size.width = (m_fStarImgWidth+m_iSpanValue) * 6;
	frame.size.height = m_fStarImgHeight;
	[self setFrame:frame];


}

-(void) touchesBegan: (NSSet *)touches withEvent: (UIEvent *)event
{
	[self touchesMoved:touches withEvent:event];
}

//鼠标移动后，判断鼠标点的距离，从而设置星星的样式
-(void) touchesMoved: (NSSet *)touches withEvent: (UIEvent *)event
{
    if(m_blCanUpdate == false)
        return ;
	CGPoint pt = [[touches anyObject] locationInView:self];
    float fNewValue = 1;
    if(pt.x > (m_fStarImgWidth+m_iSpanValue)*4)
        fNewValue = 5;
    else if (pt.x > (m_fStarImgWidth+m_iSpanValue)*3)
        fNewValue = 4;
    else if (pt.x > (m_fStarImgWidth+m_iSpanValue)*2)
        fNewValue = 3;
    else if (pt.x > (m_fStarImgWidth+m_iSpanValue)*1)
        fNewValue = 2;
    else if(pt.x < m_fStarImgWidth/2)
        fNewValue = 0;
    
    //float fNewValue = (pt.x / (m_fStarImgWidth+m_iSpanValue));
    [self showRatingImageView:fNewValue];

}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	[self touchesMoved:touches withEvent:event];
}


/*------------------------------------------------------------------------
 Function    :showRatingImageView
 Description :显示综合评分信息
 Params      :
    fValue：评分值
 Result      :void
 Author      :lzq,lvzhuqiang@ytinfo.zj.cn
 DateTime    :2012-06-019
 ------------------------------------------------------------------------*/
-(void)showRatingImageView:(float)fValue
{
    if(m_blHaveCreateView == false)
        [self createRatingViews:NO andHeight:20 andSpan:15];
    
    m_fLastMarkValue = fValue;

    if (fValue < 0) {
        m_fLastMarkValue = 0;
    }
    else if (fValue >5.0) {
        m_fLastMarkValue = 5.0;
    }
    
    if ((m_fLastMarkValue-floor(m_fLastMarkValue))>0.25) {
        m_iMarkValue = ceil(m_fLastMarkValue);
    }
    else {
        m_iMarkValue = floor(m_fLastMarkValue);
    }

    for (int i=0; i<5; i++) {
        UIImageView* pImageView = (UIImageView*)[m_arImageViewList objectAtIndex:i];
        if(pImageView == NULL)
            continue;
        if (floor(m_fLastMarkValue)>i) {
            [pImageView setImage:m_fullySelectedImage];
        }
        else if (m_fLastMarkValue<i) {
            [pImageView setImage:m_unselectedImage];
        }
        else if ((m_fLastMarkValue-floor(m_fLastMarkValue))>0.75)
        {
            [pImageView setImage:m_fullySelectedImage];
        }
        else if ((m_fLastMarkValue-floor(m_fLastMarkValue))<0.25){
            [pImageView setImage:m_unselectedImage];
        }
        else {
            [pImageView setImage:m_partlySelectedImage];
        }
    }
    /*
    NSInteger iFullValue = (NSInteger)fValue;
    float fLeftValue = fValue - iFullValue;
    //表示是更改星星的显示
    if(m_blCanUpdate == true)
    {
        if(fLeftValue > 0.51)
        {
            iFullValue++;
            fLeftValue = 0;
            m_iMarkValue = iFullValue + 1;
        }
        else if(fLeftValue > 0.1) 
        {
            fLeftValue = 0.5;
            m_iMarkValue = iFullValue + 1;
        }
        else {
            m_iMarkValue = iFullValue;
            fLeftValue = 0;
        }
        m_fLastMarkValue = iFullValue+fLeftValue;
    }

    for(int i=0;i<5;i++)
    {
        UIImageView* pImageView = (UIImageView*)[m_arImageViewList objectAtIndex:i];
        if(pImageView == NULL)
            continue;
        //判断半颗星
        if(i == iFullValue)
        {
            if(fLeftValue >=0.2)
                [pImageView setImage:m_partlySelectedImage];
            else
                [pImageView setImage:m_unselectedImage];
        }
        else if(i <= iFullValue-1)
        {
            [pImageView setImage:m_fullySelectedImage];
        }
        else 
        {
            [pImageView setImage:m_unselectedImage];
        }
        
    }
     */
 }

@end
