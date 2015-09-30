//
//  MyHoldAssetsPageView.h
//  我的叮叮-持有资产
//
//  Created by lzq on 2014-11-18
//
//

#import <UIKit/UIKit.h>
#import "CustomViews.h"
#import "CKHttpHelper.h"
#import "QDataSetObj.h"

@interface MyHoldAssetsPageView : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    QDataSetObj*    m_pInfoDataSet;
    
    NSString*       m_strTotalMoney;
    NSString*       m_strWaitInMoney;
    NSString*       m_strWaitJsMoney;
}

@property(nonatomic,strong)IBOutlet UITableView* m_uiMainTableView;


@end
