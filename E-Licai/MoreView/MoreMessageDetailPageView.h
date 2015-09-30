//
//  MoreMessageDetailPageView.h

//  更多 - 消息中心 - 消息详情
//
//  Created by lzq on 2014-11-26.
//

#import <UIKit/UIKit.h>
#import "QDataSetObj.h"


@interface MoreMessageDetailPageView : UIViewController <UITableViewDataSource ,UITableViewDelegate>
{
    
    QDataSetObj*    m_pInfoDataSet;

    
}

@property (strong, nonatomic) IBOutlet UITableView  *m_uiMainTableView;

@property(assign ,nonatomic)NSString*   m_strMessageId;
@property(assign ,nonatomic)NSString*   m_strMessageTitle;
@property(assign ,nonatomic)NSString*   m_strMessageContent;
@property(assign ,nonatomic)NSString*   m_strMessageSendDate;
@end
