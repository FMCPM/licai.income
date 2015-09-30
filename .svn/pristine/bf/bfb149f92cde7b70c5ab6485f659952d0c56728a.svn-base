//
//  CommonInfoTableCell.m
//  YTSearch
//
//  Created by lzq on 12-12-18.
//
//

#import "HomePageInfoCell.h"
#import "GlobalDefine.h"

@implementation HomePageInfoCell

@synthesize m_uiExtLabel = _uiExtLabel;
@synthesize m_uiMidLabel_1 = _uiMidLabel_1;
@synthesize m_uiMidLabel_11 = _uiMidLabel_11;
@synthesize m_uiMidLabel_2 = _uiMidLabel_2;
@synthesize m_uiMidLabel_21 = _uiMidLabel_21;
@synthesize m_uiMidLabel_3 = _uiMidLabel_3;
@synthesize m_uiMidLabel_31 = _uiMidLabel_31;

@synthesize m_uiNewOldLabel = _uiNewOldLabel;
@synthesize m_uiTitleLabel = _uiTitleLabel;
@synthesize m_uiPointImgView = _uiPointImgView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

//cell的初始化设置
-(void)initCellDefaultShow
{
    UIButton* pButton = [UIButton buttonWithType:UIButtonTypeCustom];
    pButton.frame = CGRectMake(0, 0, 110, 120) ;
    [pButton addTarget:self action:@selector(actionWaterClicked:) forControlEvents:UIControlEventTouchUpInside];
    //[self.contentView addSubview:pButton];
    
    m_uiWaterView = [[WaterPercentView alloc] initWithFrame:CGRectMake(105, 44, 110, 120) andPcert:0];
    
    [self.contentView addSubview:m_uiWaterView];
    
    [m_uiWaterView addBackgroundButton:pButton];
    
    
    _uiTitleLabel.textColor = COLOR_FONT_1;
    _uiMidLabel_1.textColor = COLOR_FONT_2;
    _uiMidLabel_11.textColor = COLOR_FONT_3;
    _uiMidLabel_2.textColor = COLOR_FONT_2;
    _uiMidLabel_21.textColor = COLOR_FONT_3;
    _uiMidLabel_3.textColor = COLOR_FONT_2;
    _uiMidLabel_31.textColor = COLOR_FONT_3;
    _uiExtLabel.textColor = COLOR_FONT_3;
}

//设置百分比
-(void)setCellPcertValue:(float)fPcertValue
{
    m_fTotalPcert = fPcertValue;
 
    if(m_uiWaterView == nil)
        return;
    //默认为1秒钟
    if(m_waterTimer != nil )
    {
        return;
    }
    
    NSTimeInterval  detctTime = 0.1;
    m_waterTimer = [NSTimer scheduledTimerWithTimeInterval:detctTime target:self selector:@selector(showWaterPictureTime:) userInfo:nil repeats:YES];
    m_iCurPicFrameId = 0;
    
    //[m_uiWaterView setPcertValue:fPcertValue];
    [m_uiWaterView setPcertValue:0.0f];
}


-(void)showWaterPictureTime:(id)sender
{
    m_iCurPicFrameId++;
    
    int iCurPcert = m_iCurPicFrameId*5;
    
    if(iCurPcert >= m_fTotalPcert)
    {
        [m_waterTimer invalidate];
        m_waterTimer = nil;
        
        [m_uiWaterView setPcertValue:m_fTotalPcert];
        m_iCurPicFrameId = 0;
    
        return;
    }
    
    [m_uiWaterView setPcertValue:m_iCurPicFrameId*5];
    
}

-(void)actionWaterClicked:(id)sender
{
    [self setCellPcertValue:m_fTotalPcert];
}

@end
