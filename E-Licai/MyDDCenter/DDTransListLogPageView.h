//
//  DDTradeLogPageView.h

//  我的叮叮 - 转让纪录
//
//  Created on 2014-11-23.
//

#import <UIKit/UIKit.h>
#import "QDataSetObj.h"
#import "CustomViews.h"
#import "CKHttpHelper.h"
#import "CKHttpImageHelper.h"


@interface DDTransListLogPageView : UIViewController <UITableViewDataSource ,UITableViewDelegate>
{
    
    QDataSetObj*    m_pInfoDataSet;

    NSMutableDictionary   *m_muImageListDic;
    
}

@property (strong, nonatomic) IBOutlet UITableView  *m_uiMainTableView;


@end
