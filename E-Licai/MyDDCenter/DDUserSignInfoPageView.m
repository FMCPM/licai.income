//
//  DDUserSignInfoPageView.m

//  我的叮叮 - 身份信息确认
//
//  Created on 2014-11-20.
//

#import "DDUserSignInfoPageView.h"
#import "UaConfiguration.h"
#import "UIOwnSkin.h"
#import "DdBillDetailTableCell.h"
#import "GlobalDefine.h"
#import "JsonXmlParserObj.h"
#import "DDAddBankCardPageInfo.h"

@interface DDUserSignInfoPageView ()

@end

@implementation DDUserSignInfoPageView

@synthesize m_uiMainTableView = _uiMainTableView;
;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}


- (void)viewDidLoad
{
  
    self.navigationController.navigationBar.translucent = NO;

    //标题
    self.navigationItem.titleView = [UIOwnSkin navibarTitleView:@"身份信息确认" andFrame:CGRectMake(0, 0, 100, 40)];
    
    //左边返回按钮
    self.navigationItem.leftBarButtonItem = [UIOwnSkin backItemTarget:self action:@selector(backNavButtonAction:)];
    _uiMainTableView = nil;
    
    self.view.backgroundColor = COLOR_BAR_BACKGROUND;
    [self registerForKeyboardNotifications];
    [super viewDidLoad];
    
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
    [self.view addSubview:_uiMainTableView];
    
  //  [self loadAllTypeBankInfo_Web];
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

//返回
-(void)backNavButtonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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

    if(m_pTapGesture == nil)
    {
        m_pTapGesture  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenKeyBoard)];
        [self.view addGestureRecognizer:m_pTapGesture];
    }
 /*不需要控制视图被键盘遮住的处理
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
  */
    
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
    
    [self hiddenKeyBoard];
    if(m_pTapGesture != nil)
    {
        [self.view removeGestureRecognizer:m_pTapGesture];
        m_pTapGesture  = nil;
    }

    
}

//点击完成等结束编辑
-(void)actionTextFieldEditingDidEndExit:(id)sender
{
    UITextField* pTextField = (UITextField*)sender;
    if(pTextField == nil)
        return;
    [pTextField resignFirstResponder];

}

//开始编辑
-(void)actionTextFieldEditingDidBegin:(id)sender
{
    UITextField* pTextField = (UITextField*)sender;
    if(pTextField == nil)
        return;
    m_uiCurEditingField = pTextField;
}

//完成编辑
-(void)actionTextFieldEditingDidEnd:(id)sender
{
    UITextField* pTextField = (UITextField*)sender;
    if(pTextField == nil)
        return;
    [pTextField resignFirstResponder];
    
    if(pTextField.tag == 1001)
    {
        m_strUserReallyName = pTextField.text;
    }
    else
    {
        m_strUserCardId = pTextField.text;
    }
}


//
-(void)actionTextFieldEditingChanged:(id)sender
{
    UITextField* pTextField = (UITextField*)sender;
    if(pTextField == nil)
        return;

    bool blNext = NO;
    NSString* strText = pTextField.text;
    if(strText.length > 0)
    {
        if(pTextField.tag == 1001)
        {
            if(m_strUserCardId.length > 1)
                blNext = YES;
        }
        else
        {
            if(m_strUserReallyName.length > 1)
                blNext = YES;
        }
    }
    
    if(blNext == YES)
    {
        
        m_uiNextSubmitButton.enabled = YES;
        [UIOwnSkin setButtonBackground:m_uiNextSubmitButton];
    }
    else
    {
        m_uiNextSubmitButton.enabled = NO;
        [UIOwnSkin setButtonBackground:m_uiNextSubmitButton andColor:COLOR_BTN_BORDER_1];
    }
}


//保存身份证信息
-(void)actionInfoSignNextClicked:(id)sender
{
    [self hiddenKeyBoard];
    
    if(m_strUserReallyName.length < 1)
    {
        [SVProgressHUD showErrorWithStatus:@"请输入您的真实姓名！" duration:1.8];
        return;
    }
    

    if(m_strUserCardId.length < 1)
    {
        [SVProgressHUD showErrorWithStatus:@"请输入您的18位身份证号码！" duration:1.8];
        return;
    }
    
    if(m_strUserCardId.length != 18)
    {
        [SVProgressHUD showErrorWithStatus:@"请输入您的身份证号码位数有误！" duration:1.8];
        return;
    }
    
    CKHttpHelper*  pHttpHelper = [CKHttpHelper httpHelperWithOwner:self];
    pHttpHelper.m_iWebServerType = 1;
    pHttpHelper.methodType = CKHttpMethodTypePost_Page;
    //设置webservice方法名
    [pHttpHelper setMethodName:@"memberInfo/saveIdCard"];
    [pHttpHelper addParam:[NSString stringWithFormat:@"%d",[UaConfiguration sharedInstance].m_setLoginState.m_iUserMemberID] forName:@"memberId"];
    //身份证号码
    [pHttpHelper addParam:m_strUserCardId forName:@"tmember.idCardNo"];
    //姓名
    [pHttpHelper addParam:m_strUserReallyName forName:@"tmember.name"];
    
    [pHttpHelper setCompleteBlock:^(id dataSet)
     {
         
         [SVProgressHUD dismiss];
         JsonXmlParserObj* pJsonObj = dataSet;
         if(pJsonObj == nil)
         {
             
             [SVProgressHUD showErrorWithStatus:HINT_WEBDATA_NET_ERROR duration:1.8];
             return ;
         }
         /*
         if([pJsonObj getOpeResult] == NO)
         {
             [SVProgressHUD showErrorWithStatus:[pJsonObj getJsonValueByKey:@"message"] duration:1.8];
             return;
         }
          */
         [UaConfiguration sharedInstance].m_setLoginState.m_strUserReallyName = m_strUserReallyName;
         [UaConfiguration sharedInstance].m_setLoginState.m_strUserCardId = m_strUserCardId;
         [SVProgressHUD showSuccessWithStatus:@"身份信息验证成功！" duration:1.8];
         //下一步
         [self performSelector:@selector(stepToNextView) withObject:self afterDelay:1.6];

         
     }];
    
    [pHttpHelper setStartBlock:^{
        [SVProgressHUD showWithStatus:HINT_WEBDATA_LOADING];
    }];
    
    
    [pHttpHelper start];
}

//跳到下一步，银行卡页面
-(void)stepToNextView
{
    DDAddBankCardPageInfo* pAddBankView = [[DDAddBankCardPageInfo alloc] init];
    pAddBankView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:pAddBankView animated:YES];
}

#pragma UITableViewDataSource,UITableViewDelegate

//didSelectRowAtIndexPath
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{

}


//
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.row == 0)
    {
        return 70;
    }
    if(indexPath.row == 1)
    {
        return 80;
    }
    return 45;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

//顶部，添加提示信息的Cell
-(UITableViewCell *)getTopUserInfoSignHintCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strTopUserInfoSignHintCellId = @"TopUserInfoSignHintCellId";
    UITableViewCell *pCellObj = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:strTopUserInfoSignHintCellId];
    if (!pCellObj)
    {
        pCellObj = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strTopUserInfoSignHintCellId];
        pCellObj.contentView.backgroundColor =  [UIColor whiteColor];
        pCellObj.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //小太阳提示logo
        UIImageView*pHintImgView  = [[UIImageView alloc] initWithFrame:CGRectMake(10, 20, 20, 20)];
        pHintImgView.image = [UIImage imageNamed:@"icon_sun.png"];
        [pCellObj.contentView addSubview:pHintImgView];
        
       //具体的提示信息
        UILabel*pLabel = [[UILabel alloc]initWithFrame:CGRectMake(40,5, 270, 60)];
        pLabel.backgroundColor = [UIColor clearColor];
        pLabel.textColor = COLOR_FONT_1;
    
        pLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        pLabel.numberOfLines = 0;
        pLabel.textAlignment  = UITextAlignmentLeft;
        pLabel.tag = 1001;
        pLabel.text = @"监管部门规定，购买理财产品需提供实名信息以确保投资安全";
        [pCellObj.contentView addSubview:pLabel];
        
    }
    
    return pCellObj;

}

//具体选择银行，以及输入银行信息的Cell
-(UITableViewCell *)getUserSignInfoInputCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strUserSignInfoInputCellId = @"UserSignInfoInputCellId";
    UITableViewCell *pCellObj = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:strUserSignInfoInputCellId];
    if (!pCellObj)
    {
        pCellObj = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strUserSignInfoInputCellId];
        pCellObj.contentView.backgroundColor =  [UIColor whiteColor];
        pCellObj.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView* pBackView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width-20, 80)];
        pBackView.backgroundColor = COLOR_VIEW_BK_05;
        pBackView.layer.borderWidth = 1.0f;
        pBackView.layer.cornerRadius = 5.0f;
        pBackView.layer.borderColor = COLOR_BTN_BORDER_1.CGColor;
        
        [pCellObj.contentView addSubview:pBackView];
        
        //中间线
        UIImageView*pLineView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, 1)];
        pLineView.backgroundColor = COLOR_BTN_BORDER_1;
        [pBackView addSubview:pLineView];
        
        
        //用户的真实姓名
        UIImageView* pLogoImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 12, 16, 16)];
        pLogoImgView.image = [UIImage imageNamed:@"icon_form_user.png"];
        [pBackView addSubview:pLogoImgView];
   
        UITextField*pTextField = [[UITextField alloc] initWithFrame:CGRectMake(36, 5, self.view.frame.size.width-20-45, 30)];
        pTextField.font  = [UIFont systemFontOfSize:14];
        pTextField.textColor = COLOR_FONT_1;
        pTextField.textAlignment  = UITextAlignmentLeft;
        pTextField.tag  = 1001;
        pTextField.placeholder = @"请填写您的真实姓名";
        pTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;  //垂直居中
        
        [pTextField addTarget:self action:@selector(actionTextFieldEditingDidEnd:) forControlEvents:UIControlEventEditingDidEnd];
        [pTextField addTarget:self action:@selector(actionTextFieldEditingDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
        [pTextField addTarget:self action:@selector(actionTextFieldEditingDidEndExit:) forControlEvents:UIControlEventEditingDidEndOnExit];
        [pTextField addTarget:self action:@selector(actionTextFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
        [pBackView addSubview:pTextField];
        
        

        //身份证
        pLogoImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 52, 16, 16)];
        pLogoImgView.image = [UIImage imageNamed:@"icon_select_bank.png"];
        [pBackView addSubview:pLogoImgView];
        
        //输入
        pTextField = [[UITextField alloc] initWithFrame:CGRectMake(36, 45, self.view.frame.size.width-20-45, 30)];
        pTextField.font  = [UIFont systemFontOfSize:14];
        pTextField.textColor = COLOR_FONT_1;
        pTextField.textAlignment  = UITextAlignmentLeft;
        pTextField.tag  = 1002;
        pTextField.placeholder = @"请填写18位身份证号码";
        pTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;  //垂直居中
        pTextField.keyboardType = UIKeyboardTypeDefault;
        pTextField.returnKeyType = UIReturnKeyDone;
        
        [pTextField addTarget:self action:@selector(actionTextFieldEditingDidEnd:) forControlEvents:UIControlEventEditingDidEnd];
        [pTextField addTarget:self action:@selector(actionTextFieldEditingDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
        [pTextField addTarget:self action:@selector(actionTextFieldEditingDidEndExit:) forControlEvents:UIControlEventEditingDidEndOnExit];
         [pTextField addTarget:self action:@selector(actionTextFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    
        [pBackView addSubview:pTextField];
        
    }

    return pCellObj;
}


//添加银行卡确认的button的Cell
-(UITableViewCell *)getSignNextButtonCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strSignNextButtonCellId = @"SignNextButtonCellId";
    UITableViewCell *pCellObj = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:strSignNextButtonCellId];
    if (!pCellObj)
    {
        pCellObj = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strSignNextButtonCellId];
        pCellObj.selectionStyle = UITableViewCellSelectionStyleNone;
        pCellObj.backgroundColor = [UIColor whiteColor];
        
        //
        UIButton* pButton = [UIButton buttonWithType:UIButtonTypeCustom];
        pButton.frame = CGRectMake(10, 10, self.view.frame.size.width-20, 35);
        pButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [pButton setTitle:@"下一步" forState:UIControlStateNormal];
        pButton.enabled = NO;
        pButton.tag = 3001;
        [UIOwnSkin setButtonBackground:pButton andColor:COLOR_BTN_BORDER_1];
        [pButton addTarget:self action:@selector(actionInfoSignNextClicked:) forControlEvents:UIControlEventTouchUpInside];
        m_uiNextSubmitButton = pButton;
        [pCellObj.contentView addSubview:pButton];
        
    }
    //信息设置
    
    return pCellObj;
}

//
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *pCellObj = nil;
    if(indexPath.row == 0)
    {
        pCellObj = [self getTopUserInfoSignHintCell:tableView cellForRowAtIndexPath:indexPath];
    }
    else if(indexPath.row == 1)
    {
        pCellObj = [self getUserSignInfoInputCell:tableView cellForRowAtIndexPath:indexPath];
    }
    else if(indexPath.row == 2 )
    {
        pCellObj = [self getSignNextButtonCell:tableView cellForRowAtIndexPath:indexPath];
    }
    return pCellObj;
}


@end
