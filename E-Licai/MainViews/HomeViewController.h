//
//  HomeViewController.h
//
//  叮叮理财 - 首页
//
//  Copyright (c) 2014年  All rights reserved.
//

#import <UIKit/UIKit.h>

#import "QDataSetObj.h"
#import "CustomViews.h"
#import "ViewControllDismissDelegate.h"
#import "LoginViewController.h"
#import "QBImagePickerController.h"
#import "SYPaginatorView.h"
#import "CKHttpHelper.h"
#import "CKHttpImageHelper.h"
//#import "SwitchCityNavItem.h"
#import "LLPaySdk.h"

@interface HomeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,SYPaginatorViewDataSource,SYPaginatorViewDelegate,EGORefreshTableHeaderDelegate,LLPaySdkDelegate>
{

    //广告视图
    SYPaginatorView*    m_sysTopAdPageView;
    //记录所有图片对象的队列
    NSMutableDictionary* m_muMultImageDict;
    //下拉刷新的视图控件
    EGORefreshTableHeaderView *m_refreshHeaderView;
    //
    bool            m_isLoading;
   
    //几幅广告图
    QDataSetObj*    m_pAdPicDataSet;
    //首页的数据
    QDataSetObj*    m_homeInfoDataSet;
    
 //   LLPaySdk *m_llPaysdk;

}

@property (strong, nonatomic) IBOutlet UITableView *m_uiMainInfoTable;

@property (nonatomic, retain) LLPaySdk *sdk;


@end
