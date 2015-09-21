//
//  Car_LoanEnterInfoPageView.h

//  汽车贷款 - 产品详情 - 贷款企业详情页面

//  Created by lzq on 2014-12-16.

//

#import <UIKit/UIKit.h>
#import "QDataSetObj.h"


@interface Car_LoanEnterInfoPageView : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    QDataSetObj*    m_pInfoDataSet;
    NSMutableDictionary* m_muImageDict;
    
    NSInteger     m_iSafeImageCount;
    
}

@property (strong, nonatomic) IBOutlet UITableView *m_uiMainTableView;

@property (strong, nonatomic) NSString* m_strProductId;
@property (strong, nonatomic) NSString* m_strLoanEnterMemo;
@end
