//
//  UaConfiguration.h
//  YTSearch
//
//  Created by jiang junchen on 12-10-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CustomDataSet.h"
#import "SQLLiteDBManager.h"
#import "HomeViewController.h"
#import "BTCustomTabBarController.h"
#import "MPNotificationView.h"
#import "GlobalDefine.h"

@interface UaConfiguration : NSObject<NSCoding,NSCopying,MPNotificationViewDelegate>
{

    __weak UIViewController *_uiCurRootCtrl;
    int       m_iErrorCount;
}
//Webservice的服务器地址
@property (strong, nonatomic) NSString      *m_strSoapRequestUrl_1;
@property (strong, nonatomic) NSString      *m_strSoapRequestUrl_2;
//版本：1大众版，2：地方版
@property (assign, nonatomic) NSInteger     m_iVersionsCode;
@property (strong, nonatomic) NSString      *m_strApplicationVersion;
//系统主页的对象指针
@property (strong, nonatomic) BTCustomTabBarController *m_uiTabCtrl;

@property (weak,readonly, nonatomic) UIViewController *m_uiCurRootCtrl;

//当前城市信息数据集
@property (strong, nonatomic) CityDataSet *m_setCityData;
//当前登录状态数据集
@property (strong, nonatomic) LoginStateSet *m_setLoginState;
//记录当前的网络类型：gprs和wifi
@property (assign, nonatomic) NSInteger     m_iCurrentNetType;
//屏幕尺寸
@property (assign, nonatomic) float     m_fScreenwidth;
@property (assign, nonatomic) float     m_fScreenHeigh;
@property (strong, nonatomic) UIImage*  m_pUserHeadImage;

//用于标识是否切换了账号;
@property (assign, nonatomic) NSInteger m_isSwitchUserFlag;
//在首页显示当前城市
//@property (strong, nonatomic) SwitchCityNavItem*   m_pSwitchCityNavItem;

//1_内部测试版本;2_发布版本
@property (assign, nonatomic) NSInteger m_iAppTestOrDisVersion;
//1_app store更新;2_网站更新;
@property (assign, nonatomic) NSInteger m_iAppUpdateFromType;

//在页面的tabbar上的更多按钮显示红色数字。
@property (strong, nonatomic) UIImageView*  m_uiBuyCarHintImgView;

//获取单例的静态函数
+(UaConfiguration*)sharedInstance;
//用于时间格式转换
+(NSString *)getTimeStringWith:(NSString *)string;
//
+(NSString*)getPlistPath;
//
-(void)setCurRootCtrl:(UIViewController*)rootCtrl;

//设置不同网络时，是否需要下载图片
-(void)setPhoneNetAndImageDownFlag;

//判断用户是否已经登录
-(BOOL)userIsHaveLoadinSystem;
//获取应用程序的一些初始化数据
-(void)initAppDataFromWeb;

@end
