//
//  MyHoldBackMoneyPlanView.h
//
//  我的叮叮 - 持有资产 - 回款计划
//
//  Created by lzq on 2015-01-05
//
//

#import <UIKit/UIKit.h>
#import "CustomViews.h"
#import "CKHttpHelper.h"
#import "QDataSetObj.h"

@interface MyHoldBackMoneyPlanView : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    QDataSetObj* m_pInfoDataSet;
}

@property(nonatomic,strong)IBOutlet UITableView* m_uiMainTableView;

@property(nonatomic,strong)IBOutlet UIView* m_uiTopBarView;
@property(nonatomic,strong)IBOutlet UILabel* m_uiStartTimeLabel;
@property(nonatomic,strong)IBOutlet UILabel* m_uiTotalInComeLabel;

@property(nonatomic,assign)NSString* m_strProductId;
@property(nonatomic,assign)NSString* m_strOrderRecId;
@end
