//
//  LoginStateSet.m
//  
//  登录信息记录
//
//  Created by lzq on 12-11-27.
//


#import "LoginStateSet.h"
#import "UaConfiguration.h"

@implementation LoginStateSet

@synthesize m_iUserLoginFlag;
@synthesize m_strUserProvinceID;
@synthesize m_strUserCityID;
@synthesize m_strUserLoginName;
@synthesize m_strUserLoginSid;
@synthesize m_lLastSidTime;
@synthesize m_iUserMemberID;
@synthesize m_strUserCityName;
@synthesize m_strBankCardId;
@synthesize m_strUserCardId;
@synthesize m_strUserReallyName;
@synthesize m_strUserLoginPwd;
@synthesize m_iNeedDownImageNotWifi;
@synthesize m_strBankName;
@synthesize m_strBankCardSno;
@synthesize m_pBankLogoImage;

-(id)init
{
    self = [super init];
    if (self) {
        
        self.m_iUserLoginFlag = 0;
        self.m_strUserLoginName = @"";
        self.m_strUserLoginSid = @"";
        self.m_strUserReallyName = @"";
        self.m_strUserLoginSid  = @"";
        self.m_iUserMemberID = 0;
        self.m_strUserLoginPwd = @"";
        self.m_lLastSidTime = 0;
        self.m_iNeedDownImageNotWifi = 1;//默认没有wifi，也需要下载图片
        self.m_strUserProvinceID = @"0";//默认未浙江省
        self.m_strUserCityID = @"0";//默认为杭州市
        self.m_strUserCityName = @"";
        self.m_strBankCardId = @"";
        self.m_strBankName = @"";
        self.m_strUserCardId = @"";
        self.m_strBankCardSno = @"";
        self.m_pBankLogoImage = nil;
    }
    return self;
}
/*
-(void)getUserHeadImgPath
{
    NSString *path = [UaConfiguration getPlistPath];
    NSMutableDictionary* dict = [ [ NSMutableDictionary alloc ] initWithContentsOfFile:path];
    NSString* object = (NSString*)[ dict objectForKey:@"UserHeadImgPath"];
    if (object) {
        self.m_strUserHeadImgPath = object;
    }
}

-(void)saveUserHeadImgPath
{
    if (self.m_strUserHeadImgPath)
    {
        NSString *path = [UaConfiguration getPlistPath];
        NSMutableDictionary* dict = [ [ NSMutableDictionary alloc ] initWithContentsOfFile:path];
        [ dict setObject:self.m_strUserHeadImgPath forKey:@"UserHeadImgPath" ];
        [ dict writeToFile:path atomically:YES ];
    }
}
*/

#pragma mark- NSCoding delegate and NSCoping delegate
//保存至本地
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:m_strUserLoginName forKey:@"m_strUserLoginName"];
    [aCoder encodeObject:m_strUserLoginPwd forKey:@"m_strUserLoginPwd"];
    [aCoder encodeObject:m_strUserLoginSid forKey:@"m_strUserLoginSid"];
    [aCoder encodeInteger:m_lLastSidTime forKey:@"m_lLastSidTime"];

    [aCoder encodeInteger:m_iUserMemberID forKey:@"m_iUserMemberID"];
    [aCoder encodeObject:m_strUserProvinceID forKey:@"m_strUserProvinceID"];
    [aCoder encodeObject:m_strUserCityID forKey:@"m_strUserCityID"];
    [aCoder encodeObject:m_strUserCityName forKey:@"m_strUserCityName"];
    [aCoder encodeInteger:m_iUserLoginFlag forKey:@"m_iUserLoginFlag"];
 //   [aCoder encodeObject:m_strUserHeadImgPath forKey:@"m_strUserHeadImgPath"];
//    [aCoder encodeObject:m_strUserSinaToken forKey:@"m_strUserSinaToken"];
    
 
}


-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {

        self.m_strUserLoginName = [aDecoder decodeObjectForKey:@"m_strUserLoginName"];
        self.m_strUserLoginSid = [aDecoder decodeObjectForKey:@"m_strUserLoginSid"];
        self.m_strUserLoginPwd = [aDecoder decodeObjectForKey:@"m_strUserLoginPwd"];
        self.m_lLastSidTime = [aDecoder decodeIntegerForKey:@"m_lLastSidTime"];
        self.m_iUserMemberID = [aDecoder decodeIntegerForKey:@"m_iUserMemberID"];
        self.m_strUserProvinceID = [aDecoder decodeObjectForKey:@"m_strUserProvinceID"];
        self.m_strUserCityID = [aDecoder decodeObjectForKey:@"m_strUserCityID"];
        self.m_strUserCityName = [aDecoder decodeObjectForKey:@"m_strUserCityName"];
        self.m_iNeedDownImageNotWifi = [aDecoder decodeIntegerForKey:@"m_iNeedDownImageNotWifi"];
        
        self.m_strBankCardSno = @"";
        self.m_strBankName = @"";
        self.m_strUserCardId = @"";
        self.m_pBankLogoImage = nil;
    }
    return self;
}


-(id)copyWithZone:(NSZone *)zone
{
    LoginStateSet *copy = [[[self class] allocWithZone:zone] init];
    copy.m_iUserLoginFlag = self.m_iUserLoginFlag;
    copy.m_strUserLoginName = self.m_strUserLoginName;
    copy.m_strUserLoginPwd = self.m_strUserLoginPwd;
    copy.m_strUserLoginSid = self.m_strUserLoginSid;
    copy.m_strUserCardId = self.m_strUserCardId;
    copy.m_strBankCardSno = self.m_strBankCardSno;
    copy.m_strBankCardId = self.m_strBankCardId;
    copy.m_strBankName = self.m_strBankName;
    copy.m_strUserReallyName = self.m_strUserReallyName;
    copy.m_lLastSidTime = self.m_lLastSidTime;
    copy.m_iUserMemberID = self.m_iUserMemberID;

    copy.m_iNeedDownImageNotWifi = self.m_iNeedDownImageNotWifi;
    copy.m_strUserProvinceID = self.m_strUserProvinceID;
    copy.m_strUserCityID = self.m_strUserCityID;
    copy.m_strUserCityName = self.m_strUserCityName;
    return copy;
}

-(bool)isLoginUser:(NSString*)strUser
{
    NSString* strTempUser = [m_strUserLoginName lowercaseString];
    strUser = [strUser lowercaseString];
    if([strTempUser isEqualToString:strUser])
        return true;
    return false;
}

//判断是否登录
-(bool)isHaveLoadInSystem
{
    if(m_strUserLoginName.length < 1 || m_strUserLoginPwd.length < 1)
        return NO;
    if(m_strUserLoginSid.length < 1)
        return NO;
    if(m_iUserLoginFlag < 1)
        return NO;
    return YES;
}

//设置登录/退出状态()
-(void)setHaveLoadInSession:(NSInteger)iLoadFlag
{
    if(iLoadFlag == 0)//
    {
        m_strUserLoginSid = @"";
        m_iUserLoginFlag = 0;
        return;
    }

    m_iUserLoginFlag = 1;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"yyyy.MM.dd HH:mm:ss"];
    NSString* strTime = [dateFormatter stringFromDate:[NSDate date]];
    m_strUserLoginSid = strTime;
}
@end
