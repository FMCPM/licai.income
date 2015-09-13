//
//  DdBillDetailTableCell.h

//
//  Created by lzq on 2014-11-18.
//
//

#import <UIKit/UIKit.h>


@interface DdBillDetailTableCell : UITableViewCell
{

}

@property (nonatomic,strong) IBOutlet UILabel    *m_uiFondInComeLabel;
@property (nonatomic,strong) IBOutlet UILabel    *m_uiProductNameLabel;
@property (nonatomic,strong) IBOutlet UILabel    *m_uiTimeLabel;
@property (nonatomic,strong) IBOutlet UILabel    *m_uiAddInfoLabel;
@property (nonatomic,strong) IBOutlet UILabel    *m_uiLeftMoneyHintLabel;
@property (nonatomic,strong) IBOutlet UILabel    *m_uiLeftMoneyValueLabel;

-(void)initCellDefaultShow;

@end
