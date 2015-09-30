//
//  DDBankCardInfoPageView.h

//  我的叮叮-账号中心-银行卡管理
//
//  Created on 2014-11-23.
//

#import <UIKit/UIKit.h>
#import "QDataSetObj.h"


@interface DDBankCardInfoPageView : UIViewController <UITableViewDataSource ,UITableViewDelegate>
{
    
    QDataSetObj*    m_pInfoDataSet;
}

@property (strong, nonatomic) IBOutlet UITableView  *m_uiMainTableView;



@end
