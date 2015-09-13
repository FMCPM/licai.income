//
//  DDBillLeftMoneyPageView.h

//  我的叮叮-账户余额-提现
//
//  Created  on 2014-11-20.
//

#import "DDBillGetCashPageView.h"
#import "UaConfiguration.h"
#import "UIOwnSkin.h"
#import "DdBillDetailTableCell.h"
#import "GlobalDefine.h"
#import "JsonXmlParserObj.h"
#import "ForgotPasswordView.h"

@interface DDBillGetCashPageView ()

@end

@implementation DDBillGetCashPageView

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
   // m_muImageListDic = [[NSMutableDictionary alloc]initWithCapacity:0];
    //标题
    self.navigationItem.titleView = [UIOwnSkin navibarTitleView:@"提现" andFrame:CGRectMake(0, 0, 100, 40)];
    
    //左边返回按钮
    self.navigationItem.leftBarButtonItem = [UIOwnSkin backItemTarget:self action:@selector(backNavButtonAction:)];
    _uiMainTableView = nil;
    m_fBalanceFee = 0.00f;
    m_strInputCashValue = @"0.00";
    m_strInputTradePwd = @"";
    
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
    //下载用户的余额等信息
    [self loadBillLeftInfo_Web];
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

    m_uiCurEditingField = pTextField;
}

//完成编辑
-(void)actionTextFieldEditingDidEnd:(id)sender
{
    UITextField* pTextField = (UITextField*)sender;
    if(pTextField == nil)
        return;
    if(pTextField.tag == 1001)
    {
        m_strInputCashValue = pTextField.text;
    }
    else
    {
        m_strInputTradePwd = pTextField.text;
    }
    m_uiCurEditingField = nil;
}


//
-(void)actionTextFieldEditingChanged:(id)sender
{
    UITextField* pTextField = (UITextField*)sender;
    if(pTextField == nil)
        return;

    NSIndexPath* regBtnIndex = [NSIndexPath indexPathForRow:6 inSection:0];
    UITableViewCell* pBtnCellObj = [_uiMainTableView cellForRowAtIndexPath:regBtnIndex];
    if(pBtnCellObj == nil)
        return;
    UIButton* pSubmitButton = (UIButton*)[pBtnCellObj.contentView viewWithTag:3001];
    if(pSubmitButton == nil)
        return;
    if(pTextField.text.length > 0)
    {
        
        pSubmitButton.enabled = YES;
        [UIOwnSkin setButtonBackground:pSubmitButton];
    }
    else
    {
        pSubmitButton.enabled = NO;
        [UIOwnSkin setButtonBackground:pSubmitButton andColor:COLOR_BTN_BORDER_1];
    }
}



//获取用户的银行卡等相关信息
-(void)loadUserBankCardInfo_Web
{

    
    if([UaConfiguration sharedInstance].m_setLoginState.m_strBankCardSno.length > 0)
    {
        [_uiMainTableView reloadData];
        return;
    }
    
    CKHttpHelper* pHttpHelper = [CKHttpHelper httpHelperWithOwner:self];
    pHttpHelper.m_iWebServerType = 1;
    pHttpHelper.methodType  = CKHttpMethodTypePost_Page;
    
    //专业市场的id
    [pHttpHelper setMethodName:[NSString stringWithFormat:@"memberInfo/queryUserBank"]];
    [pHttpHelper addParam:[NSString stringWithFormat:@"%d",[UaConfiguration sharedInstance].m_setLoginState.m_iUserMemberID] forName:@"memberId"];
 
    [pHttpHelper setCompleteBlock:^(id dataSet)
     {
         [SVProgressHUD dismiss];
         /*
         [UaConfiguration sharedInstance].m_setLoginState.m_strBankCardId = @"1";
         
         [UaConfiguration sharedInstance].m_setLoginState.m_strBankName = @"农业银行";
         
         [UaConfiguration sharedInstance].m_setLoginState.m_strBankCardSno = @"955805716234344";
         
         [UaConfiguration sharedInstance].m_setLoginState.m_pBankLogoImage = [UIImage imageNamed:@"banks_95599.png"];
         [_uiMainTableView reloadData];
         */
  
         JsonXmlParserObj* pJsonObj = dataSet;
         
         if(pJsonObj == nil)
         {
             [SVProgressHUD showErrorWithStatus:HINT_WEBDATA_NET_ERROR duration:1.8];
             [_uiMainTableView reloadData];
             return ;
         }
         QDataSetObj* pDataSet = [pJsonObj parsetoDataSet:@"data"];
         if(pDataSet == nil)
         {
             [_uiMainTableView reloadData];
             return;
         }
         [UaConfiguration sharedInstance].m_setLoginState.m_strBankCardId = [pDataSet getFeildValue:0 andColumn:@"bankId"];
         
          [UaConfiguration sharedInstance].m_setLoginState.m_strBankName = [pDataSet getFeildValue:0 andColumn:@"bankName"];
         
         [UaConfiguration sharedInstance].m_setLoginState.m_strBankCardSno = [pDataSet getFeildValue:0 andColumn:@"cardSno"];
         
         NSString* strImgUrl = [pDataSet getFeildValue:0 andColumn:@"logo"];
         strImgUrl = [NSString stringWithFormat:@"%@/web/banklogo/%@",[UaConfiguration sharedInstance].m_strSoapRequestUrl_1,strImgUrl];
         
         CKHttpImageHelper* pImageHelper = [CKHttpImageHelper httpHelperWithOwner:self];
         NSURL *nsImageReqUrl = [NSURL URLWithString:strImgUrl];
         [pImageHelper addImageUrl:nsImageReqUrl forKey:@"1"];
         
         [_uiMainTableView reloadData];
         [pImageHelper startWithReceiveBlock:^(UIImage *image,NSString *strKey,BOOL finsh)
          {
              [UaConfiguration sharedInstance].m_setLoginState.m_pBankLogoImage = image;
              
              NSIndexPath* indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
              UITableViewCell*pCellObj = [_uiMainTableView cellForRowAtIndexPath:indexPath];
              if(pCellObj)
              {
                  UIImageView* pLogoImgView = (UIImageView*)[pCellObj.contentView viewWithTag:2001];
                  if(pLogoImgView)
                      pLogoImgView.image = image;
              }
          }];

     }];
    
    [pHttpHelper setStartBlock:^{
        [SVProgressHUD showWithStatus:@"正在加载，请稍后..."];
    }];
    
    [pHttpHelper start];

    
}



//获取账号余额
-(void)loadBillLeftInfo_Web
{

    
    CKHttpHelper* pHttpHelper = [CKHttpHelper httpHelperWithOwner:self];
    pHttpHelper.m_iWebServerType = 1;
    pHttpHelper.methodType  = CKHttpMethodTypePost_Page;
    
    //
    [pHttpHelper setMethodName:@"memberInfo/queryMyAccount"];
    
    [pHttpHelper addParam:[NSString stringWithFormat:@"%d",[UaConfiguration sharedInstance].m_setLoginState.m_iUserMemberID] forName:@"memberId"];
    [pHttpHelper setCompleteBlock:^(id dataSet)
     {

         [SVProgressHUD dismiss];
         JsonXmlParserObj* pJsonObj = dataSet;
         
         if(pJsonObj == nil)
         {
             [SVProgressHUD showErrorWithStatus:HINT_WEBDATA_NET_ERROR duration:1.8];
             return ;
         }
         QDataSetObj* pDataSet = [pJsonObj parsetoDataSet:@"data"];
         if(pDataSet != nil)
         {
             NSString* strBalanceFee = [pDataSet getFeildValue:0 andColumn:@"balance"];
             m_fBalanceFee = [QDataSetObj convertToFloat:strBalanceFee];
         }
        // [_uiMainTableView reloadData];
         [self loadUserBankCardInfo_Web];
     }];
    
    [pHttpHelper setStartBlock:^{
        [SVProgressHUD showWithStatus:HINT_WEBDATA_LOADING];
    }];
    
    [pHttpHelper start];
    
}


//全额提现
-(void)actionGetAllCashClicked:(id)sender
{
    NSIndexPath* regBtnIndex = [NSIndexPath indexPathForRow:3 inSection:0];
    UITableViewCell* pBtnCellObj = [_uiMainTableView cellForRowAtIndexPath:regBtnIndex];
    if(pBtnCellObj == nil)
        return;
    UITextField* pTextField = (UITextField*)[pBtnCellObj.contentView viewWithTag:1001];
    if(pTextField == nil)
        return;
    pTextField.text = [NSString stringWithFormat:@"%.2f",m_fBalanceFee];
}

//提交提现请求
-(void)actionSubmitCashClicked:(id)sender
{
    [self hiddenKeyBoard];
    
    if(m_strInputCashValue.length < 1)
    {
        [SVProgressHUD showErrorWithStatus:@"请输入提现金额！" duration:1.8];
        return;
    }
    
    float fCashValue = [QDataSetObj convertToFloat:m_strInputCashValue];
    if(fCashValue < 0.009)
    {
        [SVProgressHUD showErrorWithStatus:@"提现金额格式不正确！" duration:1.8];
        return;
    }
    
    if(fCashValue > m_fBalanceFee)
    {
        [SVProgressHUD showErrorWithStatus:@"提现金额不能大于可用余额！" duration:1.8];
        return;
    }
    
    if(m_strInputTradePwd.length < 1)
    {
        [SVProgressHUD showErrorWithStatus:@"请输入交易密码！" duration:1.8];
        return;
    }
    
    CKHttpHelper* pHttpHelper = [CKHttpHelper httpHelperWithOwner:self];
    pHttpHelper.m_iWebServerType = 1;
    pHttpHelper.methodType  = CKHttpMethodTypePost_Page;
    
    //
    [pHttpHelper setMethodName:@"memberInfo/applyWithDraw"];
    
    [pHttpHelper addParam:m_strInputTradePwd forName:@"payPwd"];
    [pHttpHelper addParam:m_strInputCashValue forName:@"wdFee"];
    [pHttpHelper addParam:[NSString stringWithFormat:@"%d",[UaConfiguration sharedInstance].m_setLoginState.m_iUserMemberID] forName:@"memberId"];
    
    [pHttpHelper setCompleteBlock:^(id dataSet)
     {
         
         [SVProgressHUD dismiss];
         JsonXmlParserObj* pJsonObj = dataSet;
         if(pJsonObj == nil)
         {
             [SVProgressHUD showErrorWithStatus:HINT_WEBDATA_NET_ERROR duration:1.8];
             return ;
         }
         QDataSetObj* pDataSet = [pJsonObj parsetoDataSet:@"data"];
         if(pDataSet)
         {
             if([pDataSet getOpeResult] == NO)
             {
                 NSString* strMessage = [pDataSet getFeildValue:0 andColumn:@"message"];
                 [SVProgressHUD showErrorWithStatus:strMessage duration:1.8];
                 return;
             }
         }
         [SVProgressHUD showSuccessWithStatus:@"提现成功！" duration:1.8];
         [self performSelector:@selector(synStepToParentView) withObject:self afterDelay:1.8];
     }];
    
    [pHttpHelper setStartBlock:^{
        [SVProgressHUD showWithStatus:@"正在加载，请稍后..."];
    }];
    
    [pHttpHelper start];
    
}

-(void)synStepToParentView
{
    [self.navigationController popViewControllerAnimated:YES];
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
        return 105;
    }
    if(indexPath.row == 1 || indexPath.row == 3 || indexPath.row == 5)
    {
        return 50;
    }
    if(indexPath.row == 2 || indexPath.row == 4)
        return 40;
    return 120;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 7;
}

//顶部，银行信息的Cell
-(UITableViewCell *)getGetCashTopBarCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strGetCashTopBarCellId = @"GetCashTopBarCellId";
    UITableViewCell *pCellObj = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:strGetCashTopBarCellId];
    if (!pCellObj)
    {
        pCellObj = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strGetCashTopBarCellId];
        pCellObj.contentView.backgroundColor =  [UIColor whiteColor];
        pCellObj.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //背景
        UIView* pBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, 95)];
        pBarView.backgroundColor = COLOR_VIEW_BACKGROUND;
        [pCellObj.contentView addSubview:pBarView];
        
        //画上边线
        UIImageView*pLineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
        pLineView.backgroundColor = COLOR_CELL_LINE_DEFAULT;
        [pBarView addSubview:pLineView];
         //画下边线
        pLineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 94, self.view.frame.size.width, 1)];
        pLineView.backgroundColor = COLOR_CELL_LINE_DEFAULT;
        [pBarView addSubview:pLineView];
        
        
        
        //产品名称
        UILabel*pLabel = [[UILabel alloc]initWithFrame:CGRectMake(120,25, 170, 20)];
        pLabel.backgroundColor = [UIColor clearColor];
        pLabel.textColor = COLOR_FONT_1;
    
        pLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        pLabel.numberOfLines = 0;
        pLabel.textAlignment  = UITextAlignmentLeft;
        pLabel.tag = 1001;
        //pLabel.text = @"中国农业银行";
        [pCellObj.contentView addSubview:pLabel];
        
        //余额
        pLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 45, 100, 20)];
        pLabel.textAlignment  = UITextAlignmentLeft;
        pLabel.backgroundColor = [UIColor clearColor];
        pLabel.font = [UIFont systemFontOfSize:14.f];
        pLabel.textColor = COLOR_FONT_2;
        //pLabel.text = @"尾号2345";
        pLabel.tag = 1002;
        [pCellObj.contentView addSubview:pLabel];
        
        
        pLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 75, 280, 20)];
        pLabel.textAlignment  = UITextAlignmentCenter;
        pLabel.backgroundColor = [UIColor clearColor];
        pLabel.font = [UIFont systemFontOfSize:12.f];
        pLabel.textColor = COLOR_FONT_2;
        pLabel.text = @"提现银行卡为绑定的投资银行卡";
        pLabel.tag = 1003;
        [pCellObj.contentView addSubview:pLabel];
        
        //银行卡logo
        UIImageView* pBankImgView = [[UIImageView alloc] initWithFrame:CGRectMake(75, 25, 40, 40)];
       // pBankImgView.image = [UIImage imageNamed:@"banks_95599"];
        pBankImgView.tag = 2001;
        [pCellObj.contentView addSubview:pBankImgView];
        

    }
    
    UILabel*pLabel = (UILabel*)[pCellObj.contentView viewWithTag:1001];
    if(pLabel)
    {
        pLabel.text = [UaConfiguration sharedInstance].m_setLoginState.m_strBankName;
    }

    pLabel = (UILabel*)[pCellObj.contentView viewWithTag:1002];
    if(pLabel)
    {
        NSString* strBandCardSno = [UaConfiguration sharedInstance].m_setLoginState.m_strBankCardSno;
        if(strBandCardSno.length > 4)
        {
            int iIndex = strBandCardSno.length-4;
            strBandCardSno = [strBandCardSno substringFromIndex:iIndex];
        }
        pLabel.text = [NSString stringWithFormat:@"尾号为%@",strBandCardSno];
    }
    
    UIImageView* pLogoImgView = (UIImageView*)[pCellObj.contentView viewWithTag:2001];
    if(pLogoImgView)
    {
        pLogoImgView.image = [UaConfiguration sharedInstance].m_setLoginState.m_pBankLogoImage;
    }
    
    return pCellObj;

}

//可提现余额的cell
-(UITableViewCell *)getCanGetCashValueCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strCanGetCashValueCellId = @"CanGetCashValueCellId";
    UITableViewCell *pCellObj = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:strCanGetCashValueCellId];
    if (!pCellObj)
    {
        pCellObj = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strCanGetCashValueCellId];
        pCellObj.contentView.backgroundColor =  [UIColor whiteColor];
        pCellObj.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        //可用余额
        UILabel*pLabel = [[UILabel alloc]initWithFrame:CGRectMake(20,15, 120, 20)];
        pLabel.backgroundColor = [UIColor clearColor];
        pLabel.textColor = COLOR_FONT_1;
        
        pLabel.font = [UIFont systemFontOfSize:14.0f];
        pLabel.numberOfLines = 0;
        pLabel.textAlignment  = UITextAlignmentLeft;
        pLabel.tag = 1001;
        pLabel.text = @"可提现余额（元）";
        [pCellObj.contentView addSubview:pLabel];
        
        pLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 15, 120, 20)];
        pLabel.textAlignment  = UITextAlignmentRight;
        pLabel.backgroundColor = [UIColor clearColor];
        pLabel.font = [UIFont systemFontOfSize:14];
        pLabel.textColor = COLOR_FONT_2;
       // pLabel.text = @"10000";
        pLabel.tag = 1002;
        [pCellObj.contentView addSubview:pLabel];
        
        
        UIImageView*pLineView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 49, self.view.frame.size.width, 1)];
        pLineView.backgroundColor = COLOR_CELL_LINE_DEFAULT;
        [pCellObj.contentView addSubview:pLineView];
        
    }
    UILabel* pLabel = (UILabel*)[pCellObj.contentView viewWithTag:1002];
    if(pLabel)
    {
        pLabel.text = [NSString stringWithFormat:@"%.2f",m_fBalanceFee];
    }
    return pCellObj;
}

//提现提示信息的Cell
-(UITableViewCell *)getCashComInfoHintCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strCashComInfoHintCellId = @"CashComInfoHintCellId";
    UITableViewCell *pCellObj = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:strCashComInfoHintCellId];
    if (!pCellObj)
    {
        pCellObj = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strCashComInfoHintCellId];
        pCellObj.contentView.backgroundColor =  COLOR_VIEW_BACKGROUND;
        pCellObj.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        //投资收益
        UILabel*pLabel = [[UILabel alloc]initWithFrame:CGRectMake(20,10, 280, 20)];
        pLabel.backgroundColor = [UIColor clearColor];
        pLabel.textColor = COLOR_FONT_2;
        
        pLabel.font = [UIFont systemFontOfSize:12.0f];
        pLabel.numberOfLines = 0;
        pLabel.textAlignment  = UITextAlignmentLeft;
        pLabel.tag = 1001;
        pLabel.text= @"";
        [pCellObj.contentView addSubview:pLabel];
        
        UIImageView*pLineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 39, self.view.frame.size.width, 1)];
        pLineView.backgroundColor = COLOR_CELL_LINE_DEFAULT;
        [pCellObj.contentView addSubview:pLineView];
        
    }
    
    UILabel* pLabel = (UILabel*)[pCellObj.contentView viewWithTag:1001];
    if(pLabel == nil)
        return pCellObj;
    if(indexPath.row == 2)
    {
        pLabel.text = @"可提现余额 = 余额 - 提现中的金额";
    }
    else if(indexPath.row == 4)
    {
        pLabel.text = @"当余额低于100元，请一次性全额提取";
    }
    
    return pCellObj;
}


//提现金额输入的cell
-(UITableViewCell *)getInputCashValueCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strInputCashValueCellId = @"InputCashValueCellId";
    UITableViewCell *pCellObj = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:strInputCashValueCellId];
    if (!pCellObj)
    {
        pCellObj = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strInputCashValueCellId];
        pCellObj.selectionStyle = UITableViewCellSelectionStyleNone;
        pCellObj.backgroundColor = [UIColor whiteColor];
        
        UILabel *pLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 80, 21)];
        pLabel.tag = 1002;
        pLabel.backgroundColor = [UIColor clearColor];
        pLabel.textColor = COLOR_FONT_1;
        pLabel.textAlignment = UITextAlignmentLeft;
        pLabel.font = [UIFont systemFontOfSize:14];
        pLabel.text = @"提现金额：";
        [pCellObj.contentView addSubview:pLabel];
        
        
        UITextField*pTextField = [[UITextField alloc] initWithFrame:CGRectMake(100, 5, 100, 30)];
        pTextField.font  = [UIFont systemFontOfSize:14];
        pTextField.textColor = COLOR_FONT_1;
        pTextField.textAlignment  = UITextAlignmentLeft;
        pTextField.tag  = 1001;
        pTextField.placeholder = @"请输入提现金额";
        pTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;  //垂直居中
        pTextField.keyboardType = UIKeyboardTypeDecimalPad;
        
        [pTextField addTarget:self action:@selector(actionTextFieldEditingDidEnd:) forControlEvents:UIControlEventEditingDidEnd];
        [pTextField addTarget:self action:@selector(actionTextFieldEditingDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
        [pTextField addTarget:self action:@selector(actionTextFieldEditingDidEndExit:) forControlEvents:UIControlEventEditingDidEndOnExit];
        [pCellObj.contentView addSubview:pTextField];

        
        UIButton*pButton = [UIButton buttonWithType: UIButtonTypeCustom];
        pButton.frame = CGRectMake(240, 5, 60, 30);

        [UIOwnSkin setButtonBackground:pButton andColor:RGBCOLOR(131, 184, 185)];
        [pButton setTitle:@"全额提现" forState:UIControlStateNormal];
        pButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [pButton addTarget:self action:@selector(actionGetAllCashClicked:) forControlEvents:UIControlEventTouchUpInside];
        [pCellObj.contentView addSubview:pButton];
        
        //线条
        UIImageView* pLineView = [[UIImageView alloc] initWithFrame:CGRectMake(0,49, 320, 1)];
        pLineView.backgroundColor = COLOR_CELL_LINE_DEFAULT;
        [pCellObj.contentView addSubview:pLineView];
 
    }
    
     //信息设置
    return pCellObj;
}

//输入交易密码的Cell
-(UITableViewCell *)getInputCashPasswordCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strInputCashPasswordCellId = @"InputCashPasswordCellId";
    UITableViewCell *pCellObj = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:strInputCashPasswordCellId];
    if (!pCellObj)
    {
        pCellObj = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strInputCashPasswordCellId];
        pCellObj.selectionStyle = UITableViewCellSelectionStyleNone;
        pCellObj.backgroundColor = [UIColor whiteColor];
        
        
        UITextField*pTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 5, 100, 30)];
        pTextField.font  = [UIFont systemFontOfSize:14];
        pTextField.textColor = COLOR_FONT_1;
        pTextField.textAlignment  = UITextAlignmentLeft;
        pTextField.tag  = 1002;
        pTextField.placeholder = @"请输入交易密码";
        pTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;  //垂直居中
        pTextField.keyboardType = UIKeyboardTypeDefault;
        pTextField.secureTextEntry = YES;
        pTextField.returnKeyType = UIReturnKeyDone;
        //添加事件处理
        [pTextField addTarget:self action:@selector(actionTextFieldEditingDidEnd:) forControlEvents:UIControlEventEditingDidEnd];
        [pTextField addTarget:self action:@selector(actionTextFieldEditingDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
        [pTextField addTarget:self action:@selector(actionTextFieldEditingDidEndExit:) forControlEvents:UIControlEventEditingDidEndOnExit];
        
        [pTextField addTarget:self action:@selector(actionTextFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
        [pCellObj.contentView addSubview:pTextField];
        
        //线条
        UIImageView* pLineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, pCellObj.contentView.frame.size.height-1, 320, 1)];
        pLineView.backgroundColor = COLOR_CELL_LINE_DEFAULT;
        [pCellObj.contentView addSubview:pLineView];
        
    }
    //信息设置
    return pCellObj;
}

//贷款类的tableviewcell
-(UITableViewCell *)getCashSubmitTableCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strCashSubmitTableCellId = @"CashSubmitTableCellId";
    UITableViewCell *pCellObj = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:strCashSubmitTableCellId];
    if (!pCellObj)
    {
        pCellObj = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strCashSubmitTableCellId];
        pCellObj.selectionStyle = UITableViewCellSelectionStyleNone;
        pCellObj.backgroundColor = [UIColor whiteColor];
        
        UIButton*pButton = [UIButton buttonWithType:UIButtonTypeCustom];
        pButton.frame = CGRectMake(110, 0, 200, 38);
        [pButton addTarget:self action:@selector(actionFogortPassword:) forControlEvents:UIControlEventTouchUpInside];
        [pCellObj.contentView addSubview:pButton];
        
        UILabel*pLabel = [[UILabel alloc]initWithFrame:CGRectMake(10,10, 190, 16)];
        pLabel.textColor = COLOR_FONT_6;
        pLabel.font = [UIFont systemFontOfSize:14];
        pLabel.text = @"忘记密码？";
        pLabel.textAlignment = UITextAlignmentRight;
        [pButton addSubview:pLabel];
        //下划线
        UIImageView*pLineView = [[UIImageView alloc] initWithFrame:CGRectMake(130, 27, 60, 0.5)];
        pLineView.backgroundColor = COLOR_FONT_6;
        [pButton addSubview:pLineView];
        
        //
    
        pButton = [UIButton buttonWithType:UIButtonTypeCustom];
        pButton.frame = CGRectMake(15, 40, 290, 35);
        pButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [pButton setTitle:@"提交" forState:UIControlStateNormal];
        pButton.enabled = NO;
        [pButton addTarget:self action:@selector(actionSubmitCashClicked:) forControlEvents:UIControlEventTouchUpInside];
        pButton.tag = 3001;
        [UIOwnSkin setButtonBackground:pButton andColor:COLOR_BTN_BORDER_1];
        
        [pCellObj.contentView addSubview:pButton];
        
        //
        pLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 85, 280, 35)];
        pLabel.textColor = COLOR_FONT_2;
        pLabel.numberOfLines = 0;
        pLabel.textAlignment = UITextAlignmentLeft;
        pLabel.font = [UIFont systemFontOfSize:12];
        pLabel.text = @"提现需要T+1个工作日到账，如遇节假日顺延，请注意查收";

        [pCellObj.contentView addSubview:pLabel];
        
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
        pCellObj = [self getGetCashTopBarCell:tableView cellForRowAtIndexPath:indexPath];
        
    }
    else if(indexPath.row == 1)
    {
        pCellObj = [self getCanGetCashValueCell:tableView cellForRowAtIndexPath:indexPath];
    }
    else if(indexPath.row == 2 || indexPath.row == 4)
    {
        pCellObj = [self getCashComInfoHintCell:tableView cellForRowAtIndexPath:indexPath];
    }
    else if(indexPath.row == 3)
    {
        pCellObj = [self getInputCashValueCell:tableView cellForRowAtIndexPath:indexPath];
    }
    else if(indexPath.row == 5)
    {
        pCellObj = [self getInputCashPasswordCell:tableView cellForRowAtIndexPath:indexPath];
    }
    else
    {
        pCellObj = [self getCashSubmitTableCell:tableView cellForRowAtIndexPath:indexPath];
    }
    return pCellObj;
}



//点击忘记密码
-(void)actionFogortPassword:(id)sender
{
    ForgotPasswordView* pForgotView = [[ForgotPasswordView alloc] init];
    pForgotView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:pForgotView animated:YES];
}



@end
