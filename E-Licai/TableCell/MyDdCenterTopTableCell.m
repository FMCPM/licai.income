//
//  MyDdCenterTopTableCell.m
//  我的叮叮-顶部视图对应的Cell
//
//  Created by lzq on 2014-11-22.
//
//

#import "MyDdCenterTopTableCell.h"
#import "GlobalDefine.h"


@implementation MyDdCenterTopTableCell

@synthesize m_uiDayInComeHintLabel = _uiDayInComeHintLabel;
@synthesize m_uiDayInComeValueLabel = _uiDayInComeValueLabel;
@synthesize m_uiTotalInFalueLabel = _uiTotalInFalueLabel;
@synthesize m_uiTotalInHintLabel = _uiTotalInHintLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

//初始化设置
-(void)initCellDefaultSet
{

    self.contentView.backgroundColor = COLOR_FONT_7;
    
    UIView* pLineView = [self.contentView viewWithTag:1005];
    if(pLineView)
    {
        pLineView.backgroundColor = [UIColor colorWithRed:0.93 green:0.61 blue:0 alpha:1];
    }
}



@end
