//
//  DDBillCenterInfoPageView.h
//  我的叮叮 - 账户中心
//
//  Created  on 2014-11-24.

//

#import <UIKit/UIKit.h>
#import "CustomViews.h"
#import "QDataSetObj.h"


@interface DDBillCenterInfoPageView : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
	//UIWebView  *_callWebView;
    
    QDataSetObj* m_pInfoDataSet;
}

@property (strong, nonatomic) IBOutlet UITableView *m_uiMainTableView;

@end
