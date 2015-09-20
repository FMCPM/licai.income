//
//  ProductListViewController.h
//
//  叮叮理财 - 产品列表
//
//  Created by lzq on 2014-12-27.
//

#import <UIKit/UIKit.h>
#import "QDataSetObj.h"
#import "CustomViews.h"
#import "CKHttpHelper.h"
#import "CKHttpImageHelper.h"
#import "OwnSegmentedControl.h"
#import "MiddleShowPopupView.h"

@interface ProductListViewController : UIViewController <UITableViewDataSource ,UITableViewDelegate,EGORefreshTableHeaderDelegate,OwnSegmentedControlDelegate,MiddleShowPopupViewDelegate>
{
    QDataSetObj*    m_pCellInfoDataSet;
    
    //正在销售的产品列表
    QDataSetObj*    m_pCurSellDataSet;
    //即将销售的产品列表
    QDataSetObj*    m_pReadySellDataSet;
    //销售完成的产品列表
    QDataSetObj*    m_pEndSellDataSet;
    //转让列表
    QDataSetObj*    m_pTransSellDataSet;
    
    UIButton*       m_uiNavTitleButton;
    
    EGORefreshTableHeaderView* m_refreshHeaderView;
    BOOL        m_isLoading;
    BOOL        m_isToEndPage;
    int         m_iInfoType;
    int         m_iCurPageID;
    
    //取消订单的弹出视图
    MiddleShowPopupView *m_pMiddleShowView;

}

@property (strong, nonatomic) IBOutlet UITableView  *m_uiMainTableView;
@property (strong, nonatomic) IBOutlet UIView  *m_uiTopBarView;


@end
