//
//  MyDdCenterMidTableCell.h
//  我的叮叮-中间部分的三个按钮对应的Cell
//
//  Created by lzq on 2014-11-22.
//
//

#import <UIKit/UIKit.h>

@protocol MyDdCenterMidTableCellDelegate <NSObject>
@optional

-(void)actionDDCenterButtonClicked:(NSInteger)iButtonIndex;
@end


@interface MyDdCenterMidTableCell : UITableViewCell
{
    UILabel*    m_uiTotalMoneyLabel;
    UILabel*    m_uiHoldMoneyLabel;
    UILabel*    m_uiLeftMoneyLabel;
    
}

@property (nonatomic,strong) IBOutlet UIButton    *m_uiDdButton1;
@property (nonatomic,strong) IBOutlet UIButton    *m_uiDdButton2;
@property (nonatomic,strong) IBOutlet UIButton    *m_uiDdButton3;

@property (nonatomic,strong)id <MyDdCenterMidTableCellDelegate> m_pCellDelegate;

-(IBAction)actionButtonClicked:(id)sender;

-(void)initCellDefaultSet;

//
-(void)showMidCellInfo:(NSString*)strTotalMoney andHoldMoney:(NSString*)strHoldMoney andLeftMoney:(NSString*)strLeftMoney;
@end
