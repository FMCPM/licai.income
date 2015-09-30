//
//  LoginViewController.m
//  YTSearch
//
//  Created by jiangjunchen on 12-11-27.
//
//

#import "LoginViewController.h"
#import "UaConfiguration.h"
#import "UserRegisterViewController.h"
#import "CKHttpHelper.h"
#import "GlobalDefine.h"
#import "UIColor+Hex.h"
#import "CKEncrypt.h"
#import "UIOwnSkin.h"
#import "ForgotPasswordView.h"
#import "GlobalDefine.h"
#import "EAppDelegate.h"
#import "JsonXmlParserObj.h"
#import "XGPush.h"
#import "WebViewController.h"

@interface LoginViewController()

@end

@implementation LoginViewController

@synthesize m_uiMainTableView = _uiMainTableView;
@synthesize m_iLoadOrigin = _iLoadOrigin;
@synthesize m_pLoginDelegate = _pLoginDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
      //  _bFromOrdersMng = NO;
    }
    return self;
}



- (void)viewDidLoad
{
	
    //左边返回按钮
    self.navigationItem.leftBarButtonItem = [UIOwnSkin backItemTarget:self action:@selector(backNavButtonAction:)];

	self.navigationItem.titleView = [UIOwnSkin navibarTitleView:@"填写登录密码" andFrame:CGRectMake(0, 0, 100, 40)];
    
    //右边注册按钮
    self.navigationItem.rightBarButtonItem = [UIOwnSkin navTextItemTarget:self action:@selector(onRightRegistClicked:) text:@"注册" andWidth:40];
	self.view.backgroundColor = [UIColor whiteColor];
    m_pTapGesture = nil;
    m_uiCurEditingField = nil;
    m_strInputPassword = @"";
    m_strInputPhoneNum = @"";
    
    _uiMainTableView = nil;
    m_blSelProtocol = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [super viewDidLoad];
    
    
}


-(void)backNavButtonAction:(id)sender
{
    if(self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }


}

//启动注册流程
-(void)onRightRegistClicked:(id)sender
{
    UserRegisterViewController*pRegistView = [[UserRegisterViewController alloc] init];
    pRegistView.hidesBottomBarWhenPushed = YES;
    _iLoadOrigin = 9;
    [self.navigationController pushViewController:pRegistView animated:YES];
}



-(void)viewWillAppear:(BOOL)animated
{
    if(_uiMainTableView != nil)
    {
        if(_iLoadOrigin == 9)
            _iLoadOrigin = 1;
        return;
    }
    
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
    [self.view addSubview:_uiMainTableView];

}

-(void)viewWillDisappear:(BOOL)animated
{
    //注销键盘事件
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    if(_iLoadOrigin != 1)
        return;
    
    [_pLoginDelegate onSelectedNoLoadInSystem];
}

-(void)viewDidDisappear:(BOOL)animated
{



}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//键盘显示的事件
-(void)keyboardWillShow:(NSNotification*)aNotification
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

//点击登录
-(void)actionLoginClicked:(id)sender
{
//    m_blSelProtocol = YES;
//    //测试
//    m_strInputPhoneNum = @"13600523915";
//    m_strInputPassword = @"123456";
    
    if(m_uiCurEditingField != nil)
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
    //二、密码
    if(m_strInputPassword.length < 1)
    {
        [SVProgressHUD showErrorWithStatus:@"请输入登录密码！" duration:1.8];
        return;
    }
    
    //阅读协议
    if(m_blSelProtocol == NO)
    {
        [SVProgressHUD showErrorWithStatus:@"请阅读叮叮理财使用条款！" duration:1.8];
        return;
    }
    
    CKHttpHelper *httpHelper = [CKHttpHelper httpHelperWithOwner:self];
    httpHelper.m_iWebServerType =1;
    httpHelper.methodType = CKHttpMethodTypePost_Page;
    [httpHelper setMethodName:@"memberInfo/memberLogin"];
    [httpHelper addParam:m_strInputPhoneNum forName:@"tmember.mobilePhone"];
    [httpHelper addParam:m_strInputPassword forName:@"tmember.password"];
    //设备类型,1_android;2_ios
    [httpHelper addParam:@"2" forName:@"tmember.deviceType"];
    [httpHelper setCompleteBlock:^(id data)
     {
         [SVProgressHUD  dismiss];
         
         JsonXmlParserObj* pJsonObj = data;
         if(pJsonObj == nil)
         {
             [SVProgressHUD showErrorWithStatus:HINT_WEBDATA_NET_ERROR duration:1.8];
             return ;
         }
         QDataSetObj* pDataSet = [pJsonObj parsetoDataSet:@"data"];
         if(pDataSet == nil)
             return;
         if([pDataSet getOpeResult] == NO)
         {
             [SVProgressHUD showErrorWithStatus:[pDataSet getFeildValue:0 andColumn:@"message"] duration:1.8];
             return;
         }
         NSString* strMemberId = [pDataSet getFeildValue:0 andColumn:@"memberId"];
         
         [UaConfiguration sharedInstance].m_setLoginState.m_iUserMemberID = [QDataSetObj convertToInt:strMemberId];
         [UaConfiguration sharedInstance].m_setLoginState.m_strUserLoginName = m_strInputPhoneNum;
         [UaConfiguration sharedInstance].m_setLoginState.m_strUserLoginPwd = m_strInputPassword;
         [[UaConfiguration sharedInstance].m_setLoginState setHaveLoadInSession:1];
         
         //身份证、姓名、银行卡
         [UaConfiguration sharedInstance].m_setLoginState.m_strUserCardId = [pDataSet getFeildValue:0 andColumn:@"idCardNo"];
         
         [UaConfiguration sharedInstance].m_setLoginState.m_strUserReallyName = [pDataSet getFeildValue:0 andColumn:@"name"];
         
         [UaConfiguration sharedInstance].m_setLoginState.m_strBankCardId = [pDataSet getFeildValue:0 andColumn:@"cardSno"];
         [XGPush setAccount:[UaConfiguration sharedInstance].m_setLoginState.m_strUserLoginName];
         NSLog(@"XGPush setAccount %@",[UaConfiguration sharedInstance].m_setLoginState.m_strUserLoginName);
         if(_iLoadOrigin == 3)
         {
             [self.navigationController popViewControllerAnimated:NO];
             return;
         }
         if(_iLoadOrigin == 1)
         {
             _iLoadOrigin = 0;
             [self.navigationController popViewControllerAnimated:YES];
             return;
         }
         _iLoadOrigin = 2;
         [self.navigationController popToRootViewControllerAnimated:YES];

         
     }];
    
    [httpHelper startWithStartBlock:^{
        [SVProgressHUD showWithStatus:HINT_WEBDATA_SUBMITING];
    }];
    
}

-(void)synPopupView
{
    [self.navigationController popViewControllerAnimated:YES];
}

//忘记密码
-(void)actionForgotPwdClicked:(id)sender
{
    _iLoadOrigin = 2;
    [self hiddenKeyBoard];
    ForgotPasswordView* pForgotPwdView = [[ForgotPasswordView alloc] init];
    pForgotPwdView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:pForgotPwdView animated:YES];
}


-(void)actionTextFieldEditingDidEndExit:(id)sender
{
    UITextField* pTextField = (UITextField*)sender;
    if(pTextField == nil)
        return;
    UIView* pSupView = [pTextField superview];
    if(pSupView)
    {
        pSupView.layer.borderColor = COLOR_BTN_BORDER_1.CGColor;
    }
    
    [pTextField resignFirstResponder];
}


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
        m_strInputPassword = strText;
    }
    m_uiCurEditingField = nil;

}

/*
-(void)actionTextFieldEditingChanged:(id)sender
{
    NSString* strText = m_uiInputPwdField.text;
    if(strText.length <= 4)
    {
        m_uiPhoneNumLabel.text = strText;
    }
    else if(strText.length <=8 )
    {
        m_uiPhoneNumLabel.text = [NSString stringWithFormat:@"%@ %@",[strText substringToIndex:3],[strText substringFromIndex:4]];
    }
    else
    {
        NSRange range;
        range.location = 4;
        range.length = 4;
        m_uiPhoneNumLabel.text = [NSString stringWithFormat:@"%@ %@ %@",[strText substringToIndex:3],[strText substringWithRange:range],[strText substringFromIndex:8]];
    }
}
*/
//点击叮叮适用协议条款
-(void)actionUsedProtocolClicked:(id)sender
{
    if(m_uiCurEditingField)
    {
        [m_uiCurEditingField resignFirstResponder];
    }
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    UITableViewCell* pCellObj = [_uiMainTableView cellForRowAtIndexPath:indexPath];
    if(pCellObj == nil)
        return;
    UIImageView* pImageView = (UIImageView*)[pCellObj.contentView viewWithTag:2001];
    UILabel*   pProtocoLabel = (UILabel*)[pCellObj.contentView viewWithTag:1001];
    UIImageView* pLineView = (UIImageView*)[pCellObj.contentView viewWithTag:2002];
    if(m_blSelProtocol == YES)
    {
        m_blSelProtocol = NO;
        pImageView.image = [UIImage imageNamed:@"checkbox_nil"];
        pProtocoLabel.textColor = COLOR_FONT_1;
        pLineView.backgroundColor = COLOR_FONT_1;
    }
    else
    {
        m_blSelProtocol = YES;
        pImageView.image = [UIImage imageNamed:@"checkbox_selected.png"];
        pProtocoLabel.textColor = COLOR_FONT_4;
        pLineView.backgroundColor = COLOR_FONT_4;
    }
 
    [self setLogButtonTypeShow:m_blSelProtocol];
}

-(void)setLogButtonTypeShow:(bool)blEnabel
{
    NSIndexPath* regBtnIndex = [NSIndexPath indexPathForRow:2 inSection:0];
    UITableViewCell* pBtnCellObj = [_uiMainTableView cellForRowAtIndexPath:regBtnIndex];
    if(pBtnCellObj == nil)
        return;
    UIButton* pRegButton = (UIButton*)[pBtnCellObj.contentView viewWithTag:3004];
    if(pRegButton == nil)
        return;
    if(blEnabel == YES)
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


//阅读协议
-(void)actionToReadProtocol:(id)sender
{
    WebViewController* pWebControl = [[WebViewController alloc] init];
    pWebControl.m_strViewTitle = @"叮叮理财协议";
    pWebControl.m_strWebUrl = [NSString stringWithFormat:@"%@/website/apis/m_user_agreement.html",[UaConfiguration sharedInstance].m_strSoapRequestUrl_1];
    pWebControl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:pWebControl animated:YES];
}


#pragma UITableViewDataSource,UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < 2) {
        return 50;
    }
    return 130;
}



-(UITableViewCell*)getLoginTextFieldCell:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath
{
    NSString* strLoginTextFieldCellId = @"LoginTextFieldCellId";
    UITableViewCell *pCellObj = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:strLoginTextFieldCellId];
    if (!pCellObj)
    {
        pCellObj = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strLoginTextFieldCellId];
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
        UIImageView *pLogoImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
        pLogoImgView.tag = 1002;
        [pBackView addSubview:pLogoImgView];
        
        
        UITextField* pTextField = [[UITextField alloc]initWithFrame:CGRectMake(40, 5, self.view.frame.size.width-70, 30)];
        pTextField .font =[UIFont systemFontOfSize:14.0];
        pTextField.tag = 1003;
        pTextField.borderStyle = UITextBorderStyleNone;
        pTextField.keyboardType = UIKeyboardTypeDefault;
        pTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        //pTextField.placeholder = @"请输入密码";
       // pTextField.secureTextEntry = YES;
        pTextField.contentHorizontalAlignment  = UIControlContentHorizontalAlignmentCenter;
        pTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        //pTextField.delegate =self;
        pTextField.returnKeyType = UIReturnKeyDone;
        [pTextField addTarget:self action:@selector(actionTextFieldEditingDidEndExit:) forControlEvents:UIControlEventEditingDidEndOnExit];
        [pTextField addTarget:self action:@selector(actionTextFieldEditingDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
        [pTextField addTarget:self action:@selector(actionTextFieldEditingDidEnd:) forControlEvents:UIControlEventEditingDidEnd];
      //  [m_uiInputPwdField addTarget:self action:@selector(actionTextFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
        
        [pBackView addSubview:pTextField];
        
        
    }
    
    UITextField* pTextField = (UITextField*)[pCellObj.contentView viewWithTag:1003];
    UIImageView* pLogoImgView = (UIImageView*)[pCellObj.contentView viewWithTag:1002];
    if(pTextField == nil || pLogoImgView == nil)
        return pCellObj;
    if(indexPath.row == 0)
    {
        pTextField.placeholder = @"请输入您的手机号码";
        m_strInputPhoneNum = [UaConfiguration sharedInstance].m_setLoginState.m_strUserLoginName;
        pTextField.text = m_strInputPhoneNum;
        pLogoImgView.image = [UIImage imageNamed:@"icon_phone.png"];
        pTextField.keyboardType = UIKeyboardTypeDecimalPad;
    }
    else
    {
        pTextField.secureTextEntry = YES;
        pTextField.placeholder = @"请输入您的登录密码";
        pLogoImgView.image = [UIImage imageNamed:@"icon_password.png"];
        pTextField.keyboardType = UIKeyboardTypeDefault;
        
    }
    
    return pCellObj;
}


-(UITableViewCell*)getLoginBtnTableCell:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath
{
    NSString* strLoginBtnTableCellId = @"LoginBtnTableCellId";
    UITableViewCell *pCellObj = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:strLoginBtnTableCellId];
    if (!pCellObj)
    {
        pCellObj = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strLoginBtnTableCellId];
        pCellObj.contentView.backgroundColor = [UIColor whiteColor];
        pCellObj.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        //使用协议
        UIButton* pButton = [UIButton buttonWithType:UIButtonTypeCustom];
        pButton.frame = CGRectMake(10, 10, 40, 30);
        pButton.tag = 3001;
        [pButton addTarget:self action:@selector(actionUsedProtocolClicked:) forControlEvents:UIControlEventTouchUpInside];
        [pCellObj.contentView addSubview:pButton];
        
        //使用协议的选中图标
        UIImageView* pImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 7, 20, 20)];
        pImageView.image = [UIImage imageNamed:@"checkbox_nil.png"];
        pImageView.tag = 2001;
        [pButton addSubview:pImageView];
        
        //阅读协议的选择框点击处理
        pButton = [UIButton buttonWithType:UIButtonTypeCustom];
        pButton.frame = CGRectMake(40, 10, 160, 35);
        pButton.tag = 3002;
        [pButton addTarget:self action:@selector(actionToReadProtocol:) forControlEvents:UIControlEventTouchUpInside];
        [pCellObj.contentView addSubview:pButton];
        
        
        //具体协议的部分
        UILabel* pLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 7, 160, 20)];
        pLabel.backgroundColor = [UIColor clearColor];
        pLabel.textColor = COLOR_FONT_1;
        pLabel.textAlignment = UITextAlignmentLeft;
        pLabel.font = [UIFont systemFontOfSize:14];
        pLabel.text = @"已阅读叮叮理财使用条款";
        pLabel.tag = 1001;
        
        [pButton addSubview:pLabel];
        
        //下划线
        int iLength = pLabel.text.length*14;
        UIImageView*pLineView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 23, iLength, 0.5)];
        pLineView.backgroundColor = COLOR_FONT_1;
        pLineView.tag = 2002;
        [pButton addSubview:pLineView];
        
        //忘记密码
        pButton = [UIButton buttonWithType:UIButtonTypeCustom];
        pButton.frame = CGRectMake(205, 10, 95, 38);
        pButton.tag = 3003;
        [pButton addTarget:self action:@selector(actionForgotPwdClicked:) forControlEvents:UIControlEventTouchUpInside];
        [pCellObj.contentView addSubview:pButton];
        
        //提示的label
        pLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,10, 95, 16)];
        pLabel.backgroundColor = [UIColor clearColor];
        pLabel.textColor = COLOR_FONT_6;
        
        pLabel.font = [UIFont systemFontOfSize:14.0f];
        pLabel.numberOfLines = 0;
        pLabel.textAlignment  = UITextAlignmentRight;
        pLabel.tag = 1002;
        pLabel.text = @"忘记密码";
        [pButton addSubview:pLabel];
        //下划线
        pLineView = [[UIImageView alloc] initWithFrame:CGRectMake(40, 26, 55, 0.5)];
        pLineView.backgroundColor = COLOR_FONT_6;
        [pButton addSubview:pLineView];
        
        //
        pButton = [UIButton buttonWithType:UIButtonTypeCustom];
        pButton.frame = CGRectMake(10, 50, self.view.frame.size.width-20, 35);
        pButton.tag = 3004;
        pButton.enabled = YES;
        [UIOwnSkin setButtonBackground:pButton andColor:COLOR_BTN_BORDER_1];
        [pButton setTitle:@"登录" forState:UIControlStateNormal];
        [pButton addTarget:self action:@selector(actionLoginClicked:) forControlEvents:UIControlEventTouchUpInside];
        [pCellObj.contentView addSubview:pButton];
        
        
    }
    return pCellObj;
}

#pragma mark -UITableView delegate and datasource

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(m_uiCurEditingField != nil)
    {
        [m_uiCurEditingField resignFirstResponder];
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *pCellObj = nil;
    if(indexPath.row < 2)
    {
        pCellObj = [self getLoginTextFieldCell:tableView indexPath:indexPath];
        
    }
    else
    {
        pCellObj = [self getLoginBtnTableCell:tableView indexPath:indexPath];
    }
    return pCellObj;
    
}

@end
