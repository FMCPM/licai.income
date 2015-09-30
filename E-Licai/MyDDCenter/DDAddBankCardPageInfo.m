//
//  DDAddBankCardPageInfo.h

//  我的叮叮-添加银行卡
//
//  Created on 2014-11-20.
//

#import "DDAddBankCardPageInfo.h"
#import "UaConfiguration.h"
#import "UIOwnSkin.h"
#import "DdBillDetailTableCell.h"
#import "GlobalDefine.h"
#import "JsonXmlParserObj.h"
#import "Car_LoanDetailInfoPageView.h"
#import "DDChangeTradePassword_2.h"

@interface DDAddBankCardPageInfo ()

@end

@implementation DDAddBankCardPageInfo

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
    self.navigationItem.titleView = [UIOwnSkin navibarTitleView:@"添加银行卡" andFrame:CGRectMake(0, 0, 100, 40)];
    
    //左边返回按钮
    self.navigationItem.leftBarButtonItem = [UIOwnSkin backItemTarget:self action:@selector(backNavButtonAction:)];
    _uiMainTableView = nil;
    m_strOraInputCardId = @"";
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
    
    [self loadAllTypeBankInfo_Web];
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
    [m_uiCardIdField resignFirstResponder];
    
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
    //
}

//完成编辑
-(void)actionTextFieldEditingDidEnd:(id)sender
{
    UITextField* pTextField = (UITextField*)sender;
    if(pTextField == nil)
        return;
    [pTextField resignFirstResponder];
}


//
-(void)actionTextFieldEditingChanged:(id)sender
{
    UITextField* pTextField = (UITextField*)sender;
    if(pTextField == nil)
        return;

    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    UITableViewCell* pBtnCellObj = [_uiMainTableView cellForRowAtIndexPath:indexPath];
    if(pBtnCellObj == nil)
        return;
    UIButton* pSubmitButton = (UIButton*)[pBtnCellObj.contentView viewWithTag:3001];
    if(pSubmitButton == nil)
        return;
    if(pTextField.text.length > 0)
    {
        
        pSubmitButton.enabled = YES;
        [UIOwnSkin setButtonBackground:pSubmitButton];
        pTextField.text = [self getRightBankCarIdShow:pTextField.text];
        m_strOraInputCardId = pTextField.text;
    }
    else
    {
        pSubmitButton.enabled = NO;
        [UIOwnSkin setButtonBackground:pSubmitButton andColor:COLOR_BTN_BORDER_1];
    }
}

//银行卡号，4位分隔一下
-(NSString*)getRightBankCarIdShow:(NSString*)strText
{
    NSString* strTemp = strText;
    if(strTemp.length < 4)
        return strTemp;
    int iOraLen = m_strOraInputCardId.length;
    int iCurLen = strTemp.length;
    if(iCurLen < iOraLen)
    {
        return strTemp;
    }
    
    //先全部替换空格
    strTemp = [strTemp stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSString* strCardId = @"";
    
    int iBegIndex = 0;
    while (iBegIndex < strTemp.length)
    {
        NSRange range ;
        range.location = iBegIndex;
        
        int iLeftLen = strTemp.length - iBegIndex;
        int iGetLen = 0;
        if(iLeftLen >=4)
        {
            iGetLen = 4;
        }
        else
        {
            iGetLen = iLeftLen;
        }
        if(iGetLen < 1)
            break;
        range.length = iGetLen;
        if(strCardId.length < 1)
            strCardId = [strTemp substringWithRange:range];
        else
            strCardId = [strCardId stringByAppendingString:[strTemp substringWithRange:range]];
        if(iGetLen == 4)
        {
            strCardId = [strCardId stringByAppendingString:@" "];
        }
        iBegIndex = iBegIndex+iGetLen;
        
    }
    
    return  strCardId;
}


//查询支持的银行信息
-(void)loadAllTypeBankInfo_Web
{
    
    CKHttpHelper*  pHttpHelper = [CKHttpHelper httpHelperWithOwner:self];
    pHttpHelper.m_iWebServerType = 1;
    pHttpHelper.methodType = CKHttpMethodTypePost_Page;
    //设置webservice方法名
    [pHttpHelper setMethodName:@"memberInfo/queryBankList"];


    [pHttpHelper setCompleteBlock:^(id dataSet)
     {
         
         [SVProgressHUD dismiss];
         
         JsonXmlParserObj* pJsonObj = dataSet;
         if(pJsonObj == nil)
         {
             [SVProgressHUD showErrorWithStatus:HINT_WEBDATA_NET_ERROR duration:1.8];
             return ;
         }
         m_pBankInfoDataSet = [pJsonObj parsetoDataSet:@"brankList"];
         /*
         m_pBankInfoDataSet = [[QDataSetObj alloc] init];
         
         [m_pBankInfoDataSet addDataSetRow_Ext:0 andName:@"bankId" andValue:@"1"];
         [m_pBankInfoDataSet addDataSetRow_Ext:0 andName:@"bankName" andValue:@"中国工商银行"];

         [m_pBankInfoDataSet addDataSetRow_Ext:1 andName:@"bankId" andValue:@"2"];
         [m_pBankInfoDataSet addDataSetRow_Ext:1 andName:@"bankName" andValue:@"中国建设银行"];
         
         [m_pBankInfoDataSet addDataSetRow_Ext:2 andName:@"bankId" andValue:@"3"];
         [m_pBankInfoDataSet addDataSetRow_Ext:2 andName:@"bankName" andValue:@"中国农业银行"];
          */
         
     }];
    
    [pHttpHelper setStartBlock:^{
        [SVProgressHUD showWithStatus:HINT_WEBDATA_LOADING];
    }];
    
    [pHttpHelper start];
   
    
}

//选择银行卡
-(void)actionSelectBankClicked:(id)sender
{
    if(m_pBankInfoDataSet == nil || [m_pBankInfoDataSet getRowCount ] < 1)
    {
        return;
    }

    NSMutableArray* arDataList = [[NSMutableArray alloc] init];
    
    for(int i=0;i<[m_pBankInfoDataSet getRowCount];i++)
    {
        NSString* strBankId = [m_pBankInfoDataSet getFeildValue:i andColumn:@"cardId"];
        NSString* strBankName = [m_pBankInfoDataSet getFeildValue:i andColumn:@"bankName"];
        
        NSDictionary  *newDict =  [[NSDictionary alloc]initWithObjectsAndKeys:strBankId,@"CellCode",strBankName,@"CellName", nil];
        [arDataList addObject:newDict];
    }

    m_pDownUpPopupView = [[DownToUpPopupView alloc] initWithFrame:self.view.frame andViewType:1 andData:arDataList];
    m_pDownUpPopupView.m_iCurrentSelCellRow  =-1;
    m_pDownUpPopupView.m_switchDelegate = self;
    [self.view addSubview:m_pDownUpPopupView];
    

}

//添加银行卡
-(void)actionAddBankCardClicked:(id)sender
{
    
    [self hiddenKeyBoard];

    
    if(m_strSelectedBankId.length < 1)
    {
        [SVProgressHUD showErrorWithStatus:@"请选择银行卡所的银行！" duration:1.8];
        return;
    }
    
    NSString* strBankCardId = m_uiCardIdField.text;
    
    strBankCardId = [strBankCardId stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if(strBankCardId.length < 1)
    {
        [SVProgressHUD showErrorWithStatus:@"请输入银行卡的卡号！" duration:1.8];
        return;
    }
    
    CKHttpHelper*  pHttpHelper = [CKHttpHelper httpHelperWithOwner:self];
    pHttpHelper.m_iWebServerType = 1;
    pHttpHelper.methodType = CKHttpMethodTypePost_Page;
    //设置webservice方法名
    [pHttpHelper setMethodName:@"memberInfo/saveBankCard"];
    [pHttpHelper addParam:[NSString stringWithFormat:@"%d",[UaConfiguration sharedInstance].m_setLoginState.m_iUserMemberID] forName:@"memberId"];
    //银行编号
    [pHttpHelper addParam:m_strSelectedBankId forName:@"bank.cardId"];
    //银行卡号
    [pHttpHelper addParam:strBankCardId forName:@"bank.cardSno"];
    
    [pHttpHelper setCompleteBlock:^(id dataSet)
     {
         
         [SVProgressHUD dismiss];
         
         [SVProgressHUD showErrorWithStatus:@"添加银行卡成功！" duration:1.8];
         [UaConfiguration sharedInstance].m_setLoginState.m_strBankCardId = strBankCardId;
         
       //  [self performSelector:@selector(stepToProductDetailInfo) withObject:self afterDelay:1.6];
         //[self.navigationController popToRootViewControllerAnimated:YES];
         DDChangeTradePassword_2* pTradePwdView = [[DDChangeTradePassword_2 alloc] init];
         pTradePwdView.m_iPasswordType = 3;
         pTradePwdView.hidesBottomBarWhenPushed = YES;
         [self.navigationController pushViewController:pTradePwdView animated:YES];
     }];
    
    [pHttpHelper setStartBlock:^{
        [SVProgressHUD showWithStatus:HINT_WEBDATA_LOADING];
    }];
    
    
    [pHttpHelper start];
}


//返回到产品详情页面
-(void)stepToProductDetailInfo
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

    [self.navigationController popToRootViewControllerAnimated:YES];
        
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
-(UITableViewCell *)getTopBarAddHintInfoCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strTopBarAddHintInfoCellId = @"TopBarAddHintInfoCellId";
    UITableViewCell *pCellObj = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:strTopBarAddHintInfoCellId];
    if (!pCellObj)
    {
        pCellObj = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strTopBarAddHintInfoCellId];
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
        pLabel.text = @"您的实名信息已被验证，购买理财产品需用本人银行卡，申购金额仅可购回至付款银行卡。";
        [pCellObj.contentView addSubview:pLabel];
        
    }
    
    return pCellObj;

}

//具体选择银行，以及输入银行信息的Cell
-(UITableViewCell *)getBankCardSelectOrInputCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strBankCardSelectOrInputCellId = @"BankCardSelectOrInputCellId";
    UITableViewCell *pCellObj = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:strBankCardSelectOrInputCellId];
    if (!pCellObj)
    {
        pCellObj = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strBankCardSelectOrInputCellId];
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
        
        
        //选择银行卡的提示图片
        UIImageView* pSelCarImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 14, 16, 12)];
        pSelCarImgView.image = [UIImage imageNamed:@"icon_select_bank"];
        [pBackView addSubview:pSelCarImgView];
   
        //
        UIButton*pButton = [UIButton buttonWithType:UIButtonTypeCustom];
        pButton.tag = 3001;
        [pButton addTarget:self action:@selector(actionSelectBankClicked:) forControlEvents:UIControlEventTouchUpInside];
        pButton.frame = CGRectMake(36, 1, 264, 38);
        pButton.tag = 3001;
        [pBackView addSubview:pButton];
        
        //可用余额
        UILabel*pLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,9, 100, 20)];
        pLabel.backgroundColor = [UIColor clearColor];
        pLabel.textColor = COLOR_FONT_2;
        
        pLabel.font = [UIFont systemFontOfSize:14.0f];
        pLabel.numberOfLines = 0;
        pLabel.textAlignment  = UITextAlignmentLeft;
        pLabel.tag = 1001;
        pLabel.text = @"请选择银行";
        [pButton addSubview:pLabel];
        
        //
        UIImageView*pBtnImgView = [[UIImageView alloc] initWithFrame:CGRectMake(240, 16, 12, 5)];
        pBtnImgView.image = [UIImage imageNamed:@"arrow_down"];
        [pButton addSubview:pBtnImgView];
        
        //输入银行卡
        UITextField*pTextField = [[UITextField alloc] initWithFrame:CGRectMake(36, 45, self.view.frame.size.width-20-45, 30)];
        pTextField.font  = [UIFont systemFontOfSize:14];
        pTextField.textColor = COLOR_FONT_1;
        pTextField.textAlignment  = UITextAlignmentLeft;
        pTextField.tag  = 1001;
        pTextField.placeholder = @"请输入银行卡号";
        pTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;  //垂直居中
        pTextField.keyboardType = UIKeyboardTypeDecimalPad;
        
        [pTextField addTarget:self action:@selector(actionTextFieldEditingDidEnd:) forControlEvents:UIControlEventEditingDidEnd];
        [pTextField addTarget:self action:@selector(actionTextFieldEditingDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
        [pTextField addTarget:self action:@selector(actionTextFieldEditingDidEndExit:) forControlEvents:UIControlEventEditingDidEndOnExit];
         [pTextField addTarget:self action:@selector(actionTextFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
        
        m_uiCardIdField = pTextField;
        [pBackView addSubview:pTextField];
        
    }

    return pCellObj;
}


//添加银行卡确认的button的Cell
-(UITableViewCell *)getAddBankCardButtonCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strAddBankCardButtonCellId = @"AddBankCardButtonCellId";
    UITableViewCell *pCellObj = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:strAddBankCardButtonCellId];
    if (!pCellObj)
    {
        pCellObj = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strAddBankCardButtonCellId];
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
        [pButton addTarget:self action:@selector(actionAddBankCardClicked:) forControlEvents:UIControlEventTouchUpInside];
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
        pCellObj = [self getTopBarAddHintInfoCell:tableView cellForRowAtIndexPath:indexPath];
    }
    else if(indexPath.row == 1)
    {
        pCellObj = [self getBankCardSelectOrInputCell:tableView cellForRowAtIndexPath:indexPath];
    }
    else if(indexPath.row == 2 )
    {
        pCellObj = [self getAddBankCardButtonCell:tableView cellForRowAtIndexPath:indexPath];
    }
    return pCellObj;
}

#pragma DownToUpPopupViewDelegate
-(void)onEndSelectedCellInfo:(NSString *)strCellId andName:(NSString *)strCellName
{
    if(m_pDownUpPopupView)
    {
        [m_pDownUpPopupView removeFromSuperview];
        m_pDownUpPopupView = nil;
    }
    if(strCellName.length < 1)
        return;
    m_strSelectedBankId = strCellId;
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    UITableViewCell* pCellObj = [_uiMainTableView cellForRowAtIndexPath:indexPath];
    if(pCellObj == nil)
        return;
    UILabel* pLabel = (UILabel*)[pCellObj.contentView viewWithTag:1001];
    if(pLabel)
    {
        pLabel.text = strCellName;
    }
  //  m_strExpressEnterId = strCellId;
  //  m_strExpressEnterName = strCellName;

    
}


@end
