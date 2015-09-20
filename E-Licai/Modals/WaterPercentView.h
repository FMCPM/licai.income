
//
//  WaterPercentView.h
//
//  水杯显示百分比的自定义视图

//  Created by lzq on 2014-11-26.

//


@interface WaterPercentView : UIView
{
    
    UIImageView*    m_uiPcertImgView;
    UILabel*        m_uiPcertLabel;
}

- (id)initWithFrame:(CGRect)frame andPcert:(NSInteger)iPcert;

-(void)setPcertValue:(float)fPcert;

-(void)setPcertValue:(float)fPcert andFontSize:(NSInteger)iFontSize andType:(NSInteger)iSellType andStatus:(NSInteger)iStatus;

-(void)addBackgroundButton:(UIButton*)pButton;

@end


