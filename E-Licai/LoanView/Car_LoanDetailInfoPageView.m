//
//  LoanDetailInfoPageView.h

//  汽车贷款-产品详情页面

//  Created by lzq on 2014-03-04.
//

#import "Car_LoanDetailInfoPageView.h"
#import "UaConfiguration.h"
#import "CKHttpHelper.h"
#import "CKKit.h"
#import <QuartzCore/QuartzCore.h>
#import "UIOwnSkin.h"
#import "GlobalDefine.h"
#import "AppInitDataMethod.h"
#import "LoanDetailTableCell.h"
#import "Car_LoanTenderInfoListView.h"
#import "Car_LoanProjectInfoView.h"
#import "Car_LoanRiskSafePageView.h"
#import "Car_TenderFlowView_Setp1.h"
#import "Car_EstimateInComePageView.h"
#import "DDAddBankCardPageInfo.h"
#import "UILabel+CKKit.h"
#import "JsonXmlParserObj.h"
#import "AppInitDataMethod.h"
#import "Car_LoanEnterInfoPageView.h"
#import "DDUserSignInfoPageView.h"
#import "AppInitDataMethod.h"

@interface Car_LoanDetailInfoPageView ()

@end

@implementation Car_LoanDetailInfoPageView

@synthesize m_uiMainTableView = _uiMainTableView;
@synthesize m_uiBottomBarView = _uiBottomBarView;
@synthesize m_strProductId = _strProductId;
@synthesize m_strProductName = _strProductName;
@synthesize m_iLoanType = _iLoanType;
@synthesize m_strMinTenderMoney = _strMinTenderMoney;

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
    self.navigationItem.titleView = [UIOwnSkin navibarTitleView:_strProductName andFrame:CGRectMake(0, 0, 100, 40)];
    //导航返回
    self.navigationItem.leftBarButtonItem = [UIOwnSkin backItemTarget:self action:@selector(backNavButtonAction:)];
    _uiMainTableView = nil;
    _uiBottomBarView = nil;
    m_pInfoDataSet = nil;
    m_isStartingTender = NO;
}

-(void)viewWillAppear:(BOOL)animated
{
    if(_uiMainTableView != nil)
    {
        if(m_isStartingTender == YES)
        {
            m_isStartingTender = NO;
            if([[UaConfiguration sharedInstance] userIsHaveLoadinSystem] == YES)
            {
                [self actionStartTenderClicked:nil];
            }
            
        }
        return;
    }
    
    CGRect rcTable = self.view.frame;
    if(rcTable.origin.y != 0)
        rcTable.origin.y = 0;
    rcTable.size.height = self.view.frame.size.height - 40;
    
    _uiMainTableView = [[UITableView alloc]initWithFrame:rcTable style:UITableViewStylePlain];
    _uiMainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _uiMainTableView.separatorColor = [UIColor clearColor];
    _uiMainTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _uiMainTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _uiMainTableView.showsHorizontalScrollIndicator = NO;
    _uiMainTableView.showsVerticalScrollIndicator = NO;
    _uiMainTableView.backgroundColor = COLOR_VIEW_BK_01;
    _uiMainTableView.dataSource = self;
    _uiMainTableView.delegate = self;
    [self.view addSubview:_uiMainTableView];
    
    
    if(_uiBottomBarView != nil)
        return;
    _uiBottomBarView = [[UIView alloc] init];
    _uiBottomBarView.frame = CGRectMake(0, _uiMainTableView.frame.size.height, self.view.frame.size.width, 40);
    
    UIImageView* pLineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 1, self.view.frame.size.width, 1)];
    pLineView.backgroundColor = COLOR_CELL_LINE_DEFAULT;
    [_uiBottomBarView addSubview:pLineView];
    
    
    UIButton* pButton = [UIButton buttonWithType:UIButtonTypeCustom];
    pButton.frame = CGRectMake(175, 5, 130, 30);
    [UIOwnSkin setButtonBackground:pButton andColor:COLOR_FONT_7];
    pButton.enabled = NO;
    pButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [pButton setTitle:@"投标" forState:UIControlStateNormal];
    //
    [pButton addTarget:self action:@selector(actionStartTenderClicked:) forControlEvents:UIControlEventTouchUpInside];
    m_uiTenderButton = pButton;
    [_uiBottomBarView addSubview:pButton];
    
    //收益
    pButton = [UIButton buttonWithType:UIButtonTypeCustom];
    pButton.frame = CGRectMake(20, 5, 130, 30);

    pButton.titleLabel.font = [UIFont systemFontOfSize:14];
   
    UIImageView* pLogoImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 20, 20)];
    pLogoImg.image = [UIImage imageNamed:@"icon_product_calculator.png"];
    [pButton addSubview:pLogoImg];
    
    
    UILabel* pLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 5, 70, 20)];
    pLabel.textColor = COLOR_FONT_2;
    pLabel.text = @"预估收益";
    pLabel.font = [UIFont systemFontOfSize:12];
    [pButton addSubview:pLabel];
    
    [pButton addTarget:self action:@selector(actionEstimateInComeClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_uiBottomBarView addSubview:pButton];
    
    [self.view addSubview:_uiBottomBarView];
    
    [self loadProductDetialInfo_Web:0];
    
    
}

-(void)viewDidAppear:(BOOL)animated
{

}


- (void)backNavButtonAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

//启动投标
-(void)actionStartTenderClicked:(id)sender
{
    if([[UaConfiguration sharedInstance] userIsHaveLoadinSystem] == NO)
    {
        m_isStartingTender = YES;
        //弹出登录页面
        LoginViewController* pLoginView = [[LoginViewController alloc] init];
        pLoginView.m_iLoadOrigin = 3;
        pLoginView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:pLoginView animated:YES];
        return;
    }
    
    if(m_pInfoDataSet == nil || [m_pInfoDataSet getRowCount] < 1)
        return;
    

    //如果没有实名认证，则进入身份信息确认的流程
    if([UaConfiguration sharedInstance].m_setLoginState.m_strUserReallyName.length < 1)
    {
        //第一步改成先进行身份验证
        DDUserSignInfoPageView* pUserSignView = [[DDUserSignInfoPageView alloc] init];
        pUserSignView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:pUserSignView animated:YES];
        return;
    }

    //如果没有银行卡，则需要添加银行卡流程
    if([UaConfiguration sharedInstance].m_setLoginState.m_strBankCardSno.length < 1)
    {

        [self reloadUserBankInfo_Web];
        return;
    }

    Car_TenderFlowView_Setp1* pStepView1 = [[Car_TenderFlowView_Setp1 alloc] init];
    pStepView1.hidesBottomBarWhenPushed = YES;
    pStepView1.m_strProductName = _strProductName;
    pStepView1.m_strProductId = _strProductId;
    
    pStepView1.m_strLimitTime = [m_pInfoDataSet getFeildValue:0 andColumn:@"limitTime"];
    NSString* strMinMoney = [m_pInfoDataSet getFeildValue:0 andColumn:@"leastAmount"];
    if(strMinMoney.length < 1)
        strMinMoney = _strMinTenderMoney;
    pStepView1.m_strStartTenderMoney = strMinMoney;
    pStepView1.m_strTotalTenderMoney = [m_pInfoDataSet getFeildValue:0 andColumn:@"financingAmount"];
    
    [self.navigationController pushViewController:pStepView1 animated:YES];

}


//查询银行卡信息
-(void)reloadUserBankInfo_Web
{
    
    
    CKHttpHelper* pHttpHelper = [CKHttpHelper httpHelperWithOwner:self];
    pHttpHelper.m_iWebServerType = 1;
    pHttpHelper.methodType  = CKHttpMethodTypePost_Page;
    
    //专业市场的id
    [pHttpHelper setMethodName:[NSString stringWithFormat:@"memberInfo/queryUserBank"]];
    [pHttpHelper addParam:[NSString stringWithFormat:@"%d",[UaConfiguration sharedInstance].m_setLoginState.m_iUserMemberID] forName:@"memberId"];
    
    [pHttpHelper setCompleteBlock:^(id dataSet)
     {
         
         [SVProgressHUD dismiss];
         JsonXmlParserObj* pJsonObj = dataSet;
         if([self dealReceivedUserBankInfo:pJsonObj] == NO)
         {
             
             DDAddBankCardPageInfo* pAddBankView = [[DDAddBankCardPageInfo alloc] init];
             pAddBankView.hidesBottomBarWhenPushed = YES;
             [self.navigationController pushViewController:pAddBankView animated:YES];
         }
         else
         {
             Car_TenderFlowView_Setp1* pStepView1 = [[Car_TenderFlowView_Setp1 alloc] init];
             pStepView1.hidesBottomBarWhenPushed = YES;
             pStepView1.m_strProductName = _strProductName;
             pStepView1.m_strProductId = _strProductId;
             
             pStepView1.m_strLimitTime = [m_pInfoDataSet getFeildValue:0 andColumn:@"limitTime"];
             NSString* strMinMoney = [m_pInfoDataSet getFeildValue:0 andColumn:@"leastAmount"];
             if(strMinMoney.length < 1)
                 strMinMoney = _strMinTenderMoney;
             pStepView1.m_strStartTenderMoney = strMinMoney;
             pStepView1.m_strTotalTenderMoney = [m_pInfoDataSet getFeildValue:0 andColumn:@"financingAmount"];
             
             [self.navigationController pushViewController:pStepView1 animated:YES];
         }

         
     }];
    
    [pHttpHelper setStartBlock:^{
        [SVProgressHUD showWithStatus:HINT_WEBDATA_LOADING];
    }];
    
    [pHttpHelper start];
    
    
}

//银行卡等信息
-(bool)dealReceivedUserBankInfo:(JsonXmlParserObj*)pJsonObj
{
    if(pJsonObj == nil)
    {
        [SVProgressHUD showErrorWithStatus:HINT_WEBDATA_NET_ERROR duration:1.8];
        return NO;
    }
    
    QDataSetObj* pDataSet = [pJsonObj parsetoDataSet:@"data"];
    NSString* strBankLogoUrl = @"";
    if(pDataSet == nil)
        return NO;
    
    [UaConfiguration sharedInstance].m_setLoginState.m_strBankCardId = [pDataSet getFeildValue:0 andColumn:@"bankId"];
    [UaConfiguration sharedInstance].m_setLoginState.m_strBankCardSno = [pDataSet getFeildValue:0 andColumn:@"cardSno"];
    [UaConfiguration sharedInstance].m_setLoginState.m_strBankName = [pDataSet getFeildValue:0 andColumn:@"bankName"];
    strBankLogoUrl = [pDataSet getFeildValue:0 andColumn:@"logo"];
    
    if(strBankLogoUrl.length < 1)
    {
        return YES;
    }
    CKHttpImageHelper* pImageHelper = [CKHttpImageHelper httpHelperWithOwner:self];
    
    strBankLogoUrl = [AppInitDataMethod getImageFullUrlPath:strBankLogoUrl andImgFlag:1];
    NSURL *nsImageReqUrl = [NSURL URLWithString:strBankLogoUrl];
    
    [pImageHelper addImageUrl:nsImageReqUrl forKey:[NSString stringWithFormat:@"%d",1]];
    
    [_uiMainTableView reloadData];
    //
    [pImageHelper startWithReceiveBlock:^(UIImage *image,NSString *strKey,BOOL finsh)
     {
         
         if(image == nil || strKey == nil)
             return ;
         
         [UaConfiguration sharedInstance].m_setLoginState.m_pBankLogoImage = image;
         
         
     }];
    return YES;
}

//查看预估收益
-(void)actionEstimateInComeClicked:(id)sender
{
    Car_EstimateInComePageView* pEstView = [[Car_EstimateInComePageView alloc] init];
    QDataSetObj* pDataSet = [[QDataSetObj alloc] init];
    //融资金额
    [pDataSet addDataSetRow_Ext:0 andName:@"totalMoney" andValue:[m_pInfoDataSet getFeildValue:0 andColumn:@"financingAmount"]];
    //融资期限
    [pDataSet addDataSetRow_Ext:0 andName:@"limitTime" andValue:[m_pInfoDataSet getFeildValue:0 andColumn:@"limitTime"]];
 
    [pDataSet addDataSetRow_Ext:0 andName:@"productId" andValue:_strProductId];
    [pDataSet addDataSetRow_Ext:0 andName:@"productName" andValue:_strProductName];
    pEstView.m_pPrevDataSet = pDataSet;
    pEstView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:pEstView animated:YES];
}

//获取商品的详情信息
-(void)loadProductDetialInfo_Web:(NSInteger)iLoadFlag
{

    if(_strProductId.length < 1)
        return;
    
    CKHttpHelper *pHttpHelper = [CKHttpHelper httpHelperWithOwner:self];
    pHttpHelper.m_iWebServerType = 1;
    pHttpHelper.methodType  = CKHttpMethodTypePost_Page;
    [pHttpHelper setMethodName:[NSString stringWithFormat:@"productInfo/queryOneProduct"]];
    
    [pHttpHelper addParam:_strProductId forName:@"productId"];

    [pHttpHelper setCompleteBlock:^(id dataSet)
     {
         [SVProgressHUD dismiss];
         
         JsonXmlParserObj* pJsonObj = dataSet;
         if(pJsonObj == nil)
         {
             [SVProgressHUD showErrorWithStatus:HINT_WEBDATA_NET_ERROR duration:1.8];
             return ;
         }
         
         m_pInfoDataSet = [pJsonObj parsetoDataSet:@"data"];
         if(m_pInfoDataSet == nil)
             return;
         if([m_pInfoDataSet getOpeResult] == NO)
             return;
         if([m_pInfoDataSet getRowCount] < 1)
             return;
         NSString* strContents = [m_pInfoDataSet getFeildValue:0 andColumn:@"contents"];
         [m_pInfoDataSet addDataSetRow_Ext:0 andName:@"contents1" andValue:strContents];
         NSString* strContents2 = [NSString stringWithFormat:@"%@\r\n%@\r\n%@\r\n",[m_pInfoDataSet getFeildValue:0 andColumn:@"beInrestDate"],[m_pInfoDataSet getFeildValue:0 andColumn:@"repaymentDate"],[m_pInfoDataSet getFeildValue:0 andColumn:@"repaymentNotes"]];
         [m_pInfoDataSet addDataSetRow_Ext:0 andName:@"contents2" andValue:strContents2];
         
         NSString* strStatus = [m_pInfoDataSet getFeildValue:0 andColumn:@"status"];
         int iStatus = [QDataSetObj convertToInt:strStatus];
         //在查询单个产品的接口中 当status=1时投标按钮为灰色，不能点，当已投标金额等于融资总金额时或者状态status为3时，投标按钮也是灰色，改成”投标已结束”
         
         bool blEnabel = YES;
         bool blEnd = YES;
         if(iStatus == 1)
         {
             blEnabel = NO;
         }
         else if(iStatus == 3)
         {
             blEnabel = NO;
             blEnd = NO;
         }
         else
         {
             float fTotalFee = [m_pInfoDataSet getFeildValue_Float:0 andColumn:@"financingAmount"];
             float fHaveFee = [m_pInfoDataSet getFeildValue_Float:0 andColumn:@"hasFinancingAmount"];
             if(fHaveFee >= fTotalFee)
             {
                 blEnabel = NO;
                 blEnd = YES;
             }
             
         }
         m_uiTenderButton.enabled = blEnabel;
         if(blEnabel == NO)
         {
             [UIOwnSkin setButtonBackground:m_uiTenderButton andColor:COLOR_BTN_BORDER_1];
             [m_uiTenderButton setTitle:@"投标已结束" forState:UIControlStateNormal];

         }
         else
         {
             [m_uiTenderButton setTitle:@"投标" forState:UIControlStateNormal];
             [UIOwnSkin setButtonBackground:m_uiTenderButton andColor:COLOR_FONT_7];
         }

         [_uiMainTableView reloadData];
    }];
    [SVProgressHUD showWithStatus:HINT_WEBDATA_LOADING];
    [pHttpHelper start];

    
}


#pragma UITableViewDataSource,UITableViewDelegate

//tableviewCell的点击事件，暂时不需要处理
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath

{

    if(indexPath.row == 2)
    {
        Car_LoanTenderInfoListView* pListView = [[Car_LoanTenderInfoListView alloc] init];
        pListView.m_strProductId = _strProductId;
        pListView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:pListView animated:YES];
        return;
    }
    
    if(indexPath.row == 3)
    {
        Car_LoanProjectInfoView* pProjectView = [[Car_LoanProjectInfoView alloc] init];
        pProjectView.m_strProductId = _strProductId;
        pProjectView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:pProjectView animated:YES];
        return;
    }
    
    if(indexPath.row ==4)
    {
        Car_LoanRiskSafePageView* pRiskView = [[Car_LoanRiskSafePageView alloc] init];
        pRiskView.m_strProductId = _strProductId;
        pRiskView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:pRiskView animated:YES];
        return;
    }
    if(indexPath.row == 5)
    {
        Car_LoanEnterInfoPageView* pEnterView = [[Car_LoanEnterInfoPageView alloc] init];
        pEnterView.m_strProductId = _strProductId;
        pEnterView.m_strLoanEnterMemo = [m_pInfoDataSet getFeildValue:0 andColumn:@"companyDetail"];
        pEnterView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:pEnterView animated:YES];
        return;
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{

  
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
        return 220;
    if(indexPath.row == 1)
    {
        NSString* strContent1 = [m_pInfoDataSet getFeildValue:0 andColumn:@"contents1"];
        int iHeight1 = [UILabel getFitTextHeightWithText:strContent1 andWidth:self.view.frame.size.width-40 andFont:[UIFont systemFontOfSize:12]];
        if(iHeight1 < 70)
            iHeight1 = 70;
        NSString* strContent2 = [m_pInfoDataSet getFeildValue:0 andColumn:@"contents2"];
        int iHeight2 = [UILabel getFitTextHeightWithText:strContent2 andWidth:self.view.frame.size.width-40 andFont:[UIFont systemFontOfSize:12]]-4;
        if(iHeight2 < 60)
            iHeight2 = 60;
        
        int iTotalHeight = iHeight2+ iHeight1+50;
        return iTotalHeight;
    }
    
    return 60;
	
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(m_pInfoDataSet == nil)
        return 0;
    if(_iLoanType == 3)
        return 6;
    return 5;
}

//
-(UITableViewCell*)getTopTitleTableCell:(UITableView*)tableView andIndexPath:(NSIndexPath*)indexPath
{
    static NSString *strLoanDetailTableCellId = @"LoanDetailTableCellId";
    LoanDetailTableCell* pCellObj = (LoanDetailTableCell*)[tableView dequeueReusableCellWithIdentifier:strLoanDetailTableCellId];
    
    if (!pCellObj)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"LoanDetailTableCell" owner:self options:nil];
        pCellObj = [nib objectAtIndex:0];
        
        pCellObj.contentView.backgroundColor = [UIColor whiteColor];
        pCellObj.selectionStyle = UITableViewCellSelectionStyleNone;
        [pCellObj initCellDefaultShow];
    }
    //年化收益
    pCellObj.m_uiYearPcertLabel.text = [AppInitDataMethod convertPcertShow:[m_pInfoDataSet getFeildValue:0 andColumn:@"expectAnnual"]];
    
    //融资期限
    pCellObj.m_uiLongTimeLabel.text = [NSString stringWithFormat:@"%@个月",[m_pInfoDataSet getFeildValue:0 andColumn:@"limitTime"]];
    //融资金额
    NSString* strTotalFee = [m_pInfoDataSet getFeildValue:0 andColumn:@"financingAmount"];
    pCellObj.m_uiTotalMoneyLabel.text = strTotalFee;
    
    //已融资金额
    NSString* strHaveFee = [m_pInfoDataSet getFeildValue:0 andColumn:@"hasFinancingAmount"];
    float fPcert = [AppInitDataMethod calculatePcert:strHaveFee andTotal:strTotalFee];
    [pCellObj setProductPcertValue:fPcert];
    return pCellObj;
 
}

-(UITableViewCell*)getMiddleMemoTableCell:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath
{
    static NSString *strMiddleMemoTableCellId = @"MiddleMemoTableCellId";
    UITableViewCell *pCellObj = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:strMiddleMemoTableCellId];
    if (!pCellObj)
    {
        pCellObj = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strMiddleMemoTableCellId];
        pCellObj.contentView.backgroundColor = COLOR_VIEW_BK_01;
        pCellObj.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSString* strContent1 = [m_pInfoDataSet getFeildValue:0 andColumn:@"contents1"];
        int iHeight1 = [UILabel getFitTextHeightWithText:strContent1 andWidth:self.view.frame.size.width-40 andFont:[UIFont systemFontOfSize:12]];
        if(iHeight1 < 70)
            iHeight1 = 70;
        
        NSString* strContent2 = [m_pInfoDataSet getFeildValue:0 andColumn:@"contents2"];
        int iHeight2 = [UILabel getFitTextHeightWithText:strContent2 andWidth:self.view.frame.size.width-40 andFont:[UIFont systemFontOfSize:12]]-4;
        
        if(iHeight2 < 60)
            iHeight2 = 60;
        
        
        //cell的背景
        UIView*pBkView = [[UIView alloc] initWithFrame:CGRectMake(15, 10, self.view.frame.size.width-30, iHeight1+iHeight2)];
        pBkView.backgroundColor = [UIColor whiteColor];
        pBkView.layer.borderColor = COLOR_CELL_LINE_DEFAULT.CGColor;
        pBkView.layer.borderWidth = 1.0f;
        pBkView.layer.cornerRadius = 5.0;
        [pCellObj.contentView addSubview:pBkView];
        
        //贷款的条款
        UILabel* pLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 2, self.view.frame.size.width-40, iHeight1-4)];
        
        pLabel.textColor = COLOR_FONT_6;
        pLabel.textAlignment = NSTextAlignmentLeft;
        pLabel.numberOfLines = 0;
        pLabel.font = [UIFont systemFontOfSize:12];
        pLabel.text = strContent1;
        pLabel.tag  = 1001;
        [pBkView addSubview:pLabel];
        
        //中间的线条
        UIImageView* pLineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, iHeight1-1, self.view.frame.size.width-20, 1)];
        pLineView.backgroundColor = COLOR_CELL_LINE_DEFAULT;
        [pBkView addSubview:pLineView];
        
        
        pLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, iHeight1+2, self.view.frame.size.width-40, iHeight2-4)];
        pLabel.textColor = COLOR_FONT_2;
        pLabel.textAlignment = NSTextAlignmentLeft;
        pLabel.font = [UIFont systemFontOfSize:12];
        pLabel.numberOfLines = 0;
        pLabel.tag = 1002;
        pLabel.text = strContent2;
        [pBkView addSubview:pLabel];
        
        
        //
        pLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, iHeight1+iHeight2+20, 280, 15)];
        pLabel.textColor = COLOR_FONT_2;
        pLabel.textAlignment = NSTextAlignmentLeft;
        pLabel.font = [UIFont systemFontOfSize:12];
        pLabel.text = @"改成账户资金安全由连连支付第三方托管";
        pLabel.tag = 1003;
        [pCellObj.contentView addSubview:pLabel];
        
        
    }
    return pCellObj;
}

-(UITableViewCell*)getButtomTableCell:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath
{
    static NSString *strButtomTableCellId = @"ButtomTableCellId";
    UITableViewCell *pCellObj = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:strButtomTableCellId];
    if (!pCellObj)
    {
        pCellObj = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strButtomTableCellId];
        pCellObj.contentView.backgroundColor = COLOR_VIEW_BK_01;
        pCellObj.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView*pBkView = [[UIView alloc] initWithFrame:CGRectMake(15, 10, self.view.frame.size.width-30, 50)];
        pBkView.backgroundColor = [UIColor whiteColor];
        pBkView.layer.borderColor = COLOR_CELL_LINE_DEFAULT.CGColor;
        pBkView.layer.borderWidth = 1.0f;
        pBkView.layer.cornerRadius = 5.0;
        [pCellObj.contentView addSubview:pBkView];

        
        UIImageView*pLogoImgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 10, 10)];
        pLogoImgView.image = [UIImage imageNamed:@"point_red.png"];
        [pBkView addSubview:pLogoImgView];
        
        //标题
        UILabel* pLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 8, 180, 16)];
        pLabel.textColor = COLOR_FONT_7;
        pLabel.textAlignment = NSTextAlignmentLeft;
        pLabel.numberOfLines = 0;
        pLabel.font = [UIFont systemFontOfSize:12];
        pLabel.tag = 1001;
        [pBkView addSubview:pLabel];
        
        //内容1
        pLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 25, 180, 20)];
        pLabel.textColor = COLOR_FONT_1;
        pLabel.textAlignment = NSTextAlignmentLeft;
        pLabel.font = [UIFont systemFontOfSize:12];
        pLabel.tag = 1002;
        [pBkView addSubview:pLabel];
        
        //内容2
        pLabel = [[UILabel alloc] initWithFrame:CGRectMake(190, 20, 60, 20)];
        pLabel.textColor = COLOR_FONT_1;
        pLabel.textAlignment = NSTextAlignmentRight;
        pLabel.font = [UIFont systemFontOfSize:12];
        pLabel.tag = 1003;
        [pBkView addSubview:pLabel];
        
        
        UIImageView* pArrowView = [[UIImageView alloc] initWithFrame:CGRectMake(270, 15, 10, 20)];

        pArrowView.image = [UIImage imageNamed:@"icon_arrow_right_yellow"];
        [pBkView addSubview:pArrowView];
        
        UIImageView* pLineView = [[UIImageView alloc] initWithFrame:CGRectMake(260, 0, 1, 50)];
        pLineView.backgroundColor = COLOR_CELL_LINE_DEFAULT;
        [pBkView addSubview:pLineView];
        
    }
    
    UILabel* pLabel1 = (UILabel*)[pCellObj.contentView viewWithTag:1001];
    UILabel* pLabel2 = (UILabel*)[pCellObj.contentView viewWithTag:1002];
    UILabel* pLabel3 = (UILabel*)[pCellObj.contentView viewWithTag:1003];
    if(pLabel1 == nil || pLabel2 == nil || pLabel3 == nil)
        return pCellObj;
    
    CGRect rcLabel2 = pLabel2.frame;
    if(indexPath.row == 2)
    {
        pLabel3.hidden = NO;
        rcLabel2.size.width = 180;
        pLabel2.frame = rcLabel2;
        pLabel1.text = @"投标情况";
        pLabel2.text = @"已投标人数";
        pLabel3.text = [NSString stringWithFormat:@"%@人",[m_pInfoDataSet getFeildValue:0 andColumn:@"hasbid"]];
    }
    else
    {
        pLabel3.hidden = YES;
        rcLabel2.size.width = 240;
        pLabel2.frame = rcLabel2;
        if(indexPath.row == 3)
        {
            pLabel1.text = @"项目描述";
            pLabel2.text = [m_pInfoDataSet getFeildValue:0 andColumn:@"description"];
        }
        else if(indexPath.row == 4)
        {
            pLabel1.text = @"风险措施";
            pLabel2.text = [m_pInfoDataSet getFeildValue:0 andColumn:@"riskShortDtl"];
            
        }
        else if(indexPath.row == 5)
        {
            pLabel1.text = @"企业信息";
            pLabel2.text = [m_pInfoDataSet getFeildValue:0 andColumn:@"companyDetail"];
        }

        
    }
    
    return pCellObj;
}


//加载tableview cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{	

    UITableViewCell* pCellObj = nil;
    if(indexPath.row == 0)
    {
        pCellObj =  [self getTopTitleTableCell:tableView andIndexPath:indexPath];
    }
    else if(indexPath.row ==1)
    {
        pCellObj = [self getMiddleMemoTableCell:tableView indexPath:indexPath];
    }
    else
    {
        pCellObj = [self getButtomTableCell:tableView indexPath:indexPath];
    }

    
    return pCellObj;
	
}

@end
