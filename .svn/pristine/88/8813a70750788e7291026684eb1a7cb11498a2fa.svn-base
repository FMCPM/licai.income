//
//  EYpAppDelegate.m
//  E-YellowPage
//
//  Created by lzq on 12-12-21.
//  Copyright (c) 2012年 ytinfo. All rights reserved.
//

#import "EAppDelegate.h"
#import "UaConfiguration.h"
#import "CustomCategory.h"
#import "CKKit.h"
#import "BTCustomTabBarController.h"
#import "HomeViewController.h"
#import "GlobalDefine.h"
#import "PrettyNavigationBar.h"
#import "CKHttpHelper.h"
#import "HomeViewController.h"
#import "ProductListViewController.h"
#import "MoreViewController.h"
#import "WebserviceParser.h"
#import "InComeMngHomePageView.h"
#import "XGPush.h"
#import "XGSetting.h"
#import <ShareSDK/ShareSDK.h>
#import "WeiboSDK.h"


//sharesdk官网申请的appid
#define SHARESDP_APP_ID @"53b220d305d3"

//微信(理财)
#define WECHAT_APP_ID @"wx6396b3112dc63088"
#define WECHAT_APP_KEY @"7da040e7219e0d125474c9a9da37789a"


//qq平台（理财，需要申请）
#define QQ_APP_ID @"1104236934"
#define QQ_APP_KEY @"Q8g8SwdJGe3pvifh"

//腾讯微博
#define TENCENT_APP_ID @""
#define TENCENT_APP_KEY @""

//新浪微博(理财，需要申请)
#define SINA_APP_ID @"1708358465"
#define SINA_APP_KEY @"5c9ff5fef1ca5a62d725a9f0d404dca5"



@implementation EAppDelegate


@synthesize window          = _window;
@synthesize m_appTabBarController = _appTabBarController;



-(void)initStartView
{

    //#warning 测试的时候为YES，正式发布需要改为NO
    BOOL startGuidePage = NO;
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
    
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    //获取app的version
    NSString *version = [dic objectForKey:@"CFBundleShortVersionString"];
    if(version.length > 0)
    {
        [UaConfiguration sharedInstance].m_strApplicationVersion = version;
    }
    //必须版本升级的时候，才能启动引导页
    if (version && [version compare:[UaConfiguration sharedInstance].m_strApplicationVersion] == NSOrderedDescending )
    {
        startGuidePage = YES;
    }
    //启动引导页
    if (startGuidePage)
    {
        if([[UIDevice currentDevice]systemVersion].intValue<7)
        {
            [[UIApplication sharedApplication] setStatusBarHidden:YES ];
        }
        //STEP 1 Construct Panels
        MYIntroductionPanel *panel1 = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"startImg1.png"] description:@""];
        MYIntroductionPanel *panel2 = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"startImg2.png"] description:@""];
        /*
        MYIntroductionPanel *panel3 = [[MYIntroductionPanel alloc]
                                       initWithimage:[UIImage imageNamed:@"startImg3"] description:@""];
        MYIntroductionPanel *panel4 = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"startImg4"] description:@""];*/
        //You may also add in a title for each panel
        
        CGRect frame = [UIApplication sharedApplication].keyWindow.bounds;
        MYIntroductionView *introductionView = [[MYIntroductionView alloc]initWithFrame:frame panels:@[panel1, panel2] languageDirection:MYLanguageDirectionLeftToRight];
        //可以设置背景图片、也可以是背景色
        //[introductionView setBackgroundImage:[UIImage imageNamed:@"startbg"]];
        introductionView.backgroundColor = [UIColor whiteColor];
        introductionView.delegate = self;
		
        [introductionView showInView:[UIApplication sharedApplication].keyWindow];
    }
}

//ios版本以上的推送消息的注册方法
- (void)registerPushForIOS8{
    
    
    //Types
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    
    //Actions
    UIMutableUserNotificationAction *acceptAction = [[UIMutableUserNotificationAction alloc] init];
    
    acceptAction.identifier = @"ACCEPT_IDENTIFIER";
    acceptAction.title = @"Accept";
    
    acceptAction.activationMode = UIUserNotificationActivationModeForeground;
    acceptAction.destructive = NO;
    acceptAction.authenticationRequired = NO;
    
    //Categories
    UIMutableUserNotificationCategory *inviteCategory = [[UIMutableUserNotificationCategory alloc] init];
    
    inviteCategory.identifier = @"INVITE_CATEGORY";
    
    [inviteCategory setActions:@[acceptAction] forContext:UIUserNotificationActionContextDefault];
    
    [inviteCategory setActions:@[acceptAction] forContext:UIUserNotificationActionContextMinimal];
    
    NSSet *categories = [NSSet setWithObjects:inviteCategory, nil];
    
    
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:categories];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
}

//ios8.0以下的推销消息注册方法
- (void)registerPush{
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
}


//腾讯信鸽推送初始化设置
-(void)initTencentXgPush:(NSDictionary *)launchOptions
{
    //ACCESS ID:2100075512,ACCESS KEY:AG1U6M56K5MN
    [XGPush startApp:2100075512 appKey:@"AG1U6M56K5MN"];
    
    //注销之后需要再次注册前的准备
    void (^successCallback)(void) = ^(void){
        //如果变成需要注册状态
        if(![XGPush isUnRegisterStatus])
        {
            float fSysVer = [[[UIDevice currentDevice] systemVersion] floatValue];
            if(fSysVer < 8){
                [self registerPush];
            }
            else{
                [self registerPushForIOS8];
            }
            
        }
    };
    [XGPush initForReregister:successCallback];
    
    //   [XGPush registerPush];  //注册Push服务，注册后才能收到推送
    
    //设置推送别名，可以根据别名进行推送
    if([UaConfiguration sharedInstance].m_setLoginState.m_strUserLoginName.length > 0)
    {
         [XGPush setAccount:[UaConfiguration sharedInstance].m_setLoginState.m_strUserLoginName];
         NSLog(@"XGPush setAccount %@",[UaConfiguration sharedInstance].m_setLoginState.m_strUserLoginName);
    }
    
    //推送反馈(app不在前台运行时，点击推送激活时)
    //[XGPush handleLaunching:launchOptions];
    
    //推送反馈回调版本示例
    void (^successBlock)(void) = ^(void){
        //成功之后的处理
        NSLog(@"[XGPush]handleLaunching's successBlock");
    };
    
    void (^errorBlock)(void) = ^(void){
        //失败之后的处理
        NSLog(@"[XGPush]handleLaunching's errorBlock");
    };
    
    //角标清0
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    //清除所有通知(包含本地通知)
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    //
    [XGPush handleLaunching:launchOptions successCallback:successBlock errorCallback:errorBlock];
    
    //本地推送示例
  /*
     NSDate *fireDate = [[NSDate new] dateByAddingTimeInterval:10];
     
     NSMutableDictionary *dicUserInfo = [[NSMutableDictionary alloc] init];
     [dicUserInfo setValue:@"myid" forKey:@"clockID"];
     NSDictionary *userInfo = dicUserInfo;
     
     [XGPush localNotification:fireDate alertBody:@"测试本地推送" badge:2 alertAction:@"确定" userInfo:userInfo];
    */
}



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    if([[[UIDevice currentDevice] systemVersion]floatValue] >= 7.0)
    {
        NSLog(@"ios version > 7.0");

        self.window.clipsToBounds = YES;
        self.window.frame = CGRectMake(0, 20, self.window.frame.size.width, self.window.frame.size.height-20);
		
    }
    //创建全局对象实例
    [UaConfiguration sharedInstance];
    //检测是否在不是wifi的情况下，下载图片（可以根据需要开发此项功能）
    [[UaConfiguration sharedInstance] setPhoneNetAndImageDownFlag];
    
    //初始化http基本设置
    [self initGlobalHttpHelper];
    //腾讯信鸽推送设置推送
    [self initTencentXgPush:launchOptions];
    //初始化分享库(还未申请，暂时屏蔽)
    [self initShareSdkInfo];
    
/*
    if(IS_IPHONE_5)
    {
        [UaConfiguration sharedInstance].m_fScreenHeigh = 548;
    }else
    {
        [UaConfiguration sharedInstance].m_fScreenHeigh = 460;
    }
*/
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];//[UIColor colorWithRed:0xf8/255.0 green:0xf8/255.0 blue:0xf8/255.0 alpha:1.00f];
        
    [self initAppTabBarController];
    
    [UaConfiguration sharedInstance].m_uiTabCtrl = _appTabBarController;
    self.window.rootViewController = _appTabBarController;

    [self.window makeKeyAndVisible];
    //[self.window makeKeyWindow];
    [self initStartView];
    

    
    return YES;
}

//初始化设置ShareSdk
-(void)initShareSdkInfo
{
    //shareSdk初始化设置，现在是测试的appkey
    [ShareSDK registerApp:SHARESDP_APP_ID];
    
    //一、添加微信应用，包括微信朋友圈：连接微信应用以使用相关功能，此应用需要引用WeChatConnection.framework和微信官方SDKhttp://open.weixin.qq.com上注册应用
    [ShareSDK connectWeChatWithAppId:WECHAT_APP_ID wechatCls:[WXApi class]];
    //demo测试账号
    /*
    [ShareSDK connectWeChatWithAppId:@"wx4868b35061f87885"
                           appSecret:@"64020361b8ec4c99936c0e3999a9f249"
                           wechatCls:[WXApi class]];
     */
    //二、添加QQ应用  注册网址  http://open.qq.com/
   [ShareSDK connectQQWithQZoneAppKey:QQ_APP_ID
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];

    //demo测试账号
    /*
    [ShareSDK connectQQWithQZoneAppKey:@"100371282"
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];
    */
    //二、qq空间：此应用需要引用QZoneConnection.framework，http://connect.qq.com/intro/login/上申请加入QQ登录
    /*
    [ShareSDK connectQZoneWithAppKey:QQ_APP_ID
                           appSecret:QQ_APP_KEY
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    
    
    
    //三、腾讯微博开放平台应用以使用相关功能，此应用需要引用TencentWeiboConnection.frameworkhttp://dev.t.qq.com上注册腾讯微博开放平台应用
    [ShareSDK connectTencentWeiboWithAppKey:TENCENT_APP_ID
                                  appSecret:TENCENT_APP_KEY
                                redirectUri:@"http://www.sjq.cn"
                                   wbApiCls:[WeiboApi class]];
    */

    
    
    //三、新浪微博开放平台应用以使用相关功能，此应用需要引用SinaWeiboConnection.frameworkhttp://open.weibo.com上注册新浪微博开放平台应用

    [ShareSDK connectSinaWeiboWithAppKey:SINA_APP_ID
                               appSecret:SINA_APP_KEY
                             redirectUri:@"http://www.dingding58.com"];

    //新浪demo测试账号
    /*
    [ShareSDK connectSinaWeiboWithAppKey:@"568898243"
                               appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
                             redirectUri:@"http://www.sharesdk.cn"];*/
    //当使用新浪微博客户端分享的时候需要按照下面的方法来初始化新浪的平台
 /*
    [ShareSDK  connectSinaWeiboWithAppKey:SINA_APP_ID
                                appSecret:SINA_APP_KEY
                              redirectUri:@"www.dingding58.com"
                              weiboSDKCls:[WeiboSDK class]];
 */
    //监听用户信息变更
    [ShareSDK addNotificationWithName:SSN_USER_INFO_UPDATE
                               target:self
                               action:@selector(userInfoUpdateHandler:)];
}


//将deviceToken保存到应用服务器数据库中，添加相关的代码
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    
    NSString * deviceTokenStr = [XGPush registerDevice:deviceToken];
    
    void (^successBlock)(void) = ^(void){
        //成功之后的处理
        NSLog(@"[XGPush]register successBlock ,deviceToken: %@",deviceTokenStr);
        
    };
    
    void (^errorBlock)(void) = ^(void){
        //失败之后的处理
        NSLog(@"[XGPush]register errorBlock");
    };
    
    //注册设备
    [[XGSetting getInstance] setChannel:@"appstore"];
    [[XGSetting getInstance] setGameServer:@"叮叮理财"];
    [XGPush registerDevice:deviceToken successCallback:successBlock errorCallback:errorBlock];
    
    //如果不需要回调
    //[XGPush registerDevice:deviceToken];
    
    //打印获取的deviceToken的字符串
    NSLog(@"deviceTokenStr is %@",deviceTokenStr);
}

//注册推送失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"Regist fail%@",[error description]);
}


//收到本地推送消息
-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    /*
    UIApplicationState state = [application applicationState];
    if (state != UIApplicationStateActive)
    {
        NSLog(@"Recieved Notification %@",notification);
    }
     */
    NSDictionary* userInfo = notification.userInfo;
    [self handlePushMessage:userInfo];
}

//处理收到apns服务端推送过来的消息
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{

    // 可选，推送反馈（通知信鸽）
    [XGPush handleReceiveNotification:userInfo];
    
    //清除本地的消息
    [XGPush clearLocalNotifications];
    
    //
    [self handlePushMessage:userInfo];
}



//处理推送消息，暂时就弹出这个提示框
-(void) handlePushMessage:(NSDictionary *)userInfo
{
    NSDictionary *dictAps = [userInfo objectForKey:@"aps"];
    if(dictAps == nil)
        return;
    NSString* strMessage =  [dictAps objectForKey:@"alert"];
    UIAlertView* pAlterView = [[UIAlertView alloc] initWithTitle:@"车主生活" message:strMessage delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [pAlterView show];
    
    /*
    if (m_PushUserInfo == nil || m_PushUserInfo.count < 1)
        return ;
    
    NSDictionary *dictData = [m_PushUserInfo objectForKey:@"data"];
    NSDictionary *dictAps = [m_PushUserInfo objectForKey:@"aps"];
    NSString* strTitle = dictAps == nil ? nil : [dictAps objectForKey:@"alert"];
    NSString* strBadge = dictAps == nil ? nil : [dictAps objectForKey:@"badge"];
    NSInteger iBadge = strBadge.intValue;
    application.applicationIconBadgeNumber -= iBadge;
    
    NSString *strType = [dictData objectForKey:@"type"];
    NSString *strId = [dictData objectForKey:@"id"];
    NSString *strWapUrl = [dictData objectForKey:@"url"];
    
    int iType = [QDataSetObj convertToInt:strType];
    switch (iType)
    {
        case 1://商品
        {
            GoodDetailInfoPageView *pDetailView =  [[GoodDetailInfoPageView alloc]init];
            pDetailView.m_strGoodID = strId;
            pDetailView.m_iUserFlag = BUYER_FLAG_ID;//买家
            pDetailView.hidesBottomBarWhenPushed =YES;
            UIViewController *curViewController = [[UaConfiguration sharedInstance] m_uiCurRootCtrl];
            [curViewController.navigationController pushViewController:pDetailView animated:YES];
            break;
        }
            
        case 2:// 店铺
        {
            SjqShopGoodsListPageView* pShopView = [[SjqShopGoodsListPageView alloc] init];
            pShopView.hidesBottomBarWhenPushed = YES;
            pShopView.m_strStoreId =  strId;
            
            UIViewController *curViewController = [[UaConfiguration sharedInstance] m_uiCurRootCtrl];
            [curViewController.navigationController pushViewController:pShopView animated:YES];
            
            break;
        }
            
        case 3: //链接
        {
            WebViewController* pWebView = [[WebViewController alloc] init];
            pWebView.m_MainUrlStr = strWapUrl;
            pWebView.hidesBottomBarWhenPushed = YES;
            
            UIViewController *curViewController = [[UaConfiguration sharedInstance] m_uiCurRootCtrl];
            [curViewController.navigationController pushViewController:pWebView animated:YES];
            
            break;
        }
            
        case 4://内部消息
        {
            //处理推送消息
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"通知" message:strTitle delegate:self  cancelButtonTitle:@"我知道了" otherButtonTitles:nil,nil];
            [alert show];
            
            break;
        }
            
        default:
            break;
    }
    m_PushUserInfo = nil;
     */
}


//初始化网络环境设置
-(void)initGlobalHttpHelper
{
    
    CALayer* splashLayer = [CALayer layer];
    splashLayer.frame = [UIScreen mainScreen].applicationFrame;
    
    if (splashLayer.frame.size.height > 480)
    {
       // [UaConfiguration sharedInstance].m_iPhoneDeviceVersion = 5;
    }
    /*测试网络环境
    CKNetworkTestHelper* pTestHelper = [[CKNetworkTestHelper alloc] init];
    
    [pTestHelper setNetTestCompleteBlock:^(id strInUseUrl)
     {
         if(strInUseUrl != nil)
         {
             NSLog(@"current inuse service is %@",strInUseUrl);
             NSURL* nsInUseUrl = [[NSURL alloc] initWithString:strInUseUrl];
             [CKHttpHelper setBaseUrl:nsInUseUrl andUrl2:nil];
             [UaConfiguration sharedInstance].m_strSoapRequestUrl_1 = strInUseUrl;
         }
         else
         {
             [SVProgressHUD showErrorWithStatus:@"当前没有可用的服务，请稍后重试！" duration:1.5];
         }
         
     }];
    [pTestHelper startTest];*/
    
    NSString *strUrl1 = [UaConfiguration sharedInstance].m_strSoapRequestUrl_1;
    NSURL *nsSoapUrl1 = [NSURL URLWithString:strUrl1];
    
    NSString *strUrl2 = [UaConfiguration sharedInstance].m_strSoapRequestUrl_2;
    NSURL *nsSoapUrl2 = [NSURL URLWithString:strUrl2];
    // 缓存的最大内存空间:    20M
    // 最大本地存储空间:     200M
    // 存储地址:         默认地址
    // 保存时间:         一个星期
    CKUrlCache *urlCache = [[CKUrlCache alloc] initWithMemoryCapacity:20 * 1024 * 1024
                                                         diskCapacity:200 * 1024 * 1024
                                                             diskPath:nil
                                                            cacheTime:60*60*24*7];
    
    //设置默认url地址
    [CKHttpHelper setBaseUrl:nsSoapUrl1 andUrl2:nsSoapUrl2];
    //设置默认缓存
    [CKHttpHelper setCache:urlCache];
    //设置默认超时时间
    [CKHttpHelper setTimeout:30];
    //设置默认请求方式为soap
    [CKHttpHelper setHttpMethodType:CKHttpMethodTypeSoap];
    //设置默认解析返回数据的block
    [CKHttpHelper setParserBlock:^id(NSData *webData) {
        WebserviceParser *parser = [[WebserviceParser alloc]init];
        return [parser ParserData_Json:webData];
    }];
    //设置默认处理连接错误的block
    [CKHttpHelper setFailureBlock:^(NSError *error) {
        NSString *strErr = error.description;
        NSLog(@"%@",strErr);
        //   [[TKAlertCenter defaultCenter] postAlertWithMessage:strErr];
    }];
    
    //获取快递公司、订单取消原因、退款原因
 //   AppInitDataMethod* pInitMethod = [[AppInitDataMethod alloc] init];
 //   [pInitMethod initExpreeEnters];
}



//初始化百度云统计
-(void)initBaiduMobInfo
{
    /*
    BaiduMobStat* statTracker = [BaiduMobStat defaultStat];
    statTracker.enableExceptionLog = YES; // 是否允许截获并发送崩溃信息，请设置YES或者NO
    statTracker.channelId = @"";//设置您的app的发布渠道
    statTracker.logStrategy = BaiduMobStatLogStrategyAppLaunch;//根据开发者设定的时间间隔接口发送 也可以使用启动时发送策略
    statTracker.enableDebugOn = YES; //打开调试模式，发布时请去除此行代码或者设置为False即可。
    //    statTracker.logSendInterval = 1; //为1时表示发送日志的时间间隔为1小时,只有 statTracker.logStrategy = BaiduMobStatLogStrategyAppLaunch这时才生效。
    statTracker.logSendWifiOnly = NO; //是否仅在WIfi情况下发送日志数据
    statTracker.sessionResumeInterval = 1;//设置应用进入后台再回到前台为同一次session的间隔时间[0~600s],超过600s则设为600s，默认为30s
    
    NSString *adId = @"";
    
    //if([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0f){
    //    adId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
   // }
    
    statTracker.adid = adId;
    //设置您在mtj网站上添加的app的appkey
    [statTracker startWithAppId:@"3cfc356892"];
     */
}



/*---------------------------------------------------------------------------
 Function   :initAppTabBarController
 Description:初始化生成整个APP的TabBarController控件
 Params     :none
 Result     :void
 Author     :lzq,lvzhuqiang@ytinfo.zj.cn
 DateTime   :2013-06-25
 ---------------------------------------------------------------------------*/
- (void)initAppTabBarController
{
    
    
    NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
    
    //加载首页
    HomeViewController *pHomeViewController = [[HomeViewController alloc] init];
    
    UINavigationController *pHomeNavController = [[UINavigationController alloc]initWithNavigationBarClass:[PrettyNavigationBar class] rootViewController:pHomeViewController];

    pHomeNavController.tabBarItem.title = NSLocalizedString(@"首页", nil);
    pHomeNavController.tabBarItem.image = IMG_WITH_ARG(@"Tab_Home");
    [viewControllers addObject:pHomeNavController];
    
    
    
   //加载产品
    ProductListViewController* pProductViewController = [[ProductListViewController alloc] init];
    UINavigationController *pProductNavController = [[UINavigationController alloc]initWithNavigationBarClass:[PrettyNavigationBar class] rootViewController:pProductViewController];
    
    pProductViewController.tabBarItem.title = NSLocalizedString(@"产品", nil);
    pProductViewController.tabBarItem.image = IMG_WITH_ARG(@"Tab_ProductList");
    [viewControllers addObject:pProductNavController];
    
    //收入
    InComeMngHomePageView* pInComeViewController = [[InComeMngHomePageView alloc] init];
    UINavigationController *pInComeNavController = [[UINavigationController alloc]initWithNavigationBarClass:[PrettyNavigationBar class] rootViewController:pInComeViewController];
    
    pInComeViewController.tabBarItem.title = NSLocalizedString(@"我的叮叮", nil);
    pInComeViewController.tabBarItem.image = IMG_WITH_ARG(@"Tab_Money");
    [viewControllers addObject:pInComeNavController];
    
    
    //更多
    MoreViewController* pMoreViewController = [[MoreViewController alloc] init];
    UINavigationController *pMoreNavController = [[UINavigationController alloc]initWithNavigationBarClass:[PrettyNavigationBar class] rootViewController:pMoreViewController];
    
    pMoreViewController.tabBarItem.title = NSLocalizedString(@"更多", nil);
    pMoreViewController.tabBarItem.image = IMG_WITH_ARG(@"Tab_MyCenter");
    [viewControllers addObject:pMoreNavController];
        
    _appTabBarController = [[BTCustomTabBarController alloc] init];
    
    _appTabBarController.m_nsHigleImageNameList = [[NSArray alloc] initWithObjects:@"Tab_Home_h@2x",@"Tab_ProductList_h@2x",@"Tab_Money_h@2x",@"Tab_MyCenter_h@2x",nil];
    
    _appTabBarController.viewControllers = viewControllers;
    
    //设置导航条UIBarButtonItem
    if(SYSTEM_VESION >= 7.0)
    {
        [[UIBarButtonItem appearance] setBackgroundImage: [UIImage new]                                                forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        
        NSDictionary* textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIColor blackColor],UITextAttributeTextColor,
                                    [UIFont boldSystemFontOfSize:14],UITextAttributeFont,
                                    [UIColor clearColor],UITextAttributeTextShadowColor,
                                    [NSValue valueWithCGSize:CGSizeMake(1, 1)],UITextAttributeTextShadowOffset,
                                    nil];
    
        [[UIBarButtonItem appearance] setTitleTextAttributes:textAttributes forState:0];
    }
    
}

#pragma mark - PPRevealSideViewController delegate

- (PPRevealSideDirection)pprevealSideViewController:(PPRevealSideViewController*)controller directionsAllowedForPanningOnView:(UIView*)view {
    return PPRevealSideDirectionLeft;
}

// 将要进入后台
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    NSLog(@"applicationWillResignActive");
}

//进入后台后的相关事件处理
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSLog(@"applicationDidEnterBackground");
}

//恢复前台运行的事件处理
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    NSLog(@"applicationWillEnterForeground");
    //[self StartUserSidUpdateTimer:1];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    if (application.applicationIconBadgeNumber != 0)
    {
        application.applicationIconBadgeNumber = 0;
        //[self callBackPushMsgReadCount:application];
    }
}

//将要终止程序前的相关处理
- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.

}

#pragma mark - MYIntroductionDelegate delegate

-(void)introductionDidFinishWithType:(MYFinishType)finishType{
    if (finishType == MYFinishTypeSkipButton)
    {
        
    }
    else if (finishType == MYFinishTypeSwipeOut)
    {

    }
    if([[UIDevice currentDevice]systemVersion].intValue < 7)
    {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
    }
}

-(void)introductionDidChangeToPanel:(MYIntroductionPanel *)panel withIndex:(NSInteger)panelIndex{

}

//
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    /*
    bool blAliPay = [[FeePayComMethod sharedInstance] handleAlipayUrl:url];
    if(blAliPay == true)
        return true;
    */
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
   
  
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}

//
-(void)passPageMove:(NSInteger)iPageID andFlag:(NSInteger)iMoveFlag
{
    iPageID++;
    [_appTabBarController setSelectedIndex:iPageID];
}


//监听用户信息变更
- (void)userInfoUpdateHandler:(NSNotification *)notif
{
    NSMutableArray *authList = [NSMutableArray arrayWithContentsOfFile:[NSString stringWithFormat:@"%@/authListCache.plist",NSTemporaryDirectory()]];
    if (authList == nil)
    {
        authList = [NSMutableArray array];
    }
    
    NSString *platName = nil;
    NSInteger plat = [[[notif userInfo] objectForKey:SSK_PLAT] integerValue];
    switch (plat)
    {
        case ShareTypeSinaWeibo:
            platName = NSLocalizedString(@"TEXT_SINA_WEIBO", @"新浪微博");
            break;
        case ShareType163Weibo:
            platName = NSLocalizedString(@"TEXT_NETEASE_WEIBO", @"网易微博");
            break;
        case ShareTypeDouBan:
            platName = NSLocalizedString(@"TEXT_DOUBAN", @"豆瓣");
            break;
        case ShareTypeFacebook:
            platName = @"Facebook";
            break;
        case ShareTypeKaixin:
            platName = NSLocalizedString(@"TEXT_KAIXIN", @"开心网");
            break;
        case ShareTypeQQSpace:
            platName = NSLocalizedString(@"TEXT_QZONE", @"QQ空间");
            break;
        case ShareTypeRenren:
            platName = NSLocalizedString(@"TEXT_RENREN", @"人人网");
            break;
        case ShareTypeSohuWeibo:
            platName = NSLocalizedString(@"TEXT_SOHO_WEIBO", @"搜狐微博");
            break;
        case ShareTypeTencentWeibo:
            platName = NSLocalizedString(@"TEXT_TENCENT_WEIBO", @"腾讯微博");
            break;
        case ShareTypeTwitter:
            platName = @"Twitter";
            break;
        case ShareTypeInstapaper:
            platName = @"Instapaper";
            break;
        case ShareTypeYouDaoNote:
            platName = NSLocalizedString(@"TEXT_YOUDAO_NOTE", @"有道云笔记");
            break;
        case ShareTypeGooglePlus:
            platName = @"Google+";
            break;
        case ShareTypeLinkedIn:
            platName = @"LinkedIn";
            break;
        default:
            platName = NSLocalizedString(@"TEXT_UNKNOWN", @"未知");
    }
    
    id<ISSPlatformUser> userInfo = [[notif userInfo] objectForKey:SSK_USER_INFO];
    BOOL hasExists = NO;
    for (int i = 0; i < [authList count]; i++)
    {
        NSMutableDictionary *item = [authList objectAtIndex:i];
        ShareType type = [[item objectForKey:@"type"] integerValue];
        if (type == plat)
        {
            [item setObject:[userInfo nickname] forKey:@"username"];
            hasExists = YES;
            break;
        }
    }
    
    if (!hasExists)
    {
        NSDictionary *newItem = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 platName,
                                 @"title",
                                 [NSNumber numberWithInteger:plat],
                                 @"type",
                                 [userInfo nickname],
                                 @"username",
                                 nil];
        [authList addObject:newItem];
    }
    
    [authList writeToFile:[NSString stringWithFormat:@"%@/authListCache.plist",NSTemporaryDirectory()] atomically:YES];
}

@end


