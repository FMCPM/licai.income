//
//  DDBillLeftMoneyPageView.h

//  我的叮叮-账户余额
//
//  Created on 2014-11-20.
//

#import <UIKit/UIKit.h>
#import "QDataSetObj.h"
#import "CustomViews.h"
#import "CKHttpHelper.h"
#import "CKHttpImageHelper.h"
#import "OwnSegmentedControl.h"


@interface DDBillLeftMoneyPageView : UIViewController <UITableViewDataSource ,UITableViewDelegate,OwnSegmentedControlDelegate>
{
    
   // QDataSetObj*    m_pInfoDataSet1;

    //1_余额;2_收入明细;3_支出明细
    int         m_iInfoType;
    //
    bool        m_isLoading;
    //数据源
    QDataSetObj*    m_pInfoDataSet;
}

@property (strong, nonatomic) IBOutlet UITableView  *m_uiMainTableView;
@property (strong, nonatomic) IBOutlet UIView  *m_uiTopBarView;


@end
