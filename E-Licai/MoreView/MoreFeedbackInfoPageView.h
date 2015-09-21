//
//  MoreFeedbackInfoPageView.h
//  更多 - 意见反馈
//
//  Created by lzq on 2014-11-26.

//

#import <UIKit/UIKit.h>
#import "QDataSetObj.h"

#define FEEDBACK_MEMO_DEFAULT @"感谢您对叮叮理财的支持，我们期待您宝贵的一键，请点击输入..."

@interface MoreFeedbackInfoPageView : UIViewController <UITableViewDataSource ,UITableViewDelegate>

{
    UITextView* m_uiDespTextView ;
    UIButton*   m_uiSendMsgButton;
    NSString*   m_strInputMemoInfo;
    bool        m_isRegKeyboardEvent;
    UITapGestureRecognizer*m_pTapGesture;
    UIWebView*  m_callWebView;
}

@property (strong, nonatomic) IBOutlet UITableView  *m_uiMainTableView;


@end
