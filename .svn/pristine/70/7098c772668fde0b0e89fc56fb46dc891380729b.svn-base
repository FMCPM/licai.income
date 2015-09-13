//
//  UserRegisterViewController.m
//  叮叮理财 - 注册
//
//  Created by lzq on 2014-11-27.
//
//

#import "UserRegisterViewController.h"
#import "GlobalDefine.h"
#import "CKHttpHelper.h"
#import "UaConfiguration.h"
#import "UIColor+Hex.h"
#import "UIOwnSkin.h"
#import "LoginViewController.h"
#import "JsonXmlParserObj.h"
#import "WebViewController.h"

@interface UserRegisterViewController ()

@end

@implementation UserRegisterViewController
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
    self.navigationItem.titleView  = [UIOwnSkin navibarTitleView:@"填写手机号" andFrame:CGRectMake(0, 0, 100, 40)];
    //左边返回按钮
    self.navigationItem.leftBarButtonItem = [UIOwnSkin backItemTarget:self action:@selector(backNavButtonAction:)];
    
    self.view.backgroundColor = [UIColor whiteColor];
    //_uiMainTableView.scrollEnabled = NO;
    m_blSelProtocol = NO;
    m_strUserPhoneNum = @"";
    m_strUserPwd1  = @"";
    m_strUserPwd2 = @"";
    m_strUserSignMsg = @"";
    m_uiCurEditingField = nil;
    m_pTapGesture = nil;
    _uiMainTableView = nil;
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
    if(_uiMainTableView != nil)
        return;
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
    [self registerForKeyboardNotifications];
    [self.view addSubview:_uiMainTableView];
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    //注销键盘事件
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

//注册键盘事件
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}



//键盘弹出时的相关处理
- (void)keyboardWillShow:(NSNotification*)aNotification
{
    UITableViewCell* pCellObj=  nil;
    
    if(m_uiCurEditingField != nil)
    {
        if (m_uiCurEditingField.isFirstResponder == false)
            return;
        pCellObj = [UIOwnSkin getSuperTableViewCell:m_uiCurEditingField];
    }

    
    if(pCellObj == nil)
        return;
    
    if(m_pTapGesture == nil)
    {
        m_pTapGesture  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenKeyBoard)];
        [self.view addGestureRecognizer:m_pTapGesture];
    }
    
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    CGPoint point = CGPointMake(0, 0);
    if(m_uiCurEditingField != nil)
    {
        point = [pCellObj convertPoint:CGPointMake(0, m_uiCurEditingField.frame.size.height + m_uiCurEditingField.frame.origin.y) toView:_uiMainTableView];
    }
    
    CGFloat activeOffset = point.y - _uiMainTableView.contentOffset.y;
    CGFloat kbOffset = self.view.frame.size.height -kbSize.height;
    
    m_offsetToMove = 0;
    if (activeOffset > kbOffset)
    {
        m_offsetToMove = activeOffset - kbOffset + 10;
        [_uiMainTableView setContentOffset:CGPointMake(0, _uiMainTableView.contentOffset.y + m_offsetToMove) animated:YES];

    }
    
}
-(void)hiddenKeyBoard
{
    if(m_uiCurEditingField)
    {
        [m_uiCurEditingField resignFirstResponder];
    }

}
// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{

    if(m_uiCurEditingField)
    {
        [m_uiCurEditingField resignFirstResponder];
        m_uiCurEditingField = nil;
    }
    if(m_pTapGesture != nil)
    {
        [self.view removeGestureRecognizer:m_pTapGesture];
        m_pTapGesture  = nil;
    }
    if(m_offsetToMove == 0)
        return ;
    
    [_uiMainTableView setContentOffset:CGPointMake(0, _uiMainTableView.contentOffset.y - m_offsetToMove) animated:YES];
    m_offsetToMove = 0;
    
}

//点击叮叮适用协议条款
-(void)actionUsedProtocolClicked:(id)sender
{
    if(m_uiCurEditingField)
    {
        [m_uiCurEditingField resignFirstResponder];
    }
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:4 inSection:0];
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
    bool blEnable = NO;
    if(m_blSelProtocol == YES && m_strUserSignMsg.length > 0)
        blEnable = YES;
    [self setRegButtonTypeShow:blEnable];
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

//点击下一步
-(void)actionNextStepClicked:(id)sender
{
    
    
    //一、手机号码验证
    if(m_strUserPhoneNum.length < 1)
    {
        [SVProgressHUD showErrorWithStatus:@"请输入您的手机号码！" duration:1.8];
        return;
    }
    NSString* phoneRegex = @"\\d{7,20}";
    NSPredicate *phoneTest  = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    if([phoneTest evaluateWithObject:m_strUserPhoneNum] == NO)
    {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号码！"];
        return ;
    }
    //二、密码
    if(m_strUserPwd1.length < 1)
    {
        [SVProgressHUD showErrorWithStatus:@"请输入登录密码！" duration:1.8];
        return;
    }
    //三、确认密码
    if(m_strUserPwd2.length < 1)
    {
        [SVProgressHUD showErrorWithStatus:@"请输入确认密码！" duration:1.8];
        return;
    }
    if([m_strUserPwd1 isEqual:m_strUserPwd2] == NO)
    {
        [SVProgressHUD showErrorWithStatus:@"两次输入的密码不一致！" duration:1.8];
        return;
    }
    //四、验证码
    if(m_strUserSignMsg.length < 1)
    {
        [SVProgressHUD showErrorWithStatus:@"请输入验证码！" duration:1.8];
        return;
        
    }
    
    //五、判断验证码是否一致
    if([m_strServerSignMsg isEqualToString:m_strUserSignMsg] == NO)
    {
        [SVProgressHUD showErrorWithStatus:@"您输入的验证码不正确，请重新输入！" duration:1.8];
        return;
        
    }
    
    if(m_blSelProtocol == NO)
    {
        [SVProgressHUD showErrorWithStatus:@"请阅读叮叮理财使用条款！" duration:1.8];
        return;
    }
    //
    CKHttpHelper *httpHelper = [CKHttpHelper httpHelperWithOwner:self];
    httpHelper.m_iWebServerType =1;
    httpHelper.methodType = CKHttpMethodTypePost_Page;
    [httpHelper setMethodName:@"memberInfo/registeMember"];
    [httpHelper addParam:m_strUserPhoneNum forName:@"tmember.mobilePhone"];
    [httpHelper addParam:m_strUserPwd1 forName:@"tmember.password"];
    //设备类型 1:安卓 2 ios
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
         if([pJsonObj getOpeResult] == NO)
         {
             [SVProgressHUD showErrorWithStatus:@"注册失败！" duration:1.8];
             return;
         }
         QDataSetObj* pDataSet = [pJsonObj parsetoDataSet:@"data"];
         if(pDataSet == nil)
             return;
         if(m_uiSignButton != nil)
         {
             [m_uiSignButton stopWait];
         }
         [UaConfiguration sharedInstance].m_setLoginState.m_strUserLoginName = m_strUserPhoneNum;
         [UaConfiguration sharedInstance].m_setLoginState.m_strUserLoginPwd = m_strUserPwd1;
         [SVProgressHUD showSuccessWithStatus:@"注册成功！" duration:1.8];
         LoginViewController* pLoginView = [[LoginViewController alloc] init];
         pLoginView.hidesBottomBarWhenPushed = YES;
         [self.navigationController pushViewController:pLoginView animated:YES];
         
        // [self.navigationController popToRootViewControllerAnimated:YES];

     }];
    
    [httpHelper startWithStartBlock:^{
        [SVProgressHUD showWithStatus:HINT_WEBDATA_SUBMITING];
    }];

    
    
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
        m_strUserPhoneNum = strText;
    }
    else if(indexPath.row == 1)
    {
        m_strUserPwd1 = strText;
    }
    else if(indexPath.row == 2)
    {
        m_strUserPwd2 = strText;
    }
    else
    {
        m_strUserSignMsg = strText;
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
    if(indexPath.row != 3)//验证码
    {
        return;
    }
    bool blEnabel = NO;
    if(pTextField.text.length > 0 && m_blSelProtocol == YES)
    {
        blEnabel = YES;
   
    }
    [self setRegButtonTypeShow:blEnabel];
    /*
    NSIndexPath* regBtnIndex = [NSIndexPath indexPathForRow:4 inSection:0];
    UITableViewCell* pBtnCellObj = [_uiMainTableView cellForRowAtIndexPath:regBtnIndex];
    if(pBtnCellObj == nil)
        return;
    UIButton* pRegButton = (UIButton*)[pBtnCellObj.contentView viewWithTag:3003];
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
    }*/
}

-(void)setRegButtonTypeShow:(bool)blEnabel
{
    NSIndexPath* regBtnIndex = [NSIndexPath indexPathForRow:4 inSection:0];
    UITableViewCell* pBtnCellObj = [_uiMainTableView cellForRowAtIndexPath:regBtnIndex];
    if(pBtnCellObj == nil)
        return;
    UIButton* pRegButton = (UIButton*)[pBtnCellObj.contentView viewWithTag:3003];
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

 //获取验证码
-(void)actionGetSignMessageClicked:(id)sender
{
  //  [SVProgressHUD showSuccessWithStatus:@"测试：验证码已发送，请查收！" duration:1.8];

    [self hiddenKeyBoard];
    if(m_strUserPhoneNum.length < 11)
    {
        [SVProgressHUD showErrorWithStatus:@"请输入手机号码！" duration:1.8];
        return;
    }
    //
    CKHttpHelper *httpHelper = [CKHttpHelper httpHelperWithOwner:self];
    httpHelper.m_iWebServerType =1;
    httpHelper.methodType = CKHttpMethodTypePost_Page;
    [httpHelper setMethodName:@"memberInfo/queryCheckNum"];
    [httpHelper addParam:m_strUserPhoneNum forName:@"tmember.mobilePhone"];
    
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
    if(indexPath.row < 4)
        return 50;
    return 130;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

-(UITableViewCell*)getRegTextFieldTableCell:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath
{
    static NSString *strRegTextFieldTableCellId = @"RegTextFieldTableCellId";
    UITableViewCell *pCellObj = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:strRegTextFieldTableCellId];
    if (!pCellObj) {
        pCellObj = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strRegTextFieldTableCellId];
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
    if(indexPath.row == 0)
    {
        pLogoImgView.image = [UIImage imageNamed:@"icon_phone.png"];
        pTextField.placeholder = @"手机号码";
        pTextField.secureTextEntry = NO;
        pTextField.keyboardType = UIKeyboardTypeDecimalPad;
    }
    else if(indexPath.row == 1)
    {
        pLogoImgView.image = [UIImage imageNamed:@"icon_password.png"];
        pTextField.placeholder = @"登录密码";
        pTextField.secureTextEntry = YES;
        pTextField.keyboardType = UIKeyboardTypeDefault;
    }
    else if(indexPath.row == 2)
    {
        pLogoImgView.image = [UIImage imageNamed:@"icon_password.png"];
        pTextField.placeholder = @"确认密码";
        pTextField.secureTextEntry = YES;
        pTextField.keyboardType = UIKeyboardTypeDefault;
    }
    
    return pCellObj;
}


//短信验证码
-(UITableViewCell*)getRegSignMessageCell:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath
{
    static NSString *strRegSignMessageCellId = @"RegSignMessageCellId";
    UITableViewCell *pCellObj = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:strRegSignMessageCellId];
    if (!pCellObj) {
        pCellObj = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strRegSignMessageCellId];
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
-(UITableViewCell*)getRegNowButtonCell:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath
{
    static NSString *strRegNowButtonCellId = @"RegNowButtonCellId";
    UITableViewCell *pCellObj = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:strRegNowButtonCellId];
    if (!pCellObj) {
        pCellObj = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strRegNowButtonCellId];
        pCellObj.selectionStyle = UITableViewCellSelectionStyleNone;
        
         //使用协议
        UIButton* pButton = [UIButton buttonWithType:UIButtonTypeCustom];
        pButton.frame = CGRectMake(10, 20, 40, 35);
        pButton.tag = 3001;
        [pButton addTarget:self action:@selector(actionUsedProtocolClicked:) forControlEvents:UIControlEventTouchUpInside];
        [pCellObj.contentView addSubview:pButton];
        
        //使用协议的选中图标
        UIImageView* pImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 7, 20, 20)];
        pImageView.image = [UIImage imageNamed:@"checkbox_nil.png"];
        pImageView.tag = 2001;
        [pButton addSubview:pImageView];
        
        //阅读协议
        pButton = [UIButton buttonWithType:UIButtonTypeCustom];
        pButton.frame = CGRectMake(45, 20, 240, 35);
        pButton.tag = 3002;
        [pButton addTarget:self action:@selector(actionToReadProtocol:) forControlEvents:UIControlEventTouchUpInside];
        [pCellObj.contentView addSubview:pButton];
        
        UILabel* pLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 7, 230, 20)];
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
        
        //注册按钮
        pButton = [UIButton buttonWithType:UIButtonTypeCustom];
        pButton.frame = CGRectMake(10, 70, 300, 35);
        pButton.tag = 3003;
        [UIOwnSkin setButtonBackground:pButton andColor:COLOR_BTN_BORDER_1];
        pButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [pButton setTitle:@"注册" forState:UIControlStateNormal];
        [pButton addTarget:self action:@selector(actionNextStepClicked:) forControlEvents:UIControlEventTouchUpInside];
        pButton.enabled = NO;
        [pCellObj.contentView addSubview:pButton];
        
    }
    
    return pCellObj;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell* pCellObj = nil;
    if(indexPath.row  < 3)
    {
        pCellObj = [self getRegTextFieldTableCell:tableView indexPath:indexPath];
    }
    else if(indexPath.row == 3)
    {
        pCellObj = [self getRegSignMessageCell:tableView indexPath:indexPath];
    }
    else if(indexPath.row == 4)
    {
        pCellObj = [self getRegNowButtonCell:tableView indexPath:indexPath];
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
