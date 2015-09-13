//
//  ForgotPasswordView.m
//  找回密码
//
//  Created by lzq on 2014-11-28.
//
//

#import "ForgotPasswordView.h"
#import <QuartzCore/QuartzCore.h>
#import "UIOwnSkin.h"
#import "CKKit.h"
#import "CustomViews.h"
#import "QDataSetObj.h"
#import "JsonXmlParserObj.h"
#import "GlobalDefine.h"
#import "DDChangeTradePassword_2.h"


@interface ForgotPasswordView ()

@end

@implementation ForgotPasswordView
@synthesize m_uiMainTableView = _uiMainTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    //标题
    self.navigationItem.titleView  = [UIOwnSkin navibarTitleView:@"找回登录密码" andFrame:CGRectMake(0, 0, 100, 40)];
    //左边返回按钮
    self.navigationItem.leftBarButtonItem = [UIOwnSkin backItemTarget:self action:@selector(backNavButtonAction:)];
    
    self.view.backgroundColor = [UIColor whiteColor];
    m_uiSignButton = nil;
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)backNavButtonAction:(id)sender
{
    if(m_uiSignButton != nil)
    {
        [m_uiSignButton stopWait];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    
    CGRect rcTable = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    _uiMainTableView = [[UITableView alloc]initWithFrame:rcTable style:UITableViewStylePlain];
    _uiMainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _uiMainTableView.separatorColor = [UIColor clearColor];
    _uiMainTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _uiMainTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _uiMainTableView.showsHorizontalScrollIndicator = NO;
    _uiMainTableView.showsVerticalScrollIndicator = NO;
    _uiMainTableView.backgroundColor = [UIColor whiteColor];
    _uiMainTableView.dataSource = self;
    _uiMainTableView.delegate = self;
    //注册键盘事件
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [self.view addSubview:_uiMainTableView];
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    //注销键盘事件
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    

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
    if(m_uiCurEditingField)
    {
        [m_uiCurEditingField resignFirstResponder];
    }
    
}


//点击下一步
-(void)actionNextStepClicked:(id)sender
{
    if(m_uiCurEditingField)
    {
        [m_uiCurEditingField resignFirstResponder];
    }
    //一、手机号码验证
    if(m_strInputPhoneNum.length < 1)
    {
        [SVProgressHUD showErrorWithStatus:@"请输入您的手机号码！" duration:1.8];
        return;
    }
    NSString* phoneRegex = @"\\d{7,20}";
    NSPredicate *phoneTest  = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    if([phoneTest evaluateWithObject:m_strInputPhoneNum] == NO)
    {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号码！"];
        return ;
    }

    if(m_strInputSignMessage.length < 1)
    {
        [SVProgressHUD showErrorWithStatus:@"请输入您收到的验证码！"];
        return ;
    }
    
    if([m_strInputSignMessage isEqualToString:m_strServerSignMsg] == NO)
    {
        [SVProgressHUD showErrorWithStatus:@"您输入的验证码不正确，请重新输入！" duration:1.8];
        return ;
    }
    if(m_uiSignButton != nil)
    {
        [m_uiSignButton stopWait];
    }
    
    DDChangeTradePassword_2* pPwdView2 = [[DDChangeTradePassword_2 alloc] init];
    pPwdView2.m_iPasswordType = 1;
    pPwdView2.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:pPwdView2 animated:YES];

    /*
    CKHttpHelper *httpHelper = [CKHttpHelper httpHelperWithOwner:self];
    httpHelper.m_iWebServerType =1;
    httpHelper.methodType = CKHttpMethodTypePost_Page;
    [httpHelper setMethodName:@"memberInfo/registeMember"];
    [httpHelper addParam:m_strUserPhoneNum forName:@"tmember.mobilePhone"];
    [httpHelper addParam:m_strUserPwd1 forName:@"tmember.password"];
    
    [httpHelper setCompleteBlock:^(id data)
     {
         [SVProgressHUD  dismiss];
     
         
         [UaConfiguration sharedInstance].m_setLoginState.m_strUserLoginName = m_strUserPhoneNum;
         [UaConfiguration sharedInstance].m_setLoginState.m_strUserLoginPwd = m_strUserPwd1;
         [self.navigationController popToRootViewControllerAnimated:YES];
         
     }];
    
    [httpHelper startWithStartBlock:^{
        [SVProgressHUD showWithStatus:HINT_WEBDATA_SUBMITING];
    }];
    */
    
    
}

//点击完成等结束编辑
-(void)actionTextFieldEditingDidEndExit:(id)sender
{
    UITextField* pTextField = (UITextField*)sender;
    if(pTextField == nil)
        return;
    [pTextField resignFirstResponder];
    m_uiCurEditingField = nil;
}

//开始编辑
-(void)actionTextFieldEditingDidBegin:(id)sender
{
    UITextField* pTextField = (UITextField*)sender;
    if(pTextField == nil)
        return;
    UIView* pSupView = [pTextField superview];
    if(pSupView)
    {
        pSupView.layer.borderColor = COLOR_BTN_BORDER_2.CGColor;
    };
    m_uiCurEditingField = pTextField;
}

//完成编辑
-(void)actionTextFieldEditingDidEnd:(id)sender
{
    UITextField* pTextField = (UITextField*)sender;
    if(pTextField == nil)
        return;
    
    UIView* pSupView = [pTextField superview];
    if(pSupView)
    {
        pSupView.layer.borderColor = COLOR_BTN_BORDER_1.CGColor;
    }
    
    UITableViewCell*  pCellObj = [UIOwnSkin getSuperTableViewCell:sender];
    if(pCellObj == nil)
        return;
    NSIndexPath* indexPath = [_uiMainTableView indexPathForCell:pCellObj];
    if(indexPath == nil)
        return;
    NSString* strText = pTextField.text;
    if(indexPath.row == 0)
    {
        m_strInputPhoneNum = strText;
    }
    else if(indexPath.row == 1)
    {
        m_strInputSignMessage = strText;
    }
 
    m_uiCurEditingField = nil;
}


-(void)actionTextFieldEditingChanged:(id)sender
{
    UITextField* pTextField = (UITextField*)sender;
    if(pTextField == nil)
        return;
    UITableViewCell*  pCellObj = [UIOwnSkin getSuperTableViewCell:sender];
    if(pCellObj == nil)
        return;
    NSIndexPath* indexPath = [_uiMainTableView indexPathForCell:pCellObj];
    if(indexPath == nil)
        return;
    if(indexPath.row != 1)//验证码
    {
        return;
    }
    NSIndexPath* regBtnIndex = [NSIndexPath indexPathForRow:2 inSection:0];
    UITableViewCell* pBtnCellObj = [_uiMainTableView cellForRowAtIndexPath:regBtnIndex];
    if(pBtnCellObj == nil)
        return;
    UIButton* pRegButton = (UIButton*)[pBtnCellObj.contentView viewWithTag:1004];
    if(pRegButton == nil)
        return;
    if(pTextField.text.length > 0)
    {
        
        pRegButton.enabled = YES;
        [UIOwnSkin setButtonBackground:pRegButton];
    }
    else
    {
        pRegButton.enabled = NO;
        [UIOwnSkin setButtonBackground:pRegButton andColor:COLOR_BTN_BORDER_1];
    }
}

//获取验证码
-(void)actionGetSignMessageClicked:(id)sender
{
  //  [SVProgressHUD showSuccessWithStatus:@"测试：验证码已发送，请查收！" duration:1.8];
    
    
    [self hiddenKeyBoard];
    if(m_strInputPhoneNum.length < 11)
    {
        [SVProgressHUD showErrorWithStatus:@"请输入手机号码！" duration:1.8];
        return;
    }

    //
    CKHttpHelper *httpHelper = [CKHttpHelper httpHelperWithOwner:self];
    httpHelper.m_iWebServerType =1;
    httpHelper.methodType = CKHttpMethodTypePost_Page;
    [httpHelper setMethodName:@"memberInfo/queryCheckNum"];
    [httpHelper addParam:m_strInputPhoneNum forName:@"tmember.mobilePhone"];
    
    [httpHelper setCompleteBlock:^(id data)
     {
         [SVProgressHUD  dismiss];
         
         JsonXmlParserObj* pJsonObj = data;
         if(pJsonObj == nil)
         {
             [SVProgressHUD showErrorWithStatus:HINT_WEBDATA_NET_ERROR duration:1.8];
             return ;
         }
         
         QDataSetObj* pDataObj = [pJsonObj parsetoDataSet:@"data"];
         if(pDataObj == nil)
             return;
         m_strServerSignMsg = [pDataObj getFeildValue:0 andColumn:@"checkNum"];
         if(m_strServerSignMsg.length > 0)
         {
             [SVProgressHUD showSuccessWithStatus:@"验证码已发送，请查收！" duration:1.8];
         }
         
         if(m_uiSignButton != nil)
         {
             [m_uiSignButton startWait];
         }
     }];
    
    [httpHelper startWithStartBlock:^{
        [SVProgressHUD showWithStatus:HINT_WEBDATA_SUBMITING];
    }];

}

#pragma UITableViewDataSource,UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row < 2)
        return 50;
    return 60;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(UITableViewCell*)getForgotTextFieldTableCell:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath
{
    static NSString *strForgotTextFieldTableCellId = @"ForgotTextFieldTableCellId";
    UITableViewCell *pCellObj = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:strForgotTextFieldTableCellId];
    if (!pCellObj) {
        pCellObj = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strForgotTextFieldTableCellId];
        pCellObj.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *pBackView = [[UIView alloc]initWithFrame:CGRectMake(10, 10, self.view.frame.size.width - 20, 40)];
        pBackView.backgroundColor = [UIColor whiteColor];
        pBackView.layer.borderWidth = 1.0f;
        pBackView.layer.borderColor = COLOR_BTN_BORDER_1.CGColor;
        pBackView.layer.cornerRadius = 1.0f;
        pBackView.tag = 1001;
        [pCellObj.contentView addSubview:pBackView];
        
        //提示的小图片
        UIImageView *pLogoImgView = [[UIImageView alloc] initWithFrame: CGRectMake(10, 10, 20, 20)];
        
        pLogoImgView.tag = 1002;
        [pBackView addSubview:pLogoImgView];
        
        //信息编辑
        UITextField *pTextField = [[UITextField alloc]initWithFrame:CGRectMake(40, 5, self.view.frame.size.width-70, 30)];
        pTextField .font =[UIFont systemFontOfSize:14.0];
        pTextField.tag = 1003;
        pTextField.borderStyle = UITextBorderStyleNone;
        pTextField.keyboardType = UIKeyboardTypeDefault;
        pTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        //pTextField.placeholder = @"请输入密码";
        pTextField.secureTextEntry = YES;
        pTextField.contentHorizontalAlignment  = UIControlContentHorizontalAlignmentCenter;
        pTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        //pTextField.delegate =self;
        pTextField.returnKeyType = UIReturnKeyDone;
        [pTextField addTarget:self action:@selector(actionTextFieldEditingDidEndExit:) forControlEvents:UIControlEventEditingDidEndOnExit];
        [pTextField addTarget:self action:@selector(actionTextFieldEditingDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
        [pTextField addTarget:self action:@selector(actionTextFieldEditingDidEnd:) forControlEvents:UIControlEventEditingDidEnd];
        [pBackView addSubview:pTextField];
        
    }
    UIImageView* pLogoImgView = (UIImageView*)[pCellObj.contentView viewWithTag:1002];
    
    UITextField* pTextField = (UITextField*)[pCellObj.contentView viewWithTag:1003];
    if(pTextField == nil || pLogoImgView == nil)
        return pCellObj;
    pLogoImgView.image = [UIImage imageNamed:@"icon_phone.png"];
    pTextField.placeholder = @"请输入您的手机号码";
    pTextField.secureTextEntry = NO;
    pTextField.keyboardType = UIKeyboardTypeDecimalPad;
    
    return pCellObj;
}


//短信验证码
-(UITableViewCell*)getForgotSignMessageCell:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath
{
    static NSString *strForgotSignMessageCellId = @"ForgotSignMessageCellId";
    UITableViewCell *pCellObj = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:strForgotSignMessageCellId];
    if (!pCellObj) {
        pCellObj = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strForgotSignMessageCellId];
        pCellObj.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *pBackView = [[UIView alloc]initWithFrame:CGRectMake(10, 10, 150, 40)];
        pBackView.backgroundColor = [UIColor whiteColor];
        pBackView.layer.borderWidth = 1.0f;
        pBackView.layer.borderColor = COLOR_BTN_BORDER_1.CGColor;
        pBackView.layer.cornerRadius = 1.0f;
        pBackView.tag = 2001;
        [pCellObj.contentView addSubview:pBackView];
        
        //验证码
        UITextField *pTextField = [[UITextField alloc]initWithFrame:CGRectMake(5, 5, 140, 30)];
        pTextField.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
        pTextField.tag = 1001;
        pTextField.font = [UIFont systemFontOfSize:14.0];
        pTextField.borderStyle = UITextBorderStyleNone;
        pTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        pTextField.returnKeyType = UIReturnKeyDone;
        [pTextField addTarget:self action:@selector(actionTextFieldEditingDidEndExit:) forControlEvents:UIControlEventEditingDidEndOnExit];
        [pTextField addTarget:self action:@selector(actionTextFieldEditingDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
        [pTextField addTarget:self action:@selector(actionTextFieldEditingDidEnd:) forControlEvents:UIControlEventEditingDidEnd];
        [pTextField addTarget:self action:@selector(actionTextFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
        pTextField.placeholder = @"短信验证码";
        //[self setTextFieldBorderColor:pTextField andFlag:0];
        [pBackView addSubview:pTextField];
        
        //
        m_uiSignButton = [SignMsgButton buttonWithType:UIButtonTypeCustom];
        
        m_uiSignButton.frame = CGRectMake(170, 10, 140, 40);
        [m_uiSignButton addTitleLabel];
        [UIOwnSkin setButtonBackground:m_uiSignButton andColor:COLOR_BTN_BORDER_2];
        m_uiSignButton.m_uiTitleLabel.font = [UIFont systemFontOfSize:14];
        m_uiSignButton.m_uiTitleLabel.textColor = [UIColor whiteColor];
        m_uiSignButton.m_uiTitleLabel.text = @"立即获取";
        //[pButton setTitle:@"立即获取" forState:UIControlStateNormal];
        [m_uiSignButton addTarget:self action:@selector(actionGetSignMessageClicked:) forControlEvents:UIControlEventTouchUpInside];
        [pCellObj.contentView addSubview:m_uiSignButton];
        
    }
    
    return pCellObj;
}


//下一步
-(UITableViewCell*)getForgotPwdButtonCell:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath
{
    static NSString *strForgotPwdButtonCellId = @"ForgotPwdButtonCellId";
    UITableViewCell *pCellObj = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:strForgotPwdButtonCellId];
    if (!pCellObj) {
        pCellObj = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strForgotPwdButtonCellId];
        pCellObj.selectionStyle = UITableViewCellSelectionStyleNone;
        
         //注册按钮
        UIButton* pButton = [UIButton buttonWithType:UIButtonTypeCustom];
        pButton.frame = CGRectMake(10, 20, 300, 35);
        pButton.tag = 1004;
        [UIOwnSkin setButtonBackground:pButton andColor:COLOR_BTN_BORDER_1];
        pButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [pButton setTitle:@"下一步" forState:UIControlStateNormal];
        [pButton addTarget:self action:@selector(actionNextStepClicked:) forControlEvents:UIControlEventTouchUpInside];
        pButton.enabled = NO;
        [pCellObj.contentView addSubview:pButton];
        
    }
    
    return pCellObj;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell* pCellObj = nil;
    if(indexPath.row == 0)
    {
        pCellObj = [self getForgotTextFieldTableCell:tableView indexPath:indexPath];
    }
    else if(indexPath.row == 1)
    {
        pCellObj = [self getForgotSignMessageCell:tableView indexPath:indexPath];
    }
    else if(indexPath.row == 2)
    {
        pCellObj = [self getForgotPwdButtonCell:tableView indexPath:indexPath];
    }
    return pCellObj;
    
}

//
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(m_uiCurEditingField)
    {
        [m_uiCurEditingField resignFirstResponder];
    }
}






@end
