//
//  Car_TenderFlowView_Setp2.h
//
//  汽车贷款-产品详情-投标流程第二步

//  Created by lzq on 2014-11-16.

//


#import "Car_TenderFlowView_Setp2.h"
#import "UaConfiguration.h"
#import "CKHttpHelper.h"
#import "CKKit.h"
#import "SQLLiteDBManager.h"
#import <QuartzCore/QuartzCore.h>
#import "UIOwnSkin.h"
#import "GlobalDefine.h"
#import "Car_TenderFlowView_Setp3.h"
#import "JsonXmlParserObj.h"
#import "KGModal.h"
#import "WebViewController.h"
#import "FeePayComMethod.h"
#import "UserIdSignInfoPopupView.h"
#import "DDChangeTradePassword_1.h"


@interface Car_TenderFlowView_Setp2 ()

@end

@implementation Car_TenderFlowView_Setp2

@synthesize m_strProductId = _strProductId;
@synthesize m_strProductName = _strProductName;
@synthesize m_strTenderMoney = _strTenderMoney;
@synthesize m_uiConfirmStepButton = _uiConfirmStepButton;
@synthesize m_uiMainTableView = _uiMainTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {


    }
    return self;
}

- (void)dealloc
{
    //self.llSdk = nil;
}



- (void)viewDidLoad
{
    
    self.navigationController.navigationBar.translucent = NO;
    //标题
    self.navigationItem.titleView = [UIOwnSkin navibarTitleView:@"投标" andFrame:CGRectMake(0, 0, 100, 40)];
    //左边返回按钮
    self.navigationItem.leftBarButtonItem = [UIOwnSkin backItemTarget:self action:@selector(backNavButtonAction:)];
    
    
    m_isReadProtocol = NO;
    m_isUsedBankCard = NO;
    m_isUsedLeftMoney = NO;
    m_iSelectedCashBillId = 0;
    m_strProtocolName = @"";
    m_blPrePayResult = YES;
   // [self initViewShow];
    [super viewDidLoad];
}

- (void)viewWillDisappear:(BOOL)animated
{
    //注销键盘事件
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    m_isRegKeyboardEvent = NO;
    
}


-(void)viewWillAppear:(BOOL)animated
{
    //注册键盘事件
    [self registerForKeyboardNotifications];
    if(_uiMainTableView != nil)
        return;
    CGRect rcFrame = self.view.frame;
    rcFrame.origin.y = 0;
    _uiMainTableView = [[UITableView alloc]initWithFrame:rcFrame style:UITableViewStylePlain];
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
    
    [self loadUserBillInfo_Web];
}

//注册键盘事件
- (void)registerForKeyboardNotifications
{
    
    if(m_isRegKeyboardEvent == YES)
        return;
    
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
    //交易密码
    m_strInputTradePwd = pTextField.text;

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
    bool blCanNext = NO;
    if(pTextField.text.length > 1 && m_isReadProtocol == YES)
    {
        blCanNext = YES;
    }
    
    if(blCanNext == YES)
    {
        
        _uiConfirmStepButton.enabled = YES;
        [UIOwnSkin setButtonBackground:_uiConfirmStepButton];
    }
    else
    {
        _uiConfirmStepButton.enabled = NO;
        [UIOwnSkin setButtonBackground:_uiConfirmStepButton andColor:COLOR_BTN_BORDER_1];
    }
}


//获取账号余额
-(void)loadUserBillInfo_Web
{
    CKHttpHelper *pHttpHelper = [CKHttpHelper httpHelperWithOwner:self];
    pHttpHelper.m_iWebServerType = 1;
    pHttpHelper.methodType = CKHttpMethodTypePost_Page;
    //设置webservice方法名
    [pHttpHelper setMethodName:@"memberInfo/queryMyAccount"];
    //
    [pHttpHelper addParam:[NSString stringWithFormat:@"%d",[UaConfiguration sharedInstance].m_setLoginState.m_iUserMemberID] forName:@"memberId"];
    
    //设置结束block（webservice方法结束后，会自动调用）
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
         if(pDataSet == nil)
         {
             [_uiMainTableView reloadData];
             return;
         }
         //账户可用余额
         NSString* strBalance = [pDataSet getFeildValue:0 andColumn:@"balance"];
         
         m_fBillLeftFee = [QDataSetObj convertToFloat:strBalance];
         
          NSString* strLeftMoney = [NSString stringWithFormat:@"可用余额：%.2f",m_fBillLeftFee];
         [self setCellLabelText:1 andTag:1001 andText:strLeftMoney];
         [self loadProductBuyProtocol_Web];
     }];

    [SVProgressHUD showWithStatus:HINT_WEBDATA_LOADING];
    //开始连接
    [pHttpHelper start];

}

-(void)setCellLabelText:(NSInteger)iCellRow andTag:(NSInteger)iTag andText:(NSString*)strText
{
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:iCellRow inSection:0];
    UITableViewCell* pCellObj = [_uiMainTableView cellForRowAtIndexPath:indexPath];
    if(pCellObj == nil)
        return;
    UILabel*pLabel = (UILabel*)[pCellObj.contentView viewWithTag:iTag];
    if(pLabel)
    {
        pLabel.text = strText;
    }
    
}

//获取产品的协议
-(void)loadProductBuyProtocol_Web
{
    CKHttpHelper *pHttpHelper = [CKHttpHelper httpHelperWithOwner:self];
    pHttpHelper.m_iWebServerType = 1;
    pHttpHelper.methodType = CKHttpMethodTypePost_Page;
    //设置webservice方法名
    [pHttpHelper setMethodName:@"productInfo/queryRepayPlan"];
    //
    [pHttpHelper addParam:_strProductId forName:@"productId"];
    
    //设置结束block（webservice方法结束后，会自动调用）
    [pHttpHelper setCompleteBlock:^(id dataSet)
     {
         [SVProgressHUD dismiss];
         
         
         m_strProtocolName = [NSString stringWithFormat:@"%@协议",_strProductName];
         
         [_uiMainTableView reloadData];
    }];
    
    //开始连接
    [pHttpHelper start];
}

//获取用户的代金券信息
-(void)loadUserCashBillInfo_Web
{
    CKHttpHelper *pHttpHelper = [CKHttpHelper httpHelperWithOwner:self];
    pHttpHelper.m_iWebServerType = 1;
    pHttpHelper.methodType = CKHttpMethodTypePost_Page;
    //设置webservice方法名
    [pHttpHelper setMethodName:@"memberInfo/queryMemberDkList"];
    //
    [pHttpHelper addParam:[NSString stringWithFormat:@"%d",[UaConfiguration sharedInstance].m_setLoginState.m_iUserMemberID] forName:@"memberId"];
    
    //设置结束block（webservice方法结束后，会自动调用）
    [pHttpHelper setCompleteBlock:^(id dataSet)
     {
         [SVProgressHUD dismiss];
         
         JsonXmlParserObj* pJsonObj = dataSet;
         if(pJsonObj == nil)
         {
              [SVProgressHUD showErrorWithStatus:HINT_WEBDATA_NET_ERROR duration:1.8];
              return ;
         }
         QDataSetObj* pDataSet = [pJsonObj parsetoDataSet:@"dkList"];
         if(pDataSet == nil)
              return;
         m_pCashBillDataSet = [[QDataSetObj alloc] init];
         for(int i=0;i<[pDataSet getRowCount];i++)
         {
             [m_pCashBillDataSet addDataSetRow_Ext:i andName:@"tickName" andValue:[pDataSet getFeildValue:i andColumn:@"TCashTick_tickName"]];
             [m_pCashBillDataSet addDataSetRow_Ext:i andName:@"tkId" andValue:[pDataSet getFeildValue:i andColumn:@"TCashTick_tkId"]];
             [m_pCashBillDataSet addDataSetRow_Ext:i andName:@"dkFee" andValue:[pDataSet getFeildValue:i andColumn:@"TCashTick_dkFee"]];
         }
         [self showCashBillPopupView];
       
     }];
    
    //开始连接
    [pHttpHelper start];
}

//弹出显示代金券信息的列表
-(void)showCashBillPopupView
{
    
    if(m_pCashBillDataSet == nil || [m_pCashBillDataSet getRowCount] < 1)
    {
        [SVProgressHUD showErrorWithStatus:@"您目前没有可用的代金券！" duration:1.8];
        return;
    }
    
    NSMutableArray* arDataList = [[NSMutableArray alloc] init];
    for(int i=0;i<[m_pCashBillDataSet getRowCount];i++)
    {
        NSString* strCellName = [m_pCashBillDataSet getFeildValue:i andColumn:@"tickName"];
        NSString* strCellId = [m_pCashBillDataSet getFeildValue:i andColumn:@"tkId"];
        
        NSString* strCellFee = [m_pCashBillDataSet getFeildValue:i andColumn:@"dkFee"];
        NSDictionary  *newDict =  [[NSDictionary alloc]initWithObjectsAndKeys:strCellId,@"CellId",strCellName,@"CellName",strCellFee,@"CellFee" ,nil];
        
        [arDataList addObject:newDict];
    }

    int iHeight = arDataList.count*40+90;
    if(iHeight>300)
    {
        iHeight = 300;
    }
    
    m_pMiddlePopView = [[MoneyTickedPopupView alloc] initWithFrame:CGRectMake(0, 0, 280, iHeight) andData:arDataList andTitle:@"请选择代金券"];
    m_pMiddlePopView.m_iCurrentSelCellRow  = -1;
    m_pMiddlePopView.m_switchDelegate = self;
    
    [[KGModal sharedInstance] setCloseButtonType:KGModalCloseButtonTypeRight];
    [[KGModal sharedInstance] showWithContentView:m_pMiddlePopView andAnimated:YES];
    
}

//选择代金券
-(void)actionSelectCashBillClicked:(id)sender
{
    
    if(m_pCashBillDataSet != nil)
    {
        [self showCashBillPopupView];
        return;
    }
    
    [self loadUserCashBillInfo_Web];
    
}


//阅读协议
-(void)actionViewProtocolBtnClicked:(id)sender
{
    
    WebViewController* pWebView = [[WebViewController alloc] init];
    pWebView.m_strViewTitle = m_strProtocolName;
    pWebView.m_strWebUrl = [NSString stringWithFormat:@"%@/productInfo/queryProContract.do?productId=%@",[UaConfiguration sharedInstance].m_strSoapRequestUrl_1,_strProductId];
    pWebView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:pWebView animated:YES];
    
}



- (void)backNavButtonAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

//点击余额、银行卡、阅读协议
-(void)actionFlowButtonClicked:(id)sender
{
    UIButton* pButton = (UIButton*)sender;
    if(pButton == nil)
        return;
    
    UITableViewCell* pCellObj = [UIOwnSkin getSuperTableViewCell:sender];
    if(pCellObj == nil)
        return;
    
    NSIndexPath* indexPath = [_uiMainTableView indexPathForCell:pCellObj];
    if(indexPath == nil)
        return;
    
    int iCellRow = indexPath.row;
    
    BOOL blChecked = NO;
    UIImageView* pSelImgView = nil;
    UILabel* pLabel = nil;
    
    if(iCellRow == 1)
    {
        if(pButton.tag == 3001)//使用余额支付
        {
            pSelImgView = (UIImageView*)[pCellObj.contentView viewWithTag:2001];
            if(m_isUsedLeftMoney == YES)
            {
                m_isUsedLeftMoney = NO;
            }
            else
            {
                m_isUsedLeftMoney = YES;
            }
            pLabel = (UILabel*)[pCellObj.contentView viewWithTag:1001];
            
            blChecked = m_isUsedLeftMoney;
            
        }
        else if(pButton.tag == 3002)//银行卡支付
        {
            
            pSelImgView = (UIImageView*)[pCellObj.contentView viewWithTag:2002];
            if(m_isUsedBankCard == YES)
            {
                m_isUsedBankCard = NO;
            }
            else
            {
                m_isUsedBankCard = YES;
            }
            pLabel = (UILabel*)[pCellObj.contentView viewWithTag:1002];
            blChecked = m_isUsedBankCard;
            
        }
        else if(pButton.tag == 3003)//代金券
        {
            pSelImgView = (UIImageView*)[pCellObj.contentView viewWithTag:2003];
            if(m_isUsedCashBill == YES)
            {
                m_isUsedCashBill = NO;
            }
            else
            {
                m_isUsedCashBill = YES;
            }
            pLabel = (UILabel*)[pCellObj.contentView viewWithTag:1004];
            
            blChecked = m_isUsedCashBill;
        }
       
    }
     else //阅读协议
    {
        pSelImgView = (UIImageView*)[pCellObj.contentView viewWithTag:2001];
        bool blNext = NO;
        if(m_isReadProtocol == YES)
        {
            m_isReadProtocol = NO;

            blNext = NO;
        }
        else
        {
            m_isReadProtocol = YES;
            if(m_strInputTradePwd.length > 0)
                blNext = YES;
        }
        if(blNext == NO)
        {

            [UIOwnSkin setButtonBackground:_uiConfirmStepButton andColor:COLOR_BTN_BORDER_1];
            _uiConfirmStepButton.enabled = NO;
        }
        else
        {
            [UIOwnSkin setButtonBackground:_uiConfirmStepButton];
            _uiConfirmStepButton.enabled = YES;
        }
    
        blChecked = m_isReadProtocol;
        
    }
    
    if(pSelImgView == nil)
        return;
    if(blChecked == YES)
    {
        pSelImgView.image = [UIImage imageNamed:@"checkbox_fill.png"];
        if(pLabel)
            pLabel.textColor = COLOR_FONT_5;
    }
    else
    {
        pSelImgView.image = [UIImage imageNamed:@"checkbox_nil.png"];
        if(pLabel)
            pLabel.textColor = COLOR_FONT_2;
    }
    if(iCellRow == 3)
    {
        UILabel* pTitleLabel = (UILabel*)[pCellObj.contentView viewWithTag:1001];
        UIImageView* pLineView = (UIImageView*)[pCellObj.contentView viewWithTag:2002];
        if(blChecked == YES)
        {
            pTitleLabel.textColor = COLOR_FONT_5;
            pLineView.backgroundColor =COLOR_FONT_5;
        }
        else
        {
            pTitleLabel.textColor = COLOR_FONT_1;
            pLineView.backgroundColor =COLOR_FONT_1;
        }
        return;
    }
    [self reStatAllTypeFeeShow];
    
}

//根据选择的不同的支付方式的组合，计算各个方式实际需要的金额
-(void)reStatAllTypeFeeShow
{
    //计算费用
    float fLeftPayFeeValue = m_fReallyTenderFee;
    //先扣除代金券
    if(m_isUsedCashBill == YES)
    {
        fLeftPayFeeValue = fLeftPayFeeValue - m_fSelectedCashBillFee;
    }
    
    //接着计算余额扣款
    if(m_isUsedLeftMoney == YES)
    {
        fLeftPayFeeValue = fLeftPayFeeValue - m_fBillLeftFee;
        //账号余额的值的显示不需要修改，就显示实际的可用余额即可
        //UILabel* pCashLable = (UILabel*)[self.view viewWithTag:1005];
    }
    
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    UITableViewCell* pCellObj = [_uiMainTableView cellForRowAtIndexPath:indexPath];
    UILabel*pBankLabel = (UILabel*)[pCellObj.contentView viewWithTag:1002];

    if(pBankLabel == nil)
        return;
    
    if(m_isUsedBankCard == YES)
    {
        if(fLeftPayFeeValue > 0)
        {
            pBankLabel.text = [NSString stringWithFormat:@"银行卡：%.2f元",fLeftPayFeeValue];
        }
        else
        {
            pBankLabel.text = @"银行卡：0.00元";
        }
    }
    else
    {
        pBankLabel.text = @"银行卡：0.00元";

    }
 
}

//确认投标
-(void)onConfirmTenderClicked:(id)sender
{
    [self hiddenKeyBoard];
    
    if(m_isReadProtocol == NO)
    {
        [SVProgressHUD showErrorWithStatus:@"请先阅读并同意投标协议！" duration:1.8];
        return;
        
    }
    
    if(m_strInputTradePwd.length < 1)
    {
        [SVProgressHUD showErrorWithStatus:@"请输入交易密码！" duration:1.8];
        return;
    }
    
    
    CKHttpHelper *pHttpHelper = [CKHttpHelper httpHelperWithOwner:self];
    pHttpHelper.m_iWebServerType = 1;
    pHttpHelper.methodType = CKHttpMethodTypePost_Page;
    //设置webservice方法名
    [pHttpHelper setMethodName:@"productInfo/toLianLianPay"];
    //
    [pHttpHelper addParam:_strProductId forName:@"productId"];
    [pHttpHelper addParam:[NSString stringWithFormat:@"%d",[UaConfiguration sharedInstance].m_setLoginState.m_iUserMemberID] forName:@"memberId"];
    //投标金额
    [pHttpHelper addParam:_strTenderMoney forName:@"bidFee"];
    //代金券的id
    NSString* strCashBillId = @"";
    
    if(m_iSelectedCashBillId != 0 && m_isUsedCashBill == YES)
    {
        strCashBillId = [NSString stringWithFormat:@"%d",m_iSelectedCashBillId];
    }
    [pHttpHelper addParam:strCashBillId forName:@"dkId"];
    //useAccount：是否使用账户可用余额支付 1 使用 0不使用
    int iUsedLeftMoney = 1;
    if(m_isUsedLeftMoney == NO)
        iUsedLeftMoney = 0;
    [pHttpHelper addParam:[NSString stringWithFormat:@"%d",iUsedLeftMoney] forName:@"useAccount"];
    [pHttpHelper addParam:m_strInputTradePwd forName:@"payPwd"];
    
    //设置结束block（webservice方法结束后，会自动调用）
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
         NSString* strOpeFlag= [pJsonObj getJsonValueByKey:@"operFlag"];
         int iOpeFlag = [QDataSetObj convertToInt:strOpeFlag];
         if(iOpeFlag == 0)
         {
             NSString* strMessage = [pDataSet getFeildValue:0 andColumn:@"message"];
             [SVProgressHUD showErrorWithStatus:strMessage duration:1.8];
             return;
         }
         //1_投标成功;2_需要调用连连支付接口
         if(iOpeFlag == 1)
         {
             Car_TenderFlowView_Setp3* pStepView3 = [[Car_TenderFlowView_Setp3 alloc] init];
             pStepView3.m_strProductId = _strProductId;
             pStepView3.m_strProductName = _strProductName;
             pStepView3.m_strTenderFeeValue = _strTenderMoney;
             pStepView3.hidesBottomBarWhenPushed = YES;
             [self.navigationController pushViewController:pStepView3 animated:YES];
             return;
         }
         
         //需要连连支付
         if(iOpeFlag == 2)
         {
             [self startLLWallketPay:pDataSet];
         }

         
     }];
    [pHttpHelper setStartBlock:^{
        [SVProgressHUD showWithStatus:HINT_WEBDATA_SUBMITING ];
    }];
    //开始连接
    [pHttpHelper start];

    
}

//启动连连支付
-(void)startLLWallketPay:(QDataSetObj*)pDataSet
{
    
    
 //   m_pllWallsdk = [[LLPaySdk alloc] init];
//    m_pllWallsdk.sdkDelegate = self;
    
    //商户唯一订单号
    NSString* strOrderSn = [pDataSet getFeildValue:0 andColumn:@"no_order"];
    
    //商品名称name_goods，暂时未提供
    NSString* strOrderTitle = [pDataSet getFeildValue:0 andColumn:@"name_goods"];
    //info_order,订单的描述信息
    NSString* strOrderDesp = [pDataSet getFeildValue:0 andColumn:@"info_order"];
    //订单金额
  //  NSString* strPrice = [pDataSet getFeildValue:0 andColumn:@"money_order"];
    
    //订单时间
    NSString* strOrderTime = [pDataSet getFeildValue:0 andColumn:@"dt_order"];
    

    // id_no:证件号 acc_name:银行账号姓名 card_no:银行卡号
    NSString* strBuyerId = [pDataSet getFeildValue:0 andColumn:@"acct_name"];
    //成功后的回调地址
    NSString* strNotify_url = [pDataSet getFeildValue:0 andColumn:@"notify_url"];
    //商户编号	oid_partner	是	String(18)	商户编号是商户在连连钱包支付平台上开设的商户号码，为18位数字，如：201304121000001004
    NSString* strOidPartner = [pDataSet getFeildValue:0 andColumn:@"oid_partner"];
    //商户业务类型	busi_partner	是	String(6)	虚拟商品销售：101001
    NSString* strBusiPartner = [pDataSet getFeildValue:0 andColumn:@"busi_partner"];
    NSString* strOrderFee = [pDataSet getFeildValue:0 andColumn:@"money_order"];
    NSString* strUserCardId = [pDataSet getFeildValue:0 andColumn:@"id_no"];
    
    NSString* strCardNo =  [pDataSet getFeildValue:0 andColumn:@"card_no"];
    
    NSString* strMd5Sign = [pDataSet getFeildValue:0 andColumn:@"sign"];
    m_llDictPay = [[FeePayComMethod sharedInstance]  getFeePayByLLWall_Licai:strOrderSn andTitle:strOrderTitle andDesp:strOrderDesp andPrice:strOrderFee andTime:strOrderTime  andBuyerId:strBuyerId andNotUrl:strNotify_url andOid:strOidPartner andBusiId:strBusiPartner andSign:strMd5Sign andValidOd:strOidPartner];
    m_llDictPay[@"flag_modify"] = @"1";
    if(m_blPrePayResult == YES && strCardNo.length > 0)
        m_llDictPay[@"card_no"] = strCardNo;

    if(strUserCardId.length < 1)
        strUserCardId = [UaConfiguration sharedInstance].m_setLoginState.m_strUserCardId;
    m_llDictPay[@"id_no"] = strUserCardId;

  
 /*   m_pIdSignView = [[UserIdSignInfoPopupView alloc] initWithFrame:CGRectMake(0, 0, 280, 170) andName:strBuyerId andId:strUserCardId];
    
    m_pIdSignView.m_pSignInfoDelegate = self;
    
    [[KGModal sharedInstance] setCloseButtonType:KGModalCloseButtonTypeNone];
    [[KGModal sharedInstance] showWithContentView:m_pIdSignView andAnimated:YES];
*/
    self.sdk = [[LLPaySdk alloc] init];
    self.sdk.sdkDelegate = self;

    //m_llDictPay[@"card_no"] = @"6227001540140127453";
    
    [ self.sdk presentPaySdkInViewController:self withTraderInfo:m_llDictPay];
    
}

#pragma MoneyTickedPopupViewDelegate

-(void)onEndSelectedCellInfo:(NSString *)strCellId andName:(NSString *)strCellName andFee:(NSString *)strCellFee
{
    [[KGModal sharedInstance] hideAnimated:YES];

    m_pMiddlePopView = nil;
    if(strCellName.length < 1)
        return;
    NSString* strText = [NSString stringWithFormat:@"%@(%@元)",strCellName,strCellFee];
    
    [self setCellLabelText:1 andTag:1004 andText:strText];
    /*
    
    UILabel* pLabel = (UILabel*)[self.view viewWithTag:1010];
    if(pLabel)
    {
        pLabel.text = [NSString stringWithFormat:@"%@(%@元)",strCellName,strCellFee];
        
    }
     */
    m_iSelectedCashBillId = [QDataSetObj convertToInt:strCellId];

}


#pragma LLWalletSDKDelegate

//连连科技回调
/*
- (void)paymentEnd:(LLWalletPayResult)resultCode withResultDic:(NSDictionary *)dic
{
    NSString *strMsg = @"支付异常";
    switch (resultCode)
    {
        case kLLWalletPayResultSuccess:
        {
            strMsg = @"支付成功";
            
            NSString* result_pay = dic[@"result_pay"];
            if ([result_pay isEqualToString:@"SUCCESS"])
            {
                
                //支付成功后，通知服务端
               // [self nodifyToServerPayResult:1 andResultMemo:strMsg];
                return;
            }
            else if ([result_pay isEqualToString:@"PROCESSING"])
            {
                strMsg = @"支付单处理中";
            }
            else if ([result_pay isEqualToString:@"FAILURE"])
            {
                strMsg = @"支付单失败";
            }
            else if ([result_pay isEqualToString:@"REFUND"])
            {
                strMsg = @"支付单已退款";
            }
            break;
        }
            
        case kLLWalletPayResultFail:
        {
            strMsg = @"支付失败";
            break;
        }
            
        case kLLWalletPayResultCancel:
        {
            strMsg = @"支付取消";
            break;
        }
            
        case kLLWalletPayResultInitError:
        {
            strMsg = @"钱包初始化异常";
            break;
        }
        default:
            break;
    }
    //
    [SVProgressHUD showErrorWithStatus:strMsg duration:1.8];
   // [self performSelector:@selector(backToOrderDetailView) withObject:nil afterDelay:1.8];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

*/

// 订单支付结果返回，主要是异常和成功的不同状态
- (void)paymentEnd:(LLPayResult)resultCode withResultDic:(NSDictionary *)dic
{
    NSString *msg = @"支付异常";
    bool blSucc = NO;
    switch (resultCode) {
        case kLLPayResultSuccess:
        {
            msg = @"支付成功";
            
            NSString* result_pay = dic[@"result_pay"];
            if ([result_pay isEqualToString:@"SUCCESS"])
            {
                //
               // NSString *payBackAgreeNo = dic[@"agreementno"];
                //_agreeNumField.text = payBackAgreeNo;
               // return;
                //msg = payBackAgreeNo;
                blSucc = YES;
            }
            else if ([result_pay isEqualToString:@"PROCESSING"])
            {
                msg = @"支付单处理中";
            }
            else if ([result_pay isEqualToString:@"FAILURE"])
            {
                msg = @"支付单失败";
            }
            else if ([result_pay isEqualToString:@"REFUND"])
            {
                msg = @"支付单已退款";
            }
        }
            break;
        case kLLPayResultFail:
        {
            msg = @"支付失败";
        }
            break;
        case kLLPayResultCancel:
        {
            msg = @"支付取消";
        }
            break;
        case kLLPayResultInitError:
        {
            msg = @"sdk初始化异常";
        }
            break;
        case kLLPayResultInitParamError:
        {
            msg = dic[@"ret_msg"];
        }
            break;
        default:
            break;
    }
    m_blPrePayResult = blSucc;
    
    if(blSucc == YES)
    {
        [SVProgressHUD showSuccessWithStatus:msg duration:1.8];
        [self performSelector:@selector(synPopupToRootView_Succ) withObject:nil afterDelay:1.8];
        return;
    }
    [SVProgressHUD showErrorWithStatus:msg duration:1.8];

   // [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)synPopupToRootView_Succ
{
 //    [self.navigationController popToRootViewControllerAnimated:YES];
    Car_TenderFlowView_Setp3* pStepView3 = [[Car_TenderFlowView_Setp3 alloc] init];
    pStepView3.m_strProductId = _strProductId;
    pStepView3.m_strProductName = _strProductName;
    pStepView3.m_strTenderFeeValue = _strTenderMoney;
    pStepView3.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:pStepView3 animated:YES];

}

-(void)actionFogortTradePassword:(id)sender
{
    
    DDChangeTradePassword_1* pPasswordView = [[DDChangeTradePassword_1 alloc] init];
    pPasswordView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:pPasswordView animated:YES];
}

#pragma mark -UITableView delegate and datasource


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


//投标第二部-顶部的cell
-(UITableViewCell*)getTenderTopBarCell:(UITableView*)tableView andIndexPath:(NSIndexPath*)indexPath
{
    static NSString *strTenderTopBarCellId = @"TenderTopBarCellId";
    UITableViewCell *pCellObj = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:strTenderTopBarCellId];
    
    if (!pCellObj)
    {
        pCellObj = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strTenderTopBarCellId];
        pCellObj.contentView.backgroundColor = [UIColor whiteColor];
        pCellObj.selectionStyle = UITableViewCellSelectionStyleNone;
    
        //logo
        UIImageView*pImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 20, 20)];
        pImageView.image = [UIImage imageNamed:@"icon_small_logo.png"];
        pImageView.tag = 2001;
        [pCellObj.contentView  addSubview:pImageView];
        
        //产品名称
        UILabel* pLable = [[UILabel alloc] initWithFrame:CGRectMake(50, 20, 250, 20)];
        pLable.textAlignment = NSTextAlignmentLeft;
        pLable.backgroundColor = [UIColor clearColor];
        pLable.font = [UIFont systemFontOfSize:18];
        pLable.textColor = COLOR_FONT_1;
        pLable.tag = 1001;
        pLable.text = _strProductName;
        [pCellObj.contentView addSubview:pLable];
        
        
        //投标金额的提示
        pLable = [[UILabel alloc] initWithFrame:CGRectMake(50, 50, 90, 20)];
        pLable.textAlignment = NSTextAlignmentLeft;
        pLable.backgroundColor = [UIColor clearColor];
        pLable.font = [UIFont systemFontOfSize:14];
        pLable.textColor = COLOR_FONT_1;
        pLable.tag = 1002;
        pLable.text= @"投标金额：";
        [pCellObj.contentView addSubview:pLable];
        
        //具体投标金额的值
        pLable = [[UILabel alloc] initWithFrame:CGRectMake(145, 50, 145, 20)];
        pLable.textAlignment = NSTextAlignmentRight;
        pLable.backgroundColor = [UIColor clearColor];
        pLable.font = [UIFont systemFontOfSize:14];
        pLable.textColor = COLOR_FONT_1;
        pLable.tag = 1003;
        pLable.text= [NSString stringWithFormat:@"%@元",_strTenderMoney];
        m_fReallyTenderFee = _strTenderMoney.floatValue;
        [pCellObj.contentView addSubview:pLable];
         
        
        UIImageView* pLineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 89, self.view.frame.size.width, 1)];
        pLineView.tag = 2002;
        pLineView.backgroundColor = COLOR_CELL_LINE_DEFAULT;
        [pCellObj.contentView addSubview:pLineView];
    }
    return pCellObj;

}

-(UITableViewCell*)getTenderMiddlePayTypeCell:(UITableView *)tableView andIndexPath:(NSIndexPath*)indexPath
{
    
    static NSString *strTenderMiddlePayTypeCellId = @"TenderMiddlePayTypeCell";
    UITableViewCell *pCellObj = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:strTenderMiddlePayTypeCellId];
    
    if (!pCellObj)
    {
        pCellObj = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strTenderMiddlePayTypeCellId];
        pCellObj.contentView.backgroundColor = [UIColor whiteColor];
        pCellObj.selectionStyle = UITableViewCellSelectionStyleNone;

        int iTopY = 10;
        //一、可用余额
        UIButton* pButton = [UIButton buttonWithType:UIButtonTypeCustom];
        pButton.frame = CGRectMake(20, iTopY, 280, 40);
        pButton.tag = 3001;
        [pButton addTarget:self action:@selector(actionFlowButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [pCellObj.contentView addSubview:pButton];
        
        //选择框
        UIImageView*pSelImgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 20, 20)];
        pSelImgView.tag = 2001;
        pSelImgView.image = [UIImage imageNamed:@"checkbox_nil.png"];
        [pButton addSubview:pSelImgView];
 
        //可用余额
        UILabel* pLable = [[UILabel alloc] initWithFrame:CGRectMake(30, 10, 270, 20)];
        pLable.textAlignment = NSTextAlignmentLeft;
        pLable.backgroundColor = [UIColor clearColor];
        pLable.font = [UIFont systemFontOfSize:14];
        pLable.textColor = COLOR_FONT_2;
        pLable.tag = 1001;
        pLable.text = [NSString stringWithFormat:@"可用余额：0.00"];
        [pButton addSubview:pLable];
        
        //end of 可用余额
        
        iTopY+=40;
        //二、银行卡
        pButton = [UIButton buttonWithType:UIButtonTypeCustom];
        pButton.frame = CGRectMake(20, iTopY, 280, 50);
        pButton.tag = 3002;
        [pButton addTarget:self action:@selector(actionFlowButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        //[pCellObj.contentView addSubview:pButton];
        
        //选择框
        pSelImgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 20, 20)];
        pSelImgView.tag = 2002;
        pSelImgView.image = [UIImage imageNamed:@"checkbox_nil.png"];
        //[pButton addSubview:pSelImgView];
        
        //银行卡支付金额
        pLable = [[UILabel alloc] initWithFrame:CGRectMake(30, 10, 270, 20)];
        pLable.textAlignment = NSTextAlignmentLeft;
        pLable.backgroundColor = [UIColor clearColor];
        pLable.font = [UIFont systemFontOfSize:14];
        pLable.textColor = COLOR_FONT_2;
        pLable.tag = 1002;
        pLable.text = [NSString stringWithFormat:@"银行卡：0.00"];
        //[pButton addSubview:pLable];
        
        //尾号显示
        pLable = [[UILabel alloc] initWithFrame:CGRectMake(30, 30, 270, 15)];
        pLable.textAlignment = NSTextAlignmentLeft;
        pLable.backgroundColor = [UIColor clearColor];
        pLable.font = [UIFont systemFontOfSize:12];
        pLable.textColor = COLOR_FONT_2;
        pLable.tag = 1003;
        pLable.text = [NSString stringWithFormat:@"尾号："];
        
        NSString* strBankCardSno = [UaConfiguration sharedInstance].m_setLoginState.m_strBankCardSno;
        NSString* strBankName = [UaConfiguration sharedInstance].m_setLoginState.m_strBankName;
        
        if(strBankCardSno.length > 4)
        {
            strBankCardSno = [strBankCardSno substringFromIndex:strBankCardSno.length-4];
        }
        
        pLable.text = [NSString stringWithFormat:@"%@ 尾号：%@",strBankName,strBankCardSno];
        
        //[pButton addSubview:pLable];
        
        //end of 银行卡
        //代金券
        iTopY += 50;
        pButton = [UIButton buttonWithType:UIButtonTypeCustom];
        pButton.frame = CGRectMake(20, iTopY, 280, 40);
        pButton.tag = 3003;
        [pButton addTarget:self action:@selector(actionFlowButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
       // [pCellObj.contentView addSubview:pButton];
        
        //选择框
        pSelImgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 20, 20)];
        pSelImgView.tag = 2003;
        pSelImgView.image = [UIImage imageNamed:@"checkbox_nil.png"];
        //[pButton addSubview:pSelImgView];
        
        //代金券
        pLable = [[UILabel alloc] initWithFrame:CGRectMake(30, 10, 270, 20)];
        pLable.textAlignment = NSTextAlignmentLeft;
        pLable.backgroundColor = [UIColor clearColor];
        pLable.font = [UIFont systemFontOfSize:14];
        pLable.textColor = COLOR_FONT_2;
        pLable.tag = 1004;
        pLable.text = [NSString stringWithFormat:@"代金券（可用代金券0张）"];
        //[pButton addSubview:pLable];
        
        //选择按钮
        pButton = [UIButton buttonWithType:UIButtonTypeCustom];
        pButton.frame = CGRectMake(245, iTopY, 60, 35);
        pButton.tag = 3004;
        [UIOwnSkin setButtonBackground:pButton andColor:COLOR_BTN_BORDER_2];
        
        [pButton addTarget:self action:@selector(actionSelectCashBillClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [pButton setTitle:@"选择" forState:UIControlStateNormal];
        //[pCellObj.contentView addSubview:pButton];
        
        
        UIImageView*pLineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 1)];
        pLineView.backgroundColor = COLOR_CELL_LINE_DEFAULT;
        [pCellObj.contentView addSubview:pLineView];
        
        
    }
    UILabel* pLabel = (UILabel*)[pCellObj.contentView viewWithTag:1001];
    if(pLabel)
    {
        pLabel.text = [NSString stringWithFormat:@"可用余额：%.2f",m_fBillLeftFee];
    }
    
    return pCellObj;
 
    
}

//交易密码输入的cell
-(UITableViewCell*)getTradePwdInputFieldCell:(UITableView*)tableView andIndexPath:(NSIndexPath*)indexPath
{
    static NSString *strTradePwdInputFieldCellId = @"TradePwdInputFieldCell";
    UITableViewCell *pCellObj = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:strTradePwdInputFieldCellId];
    
    if (!pCellObj)
    {
        pCellObj = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strTradePwdInputFieldCellId];
        pCellObj.contentView.backgroundColor = [UIColor whiteColor];
        pCellObj.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //
        UIView *pBackView = [[UIView alloc]initWithFrame:CGRectMake(20, 10, self.view.frame.size.width - 40, 40)];
        pBackView.backgroundColor = [UIColor whiteColor];
        pBackView.layer.borderWidth = 1.0f;
        pBackView.layer.borderColor = COLOR_BTN_BORDER_1.CGColor;
        pBackView.layer.cornerRadius = 1.0f;
        pBackView.tag = 2001;
        [pCellObj.contentView addSubview:pBackView];
        
        //
        UIImageView *pLogoImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
        pLogoImgView.tag = 2002;
        pLogoImgView.image = [UIImage imageNamed:@"icon_password.png"];
        [pBackView addSubview:pLogoImgView];
        
        
        UITextField* pTextField = [[UITextField alloc]initWithFrame:CGRectMake(40, 5, self.view.frame.size.width-80, 30)];
        pTextField .font =[UIFont systemFontOfSize:14.0];
        pTextField.tag = 1001;
        pTextField.borderStyle = UITextBorderStyleNone;
        pTextField.keyboardType = UIKeyboardTypeDefault;
        pTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        pTextField.placeholder = @"请输入交易密码";
        pTextField.secureTextEntry = YES;
        pTextField.contentHorizontalAlignment  = UIControlContentHorizontalAlignmentCenter;
        pTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        //pTextField.delegate =self;
        pTextField.returnKeyType = UIReturnKeyDone;
        [pTextField addTarget:self action:@selector(actionTextFieldEditingDidEndExit:) forControlEvents:UIControlEventEditingDidEndOnExit];
        [pTextField addTarget:self action:@selector(actionTextFieldEditingDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
        [pTextField addTarget:self action:@selector(actionTextFieldEditingDidEnd:) forControlEvents:UIControlEventEditingDidEnd];
        [pTextField addTarget:self action:@selector(actionTextFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
        
        [pBackView addSubview:pTextField];
        
        
        
        UIImageView*pLineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 59, self.view.frame.size.width, 1)];
        pLineView.backgroundColor = COLOR_CELL_LINE_DEFAULT;
        [pCellObj.contentView addSubview:pLineView];
    }
    
    return pCellObj;

}

-(UITableViewCell*)getLastHintInfoOrButtonCell:(UITableView*)tableView andIndexPath:(NSIndexPath*)indexPath
{
    static NSString *strLastHintInfoOrButtonCellId = @"LastHintInfoOrButtonCellId";
    UITableViewCell *pCellObj = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:strLastHintInfoOrButtonCellId];
    
    if (!pCellObj)
    {
        pCellObj = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strLastHintInfoOrButtonCellId];
        pCellObj.contentView.backgroundColor = [UIColor whiteColor];
        pCellObj.selectionStyle = UITableViewCellSelectionStyleNone;

        
        //忘记交易密码
        UIButton* pButton = [UIButton buttonWithType:UIButtonTypeCustom];
        pButton.frame = CGRectMake(210, 0, 100, 30);
        [pButton addTarget:self action:@selector(actionFogortTradePassword:) forControlEvents:UIControlEventTouchUpInside];
        pButton.tag = 3006;
        [pCellObj.contentView addSubview:pButton];
        
        UILabel*pLabel = [[UILabel alloc]initWithFrame:CGRectMake(10,5, 90, 16)];
        pLabel.textColor = COLOR_FONT_6;
        pLabel.font = [UIFont systemFontOfSize:14];
        pLabel.text = @"忘记密码？";
        pLabel.textAlignment = UITextAlignmentRight;
        [pButton addSubview:pLabel];
        
        //下划线
        UIImageView* pLineView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 21, 60, 0.5)];
        pLineView.backgroundColor = COLOR_FONT_6;
        [pButton addSubview:pLineView];
        
        
        int iTopY = 30;
        //预读协议的选择框
        pButton = [UIButton buttonWithType:UIButtonTypeCustom];
        pButton.frame = CGRectMake(20, iTopY, 35, 35);
        pButton.tag = 3001;
   
        [pButton addTarget:self action:@selector(actionFlowButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [pCellObj.contentView addSubview:pButton];
        
        //选择框
        UIImageView* pSelImgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 20, 20)];
        pSelImgView.tag = 2001;
        pSelImgView.image = [UIImage imageNamed:@"checkbox_nil.png"];
        [pButton addSubview:pSelImgView];
        
        
        //具体协议的部分
        pButton = [UIButton buttonWithType:UIButtonTypeCustom];
        pButton.frame = CGRectMake(55, iTopY, 255, 40);
        pButton.tag = 3002;
        [pButton addTarget:self action:@selector(actionViewProtocolBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [pCellObj.contentView addSubview:pButton];
        //协议名称
        UILabel* pLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 255, 20)];
        pLable.textAlignment = NSTextAlignmentLeft;
        pLable.backgroundColor = [UIColor clearColor];
        pLable.font = [UIFont systemFontOfSize:12];
        pLable.textColor = COLOR_FONT_1;
        pLable.tag = 1001;
        pLable.text = @"";
        [pButton addSubview:pLable];
        
        pLineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 26, 1, 0.5)];
        pLineView.tag = 2002;
        pLineView.backgroundColor = COLOR_FONT_1;
        [pButton addSubview:pLineView];
        
        iTopY+=40;
        //确认投标的按钮
        pButton = [UIButton buttonWithType:UIButtonTypeCustom];
        pButton.frame = CGRectMake(10, iTopY, self.view.frame.size.width-20, 35);
        pButton.tag = 3002;
        
        [pButton addTarget:self action:@selector(onConfirmTenderClicked:) forControlEvents:UIControlEventTouchUpInside];
        _uiConfirmStepButton = pButton;
        [UIOwnSkin setButtonBackground:pButton andColor:COLOR_BTN_BORDER_1];
        [pButton setTitle:@"确认投标" forState:UIControlStateNormal];
        pButton.enabled = NO;
        [pCellObj.contentView addSubview:pButton];
        
        iTopY+=40;
        pLable = [[UILabel alloc] initWithFrame:CGRectMake(10, iTopY, self.view.frame.size.width-20, 20)];
        pLable.textAlignment = NSTextAlignmentCenter;
        pLable.backgroundColor = [UIColor clearColor];
        pLable.font = [UIFont systemFontOfSize:12];
        pLable.textColor = COLOR_FONT_2;
        pLable.tag = 1002;
        pLable.text = @"资金账户安全有中国银行监管";
        [pCellObj.contentView addSubview:pLable];
        
        iTopY+=20;
        pLable = [[UILabel alloc] initWithFrame:CGRectMake(10, iTopY, self.view.frame.size.width-20, 20)];
        pLable.textAlignment = NSTextAlignmentCenter;
        pLable.backgroundColor = [UIColor clearColor];
        pLable.font = [UIFont systemFontOfSize:12];
        pLable.textColor = COLOR_FONT_1;
        pLable.tag = 1003;
        pLable.text = @"募集成功次日开始计算";
        [pCellObj.contentView addSubview:pLable];
        
    }
    
    UILabel* pLabel = (UILabel*)[pCellObj viewWithTag:1001];
    if(pLabel)
    {
        NSString* strProtocolName = m_strProtocolName;
        int iLength = m_strProtocolName.length;
        if(iLength > 14)
        {
            strProtocolName = [strProtocolName substringToIndex:13];
            strProtocolName = [strProtocolName stringByAppendingString:@"..."];
        }
        pLabel.text = [NSString stringWithFormat:@"已阅读并同意<<%@>>",strProtocolName];
    }
    
    
    UIImageView* pLineView = (UIImageView*)[pCellObj.contentView viewWithTag:2002];
    if(pLineView)
    {
        CGRect rcLine = pLineView.frame;
        rcLine.origin.x = 80;
        int iWidth = m_strProtocolName.length*12;
        if(iWidth > 160)
            iWidth = 160;
        rcLine.size.width = iWidth;
        pLineView.frame = rcLine;
    }

    return pCellObj;
}

//加载cell
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell* pCellObj = nil;
    if(indexPath.row == 0)
    {
        pCellObj = [self getTenderTopBarCell:tableView andIndexPath:indexPath];
    }
    else if(indexPath.row == 1)
    {
        pCellObj = [self getTenderMiddlePayTypeCell:tableView andIndexPath:indexPath];
    }
    else if(indexPath.row == 2)
    {
        pCellObj = [self getTradePwdInputFieldCell:tableView andIndexPath:indexPath];
    }
    else
    {
        pCellObj = [self getLastHintInfoOrButtonCell:tableView andIndexPath:indexPath];
    }
    return pCellObj;
    
}



-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.row == 0)
    {
        return 90;
    }
    if(indexPath.row == 1)
    {
        //return 150;
        return 50;
    }
    if(indexPath.row == 2)
    {
        return 60;
    }
    
    return 140;
}

//4个Section
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(_strProductId.length < 1 || m_strProtocolName.length < 1)
        return 0;
    return 1;
}


//4行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 4;
    
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


#pragma UserIdSignInfoPopupViewDelegate


-(void)onUserIdSignInfoClicked:(NSString*)strCardId andName:(NSString*)strUserName
{
   
    [[KGModal sharedInstance] hide];
    //m_pIdSignView = nil;
    self.sdk = [[LLPaySdk alloc] init];
    self.sdk.sdkDelegate = self;
    m_llDictPay[@"id_no"] = strCardId;
    m_llDictPay[@"acct_name"] = strUserName;
    //m_llDictPay[@"card_no"] = @"6227001540140127453";
    
    [ self.sdk presentPaySdkInViewController:self withTraderInfo:m_llDictPay];
}


@end
