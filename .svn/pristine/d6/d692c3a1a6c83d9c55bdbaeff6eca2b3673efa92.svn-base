//
//  PDColoredProgressView.m
//  PDColoredProgressViewDemo
//
//  Created by Pascal Widdershoven on 03-01-09.
//  Copyright 2009 Pascal Widdershoven. All rights reserved.
//  

#import "OwnColoredProgressView.h"
#import "GlobalDefine.h"


@implementation OwnColoredProgressView

- (id)initWithFrame:(CGRect)frame andType:(NSInteger)iType
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
        //Background Color
        self.backgroundColor = [UIColor whiteColor];
        
        //左边的角
        m_pLeftCornerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, frame.size.height)];
        
        m_pLeftCornerView.backgroundColor = COLOR_CELL_LINE_DEFAULT;
        m_pLeftCornerView.layer.cornerRadius= 5.0f;
        m_pLeftCornerView.layer.borderColor = COLOR_CELL_LINE_DEFAULT.CGColor;
        m_pLeftCornerView.layer.borderWidth = 1.0;
        [self addSubview:m_pLeftCornerView];
        
        //右边的角
        m_pRightCornerView = [[UIView alloc] initWithFrame:CGRectMake(frame.size.width-20, 0, 20, frame.size.height)];
        m_pRightCornerView.backgroundColor = COLOR_CELL_LINE_DEFAULT;
        m_pRightCornerView.layer.cornerRadius= 5.0f;
        m_pRightCornerView.layer.borderColor = COLOR_CELL_LINE_DEFAULT.CGColor;
        m_pRightCornerView.layer.borderWidth = 1.0f;
        [self addSubview:m_pRightCornerView];
        
        //进度的背景
        m_pProgressBkView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, frame.size.width-20, frame.size.height)];
        [self addSubview:m_pProgressBkView];
        m_pProgressBkView.backgroundColor = COLOR_CELL_LINE_DEFAULT;
        
        //进度提示
        m_pProgressStepView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 10, frame.size.height)];
        m_pProgressStepView.backgroundColor = COLOR_CELL_LINE_DEFAULT;
        [self addSubview:m_pProgressStepView];

    }
    return self;
  
}

//设置进度
-(void)setProgress:(float)fProgress
{
    float fWidth = self.frame.size.width*fProgress;
    if(fWidth < 10)
    {
        m_pLeftCornerView.backgroundColor = COLOR_FONT_3;
        m_pProgressStepView.backgroundColor = COLOR_CELL_LINE_DEFAULT;
        m_pProgressStepView.frame = CGRectMake(10, 0, 100, self.frame.size.height);
        m_pRightCornerView.backgroundColor = COLOR_CELL_LINE_DEFAULT;
        m_pRightCornerView.layer.borderColor = COLOR_CELL_LINE_DEFAULT.CGColor;
        return;
    }
    if(fWidth <= self.frame.size.width-10)
    {
        m_pLeftCornerView.backgroundColor = COLOR_FONT_3;
        m_pLeftCornerView.layer.borderColor = COLOR_FONT_3.CGColor;

        m_pRightCornerView.backgroundColor = COLOR_CELL_LINE_DEFAULT;
        m_pRightCornerView.layer.borderColor = COLOR_CELL_LINE_DEFAULT.CGColor;
        m_pProgressStepView.backgroundColor = COLOR_FONT_3;
        m_pProgressStepView.frame = CGRectMake(10, 0, fWidth, self.frame.size.height);
        return;
    }
    if(fWidth >= self.frame.size.width*fProgress)
    {
        m_pLeftCornerView.backgroundColor = COLOR_FONT_3;
        m_pLeftCornerView.layer.borderColor = COLOR_FONT_3.CGColor;
        
        m_pProgressStepView.backgroundColor = COLOR_FONT_3;
        m_pProgressStepView.frame = CGRectMake(10, 0, fWidth-20, self.frame.size.height);
        
        m_pRightCornerView.backgroundColor = COLOR_FONT_3;
        m_pRightCornerView.layer.borderColor = COLOR_FONT_3.CGColor;
    }

}

@end
