//
//  LoanDetailTableCell.m
//  YTSearch
//
//  Created by lzq on 12-12-18.
//
//

#import "LoanDetailTableCell.h"
#import "GlobalDefine.h"

@implementation LoanDetailTableCell

@synthesize m_uiLongTimeLabel = _uiLongTimeLabel;
@synthesize m_uiTotalMoneyLabel = _uiTotalMoneyLabel;
@synthesize m_uiYearPcertLabel = _uiYearPcertLabel;


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
    
    //融资金额的提示
    UILabel* pLabel = (UILabel*)[self.contentView viewWithTag:1001];
    if(pLabel)
    {
        pLabel.textColor = COLOR_FONT_2;
    }
    //融资金额的值
    pLabel = (UILabel*)[self.contentView viewWithTag:1002];
    if(pLabel)
    {
        pLabel.textColor = COLOR_FONT_1;
    }
    
    //年化收益的提示
    pLabel = (UILabel*)[self.contentView viewWithTag:1003];
    if(pLabel)
    {
        pLabel.textColor = COLOR_FONT_2;
    }
    
    //融资金额的提示
    pLabel = (UILabel*)[self.contentView viewWithTag:1004];
    if(pLabel)
    {
        pLabel.textColor = COLOR_FONT_2;
    }
    //年化收益的内容
    pLabel = (UILabel*)[self.contentView viewWithTag:1005];
    if(pLabel)
    {
        pLabel.textColor = COLOR_FONT_5;
    }
    
    //融资期限
    pLabel = (UILabel*)[self.contentView viewWithTag:1006];
    if(pLabel)
    {
        pLabel.textColor = COLOR_FONT_1;
    }
    
    //
    pLabel = (UILabel*)[self.contentView viewWithTag:1007];
    if(pLabel)
    {
        pLabel.textColor = COLOR_FONT_2;
    }
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
       
    m_pWaterView = [[WaterPercentView alloc] initWithFrame:CGRectMake(130, 58, 72, 72) andPcert:45];
    [self.contentView addSubview:m_pWaterView];
    
    UIImageView* pLineView = [[UIImageView alloc] initWithFrame:CGRectMake(160, 135, 0.5, 50)];
    pLineView.backgroundColor = COLOR_CELL_LINE_DEFAULT;
    [self.contentView addSubview:pLineView];
    
}

-(void)setProductPcertValue:(float)fValue
{
    [m_pWaterView setPcertValue:fValue andFontSize:12 andType:1 andStatus:0];
}


@end
