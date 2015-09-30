//
//  DDChangeTradePassword.h
//  我的叮叮 - 修改交易密码
//
//  Created  on 2014-11-25
//

#import <UIKit/UIKit.h>
#import "CustomViews.h"
#import "SignMsgButton.h"

@interface DDChangeTradePassword_1 : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITextField* m_pCurEditingField;
    NSString*   m_strUserRealName;
    NSString*   m_strUserCardNumber;
    NSString*   m_strUserMobileNum;
    NSString*   m_strUserSignMessage;
    UITapGestureRecognizer* m_pTapGesture;
    float           m_offsetToMove;
    NSString*   m_strServerSignMsg;
    
    SignMsgButton*  m_uiSignButton;
}

@property (strong, nonatomic) IBOutlet UITableView *m_uiPwdTableView;
@property (strong ,nonatomic) UITextField *_uiFieldUserOldPwd;
@property (strong ,nonatomic) UITextField *_uiFieldUserNewPwd;
@property (strong ,nonatomic) UITextField * _uiFieldUserRepeatPwd;

@end
