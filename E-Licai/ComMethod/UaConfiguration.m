//
//  UaConfiguration.m
//  YTSearch
//
//  Created by jiang junchen on 12-10-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UaConfiguration.h"
#import "ImgFileMethod.h"
#import "CKHttpImageHelper.h"
#import "AppInitDataMethod.h"

#define kConfigurationFile @"configurationFile"

@implementation UaConfiguration
@synthesize m_strSoapRequestUrl_1     = _strSoapRequestUrl_1;
@synthesize m_strSoapRequestUrl_2     = _strSoapRequestUrl_2;
@synthesize m_iVersionsCode         = _iVersionCode;
@synthesize m_uiTabCtrl            = _uiTabCtrl;
@synthesize m_uiCurRootCtrl         = _uiCurRootCtrl;
@synthesize m_setCityData           = _setCityData;
@synthesize m_setLoginState         = _setLoginState;

@synthesize m_strApplicationVersion = _strApplicationVersion;
@synthesize m_iCurrentNetType       = _iCurrentNetType;

@synthesize m_fScreenwidth = _fScreenwidth;
@synthesize m_fScreenHeigh = _fScreenHeigh;
@synthesize m_pUserHeadImage = _pUserHeadImage;
@synthesize m_isSwitchUserFlag   = _isSwitchUserFlag;
//@synthesize m_pSwitchCityNavItem = _pSwitchCityNavItem;
@synthesize m_iAppTestOrDisVersion = _iAppTestOrDisVersion;
@synthesize m_iAppUpdateFromType = _iAppUpdateFromType;
@synthesize m_uiBuyCarHintImgView = _uiBuyCarHintImgView;

static UaConfiguration* _pGConfiguration = nil;

-(id)init
{
    self = [super init];
    if (self) {
        [self initGlobalValues];
    }
    return self;
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//获取单例的静态函数
+(UaConfiguration*)sharedInstance
{
    @synchronized(self) {
        if (_pGConfiguration == nil)
        {
            _pGConfiguration = [UaConfiguration initFromFile:kConfigurationFile];
            if (!_pGConfiguration) {
                _pGConfiguration = [[self alloc] init];
            }
            // _pGConfiguration = [[self alloc] init];
        }
    }
    return _pGConfiguration;
}
/*------------------------------------------------------------------------
 Function    :initGlobalValues
 Description :全局的一些数据的初始化操作
 Params      :none
 Result      :void
 Author      :jjc,jiangjunchen@ytinfo.zj.cn
 DateTime    :2012-06-05
 ------------------------------------------------------------------------*/
- (void) initGlobalValues
{

    //1_app store更新;2_网站更新;
    #warning app更新模式为从app store更新
    _iAppUpdateFromType = 1;
    //1_内部测试版本;2_发布的正式版本
    _iAppTestOrDisVersion = 1;

    #warning 现在启用了测试接口，发布需要改回正式接口
    if(_iAppTestOrDisVersion == 1)
    {
//        //测试地址
//        _strSoapRequestUrl_1     = @"http://115.29.248.32:8080";
        //测试地址
        _strSoapRequestUrl_1     = @"http://121.40.252.180:8080";
        
     }
    else
    {
        //正式地址
        _strSoapRequestUrl_1    = @"http://api.dingding58.com";
        
    }

    //优惠劵的webservice url
    _strSoapRequestUrl_2      =  @"";
    _iVersionCode           = 1;
    _iCurrentNetType        = 0;
    if(!_setCityData)
        _setCityData = [[CityDataSet alloc]init];
    if (!_setLoginState)
        _setLoginState = [[LoginStateSet alloc]init];
    
    //当app在后台执行的时候，处理相关事宜
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willTerminate:) name:UIApplicationDidEnterBackgroundNotification object:[UIApplication sharedApplication]];

    _pUserHeadImage =  nil;

    _isSwitchUserFlag =  0;
    //_pSwitchCityNavItem = nil;
    m_iErrorCount = 0;
}

-(void)willTerminate:(NSNotification *)notification
{
    [self saveToFile:kConfigurationFile];
    
}


-(void)setCurRootCtrl:(UIViewController*)rootCtrl
{
    if (rootCtrl) {
        _uiCurRootCtrl = rootCtrl;
    }
}


+(id)initFromFile:(NSString*)strFile
{
    NSArray* arPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if (!arPaths)
        return nil;
    NSString*strDir = [arPaths objectAtIndex:0];
    NSString* filePath = [strDir stringByAppendingPathComponent:strFile];
    NSFileManager *manager = [[NSFileManager alloc]init];
    if(![manager fileExistsAtPath:filePath])
        return nil;
    NSData *data = [[NSData alloc]initWithContentsOfFile:filePath];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
    UaConfiguration *config = [unarchiver decodeObjectForKey:kConfigurationFile];
    [unarchiver finishDecoding];
    
    return config;
}
-(void)saveToFile:(NSString*)strFile
{
    NSArray* arPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSAssert(arPaths, @"Directory Path not exist!");
    NSString*strDir = [arPaths objectAtIndex:0];
    NSString* filePath = [strDir stringByAppendingPathComponent:strFile];
    NSMutableData *data = [[NSMutableData alloc]init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    [archiver encodeObject:self forKey:kConfigurationFile];
    [archiver finishEncoding];
    [data writeToFile:filePath atomically:YES];
}


#pragma mark -static function
+(NSString*)getPlistPath
{
    NSArray *storeFilePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *doucumentsDirectiory = [storeFilePath objectAtIndex:0];
    NSString *plistPath =[doucumentsDirectiory stringByAppendingPathComponent:@"DZHYList.plist"];       //根据需要更改文件名
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if( [fileManager fileExistsAtPath:plistPath]== NO ) {
        NSError *error;
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"DZHYList" ofType:@"plist"];
        [fileManager copyItemAtPath:bundle toPath:plistPath error:&error];
    }
    return plistPath;
}

//用于时间格式转换
+(NSString *)getTimeStringWith:(NSString *)string{
    
    NSMutableString *mstring = [NSMutableString stringWithString:string];
    NSRange wholeShebang = NSMakeRange(0, [mstring length]);
    [mstring replaceOccurrencesOfString:@"T" withString:@" " options:0 range:wholeShebang];
    //遍历字符串中的每一个字符
    NSLog(@"%@",mstring);
    int count = [mstring length];
    int rltLen = 0;
    for(int i =0; i < count; i++)
    {
        char c = [mstring characterAtIndex:i];
        if(c == '.' || c == '+')
        {
            rltLen = i;
            break;
        }
    }
    if(rltLen != 0)
    {
        wholeShebang = NSMakeRange(0, rltLen);
        return [mstring substringWithRange:wholeShebang];
    }
    NSLog(@"%@",mstring);
    return mstring;
}

#pragma NSCoding delegate and NSCopying delegate
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_setLoginState forKey:@"_setLoginState"];
    [aCoder encodeObject:_setCityData forKey:@"_setCityData"];
    NSLog(@"_strApplicationVersion=%@",_strApplicationVersion);
    [aCoder encodeObject:_strApplicationVersion forKey:@"_strApplicationVersion"];
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.m_setLoginState = [aDecoder decodeObjectForKey:@"_setLoginState"];
        self.m_setCityData = [aDecoder decodeObjectForKey:@"_setCityData"];
        self.m_strApplicationVersion = 0;
        
        NSString *version = [aDecoder decodeObjectForKey:@"_strApplicationVersion"];
        if (version) {
            self.m_strApplicationVersion = version;
        }
        [self initGlobalValues];
    }
    return self;
}
-(id)copyWithZone:(NSZone *)zone
{
    UaConfiguration *copy = [[[self class] allocWithZone:zone] init];
    copy.m_setLoginState = [_setLoginState copy];
    copy.m_setCityData = [_setCityData copy];
    copy.m_strApplicationVersion = self.m_strApplicationVersion;
    return copy;
}


//设置不同网络时，是否需要下载图片
-(void)setPhoneNetAndImageDownFlag
{
    //int iCurrentNetType = 0;
    //int iIsNeedDownImageFlag = 0;
    
    if(!_setLoginState)
        return;
/*
    //没有wifi是否需要下载图片
    int iWifiFlag = _setLoginState.m_iNeedDownImageNotWifi;
    if(iWifiFlag == 1)
    {
        [CKHttpImageHelper setIsNeedDownImageFlag:1];
        return ;
    }
    if(_iCurrentNetType == 0)
    {
        Reachability *reachability = [Reachability reachabilityWithHostname:@"www.aapple.com"];
        switch ([reachability currentReachabilityStatus])
        {
            case ReachableViaWWAN:
                NSLog(@"WWAN");
                _iCurrentNetType = 2;
                break;
                
            case ReachableViaWiFi:
                _iCurrentNetType = 1;
                break;
            default:
                _iCurrentNetType = 2;
                break;
        }
    }
    int iDownFlag =1;
    if(_iCurrentNetType == 2)
        iDownFlag = 0;
    //设置是否需要下载图片1_需要下载;0_需要下载;
    [CKHttpImageHelper setIsNeedDownImageFlag:iDownFlag];
*/
}

//判断用户是否已经登录
-(BOOL)userIsHaveLoadinSystem
{

    bool blIn =  [[UaConfiguration sharedInstance].m_setLoginState isHaveLoadInSystem];
    
    return blIn;
}

//与服务端交互，获取推送消息
-(void)reportPushMessageToServer
{
    
    
    NSString *strUserName = @"";
    if([self userIsHaveLoadinSystem] == YES)
    {
        strUserName =  [UaConfiguration sharedInstance].m_setLoginState.m_strUserLoginName;
       // [UaConfiguration sharedInstance].m_setLoginState.m_strUserLoginName
    }
    NSInteger iMemberType = 0;
    if(strUserName.length > 0)
        iMemberType = 1;
    
    CKHttpHelper *httpHelper = [CKHttpHelper httpHelperWithOwner:self];
    [httpHelper setMethodName:@"getPushMsg2"];
   // [httpHelper addParam:[NSString stringWithFormat:@"%lf",_coordinate2D.longitude] forName:@"longitude"];
  //  [httpHelper addParam:[NSString stringWithFormat:@"%lf",_coordinate2D.latitude] forName:@"latitude"];
    [httpHelper addParam:strUserName forName:@"username"];
    [httpHelper addParam:[NSString stringWithFormat:@"%d",iMemberType] forName:@"memberType"];
    [httpHelper addParam:[UaConfiguration sharedInstance].m_setCityData.m_strProvinceID forName:@"provinceID"];
    
    [httpHelper setCompleteBlock:^(id data)
     {
         if(data == nil)
         {
             NSLog(@"push message is error!");
             return ;
         }
         
         QDataSetObj* dataSet = data;
         int iRowCount = [dataSet getRowCount];
         if(iRowCount < 1)
         {
             NSLog(@"push message is null!");
             return;
         }
         //NSString* strMsgID = [dataSet getFeildValue:0 andColumn:@"msgID"];
         NSString* strContent = [dataSet getFeildValue:0 andColumn:@"content"];
         NSString* strTitle = [dataSet getFeildValue:0 andColumn:@"msgTitle"];
         if(strContent.length < 1)
             return;
		 if(![strTitle isEqual:@""])
		 {
             UILocalNotification *localNotif = [[UILocalNotification alloc]init];
             if (localNotif ==nil)
             {
                 return;
             }
             NSDate *now =[NSDate new];
             localNotif.fireDate = [now  dateByAddingTimeInterval:5.0];
             localNotif.timeZone = [NSTimeZone defaultTimeZone];
             localNotif.alertBody = strContent;
             localNotif.soundName = UILocalNotificationDefaultSoundName;
             localNotif.applicationIconBadgeNumber = 1;
             NSDictionary *infoDic = [NSDictionary dictionaryWithObject:@"someValue" forKey:@"someKey"];
             localNotif.userInfo = infoDic;
		 
             [[UIApplication sharedApplication]scheduleLocalNotification:localNotif];
		 
             MPNotificationView *notification = [MPNotificationView notifyWithText:strTitle andDetail:nil];
             notification.delegate =self;
		 }
         
     }];
    [httpHelper start];
}


//获取应用程序的一些初始化数据
-(void)initAppDataFromWeb
{
  //  AppInitDataMethod* pInitMethod = [[AppInitDataMethod alloc] init];
  //  [pInitMethod initExpreeEnters];
}


//设置tabbar上购物车的红色提醒
/*
-(void)setTabBarBuyCarRedHint:(NSInteger)iNewCount
{
    if(_uiBuyCarHintImgView == nil)
        return;
    if(_uiBuyCarHintLabel == nil)
        return;
    if(iNewCount < 1)
    {
        [_uiBuyCarHintImgView setHidden:YES];
        [_uiBuyCarHintLabel setHidden:YES];
        return;
    }
    [_uiBuyCarHintImgView setHidden:NO];
    [_uiBuyCarHintLabel setHidden:NO];
    
    NSString* strCount = [NSString stringWithFormat:@"%d",iNewCount];
    if(strCount.length > 2)
    {
        strCount = @"99+";
        _uiBuyCarHintLabel.font = [UIFont systemFontOfSize:10];
    }
    else
    {
        _uiBuyCarHintLabel.font = [UIFont systemFontOfSize:12];
    }
    _uiBuyCarHintLabel.text = strCount;
    
}
*/



@end
