//
//  ForgotPasswordView.h
//  找回密码
//
//  Created by lzq on 2014-11-28.
//
//

#import <UIKit/UIKit.h>
#import "SignMsgButton.h"


@interface ForgotPasswordView : UIViewController <UITableViewDataSource,UITableViewDelegate>
{
	
    UITapGestureRecognizer* m_pTapGesture;
    UITextField*            m_uiCurEditingField;
    NSString*               m_strInputPhoneNum;
    NSString*               m_strInputSignMessage;
    NSString*               m_strServerSignMsg;
    
    SignMsgButton*          m_uiSignButton;
}



@property (strong ,nonatomic) IBOutlet UITableView * m_uiMainTableView;

@end
