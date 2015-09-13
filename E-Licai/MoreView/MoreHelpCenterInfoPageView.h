//
//  MoreActivityCenterPageView.h
//  更多 - 帮助中心
//
//  Created by lzq on 2014-11-26.

//

#import <UIKit/UIKit.h>
#import "QDataSetObj.h"


@interface MoreHelpCenterInfoPageView : UIViewController <UITableViewDataSource ,UITableViewDelegate>

{

    
    QDataSetObj     *m_pInfoDataSet;
    NSInteger       m_iCurPageID;
    bool            m_isToEndPage;
    bool            m_isLoading;


}

@property (strong, nonatomic) IBOutlet UITableView  *m_uiMainTableView;


@end
