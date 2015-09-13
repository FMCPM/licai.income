/*------------------------------------------------------------------------
 Filename       : 	BillDataSet.m
 
 Description	:   自定义的一个类：封装了订单相关的一些属性、方法。
 
 Author         :   lzq,lvzhuqiang@ytinfo.zj.cn
 
 Date           :   2012-06-12
 
 version        :   v1.0
 
 Copyright      :   2012年 ytinfo. All rights reserved.
 
 ------------------------------------------------------------------------*/

#import "BillDataSet.h"
#import "CKHttpHelper.h"
#import "SVProgressHUD.h"
#import "SQLLiteDBManager.h"


@implementation BillDataSet


@synthesize m_strGoodsBillID = _strGoodsBillID;
- (id)init
{
    self = [super init];
    if (self) {

        m_pBillDataSet = nil;
    }

    return self;
}


//添加一个商品到订单
-(void)addGoods:(NSInteger)iGoodsID andColor:(NSInteger)iColorID andSize:(NSInteger)iSizeID andCount:(NSInteger)iCount
{
    if(m_pBillDataSet == nil)
        m_pBillDataSet = [[QDataSetObj alloc] init];
    
    int iRow = [m_pBillDataSet getRowCount];
    [m_pBillDataSet addDataSetRow_Ext:iRow andName:@"GoodsID" andValue:[NSString stringWithFormat:@"%d",iGoodsID]];
    [m_pBillDataSet addDataSetRow_Ext:iRow andName:@"ColorID" andValue:[NSString stringWithFormat:@"%d",iColorID]];
    [m_pBillDataSet addDataSetRow_Ext:iRow andName:@"SizeID" andValue:[NSString stringWithFormat:@"%d",iSizeID]];
    [m_pBillDataSet addDataSetRow_Ext:iRow andName:@"BuyCount" andValue:[NSString stringWithFormat:@"%d",iCount]];
    
}


//获取订单中的商品ID列表
-(NSString*)getGoodsIDList
{
    if(m_pBillDataSet == nil)
        return @"";
    NSString* strIDList = @"";
    for(int i=0;i<[m_pBillDataSet getRowCount];i++)
    {
        NSString* strID = [m_pBillDataSet getFeildValue:i andColumn:@"GoodsID"];
        if(strIDList.length == 0)
            strIDList = strID;
        else
        {
            strIDList = [strIDList stringByAppendingFormat:@",%@",strID];
        }
        
    }
    return strIDList;
}

//获取所有的省的列表
-(QDataSetObj*)getProvinceInfoList
{

    NSString* strSQL = @"SELECT region_id ,region_name from t_region where parent_id=0";
    sqlite3_stmt *stmt;
    SQLLiteDBManager *manager = [[SQLLiteDBManager alloc]init];
    if (![manager prepareSQL:strSQL andStmt:&stmt] || !stmt) {
        return nil;
    }
    
    QDataSetObj*pResultDataSet = [[QDataSetObj alloc] init];
    int iRow = -1;
    while (sqlite3_step(stmt) ==SQLITE_ROW)
    {
        
        NSString* strId = [[NSString alloc] initWithCString:(char*)sqlite3_column_text(stmt,0) encoding:NSUTF8StringEncoding];
        NSString* strName = [[NSString alloc] initWithCString:(char*)sqlite3_column_text(stmt,1) encoding:NSUTF8StringEncoding];
        iRow++;
       
        [pResultDataSet addDataSetRow_Ext:iRow andName:@"id" andValue:strId];
        [pResultDataSet addDataSetRow_Ext:iRow andName:@"name" andValue:strName];
    }
    
    sqlite3_finalize(stmt);
    [manager closeSQLLiteDB];
    return pResultDataSet;
}

//获取某个省所属的城市列表
-(QDataSetObj*)getCityInfoLsit:(NSInteger)iProvinceId
{
    NSString* strSQL = @"";
    if(iProvinceId > 0)
    {
        strSQL = [NSString stringWithFormat:@"select region_id ,region_name,parent_id from t_region where parent_id=%d",iProvinceId];
    }
    else
    {
        strSQL = @"select region_id ,region_name,parent_id from t_region where parent_id <> 0 ";
    
    }
    

    sqlite3_stmt *stmt;
    SQLLiteDBManager *manager = [[SQLLiteDBManager alloc]init];
    if (![manager prepareSQL:strSQL andStmt:&stmt] || !stmt) {
        return nil;
    }
    
    QDataSetObj*pResultDataSet = [[QDataSetObj alloc] init];
    int iRow = -1;
    while (sqlite3_step(stmt) ==SQLITE_ROW)
    {
        
        NSString* strId = [[NSString alloc] initWithCString:(char*)sqlite3_column_text(stmt,0) encoding:NSUTF8StringEncoding];
        NSString* strName = [[NSString alloc] initWithCString:(char*)sqlite3_column_text(stmt,1) encoding:NSUTF8StringEncoding];
        NSString* strPid = [[NSString alloc] initWithCString:(char*)sqlite3_column_text(stmt,2) encoding:NSUTF8StringEncoding];
        iRow++;
        
        [pResultDataSet addDataSetRow_Ext:iRow andName:@"id" andValue:strId];
        [pResultDataSet addDataSetRow_Ext:iRow andName:@"name" andValue:strName];
        if(iProvinceId == 0)
        {
            [pResultDataSet addDataSetRow_Ext:iRow andName:@"pid" andValue:strPid];
        }
    }
    
    sqlite3_finalize(stmt);
    [manager closeSQLLiteDB];
    return pResultDataSet;
}

//根据城市的id，获取省的信息
-(SetRowObj*)getProvinceObj:(NSInteger)iCityId
{
    int iProvinceId = [self getProvinceId:iCityId];
    if(iProvinceId == 0)
        return nil;
    NSString* strSQL = [NSString stringWithFormat:@"select region_name from t_region where region_id=%d",iProvinceId];
    
    sqlite3_stmt *stmt;
    SQLLiteDBManager *manager = [[SQLLiteDBManager alloc]init];
    if (![manager prepareSQL:strSQL andStmt:&stmt] || !stmt) {
        return nil;
    }
    if(sqlite3_step(stmt) !=SQLITE_ROW)
        return nil;
    
    NSString* strProvinceName =[[NSString alloc] initWithCString:(char*)sqlite3_column_text(stmt,0) encoding:NSUTF8StringEncoding];
    SetRowObj* pRowObj = [[SetRowObj alloc] init];
    [pRowObj addFieldObj:@"id" andValue:[NSString stringWithFormat:@"%d",iProvinceId]];
    [pRowObj addFieldObj:@"name" andValue:strProvinceName];
    sqlite3_finalize(stmt);
    [manager closeSQLLiteDB];
    return pRowObj;
   
}

//根据cityid获取对应的provinceid
-(NSInteger)getProvinceId:(NSInteger)iCityId
{
    NSString* strSQL = [NSString stringWithFormat:@"select parent_id from t_region where region_id=%d",iCityId];
    
    sqlite3_stmt *stmt;
    SQLLiteDBManager *manager = [[SQLLiteDBManager alloc]init];
    if (![manager prepareSQL:strSQL andStmt:&stmt] || !stmt) {
        return nil;
    }
    
    int iProvinceId = 0;
    if(sqlite3_step(stmt) ==SQLITE_ROW)
    {
        NSString* strProvinceId =[[NSString alloc] initWithCString:(char*)sqlite3_column_text(stmt,0) encoding:NSUTF8StringEncoding];
        iProvinceId = [QDataSetObj convertToInt:strProvinceId];
    }
    sqlite3_finalize(stmt);
    [manager closeSQLLiteDB];
    return iProvinceId;

}

//根据id，获取省份或城市的名称
-(NSString*)getProvinceOrCityNameById:(NSString*)strId
{
    NSString* strSQL = [NSString stringWithFormat:@"select region_name from t_region where region_id=%@",strId];
    
    sqlite3_stmt *stmt;
    SQLLiteDBManager *manager = [[SQLLiteDBManager alloc]init];
    if (![manager prepareSQL:strSQL andStmt:&stmt] || !stmt) {
        return nil;
    }
    
    NSString* strName = @"";
    if(sqlite3_step(stmt) ==SQLITE_ROW)
    {
        strName =[[NSString alloc] initWithCString:(char*)sqlite3_column_text(stmt,0) encoding:NSUTF8StringEncoding];
      
    }
    sqlite3_finalize(stmt);
    [manager closeSQLLiteDB];
    return strName;
   
}


-(NSString*)getAreaInfoShowByCityId:(NSString*)strCityId
{
    if(strCityId.length < 1)
        return @"";
    NSInteger iProvinceId = [self getProvinceId:strCityId.intValue];
    NSString* strProvinceName = @"";
    if(iProvinceId > 0)
    {
        strProvinceName = [self getProvinceOrCityNameById:[NSString stringWithFormat:@"%d",iProvinceId]];
        
    }
    NSString* strCityName = [self getProvinceOrCityNameById:strCityId];
    
    NSString* strAreaInfo = strProvinceName;
    if(strAreaInfo.length < 1)
        strAreaInfo = strCityName;
    else
        strAreaInfo = [strAreaInfo stringByAppendingFormat:@"   %@",strCityName];
    
    return  strAreaInfo;
        
}

@end
