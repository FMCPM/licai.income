//
//  CityDataSet.m
//  YTSearch
//
//  Created by jiang junchen on 12-11-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CityDataSet.h"
#import "SQLLiteDBManager.h"

@implementation CityDataSet

@synthesize m_strProvinceID;
@synthesize m_strProvinceName;
@synthesize m_strCityCode;
@synthesize m_strCityName;
@synthesize m_strTownCode;
@synthesize m_strTownName;
@synthesize m_strCountyCode;
@synthesize m_strCountyName;
@synthesize m_strAddr;

-(id)init
{
    self = [super init];
    if (self) {
        //   self.m_strProvinceID = @"936";
        //    self.m_strProvinceName = @"浙江";
        //     self.m_strCityCode = @"937";
        //     self.m_strCityName = @"杭州";
        self.m_strTownName = @"";
        self.m_strTownCode = @"";
        self.m_strCountyCode = @"";
        self.m_strCountyName = @"";

        //默认为全国
        self.m_strProvinceID = @"0";
        self.m_strProvinceName = @"全国";
        self.m_strCityCode = @"0";
        self.m_strCityName = @"全国";
        self.m_strAddr = self.m_strCityName;
    }
    return self;
}

/*
+(NSString*)getCityNameFromeCode:(NSString*)cityCode
{
    NSString* strSQL = [NSString stringWithFormat:@"select  cityName from t_cityInfo where cityCode='%@'",cityCode];
    sqlite3_stmt *stmt;
    SQLLiteDBManager *manager = [[SQLLiteDBManager alloc]init];
    
    if (![manager prepareSQL:strSQL andStmt:&stmt] || !stmt) {
        return @"";
    }
    if (sqlite3_step(stmt) ==SQLITE_ROW)
    {
        NSString *cityName = [NSString stringWithCString:(char*)sqlite3_column_text(stmt,0) encoding:NSUTF8StringEncoding];
        if (cityName && ![cityName isEqualToString:@""]) {
            sqlite3_finalize(stmt);
            return cityName;
        }
    }
    sqlite3_finalize(stmt);
    [manager closeSQLLiteDB];
    return @"";
}

+(NSString*)getCountyNameFromeCityCode:(NSString*)cityCode andCountyCode:(NSString*)countyCode
{
    NSString* strSQL = [NSString stringWithFormat:@"select  countyName from t_countyInfo where cityCode='%@' and countyCode='%@'",cityCode,countyCode];
    sqlite3_stmt *stmt;
    SQLLiteDBManager *manager = [[SQLLiteDBManager alloc]init];
    
    if (![manager prepareSQL:strSQL andStmt:&stmt] || !stmt) {
        return @"";
    }
    if (sqlite3_step(stmt) ==SQLITE_ROW)
    {
        NSString *countyName = [NSString stringWithCString:(char*)sqlite3_column_text(stmt,0) encoding:NSUTF8StringEncoding];
        if (countyName.length>0) {
            sqlite3_finalize(stmt);
            [manager closeSQLLiteDB];
            return countyName;
        }
    }
    sqlite3_finalize(stmt);
    [manager closeSQLLiteDB];
    return @"";
}
*/
#pragma mark- NSCoding delegate and NSCoping delegate
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:m_strProvinceID forKey:@"m_strProvinceID"];
    [aCoder encodeObject:m_strProvinceName forKey:@"m_strProvinceName"];
    [aCoder encodeObject:m_strCountyCode forKey:@"m_strCountyCode"];
    [aCoder encodeObject:m_strCountyName forKey:@"m_strCountyName"];
    [aCoder encodeObject:m_strCityCode forKey:@"m_strCityCode"];
    [aCoder encodeObject:m_strCityName forKey:@"m_strCityName"];
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self.m_strProvinceID = @"0";
    self.m_strProvinceName = @"全国";
    self.m_strTownName = @"";
    self.m_strTownCode = @"";
    self.m_strCountyCode = @"";
    self.m_strCountyName = @"";
    self.m_strCityCode = @"0";
    self.m_strCityName = @"全国";
    
    if (self = [super init])
    {
        self.m_strTownName = @"";
        self.m_strTownCode = @"";
        self.m_strCountyCode = [aDecoder decodeObjectForKey:@"m_strCountyCode"];
        self.m_strCountyName = [aDecoder decodeObjectForKey:@"m_strCountyName"];
        self.m_strCityCode = [aDecoder decodeObjectForKey:@"m_strCityCode"];
        self.m_strCityName = [aDecoder decodeObjectForKey:@"m_strCityName"];
        self.m_strProvinceID = [aDecoder decodeObjectForKey:@"m_strProvinceID"];
          self.m_strProvinceName = [aDecoder decodeObjectForKey:@"m_strProvinceName"];
    }
    return self;
}
-(id)copyWithZone:(NSZone *)zone
{
    CityDataSet *copy = [[[self class] allocWithZone:zone] init];
    copy.m_strTownName = self.m_strTownName;
    copy.m_strTownCode = self.m_strTownCode;
    copy.m_strCountyCode = self.m_strCountyCode;
    copy.m_strCountyName = self.m_strCountyName;
    copy.m_strCityCode = self.m_strCityCode;
    copy.m_strCityName = self.m_strCityName;
    copy.m_strProvinceName = self.m_strProvinceName;
    copy.m_strProvinceID = self.m_strProvinceID;
    return copy;
}
@end
