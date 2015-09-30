//
//  UserSendMessagePageView.h

//
//  Created by lzq on 2014-03-10.
//

#import <UIKit/UIKit.h>
#import "CustomViews.h"
#import "QDataSetObj.h"

//#define SENDVIEW_HEIGH 50

@interface UserSendMessagePageView : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    QDataSetObj* m_pMsgDataSet;
    NSMutableDictionary   *m_muImageListDic;
    int     m_iTextLineCount;
    UIImage*    m_pUserHeadImage;
    NSString*   m_strUserHeadImageUrl;
    NSInteger   m_iCurPageID;
  //  bool        m_isEndLoadLog;
    //是否可以加载更多
    bool        m_isCanLoadMore;
    
    int         m_iTotalTestCount;
}

@property (strong ,nonatomic) IBOutlet UITableView *m_uiMessageTable;
@property (strong ,nonatomic) IBOutlet UIView *m_uiSendView;
@property (strong ,nonatomic) IBOutlet UITextView *m_uiSendTextView;
@property (strong ,nonatomic) IBOutlet UIButton *m_uiSendTextButton;

@property (strong ,nonatomic) NSString* m_strFriendId;
@property (strong ,nonatomic) NSString* m_strSessionId;
@property (strong ,nonatomic) UIImage* m_pFriendHeadImage;
@property (assign,nonatomic)  NSInteger m_iMessageType;
@property (strong ,nonatomic) SetRowObj* m_pOneMessageRowSet;
@property (strong ,nonatomic) NSString* m_strFriendHeadImgUrl;

-(IBAction)onSendMessageBtnClicked:(id)sender;

@end
