//
//  DDAddBankCardPageInfo.h

//  我的叮叮-添加银行卡
//
//  Created on 2014-11-20.
//

#import <UIKit/UIKit.h>
#import "QDataSetObj.h"
#import "DownToUpPopupView.h"

@interface DDAddBankCardPageInfo : UIViewController <UITableViewDataSource ,UITableViewDelegate,DownToUpPopupViewDelegate>
{
    
    QDataSetObj*    m_pBankInfoDataSet;
    UITapGestureRecognizer* m_pTapGesture;
    UITextField*    m_uiCardIdField;

    NSString*   m_strSelectedBankId;
    //NSString*   m_strInputBankCardId;
    DownToUpPopupView*  m_pDownUpPopupView;
    
    NSString*   m_strOraInputCardId;

}

@property (strong, nonatomic) IBOutlet UITableView  *m_uiMainTableView;



@end
