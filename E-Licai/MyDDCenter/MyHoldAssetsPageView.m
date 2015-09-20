//
//  MyHoldAssetsPageView.m
//  我的叮叮-持有资产
//
//  Created by lzq on 2014-11-18
//
//

#import "MyHoldAssetsPageView.h"
#import "CKKit.h"
#import "UIOwnSkin.h"
#import "GlobalDefine.h"
#import "AppInitDataMethod.h"
#import "MyHoldBackMoneyLogView.h"
#import "UaConfiguration.h"
#import "JsonXmlParserObj.h"
#import "WebViewController.h"
#import "MyHoldBackMoneyPlanView.h"
#import "DDTransMakeTurePageView.h"

@interface MyHoldAssetsPageView ()

@end

@implementation MyHoldAssetsPageView
@synthesize m_uiMainTableView = _uiMainTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}



- (void)viewDidLoad
{
	self.navigationController.navigationBar.translucent = NO;
    //
    self.navigationItem.titleView = [UIOwnSkin navibarTitleView:@"持有资产" andFrame:CGRectMake(0, 0, 100, 40)];
    
    _uiMainTableView = nil;
    
    //左边返回按钮
    self.navigationItem.leftBarButtonItem = [UIOwnSkin backItemTarget:self action:@selector(backNavButtonAction:)];
    //
    [super viewDidLoad];
}



-(void)viewWillAppear:(BOOL)animated
{
    [self initTableView];
    
    [self loadHoldAssetsInfo_Web ];
}

-(void)viewDidAppear:(BOOL)animated
{

}

-(void)viewDidDisappear:(BOOL)animated
{
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)backNavButtonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


//初始化视图
-(void)initTableView
{
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
    
    m_pInfoDataSet = nil;
    //
    
}

//转让操作
-(void)actionToCheckTransMoneyClicked:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    NSString *title = btn.titleLabel.text;
    
    UITableViewCell* pCellObj = [UIOwnSkin getSuperTableViewCell:sender];
    NSIndexPath* indexPath = [_uiMainTableView indexPathForCell:pCellObj];
    if(indexPath == nil)
        return;
    int iDataRow = indexPath.row-1;
    if(iDataRow < 0 || iDataRow >= [m_pInfoDataSet getRowCount])
        return;
    
    NSString* strRelId = [m_pInfoDataSet getFeildValue:indexPath.row-1 andColumn:@"relId"];
    NSString* strProductName = [m_pInfoDataSet getFeildValue:indexPath.row-1 andColumn:@"productName"];
    NSString* strProductId = [m_pInfoDataSet getFeildValue:indexPath.row-1 andColumn:@"productId"];

    if([title isEqualToString:@"转让"]) {
        //转让
        DDTransMakeTurePageView *vc = [[DDTransMakeTurePageView alloc] init];
        vc.relId = strRelId;
        vc.productId = strProductId;
        vc.transName = strProductName;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else if([title isEqualToString:@"取消转让"]) {
        CKHttpHelper*  pHttpHelper = [CKHttpHelper httpHelperWithOwner:self];
        pHttpHelper.m_iWebServerType = 1;
        pHttpHelper.methodType = CKHttpMethodTypePost_Page;
        //设置webservice方法名
        [pHttpHelper setMethodName:@"debtorInfo/cancelTransApp"];
        [pHttpHelper addParam:[NSString stringWithFormat:@"%d",[UaConfiguration sharedInstance].m_setLoginState.m_iUserMemberID] forName:@"memberId"];
        
        [pHttpHelper addParam:strRelId forName:@"dataId"];
        
        [pHttpHelper setCompleteBlock:^(id dataSet)
         {
             [SVProgressHUD dismiss];
             JsonXmlParserObj* pJsonObj = dataSet;
             if(pJsonObj == nil)
             {
                 [SVProgressHUD showErrorWithStatus:HINT_WEBDATA_NET_ERROR duration:1.8];
                 return ;
             }
             NSString *operFlag = [pJsonObj getJsonValueByKey:@"operFlag"];
             if(operFlag.boolValue) {
                 [SVProgressHUD showSuccessWithStatus:@"取消成功" duration:1.8];
             } else {
                 [SVProgressHUD showSuccessWithStatus:@"取消失败" duration:1.8];
             }
             [self loadHoldAssetsInfo_Web];

         }];
        
        [pHttpHelper setStartBlock:^{
            [SVProgressHUD showWithStatus:HINT_WEBDATA_LOADING];
        }];
        
        
        [pHttpHelper start];

    } else if([title isEqualToString:@"转让中"]) {
        
    }
    
    //取消转让
    //转让中
}

//查看还款记录

-(void)actionBackMoneyLogClicked:(id)sender
{

    UIButton* pButton = (UIButton*)sender;
    if(pButton == nil)
        return;


    if(pButton.tag == 2003)//查看还款记录
    {
        MyHoldBackMoneyLogView * pBackView = [[MyHoldBackMoneyLogView alloc] init];


        pBackView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:pBackView animated:YES];
    }
    else//回款计划
    {
        MyHoldBackMoneyPlanView* pPlanView = [[MyHoldBackMoneyPlanView alloc] init];

        UITableViewCell* pCellObj = [UIOwnSkin getSuperTableViewCell:sender];
        NSIndexPath* indexPath = [_uiMainTableView indexPathForCell:pCellObj];
        if(indexPath == nil)
            return;
        int iDataRow = indexPath.row-1;
        if(iDataRow < 0 || iDataRow >= [m_pInfoDataSet getRowCount])
            return;
        //未结算收益
        
        pPlanView.m_uiTotalInComeLabel.text = @"";
        pPlanView.m_uiStartTimeLabel.text= @"";
        pPlanView.m_strProductId = [m_pInfoDataSet getFeildValue:iDataRow andColumn:@"productId"];
        pPlanView.m_strOrderRecId = [m_pInfoDataSet getFeildValue:iDataRow andColumn:@"relId"];
        
        pPlanView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:pPlanView animated:YES];
    }

    
}

//获取持有资产的详细信息
-(void)loadHoldAssetsInfo_Web
{
    CKHttpHelper*  pHttpHelper = [CKHttpHelper httpHelperWithOwner:self];
    pHttpHelper.m_iWebServerType = 1;
    pHttpHelper.methodType = CKHttpMethodTypePost_Page;
    //设置webservice方法名
    [pHttpHelper setMethodName:@"memberInfo/queryMyAsset"];
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
         
         //
         QDataSetObj* pDataSet = [pJsonObj parsetoDataSet:@"data"];
         if(pDataSet == nil)
             return;
         
         //代收本金
         NSString* strWaitInMoney = [pDataSet getFeildValue:0 andColumn:@"dsbj"];
         //待结算
         NSString* strWaitJsMoney = [pDataSet getFeildValue:0 andColumn:@"wjssy"];
         
         //总资产
         float fTotalMoney = [QDataSetObj convertToFloat:strWaitInMoney] + [QDataSetObj convertToFloat:strWaitJsMoney];
         
        m_strTotalMoney = [NSString stringWithFormat:@"%.2f",fTotalMoney];
         m_strWaitInMoney = [AppInitDataMethod convertMoneyShow:strWaitInMoney];
         m_strWaitJsMoney = [AppInitDataMethod convertMoneyShow:strWaitJsMoney];
         
         NSString* strProductCount = [pDataSet getFeildValue:0 andColumn:@"productList_count"];
         
         int iProCount = [QDataSetObj convertToInt:strProductCount];
         m_pInfoDataSet = [[QDataSetObj alloc] init];
         for(int i=0;i<iProCount;i++)
         {
             //订单id
             [m_pInfoDataSet addDataSetRow_Ext:i andName:@"relId" andValue:[pDataSet getFeildValue:0 andColumn:[NSString stringWithFormat:@"productList_relId_%d",i]]];
             //产品id
             [m_pInfoDataSet addDataSetRow_Ext:i andName:@"productId" andValue:[pDataSet getFeildValue:0 andColumn:[NSString stringWithFormat:@"productList_productId_%d",i]]];
             //产品name
             [m_pInfoDataSet addDataSetRow_Ext:i andName:@"productName" andValue:[pDataSet getFeildValue:0 andColumn:[NSString stringWithFormat:@"productList_productName_%d",i]]];

            //预期年化
             [m_pInfoDataSet addDataSetRow_Ext:i andName:@"expectAnnual" andValue:[pDataSet getFeildValue:0 andColumn:[NSString stringWithFormat:@"productList_expectAnnual_%d",i]]];
             
             //投资金额
             NSString* strMoney = [pDataSet getFeildValue:0 andColumn:[NSString stringWithFormat:@"productList_bidFee_%d",i]];

             [m_pInfoDataSet addDataSetRow_Ext:i andName:@"bidFee" andValue:strMoney];
             
             //代收本金
             strMoney = [pDataSet getFeildValue:0 andColumn:[NSString stringWithFormat:@"productList_readyBenj_%d",i]];

             [m_pInfoDataSet addDataSetRow_Ext:i andName:@"readyBenj" andValue:strMoney];
             //未结算收益
             strMoney = [pDataSet getFeildValue:0 andColumn:[NSString stringWithFormat:@"productList_notSettle_%d",i]];
             [m_pInfoDataSet addDataSetRow_Ext:i andName:@"notSettle" andValue:strMoney];
             
             //起息日
             [m_pInfoDataSet addDataSetRow_Ext:i andName:@"startDay" andValue:[pDataSet getFeildValue:0 andColumn:[NSString stringWithFormat:@"productList_startDay_%d",i]]];
             //最近还款日
             [m_pInfoDataSet addDataSetRow_Ext:i andName:@"lastDay" andValue:[pDataSet getFeildValue:0 andColumn:[NSString stringWithFormat:@"productList_lastDay_%d",i]]];
             [m_pInfoDataSet addDataSetRow_Ext:i andName:@"payStatus" andValue:[pDataSet getFeildValue:0 andColumn:[NSString stringWithFormat:@"productList_payStatus_%d",i]]];
             [m_pInfoDataSet addDataSetRow_Ext:i andName:@"tansStatus" andValue:[pDataSet getFeildValue:0 andColumn:[NSString stringWithFormat:@"productList_tansStatus_%d",i]]];
         }
         [_uiMainTableView reloadData];
     }];
    
    [pHttpHelper setStartBlock:^{
        [SVProgressHUD showWithStatus:HINT_WEBDATA_LOADING];
    }];
    
    
    [pHttpHelper start];

}

//查看合同
-(void)actionViewHetongClicked:(id)sender
{
  
    UITableViewCell* pCellObj = [UIOwnSkin getSuperTableViewCell:sender];
    NSIndexPath* indexPath = [_uiMainTableView indexPathForCell:pCellObj];
    if(indexPath == nil)
        return;
    int iDataRow = indexPath.row-1;
    if(iDataRow < 0 || iDataRow >= [m_pInfoDataSet getRowCount])
        return;
    
    NSString* strProductId = [m_pInfoDataSet getFeildValue:indexPath.row-1 andColumn:@"productId"];
    WebViewController* pWebView = [[WebViewController alloc] init];
    pWebView.hidesBottomBarWhenPushed = YES;
    pWebView.m_strViewTitle = @"查看合同";
    pWebView.m_strWebUrl = [NSString stringWithFormat:@"%@/productInfo/queryProContract.do?relId=%@",[UaConfiguration sharedInstance].m_strSoapRequestUrl_1,strProductId];
    [self.navigationController pushViewController:pWebView animated:YES];
}

#pragma mark -UITableView delegate and datasource

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
        return 180;
    return 220;
}

//Section
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(m_pInfoDataSet == nil)
        return 0;
    return 1;
}

//
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int iRowCount = 1 + [m_pInfoDataSet getRowCount];
    return iRowCount;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(UITableViewCell*)getHoldTopViewTableCell:(UITableView*)tableView andIndexPath:(NSIndexPath*)indexPath
{
    static NSString *strHoldTopViewTableCellId = @"HoldTopViewTableCellId";
    UITableViewCell *pCellObj = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:strHoldTopViewTableCellId];
    
    if (!pCellObj)
    {
        pCellObj = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strHoldTopViewTableCellId];
        pCellObj.contentView.backgroundColor = [UIColor whiteColor];
        pCellObj.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //背景
        UIView* pBkView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
        pBkView.backgroundColor = COLOR_VIEW_BK_02;
        [pCellObj.contentView addSubview:pBkView];
        
        //总资产的标题
        UILabel* pLable = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, 120, 30)];
        pLable.textAlignment = NSTextAlignmentLeft;
        pLable.backgroundColor = [UIColor clearColor];
        pLable.font = [UIFont systemFontOfSize:14];
        pLable.textColor = COLOR_FONT_1;
        pLable.text = @"总资产（元）";
        pLable.tag = 1001;
        [pBkView addSubview:pLable];
        
        //资产的值
        pLable = [[UILabel alloc] initWithFrame:CGRectMake(190, 8, 100, 30)];
        pLable.backgroundColor = [UIColor clearColor];
        pLable.font = [UIFont systemFontOfSize:18];
        pLable.textColor = COLOR_FONT_7;
       // pLable.text = @"168000.00";
        pLable.tag = 1002;
        pLable.textAlignment = NSTextAlignmentRight;
        [pBkView addSubview:pLable];
        
        //提示
        pLable = [[UILabel alloc] initWithFrame:CGRectMake(160, 30, 130, 30)];
        pLable.backgroundColor = [UIColor clearColor];
        pLable.font = [UIFont systemFontOfSize:12];
        pLable.textColor = COLOR_FONT_2;
        pLable.textAlignment = NSTextAlignmentRight;
        pLable.text = @"待收本金+未结算收益";
        pLable.tag = 1003;
        [pBkView addSubview:pLable];
        
        
        //待收本金的标题
        pLable = [[UILabel alloc] initWithFrame:CGRectMake(20, 75, 200, 20)];
        pLable.textAlignment = NSTextAlignmentLeft;
        pLable.backgroundColor = [UIColor clearColor];
        pLable.font = [UIFont systemFontOfSize:14];
        pLable.textColor = COLOR_FONT_1;
        pLable.text = @"待收本金（元）";
        pLable.tag = 1004;
        [pCellObj.contentView addSubview:pLable];
        
        //代收本金的值
        pLable = [[UILabel alloc] initWithFrame:CGRectMake(230, 75, 80, 20)];
        pLable.textAlignment = NSTextAlignmentRight;
        pLable.backgroundColor = [UIColor clearColor];
        pLable.font = [UIFont systemFontOfSize:14];
        pLable.textColor = COLOR_FONT_2;
        pLable.tag = 1005;
       // pLable.text = @"168000.00";
        [pCellObj.contentView addSubview:pLable];
 
        UIImageView* pLineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 100, self.view.frame.size.width-20, 1)];
        pLineImageView.backgroundColor = COLOR_CELL_LINE_DEFAULT;
        [pCellObj.contentView addSubview:pLineImageView];
        
        //未结算本金的标题
        pLable = [[UILabel alloc] initWithFrame:CGRectMake(20, 105,200, 20)];
        pLable.textAlignment = NSTextAlignmentLeft;
        pLable.backgroundColor = [UIColor clearColor];
        pLable.font = [UIFont systemFontOfSize:14];
        pLable.textColor = COLOR_FONT_1;
        pLable.text = @"未结算收益（元）";
        pLable.tag = 1006;
        [pCellObj.contentView addSubview:pLable];
        
        //未结算本金的值
        pLable = [[UILabel alloc] initWithFrame:CGRectMake(230, 105, 80, 20)];
        pLable.textAlignment = NSTextAlignmentRight;
        pLable.backgroundColor = [UIColor clearColor];
        pLable.font = [UIFont systemFontOfSize:14];
        pLable.textColor = COLOR_FONT_2;
        //pLable.text = @"100.00";
        pLable.tag  =1007;
        [pCellObj.contentView addSubview:pLable];
        
        //
        pLineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 130, self.view.frame.size.width-20, 1)];
        pLineImageView.backgroundColor = COLOR_CELL_LINE_DEFAULT;
        [pCellObj.contentView addSubview:pLineImageView];
        
        //已回款的标题
        pLable = [[UILabel alloc] initWithFrame:CGRectMake(20, 135,200, 20)];
        pLable.textAlignment = NSTextAlignmentLeft;
        pLable.backgroundColor = [UIColor clearColor];
        pLable.font = [UIFont systemFontOfSize:14];
        pLable.textColor = COLOR_FONT_1;
        pLable.text = @"已还款";
        pLable.tag = 1008;
        [pCellObj.contentView addSubview:pLable];
        
        
        UIButton* pButton = [UIButton buttonWithType:UIButtonTypeCustom];
        pButton.tag = 2003;
        pButton.frame = CGRectMake(220, 130, 90, 30);
        [pButton addTarget:self action:@selector(actionBackMoneyLogClicked:) forControlEvents:UIControlEventTouchUpInside];
        [pCellObj.contentView addSubview:pButton];
        //
        pLable = [[UILabel alloc] initWithFrame:CGRectMake(230, 135, 80, 20)];
        pLable.textAlignment = NSTextAlignmentRight;
        pLable.backgroundColor = [UIColor clearColor];
        pLable.font = [UIFont systemFontOfSize:14];
        pLable.textColor = COLOR_FONT_2;
        pLable.text = @"查看记录";
        pLable.tag  = 1009;
        [pCellObj.contentView addSubview:pLable];
        
                
        pLineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 160, self.view.frame.size.width-20, 1)];
        pLineImageView.backgroundColor = COLOR_CELL_LINE_DEFAULT;
        [pCellObj.contentView  addSubview:pLineImageView];
        
    }
    UILabel* pLabel = (UILabel*)[pCellObj.contentView viewWithTag:1002];
    if(pLabel)
    {
        pLabel.text = m_strTotalMoney;//总资产
    }
    
    pLabel = (UILabel*)[pCellObj.contentView viewWithTag:1005];
    if(pLabel)
    {
        pLabel.text = m_strWaitInMoney;//代收本金
    }
    
    pLabel = (UILabel*)[pCellObj.contentView viewWithTag:1007];
    if(pLabel)
    {
        pLabel.text = m_strWaitJsMoney;//未结算
    }
    return pCellObj;

}


-(UITableViewCell*)getHoldMidViewTableCell:(UITableView*)tableView andIndexPath:(NSIndexPath*)indexPath
{
    static NSString *strHoldMidViewTableCellId = @"HoldMidViewTableCellId";
    UITableViewCell *pCellObj = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:strHoldMidViewTableCellId];
    
    if (!pCellObj)
    {
        pCellObj = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strHoldMidViewTableCellId];
        pCellObj.contentView.backgroundColor = [UIColor whiteColor];
        pCellObj.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //背景
        UIView* pBkCellView = [[UIView alloc] initWithFrame:CGRectMake(10,0, self.view.frame.size.width-20, 210)];
        pBkCellView.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1];
        pBkCellView.layer.borderWidth = 1.0f;
        pBkCellView.layer.borderColor = COLOR_BTN_BORDER_1.CGColor;
        pBkCellView.layer.cornerRadius = 5.0f;
        [pCellObj.contentView addSubview:pBkCellView];
        
        //顶部背景
        UIView* pBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-20, 50)];
        pBarView.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.93 alpha:1];
        pBarView.layer.borderColor = COLOR_BTN_BORDER_1.CGColor;
        pBarView.layer.borderWidth = 1.0f;
        pBarView.layer.cornerRadius = 5.0f;
        [pBkCellView addSubview:pBarView];

        //去掉画的角、线
        pBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 45, self.view.frame.size.width-20, 5)];
        pBarView.backgroundColor = COLOR_VIEW_BK_02;
        [pBkCellView addSubview:pBarView];
        //画条线
        UIImageView* pLineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 4, self.view.frame.size.width-20, 1)];
        pLineView.backgroundColor = COLOR_CELL_LINE_DEFAULT;
        [pBarView addSubview:pLineView];

        
        //产品名称和编号
        UILabel* pLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 150, 20)];
        pLable.textAlignment = NSTextAlignmentLeft;
        pLable.backgroundColor = [UIColor clearColor];
        pLable.font = [UIFont systemFontOfSize:14];
        pLable.textColor = COLOR_FONT_1;
        //pLable.text = @"车金融编号001";
        pLable.tag = 1001;
        [pBkCellView addSubview:pLable];
        
        //起息日
        pLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, 145, 16)];
        pLable.backgroundColor = [UIColor clearColor];
        pLable.font = [UIFont systemFontOfSize:12];
        pLable.textColor = COLOR_FONT_2;
        //pLable.text = @"起息日2014-11-18";
        pLable.text = @"";
        pLable.tag  = 1002;
        pLable.textAlignment = NSTextAlignmentLeft;
        [pBkCellView addSubview:pLable];
        
        //预期年化
        pLable = [[UILabel alloc] initWithFrame:CGRectMake(160, 15, 130, 20)];
        pLable.backgroundColor = [UIColor clearColor];
        pLable.font = [UIFont systemFontOfSize:12];
        pLable.textColor = COLOR_FONT_1;
        pLable.textAlignment = NSTextAlignmentRight;
       // pLable.text = @"预期年化 8.00%";
        pLable.tag = 1003;
      //  pLable.attributedText = [AppInitDataMethod getLabelAttributedString:@"预期年化 8.00%" andLight:@"8.00%"];
        [pBkCellView addSubview:pLable];
        
        
        //投资金额的标题
        pLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 55, 200, 20)];
        pLable.textAlignment = NSTextAlignmentLeft;
        pLable.backgroundColor = [UIColor clearColor];
        pLable.font = [UIFont systemFontOfSize:12];
        pLable.textColor = COLOR_FONT_1;
        pLable.text = @"投资金额：";
        pLable.tag = 1004;
        [pBkCellView addSubview:pLable];
        
        //投资金额的值
        pLable = [[UILabel alloc] initWithFrame:CGRectMake(210, 55, 80, 20)];
        pLable.textAlignment = NSTextAlignmentRight;
        pLable.backgroundColor = [UIColor clearColor];
        pLable.font = [UIFont systemFontOfSize:12];
        pLable.textColor = COLOR_FONT_2;
        //pLable.text = @"168000.00";
        pLable.tag  = 1005;
        [pBkCellView addSubview:pLable];
        

        //未结算收益标题
        pLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 80,200, 20)];
        pLable.textAlignment = NSTextAlignmentLeft;
        pLable.backgroundColor = [UIColor clearColor];
        pLable.font = [UIFont systemFontOfSize:12];
        pLable.textColor = COLOR_FONT_1;
        pLable.text = @"未结算收益：";
        pLable.tag = 1006;
        [pBkCellView addSubview:pLable];
        
        //未结算收益的值
        pLable = [[UILabel alloc] initWithFrame:CGRectMake(210, 80, 80, 20)];
        pLable.textAlignment = NSTextAlignmentRight;
        pLable.backgroundColor = [UIColor clearColor];
        pLable.font = [UIFont systemFontOfSize:12];
        pLable.textColor = COLOR_FONT_2;
        //pLable.text = @"100.00";
        pLable.tag  = 1007;
        [pBkCellView addSubview:pLable];

        
        //待收本金标题
        pLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 105,200, 20)];
        pLable.textAlignment = NSTextAlignmentLeft;
        pLable.backgroundColor = [UIColor clearColor];
        pLable.font = [UIFont systemFontOfSize:12];
        pLable.textColor = COLOR_FONT_1;
        pLable.text = @"待收本金：";
        pLable.tag  = 1008;
        [pBkCellView addSubview:pLable];
        
        //待收本金的值
        pLable = [[UILabel alloc] initWithFrame:CGRectMake(210, 105, 80, 20)];
        pLable.textAlignment = NSTextAlignmentRight;
        pLable.backgroundColor = [UIColor clearColor];
        pLable.font = [UIFont systemFontOfSize:12];
        pLable.textColor = COLOR_FONT_2;
        //pLable.text = @"50.00";
        pLable.tag = 1009;
        [pBkCellView addSubview:pLable];
        
        //最近还款日标题
        pLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 130,200, 20)];
        pLable.textAlignment = NSTextAlignmentLeft;
        pLable.backgroundColor = [UIColor clearColor];
        pLable.font = [UIFont systemFontOfSize:12];
        pLable.textColor = COLOR_FONT_1;
        pLable.text = @"最近还款日：";
        pLable.tag = 1010;
        [pBkCellView addSubview:pLable];
        
        //最近还款日的值
        pLable = [[UILabel alloc] initWithFrame:CGRectMake(210, 130, 80, 20)];
        pLable.textAlignment = NSTextAlignmentRight;
        pLable.backgroundColor = [UIColor clearColor];
        pLable.font = [UIFont systemFontOfSize:12];
        pLable.textColor = COLOR_FONT_2;
        //pLable.text = @"2014-11-19";
        pLable.tag = 1011;
        [pBkCellView addSubview:pLable];

        
        pLineView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 160, self.view.frame.size.width-40, 1)];
        pLineView.backgroundColor = COLOR_CELL_LINE_DEFAULT;
        [pBkCellView addSubview:pLineView];
        
        
        //状态提示
        pLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 180, 90, 20)];
        pLable.textAlignment = NSTextAlignmentLeft;
        pLable.backgroundColor = [UIColor clearColor];
        pLable.font = [UIFont systemFontOfSize:12];
        pLable.textColor = COLOR_FONT_7;
        //pLable.text = @"还款中...";
        pLable.tag = 1012;
        [pBkCellView addSubview:pLable];
        
        CGFloat pButtonWidth = 160/3.0f;
        
        UIButton* pButton = [UIButton buttonWithType:UIButtonTypeCustom];
        pButton.frame = CGRectMake(120, 168, pButtonWidth, 35);
        pButton.layer.borderWidth = 1.0f;
        pButton.layer.borderColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1].CGColor;
        pButton.layer.cornerRadius = 5.0f;
        pButton.backgroundColor = [UIColor whiteColor];
        [pButton setTitleColor:COLOR_FONT_1 forState:UIControlStateNormal];
        pButton.titleLabel.font = [UIFont systemFontOfSize:14];
        pButton.tag = 2001;
        [pButton setTitle:@"合同" forState:UIControlStateNormal];
        [pButton addTarget:self action:@selector(actionViewHetongClicked:) forControlEvents:UIControlEventTouchUpInside];
        [pBkCellView addSubview:pButton];
        
        pButton = [UIButton buttonWithType:UIButtonTypeCustom];
        pButton.frame = CGRectMake(120 + pButtonWidth + 5, 168, pButtonWidth, 35);
        
        //[UIOwnSkin setButtonBackground:pButton];
        pButton.layer.borderWidth = 1.0f;
        pButton.layer.borderColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1].CGColor;
        pButton.layer.cornerRadius = 5.0f;
        pButton.backgroundColor = [UIColor whiteColor];
        [pButton setTitleColor:COLOR_FONT_1 forState:UIControlStateNormal];
        pButton.titleLabel.font = [UIFont systemFontOfSize:14];
        pButton.tag = 2002;
        [pButton setTitle:@"回款" forState:UIControlStateNormal];
        [pButton addTarget:self action:@selector(actionBackMoneyLogClicked:) forControlEvents:UIControlEventTouchUpInside];
        [pBkCellView addSubview:pButton];
        
        pButton = [UIButton buttonWithType:UIButtonTypeCustom];
        pButton.frame = CGRectMake(120 + (pButtonWidth + 5)*2, 168, pButtonWidth, 35);
        
        //[UIOwnSkin setButtonBackground:pButton];
        pButton.layer.borderWidth = 1.0f;
        pButton.layer.borderColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1].CGColor;
        pButton.layer.cornerRadius = 5.0f;
        pButton.backgroundColor = [UIColor whiteColor];
        [pButton setTitleColor:COLOR_FONT_1 forState:UIControlStateNormal];
        pButton.titleLabel.font = [UIFont systemFontOfSize:14];
        pButton.tag = 2003;
        [pButton setTitle:@"转让" forState:UIControlStateNormal];
        [pButton addTarget:self action:@selector(actionToCheckTransMoneyClicked:) forControlEvents:UIControlEventTouchUpInside];
        [pBkCellView addSubview:pButton];

        
    }
    int iDataRow = indexPath.row-1;
    
    UILabel* pLabel = (UILabel*)[pCellObj.contentView viewWithTag:1001];
    if(pLabel)
    {
        pLabel.text = [m_pInfoDataSet getFeildValue:iDataRow andColumn:@"productName"];//产品名称
    }
    
    pLabel = (UILabel*)[pCellObj.contentView viewWithTag:1002];
    if(pLabel)
    {
        pLabel.text =[NSString stringWithFormat: @"起息日：%@", [m_pInfoDataSet getFeildValue:iDataRow andColumn:@"startDay"]];//起息日
    }
    
    pLabel = (UILabel*)[pCellObj.contentView viewWithTag:1003];
    if(pLabel)
    {
        NSString* strExpValue = [m_pInfoDataSet getFeildValue:iDataRow andColumn:@"expectAnnual"];
        strExpValue = [AppInitDataMethod convertPcertShow:strExpValue];
        pLabel.attributedText = [AppInitDataMethod getLabelAttributedString:[NSString stringWithFormat:@"预期年化 %@",strExpValue] andLight:strExpValue];
    }
    
    pLabel = (UILabel*)[pCellObj.contentView viewWithTag:1005];
    if(pLabel)
    {
        //pLabel.text = [NSString stringWithFormat:@"%@元",[m_pInfoDataSet getFeildValue:iDataRow andColumn:@"bidFee"]];//投资金额
        pLabel.text = [NSString stringWithFormat:@"%@元",[AppInitDataMethod convertMoneyShow:[m_pInfoDataSet getFeildValue:iDataRow andColumn:@"bidFee"]]];//投资金额
    }
    pLabel = (UILabel*)[pCellObj.contentView viewWithTag:1007];
    if(pLabel)
    {
        
        pLabel.text = [NSString stringWithFormat:@"%@元",[AppInitDataMethod convertMoneyShow:[m_pInfoDataSet getFeildValue:iDataRow andColumn:@"notSettle"]]];//未结算收益
    }
 
    pLabel = (UILabel*)[pCellObj.contentView viewWithTag:1009];
    if(pLabel)
    {
        pLabel.text = [NSString stringWithFormat:@"%@元",[AppInitDataMethod convertMoneyShow:[m_pInfoDataSet getFeildValue:iDataRow andColumn:@"readyBenj"]]];//代收本金
    }
    
    pLabel = (UILabel*)[pCellObj.contentView viewWithTag:1011];
    if(pLabel)
    {
        pLabel.text = [m_pInfoDataSet getFeildValue:iDataRow andColumn:@"lastDay"];//最后还款日
    }
    
    //状态
    pLabel = (UILabel*)[pCellObj.contentView viewWithTag:1012];
    //合同
    UIButton *pHbutton = (UIButton*)[pCellObj.contentView viewWithTag:2001];
    //回款
    UIButton *pHKbutton = (UIButton*)[pCellObj.contentView viewWithTag:2002];
    //转让
    UIButton *pZbutton = (UIButton*)[pCellObj.contentView viewWithTag:2003];
    
    CGFloat pButtonWidth = 160/3.0f;
    
    if(pLabel)
    {
        NSString* strPayStatus = [m_pInfoDataSet getFeildValue:iDataRow andColumn:@"payStatus"];
        
        int iPayStatus = [QDataSetObj convertToInt:strPayStatus];
        
        NSString* strTransStatus = [m_pInfoDataSet getFeildValue:iDataRow andColumn:@"tansStatus"];
        
        int iTransStatus = [QDataSetObj convertToInt:strTransStatus];
        // 2:投标中 3还款中 4还款结束
        if(iPayStatus == 2)
        {
            strPayStatus = @"投标中";
            pLabel.textColor = COLOR_FONT_7;
            //绿色转让
            //绿色转让
            if(iTransStatus == 2) {
                //取消转让
                pZbutton.hidden = NO;
                [pZbutton setTitle:@"取消转让" forState:UIControlStateNormal];
                [pZbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                pZbutton.backgroundColor = COLOR_FONT_7;
                pHbutton.frame = CGRectMake(120-20, 168, pButtonWidth, 35);
                pHKbutton.frame = CGRectMake(120-20 + pButtonWidth + 5, 168, pButtonWidth, 35);
                pZbutton.frame = CGRectMake(120-20 + (pButtonWidth + 5)*2, 168, pButtonWidth+20, 35);
            }else {
                //转让
                pZbutton.hidden = NO;
                [pZbutton setTitle:@"转让" forState:UIControlStateNormal];
                [pZbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                pZbutton.backgroundColor = [UIColor colorWithRed:119/255.0 green:187/255.0 blue:183/255.0 alpha:1];
                pHbutton.frame = CGRectMake(120, 168, pButtonWidth, 35);
                pHKbutton.frame = CGRectMake(120 + pButtonWidth + 5, 168, pButtonWidth, 35);
                pZbutton.frame = CGRectMake(120 + (pButtonWidth + 5)*2, 168, pButtonWidth, 35);
            }            
        }
        else if(iPayStatus == 3)
        {
            strPayStatus = @"还款中";
            pLabel.textColor = COLOR_FONT_7;
            //绿色转让
            if(iTransStatus == 2) {
                //取消转让
                pZbutton.hidden = NO;
                [pZbutton setTitle:@"取消转让" forState:UIControlStateNormal];
                [pZbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                pZbutton.backgroundColor = COLOR_FONT_7;
                pHbutton.frame = CGRectMake(120-20, 168, pButtonWidth, 35);
                pHKbutton.frame = CGRectMake(120-20 + pButtonWidth + 5, 168, pButtonWidth, 35);
                pZbutton.frame = CGRectMake(120-20 + (pButtonWidth + 5)*2, 168, pButtonWidth+20, 35);
            }else {
                //转让
                pZbutton.hidden = NO;
                [pZbutton setTitle:@"转让" forState:UIControlStateNormal];
                [pZbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                pZbutton.backgroundColor = [UIColor colorWithRed:119/255.0 green:187/255.0 blue:183/255.0 alpha:1];
                pHbutton.frame = CGRectMake(120, 168, pButtonWidth, 35);
                pHKbutton.frame = CGRectMake(120 + pButtonWidth + 5, 168, pButtonWidth, 35);
                pZbutton.frame = CGRectMake(120 + (pButtonWidth + 5)*2, 168, pButtonWidth, 35);
            }
            
        }
        else if(iPayStatus == 4)
        {
            strPayStatus = @"还款结束";
            pLabel.textColor = COLOR_FONT_7;
            //没有转让按钮
            pZbutton.hidden = YES;
            pHbutton.frame = CGRectMake(120 + pButtonWidth + 5, 168, pButtonWidth, 35);
            pHKbutton.frame = CGRectMake(120 + (pButtonWidth + 5)*2, 168, pButtonWidth, 35);
        }else
        {
            strPayStatus = @"";
            pLabel.textColor = COLOR_FONT_7;
            //没有转让按钮
            pZbutton.hidden = YES;
            pHbutton.frame = CGRectMake(120 + pButtonWidth + 5, 168, pButtonWidth, 35);
            pHKbutton.frame = CGRectMake(120 + (pButtonWidth + 5)*2, 168, pButtonWidth, 35);
        }

//        else if(iPayStatus == 5)
//        {
//            strPayStatus = @"转让中";
//            pLabel.textColor = [UIColor colorWithRed:0.42 green:0.73 blue:0.69 alpha:1];
//            //橙色取消转让
//            pZbutton.hidden = NO;
//            [pZbutton setTitle:@"取消转让" forState:UIControlStateNormal];
//            [pZbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            pZbutton.backgroundColor = COLOR_FONT_7;
//            pHbutton.frame = CGRectMake(120-20, 168, pButtonWidth, 35);
//            pHKbutton.frame = CGRectMake(120-20 + pButtonWidth + 5, 168, pButtonWidth, 35);
//            pZbutton.frame = CGRectMake(120-20 + (pButtonWidth + 5)*2, 168, pButtonWidth+20, 35);
//        }
//        else if(iPayStatus == 6)
//        {
//            strPayStatus = @"已转让";
//            pLabel.textColor = [UIColor colorWithRed:0.42 green:0.73 blue:0.69 alpha:1];
//            //没有转让按钮
//            pZbutton.hidden = YES;
//            pHbutton.frame = CGRectMake(120 + pButtonWidth + 5, 168, pButtonWidth, 35);
//            pHKbutton.frame = CGRectMake(120 + (pButtonWidth + 5)*2, 168, pButtonWidth, 35);
//        }
        pLabel.text = strPayStatus;
    }
    
    return pCellObj;
    
}


//加载cell
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* pCellObj = nil;
    if(indexPath.row == 0)
    {
        pCellObj = [self getHoldTopViewTableCell:tableView andIndexPath:indexPath];
    }
    else
    {
      pCellObj = [self getHoldMidViewTableCell:tableView andIndexPath:indexPath];
    }
    return pCellObj;
    
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    /*
     NSInteger iMaxRow = [self getIntrolGoodsSectionRowCount];
     if(m_strAdImageUrl.length < 10)
     {
     iMaxRow--;
     }
     
     if(indexPath.row == iMaxRow)
     {
     if(m_isToEndPage)
     {
     if(m_iCurPageId == 1)
     return;
     [SVProgressHUD showSuccessWithStatus:HINT_LASTEST_PAGE duration:1.8];
     return;
     }
     
     
     [self downLoadInfoList_Web];
     
     }
     */
}



@end
