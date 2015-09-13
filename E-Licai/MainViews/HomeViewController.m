//
//  HomeViewController.m
//
//  叮叮理财 - 首页

//  Copyright (c) 2014年  All rights reserved.
//

#import "HomeViewController.h"
#import "UaConfiguration.h"
#import "UIOwnSkin.h"
#import "GlobalDefine.h"
#import "LoginViewController.h"
#import "UIColor+Hex.h"
#import "HomePageInfoCell.h"
#import "UINavigationController+CKKit.h"
#import "MoreViewController.h"
//#import "EAppDelegate.h"
#import "HomePageInfoCell.h"
#import "UserRegisterViewController.h"
#import "Car_LoanDetailInfoPageView.h"
#import "JsonXmlParserObj.h"
#import "AppInitDataMethod.h"
#import "BillPaymentViewController.h"
#import "DDAddBankCardPageInfo.h"
#import "KGModal.h"
#import "UserIdSignInfoPopupView.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

@synthesize m_uiMainInfoTable = _uiMainInfoTable;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{

	self.navigationController.navigationBar.translucent = NO;
	self.navigationController.navigationBarHidden = NO;

    m_pAdPicDataSet = nil;
    m_muMultImageDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    m_isLoading = NO;
    _uiMainInfoTable = nil;
    m_homeInfoDataSet = nil;
    //设置导航条信息
    [self initNavigationItem];
    //显示初始化数据
    [super viewDidLoad];

}

-(void)viewWillAppear:(BOOL)animated
{
    [[UaConfiguration sharedInstance] setCurRootCtrl:self];
    
    
    if(_uiMainInfoTable != nil)
    {
        if([[UaConfiguration sharedInstance] userIsHaveLoadinSystem] == YES)
        {
            self.navigationItem.rightBarButtonItem = nil;
        }else
        {
            self.navigationItem.rightBarButtonItem = [UIOwnSkin navTextItemTarget:self action:@selector(onRightLoginClicked:) text:@"登录" andWidth:40];
        }
        
        return;
    }
    
    CGRect rcFrame = self.view.frame;
    rcFrame.origin.y = 0;
    _uiMainInfoTable = [[UITableView alloc]initWithFrame:rcFrame style:UITableViewStylePlain];
    _uiMainInfoTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _uiMainInfoTable.separatorColor = [UIColor clearColor];
    _uiMainInfoTable.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _uiMainInfoTable.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _uiMainInfoTable.showsHorizontalScrollIndicator = NO;
    _uiMainInfoTable.showsVerticalScrollIndicator = NO;
    _uiMainInfoTable.backgroundColor = [UIColor whiteColor];
    _uiMainInfoTable.dataSource = self;
    _uiMainInfoTable.delegate = self;
    [self.view addSubview:_uiMainInfoTable];
    //
    m_refreshHeaderView = [[EGORefreshTableHeaderView alloc]
                           initWithFrame:CGRectMake(0.0f,
                                                    0.0f-_uiMainInfoTable.bounds.size.height,
                                                    _uiMainInfoTable.bounds.size.width,
                                                    _uiMainInfoTable.bounds.size.height)];
    m_refreshHeaderView.delegate = self;
    m_refreshHeaderView.textColor = [UIColor blackColor];
    m_refreshHeaderView.backgroundColor = [UIColor clearColor];
    [_uiMainInfoTable addSubview:m_refreshHeaderView];
    [m_refreshHeaderView refreshLastUpdatedDate];
    
    //几幅广告图片
    m_pAdPicDataSet = [[QDataSetObj alloc] init];
    [m_pAdPicDataSet addDataSetRow_Ext:0 andName:@"imgName" andValue:@"topimg1.png"];
    [m_pAdPicDataSet addDataSetRow_Ext:1 andName:@"imgName" andValue:@"topimg2.png"];
    [m_pAdPicDataSet addDataSetRow_Ext:2 andName:@"imgName" andValue:@"topimg3.png"];
    
    [self getHomePageShowInfo_Web:0];

    
    
}

-(void)viewDidAppear:(BOOL)animated
{


}

//停止定时器
-(void)viewDidDisappear:(BOOL)animated
{
}



//导航条设置
-(void)initNavigationItem
{//

    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.71 green:0.09 blue:0.06 alpha:1];
    //标题
   // self.navigationItem.titleView = [UIOwnSkin navibarTitleView:@"首页" andFrame:CGRectMake(0, 0, 100, 40)];
    //标题
    
    UIView* pTitleView = [[UIView alloc]initWithFrame:CGRectMake(0, 8, 107, 28)];
    UIImageView* pImgView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 23, 23)];
    pImgView.image = [UIImage imageNamed:@"small_logo"];
    [pTitleView addSubview:pImgView];
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(28, 0, 79, 28);
    label.text = @"萧然金融";
    label.font = [UIFont boldSystemFontOfSize:19.0f];
    [pTitleView addSubview:label];
    label.textColor = [UIColor whiteColor];
    
    self.navigationItem.titleView = pTitleView;

    //支付测试
  //  self.navigationItem.leftBarButtonItem = [UIOwnSkin navTextItemTarget:self action:@selector(startLLWalletPayTest:) text:@"支付测试" andWidth:40];
    [self dealFirstLoadShowApp];
}


//登录
-(void)onRightLoginClicked:(id)sender
{
   
    if([[UaConfiguration sharedInstance] userIsHaveLoadinSystem] == YES)
        return;
    
    //弹出登录页面
    LoginViewController* pLoginView = [[LoginViewController alloc] init];
    pLoginView.m_iLoadOrigin = 0;
    pLoginView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:pLoginView animated:YES];
    
    
 
}

//第一次启动的时候，处理自动登录
-(void)dealFirstLoadShowApp
{
    //登录
    if([[UaConfiguration sharedInstance] userIsHaveLoadinSystem] == YES)
        return;
    if([UaConfiguration sharedInstance].m_setLoginState.m_strUserLoginName.length < 1 || [UaConfiguration sharedInstance].m_setLoginState.m_strUserLoginPwd.length < 1)
    
    {
        self.navigationItem.rightBarButtonItem = [UIOwnSkin navTextItemTarget:self action:@selector(onRightLoginClicked:) text:@"登录" andWidth:40];
        
        return;
    }
    
    //启动自动登录操作
    CKHttpHelper *httpHelper = [CKHttpHelper httpHelperWithOwner:self];
    httpHelper.m_iWebServerType =1;
    httpHelper.methodType = CKHttpMethodTypePost_Page;
    [httpHelper setMethodName:@"memberInfo/memberLogin"];
    [httpHelper addParam:[UaConfiguration sharedInstance].m_setLoginState.m_strUserLoginName forName:@"tmember.mobilePhone"];
    [httpHelper addParam:[UaConfiguration sharedInstance].m_setLoginState.m_strUserLoginPwd forName:@"tmember.password"];
    [httpHelper addParam:@"2" forName:@"tmember.deviceType"];
    [httpHelper setCompleteBlock:^(id data)
     {

         
         JsonXmlParserObj* pJsonObj = data;
         if([self userIsHaveLoginSucc:pJsonObj] == YES)
         {
             self.navigationItem.rightBarButtonItem = nil;
         }
         else
         {
             self.navigationItem.rightBarButtonItem = [UIOwnSkin navTextItemTarget:self action:@selector(onRightLoginClicked:) text:@"登录" andWidth:40];
         }
         
     }];
    
    [httpHelper start];

}

-(bool)userIsHaveLoginSucc:(JsonXmlParserObj*)pJsonObj
{
    if(pJsonObj == nil)
    {
        return NO;
    }
    QDataSetObj* pDataSet = [pJsonObj parsetoDataSet:@"data"];
    if(pDataSet == nil)
        return NO;
    if([pDataSet getOpeResult] == NO)
    {

        return NO;
    }
    NSString* strMemberId = [pDataSet getFeildValue:0 andColumn:@"memberId"];
    
    [UaConfiguration sharedInstance].m_setLoginState.m_iUserMemberID = [QDataSetObj convertToInt:strMemberId];
    [[UaConfiguration sharedInstance].m_setLoginState setHaveLoadInSession:1];
    
    //身份证、姓名、银行卡测试用
    [UaConfiguration sharedInstance].m_setLoginState.m_strUserCardId = [pDataSet getFeildValue:0 andColumn:@"idCardNo"];
    
    [UaConfiguration sharedInstance].m_setLoginState.m_strUserReallyName = [pDataSet getFeildValue:0 andColumn:@"name"];
    
    [UaConfiguration sharedInstance].m_setLoginState.m_strBankCardId = [pDataSet getFeildValue:0 andColumn:@"cardSno"];
    return YES;
}

//从服务端下载首页需要显示的相关信息
-(void)getHomePageShowInfo_Web:(NSInteger)iLoadFlag
{

    //从服务端取首页产品的相关数据
    if(m_isLoading == YES)
        return;
    //重新加载
    if(iLoadFlag == 1)
    {
        m_homeInfoDataSet = nil;
    }
    
    CKHttpHelper *pHttpHelper = [CKHttpHelper httpHelperWithOwner:self];
    pHttpHelper.m_iWebServerType = 1;
    pHttpHelper.methodType = CKHttpMethodTypePost_Page;
    //设置webservice方法名
    [pHttpHelper setMethodName:@"productInfo/queryTopProduct"];

    //设置结束block（webservice方法结束后，会自动调用）
    [pHttpHelper setCompleteBlock:^(id dataSet)
     {
         [SVProgressHUD dismiss];
         JsonXmlParserObj* pJsonObj = dataSet;
         if(pJsonObj == nil)
         {
             return ;
         }
         
         m_homeInfoDataSet = [pJsonObj parsetoDataSet:@""];
         
         //[_uiMainInfoTable reloadData];
         
         [self loadHomePageAdImages_Web:iLoadFlag];
     }];
    [pHttpHelper setStartBlock:^{
        [SVProgressHUD showWithStatus:HINT_WEBDATA_LOADING ];
    }];
    //开始连接
    [pHttpHelper start];

    
}

//下载广告图片
-(void)loadHomePageAdImages_Web:(NSInteger)iLoadFlag
{
    if(iLoadFlag == 1)
    {
        m_pAdPicDataSet = nil;
        
        [m_muMultImageDict removeAllObjects];
    }
    
    CKHttpHelper *pHttpHelper = [CKHttpHelper httpHelperWithOwner:self];
    pHttpHelper.m_iWebServerType = 1;
    pHttpHelper.methodType  = CKHttpMethodTypePost_Page;
    [pHttpHelper setMethodName:[NSString stringWithFormat:@"productInfo/queryAdImages"]];
    
    
    [pHttpHelper setCompleteBlock:^(id dataSet)
     {

         
         JsonXmlParserObj* pJsonObj = dataSet;
         if(pJsonObj == nil)
         {
             [_uiMainInfoTable reloadData];
             return ;
         }
         
         QDataSetObj* pDataSet = [pJsonObj parsetoDataSet:@"data"];
         NSString* strImageList = [pDataSet getFeildValue:0 andColumn:@"adImages"];
         if(strImageList.length < 1)
         {
             [_uiMainInfoTable reloadData];
             return;
         }
         NSArray* arImageList = [strImageList componentsSeparatedByString:@"&&"];
         if(arImageList.count < 1)
             return;
         if(m_pAdPicDataSet == nil)
             m_pAdPicDataSet = [[QDataSetObj alloc] init];
         CKHttpImageHelper* pImageHelper = [CKHttpImageHelper httpHelperWithOwner:self];
         for(int i=0;i<arImageList.count;i++)
         {
             NSString* strAdImageUrl = [arImageList objectAtIndex:i];
             if(strAdImageUrl.length < 1)
                 continue;
             
             [m_pAdPicDataSet addDataSetRow_Ext:i andName:@"adImageUrl" andValue:strAdImageUrl];
             
             strAdImageUrl = [AppInitDataMethod getImageFullUrlPath:strAdImageUrl andImgFlag:2];
             NSURL *nsImageReqUrl = [NSURL URLWithString:strAdImageUrl];
             [pImageHelper addImageUrl:nsImageReqUrl forKey:[NSString stringWithFormat:@"%d",i+1]];
         }
         [_uiMainInfoTable reloadData];
         [pImageHelper startWithReceiveBlock:^(UIImage *image,NSString *strKey,BOOL finsh)
          {
              
              if(image == nil || strKey == nil)
                  return ;
              
              [m_muMultImageDict setObject:image forKey:strKey];
              
              [self showTableCellImageShow:strKey.integerValue andImage:image];
          }];
        
     }];

    [pHttpHelper start];
    
    
}


//收到图片后，在tableview的cell上显示
-(void)showTableCellImageShow:(NSInteger)iImageKey andImage:(UIImage*)pImage
{
    int iPageIndex = iImageKey - 1;
    SYPageView* pPageView= [m_sysTopAdPageView pageForIndex:iPageIndex];
    if(pPageView == nil)
        return ;
    UIImageView* pImageView = (UIImageView*)[pPageView viewWithTag:201];
    if(pImageView == nil)
        return;
    pImageView.image = pImage;
    
}

//点击立即购买
-(void)actionBuyNowClicked:(id)sender
{
    if(m_homeInfoDataSet == nil)
        return;
    NSString* strProductId = [m_homeInfoDataSet getFeildValue:0 andColumn:@"productId"];
    if(strProductId.length < 1)
    {
        [SVProgressHUD showErrorWithStatus:@"产品缺少参数！" duration:1.8];
        return;
    }
    NSString* strProductType = [m_homeInfoDataSet getFeildValue:0 andColumn:@"productType"];
    
    Car_LoanDetailInfoPageView *pLoanDetailView = [[Car_LoanDetailInfoPageView alloc] init];
    pLoanDetailView.hidesBottomBarWhenPushed = YES;

    pLoanDetailView.m_strProductId = [m_homeInfoDataSet getFeildValue:0 andColumn:@"productId"];
    pLoanDetailView.m_strProductName = [m_homeInfoDataSet getFeildValue:0 andColumn:@"productName"];
    pLoanDetailView.m_iLoanType = [QDataSetObj convertToInt:strProductType];//产品类型
    [self.navigationController pushViewController:pLoanDetailView animated:YES];
    
}



#pragma mark -UITableView delegate and datasource


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

//获取广告列表视图的cell
-(UITableViewCell*)getAdPicListViewCell:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath
{
    static NSString *strAdPicListViewCellID = @"AdPicListViewCellId";
    UITableViewCell *pCellObj = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:strAdPicListViewCellID];
    if (!pCellObj)
    {
        pCellObj = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strAdPicListViewCellID];
        pCellObj.contentView.backgroundColor = [UIColor whiteColor];
        pCellObj.selectionStyle = UITableViewCellSelectionStyleNone;
        //logo图片
        m_sysTopAdPageView = [[SYPaginatorView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
        m_sysTopAdPageView.delegate = self;
        m_sysTopAdPageView.dataSource = self;
        m_sysTopAdPageView.pageGapWidth = 0;
		m_sysTopAdPageView.pageControl.backgroundColor = [UIColor clearColor];
        m_sysTopAdPageView.tag = 1001;
        [pCellObj.contentView addSubview:m_sysTopAdPageView];
        [m_sysTopAdPageView setCurrentPageIndex:0];
        
    }
    if(m_sysTopAdPageView)
    {
        [m_sysTopAdPageView setCurrentPageIndex:0];
    }
    return pCellObj;
    
}

//
-(UITableViewCell*)getMiddleInfoViewCell:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath
{
    static NSString *strMiddleInfoViewCellID = @"MiddleInfoViewCellId";
    HomePageInfoCell *pCellObj = (HomePageInfoCell*)[tableView dequeueReusableCellWithIdentifier:strMiddleInfoViewCellID];
    if (!pCellObj)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HomePageInfoCell" owner:self options:nil];
        pCellObj = [nib objectAtIndex:0];
        
        pCellObj.contentView.backgroundColor = [UIColor whiteColor];
        pCellObj.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [pCellObj initCellDefaultShow];
    }
    //产品名称
    pCellObj.m_uiTitleLabel.text =  [m_homeInfoDataSet getFeildValue:0 andColumn:@"productName"];
    pCellObj.m_uiNewOldLabel.text = @"新";
    //预期年化

    pCellObj.m_uiMidLabel_11.text = [AppInitDataMethod convertPcertShow:[m_homeInfoDataSet getFeildValue:0 andColumn:@"expectAnnual"]];
    
    //期限
    pCellObj.m_uiMidLabel_21.text = [NSString stringWithFormat:@"%@个月",[m_homeInfoDataSet getFeildValue:0 andColumn:@"limitTime"]];
    
    //起买金额，参数未提供
    pCellObj.m_uiMidLabel_31.text = [m_homeInfoDataSet getFeildValue:0 andColumn:@"leastAmount"];
    
    //总融资金额
    NSString* strTotalValue = [m_homeInfoDataSet getFeildValue:0 andColumn:@"financingAmount"];

    NSString* strHaveValue = [m_homeInfoDataSet getFeildValue:0 andColumn:@"hasFinancingAmount"];
    
    float fIncomePcert = [AppInitDataMethod calculatePcert:strHaveValue andTotal:strTotalValue];
    [pCellObj setCellPcertValue:fIncomePcert];
    
    //新、热的提示
    NSString* strProductTag = [m_homeInfoDataSet getFeildValue:0 andColumn:@"productTag"];
    int iProductTag = [QDataSetObj convertToInt:strProductTag];
    if(iProductTag == 1)
    {
        pCellObj.m_uiNewOldLabel.text = @"新";
    }
    else if(iProductTag == 2)
    {
        pCellObj.m_uiNewOldLabel.text = @"热";
    }
    else
    {
        pCellObj.m_uiNewOldLabel.text = @"";
        [pCellObj.m_uiPointImgView setHidden:YES];
    }
    
    //额外赠送信息
    NSString* strExtInfo = [m_homeInfoDataSet getFeildValue:0 andColumn:@"contents"];
    pCellObj.m_uiExtLabel.text = strExtInfo;
    return pCellObj;
    
}

-(UITableViewCell*)getBuyButtonTableCell:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath
{
    static NSString *strBuyButtonCellID = @"BuyButtonCellId";
    UITableViewCell *pCellObj = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:strBuyButtonCellID];
    if (!pCellObj)
    {
        pCellObj = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strBuyButtonCellID];
        pCellObj.contentView.backgroundColor = [UIColor whiteColor];
        pCellObj.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //
        UIButton* pButton = [UIButton buttonWithType:UIButtonTypeCustom];
        pButton.frame = CGRectMake(70, 4, 180, 35);
        [UIOwnSkin setButtonBackground:pButton];
        pButton.layer.cornerRadius = 15.0;
        pButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [pButton setTitle:@"立即购买" forState:UIControlStateNormal];
        pButton.titleLabel.font = [UIFont systemFontOfSize:16];
        pButton.tag = 100;
        [pButton addTarget:self action:@selector(actionBuyNowClicked:) forControlEvents:UIControlEventTouchUpInside];
        [pCellObj.contentView addSubview:pButton];
        
        //
        UILabel* pLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 45, 300, 18)];
        pLabel.textColor = COLOR_FONT_2;
        pLabel.textAlignment = NSTextAlignmentCenter;
        pLabel.font = [UIFont systemFontOfSize:12];
        pLabel.text = @"账户资金安全由中国建设银行托管";
        [pCellObj.contentView addSubview:pLabel];

        
    }
    return pCellObj;
}

//加载cell
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    UITableViewCell*pCellObj = nil;

    if(indexPath.row == 0)
    {
        pCellObj = [self getAdPicListViewCell:tableView indexPath:indexPath];
    }
    else if(indexPath.row ==1)
    {
        pCellObj = [self getMiddleInfoViewCell:tableView indexPath:indexPath];
    }
    else if(indexPath.row == 2)
    {
        pCellObj = [self getBuyButtonTableCell:tableView indexPath:indexPath];
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
        return 100;

    if(indexPath.row == 1)
        return 270;
    
    return 70;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(m_pAdPicDataSet == nil)
        return 0;
    return  1;
}


//
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(m_homeInfoDataSet == nil)
        return 1;
    return 3;
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //暂时不需要处理，没有分页显示的
}


#pragma mark - SyPaginator delegate and datasource

-(NSInteger)numberOfPagesForPaginatorView:(SYPaginatorView *)paginatorView
{
    if(m_pAdPicDataSet == nil)
        return 1;
    
    int iCount = [m_pAdPicDataSet getRowCount];
    return iCount;

}


//加载商品的log图片
-(SYPageView *)paginatorView:(SYPaginatorView *)paginatorView viewForPageAtIndex:(NSInteger)pageIndex
{
    SYPageView *pPageView = nil;
    
    NSString *strScrollPageId = @"SysTopAdPicListViewId";
    int iHeight = 100;

    pPageView = (SYPageView*)[paginatorView dequeueReusablePageWithIdentifier:strScrollPageId];
    if (!pPageView)
    {
        pPageView = [[SYPageView alloc]initWithReuseIdentifier:strScrollPageId andHeight:iHeight];
        UIImageView *imgV = [[UIImageView alloc]initWithFrame:pPageView.bounds];
        imgV.autoresizingMask =  UIViewAutoresizingFlexibleLeftMargin ;
        imgV.tag = 201;
        [pPageView addSubview:imgV];
    }
    
    UIImageView *pImgView = (UIImageView *)[pPageView viewWithTag:201];
    if(pImgView == nil)
        return pPageView;
    NSString* strKey = [NSString stringWithFormat:@"%d",pageIndex+1];
    UIImage* pAdImage = [m_muMultImageDict objectForKey:strKey];
    if(pAdImage)
    {
        pImgView.image = pAdImage;
    }
    else
    {
        pImgView.image = [UIImage imageNamed:LOADING_IMAGE_NAME];
    }
    return pPageView;
}


//点击logo图的相关处理
-(void)actionPageViewClicked
{

    
    int iCurPageIndex = m_sysTopAdPageView.currentPageIndex;
    if(iCurPageIndex < 0 || iCurPageIndex >= [m_pAdPicDataSet getRowCount])
        return;
    /*
    NSString* strWapUrl = [m_pAdPicDataSet getFeildValue:iCurPageIndex andColumn:@"wapUrl"];
    if(strWapUrl.length < 1)
        return;
    
    WebViewController* pWebView = [[WebViewController alloc] init];
    pWebView.hidesBottomBarWhenPushed = YES;
    pWebView.m_MainUrlStr = strWapUrl;
    [self.navigationController pushViewController:pWebView animated:YES];
   */ 


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
    
    [self getHomePageShowInfo_Web:1];
    
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    
    return m_isLoading; // should return if data source model is reloading
    
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    
    return [NSDate date]; // should return date data source was last changed
    
}

-(void)startLLWalletPayTest:(id)sender
{
  /*
    UserIdSignInfoPopupView* pIdSignView = [[UserIdSignInfoPopupView alloc] initWithFrame:CGRectMake(0, 0, 280, 170) andName:@"test" andId:@"330419197804093215"];

//    m_pMiddlePopView.m_switchDelegate = self;
    
    [[KGModal sharedInstance] setCloseButtonType:KGModalCloseButtonTypeNone];
    [[KGModal sharedInstance] showWithContentView:pIdSignView andAnimated:YES];
    
    
  */
    self.sdk = [[LLPaySdk alloc] init];
    self.sdk.sdkDelegate = self;
    
    // 切换认证支付与快捷支付，假如并不需要切换，可以不调用这个方法
    //  [LLPaySdk setVerifyPayState:self.bVerifyPayState];
    
    
        
    
    NSMutableDictionary* dictPay = [[FeePayComMethod sharedInstance] getFeePayByLLWall_Test];
    dictPay[@"id_no"] = @"330419197804093215";
    dictPay[@"acct_name"] = @"test";
   [self.sdk presentPaySdkInViewController:self withTraderInfo:dictPay];
   
}


- (void)paymentEnd:(LLPayResult)resultCode withResultDic:(NSDictionary *)dic
{
    NSString *msg = @"支付异常";
    switch (resultCode) {
        case kLLPayResultSuccess:
        {
            msg = @"支付成功";
            
            NSString* result_pay = dic[@"result_pay"];
            if ([result_pay isEqualToString:@"SUCCESS"])
            {
                //
                //NSString *payBackAgreeNo = dic[@"agreementno"];
              //  _agreeNumField.text = payBackAgreeNo;
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
    [[[UIAlertView alloc] initWithTitle:@"结果"
                                message:msg
                               delegate:nil
                      cancelButtonTitle:@"确认"
                      otherButtonTitles:nil] show];
}

@end
