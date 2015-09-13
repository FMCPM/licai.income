//
//  DDTradeLogPageView.h

//  我的叮叮 - 交易记录
//
//  Created on 2014-11-23.
//

#import <UIKit/UIKit.h>
#import "QDataSetObj.h"
#import "CustomViews.h"
#import "CKHttpHelper.h"
#import "CKHttpImageHelper.h"


@interface DDTradeLogPageView : UIViewController <UITableViewDataSource ,UITableViewDelegate>
{
    
    QDataSetObj*    m_pInfoDataSet;

    NSMutableDictionary   *m_muImageListDic;
    
}

@property (strong, nonatomic) IBOutlet UITableView  *m_uiMainTableView;



@end
