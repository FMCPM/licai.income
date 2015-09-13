//
//  WaterPercentView.m
//
//  水杯显示百分比的自定义视图

//  Created by lzq on 2014-11-26.

//

#import "WaterPercentView.h"
#import "GlobalDefine.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+Hex.h"

@implementation WaterPercentView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame andPcert:(NSInteger)iPcert;
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor  = [UIColor whiteColor];

        if(iPcert < 0)
            iPcert = 0;
        if(iPcert > 100)
            iPcert  =100;
        m_uiPcertImgView = [[ UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
       // m_uiPcertImgView.image = [UIImage imageNamed:[self getPcertImgName:iPcert]];
        [self addSubview:m_uiPcertImgView];
        
        int iTopY = (frame.size.height - 30) / 2;
        //int iTopX = (frame.size.width - 20) / 2;
        
        m_uiPcertLabel = [[UILabel alloc] initWithFrame:CGRectMake(2, iTopY, frame.size.width-4, 30)];
        
        m_uiPcertLabel.textColor = [UIColor colorWithRed:0.79 green:0.62 blue:0.2 alpha:1];
        m_uiPcertLabel.backgroundColor = [UIColor clearColor];
        m_uiPcertLabel.font = [UIFont systemFontOfSize:26];
        m_uiPcertLabel.textAlignment = UITextAlignmentCenter;
        m_uiPcertLabel.numberOfLines = 0;
        [self addSubview:m_uiPcertLabel];
        
        [self setPcertValue:iPcert];
    }
    return self;
}

//根据这个比例，获取对应的比例图片
-(NSString*)getPcertImgName:(float)fPcert
{
    
    int iLeft = fPcert/10;
    if(iLeft >= 10)
        return @"water_100.png";
    if(fPcert < 0.001)
        return @"water_00.png";
    if(fPcert < 5)
        return @"water_05.png";

    NSString* strImgName = @"water_00.png";
    int iRight = (int)fPcert % 10;
    if(iRight < 5)
    {
        strImgName = [NSString stringWithFormat:@"water_%d0",iLeft];
    }
    else
    {
        strImgName = [NSString stringWithFormat:@"water_%d5",iLeft];
    }

    return  strImgName;
}

-(void)setPcertValue:(float)fPcert
{
    if(fPcert < 0)
        fPcert = 0;
    if(fPcert > 100)
        fPcert = 100;
    m_uiPcertLabel.text = [NSString stringWithFormat:@"%d%%",(NSInteger)fPcert];
    m_uiPcertImgView.image = [UIImage imageNamed:[self getPcertImgName:fPcert]];
}

-(void)setPcertValue:(float)fPcert andFontSize:(NSInteger)iFontSize andType:(NSInteger)iSellType andStatus:(NSInteger)iStatus
{
    m_uiPcertLabel.font = [UIFont systemFontOfSize:iFontSize];
    if(iSellType == 1)//在售产品
    {
        m_uiPcertLabel.textColor = [UIColor colorWithHex:0xf0f0f0];
        [self setPcertValue:fPcert];
    }
    else if(iSellType == 2) //即将开始
    {
        m_uiPcertLabel.textColor = COLOR_FONT_2;
        m_uiPcertImgView.image = [UIImage imageNamed:@"water_gray.png"];
        m_uiPcertLabel.text = @"即将开始";
    }
    else //已经完成
    {
        m_uiPcertLabel.textColor = COLOR_FONT_2;
        m_uiPcertImgView.image = [UIImage imageNamed:@"water_gray.png"];
        
        if(iStatus == 3)
        {
            m_uiPcertLabel.text = @"已售完\r\n还款中";
        }
        else
        {
            m_uiPcertLabel.text = @"已还款";
        }
    }
}

-(void)addBackgroundButton:(UIButton*)pButton
{
    [m_uiPcertImgView removeFromSuperview];
    [m_uiPcertLabel removeFromSuperview];
    [pButton addSubview:m_uiPcertImgView];
    [pButton addSubview:m_uiPcertLabel];
    [self addSubview:pButton];
    //[self bringSubviewToFront:m_uiPcertImgView];
    //[self bringSubviewToFront:m_uiPcertLabel];
}



@end
