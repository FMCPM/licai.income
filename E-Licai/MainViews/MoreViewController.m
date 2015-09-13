//
//  MoreViewController.m
//
//  叮叮理财 - 更多
//
//  Created by lzq on 2014-12-24.
//

#import "MoreViewController.h"
#import "UaConfiguration.h"
#import "AboutUsViewController.h"
#import "ImgFileMethod.h"
#import "QDataSetObj.h"
#import "UIOwnSkin.h"
#import "GlobalDefine.h"
#import "WebViewController.h"
#import "LoginViewController.h"
#import "CKHttpHelper.h"
#import "WebViewController.h"
#import "EAppDelegate.h"
#import "MoreMessageCenterPageView.h"
#import "MoreActivityCenterPageView.h"
#import "MoreHelpCenterInfoPageView.h"
#import "MoreFeedbackInfoPageView.h"
#import "KGModal.h"
#import "UILabel+CKKit.h"
#import "WXApi.h"
#import "JsonXmlParserObj.h"


@interface MoreViewController ()

@end

@implementation MoreViewController

@synthesize m_uiTableView  = _uiTableView;


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
    
    self.navigationController.navigationBar.translucent = NO;
	self.view.backgroundColor = COLOR_VIEW_BACKGROUND;
    self.navigationItem.titleView = [UIOwnSkin navibarTitleView:@"更多" andFrame:CGRectMake(0, 0, 100, 40)] ;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self initMoreCellData];
}

-(void)initMoreCellData
{
    m_pInfoDataSet = [[QDataSetObj alloc] init];
    [m_pInfoDataSet addDataSetRow_Ext:0 andName:@"cellTitle" andValue:@""];
    [m_pInfoDataSet addDataSetRow_Ext:0 andName:@"cellType" andValue:@"0"];
    [m_pInfoDataSet addDataSetRow_Ext:0 andName:@"cellImg" andValue:@"0"];
    [m_pInfoDataSet addDataSetRow_Ext:0 andName:@"cellHeight" andValue:@"10"];
    
    [m_pInfoDataSet addDataSetRow_Ext:1 andName:@"cellTitle" andValue:@"活动中心"];
    [m_pInfoDataSet addDataSetRow_Ext:1 andName:@"cellType" andValue:@"1"];
    [m_pInfoDataSet addDataSetRow_Ext:1 andName:@"cellImg" andValue:@"icon_more_item_0.png"];
    [m_pInfoDataSet addDataSetRow_Ext:1 andName:@"cellHeight" andValue:@"44"];
    
    
    [m_pInfoDataSet addDataSetRow_Ext:2 andName:@"cellTitle" andValue:@"消息中心"];
    [m_pInfoDataSet addDataSetRow_Ext:2 andName:@"cellType" andValue:@"2"];
    [m_pInfoDataSet addDataSetRow_Ext:2 andName:@"cellImg" andValue:@"icon_more_item_1.png"];
    [m_pInfoDataSet addDataSetRow_Ext:2 andName:@"cellHeight" andValue:@"44"];
    
    [m_pInfoDataSet addDataSetRow_Ext:3 andName:@"cellTitle" andValue:@"帮助中心"];
    [m_pInfoDataSet addDataSetRow_Ext:3 andName:@"cellType" andValue:@"3"];
    [m_pInfoDataSet addDataSetRow_Ext:3 andName:@"cellImg" andValue:@"icon_more_item_2.png"];
    [m_pInfoDataSet addDataSetRow_Ext:3 andName:@"cellHeight" andValue:@"54"];
    
    [m_pInfoDataSet addDataSetRow_Ext:4 andName:@"cellTitle" andValue:@""];
    [m_pInfoDataSet addDataSetRow_Ext:4 andName:@"cellType" andValue:@"0"];
    [m_pInfoDataSet addDataSetRow_Ext:4 andName:@"cellImg" andValue:@"0"];
    [m_pInfoDataSet addDataSetRow_Ext:4 andName:@"cellHeight" andValue:@"10"];
    
    
    [m_pInfoDataSet addDataSetRow_Ext:5 andName:@"cellTitle" andValue:@"转发好友"];
    [m_pInfoDataSet addDataSetRow_Ext:5 andName:@"cellType" andValue:@"4"];
    [m_pInfoDataSet addDataSetRow_Ext:5 andName:@"cellImg" andValue:@"icon_more_item_3.png"];
    [m_pInfoDataSet addDataSetRow_Ext:5 andName:@"cellHeight" andValue:@"44"];
    
    [m_pInfoDataSet addDataSetRow_Ext:6 andName:@"cellTitle" andValue:@"意见反馈"];
    [m_pInfoDataSet addDataSetRow_Ext:6 andName:@"cellType" andValue:@"5"];
    [m_pInfoDataSet addDataSetRow_Ext:6 andName:@"cellImg" andValue:@"icon_more_item_4.png"];
    [m_pInfoDataSet addDataSetRow_Ext:6 andName:@"cellHeight" andValue:@"44"];
    
    [m_pInfoDataSet addDataSetRow_Ext:7 andName:@"cellTitle" andValue:@"关注我们"];
    [m_pInfoDataSet addDataSetRow_Ext:7 andName:@"cellType" andValue:@"6"];
    [m_pInfoDataSet addDataSetRow_Ext:7 andName:@"cellImg" andValue:@"icon_more_item_5.png"];
    [m_pInfoDataSet addDataSetRow_Ext:7 andName:@"cellHeight" andValue:@"44"];
    
    [m_pInfoDataSet addDataSetRow_Ext:8 andName:@"cellTitle" andValue:@"给我鼓励"];
    [m_pInfoDataSet addDataSetRow_Ext:8 andName:@"cellType" andValue:@"7"];
    [m_pInfoDataSet addDataSetRow_Ext:8 andName:@"cellImg" andValue:@"icon_more_item_6.png"];
    [m_pInfoDataSet addDataSetRow_Ext:8 andName:@"cellHeight" andValue:@"54"];
    
    [m_pInfoDataSet addDataSetRow_Ext:9 andName:@"cellTitle" andValue:@""];
    [m_pInfoDataSet addDataSetRow_Ext:9 andName:@"cellType" andValue:@"0"];
    [m_pInfoDataSet addDataSetRow_Ext:9 andName:@"cellImg" andValue:@"0"];
    [m_pInfoDataSet addDataSetRow_Ext:9 andName:@"cellHeight" andValue:@"10"];
    
    
    [m_pInfoDataSet addDataSetRow_Ext:10 andName:@"cellTitle" andValue:@"检查更新"];
    [m_pInfoDataSet addDataSetRow_Ext:10 andName:@"cellType" andValue:@"8"];
    [m_pInfoDataSet addDataSetRow_Ext:10 andName:@"cellImg" andValue:@"icon_more_item_7.png"];
    [m_pInfoDataSet addDataSetRow_Ext:10 andName:@"cellHeight" andValue:@"44"];
    
    [m_pInfoDataSet addDataSetRow_Ext:11 andName:@"cellTitle" andValue:@"关于萧然金融"];
    [m_pInfoDataSet addDataSetRow_Ext:11 andName:@"cellType" andValue:@"9"];
    [m_pInfoDataSet addDataSetRow_Ext:11 andName:@"cellImg" andValue:@"icon_more_item_8.png"];
    [m_pInfoDataSet addDataSetRow_Ext:11 andName:@"cellHeight" andValue:@"44"];
    
    if([[UaConfiguration sharedInstance] userIsHaveLoadinSystem] == YES)
    {
       [m_pInfoDataSet addDataSetRow_Ext:12 andName:@"cellTitle" andValue:@"退出登录"];
        [m_pInfoDataSet addDataSetRow_Ext:12 andName:@"cellType" andValue:@"10"];
    }
    else
    {
        [m_pInfoDataSet addDataSetRow_Ext:12 andName:@"cellTitle" andValue:@"登录"];
        [m_pInfoDataSet addDataSetRow_Ext:12 andName:@"cellType" andValue:@"11"];
    }
    
    [m_pInfoDataSet addDataSetRow_Ext:12 andName:@"cellImg" andValue:@""];
    [m_pInfoDataSet addDataSetRow_Ext:12 andName:@"cellHeight" andValue:@"50"];
    
    [_uiTableView reloadData];
}

-(void)actionBackNavigation:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)viewDidAppear:(BOOL)animated
{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(m_pInfoDataSet == nil)
        return 0;
    
    return [m_pInfoDataSet getRowCount];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.row >= [m_pInfoDataSet getRowCount])
        return 44;
    
    NSString* strCellHeight = [m_pInfoDataSet getFeildValue:indexPath.row andColumn:@"cellHeight"];
    int iCellHeight = [QDataSetObj convertToInt:strCellHeight];
    if(iCellHeight > 44)
        return 44;
    return iCellHeight;

}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 0;
}


//获取推荐列表视图的cell
-(UITableViewCell*)getMoreBackViewCell:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath
{
    static NSString *strMoreBackViewCellId = @"MoreBackViewCellId";
    UITableViewCell *pCellObj = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:strMoreBackViewCellId];

    
    if (!pCellObj)
    {
        pCellObj = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strMoreBackViewCellId];
        pCellObj.contentView.backgroundColor = COLOR_BAR_BACKGROUND;
        pCellObj.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return pCellObj;
}


//获取推荐列表视图的cell
-(UITableViewCell*)getLoginButtonViewCell:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath
{
    static NSString *strLoginButtonViewCellId = @"LoginButtonViewCell";
    UITableViewCell *pCellObj = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:strLoginButtonViewCellId];
    
    
    if (!pCellObj)
    {
        pCellObj = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strLoginButtonViewCellId];
        pCellObj.contentView.backgroundColor = COLOR_BAR_BACKGROUND;
        pCellObj.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        UIButton*pButton = [UIButton buttonWithType:UIButtonTypeCustom];
        pButton.frame = CGRectMake(10, 10, 300, 35);
        pButton.tag = 2001;
        [UIOwnSkin setButtonBackground:pButton];
        
        [pButton addTarget:self action:@selector(actionLoginButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [pCellObj.contentView addSubview:pButton];
        
        
    }
    
    UIButton* pButton = (UIButton*)[pCellObj.contentView viewWithTag:2001];
    if(pButton != nil)
    {
        NSString* strTitle = [m_pInfoDataSet getFeildValue:indexPath.row andColumn:@"cellTitle"];
        [pButton setTitle:strTitle forState:UIControlStateNormal];
    }

    return pCellObj;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* pCellObj = nil;
    NSString* strCellType = [m_pInfoDataSet getFeildValue:indexPath.row andColumn:@"cellType"];
    int iCellType = [QDataSetObj convertToInt:strCellType];
    if(iCellType == 0)
    {
        pCellObj = [self getMoreBackViewCell:tableView indexPath:indexPath];
        return pCellObj;
    }
    if(iCellType == 10 || iCellType == 11)
    {
        
        pCellObj = [self getLoginButtonViewCell:tableView indexPath:indexPath];
        return pCellObj;
    }
    
    
    static NSString *strSystemMoreInfoCellId = @"SystemMoreInfoCellId";
    pCellObj = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:strSystemMoreInfoCellId];
    if (pCellObj == nil)
    {

        pCellObj = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strSystemMoreInfoCellId];
        pCellObj.accessoryType = UITableViewCellAccessoryNone;
        pCellObj.contentView.backgroundColor = [UIColor whiteColor];
        pCellObj.selectionStyle = UITableViewCellSelectionStyleNone;
            
        UILabel *pLabel = [[UILabel alloc]initWithFrame:CGRectMake(55, 0, 265, 50)];
        pLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        pLabel.tag = 1001;
        pLabel.backgroundColor = [UIColor clearColor];
        [pLabel setTextColor:[UIColor grayColor]];
        [pLabel setFont:[UIFont boldSystemFontOfSize:16]];
       
        [pCellObj.contentView addSubview:pLabel];
        pCellObj.selectionStyle = UITableViewCellAccessoryNone;
                
                
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 12.5, 25, 25)];
        imageView.tag = 2001;
        [pCellObj.contentView addSubview:imageView];
        
        UIImageView*pLineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 43, 320, 1)];
        pLineView.tag = 2002;
        pLineView.backgroundColor = COLOR_CELL_LINE_DEFAULT;
        [pCellObj.contentView addSubview:pLineView];
        
        imageView = [[UIImageView alloc]initWithFrame:CGRectMake(300, 19, 7, 12)];
        imageView.image = [UIImage imageNamed:@"cell_arrow.png"];
        imageView.tag = 2003;
        [pCellObj.contentView addSubview:imageView];
        
        imageView = [[UIImageView alloc]initWithFrame:CGRectMake(285, 20, 10, 10)];
        imageView.image = [UIImage imageNamed:@"point_orange.png"];
        imageView.tag = 2004;
        [pCellObj.contentView addSubview:imageView];
        
   }
    
    UILabel* pLable = (UILabel*)[pCellObj.contentView viewWithTag:1001];
    if(pLable)
    {
        pLable.text = [m_pInfoDataSet getFeildValue:indexPath.row andColumn:@"cellTitle"];
        
    }
    UIImageView*pImageView = (UIImageView*)[pCellObj.contentView viewWithTag:2001];
    if(pImageView)
    {
        pImageView.image = [UIImage imageNamed:[m_pInfoDataSet getFeildValue:indexPath.row andColumn:@"cellImg"]];
    }
    pImageView = (UIImageView*)[pCellObj.contentView viewWithTag:2002];
    if(pImageView)
    {
        NSString* strCellHeight = [m_pInfoDataSet getFeildValue:indexPath.row andColumn:@"cellHeight"];
        int iCellHeight = [QDataSetObj convertToInt:strCellHeight];
        if(iCellHeight>44)
            pImageView.hidden = YES;
        else
            pImageView.hidden = NO;
    }

    pImageView = (UIImageView*)[pCellObj.contentView viewWithTag:2004];
    if(pImageView)
    {
        int iCellType = [m_pInfoDataSet getFeildValue_Int:indexPath.row andColumn:@"cellType"];
        if(iCellType == 2)
            pImageView.hidden = NO;
        else
            pImageView.hidden = YES;
    }
    return pCellObj;
}





#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row >= [m_pInfoDataSet getRowCount])
            return;
    
    NSString* strCellType = [m_pInfoDataSet getFeildValue:indexPath.row andColumn:@"cellType"];
    
    int iCellType = [QDataSetObj convertToInt:strCellType];
    switch (iCellType) {
        //活动中心
        case 1:
        {
            MoreActivityCenterPageView* pActiveView = [[MoreActivityCenterPageView alloc] init];
            pActiveView.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:pActiveView animated:YES];
            break;
        }
            
        //消息中心
        case 2:
        {
            MoreMessageCenterPageView* pMessageView = [[MoreMessageCenterPageView alloc] init];
            pMessageView.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:pMessageView animated:YES];
            break;
        }
        //帮助中心
        case 3:
        {
            MoreHelpCenterInfoPageView* pHelpView = [[MoreHelpCenterInfoPageView alloc] init];
            pHelpView.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:pHelpView animated:YES];
            break;
        }
        //转发好友
        case 4:
        {
            
            [self queryAppSharedInfo_Web];

            break;
        }
           
        //意见反馈
        case 5:
        {
            MoreFeedbackInfoPageView* pFeedbackView = [[MoreFeedbackInfoPageView alloc] init];
            pFeedbackView.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:pFeedbackView animated:YES];
            break;
            
        }

        //关注我们
        case 6:
        {
            NSString* strTitle = @"您可在微信-通讯录-添加朋友-查找公众号中搜索‘叮叮理财’，点击关注，可更方便的获取我们的最新消息";
            int iHeight = [UILabel getFitTextHeightWithText:strTitle andWidth:260 andFont:[UIFont systemFontOfSize:14]];
            
            
            m_uiWxPopupView = [[StartWeiXinAppPopupView alloc] initWithFrame:CGRectMake(0, 0, 280, iHeight+70) andViewTitle:strTitle];
   
            m_uiWxPopupView.m_startWXDelegate = self;
            
            [[KGModal sharedInstance] setCloseButtonType:KGModalCloseButtonTypeNone];
            [[KGModal sharedInstance] showWithContentView:m_uiWxPopupView andAnimated:YES];
            break;
        }
        //给我鼓励
        case 7:
        {
            UIAlertView* pAlterView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"App，暂未上线，该功能暂无法使用。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
            [pAlterView show];
            break;
        }
        //检查更新
        case 8:
        {
            break;
        }
        //关于叮叮
        case 9:
        {
            WebViewController* pWebView = [[WebViewController alloc] init];
            pWebView.hidesBottomBarWhenPushed = YES;
            pWebView.m_strViewTitle = @"关于叮叮";
            pWebView.m_strWebUrl = [NSString stringWithFormat:@"%@/productInfo/toAboutUs.do",[UaConfiguration sharedInstance].m_strSoapRequestUrl_1];
            
            [self.navigationController pushViewController:pWebView animated:YES];
        }
        default:
            break;
    }
    
}

#pragma UIAlertView delete
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

    //退出系统提示
    if(alertView.tag ==1001)
    {
        if (buttonIndex ==0)
        {
            return;
        }
        if (buttonIndex ==1)
        {

            int iMaxindex = [m_pInfoDataSet getRowCount] - 1;
            
            NSString* strCellType = [m_pInfoDataSet getFeildValue:iMaxindex andColumn:@"cellType"];
            int iCellType = [QDataSetObj convertToInt:strCellType];
            
            NSIndexPath* indexPath = [NSIndexPath indexPathForRow:iMaxindex inSection:0];
            UITableViewCell* pCellObj = [_uiTableView cellForRowAtIndexPath:indexPath];
            if(pCellObj == nil)
                return;
            
            UIButton* pButton = (UIButton*)[pCellObj.contentView viewWithTag:2001];
            if(pButton == nil)
                return;
            if(iCellType == 10)//退出登录操作
            {
                 [pButton setTitle:@"登录" forState:UIControlStateNormal];
                 [[UaConfiguration sharedInstance].m_setLoginState setHaveLoadInSession:0];
                 //这样就不会再自动登录了
                 [UaConfiguration sharedInstance].m_setLoginState.m_strUserLoginPwd = @"";
                 [m_pInfoDataSet setFieldValue:iMaxindex andName:@"cellType" andValue:@"11"];
                
                UIApplication *app = [UIApplication sharedApplication];
                EAppDelegate *curEypAppDelegate = (EAppDelegate *)app.delegate;
                if (curEypAppDelegate.m_appTabBarController.JCTabBar.tabContainer != nil)
                {
                    [curEypAppDelegate.m_appTabBarController.JCTabBar.tabContainer  itemSelectedByIndex:0];
                }
                
                [self.navigationController popViewControllerAnimated:YES];
            
            }

        }
    }

}

//退出登录
-(void) actionLoginButtonClicked:(id)sender
{
    
    int iMaxindex = [m_pInfoDataSet getRowCount] - 1;
    
    NSString* strCellType = [m_pInfoDataSet getFeildValue:iMaxindex andColumn:@"cellType"];
    int iCellType = [QDataSetObj convertToInt:strCellType];
    
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:iMaxindex inSection:0];
    UITableViewCell* pCellObj = [_uiTableView cellForRowAtIndexPath:indexPath];
    if(pCellObj == nil)
        return;
    
    UIButton* pButton = (UIButton*)[pCellObj.contentView viewWithTag:2001];
    if(pButton == nil)
        return;
    if(iCellType == 10)//退出登录操作
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您确定要退出吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = 1001;
        [alertView show];
        /*
        [pButton setTitle:@"登录" forState:UIControlStateNormal];
        [[UaConfiguration sharedInstance].m_setLoginState setHaveLoadInSession:0];
        [m_pInfoDataSet setFieldValue:iMaxindex andName:@"cellType" andValue:@"11"];
         */
    }
    else
    {
        LoginViewController* pLoginView = [[LoginViewController alloc] init];
        pLoginView.m_iLoadOrigin = 4;
        pLoginView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:pLoginView animated:YES];
    }
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
       //  [UaConfiguration sharedInstance].m_setLoginState.m_iUserStoreID =0;
     //    [UaConfiguration sharedInstance].m_setLoginState.m_iUserRank =0;
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
         pWebView.m_strWebUrl = strWapUrl;
         pWebView.hidesBottomBarWhenPushed = YES;
         [self.navigationController pushViewController:pWebView animated:YES];
	 }];
	
	
	[httpHelper start];
	
}


//清除缓存：主要是图片缓存
-(void)actionWipeCache
{
    NSString *strImgDirPath = [ImgFileMethod getAppDocumentImageDir];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [SVProgressHUD showWithStatus:@"正在清除..."];
        [[NSFileManager defaultManager] removeItemAtPath:strImgDirPath error:nil];
        [NSThread sleepForTimeInterval:1.2];
        [SVProgressHUD dismissWithSuccess:@"清除完成!" afterDelay:1.8];
    });
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

//查询分享的内容
-(void)queryAppSharedInfo_Web
{
    CKHttpHelper *pHttpHelper = [CKHttpHelper httpHelperWithOwner:self];
    pHttpHelper.m_iWebServerType = 1;
    pHttpHelper.methodType = CKHttpMethodTypePost_Page;
    //设置webservice方法名
    [pHttpHelper setMethodName:@"productInfo/toShare"];
    
    //设置结束block（webservice方法结束后，会自动调用）
    [pHttpHelper setCompleteBlock:^(id dataSet)
     {
         [SVProgressHUD dismiss];
         JsonXmlParserObj* pJsonObj = dataSet;
         if(pJsonObj == nil)
         {
             return ;
         }
         
         QDataSetObj* pDataSet = [pJsonObj parsetoDataSet:@""];
         if(pDataSet == nil)
             return;
         NSString* strShareInfo = [pDataSet getFeildValue:0 andColumn:@"shareNotes"];
         if(strShareInfo.length < 1)
             return;
         
         UIImage* pShareImage = [UIImage imageNamed:@"licaiApp.png"];

         MultInfoSharePopView*pShareView = [[MultInfoSharePopView alloc] initWithFrame:CGRectMake(0, 0, 290, 190) andTitle:strShareInfo andContent:strShareInfo andUrl:@"http://www.dingding58.com" andImage:pShareImage];
         pShareView.m_strShareImageUrl = @"http://www.dingding58.com/website/img/logo.png";
         [[KGModal sharedInstance] setCloseButtonType:KGModalCloseButtonTypeNone];
         pShareView.m_pShareDelegate = self;
         [[KGModal sharedInstance] showWithContentView:pShareView andAnimated:YES];
         
     }];
    [pHttpHelper setStartBlock:^{
        [SVProgressHUD showWithStatus:HINT_WEBDATA_LOADING ];
    }];
    //开始连接
    [pHttpHelper start];

}

#pragma StartWeiXinAppPopupViewDelegate

-(void)onEndSelectedStartWeiXinApp:(NSInteger)iSelectedFlag
{
    [[KGModal sharedInstance] hideAnimated:YES];
    if(iSelectedFlag == 1)
        return;
    //打开微信app
    [WXApi openWXApp];
}

#pragma MultInfoSharePopViewDelegate
//点击分享
-(void)onShareButtonClicked:(NSInteger)iShareType andTitile:(NSString *)strTitle andContent:(NSString *)strContent andShareUrl:(NSString *)strShareUrl andImgUrl:(NSString *)strImgUrl
{
    
    [InfoShareMethod sharedInstance].m_pShareDelegate = nil;
    
    [[KGModal sharedInstance] hideAnimated:YES withCompletionBlock:^{
        
        if(iShareType < 1)
            return ;
        
        [[InfoShareMethod sharedInstance] shareToMultPlat:iShareType andTitle:strTitle andContent:strContent andUrl:strShareUrl andImage:strImgUrl];
    }];
    
}

@end
