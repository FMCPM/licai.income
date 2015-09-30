//
//  CarLoanInfoTableCell.m
//
//  产品列表 - 车贷产品列表的TableCell
//
//  Created by lzq on 2014-11-22.
//


#import "CarLoanInfoTableCell.h"
#import "GlobalDefine.h"


@implementation CarLoanInfoTableCell

@synthesize m_uiBackView = _uiBackView;
@synthesize m_uiCarLoanIdLabel = _uiCarLoanIdLabel;
@synthesize m_uiLoanLongLabel = _uiLoanLongLabel;
@synthesize m_uiLoanStartLabel = _uiLoanStartLabel;
@synthesize m_uiPcertInLabel = _uiPcertInLabel;
@synthesize m_uiNewOrHottLabel = _uiNewOrHottLabel;
@synthesize m_uiPointImgView = _uiPointImgView;
@synthesize m_uiCellTitleLabel = _uiCellTitleLabel;
@synthesize m_uiCellView = _uiCellView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}


-(void)initCellDefaultShow
{

    //产品的名称
    UILabel* pLabel = (UILabel*)[self.contentView viewWithTag:1001];
    if(pLabel)
    {
        pLabel.textColor = COLOR_FONT_1;
    }
    //年化收益的提示
    pLabel = (UILabel*)[self.contentView viewWithTag:1002];
    if(pLabel)
    {
        pLabel.textColor = COLOR_FONT_1;
    }
  
    //融资期限的提示
    pLabel = (UILabel*)[self.contentView viewWithTag:1003];
    if(pLabel)
    {
        pLabel.textColor = COLOR_FONT_1;
    }
    
    //融资金额的提示
    pLabel = (UILabel*)[self.contentView viewWithTag:1004];
    if(pLabel)
    {
        pLabel.textColor = COLOR_FONT_1;
    }
    //年化收益的内容
    pLabel = (UILabel*)[self.contentView viewWithTag:1005];
    if(pLabel)
    {
        pLabel.textColor = COLOR_FONT_5;
    }
    
    //融资期限的内容
    pLabel = (UILabel*)[self.contentView viewWithTag:1006];
    if(pLabel)
    {
        pLabel.textColor = COLOR_FONT_1;
    }
    
    //融资金额的内容
    pLabel = (UILabel*)[self.contentView viewWithTag:1007];
    if(pLabel)
    {
        pLabel.textColor = COLOR_FONT_1;
    }
    
    //
    pLabel = (UILabel*)[self.contentView viewWithTag:1008];
    if(pLabel)
    {
        pLabel.textColor = COLOR_FONT_2;
    }
    pLabel = (UILabel*)[self.contentView viewWithTag:1009];
    if(pLabel)
    {
        pLabel.textColor = COLOR_FONT_2;
    }
    pLabel = (UILabel*)[self.contentView viewWithTag:1010];
    if(pLabel)
    {
        pLabel.textColor = COLOR_FONT_2;
    }
    _uiCellTitleLabel.textColor = COLOR_FONT_1;
    _uiCellTitleLabel.font = [UIFont systemFontOfSize:12];
    _uiCellTitleLabel.backgroundColor = COLOR_VIEW_BK_01;
    
    _uiBackView.layer.borderColor = COLOR_CELL_LINE_DEFAULT.CGColor;
    _uiBackView.layer.borderWidth = 1.0f;
    _uiBackView.layer.cornerRadius = 5.0f;
    
    
    
    m_pWaterView = [[WaterPercentView alloc] initWithFrame:CGRectMake(235, 15, 50, 60) andPcert:45];
    [_uiCellView addSubview:m_pWaterView];
    
    UIImageView* pLineView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 66, 220, 0.5)];
    pLineView.backgroundColor = COLOR_CELL_LINE_DEFAULT;
    [_uiCellView addSubview:pLineView];
    
}

-(void)setProductPcertValue:(float)fValue  andType:(NSInteger)iSellType andStatus:(NSInteger)iStatus
{
    int iFontSize = 12;
    if(iSellType == 1)
    {
       // [_uiNewOrHottLabel setHidden:NO];
       // [_uiPointImgView setHidden:NO];
    }
    else
    {
        [_uiNewOrHottLabel setHidden:YES];
        [_uiPointImgView setHidden:YES];
        iFontSize = 11;
    }
    [m_pWaterView setPcertValue:fValue andFontSize:iFontSize andType:iSellType andStatus:iStatus];
}

-(void)setNewOrHotShow:(int)iProductTag
{

    if(iProductTag == 1)
    {
        _uiNewOrHottLabel.text = @"新";
        [_uiPointImgView setHidden:NO];
    }
    else if(iProductTag == 2)
    {
        _uiNewOrHottLabel.text = @"热";
        [_uiPointImgView setHidden:NO];
    }
    else
    {
        _uiNewOrHottLabel.text = @"";
        [_uiPointImgView setHidden:YES];
    }
}

-(void)setCellTitle:(NSString*)strCellTitle
{
    CGRect rcContentView = self.contentView.frame;
    CGRect rcCellView = _uiCellView.frame;
    if(strCellTitle.length < 1)
    {
        [_uiCellTitleLabel setHidden:YES];
        rcContentView.size.height = 100;
        self.contentView.frame = rcContentView;
        
        rcCellView.origin.y = 10;
        _uiCellView.frame = rcCellView;
    }
    else
    {
        _uiCellTitleLabel.text = strCellTitle;
        [_uiCellTitleLabel setHidden:NO];
        rcContentView.size.height = 120;
        self.contentView.frame = rcContentView;
        
        rcCellView.origin.y = 30;
        _uiCellView.frame = rcCellView;
    }
}

@end
