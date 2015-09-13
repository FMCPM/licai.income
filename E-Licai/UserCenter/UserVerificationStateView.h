//
//  UserVerificationStateView.h

//
//  Created by  on 14-3-21.
//  Copyright (c) 2014年 ytinfo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CKKit.h"
#import "QDataSetObj.h"

@interface UserVerificationStateView : UIViewController<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>

@property (strong ,nonatomic) QDataSetObj *m_loginData;
@property (strong ,nonatomic) NSString *userName;
@property (strong ,nonatomic) NSString *passWord;
@property (strong ,nonatomic) NSString *userPhoneNum;
@property (strong ,nonatomic) IBOutlet UILabel * m_uiUserNameLabel;
@property (strong ,nonatomic) IBOutlet UITextField * m_uiPhoneNumText;
@property (strong ,nonatomic) IBOutlet UITableView * m_uiMainTable;



@end
