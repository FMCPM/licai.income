//
//  LoanTenderInfoListView.h

//  汽车贷款-产品详情-投标情况

//  Created by lzq on 2014-06-03.

//

#import <UIKit/UIKit.h>
#import "QDataSetObj.h"


@interface Car_LoanTenderInfoListView : UIViewController<UITableViewDataSource,UITableViewDelegate>
{

    //推荐商品的数据集
    QDataSetObj*    m_pIntroInfoDataSet;
    
    BOOL            m_isLoading;


    
}

@property (strong, nonatomic) IBOutlet UITableView *m_uiMainTableView;

@property (strong, nonatomic) NSString* m_strProductId;

@end
