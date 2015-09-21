//
//  LoginStateSet.h
//
//  登录信息记录
//
//  Created by lzq on 12-11-27.

//

#import <Foundation/Foundation.h>

@interface LoginStateSet : NSObject<NSCopying, NSCoding>

//普通用户 0:未登录 1:上次登录  2:本次登录
@property (assign, nonatomic) NSInteger     m_iUserLoginFlag;
//登录账号
@property (strong, nonatomic) NSString*     m_strUserLoginName;
//登录密码
@property (strong, nonatomic) NSString*     m_strUserLoginPwd;
//登录后的session id
@property (strong, nonatomic) NSString*     m_strUserLoginSid;
//用户登录后，系统分配的id
@property (assign, nonatomic) NSInteger     m_iUserMemberID;
//sid最后一次更新的时间
@property (assign, nonatomic) long          m_lLastSidTime;
//记录账号当前的省份ID(gps定位)
@property (strong, nonatomic) NSString*     m_strUserProvinceID;
//记录账号当前的城市ID(gps定位)
@property (strong, nonatomic) NSString*     m_strUserCityID;
//记录账号当前的城市ID(gps定位)
@property (strong, nonatomic) NSString*     m_strUserCityName;
//记录当前银行卡ID
@property (strong, nonatomic) NSString*     m_strBankCardId;
//记录当前银行卡所属银行名称
@property (strong, nonatomic) NSString*     m_strBankName;
//记录当前银行卡所属银行名称
@property (strong, nonatomic) NSString*     m_strBankCardSno;
//记录用户的身份证
@property (strong, nonatomic) NSString*     m_strUserCardId;
//记录用户的真实姓名
@property (strong, nonatomic) NSString*     m_strUserReallyName;
//控制在没有WIFI的时候是否需要下载图片
@property (assign, nonatomic) NSInteger     m_iNeedDownImageNotWifi;
//银行logo
@property (strong, nonatomic) UIImage*      m_pBankLogoImage;
-(bool)isHaveLoadInSystem;
/*
-(void)getUserHeadImgPath;
-(void)saveUserHeadImgPath;
 */
-(bool)isLoginUser:(NSString*)strUser;
-(void)setHaveLoadInSession:(NSInteger)iLoadFlag;
@end
