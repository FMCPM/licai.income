//
//  DDChangeTradePassword_2.h
//  我的叮叮 - 修改交易密码 - 步骤2
//
//  Created by jiangjunchen on 12-11-27.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface DDChangeTradePassword_2 : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITextField *m_uiPwdField1;
	UITextField *m_uiPwdField2;
    
    UIButton*   m_uiEndSubmitButton;
    UITextField* m_pCurEditingField;
    UITapGestureRecognizer* m_pTapGesture;
}


@property (strong ,nonatomic) IBOutlet UITableView * m_uiPwdTableView;
@property (assign ,nonatomic) NSInteger m_iPasswordType;


@end



