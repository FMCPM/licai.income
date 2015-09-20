//
//  ProductListViewController.m
//
//  叮叮理财 - 产品列表
//
//  Created by lzq on 2014-12-27.
//

#import "ProductListViewController.h"
#import "UaConfiguration.h"
#import "UIOwnSkin.h"
#import "Car_LoanDetailInfoPageView.h"
#import "CarLoanInfoTableCell.h"
#import "UserRegisterViewController.h"
#import "JsonXmlParserObj.h"
#import "AppInitDataMethod.h"
#import "DDTransMakeTurePageView.h"

@interface ProductListViewController ()

@end

@implementation ProductListViewController

@synthesize m_uiMainTableView = _uiMainTableView;
@synthesize m_uiTopBarView = _uiTopBarView;

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
 //   self.navigationItem.titleView = [UIOwnSkin navibarTitleView:@"产品列表" andFrame:CGRectMake(0, 0, 100, 40)];

    
    //左边的刷新按钮
    UIButton* pLeftNavButton = [UIButton buttonWithType:UIButtonTypeCustom];
    pLeftNavButton.frame = CGRectMake(0, 0, 80, 30);
    [pLeftNavButton addTarget:self action:@selector(onLeftRefreshClicked:) forControlEvents:UIControlEventTouchUpInside];
    //刷新的图标
    UIImageView* pImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, 20, 20)];
    pImageView.image = [UIImage imageNamed:@"icon_refresh.png"];
    [pLeftNavButton addSubview:pImageView];
    //刷新的提示
    UILabel* pLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 5, 50, 20)];
    pLabel.backgroundColor = [UIColor clearColor];
    pLabel.textColor = COLOR_FONT_7;
    pLabel.font = [UIFont systemFontOfSize:14];
    pLabel.text = @"刷新";
    [pLeftNavButton addSubview:pLabel];
    UIBarButtonItem* pLeftBtnItem = [[UIBarButtonItem alloc] initWithCustomView:pLeftNavButton];
    self.navigationItem.leftBarButtonItem = pLeftBtnItem;

    [super viewDidLoad];
    
}

//刷新
-(void)onLeftRefreshClicked:(id)sender
{
    [self loadProductListInfo_Web:1];
}

//左边登录按钮
-(void)onLeftLoginClicked:(id)sender
{
    if([[UaConfiguration sharedInstance] userIsHaveLoadinSystem] == YES)
        return;
    //[UaConfiguration sharedInstance].m_setLoginState.m_strUserLoginName = @"13858005686";
    if([UaConfiguration sharedInstance].m_setLoginState.m_strUserLoginName.length > 1)
    {
        //弹出登录页面
        LoginViewController*pLoginView = [[LoginViewController alloc] init];
        pLoginView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:pLoginView animated:YES];
        
    }
    else
    {
        //先注册
        UserRegisterViewController*pRegistView = [[UserRegisterViewController alloc] init];
        pRegistView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:pRegistView animated:YES];
    }

}



- (void)viewWillAppear:(BOOL)animated
{
    //右边的登录按钮
    if([[UaConfiguration sharedInstance] userIsHaveLoadinSystem] == NO)
    {
        self.navigationItem.rightBarButtonItem = [UIOwnSkin navTextItemTarget:self action:@selector(onLeftLoginClicked:) text:@"登录" andWidth:40];
    }
    else
    {
        self.navigationItem.rightBarButtonItem = nil;
    }
    [self initProductListView];
}


-(void)viewDidAppear:(BOOL)animated
{

}


//初始化视图
-(void)initProductListView
{
    /*
    if(_uiTopBarView != nil)
        return;
    _uiTopBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    _uiTopBarView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_uiTopBarView];
 
    NSArray* arItems = [[NSArray alloc] initWithObjects:@"车贷",@"信用贷",@"企业贷", nil];
    
    OwnSegmentedControl* pSegControl = [[OwnSegmentedControl alloc] initWithFrame:CGRectMake(35, 7,250,25) items:arItems];
    pSegControl.m_segDelegate = self;
    [_uiTopBarView addSubview:pSegControl];
   
    
    UIImageView* pLineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 39, self.view.frame.size.width, 1)];
    pLineView.backgroundColor = COLOR_CELL_LINE_DEFAULT;
    [_uiTopBarView addSubview:pLineView];
    
    if(_uiMainTableView != nil)
        return;
 */

    
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
    
    //
    m_refreshHeaderView = [[EGORefreshTableHeaderView alloc]
                           initWithFrame:CGRectMake(0.0f,
                                                    0.0f-_uiMainTableView.bounds.size.height,
                                                    _uiMainTableView.bounds.size.width,
                                                    _uiMainTableView.bounds.size.height)];
    
    m_refreshHeaderView.delegate = self;
    m_refreshHeaderView.textColor = [UIColor blackColor];
    m_refreshHeaderView.backgroundColor = [UIColor clearColor];
    [_uiMainTableView addSubview:m_refreshHeaderView];
    
    [m_refreshHeaderView refreshLastUpdatedDate];
    //第一个按钮选中
    m_iInfoType = 1;
    m_iCurPageID = 0;

    m_isLoading = NO;
    
    [self intiNavTitleView];
  //  [self loadProductListInfo_Web:0];
}



-(void)intiNavTitleView
{
    m_uiNavTitleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    m_uiNavTitleButton.frame = CGRectMake(0, 0, 80, 40);
    
    UILabel* pLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 80, 20)];
    pLabel.backgroundColor = [UIColor clearColor];
    pLabel.font = [UIFont boldSystemFontOfSize:14];
    pLabel.text = @"";
    pLabel.textColor = COLOR_FONT_1;
    pLabel.tag = 1001;
    pLabel.textAlignment = UITextAlignmentCenter;
    [m_uiNavTitleButton addSubview:pLabel];
    
    [m_uiNavTitleButton addTarget:self action:@selector(actionProductTypeClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView* pDownImgView = [[UIImageView alloc] initWithFrame:CGRectMake(90,18, 10, 6)];
    pDownImgView.image = [UIImage imageNamed:@"icon_select_i.png"];
    pDownImgView.tag = 2001;
    [m_uiNavTitleButton addSubview:pDownImgView];
    self.navigationItem.titleView = m_uiNavTitleButton;
    
    [self setProductTypeShow:1];
    
    [self loadProductListInfo_Web:1];
}

//
-(void)setProductTypeShow:(NSInteger)iProdcutType
{
    m_iInfoType = iProdcutType;
    
    NSString* strTitle = @"";
    if(m_iInfoType == 1)
        strTitle = @"车贷";
    else if(m_iInfoType == 2)
        strTitle = @"信用贷";
    else if(m_iInfoType == 3)
        strTitle = @"企业贷";
    else if(m_iInfoType == 1000) {
        strTitle = @"债券转让";
    }
    
    UILabel* pLabel = (UILabel*)[m_uiNavTitleButton viewWithTag:1001];
    if(pLabel != nil)
    {
        pLabel.text = strTitle;
    }
    
    UIImageView* pDownImgView = (UIImageView*)[m_uiNavTitleButton viewWithTag:2001];
    if(pDownImgView)
    {
        CGRect rcImgView = pDownImgView.frame;
        
        rcImgView.origin.x = 43+(strTitle.length*14)/2;
        
        pDownImgView.frame = rcImgView;
    }
    
}


-(void)actionProductTypeClicked:(id)sender
{
    if(m_pMiddleShowView != nil)
    {
        [m_pMiddleShowView removeFromSuperview];
        m_pMiddleShowView = nil;
        return;
    }
    

    NSMutableArray* arDataList = [[NSMutableArray alloc] initWithCapacity:0];
    
    NSDictionary  *newDict =  [[NSDictionary alloc]initWithObjectsAndKeys:@"1",@"CellCode",@"车贷",@"CellName", nil];
    [arDataList addObject:newDict];
    
    newDict =  [[NSDictionary alloc]initWithObjectsAndKeys:@"2",@"CellCode",@"信用贷",@"CellName", nil];
    [arDataList addObject:newDict];
    
    newDict =  [[NSDictionary alloc]initWithObjectsAndKeys:@"3",@"CellCode",@"企业贷",@"CellName", nil];
    [arDataList addObject:newDict];
    
    newDict =  [[NSDictionary alloc]initWithObjectsAndKeys:@"1000",@"CellCode",@"债券转让",@"CellName", nil];
    [arDataList addObject:newDict];
    
    m_pMiddleShowView  = [[MiddleShowPopupView alloc] initWithFrame:CGRectMake(70, 0, 180, 160) andViewType:1 andData:arDataList];
    m_pMiddleShowView.m_switchDelegate = self;

    [self.view addSubview:m_pMiddleShowView];
}

//重新加载产品信息
-(void)loadProductListInfo_Web:(NSInteger)iLoadFlag
{


    if(m_isLoading == YES)
        return;

    if(iLoadFlag == 1)//重新加载
    {
        m_iCurPageID = 0;
        m_pCellInfoDataSet = nil;
        m_pCurSellDataSet = nil;
        m_pEndSellDataSet = nil;
        m_pReadySellDataSet = nil;
        m_pTransSellDataSet = nil;
    }
    
    CKHttpHelper* pHttpHelper = [CKHttpHelper httpHelperWithOwner:self];
    pHttpHelper.m_iWebServerType = 1;
    pHttpHelper.methodType  = CKHttpMethodTypePost_Page;

    //专业市场的id
    [pHttpHelper setMethodName:[NSString stringWithFormat:@"productInfo/queryProdutList"]];
    [pHttpHelper addParam:[NSString stringWithFormat:@"%d",m_iInfoType] forName:@"tproduct.productType"];
    
    [pHttpHelper addParam:@"10" forName:@"pageB.rowCount"];
    
    m_iCurPageID++;
    [pHttpHelper addParam:[NSString stringWithFormat:@"%d",m_iCurPageID] forName:@"pageB.pageIndex"];
    
    // __block ProductListViewController *blockSelf = self;
    [pHttpHelper setCompleteBlock:^(id dataSet)
     {
         
         [SVProgressHUD dismiss];
         m_isLoading = NO;
         m_isToEndPage = YES;
         JsonXmlParserObj* pJsonObj = dataSet;
         if(pJsonObj)
         {
             m_pCurSellDataSet = [pJsonObj parsetoDataSet:@"productList"];
             
             m_pReadySellDataSet = [pJsonObj parsetoDataSet:@"readyList"];
             
             m_pEndSellDataSet = [pJsonObj parsetoDataSet:@"sucessList"];
             
             m_pTransSellDataSet = [pJsonObj parsetoDataSet:@"transList"];
         }

         if(m_pCellInfoDataSet == nil)
         {
             m_pCellInfoDataSet = [[QDataSetObj alloc] init];
         }
         
         int iAddRow = [m_pCellInfoDataSet getRowCount];
         //正在销售
         if(m_pCurSellDataSet != nil)
         {
             for(int i=0;i<[m_pCurSellDataSet getRowCount];i++)
             {
                 [m_pCellInfoDataSet addDataSetRow_Ext:iAddRow andName:@"cellType" andValue:@"1"];
                 [m_pCellInfoDataSet addDataSetRow_Ext:iAddRow andName:@"dataIndex" andValue:[NSString stringWithFormat:@"%d",i]];
                 [m_pCellInfoDataSet addDataSetRow_Ext:iAddRow andName:@"cellTitle" andValue:@""];
                 iAddRow++;
             }
         }
         iAddRow = [m_pCellInfoDataSet getRowCount];

         if(m_pReadySellDataSet != nil)
         {
             for(int i=0;i<[m_pReadySellDataSet getRowCount];i++)
             {
                 [m_pCellInfoDataSet addDataSetRow_Ext:iAddRow andName:@"cellType" andValue:@"2"];
                 [m_pCellInfoDataSet addDataSetRow_Ext:iAddRow andName:@"dataIndex" andValue:[NSString stringWithFormat:@"%d",i]];
                 if(i == 0)
                 {
                     [m_pCellInfoDataSet addDataSetRow_Ext:iAddRow andName:@"cellTitle" andValue:@"即将开始投标的项目"];
                 }
                 else
                 {
                   [m_pCellInfoDataSet addDataSetRow_Ext:iAddRow andName:@"cellTitle" andValue:@""];
                 }

                 iAddRow++;
             }
         }
             
         iAddRow = [m_pCellInfoDataSet getRowCount];
         
         if(m_pEndSellDataSet != nil)
         {
             for(int i=0;i<[m_pEndSellDataSet getRowCount];i++)
             {
                 [m_pCellInfoDataSet addDataSetRow_Ext:iAddRow andName:@"cellType" andValue:@"3"];
                 [m_pCellInfoDataSet addDataSetRow_Ext:iAddRow andName:@"dataIndex" andValue:[NSString stringWithFormat:@"%d",i]];
                 if(i == 0)
                 {
                     [m_pCellInfoDataSet addDataSetRow_Ext:iAddRow andName:@"cellTitle" andValue:@"投标成功的项目"];
                 }
                 else
                 {
                     [m_pCellInfoDataSet addDataSetRow_Ext:iAddRow andName:@"cellTitle" andValue:@""];
                 }
                 
                 iAddRow++;
             }
         }
         
         iAddRow = [m_pCellInfoDataSet getRowCount];
         //转让
         if(m_pTransSellDataSet != nil)
         {
             for(int i=0;i<[m_pTransSellDataSet getRowCount];i++)
             {
                 [m_pCellInfoDataSet addDataSetRow_Ext:iAddRow andName:@"cellType" andValue:@"1000"];
                 [m_pCellInfoDataSet addDataSetRow_Ext:iAddRow andName:@"dataIndex" andValue:[NSString stringWithFormat:@"%d",i]];
                 [m_pCellInfoDataSet addDataSetRow_Ext:iAddRow andName:@"cellTitle" andValue:@""];
                 iAddRow++;
             }
         }


         [_uiMainTableView reloadData];
 
     }];
    
    [pHttpHelper setStartBlock:^{
        [SVProgressHUD showWithStatus:HINT_WEBDATA_LOADING];
    }];
    
    m_isLoading = YES;
    [pHttpHelper start];

}


#pragma UITableViewDataSource,UITableViewDelegate

//didSelectRowAtIndexPath
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row >= [m_pCellInfoDataSet getRowCount])
        return;
    NSString* strProductName = @"";
    NSString* strProductId = @"";
    NSString* strMinTenderMoney = @"";
    
    int iCellType = [m_pCellInfoDataSet getFeildValue_Int:indexPath.row andColumn:@"cellType"];
    int iDataIndex = [m_pCellInfoDataSet getFeildValue_Int:indexPath.row andColumn:@"dataIndex"];
    
    if(iCellType == 1000) {
        strProductName = [m_pTransSellDataSet getFeildValue:iDataIndex andColumn:@"productName"];
        strProductId = [m_pTransSellDataSet getFeildValue:iDataIndex andColumn:@"productId"];
        
        NSString *transId = [m_pTransSellDataSet getFeildValue:iDataIndex andColumn:@"transId"];
        DDTransMakeTurePageView *vc = [[DDTransMakeTurePageView alloc] init];
        vc.transId = transId;
        vc.productId = strProductId;
        vc.transName = strProductName;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }else if(iCellType == 1)
    {
        strProductName = [m_pCurSellDataSet getFeildValue:iDataIndex andColumn:@"productName"];
        strProductId = [m_pCurSellDataSet getFeildValue:iDataIndex andColumn:@"productId"];
        strMinTenderMoney = [m_pCurSellDataSet getFeildValue:iDataIndex andColumn:@"leastAmount"];
    }
    else if(iCellType == 2)
    {
        strProductName = [m_pReadySellDataSet getFeildValue:iDataIndex andColumn:@"productName"];
        strProductId = [m_pReadySellDataSet getFeildValue:iDataIndex andColumn:@"productId"];
        strMinTenderMoney = [m_pReadySellDataSet getFeildValue:iDataIndex andColumn:@"leastAmount"];
    }
    else if(iCellType == 3)
    {
        strProductName = [m_pEndSellDataSet getFeildValue:iDataIndex andColumn:@"productName"];
        strProductId = [m_pEndSellDataSet getFeildValue:iDataIndex andColumn:@"productId"];
        strMinTenderMoney = [m_pEndSellDataSet getFeildValue:iDataIndex andColumn:@"leastAmount"];
    }
    
    Car_LoanDetailInfoPageView* pDetailView = [[Car_LoanDetailInfoPageView alloc] init];
    pDetailView.hidesBottomBarWhenPushed =YES;
    pDetailView.m_strProductName = strProductName;
    pDetailView.m_strProductId = strProductId;
    pDetailView.m_iLoanType  = m_iInfoType;
    //起投金额
    pDetailView.m_strMinTenderMoney = strMinTenderMoney;
    [self.navigationController pushViewController:pDetailView animated:YES];
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
/*
    NSInteger iMaxRow = [m_pInfoDataSet getRowCount] - 1;
    
    int iRow = indexPath.row;
    if(iRow == iMaxRow)
    {
        if(m_isToEndPage == YES)
        {
            if(m_iCurPageID == 1)
                return;
            [SVProgressHUD showSuccessWithStatus:HINT_LASTEST_PAGE duration:1.8];
            return;
        }
        [self loadProductListInfo_Web:1];
    }
*/
}


//
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* strCellTitle = [m_pCellInfoDataSet getFeildValue:indexPath.row andColumn:@"cellTitle"];
    if(strCellTitle.length > 0)
        return 120;
    return 100;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(m_pCellInfoDataSet == nil)
        return 0;
    int iRowCount = [m_pCellInfoDataSet getRowCount];
    return iRowCount;
}



//
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strCarLoanTableViewCellId = @"CarLoanTableViewCellId";
    CarLoanInfoTableCell *pCellObj = (CarLoanInfoTableCell*)[tableView dequeueReusableCellWithIdentifier:strCarLoanTableViewCellId];
    if (!pCellObj)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CarLoanInfoTableCell" owner:self options:nil];
        pCellObj = [nib objectAtIndex:0];
        
        pCellObj.contentView.backgroundColor = [UIColor whiteColor];
        pCellObj.selectionStyle = UITableViewCellSelectionStyleNone;
        //初始化设置
        [pCellObj initCellDefaultShow];
        
    }
    
    int iCellType = [m_pCellInfoDataSet getFeildValue_Int:indexPath.row andColumn:@"cellType"];
    int iDataIndex = [m_pCellInfoDataSet getFeildValue_Int:indexPath.row andColumn:@"dataIndex"];
    
    QDataSetObj* pDataSet = nil;
    if(iCellType == 1)
    {
        pDataSet = m_pCurSellDataSet;
        pCellObj.limitTimeLabel.text = @"融资期限";
        pCellObj.amountLabel.text = @"融资金额";
    }
    else if(iCellType == 2)
    {
        pDataSet = m_pReadySellDataSet;
        pCellObj.limitTimeLabel.text = @"融资期限";
        pCellObj.amountLabel.text = @"融资金额";
    }
    else if(iCellType == 3)
    {
        pDataSet = m_pEndSellDataSet;
        pCellObj.limitTimeLabel.text = @"融资期限";
        pCellObj.amountLabel.text = @"融资金额";
    } else if(iCellType == 1000)
    {
        pDataSet = m_pTransSellDataSet;
        pCellObj.limitTimeLabel.text = @"剩余期限";
        pCellObj.amountLabel.text = @"转让金额";
    }
    
    //产品名称
    pCellObj.m_uiCarLoanIdLabel.text = [pDataSet getFeildValue:iDataIndex andColumn:@"productName"];
    //年化收益
    NSString* strValue = [pDataSet getFeildValue:iDataIndex andColumn:@"expectAnnual"];
    float fValue = [QDataSetObj convertToFloat:strValue]*100;
    pCellObj.m_uiPcertInLabel.text = [NSString stringWithFormat:@"%.2f%%",fValue];
    //新或旧
    NSString* strProductTag = [pDataSet getFeildValue:iDataIndex andColumn:@"productTag"];
    [pCellObj setNewOrHotShow:[QDataSetObj convertToInt:strProductTag]];
    
    //期限
    pCellObj.m_uiLoanLongLabel.text = [NSString stringWithFormat:@"%@个月",[pDataSet getFeildValue:iDataIndex andColumn:@"limitTime"]];
    
    //起购金额没有
    pCellObj.m_uiLoanStartLabel.text = [pDataSet getFeildValue:iDataIndex andColumn:@"financingAmount"];
    
    //已购比例
    NSString* strTotalValue = [pDataSet getFeildValue:iDataIndex andColumn:@"financingAmount"];
    NSString* strHaveValue =  [pDataSet getFeildValue:iDataIndex andColumn:@"hasFinancingAmount"];
    int iStatus = [pDataSet getFeildValue_Int:iDataIndex andColumn:@"status"];
    //计算完成比例
    float fPcert1 = [AppInitDataMethod calculatePcert:strHaveValue andTotal:strTotalValue];
    [pCellObj setProductPcertValue:fPcert1 andType:iCellType andStatus:iStatus];
    
    NSString* strCellTitle = [m_pCellInfoDataSet getFeildValue:indexPath.row andColumn:@"cellTitle"];
    [pCellObj setCellTitle:strCellTitle];
    return pCellObj;

}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [m_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    [m_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    
    [self loadProductListInfo_Web:1];
    
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    
    return m_isLoading; // should return if data source model is reloading
    
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    
    return [NSDate date]; // should return date data source was last changed
    
}

#pragma OwnSegmentedControlDelegate
-(void)didChangeSegmentedIndex:(UIButton *)pButton selectedIndex:(NSInteger)iBtnIndex
{
    m_iInfoType = iBtnIndex+1;
    [self loadProductListInfo_Web:1];
}

//
-(void)onEndSelectedCellInfo:(NSString *)strCellId andName:(NSString *)strCellName
{
    if(m_pMiddleShowView != nil)
    {
        [m_pMiddleShowView removeFromSuperview];
        m_pMiddleShowView = nil;
    }

    if(strCellId.length < 1)
        return;
    
    m_iInfoType = strCellId.intValue;
    
    [self setProductTypeShow:m_iInfoType];
    [self loadProductListInfo_Web:1];
}

@end
