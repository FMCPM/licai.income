//
//  UserRegisterViewController.h
//  叮叮理财 - 注册
//
//  Created by lzq on 2014-11-27.
//
//

#import <UIKit/UIKit.h>
#import "SignMsgButton.h"

@interface UserRegisterViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    bool            m_blSelProtocol;
    NSString*       m_strUserPhoneNum;
    NSString*       m_strUserPwd1;
    NSString*       m_strUserPwd2;
    NSString*       m_strUserSignMsg;
    NSString*       m_strServerSignMsg;
    
    UITextField*    m_uiCurEditingField;
    UITapGestureRecognizer* m_pTapGesture;
    float           m_offsetToMove;
    SignMsgButton*  m_uiSignButton;
}

@property (strong, nonatomic) IBOutlet UITableView *m_uiMainTableView;

@end
