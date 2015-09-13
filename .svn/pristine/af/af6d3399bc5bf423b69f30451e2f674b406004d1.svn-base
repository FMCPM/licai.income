//
//  DDChangeTradePassword.m
//  E-YellowPage
//
//  Created by jiangjunchen on 13-4-22.
//  Copyright (c) 2013年 ytinfo. All rights reserved.
//

#import "DDChangeTradePassword_1.h"
#import "CustomViews.h"
#import "UaConfiguration.h"
#import "GlobalDefine.h"
#import "UIColor+Hex.h"
#import "UIOwnSkin.h"
#import "CKHttpHelper.h"
#import "DDChangeTradePassword_2.h"
#import "JsonXmlParserObj.h"

@interface DDChangeTradePassword_1 ()

@end

@implementation DDChangeTradePassword_1

@synthesize m_uiPwdTableView = _uiPwdTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)dealloc
{

}

- (void)viewDidLoad
{
    
	self.navigationController.navigationBar.translucent = NO;
	self.navigationItem.titleView = [UIOwnSkin navibarTitleView:@"修改交易密码" andFrame:CGRectMake(0, 0, 100, 40)];
    self.navigationItem.leftBarButtonItem = [UIOwnSkin backItemTarget:self action:@selector(backNavButtonAction:)];
    
	self.view.backgroundColor = COLOR_VIEW_BACKGROUND;
    _uiPwdTableView = nil;
    m_pCurEditingField = nil;
    m_offsetToMove = 0;
    
    m_uiSignButton  = nil;
    //注册键盘事件
    [self registerForKeyboardNotifications];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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


-(void)viewDidAppear:(BOOL)animated
{
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
   // [self setM_passwordTable:nil];
    [super viewDidUnload];
}


- (void)backNavButtonAction:(UIButton *)sender
{
    if(m_uiSignButton != nil)
    {
        [m_uiSignButton stopWait];
    }
    [self.navigationController popViewControllerAnimated:YES];
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
    NSString* strText = pTextField.text;
    int iCellRow = indexPath.row;
    if(iCellRow == 0)
    {
        m_strUserRealName = strText;
    }
    else if(iCellRow == 1)
    {
        m_strUserCardNumber = strText;
        
    }
    else if(iCellRow == 2)
    {
        m_strUserMobileNum = strText;
    }
    else
    {
        m_strUserSignMessage = strText;
        
    }
    [self setTextFieldBorderColor:pTextField andFlag:0];
    m_pCurEditingField = nil;
        
}


-(void)actionTextFieldEditingDidEndExit:(id)sender
{
    [sender resignFirstResponder];
    if(m_pCurEditingField != nil)
    {
        [self setTextFieldBorderColor:m_pCurEditingField andFlag:0];
        m_pCurEditingField = nil;
    }
    
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
    UITextField* pTextField = (UITextField*)sender;
    if(pTextField == nil)
        return;
    UITableViewCell*  pCellObj = [UIOwnSkin getSuperTableViewCell:sender];
    if(pCellObj == nil)
        return;
    NSIndexPath* indexPath = [_uiPwdTableView indexPathForCell:pCellObj];
    if(indexPath == nil)
        return;
    if(indexPath.row != 3)//验证码
    {
        return;
    }
    NSIndexPath* regBtnIndex = [NSIndexPath indexPathForRow:4 inSection:0];
    UITableViewCell* pBtnCellObj = [_uiPwdTableView cellForRowAtIndexPath:regBtnIndex];
    if(pBtnCellObj == nil)
        return;
    UIButton* pRegButton = (UIButton*)[pBtnCellObj.contentView viewWithTag:1001];
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

//获取短息验证码
-(void)actionGetSignMessageClicked:(id)sender
{
    [self hiddenKeyBoard];
    if(m_strUserMobileNum.length < 11)
    {
        [SVProgressHUD showErrorWithStatus:@"请输入手机号码！" duration:1.8];
        return;
    }
    
    //
    CKHttpHelper *httpHelper = [CKHttpHelper httpHelperWithOwner:self];
    httpHelper.m_iWebServerType =1;
    httpHelper.methodType = CKHttpMethodTypePost_Page;
    [httpHelper setMethodName:@"memberInfo/queryCheckNum"];
    [httpHelper addParam:m_strUserMobileNum forName:@"tmember.mobilePhone"];
    
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

//下一步
-(void)actionNextStepClicked:(id)sender
{
    [self hiddenKeyBoard];
    if(m_strUserRealName.length < 1)
    {
        [SVProgressHUD showErrorWithStatus:@"请输入您的姓名！" duration:1.8];
        return;
    }
    
    if(m_strUserCardNumber.length < 1)
    {
        [SVProgressHUD showErrorWithStatus:@"请输入您的18位身份证号码！" duration:1.8];
        return;
    }
    
    if(m_strUserCardNumber.length < 1)
    {
        [SVProgressHUD showErrorWithStatus:@"请输入您的18位身份证号码！" duration:1.8];
        return;
    }
    
    if(m_strUserCardNumber.length < 18)
    {
        [SVProgressHUD showErrorWithStatus:@"您输入的身份证号码位数不正确！" duration:1.8];
        return;
    }
    
    
    if(m_strUserMobileNum.length < 1)
    {
        [SVProgressHUD showErrorWithStatus:@"您输入的身手机号码！" duration:1.8];
        return;
    }
 
    NSString* phoneRegex = @"\\d{7,20}";
    NSPredicate *phoneTest  = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    if([phoneTest evaluateWithObject:m_strUserMobileNum] == NO)
    {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号码！"];
        return ;
    }

    if(m_strUserSignMessage.length < 1)
    {
        [SVProgressHUD showErrorWithStatus:@"请输入您收到的验证码！"];
        return ;
    }
    
    if([m_strUserSignMessage isEqualToString:m_strServerSignMsg] == NO)
    {
        [SVProgressHUD showErrorWithStatus:@"您输入的验证码不正确，请重新输入！" duration:1.8];
        return ;
    }

    CKHttpHelper *httpHelper = [CKHttpHelper httpHelperWithOwner:self];
    httpHelper.m_iWebServerType =1;
    httpHelper.methodType = CKHttpMethodTypePost_Page;
    [httpHelper setMethodName:@"memberInfo/chageTradPwdCheck"];
    
    [httpHelper addParam:m_strUserRealName forName:@"tmember.name"];
    [httpHelper addParam:m_strUserCardNumber forName:@"tmember.idCardNo"];
    [httpHelper addParam:m_strUserMobileNum forName:@"tmember.mobilePhone"];
    [httpHelper addParam:[NSString stringWithFormat:@"%d",[UaConfiguration sharedInstance].m_setLoginState.m_iUserMemberID] forName:@"memberId"];
    
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
         
         if([pDataObj getOpeResult] == NO)
         {
             NSString* strErrorMsg = [pDataObj getFeildValue:0 andColumn:@"message"];
             [SVProgressHUD showErrorWithStatus:strErrorMsg duration:1.8];
             return;
         }
         if(m_uiSignButton != nil)
         {
             [m_uiSignButton stopWait];
         }
         DDChangeTradePassword_2* pPasswordView2 = [[DDChangeTradePassword_2 alloc] init];
         pPasswordView2.m_iPasswordType = 2;
         pPasswordView2.hidesBottomBarWhenPushed = YES;
         [self.navigationController pushViewController:pPasswordView2 animated:YES];
         
     }];
    
    [httpHelper startWithStartBlock:^{
        [SVProgressHUD showWithStatus:HINT_WEBDATA_SUBMITING];
    }];
    
    

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
    
    if(m_pCurEditingField != nil)
    {
        if (m_pCurEditingField.isFirstResponder == false)
            return;
        pCellObj = [UIOwnSkin getSuperTableViewCell:m_pCurEditingField];
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
    if(m_pCurEditingField != nil)
    {
        point = [pCellObj convertPoint:CGPointMake(0, m_pCurEditingField.frame.size.height + m_pCurEditingField.frame.origin.y) toView:_uiPwdTableView];
    }
    
    CGFloat activeOffset = point.y - _uiPwdTableView.contentOffset.y;
    CGFloat kbOffset = self.view.frame.size.height -kbSize.height;
    
    m_offsetToMove = 0;
    if (activeOffset > kbOffset)
    {
        m_offsetToMove = activeOffset - kbOffset + 10;
        [_uiPwdTableView setContentOffset:CGPointMake(0, _uiPwdTableView.contentOffset.y + m_offsetToMove) animated:YES];
        
    }
    
}
-(void)hiddenKeyBoard
{
    if(m_pCurEditingField)
    {
        [m_pCurEditingField resignFirstResponder];
    }
    
}
// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    
    if(m_pCurEditingField)
    {
        [m_pCurEditingField resignFirstResponder];
        m_pCurEditingField = nil;
    }
    if(m_pTapGesture != nil)
    {
        [self.view removeGestureRecognizer:m_pTapGesture];
        m_pTapGesture  = nil;
    }
    if(m_offsetToMove == 0)
        return ;
    
    [_uiPwdTableView setContentOffset:CGPointMake(0, _uiPwdTableView.contentOffset.y - m_offsetToMove) animated:YES];
    m_offsetToMove = 0;
    
}


#pragma mark -UITableView delegate and datasource

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

-(UITableViewCell*)getTradePwdComInfoCell:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath
{
    static NSString *strTradePwdComInfoCellId = @"TradePwdComInfoCellId";
    UITableViewCell *pCellObj = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:strTradePwdComInfoCellId];
    if (!pCellObj) {
        pCellObj = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strTradePwdComInfoCellId];
        pCellObj.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *pBackView = [[UIView alloc]initWithFrame:CGRectMake(10, 10, self.view.frame.size.width - 20, 40)];
        pBackView.backgroundColor = [UIColor whiteColor];
        pBackView.layer.borderWidth = 1.0f;
        pBackView.layer.borderColor = COLOR_BTN_BORDER_1.CGColor;
        pBackView.layer.cornerRadius = 1.0f;
        pBackView.tag = 2001;
        [pCellObj.contentView addSubview:pBackView];
        
        //
        UITextField *pTextField = [[UITextField alloc]initWithFrame:CGRectMake(5, 5, self.view.frame.size.width-40, 30)];
        
        pTextField.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
        pTextField.tag = 1001;
        pTextField.font = [UIFont systemFontOfSize:14.0];
        pTextField.borderStyle = UITextBorderStyleNone;
        pTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        pTextField.keyboardType = UIKeyboardTypeDefault;
        pTextField.returnKeyType = UIReturnKeyDone;
        [pTextField addTarget:self action:@selector(actionTextFieldEditingDidEndExit:) forControlEvents:UIControlEventEditingDidEndOnExit];
        [pTextField addTarget:self action:@selector(actionTextFieldEditingDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
        [pTextField addTarget:self action:@selector(actionTextFieldEditingDidEnd:) forControlEvents:UIControlEventEditingDidEnd];
        [self setTextFieldBorderColor:pTextField andFlag:0];
        
        [pBackView addSubview:pTextField];
        
    }
    
    UITextField* pTextField = (UITextField*)[pCellObj.contentView viewWithTag:1001];
    if(pTextField == nil)
        return pCellObj;
    
    if(indexPath.row == 0)
    {
        pTextField.placeholder = @"真实姓名";
        pTextField.keyboardType = UIKeyboardTypeDefault;
        pTextField.returnKeyType = UIReturnKeyDone;
        pTextField.text = m_strUserRealName;
    }
    else if(indexPath.row == 1)
    {
        pTextField.placeholder = @"身份证号";
        pTextField.keyboardType = UIKeyboardTypeDefault;
        pTextField.returnKeyType = UIReturnKeyDone;
        pTextField.text = m_strUserCardNumber;
    }
    else if(indexPath.row == 2)
    {
        pTextField.placeholder = @"注册的手机号码";
        pTextField.keyboardType = UIKeyboardTypeNumberPad;
        pTextField.text = m_strUserMobileNum;
    }
    
    return pCellObj;
}


//短信验证码
-(UITableViewCell*)getTradeGetSignMessageCell:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath
{
    static NSString *strTradeGetSignMessageCellId = @"TradeGetSignMessageCellId";
    UITableViewCell *pCellObj = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:strTradeGetSignMessageCellId];
    if (!pCellObj) {
        pCellObj = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strTradeGetSignMessageCellId];
         pCellObj.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *pBackView = [[UIView alloc]initWithFrame:CGRectMake(10, 10, 150, 40)];
        pBackView.backgroundColor = [UIColor whiteColor];
        pBackView.layer.borderWidth = 1.0f;
        pBackView.layer.borderColor = COLOR_BTN_BORDER_1.CGColor;
        pBackView.layer.cornerRadius = 1.0f;
        pBackView.tag = 2001;
        [pCellObj.contentView addSubview:pBackView];
        
        
        //
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
        [self setTextFieldBorderColor:pTextField andFlag:0];
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
-(UITableViewCell*)getTradeNextStepCell:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath
{
    static NSString *strTradeNextStepCellId = @"TradeNextStepCellId";
    UITableViewCell *pCellObj = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:strTradeNextStepCellId];
    if (!pCellObj) {
        pCellObj = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strTradeNextStepCellId];
        pCellObj.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIButton* pButton = [UIButton buttonWithType:UIButtonTypeCustom];
        pButton.frame = CGRectMake(10, 10, 300, 35);
        pButton.tag = 1001;
        [UIOwnSkin setButtonBackground:pButton andColor:COLOR_BTN_BORDER_1];
        pButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [pButton setTitle:@"下一步" forState:UIControlStateNormal];
        [pButton addTarget:self action:@selector(actionNextStepClicked:) forControlEvents:UIControlEventTouchUpInside];
        [pCellObj.contentView addSubview:pButton];
        
    }
    
    return pCellObj;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell* pCellObj = nil;
    if(indexPath.row  < 3)
    {
        pCellObj = [self getTradePwdComInfoCell:tableView indexPath:indexPath];
    }
    else if(indexPath.row == 3)
    {
        pCellObj = [self getTradeGetSignMessageCell:tableView indexPath:indexPath];
    }
    else if(indexPath.row == 4)
    {
        pCellObj = [self getTradeNextStepCell:tableView indexPath:indexPath];
    }
	return pCellObj;
	
}



@end
