//
//  Car_LoanProjectInfoView.h

//  汽车贷款-产品详情-项目描述

//  Created by lzq on 2014-11-16.

//

#import <UIKit/UIKit.h>
#import "QDataSetObj.h"


@interface Car_LoanProjectInfoView : UIViewController<UITableViewDataSource,UITableViewDelegate>
{

    //融资金额
    NSString*   m_strTotalMoney;
    //借款人地址
    NSString*   m_strLinkAddrInfo;
    //资金用途
    NSString*   m_strMoneyUseType;
    //项目描述
    NSString*   m_strProjectMemo;

    //总的图片数量
    int         m_iImageCount;
    
    NSMutableDictionary*    m_muImageDcit;
}

@property (strong, nonatomic) IBOutlet UITableView *m_uiMainTableView;

@property (strong, nonatomic) NSString* m_strProductId;
@end
