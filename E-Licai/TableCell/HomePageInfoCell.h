//
//  CommonInfoTableCell.h
//  YTSearch
//
//  Created by lzq on 12-12-18.
//
//

#import <UIKit/UIKit.h>
#import "WaterPercentView.h"

@interface HomePageInfoCell : UITableViewCell
{
    WaterPercentView*   m_uiWaterView;
    
    //页面刷新的定时器
    NSTimer *           m_waterTimer;
    
    float               m_fTotalPcert;
    
    int                 m_iCurPicFrameId;
}

@property (nonatomic,strong) IBOutlet UILabel    *m_uiTitleLabel;
@property (nonatomic,strong) IBOutlet UILabel    *m_uiNewOldLabel;
@property (nonatomic,strong) IBOutlet UILabel    *m_uiMidLabel_1;
@property (nonatomic,strong) IBOutlet UILabel    *m_uiMidLabel_11;

@property (nonatomic,strong) IBOutlet UILabel    *m_uiMidLabel_2;
@property (nonatomic,strong) IBOutlet UILabel    *m_uiMidLabel_21;

@property (nonatomic,strong) IBOutlet UILabel    *m_uiMidLabel_3;
@property (nonatomic,strong) IBOutlet UILabel    *m_uiMidLabel_31;

@property (nonatomic,strong) IBOutlet UILabel    *m_uiExtLabel;

@property (nonatomic,strong) IBOutlet UIImageView    *m_uiPointImgView;

-(void)initCellDefaultShow;

-(void)setCellPcertValue:(float)fPcertValue;
@end
