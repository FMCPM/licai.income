//
//  BillPaymentViewController.m

//
//  Created by Mavericks on 14-3-20.
//  Copyright (c) 2014年 ytinfo. All rights reserved.
//

#import "BillPaymentViewController.h"
#import "UIOwnSkin.h"
#import <QuartzCore/QuartzCore.h>
#import "GlobalDefine.h"

#import "SVProgressHUD.h"
#import "CKHttpHelper.h"
#import "UaConfiguration.h"



@interface BillPaymentViewController ()

@end

@implementation BillPaymentViewController

@synthesize m_uiPayTableView = _uiPayTableView;
@synthesize m_strOrderId  = _strOrderId;
@synthesize m_pOrderPayInfoData =  _pOrderPayInfoData;
@synthesize m_iOrderType = _iOrderType;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.hidesBottomBarWhenPushed = YES;
        _iOrderType = 1;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _result = @selector(paymentResult:);
    self.navigationItem.titleView = [UIOwnSkin navibarTitleView:@"收银台" andFrame:CGRectMake(0, 0, 100, 40)];
    
    //返回导航
    self.navigationItem.leftBarButtonItem = [UIOwnSkin backItemTarget:self action:@selector(backNavButtonAction:)];
    
    [self initUI];
    
    m_pllWallsdk = nil;
    //取订单详情
    [self loadOrderDetailInfo];
    //
    [_uiPayTableView reloadData];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [FeePayComMethod sharedInstance].m_pPayresultDelegate = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initUI
{

    self.view.backgroundColor = [UIColor whiteColor];
    CGRect rcFrame = self.view.frame;
    self.view.frame  = [UIOwnSkin getViewRectByIosVersion:rcFrame];
    rcFrame.origin.y = 0;
    _uiPayTableView = [[UITableView alloc]initWithFrame:rcFrame style:UITableViewStylePlain];
    _uiPayTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _uiPayTableView.separatorColor = [UIColor clearColor];
    _uiPayTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _uiPayTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _uiPayTableView.showsHorizontalScrollIndicator = NO;
    _uiPayTableView.showsVerticalScrollIndicator = NO;
    _uiPayTableView.backgroundColor = [UIColor whiteColor];
    _uiPayTableView.dataSource = self;
    _uiPayTableView.delegate = self;
    [self.view addSubview:_uiPayTableView];
    
 
}

-(void)viewDidAppear:(BOOL)animated
{
  
}


//查询订单详情
-(void)loadOrderDetailInfo
{
/*
    if(_strOrderId.length < 1  || [_strOrderId isEqualToString:@"0"])
    {
        if(_pOrderPayInfoData == nil)
        {
            [SVProgressHUD showErrorWithStatus:@"订单参数有错误！" duration:1.8];
            return;
        }
        _strOrderId = [_pOrderPayInfoData getFeildValue:0 andColumn:@"orderId"];
        [_uiPayTableView reloadData];
        return;
    }
    
    CKHttpHelper *httpHelper = [CKHttpHelper httpHelperWithOwner:self];
    httpHelper.m_iWebServerType = 1;
    httpHelper.methodType  = CKHttpMethodTypePost_Page;
    
    [httpHelper setMethodName:@"order.getDetail"];
    
    [httpHelper addParam:[UaConfiguration sharedInstance].m_setLoginState.m_strUserLoginSid forName:@"sid"];
    
    [httpHelper addParam:_strOrderId forName:@"orderId"];
    [httpHelper setCompleteBlock:^(id dataSet)
     {
         [SVProgressHUD dismiss];
         if(dataSet == nil)
         {
             [SVProgressHUD showErrorWithStatus:HINT_WEBDATA_NET_ERROR duration:1.8];
             return ;
         }
         QDataSetObj* pResultDataSet = dataSet;
         if([pResultDataSet getOpeResult] == false)
         {
             [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"订单参数错误：%@",[pResultDataSet getErrorText]] duration:1.8];
             return;
         }
         if([pResultDataSet getRowCount] < 1)
             return;
         
         _pOrderPayInfoData = [[QDataSetObj alloc ] init];
 
         [_pOrderPayInfoData addDataSetRow_Ext:0 andName:@"orderId" andValue:_strOrderId];
         [_pOrderPayInfoData addDataSetRow_Ext:0 andName:@"order_sn" andValue:[pResultDataSet getFeildValue:0 andColumn:@"order_sn"]];
         [_pOrderPayInfoData addDataSetRow_Ext:0 andName:@"order_snDisp" andValue:[pResultDataSet getFeildValue:0 andColumn:@"order_snDisp"]];
         
         NSString* strName = [pResultDataSet getFeildValue:0 andColumn:@"title"];
         NSString* strMemo = @"";
         NSString* strTotalPrice = [pResultDataSet getFeildValue:0 andColumn:@"totalPrice"];
         NSString* strOrderTime =[pResultDataSet getFeildValue:0 andColumn:@"orderTime"];
         if(strOrderTime.length > 0)
         {
             strOrderTime = [CSjqMessageObj convertToShowTime_pay:strOrderTime.integerValue];
         }
         NSString* strBuyerId = [pResultDataSet getFeildValue:0 andColumn:@"buyerId"];
         
         [_pOrderPayInfoData addDataSetRow_Ext:0 andName:@"orderTime" andValue:strOrderTime];
         
         [_pOrderPayInfoData addDataSetRow_Ext:0 andName:@"goodsName" andValue:strName];
         [_pOrderPayInfoData addDataSetRow_Ext:0 andName:@"goodsMemo" andValue:strMemo];
         [_pOrderPayInfoData addDataSetRow_Ext:0 andName:@"totalPrice" andValue:strTotalPrice];
         [_pOrderPayInfoData addDataSetRow_Ext:0 andName:@"buyerId" andValue:strBuyerId];
         [_uiPayTableView reloadData];
     }];
    [httpHelper setStartBlock:^{
        [SVProgressHUD showWithStatus:HINT_WEBDATA_LOADING];
    }];
    [httpHelper start];
*/
}


#pragma mark - onPayModeButtonClicked


- (void)onPayModeButtonClicked:(id)sender
{
    UIButton *btnSelect = (UIButton *)sender;
    
    UIButton *pButton1 = (UIButton *)[self.view viewWithTag:1000];
    UIButton *pButton2 = (UIButton *)[self.view viewWithTag:1001];
    UIButton *pButton3 = (UIButton *)[self.view viewWithTag:1002];
    
    switch (btnSelect.tag) {
        case 1000:
        {
            [pButton1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            pButton1.backgroundColor = COLOR_BUTTON_RECT;
            
            [pButton2 setTitleColor:COLOR_BUTTON_FONT forState:UIControlStateNormal];
            pButton2.backgroundColor = [UIColor clearColor];
            
            [pButton3 setTitleColor:COLOR_BUTTON_FONT forState:UIControlStateNormal];
            pButton3.backgroundColor = [UIColor clearColor];
        }
            break;
        case 1001:
        {
            [pButton2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            pButton2.backgroundColor = COLOR_BUTTON_RECT;
            
            [pButton1 setTitleColor:COLOR_BUTTON_FONT forState:UIControlStateNormal];
            pButton1.backgroundColor = [UIColor clearColor];
            
            [pButton3 setTitleColor:COLOR_BUTTON_FONT forState:UIControlStateNormal];
            pButton3.backgroundColor = [UIColor clearColor];
        }
            break;
        case 1002:
        {
            [pButton3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            pButton3.backgroundColor = COLOR_BUTTON_RECT;
            
            [pButton1 setTitleColor:COLOR_BUTTON_FONT forState:UIControlStateNormal];
            pButton1.backgroundColor = [UIColor clearColor];
            
            [pButton2 setTitleColor:COLOR_BUTTON_FONT forState:UIControlStateNormal];
            pButton2.backgroundColor = [UIColor clearColor];
        }
            break;
        default:
            break;
    }
}

#pragma mark - onNextButtonClicked
//点击支付
- (void)onNextButtonClicked:(id)sender
{
    
    UIButton* pButton = (UIButton*)sender;
    if(pButton == nil)
        return;
    
    int iTag = pButton.tag;
    if(iTag == 201)
        iTag = 202;
    else
        iTag = 201;
    UITableViewCell * pCellObj = (UITableViewCell*)[UIOwnSkin getSuperTableViewCell:pButton];
    if(pCellObj)
    {
        UIButton* pOtherBtn = (UIButton*)[pCellObj.contentView viewWithTag:iTag];
        if(pOtherBtn)
            pOtherBtn.layer.borderColor = COLOR_CELL_LINE_DEFAULT.CGColor;
    }
    pButton.layer.borderColor = COLOR_FONT_3.CGColor;
    //1支付宝；2连连科技;3余额
    iTag = pButton.tag;
    if(iTag == 201)
        m_iFeePayType  = 2;
    else if(iTag == 202)
        m_iFeePayType = 1;
    else
        m_iFeePayType = 0;
    if(m_iFeePayType == 0)
    {
        [SVProgressHUD showErrorWithStatus:@"必须选择一种支付方式！" duration:2.0];
        return;
    }
    if(m_iFeePayType == 3)
    {
        [SVProgressHUD showSuccessWithStatus:@"余额支付暂未开放，敬请期待！" duration:1.8];
        return;
    }
    [self startReallyFeePayFlow];
   /*
    //查询订单的支付结果,确保重复支付
    CKHttpHelper *httpHelper = [CKHttpHelper httpHelperWithOwner:self];
    httpHelper.m_iWebServerType = 1;
    httpHelper.methodType  = CKHttpMethodTypePost_Page;
    
    [httpHelper setMethodName:[NSString stringWithFormat:@"order.getOrderPayResult"]];
    
    [httpHelper addParam:[UaConfiguration sharedInstance].m_setLoginState.m_strUserLoginSid forName:@"sid"];
    [httpHelper addParam:_strOrderId forName:@"orderId"];
    [httpHelper addParam:[_pOrderPayInfoData getFeildValue:0 andColumn:@"order_sn"] forName:@"order_sn"];
    [httpHelper addParam:[NSString stringWithFormat:@"%d",m_iFeePayType] forName:@"payType"];
    //orderType:  1普通；2合并,对于多店铺需要合并、
    [httpHelper addParam:[NSString stringWithFormat:@"%d",_iOrderType] forName:@"orderType"];
    //新增输入参数，传入订单的金额
    NSString* strOrderFeeValue = [_pOrderPayInfoData getFeildValue:0 andColumn:@"totalPrice"];
//    [httpHelper addParam:strOrderFeeValue forName:@"totalPrice"];
    
    [httpHelper setCompleteBlock:^(id dataSet)
     {
         [SVProgressHUD dismiss];
         if(dataSet == nil)
         {
             [SVProgressHUD showErrorWithStatus:HINT_WEBDATA_NET_ERROR duration:1.8];
             return ;
         }
         QDataSetObj* pResultDataSet = dataSet;
         if([pResultDataSet getOpeResult] == false)
         {
             [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"支付失败：%@",[pResultDataSet getErrorText]] duration:1.8];
             return;
         }
         if([pResultDataSet getRowCount] < 1)
             return;
         NSString* strPayRetCode = [pResultDataSet getFeildValue:0 andColumn:@"payRetCode"];
         if([strPayRetCode isEqualToString:@"1"])
         {
             [SVProgressHUD showSuccessWithStatus:@"该订单已经成功支付！" duration:2.0];
             return;
         }
         
         if([strPayRetCode isEqualToString:@"99"])
         {
             [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"订单参数有误：%@",[pResultDataSet getFeildValue:0 andColumn:@"payRetMemo"]] duration:1.8];
             return;
         }
         
         NSString*strResultFeeValue = [pResultDataSet getFeildValue:0 andColumn:@"totalPrice"];
         float fResultFeeValue = 0;
         if(strResultFeeValue.length > 0)
             fResultFeeValue = strResultFeeValue.floatValue;
         if(fResultFeeValue < 0.001)
         {
             
             [SVProgressHUD showErrorWithStatus:@"订单价格有误！" duration:1.8];
             return;
         }
         //价格不一致，则以返回的价格为准
         if([strOrderFeeValue isEqualToString:strResultFeeValue] == false)
         {
             [_pOrderPayInfoData setFieldValue:0 andName:@"totalPrice" andValue:strResultFeeValue];
         }
         
         NSString* strBuyerId = [pResultDataSet getFeildValue:0 andColumn:@"buyerId"];
         if(strBuyerId.length > 0)
         {
             [_pOrderPayInfoData setFieldValue:0 andName:@"buyerId" andValue:strBuyerId];
         }
         [self startReallyFeePayFlow];
         
     }];
    [httpHelper setStartBlock:^{
        [SVProgressHUD showWithStatus:HINT_WEBDATA_SUBMITING];
    }];
    [httpHelper start];
    */
    
 
}

#pragma mark - backAction

- (void)backNavButtonAction:(id)sender
{
    /*
    UIViewController *pPopViewController = nil;
    
    int iViewCount = self.navigationController.viewControllers.count;
    if(iViewCount > 2)
    {
        
        pPopViewController = [self.navigationController.viewControllers objectAtIndex:iViewCount-3];
        if([pPopViewController isKindOfClass:[GoodsCarMngPageView class] ] == true)
        {

            GoodsCarMngPageView*pCarView = (GoodsCarMngPageView*)pPopViewController;
            if(pCarView)
                pCarView.m_iIsNeedRefresh = 1;
            [self.navigationController popToViewController:pCarView animated:YES];
            return;
        }
        else if([pPopViewController isKindOfClass:[GoodDetailInfoPageView class] ] == true)
        {
            [self.navigationController popToViewController:pPopViewController animated:YES];
            return;
        }
        else if ([pPopViewController isKindOfClass:[HomeViewController class]] == true)
        {
            [self.navigationController popToViewController:pPopViewController animated:YES];
            return;
        }
    }
    */
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UItableview delegate and datasource

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
    if(indexPath.row < 2)
        return 30;

    return 100;
}


-(UITableViewCell*)getTitleLabelTableCell:(UITableView*)tableView andIndexPath:(NSIndexPath*)indexPath
{
    static NSString* strTitleTableCellId = @"OrderTitleTableCellId";
    UITableViewCell* pCellObj = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:strTitleTableCellId];
    if (pCellObj == nil)
    {
        pCellObj = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strTitleTableCellId];
        pCellObj.selectionStyle = UITableViewCellSelectionStyleNone;
        pCellObj.contentView.backgroundColor = [UIColor whiteColor];
        

        UILabel*pLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,10, 280, 21)];
        pLabel.tag = 1001;
        pLabel.backgroundColor = [UIColor clearColor];
        pLabel.textColor = COLOR_FONT_1;
        pLabel.font = [UIFont systemFontOfSize:14];
        [pCellObj.contentView addSubview:pLabel];
        
        pLabel = [[UILabel alloc] initWithFrame:CGRectMake(280,10, 10, 21)];
        pLabel.tag = 1002;
        pLabel.backgroundColor = [UIColor clearColor];
        pLabel.textColor = COLOR_FONT_3;
        pLabel.font = [UIFont boldSystemFontOfSize:14];
        [pCellObj.contentView addSubview:pLabel];
        [pLabel setHidden:YES];
        
        UIImageView* pLineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 39, 320, 1)];
        pLineView.backgroundColor = COLOR_CELL_LINE_DEFAULT;
        pLineView.tag = 1003;
        [pCellObj.contentView addSubview:pLineView];
        [pLineView setHidden:YES];
    }
    
    UILabel* pLabel1 = (UILabel*)[pCellObj.contentView viewWithTag:1001];
    UILabel* pLabel2 = (UILabel*)[pCellObj.contentView viewWithTag:1002];
    UIImageView* pLineView = (UIImageView*)[pCellObj.contentView viewWithTag:1003];
    if(pLabel1 == nil || pLabel2 == nil || pLineView==nil)
        return pCellObj;
    [pLabel2 setHidden:YES];
    [pLineView setHidden:YES];
    if(indexPath.row == 0)
    {
        
        pLabel1.text =[NSString stringWithFormat:@"订单编号：%@",[_pOrderPayInfoData getFeildValue:0 andColumn:@"order_snDisp"]];
    }

    else if(indexPath.row == 1)
    {
        CGRect rcLabel = pLabel1.frame;
        rcLabel.size.width = 75;
        pLabel1.frame = rcLabel;
        
        pLabel1.text = @"订单金额：";
        
        rcLabel = pLabel2.frame;
        rcLabel.origin.x = 85;
        rcLabel.size.width = 120;
        pLabel2.frame = rcLabel;
        [pLabel2 setHidden:NO];
        pLabel2.text = [NSString stringWithFormat:@"￥%@",[_pOrderPayInfoData getFeildValue:0 andColumn:@"totalPrice"]];
        [pLineView setHidden:NO];
    }
    
    /*
    else if(indexPath.row == 2)
    {
        pLabel1.text = @"请选择支付方式";
        [pLineView setHidden:NO];
        
    }*/
    return pCellObj;
}


-(UITableViewCell*)getFeePayTypeTableCell:(UITableView*)tableView andIndexPath:(NSIndexPath*)indexPath
{
    static NSString* strFeePayTypeCellId = @"FeePayTypeTableCellId";
    UITableViewCell* pCellObj = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:strFeePayTypeCellId];
    if (pCellObj == nil)
    {
        pCellObj = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strFeePayTypeCellId];
        pCellObj.selectionStyle = UITableViewCellSelectionStyleNone;
        pCellObj.contentView.backgroundColor = [UIColor whiteColor];
        
        
        UIImageView*pLineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 9, 320, 1)];
        pLineView.backgroundColor = COLOR_CELL_LINE_DEFAULT;
        [pCellObj.contentView addSubview:pLineView];
        
        UIView*pBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 10,320 , 40)];
        pBarView.backgroundColor = COLOR_VIEW_BACKGROUND;
        [pCellObj.contentView addSubview:pBarView];
        UILabel* pLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,8, 200, 21)];
        pLabel.tag = 1001;
        pLabel.backgroundColor = [UIColor clearColor];
        pLabel.textColor = COLOR_FONT_1;
        pLabel.font = [UIFont systemFontOfSize:14];
        pLabel.text = @"请选择支付方式";
        [pBarView addSubview:pLabel];

        pLineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50, 320, 1)];
        pLineView.backgroundColor = COLOR_CELL_LINE_DEFAULT;
        [pCellObj.contentView addSubview:pLineView];
        
        
        //连连支付
        UIButton*pButton = [UIButton buttonWithType:UIButtonTypeCustom];
        pButton.frame = CGRectMake(15, 60, 140, 35);
        pButton.tag = 201;
        [pButton addTarget:self action:@selector(onNextButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        UIImageView* pBtnImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 30, 15)];
        pBtnImage.image = [UIImage imageNamed:@"logo_llwallet.png"];
        [pButton addSubview:pBtnImage];
        
        pLabel = [[UILabel alloc] initWithFrame:CGRectMake(60,6, 60, 21)];
        pLabel.backgroundColor = [UIColor clearColor];
        pLabel.textColor = COLOR_FONT_1;
        pLabel.font = [UIFont systemFontOfSize:14];
        pLabel.text = @"连连科技";
        pLabel.textAlignment  = UITextAlignmentCenter;
        [pButton addSubview:pLabel];
        pButton.layer.borderColor = COLOR_CELL_LINE_DEFAULT.CGColor;
        pButton.layer.borderWidth = 1.0f;
        pButton.layer.cornerRadius= 1.0f;
        [pCellObj.contentView addSubview:pButton];
        
 /*
        //支付宝支付
        pButton = [UIButton buttonWithType:UIButtonTypeCustom];
        pButton.frame = CGRectMake(165, 60, 140, 35);
        pButton.tag = 202;
        [pButton addTarget:self action:@selector(onNextButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        pBtnImage = [[UIImageView alloc] initWithFrame:CGRectMake(30, 7, 16, 20)];
        pBtnImage.image = [UIImage imageNamed:@"logo_alipay.png"];
        [pButton addSubview:pBtnImage];
        
        pLabel = [[UILabel alloc] initWithFrame:CGRectMake(60,6, 50, 21)];
        pLabel.backgroundColor = [UIColor clearColor];
        pLabel.textColor = COLOR_FONT_1;
        pLabel.font = [UIFont systemFontOfSize:14];
        pLabel.text = @"支付宝";
        pLabel.textAlignment  = UITextAlignmentCenter;
        [pButton addSubview:pLabel];
        pButton.layer.borderColor = COLOR_CELL_LINE_DEFAULT.CGColor;
        pButton.layer.borderWidth = 1.0f;
        pButton.layer.cornerRadius= 1.0f;
        [pCellObj.contentView addSubview:pButton];
  */
        
    }

    return pCellObj;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* pCellObj = nil;
    if(indexPath.row < 2)
    {
        pCellObj = [self getTitleLabelTableCell:tableView andIndexPath:indexPath];
        return pCellObj;
    }
    pCellObj = [self getFeePayTypeTableCell:tableView andIndexPath:indexPath];
    return pCellObj;
    /*
    
    if(indexPath.row < 5)
    {

    }
    
    static NSString* strOrderSubmitBtnCellId = @"OrderSubmitBtnCellId";
    pCellObj = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:strOrderSubmitBtnCellId];
    if (pCellObj == nil)
    {
        pCellObj = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strOrderSubmitBtnCellId];
        pCellObj.selectionStyle = UITableViewCellSelectionStyleNone;
        pCellObj.contentView.backgroundColor = [UIColor whiteColor];
        
        UIButton*pButton = [UIButton buttonWithType:UIButtonTypeCustom];
        pButton.frame = CGRectMake(60, 10, 200, 35);
        [UIOwnSkin setButtonFontRect:pButton];
        pButton.titleLabel.font  =[UIFont systemFontOfSize:14];
        pButton.titleLabel.textAlignment = UITextAlignmentCenter;
        pButton.tag = 1004;
        [pButton addTarget:self action:@selector(onNextButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [pButton setTitle:@"支付" forState:UIControlStateNormal];
        [pCellObj.contentView addSubview:pButton];        

    }
  
    return pCellObj;*/
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int iCellRow = indexPath.row;
    if(iCellRow < 3 || iCellRow>4)
        return;
    if(m_iFeePayType > 0)
    {
        [self setFeePayTypeCellSelected:m_iFeePayType+2 andFlag:false];
        
    }
    m_iFeePayType = iCellRow - 2;
    [self setFeePayTypeCellSelected:m_iFeePayType+2 andFlag:true];

}


-(void)setFeePayTypeCellSelected:(NSInteger)iCellRow andFlag:(bool)blFlag
{
    NSIndexPath*indexPath = [NSIndexPath indexPathForRow:iCellRow inSection:0];
    UITableViewCell* pCellObj = [_uiPayTableView cellForRowAtIndexPath:indexPath];
    if(pCellObj == nil)
        return;
    UIImageView*pImageView = (UIImageView*)[pCellObj.contentView viewWithTag:1002];
    if(pImageView == nil)
        return;
    UILabel*pLabel = (UILabel*)[pCellObj.contentView viewWithTag:1001];
    
    if(blFlag)
    {
        pImageView.image = [UIImage imageNamed:@"checkbox_selected.png"];
        pCellObj.contentView.backgroundColor = COLOR_BAR_BACKGROUND;
        pLabel.textColor = COLOR_FONT_3;
    }
    else
    {
        pImageView.image = [UIImage imageNamed:@"checkbox_nil.png"];
        pCellObj.contentView.backgroundColor = [UIColor whiteColor];
        pLabel.textColor = COLOR_FONT_1;
    }
    
}

//启动支付接口，支付费用
-(void)startReallyFeePayFlow
{

    //确认支付
    NSString* strOrderSn = [_pOrderPayInfoData getFeildValue:0 andColumn:@"order_sn"];
    NSString* strFeeValue = [_pOrderPayInfoData getFeildValue:0 andColumn:@"totalPrice"];
    //strFeeValue = @"0.01";
    //商品名称
    NSString* strOrderName = [_pOrderPayInfoData getFeildValue:0 andColumn:@"goodsName"];
    
    NSString* strOrderMemo = [_pOrderPayInfoData getFeildValue:0 andColumn:@"goodsMemo"];
    
    if(strOrderMemo.length < 1)
        strOrderMemo = strOrderName;
    //买家ID，连连支付需要此参数
    NSString* strBuyerId = [_pOrderPayInfoData getFeildValue:0 andColumn:@"buyerId"];
    
    if(m_iFeePayType == 1)
    {
      [self startFeePayByAlipay:strOrderSn andTitle:strOrderName andDesp:strOrderMemo andPrice:strFeeValue.floatValue];
    }
    else if (m_iFeePayType == 2)
    {
        NSString* strOrderTime = [_pOrderPayInfoData getFeildValue:0 andColumn:@"orderTime"];
        [self startFeePayByLLWall:strOrderSn andTitle:strOrderName andDesp:strOrderMemo andPrice:strFeeValue.floatValue andTime:strOrderTime andBuyerId:strBuyerId];
    }
  
 }

//支付宝支付
-(bool)startFeePayByAlipay:(NSString*)strOrderSn andTitle:(NSString*)strOrderTitle andDesp:(NSString*)strOrderDesp andPrice:(float)fPrice
{
/*
   // fPrice = 0.01;
    NSString *strOrderString = [[FeePayComMethod sharedInstance  ]getSignedFeePayByAlipay:strOrderSn andTitle:strOrderTitle andDesp:strOrderDesp andPrice:fPrice andOrderId:_strOrderId andOrderType:_iOrderType];
    if(strOrderString.length < 1)
        return false;
    [FeePayComMethod sharedInstance].m_pPayresultDelegate = self;
    NSLog(@"alipay order string=%@",strOrderString);
	//
    [AlixLibService payOrder:strOrderString AndScheme:@"Hz-E-EasyBuy" seletor:_result target:self];
    
    return  true;
*/
}

//支付宝的wap回调函数
/*
-(void)paymentResult:(NSString *)strResultd
{
    AlixPayResult* payResult = [[AlixPayResult alloc] initWithString:strResultd];

    [self onEndAlipayReturnResult:payResult];
}
 */

//启动银联支付
-(void)startFeePayByLLWall:(NSString*)strOrderSn andTitle:(NSString*)strOrderTitle andDesp:(NSString*)strOrderDesp andPrice:(float)fPrice andTime:(NSString*)strOrderTime andBuyerId:(NSString*)strBuyerId
{
    /*
    m_pllWallsdk = [[LLWalletSdk alloc] init];
    m_pllWallsdk.sdkDelegate = self;
    
    m_pllWallsdk.traderInfo = [[FeePayComMethod sharedInstance] getFeePayByLLWall:strOrderSn andTitle:strOrderTitle andDesp:strOrderDesp andPrice:fPrice andTime:strOrderTime andOrderId:_strOrderId andOrderType:_iOrderType andBuyerId:strBuyerId];
    
    [m_pllWallsdk presentWalletInViewController:self];
     */
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
                
                //
                [self nodifyToServerPayResult:1 andResultMemo:strMsg];
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
    [self performSelector:@selector(backToOrderDetailView) withObject:nil afterDelay:1.8];
 
}
*/

//通知服务的支付结果
//1_支付成功;2_支付失败
-(void)nodifyToServerPayResult:(NSInteger)iResultId andResultMemo:(NSString*)strResultMemo
{

    //查询订单的支付结果,确保重复支付
    CKHttpHelper *httpHelper = [CKHttpHelper httpHelperWithOwner:self];
    httpHelper.m_iWebServerType = 1;
    httpHelper.methodType  = CKHttpMethodTypePost_Page;
    
    [httpHelper setMethodName:[NSString stringWithFormat:@"order.payOrderResult"]];
    
    [httpHelper addParam:[UaConfiguration sharedInstance].m_setLoginState.m_strUserLoginSid forName:@"sid"];
    [httpHelper addParam:_strOrderId forName:@"orderId"];
    [httpHelper addParam:[_pOrderPayInfoData getFeildValue:0 andColumn:@"order_sn"] forName:@"order_sn"];
    
    [httpHelper addParam:[_pOrderPayInfoData getFeildValue:0 andColumn:@"totalPrice"] forName:@"orderFee"];
    [httpHelper addParam:[_pOrderPayInfoData getFeildValue:0 andColumn:@"goodsName"] forName:@"orderTitle"];
    [httpHelper addParam:[_pOrderPayInfoData getFeildValue:0 andColumn:@"goodsMemo"] forName:@"orderMemo"];
    [httpHelper addParam:[NSString stringWithFormat:@"%d",m_iFeePayType] forName:@"payType"];
    //payResult：支付结果:1成功；2失败
    [httpHelper addParam:[NSString stringWithFormat:@"%d",iResultId] forName:@"payResult"];
    //payRetMemo：支付结果说明，如果是失败，则返回失败的原因描述
    [httpHelper addParam:strResultMemo forName:@"payRetMemo"];
    
    //orderType:  1普通；2合并,对于多店铺需要合并、
    [httpHelper addParam:[NSString stringWithFormat:@"%d",_iOrderType] forName:@"orderType"];
    
    
    [httpHelper setCompleteBlock:^(id dataSet)
     {
        //[SVProgressHUD dismiss];
         [SVProgressHUD showSuccessWithStatus:strResultMemo duration:1.8];
         [self performSelector:@selector(backToOrderDetailView) withObject:nil afterDelay:1.8];
         
     }];
    [httpHelper setStartBlock:^{
        //[SVProgressHUD showWithStatus:HINT_WEBDATA_SUBMITING];
    }];
    [httpHelper start];
}




@end
