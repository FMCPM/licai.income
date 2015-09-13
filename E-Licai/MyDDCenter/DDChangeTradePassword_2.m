//
//  DDChangeTradePassword_2.m
//  YTSearch
//
//  Created by jiangjunchen on 12-11-27.
//
//

#import "DDChangeTradePassword_2.h"
#import "UaConfiguration.h"
#import "CKHttpHelper.h"
#import "GlobalDefine.h"
#import "UIOwnSkin.h"
#import "JsonXmlParserObj.h"
#import "Car_LoanDetailInfoPageView.h"

@interface DDChangeTradePassword_2()

@end

@implementation DDChangeTradePassword_2

@synthesize m_uiPwdTableView = _uiPwdTableView;
@synthesize m_iPasswordType = _iPasswordType;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
	
    self.navigationController.navigationBar.translucent = NO;

    NSString* strTitle = @"修改交易密码";
    if(_iPasswordType == 1)
    {
        strTitle = @"修改登录密码";
    }
	self.navigationItem.titleView = [UIOwnSkin navibarTitleView:strTitle andFrame:CGRectMake(0, 0, 100, 40)];
	self.view.backgroundColor = [UIColor whiteColor];
	
    self.navigationItem.leftBarButtonItem = [UIOwnSkin backItemTarget:self action:@selector(backNavButtonAction:)];
    
    m_pCurEditingField = nil;
    m_uiPwdField1 = nil;
    m_uiPwdField2 = nil;
    m_uiEndSubmitButton = nil;
    //注册键盘事件
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [super viewDidLoad];

	
}

-(void)viewWillAppear:(BOOL)animated
{
    CGRect rcTable = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    _uiPwdTableView = [[UITableView alloc]initWithFrame:rcTable style:UITableViewStylePlain];
    _uiPwdTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _uiPwdTableView.separatorColor = [UIColor clearColor];
    _uiPwdTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _uiPwdTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _uiPwdTableView.showsHorizontalScrollIndicator = NO;
    _uiPwdTableView.showsVerticalScrollIndicator = NO;
    _uiPwdTableView.backgroundColor = [UIColor whiteColor];
    _uiPwdTableView.dataSource = self;
    _uiPwdTableView.delegate = self;


    [self.view addSubview:_uiPwdTableView];
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    //注销键盘事件
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
}

- (void)backNavButtonAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)actionTextFieldEditingDidEnd:(id)sender
{
    [sender resignFirstResponder];
    UITextField* pTextField = (UITextField*)sender;
    if(pTextField == nil)
        return;
    UITableViewCell *pCellObj = [UIOwnSkin getSuperTableViewCell:pTextField];
    if(pCellObj == nil)
        return;
    
    NSIndexPath *indexPath = [_uiPwdTableView indexPathForCell:pCellObj];
    if(indexPath == nil)
        return;
    [self setTextFieldBorderColor:pTextField andFlag:0];
    m_pCurEditingField = nil;
    
    if(indexPath.row != 2)
    {
        return;
    }
/*
    if(m_uiPwdField2.text.length > 1)
    {
        [UIOwnSkin setButtonBackground:m_uiEndSubmitButton];
    }
 */
}


-(void)actionTextFieldEditingDidEndExit:(id)sender
{
    [sender resignFirstResponder];
    m_pCurEditingField = nil;
}

//开始编辑
-(void)actionTextFieldEditingDidBegin:(id)sender
{
    UITextField* pTextField = (UITextField*)sender;
    if(pTextField == nil)
        return;
    m_pCurEditingField = pTextField;
    [self setTextFieldBorderColor:pTextField andFlag:1];
}

//
-(void)actionTextFieldEditingChanged:(id)sender
{

    if(m_uiPwdField1.text.length > 0 && m_uiPwdField2.text.length > 0)
    {
        [UIOwnSkin setButtonBackground:m_uiEndSubmitButton];
    }
    else
    {
        [UIOwnSkin setButtonBackground:m_uiEndSubmitButton andColor:COLOR_BTN_BORDER_1];
    }
}


//设置边框颜色
-(void)setTextFieldBorderColor:(UITextField*)pTextField andFlag:(NSInteger)iFlag
{
    if(pTextField == nil)
        return;
    UIView*pBackView = [pTextField superview];
    if(pBackView == nil)
        return;
    pBackView.layer.borderWidth  = 1.0f;
    pBackView.layer.cornerRadius = 1.0f;
    if(iFlag == 1)
    {
        pBackView.layer.borderColor = COLOR_BTN_BORDER_2.CGColor;
    }
    else
    {
        pBackView.layer.borderColor = COLOR_BTN_BORDER_1.CGColor;
    }
    
}
//键盘弹出时的相关处理
- (void)keyboardWillShow:(NSNotification*)aNotification
{
    
    if(m_pTapGesture == nil)
    {
        m_pTapGesture  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenKeyBoard)];
        [self.view addGestureRecognizer:m_pTapGesture];
    }
    
    
}
-(void)hiddenKeyBoard
{
    if(m_pCurEditingField)
    {
        [m_pCurEditingField resignFirstResponder];
    }
    
}

//修改密码
-(void)actionModifyPwdClicked:(id)sender
{

    [self.navigationController popToRootViewControllerAnimated:YES];
    if(m_pCurEditingField)
    {
        [m_pCurEditingField resignFirstResponder];
    }
    
    NSString* strUserPwd1 = m_uiPwdField1.text;
    if(strUserPwd1.length < 1)
    {
        if(_iPasswordType == 1)
            [SVProgressHUD showErrorWithStatus:@"请输入登录密码！" duration:1.8];
        else
            [SVProgressHUD showErrorWithStatus:@"请输入交易密码！" duration:1.8];
        return;
    }
    NSString* strUserPwd2 = m_uiPwdField2.text;
    //三、确认密码
    if(strUserPwd2.length < 1)
    {
        [SVProgressHUD showErrorWithStatus:@"请输入确认密码！" duration:1.8];

        return;
    }
    if([strUserPwd1 isEqual:strUserPwd2] == NO)
    {
        [SVProgressHUD showErrorWithStatus:@"两次输入的密码不一致！" duration:1.8];
        return;
    }

    //
    CKHttpHelper *httpHelper = [CKHttpHelper httpHelperWithOwner:self];
    httpHelper.m_iWebServerType =1;
    
    if(_iPasswordType == 1)
    {

        
        httpHelper.methodType = CKHttpMethodTypePost_Page;
        [httpHelper setMethodName:@"memberInfo/changePwd"];
        [httpHelper addParam:[UaConfiguration sharedInstance].m_setLoginState.m_strUserLoginName forName:@"tmember.mobilePhone"];
        [httpHelper addParam:strUserPwd1 forName:@"tmember.password"];
    }
    else if(_iPasswordType == 2)//修改登陆密码
    {
        httpHelper.methodType = CKHttpMethodTypePost_Page;
        [httpHelper setMethodName:@"memberInfo/changeTradePwd"];
        [httpHelper addParam:[NSString stringWithFormat:@"%d",[UaConfiguration sharedInstance].m_setLoginState.m_iUserMemberID] forName:@"memberId"];
        [httpHelper addParam:strUserPwd1 forName:@"payPwd"];
    }
    else if(_iPasswordType == 3)//添加银行卡后，设置交易密码
    {
        httpHelper.methodType = CKHttpMethodTypePost_Page;
        [httpHelper setMethodName:@"memberInfo/savePayPassword"];
        [httpHelper addParam:[NSString stringWithFormat:@"%d",[UaConfiguration sharedInstance].m_setLoginState.m_iUserMemberID] forName:@"memberId"];
        [httpHelper addParam:strUserPwd1 forName:@"payPassword"];
    }

    
    [httpHelper setCompleteBlock:^(id data)
     {
         [SVProgressHUD  dismiss];
         JsonXmlParserObj* pJsonObj = data;
         if(pJsonObj == nil)
         {
             [SVProgressHUD showErrorWithStatus:HINT_WEBDATA_LOADING duration:1.8];
             return ;
             
         }
         if([pJsonObj getOpeResult] == NO)
         {
             NSString* strErrorMsg = [pJsonObj getJsonValueByKey:@"message"];
             [SVProgressHUD showErrorWithStatus:strErrorMsg duration:1.8];
             return ;
         }
         
         [UaConfiguration sharedInstance].m_setLoginState.m_strUserLoginPwd = strUserPwd1;
         [SVProgressHUD showSuccessWithStatus:@"修改密码成功！" duration:1.8];
         [self performSelector:@selector(backToRootView) withObject:self afterDelay:1.5];
         
     }];
    
    [httpHelper startWithStartBlock:^{
        [SVProgressHUD showWithStatus:HINT_WEBDATA_SUBMITING];
    }];

}


-(void)backToRootView
{
    if(_iPasswordType == 3)
    {
        UIViewController *pPopViewController = nil;
        
        int iViewCount = self.navigationController.viewControllers.count;
        
        int iViewIndex = iViewCount ;
        while (iViewIndex > 0)
        {
            iViewIndex--;
            pPopViewController = [self.navigationController.viewControllers objectAtIndex:iViewIndex];
            if([pPopViewController isKindOfClass:[Car_LoanDetailInfoPageView class] ] == NO)
            {
                continue;
            }
            [self.navigationController popToViewController:pPopViewController animated:YES];
            return;
            
        }
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}
#pragma UITableViewDataSource,UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 4;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 1)
        return 45;
    return 50;
}

-(UITableViewCell*)getUserPwdInputTableCell:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath
{
    NSString* strUserPwdInputTableCellId = @"UserPwdInputTableCellId";
    UITableViewCell *pCellObj = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:strUserPwdInputTableCellId];
    if (!pCellObj)
    {
        pCellObj = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strUserPwdInputTableCellId];
        pCellObj.contentView.backgroundColor = [UIColor whiteColor];
        pCellObj.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //
        UIView *pBackView = [[UIView alloc]initWithFrame:CGRectMake(10, 10, self.view.frame.size.width - 20, 40)];
        pBackView.backgroundColor = [UIColor whiteColor];
        pBackView.layer.borderWidth = 1.0f;
        pBackView.layer.borderColor = COLOR_BTN_BORDER_1.CGColor;
        pBackView.layer.cornerRadius = 1.0f;
        pBackView.tag = 1001;
        [pCellObj.contentView addSubview:pBackView];
        
        //
        UIImageView *pLogoImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_password"]];
        pLogoImgView.frame = CGRectMake(10, 10, 20, 20);
        pLogoImgView.tag = 2001;
        [pBackView addSubview:pLogoImgView];
        
        //
        UITextField* pTextField = [[UITextField alloc]initWithFrame:CGRectMake(40, 5, self.view.frame.size.width-60, 30)];
        pTextField .font =[UIFont systemFontOfSize:14.0];
        pTextField.tag = 2002;
        pTextField.borderStyle = UITextBorderStyleNone;
        pTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        pTextField.contentHorizontalAlignment  = UIControlContentHorizontalAlignmentCenter;
        pTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        //pTextField.delegate =self;
        pTextField.returnKeyType = UIReturnKeyDone;
        [pTextField addTarget:self action:@selector(actionTextFieldEditingDidEndExit:) forControlEvents:UIControlEventEditingDidEndOnExit];
        [pTextField addTarget:self action:@selector(actionTextFieldEditingDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
        [pTextField addTarget:self action:@selector(actionTextFieldEditingDidEnd:) forControlEvents:UIControlEventEditingDidEnd];
        
        [pTextField addTarget:self action:@selector(actionTextFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
        pTextField.secureTextEntry = YES;
        [pBackView addSubview:pTextField];
        
        
        
    }
    UIImageView* pLogoImgView = (UIImageView*)[pCellObj.contentView viewWithTag:2001];
    UITextField* pTextField = (UITextField*)[pCellObj.contentView viewWithTag:2002];
    if(pLogoImgView == nil || pTextField == nil)
        return pCellObj;
    
    if(indexPath.row == 0)
    {
        m_uiPwdField1 = pTextField;
        if(_iPasswordType == 1)
            pTextField.placeholder = @"登录密码";
        else
            pTextField.placeholder = @"交易密码";
        pTextField.secureTextEntry = NO;
    }
    else
    {
        m_uiPwdField2 = pTextField;
        if(_iPasswordType == 1)
            pTextField.placeholder = @"确认登录密码";
        else
            pTextField.placeholder = @"确认交易密码";
        pTextField.secureTextEntry = YES;
    }
    
    return pCellObj;
    
}

//
-(UITableViewCell*)getPwdEndModifyButtonCell:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath
{
    static NSString *strPwdEndModifyButtonCellId = @"PwdEndModifyButtonCellId";
    UITableViewCell *pCellObj = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:strPwdEndModifyButtonCellId];
    if (!pCellObj) {
        pCellObj = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strPwdEndModifyButtonCellId];
        pCellObj.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIButton* pButton = [UIButton buttonWithType:UIButtonTypeCustom];
        pButton.frame = CGRectMake(10, 15, 300, 35);
        
        [UIOwnSkin setButtonBackground:pButton andColor:COLOR_BTN_BORDER_1];
        pButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [pButton setTitle:@"完成" forState:UIControlStateNormal];
        [pButton addTarget:self action:@selector(actionModifyPwdClicked:) forControlEvents:UIControlEventTouchUpInside];
        [pCellObj.contentView addSubview:pButton];
        
        m_uiEndSubmitButton = pButton;
        
    }
    
    return pCellObj;
}

//
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell* pCellObj = nil;
    if(indexPath.row ==0 || indexPath.row == 2)
    {
        pCellObj = [self getUserPwdInputTableCell:tableView indexPath:indexPath];
    }
    else if(indexPath.row == 3)
    {
        pCellObj = [self getPwdEndModifyButtonCell:tableView indexPath:indexPath];
    }
    if(pCellObj != nil)
        return pCellObj;
    
    static NSString *strPwdHintLabelCellId = @"PwdHintLabelCellId";
    pCellObj = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:strPwdHintLabelCellId];
    if (!pCellObj) {
        pCellObj = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strPwdHintLabelCellId];
        pCellObj.selectionStyle = UITableViewCellSelectionStyleNone;
        pCellObj.contentView.backgroundColor = [UIColor whiteColor];
        
        UILabel* pLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 280, 20)];
        pLabel.backgroundColor = [UIColor whiteColor];
        pLabel.textColor = COLOR_FONT_2;
        pLabel.font = [UIFont systemFontOfSize:14];
        pLabel.tag = 1001;
        pLabel.textAlignment = UITextAlignmentLeft;
        pLabel.text = @"密码有6-12字符组成，字母区分大小写";
        [pCellObj.contentView addSubview:pLabel];
        
    }
    return pCellObj;
}




#pragma mark UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    int tag = textField.tag;
    NSString *temp = [textField.text stringByReplacingCharactersInRange:range withString:string];
	
    switch (tag)
    {
        case 1001: //用户名
		{
			const char  *str = [temp UTF8String];
			NSInteger lenth = strlen(str);
			if (lenth > 16)
				return  NO;
		}
            break;
        case 1002://密码
            if (temp.length > 16)
            {
                return NO;
            }
            break;
    }
    return YES;
}



@end
