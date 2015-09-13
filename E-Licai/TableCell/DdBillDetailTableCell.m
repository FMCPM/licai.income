//
//  DdBillDetailTableCell.m

//
//  Created by lzq on 2014-11-18.
//
//

#import "DdBillDetailTableCell.h"
#import "GlobalDefine.h"

@implementation DdBillDetailTableCell

@synthesize m_uiAddInfoLabel = _uiAddInfoLabel;
@synthesize m_uiFondInComeLabel = _uiFondInComeLabel;
@synthesize m_uiLeftMoneyHintLabel = _uiLeftMoneyHintLabel;
@synthesize m_uiLeftMoneyValueLabel = _uiLeftMoneyValueLabel;
@synthesize m_uiProductNameLabel = _uiProductNameLabel;
@synthesize m_uiTimeLabel = _uiTimeLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}


//
-(void)initCellDefaultShow
{
    _uiFondInComeLabel.font = [UIFont systemFontOfSize:14];
    _uiFondInComeLabel.textColor = COLOR_FONT_1;
    _uiProductNameLabel.textColor = COLOR_FONT_2;
    _uiTimeLabel.textColor = COLOR_FONT_2;
    _uiLeftMoneyHintLabel.textColor = COLOR_FONT_1;
    _uiLeftMoneyValueLabel.textColor = COLOR_FONT_1;
    _uiAddInfoLabel.textColor = COLOR_FONT_5;

    
}

@end
