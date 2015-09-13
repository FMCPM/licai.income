//
//  DDIntegralInfoPageView.h
//  我的叮叮 - 积分管理
//
//  Created by lzq on 2014-11-25
//
//

#import <UIKit/UIKit.h>
#import "QDataSetObj.h"
#import "RightNavItemView.h"

@interface DDIntegralInfoPageView : UIViewController<UITableViewDataSource,UITableViewDelegate,RightNavItemViewDelegate>
{
    QDataSetObj* m_pInfoDataSet;
    RightNavItemView*   m_pNavItemView;
}

@property(nonatomic,strong)IBOutlet UITableView* m_uiMainTableView;

@property(nonatomic,assign)NSInteger   m_iTotalIntegralValue;

@end
