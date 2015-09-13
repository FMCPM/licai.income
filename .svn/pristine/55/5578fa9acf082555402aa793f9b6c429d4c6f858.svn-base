//
//  UserMessageInfoListPageView.h

//
//  Created by lzq on 2014-03-10.
//

#import <UIKit/UIKit.h>
#import "CustomViews.h"
#import "QDataSetObj.h"
#import "CKHttpImageHelper.h"

@interface UserMessageInfoListPageView : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    QDataSetObj* m_pMsgDataSet;
    NSMutableDictionary   *m_muImageListDic;    
    int     m_iCurPageID;
    bool    m_isToEndPage;
    bool    m_blNeedRefresh;
    bool    m_isLoading;
    CKHttpImageHelper* m_pImgHelper;
}

@property (strong ,nonatomic) IBOutlet UITableView *m_uiMessageTable;


@end
