//
//  CarLoanInfoTableCell.h
//
//  产品列表 - 车贷产品列表的TableCell
//
//  Created by lzq on 2014-11-22.
//


#import <UIKit/UIKit.h>
#import "WaterPercentView.h"


@interface CarLoanInfoTableCell : UITableViewCell
{

    WaterPercentView* m_pWaterView;
}

@property (nonatomic,strong) IBOutlet UIImageView    *m_uiBackView;
@property (nonatomic,strong) IBOutlet UILabel    *m_uiCarLoanIdLabel;
@property (nonatomic,strong) IBOutlet UILabel    *m_uiPcertInLabel;
@property (nonatomic,strong) IBOutlet UILabel    *m_uiLoanLongLabel;
@property (nonatomic,strong) IBOutlet UILabel    *m_uiLoanStartLabel;
@property (nonatomic,strong) IBOutlet UILabel    *m_uiNewOrHottLabel;
@property (nonatomic,strong) IBOutlet UIImageView*m_uiPointImgView;
@property (nonatomic,strong) IBOutlet UILabel    *m_uiCellTitleLabel;
@property (nonatomic,strong) IBOutlet UIView    *m_uiCellView;

-(void)initCellDefaultShow;
-(void)setProductPcertValue:(float)fValue andType:(NSInteger)iSellType andStatus:(NSInteger)iStatus;
-(void)setNewOrHotShow:(int)iProductTag;
-(void)setCellTitle:(NSString*)strCellTitle;
@end
