//
//  GoodsBatchEditPageView.h

//  汽车贷款-产品详情页面
//  Created by lzq on 2014-03-04.
//

#import <UIKit/UIKit.h>
#import "QDataSetObj.h"
#import "CustomViews.h"

@interface Car_LoanDetailInfoPageView : UIViewController <UITableViewDataSource ,UITableViewDelegate>
{

    QDataSetObj     *m_pInfoDataSet;
    //是否启动了投标
    BOOL            m_isStartingTender;
    //
    QDataSetObj*    m_pAdImageDataSet;
    NSMutableDictionary* m_muImageDict;
    
    //投标按钮
    UIButton*       m_uiTenderButton;
}

@property (strong, nonatomic) IBOutlet UITableView  *m_uiMainTableView;
@property (strong, nonatomic) IBOutlet UIView  *m_uiBottomBarView;

//贷款类型;1_汽车贷;2_信用贷;3_企业贷
@property (assign, nonatomic) NSInteger     m_iLoanType;
@property (strong, nonatomic) NSString*     m_strProductName;
@property (strong, nonatomic) NSString*     m_strProductId;
@property (strong, nonatomic) NSString*     m_strMinTenderMoney;

@end
