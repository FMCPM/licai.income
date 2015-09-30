//
//  MyHoldBackMoneyLogView.m
//  我的叮叮-持有资产--还款记录
//
//  Created by lzq on 2014-11-19
//
//

#import "MyHoldBackMoneyLogView.h"
#import "CKKit.h"
#import "UIOwnSkin.h"
#import "GlobalDefine.h"
#import "AppInitDataMethod.h"
#import "UaConfiguration.h"
#import "JsonXmlParserObj.h"
#import "WebViewController.h"
#import "MyHoldBackMoneyPlanView.h"

@interface MyHoldBackMoneyLogView ()

@end

@implementation MyHoldBackMoneyLogView

@synthesize m_uiMainTableView = _uiMainTableView;
@synthesize m_strProductId = _strProductId;
@synthesize m_strOrderRecId = _strOrderRecId;

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

    self.navigationItem.titleView = [UIOwnSkin navibarTitleView:@"还款记录" andFrame:CGRectMake(0, 0, 100, 40)];
    
    _uiMainTableView = nil;
    m_pInfoDataSet = nil;
    //左边返回按钮
    self.navigationItem.leftBarButtonItem = [UIOwnSkin backItemTarget:self action:@selector(backNavButtonAction:)];
    //
    [super viewDidLoad];
}



-(void)viewWillAppear:(BOOL)animated
{
    [self initTableView];
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
    CGRect rcTable = self.view.frame;
    rcTable.origin.y = 0;
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

    [_uiMainTableView reloadData];
    
    [self loadBackMoneyLogList_Web];
}


//获取还款记录
-(void)loadBackMoneyLogList_Web
{
    CKHttpHelper*  pHttpHelper = [CKHttpHelper httpHelperWithOwner:self];
    pHttpHelper.m_iWebServerType = 1;
    pHttpHelper.methodType = CKHttpMethodTypePost_Page;
    //设置webservice方法名
    [pHttpHelper setMethodName:@"memberInfo/queryRepaymemberList"];
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
         m_pInfoDataSet = [pJsonObj parsetoDataSet:@"productList"];
         
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

//查看回款计划
-(void)actionBackMoneyPlanClicked:(id)sender
{
    
    MyHoldBackMoneyPlanView* pPlanView = [[MyHoldBackMoneyPlanView alloc] init];
    
    UITableViewCell* pCellObj = [UIOwnSkin getSuperTableViewCell:sender];
    NSIndexPath* indexPath = [_uiMainTableView indexPathForCell:pCellObj];
    if(indexPath == nil)
        return;
    int iDataRow = indexPath.row;
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


#pragma mark -UITableView delegate and datasource

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int iMaxRow = [m_pInfoDataSet getRowCount] - 1;
    if(indexPath.row == iMaxRow)
        return 230;
    return 220;
}

//Section
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//4行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(m_pInfoDataSet == nil)
        return 0;
    return [m_pInfoDataSet getRowCount];

    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}




//加载cell
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strBackMoneyLogTableCellId = @"BackMoneyLogTableCellId";
    UITableViewCell *pCellObj = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:strBackMoneyLogTableCellId];
    
    if (!pCellObj)
    {
        pCellObj = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strBackMoneyLogTableCellId];
        pCellObj.contentView.backgroundColor = [UIColor whiteColor];
        pCellObj.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //背景
        UIView* pBkCellView = [[UIView alloc] initWithFrame:CGRectMake(10,10, self.view.frame.size.width-20, 210)];
        pBkCellView.backgroundColor = COLOR_VIEW_BK_01;
        pBkCellView.layer.borderWidth = 1.0f;
        pBkCellView.layer.borderColor = COLOR_BTN_BORDER_1.CGColor;
        pBkCellView.layer.cornerRadius = 5.0f;
        [pCellObj.contentView addSubview:pBkCellView];
        
        //顶部背景
        UIView* pBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-20, 50)];
        pBarView.backgroundColor = COLOR_VIEW_BK_02;
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
        pLable.text = @"已收收益：";
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
        pLable.text = @"已收本金：";
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
        pLable.textColor = COLOR_FONT_3;
        //pLable.text = @"还款中...";
        pLable.tag = 1012;
        [pBkCellView addSubview:pLable];
        
        UIButton* pButton = [UIButton buttonWithType:UIButtonTypeCustom];
        pButton.frame = CGRectMake(120, 168, 80, 35);
        pButton.layer.borderWidth = 1.0f;
        pButton.layer.borderColor = COLOR_FONT_2.CGColor;
        pButton.layer.cornerRadius = 5.0f;
        pButton.backgroundColor = [UIColor whiteColor];
        [pButton setTitleColor:COLOR_FONT_1 forState:UIControlStateNormal];
        pButton.titleLabel.font = [UIFont systemFontOfSize:14];
        pButton.tag = 2001;
        [pButton setTitle:@"查看合同" forState:UIControlStateNormal];
        [pButton addTarget:self action:@selector(actionViewHetongClicked:) forControlEvents:UIControlEventTouchUpInside];
        [pBkCellView addSubview:pButton];
        
        pButton = [UIButton buttonWithType:UIButtonTypeCustom];
        pButton.frame = CGRectMake(210, 168, 80, 35);
        
        [UIOwnSkin setButtonBackground:pButton];
        pButton.titleLabel.font = [UIFont systemFontOfSize:14];
        pButton.tag = 2002;
        [pButton setTitle:@"回款计划" forState:UIControlStateNormal];
        [pButton addTarget:self action:@selector(actionBackMoneyPlanClicked:) forControlEvents:UIControlEventTouchUpInside];
        [pBkCellView addSubview:pButton];
        
    }
    int iDataRow = indexPath.row;
    
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
        pLabel.text = [NSString stringWithFormat:@"%@元",[m_pInfoDataSet getFeildValue:iDataRow andColumn:@"bidFee"]];//投资金额
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
    if(pLabel)
    {
        NSString* strPayStatus = [m_pInfoDataSet getFeildValue:iDataRow andColumn:@"payStatus"];
        
        int iPayStatus = [QDataSetObj convertToInt:strPayStatus];
        // 2:投标中 3还款中 4还款结束
        if(iPayStatus == 2)
        {
            strPayStatus = @"投标中";
        }
        else if(iPayStatus == 3)
        {
            strPayStatus = @"还款中";
        }
        else if(iPayStatus == 4)
        {
            strPayStatus = @"还款结束";
        }
        else
        {
            strPayStatus = @"";
        }
        
        pLabel.text = strPayStatus;
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
