//
//  DDBillCenterInfoPageView.m
//  我的叮叮 - 账户中心
//
//  Created  on 2014-11-24.

//

#import "DDBillCenterInfoPageView.h"
#import "UIOwnSkin.h"
#import "UaConfiguration.h"
#import "DDChangeTradePassword_1.h"
#import "DDChangeTradePassword_2.h"
#import "DDBankCardInfoPageView.h"
#import "AppInitDataMethod.h"

@interface DDBillCenterInfoPageView ()

@end

@implementation DDBillCenterInfoPageView

@synthesize m_uiMainTableView  = _uiMainTableView;


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
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [UIOwnSkin backItemTarget:self action:@selector(actionBackNavigation:)];
	self.view.backgroundColor = COLOR_VIEW_BACKGROUND;
    self.navigationItem.titleView = [UIOwnSkin navibarTitleView:@"账户中心" andFrame:CGRectMake(0, 0, 100, 40)] ;
    
    
    
}

-(void)actionBackNavigation:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated
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

}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if(indexPath.row == 0)
    {
        return 65;
    }
    if(indexPath.row == 3)
    {
        return 60;
    }
    if(indexPath.row == 4)
    {
        return 80;
    }
    return 40;
	
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 0;
}

//账号
-(UITableViewCell *)getDdUserBillInfoCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strDdUserBillInfoCellId = @"DdUserBillInfoCellId";
    UITableViewCell *pCellObj = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:strDdUserBillInfoCellId];
    if (!pCellObj)
    {
        pCellObj = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strDdUserBillInfoCellId];
        pCellObj.contentView.backgroundColor = COLOR_VIEW_BACKGROUND;
        pCellObj.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView* pBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 15, self.view.frame.size.width, 40)];
        pBackView.backgroundColor = [UIColor whiteColor];
        [pCellObj.contentView addSubview:pBackView];
        
        //
        UIImageView * pLogoImgView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 7, 25, 25)];
        
        pLogoImgView.tag = 1001;
        pLogoImgView.image = [UIImage imageNamed:@"icon_account_0.png"];
        [pBackView addSubview:pLogoImgView];
        
        
        //账号标题
        UILabel*pLabel = [[UILabel alloc]initWithFrame:CGRectMake(55,10, 100, 21)];
        pLabel.backgroundColor = [UIColor clearColor];
        pLabel.textColor = COLOR_FONT_1;
        
        pLabel.font = [UIFont systemFontOfSize:14.0f];
        pLabel.numberOfLines = 0;
        pLabel.textAlignment  = UITextAlignmentLeft;
        pLabel.tag = 1002;
        pLabel.text = @"账号";
        [pBackView addSubview:pLabel];
        
        //账号内容
        pLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 10, 145, 20)];
        pLabel.textAlignment  = UITextAlignmentRight;
        pLabel.backgroundColor = [UIColor clearColor];
        pLabel.font = [UIFont systemFontOfSize:12.f];
        pLabel.textColor = COLOR_FONT_2;
       // pLabel.text = @"130****0571";
        pLabel.tag = 1003;
        [pBackView addSubview:pLabel];
        
        
        UIImageView*pLineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
        pLineView.backgroundColor = COLOR_CELL_LINE_DEFAULT;
        [pBackView addSubview:pLineView];
        
        
        pLineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, 1)];
        pLineView.backgroundColor = COLOR_CELL_LINE_DEFAULT;
        [pBackView addSubview:pLineView];
        
        
        pLineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 1)];
        [pCellObj.contentView addSubview:pLineView];
    }
    UILabel* pLabel = (UILabel*)[pCellObj.contentView viewWithTag:1003];
    if(pLabel)
    {
        NSString* strPhone = [UaConfiguration sharedInstance].m_setLoginState.m_strUserLoginName;
        
        pLabel.text = [AppInitDataMethod convertToShowPhone:strPhone];
    }
    
    return pCellObj;
    
}


//实名认证和身份认证
-(UITableViewCell *)getDdUserSignTableCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strDdUserSignTableCellId = @"DdUserSignTableCellId";
    UITableViewCell *pCellObj = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:strDdUserSignTableCellId];
    if (!pCellObj)
    {
        pCellObj = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strDdUserSignTableCellId];
        pCellObj.contentView.backgroundColor = [UIColor whiteColor];
        
        pCellObj.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImageView* pLineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
        pLineView.backgroundColor = COLOR_CELL_LINE_DEFAULT;
        pLineView.tag  = 2001;
        [pCellObj.contentView addSubview:pLineView];
        
        //logo
        UIImageView * pLogoImgView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 7, 25, 25)];
        
        pLogoImgView.tag = 1001;
       // pLogoImgView.image = [UIImage imageNamed:@"icon_account_1.png"];
        [pCellObj.contentView addSubview:pLogoImgView];
        
         //
        UILabel*pLabel = [[UILabel alloc]initWithFrame:CGRectMake(55,10, 100, 21)];
        pLabel.backgroundColor = [UIColor clearColor];
        pLabel.textColor = COLOR_FONT_1;
        
        pLabel.font = [UIFont systemFontOfSize:14.0f];
        pLabel.numberOfLines = 0;
        pLabel.textAlignment  = UITextAlignmentLeft;
        pLabel.tag = 1002;
        pLabel.text = @"";
        [pCellObj.contentView addSubview:pLabel];
        
        //余额
        pLabel = [[UILabel alloc] initWithFrame:CGRectMake(155, 10,150, 20)];
        pLabel.textAlignment  = UITextAlignmentRight;
        pLabel.backgroundColor = [UIColor clearColor];
        pLabel.font = [UIFont systemFontOfSize:12.f];
        pLabel.textColor = COLOR_FONT_2;
        pLabel.text = @"";
        pLabel.tag = 1003;
        [pCellObj.contentView addSubview:pLabel];
        
        
        
        pLineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 39, self.view.frame.size.width, 1)];
        pLineView.backgroundColor = COLOR_CELL_LINE_DEFAULT;
        [pCellObj.contentView addSubview:pLineView];
    }
    UIImageView* pLogoImgView = (UIImageView*)[pCellObj.contentView viewWithTag:1001];
    UILabel* pLabel1 = (UILabel*)[pCellObj.contentView viewWithTag:1002];
    UILabel* pLabel2 = (UILabel*)[pCellObj.contentView viewWithTag:1003];
    UIImageView*pTopLineView = (UIImageView*)[pCellObj.contentView viewWithTag:2001];
    if(pLabel1 == nil || pLabel2 == nil || pLogoImgView == nil || pTopLineView == nil)
        return pCellObj;

    if(indexPath.row == 1)
    {
        pLabel1.text = @"实名认证";
        
        //姓名只需要显示最后一个字
        NSString*strShowName =  [UaConfiguration sharedInstance].m_setLoginState.m_strUserReallyName;
        int iLen = strShowName.length;
        if(strShowName.length > 1)
        {
            strShowName = [strShowName substringFromIndex:strShowName.length-1];
        }
        NSString* strHintName = @"";
        for(int i=0;i<iLen-1;i++)
        {
            strHintName = [strHintName stringByAppendingString:@"*"];
        }
        pLabel2.text = [NSString stringWithFormat:@"%@%@",strHintName,strShowName];
        pLogoImgView.image = [UIImage imageNamed:@"icon_account_1.png"];
        pTopLineView.hidden = NO;
    }
    else
    {
        //身份证需要隐藏8位生日
        pLabel1.text = @"身份认证";
        NSString* strCardId = [UaConfiguration sharedInstance].m_setLoginState.m_strUserCardId;
        NSString* strShowCardId = @"";
        if(strCardId.length == 18)
        {
            //前6位
            strShowCardId = [strCardId substringToIndex:6];
            
            strShowCardId = [strShowCardId stringByAppendingString:@"********"];
            
            strShowCardId = [strShowCardId stringByAppendingString:[strCardId substringFromIndex:14]];
        }
        
        pLabel2.text = strShowCardId;
        pLogoImgView.image = [UIImage imageNamed:@"icon_account_2.png"];
        pTopLineView.hidden = YES;
    }
    return pCellObj;
    
}


//银行卡管理
-(UITableViewCell *)getDdUserBankCardCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strDdUserBankCardCellId = @"DdUserBankCardCellId";
    UITableViewCell *pCellObj = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:strDdUserBankCardCellId];
    if (!pCellObj)
    {
        pCellObj = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strDdUserBankCardCellId];
        pCellObj.contentView.backgroundColor = COLOR_VIEW_BACKGROUND;
        pCellObj.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView* pBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, 40)];
        pBackView.backgroundColor = [UIColor whiteColor];
        [pCellObj.contentView addSubview:pBackView];
        
        UIImageView*pLineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
        pLineView.backgroundColor = COLOR_CELL_LINE_DEFAULT;
        [pBackView addSubview:pLineView];
        //
        UIImageView * pLogoImgView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 7, 25, 25)];
        
        pLogoImgView.tag = 1001;
        pLogoImgView.image = [UIImage imageNamed:@"icon_account_3.png"];
        [pBackView addSubview:pLogoImgView];
        
        
        //产品名称
        UILabel*pLabel = [[UILabel alloc]initWithFrame:CGRectMake(55,10, 100, 21)];
        pLabel.backgroundColor = [UIColor clearColor];
        pLabel.textColor = COLOR_FONT_1;
        
        pLabel.font = [UIFont systemFontOfSize:14.0f];
        pLabel.numberOfLines = 0;
        pLabel.textAlignment  = UITextAlignmentLeft;
        pLabel.tag = 1002;
        pLabel.text = @"银行卡管理";
        [pBackView addSubview:pLabel];
        
        //余额
        /*
        pLabel = [[UILabel alloc] initWithFrame:CGRectMake(170, 12, 100, 14)];
        pLabel.textAlignment  = UITextAlignmentRight;
        pLabel.backgroundColor = [UIColor clearColor];
        pLabel.font = [UIFont systemFontOfSize:14.f];
        pLabel.textColor = COLOR_FONT_2;
        pLabel.text = @"(1)";
        pLabel.tag = 1003;
        [pBackView addSubview:pLabel];
        */
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(300, 13, 7, 13)];
        imageView.image = [UIImage imageNamed:@"cell_arrow.png"];
        [pBackView addSubview:imageView];
        
        
        pLineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 39, self.view.frame.size.width, 1)];
        pLineView.backgroundColor = COLOR_CELL_LINE_DEFAULT;
        [pBackView addSubview:pLineView];
        
        pLineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 59, self.view.frame.size.width, 1)];
        pLineView.backgroundColor = COLOR_CELL_LINE_DEFAULT;
        [pCellObj.contentView addSubview:pLineView];
    }
    
    return pCellObj;
    
}


//修改登录和交易密码
-(UITableViewCell *)getDdUserModPasswordCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strDdUserModPasswordCellId = @"DdUserModPasswordCellId";
    UITableViewCell *pCellObj = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:strDdUserModPasswordCellId];
    if (!pCellObj)
    {
        pCellObj = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strDdUserModPasswordCellId];
        pCellObj.contentView.backgroundColor = [UIColor whiteColor];
        pCellObj.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //
        UIImageView * pLogoImgView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 32, 25, 25)];
        
        pLogoImgView.tag = 1001;
        pLogoImgView.image = [UIImage imageNamed:@"icon_account_4.png"];
        [pCellObj.contentView addSubview:pLogoImgView];
        
        //
        UIButton* pCellButton = [UIButton buttonWithType:UIButtonTypeCustom];
        pCellButton.tag = 2001;
        pCellButton.frame = CGRectMake(55, 1, 260, 38);
        [pCellButton addTarget:self action:@selector(actionChangePasswordClicked:) forControlEvents:UIControlEventTouchUpInside];
        [pCellObj addSubview:pCellButton];
        
        //
        UILabel*pLabel = [[UILabel alloc]initWithFrame:CGRectMake(5,10, 100, 21)];
        pLabel.backgroundColor = [UIColor clearColor];
        pLabel.textColor = COLOR_FONT_1;
        
        pLabel.font = [UIFont systemFontOfSize:14.0f];
        pLabel.numberOfLines = 0;
        pLabel.textAlignment  = UITextAlignmentLeft;
        pLabel.tag = 1002;
        pLabel.text = @"修改登录密码";
        [pCellButton addSubview:pLabel];
        
        
        UIImageView *pArrowImgView = [[UIImageView alloc]initWithFrame:CGRectMake(245, 13, 7, 13)];
        pArrowImgView.image = [UIImage imageNamed:@"cell_arrow.png"];
        [pCellButton addSubview:pArrowImgView];
        
        
        
        UIImageView*pLineView = [[UIImageView alloc] initWithFrame:CGRectMake(55, 39, self.view.frame.size.width, 1)];
        pLineView.backgroundColor = COLOR_CELL_LINE_DEFAULT;
        [pCellObj.contentView addSubview:pLineView];
        
        
        pCellButton = [UIButton buttonWithType:UIButtonTypeCustom];
        pCellButton.tag = 2002;
        pCellButton.frame = CGRectMake(55, 41, 260, 38);
        [pCellButton addTarget:self action:@selector(actionChangePasswordClicked:) forControlEvents:UIControlEventTouchUpInside];
        [pCellObj addSubview:pCellButton];
        
        //修改交易密码
        pLabel = [[UILabel alloc]initWithFrame:CGRectMake(5,10, 100, 21)];
        pLabel.backgroundColor = [UIColor clearColor];
        pLabel.textColor = COLOR_FONT_1;
        
        pLabel.font = [UIFont systemFontOfSize:14.0f];
        pLabel.numberOfLines = 0;
        pLabel.textAlignment  = UITextAlignmentLeft;
        pLabel.tag = 1003;
        pLabel.text = @"修改交易密码";
        [pCellButton addSubview:pLabel];
        
        
        pArrowImgView = [[UIImageView alloc]initWithFrame:CGRectMake(245, 13, 7, 12)];
        pArrowImgView.image = [UIImage imageNamed:@"cell_arrow.png"];
        [pCellButton addSubview:pArrowImgView];
        
        
        pLineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 79, self.view.frame.size.width, 1)];
        pLineView.backgroundColor = COLOR_CELL_LINE_DEFAULT;
        [pCellObj.contentView addSubview:pLineView];
        
    }
    return pCellObj;
    
}


//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* pCellObj = nil;
    if(indexPath.row == 0)
    {
        pCellObj = [self getDdUserBillInfoCell:tableView cellForRowAtIndexPath:indexPath];
        
    }
    else if(indexPath.row == 1 || indexPath.row == 2)
    {
        pCellObj = [self getDdUserSignTableCell:tableView cellForRowAtIndexPath:indexPath];
    }
    else if(indexPath.row == 3)
    {
        pCellObj = [self getDdUserBankCardCell:tableView cellForRowAtIndexPath:indexPath];
    }
    else
    {
        pCellObj = [self getDdUserModPasswordCell:tableView cellForRowAtIndexPath:indexPath];
    }
    
    return pCellObj;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //
    if(indexPath.row == 3)//银行卡管理
    {
        DDBankCardInfoPageView* pBankCardView = [[DDBankCardInfoPageView alloc] init];
        pBankCardView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:pBankCardView animated:YES];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag ==1001)
    {
        if (buttonIndex ==0)
        {
            return;
        }
        if (buttonIndex ==1)
        {

            [self startDownloadApp];

        }
    }
    else	if (alertView.tag ==1002)
    {
	
	
        if (buttonIndex==0) {
            return;
        }
        if (buttonIndex==1) {
        
            [self logOut];
        }
        
    }
    else if (alertView.tag ==1003)
    {
        if (buttonIndex ==0) {
            return;
        }
        if (buttonIndex ==1)
        {
	 

        }
	
    }
}

//退出登录
-(void) logOut
{
    /*
    CKHttpHelper *httpHelper = [CKHttpHelper httpHelperWithOwner:self];
    httpHelper.m_iWebServerType = 1;
    httpHelper.methodType  = CKHttpMethodTypePost_Page;
    
    [httpHelper setMethodName:@"user.logOut"];
    
    [httpHelper addParam:[UaConfiguration sharedInstance].m_setLoginState.m_strUserLoginSid forName:@"sid"];
    
    
    [httpHelper setCompleteBlock:^(id dataSet)
     {
         [SVProgressHUD dismiss];
         if(dataSet)
         {
             if ([dataSet getOpeResult])
             {
                 [SVProgressHUD showSuccessWithStatus:@"退出登录成功!"];
             }
         }
         else
         {
             [SVProgressHUD showErrorWithStatus:HINT_WEBDATA_NET_ERROR duration:1.8];
         }
         
         [UaConfiguration sharedInstance].m_setLoginState.m_strUserLoginPwd = @"";
         [UaConfiguration sharedInstance].m_setLoginState.m_strUserLoginName  = @"";
         [UaConfiguration sharedInstance].m_setLoginState.m_strUserLoginSid = @"";
         [UaConfiguration sharedInstance].m_setLoginState.m_iUserStoreID =0;
         [UaConfiguration sharedInstance].m_setLoginState.m_iUserRank =0;
         [UaConfiguration sharedInstance].m_isSwitchUserFlag = 1;
         
         UIApplication *app = [UIApplication sharedApplication];
         EAppDelegate *curEypAppDelegate = (EAppDelegate *)app.delegate;
         [curEypAppDelegate.m_appTabBarController setSelectedIndex:0];
         if (curEypAppDelegate.m_appTabBarController.JCTabBar.tabContainer != nil)
         {
             [curEypAppDelegate.m_appTabBarController.JCTabBar.tabContainer  itemSelectedByIndex:0];
         }
         
         [self.navigationController popViewControllerAnimated:YES];
    }];
    [httpHelper setStartBlock:^{
             [SVProgressHUD showWithStatus:HINT_WEBDATA_LOADING];
    }];
    [httpHelper start];
     */
}

//检查版本是否为最新
-(void)versionCheck
{
    
//	NSLog(@"%@",[UaConfiguration sharedInstance].m_strApplicationVersion);
	CKHttpHelper *helper = [[CKHttpHelper alloc]initWithOwner:self];
	
	[helper setM_iWebServerType:1];
	[helper setMethodType:CKHttpMethodTypePost_Page];
	[helper setMethodName:@"app.versionUpdate"];
	
	[helper addParam:[NSString stringWithFormat:@"2"] forName:@"appType"];
	[helper addParam:[UaConfiguration sharedInstance].m_strApplicationVersion forName:@"version"];
	[helper  setCompleteBlock:^(id data)
	 {
		 QDataSetObj *setObj = data;
		 
		 if (setObj) {
			 
			 if (setObj.getOpeResult==false) {
				 [SVProgressHUD showErrorWithStatus:[setObj getErrorText] duration:2.0];
			 }
			 
			 else
			 {
				 NSString *str= [setObj getFeildValue:0 andColumn:@"updateFlag"];
				 if ([str isEqualToString:@"0"]) {
					 [SVProgressHUD showSuccessWithStatus:@"当前已是最新版本" duration:2.0];
				 }
				 else if ([str isEqualToString:@"2"])
				 {

                     [self startDownloadApp];
				 }
				 
				 else  if ([str isEqualToString:@"1"] ) {
					 
					 UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"当前已有新版本，旧版本可以正常使用，如需下载新版本请前往下载" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:@"下载", nil];
					 alertView.tag = 1001;
					 [alertView show];
				 }
			 }
			 
		 }
		 else
		 {
			 [SVProgressHUD showErrorWithStatus:@"网络错误，请重试" duration:2.0];
			 return;
		 }
	 }];
	
	
	[helper start];
	
}

//启动帮助
-(void)startToWapHelp
{
/*
 
	CKHttpHelper *httpHelper = [[CKHttpHelper alloc]initWithOwner:self];
	//http://www.topws.cn/api/ltb.php?action=user.getHelpPage&model=1
    
 	[httpHelper setM_iWebServerType:1];
	[httpHelper setMethodType:CKHttpMethodTypePost_Page];
	[httpHelper setMethodName:@"user.getHelpPage"];
	
	[httpHelper addParam:[NSString stringWithFormat:@"2"] forName:@"model"];

	[httpHelper  setCompleteBlock:^(id data)
	 {
		 QDataSetObj *pDataSet = data;
         if(pDataSet == nil)
		 {
             [SVProgressHUD showErrorWithStatus:HINT_WEBDATA_NET_ERROR duration:1.8];
			 return;
		 }
         if([pDataSet getOpeResult] == false)
         {
             [SVProgressHUD showErrorWithStatus:[pDataSet getErrorText] duration:1.8];
             return;
         }
         if([pDataSet getRowCount] < 1)
             return;
         NSString* strWapUrl = [pDataSet getFeildValue:0 andColumn:@"wapUrl"];
         WebViewController* pWebView = [[WebViewController alloc] init];
         pWebView.m_MainUrlStr = strWapUrl;
         pWebView.hidesBottomBarWhenPushed = YES;
         [self.navigationController pushViewController:pWebView animated:YES];
	 }];
	
	
	[httpHelper start];*/
	
}


//清除缓存：主要是图片缓存
-(void)actionWipeCache
{
    /*
    NSString *strImgDirPath = [ImgFileMethod getAppDocumentImageDir];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [SVProgressHUD showWithStatus:@"正在清除..."];
        [[NSFileManager defaultManager] removeItemAtPath:strImgDirPath error:nil];
        [NSThread sleepForTimeInterval:1.2];
        [SVProgressHUD dismissWithSuccess:@"清除完成!" afterDelay:1.8];
    });
     */
}

//启动APP用户评分
-(void)startUserAppMark:(NSString*)strAppUrl
{
     
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strAppUrl]];
    
}

-(void)startDownloadApp
{
    //http://itunes.apple.com/lookup?id=620302844(查询app store上的版本号的post方法的url)
    //默认为app store更新
    NSURL* nsUrl = [[NSURL alloc]initWithString:@"https://itunes.apple.com/us/app/mo-jie/id620302844?l=zh&ls=1&mt=8"];

    if([UaConfiguration sharedInstance].m_iAppUpdateFromType == 2)
    {

    }
    [[UIApplication sharedApplication]openURL:nsUrl];

    
}

//点击修改登录密码或交易密码
-(void)actionChangePasswordClicked:(id)sender
{
    UIButton* pButton = (UIButton*)sender;
    if(pButton == nil)
        return;
    if(pButton.tag == 2001)
    {
        DDChangeTradePassword_2* pPasswordView = [[DDChangeTradePassword_2 alloc] init];
        pPasswordView.m_iPasswordType = 1;
        pPasswordView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:pPasswordView animated:YES];
    }
    else
    {
        DDChangeTradePassword_1* pPasswordView = [[DDChangeTradePassword_1 alloc] init];
        pPasswordView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:pPasswordView animated:YES];
       
    }
}

@end
