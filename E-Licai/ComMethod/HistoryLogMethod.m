/*------------------------------------------------------------------------
 Filename       : 	HistoryLogMethod.h
 
 Description	:   自定义的一个类：封装了App出售化时，从服务器获取相关的初始化数据
 
 Author         :   lzq,lvzhuqiang@ytinfo.zj.cn
 
 Date           :   2014-04-16
 
 version        :   v1.0
 
 Copyright      :   2014年 ytinfo. All rights reserved.
 
 ------------------------------------------------------------------------*/

#import "HistoryLogMethod.h"
#import "UaConfiguration.h"
#import "CKHttpHelper.h"
#import "SQLLiteDBManager.h"

@implementation HistoryLogMethod


- (id)init
{
    self = [super init];
    if (self) {
   
    }

    return self;
}


//添加一条商品的浏览记录
-(bool)AddOneGoodsHistoryLog:(NSString*)strUserName andGoodsId:(NSInteger)iGoodsId andName:(NSString*)strGoodsName andImgUrl:(NSString*)strImgUrl andPriceName:(NSString*)strPriceName andPriceValue:(NSString*)strPriceValue andStock:(NSInteger)iStockNum andService:(NSString*)strServiceFlag
{
    NSInteger iGoodsRecId = [self isHaveInGoods:iGoodsId andUser:strUserName];
    if(iGoodsRecId > 0)
    {
        [self updateOneGoodsHistorLog:iGoodsRecId];
        return true;
    }
    NSString* strCurTime = [self getSysCurrentTime];
    NSString* strSQL = [NSString stringWithFormat:@"insert into t_goods_history(userName,goodsId,goodsName,imgUrl,priceName,priceValue,stockNum,serviceImgUrl,lastTime)values('%@',%d,'%@','%@','%@','%@',%d,'%@','%@')",strUserName,iGoodsId,strGoodsName,strImgUrl,strPriceName,strPriceValue,iStockNum,strServiceFlag,strCurTime];
    
    SQLLiteDBManager *manager = [[SQLLiteDBManager alloc]init];
    if([manager execSQL:strSQL] == false)
        return false;
    
    return true;
}


//判断记录是否存在
-(NSInteger)isHaveInGoods:(NSInteger)iGoodsId andUser:(NSString*)strUserName
{
    NSString* strSQL = [NSString stringWithFormat:@"select id from  t_goods_history where userName='%@' and goodsId=%d ",strUserName,iGoodsId];
    sqlite3_stmt *stmt;
    
    SQLLiteDBManager *manager = [[SQLLiteDBManager alloc]init];
    if (![manager prepareSQL:strSQL andStmt:&stmt] || !stmt) {
        return false;
    }
    NSInteger iGoodsRecId = 0;
    if(sqlite3_step(stmt) ==SQLITE_ROW)
    {
        NSString* strGoodsRecId = [[NSString alloc] initWithCString:(char*)sqlite3_column_text(stmt,0) encoding:NSUTF8StringEncoding];
        iGoodsRecId = [QDataSetObj convertToInt:strGoodsRecId];
    }
    
    sqlite3_finalize(stmt);
    [manager closeSQLLiteDB];
    
    return  iGoodsRecId;
}

-(NSString*)getSysCurrentTime
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"yyyy.MM.dd HH:mm:ss"];
    NSString* strTime = [dateFormatter stringFromDate:[NSDate date]];
    return  strTime;
}



//修改商品的浏览记录的最后一次时间
-(bool)updateOneGoodsHistorLog:(NSInteger)iGoodsRecId
{
    NSString* strCurTime = [self getSysCurrentTime];
    NSString* strSQL = [NSString stringWithFormat:@"update t_goods_history set lastTime='%@' where id=%d ",strCurTime,iGoodsRecId];
    
    SQLLiteDBManager *manager = [[SQLLiteDBManager alloc]init];
    if([manager execSQL:strSQL] == false)
        return false;
    
    return true;
}

//添加一条店铺的浏览记录
-(bool)AddOneStoreHistoryLog:(NSString*)strUserName andStoreId:(NSInteger)iStoreId andName:(NSString*)strStoreName andImgUrl:(NSString*)strImgUrl andAddr:(NSString*)strAddress andZy:(NSString*)strBusiZy andService:(NSString*)strServiceFlag
{
    NSInteger iStoreRecId = [self isHaveInStore:iStoreId andUser:strUserName];
    if(iStoreRecId > 0)
    {
        [self updateOneStoreHistorLog:iStoreRecId];
        return true;
    }
    NSString* strCurTime = [self getSysCurrentTime];
    NSString* strSQL = [NSString stringWithFormat:@"insert into t_store_history(userName,storeId,storeName,imgUrl,address,business_zy,service_flag,lastTime)values('%@',%d,'%@','%@','%@','%@','%@','%@')",strUserName,iStoreId,strStoreName,strImgUrl,strAddress,strBusiZy,strServiceFlag,strCurTime];
    
    SQLLiteDBManager *manager = [[SQLLiteDBManager alloc]init];
    if([manager execSQL:strSQL] == false)
        return false;
    
    return true;
}


//判断店铺记录是否存在
-(NSInteger)isHaveInStore:(NSInteger)iStoreId andUser:(NSString*)strUserName
{
    NSString* strSQL = [NSString stringWithFormat:@"select id from  t_store_history where  userName='%@' and storeId=%d ",strUserName,iStoreId];
    sqlite3_stmt *stmt;
    
    SQLLiteDBManager *manager = [[SQLLiteDBManager alloc]init];
    if (![manager prepareSQL:strSQL andStmt:&stmt] || !stmt) {
        return false;
    }
    NSInteger iStoreRecId = 0;
    if(sqlite3_step(stmt) ==SQLITE_ROW)
    {
        NSString* strStoreRecId = [[NSString alloc] initWithCString:(char*)sqlite3_column_text(stmt,0) encoding:NSUTF8StringEncoding];
        iStoreRecId = [QDataSetObj convertToInt:strStoreRecId];
    }
 
    
    sqlite3_finalize(stmt);
    [manager closeSQLLiteDB];
    
    return  iStoreRecId;
}


//修改店铺的浏览记录的最后一次时间
-(bool)updateOneStoreHistorLog:(NSInteger)iStoreRecId
{
    NSString* strCurTime = [self getSysCurrentTime];
    NSString* strSQL = [NSString stringWithFormat:@"update t_store_history set lastTime='%@' where user id=%d ",strCurTime,iStoreRecId];
    
    SQLLiteDBManager *manager = [[SQLLiteDBManager alloc]init];
    if([manager execSQL:strSQL] == false)
        return false;
    
    return true;
}


//获取商品浏览记录
-(QDataSetObj*)getGoodsHistoryLog:(NSString*)strUserName andPageId:(NSInteger)iCurPageId

{
    
    if(iCurPageId < 1)
        return nil;
    
    NSString* strSQL = [NSString stringWithFormat:@"select id,goodsId,goodsName,imgUrl,priceName,priceValue,stockNum,serviceImgUrl from t_goods_history where userName='%@' order by lastTime desc",strUserName];
    
    sqlite3_stmt *stmt;
    SQLLiteDBManager *manager = [[SQLLiteDBManager alloc]init];
    if (![manager prepareSQL:strSQL andStmt:&stmt] || !stmt) {
        return nil;
    }

    int iRow = -1;
    QDataSetObj* pLogDataSet = [[QDataSetObj alloc] init];
    
    int iBegIndex = (iCurPageId-1)*10;
    
    int iGetCount = 0;
    while (sqlite3_step(stmt) == SQLITE_ROW)
    {
        
         iRow++;
         if(iRow < iBegIndex)
            continue;
        
         NSString* strGoodsId = [[NSString alloc] initWithCString:(char*)sqlite3_column_text(stmt,1) encoding:NSUTF8StringEncoding];
        //
         NSString* strGoodsName = [[NSString alloc] initWithCString:(char*)sqlite3_column_text(stmt,2) encoding:NSUTF8StringEncoding];
        
         NSString* strImgUrl = [[NSString alloc] initWithCString:(char*)sqlite3_column_text(stmt,3) encoding:NSUTF8StringEncoding];
  
         NSString* strPriceName = [[NSString alloc] initWithCString:(char*)sqlite3_column_text(stmt,4) encoding:NSUTF8StringEncoding];
        
         NSString* strPriceValue = [[NSString alloc] initWithCString:(char*)sqlite3_column_text(stmt,5) encoding:NSUTF8StringEncoding];
        
         NSString* strStockNum = [[NSString alloc] initWithCString:(char*)sqlite3_column_text(stmt,6) encoding:NSUTF8StringEncoding];
        
        NSString* strServiceFlag = [[NSString alloc] initWithCString:(char*)sqlite3_column_text(stmt,7) encoding:NSUTF8StringEncoding];
        

        [pLogDataSet addDataSetRow_Ext:iRow andName:@"id" andValue:strGoodsId];
        [pLogDataSet addDataSetRow_Ext:iRow andName:@"name" andValue:strGoodsName];
        [pLogDataSet addDataSetRow_Ext:iRow andName:@"imgUrl" andValue:strImgUrl];
        [pLogDataSet addDataSetRow_Ext:iRow andName:@"priceName" andValue:strPriceName];
        
        [pLogDataSet addDataSetRow_Ext:iRow andName:@"priceValue" andValue:strPriceValue];
        [pLogDataSet addDataSetRow_Ext:iRow andName:@"storageCount" andValue:strStockNum];
        [pLogDataSet addDataSetRow_Ext:iRow andName:@"serviceImgUrl" andValue:strServiceFlag];
        iGetCount++;
        if(iGetCount >=10)
            break;
        
    }
    
    sqlite3_finalize(stmt);
    [manager closeSQLLiteDB];
    
    return pLogDataSet;
  
    
}


//获取商品浏览记录
-(QDataSetObj*)getStoreHistoryLog:(NSString*)strUserName andPageId:(NSInteger)iCurPageId
{
    
    if(iCurPageId < 1)
        return nil;
    
    NSString* strSQL = [NSString stringWithFormat:@"select id,storeId,storeName,imgUrl,address,business_zy,service_flag from t_store_history where userName='%@' order by lastTime desc",strUserName];
    
    sqlite3_stmt *stmt;
    SQLLiteDBManager *manager = [[SQLLiteDBManager alloc]init];
    if (![manager prepareSQL:strSQL andStmt:&stmt] || !stmt) {
        return nil;
    }
    
    int iRow = -1;
    QDataSetObj* pLogDataSet = [[QDataSetObj alloc] init];
    
    int iBegIndex = (iCurPageId-1)*10;
    
    int iGetCount = 0;
    while (sqlite3_step(stmt) == SQLITE_ROW)
    {
        
        iRow++;
        if(iRow < iBegIndex)
            continue;
        
        NSString* strStoreId = [[NSString alloc] initWithCString:(char*)sqlite3_column_text(stmt,1) encoding:NSUTF8StringEncoding];
        //
        NSString* strStoreName = [[NSString alloc] initWithCString:(char*)sqlite3_column_text(stmt,2) encoding:NSUTF8StringEncoding];
        
        NSString* strImgUrl = [[NSString alloc] initWithCString:(char*)sqlite3_column_text(stmt,3) encoding:NSUTF8StringEncoding];
        
        NSString* strAddress = [[NSString alloc] initWithCString:(char*)sqlite3_column_text(stmt,4) encoding:NSUTF8StringEncoding];
        
        NSString* strBusinessZy = [[NSString alloc] initWithCString:(char*)sqlite3_column_text(stmt,5) encoding:NSUTF8StringEncoding];
        
        NSString* strServiceFlag = [[NSString alloc] initWithCString:(char*)sqlite3_column_text(stmt,6) encoding:NSUTF8StringEncoding];
        
        
        [pLogDataSet addDataSetRow_Ext:iRow andName:@"id" andValue:strStoreId];
        [pLogDataSet addDataSetRow_Ext:iRow andName:@"name" andValue:strStoreName];
        [pLogDataSet addDataSetRow_Ext:iRow andName:@"imgUrl" andValue:strImgUrl];
        [pLogDataSet addDataSetRow_Ext:iRow andName:@"address" andValue:strAddress];
        [pLogDataSet addDataSetRow_Ext:iRow andName:@"business_zy" andValue:strBusinessZy];
        [pLogDataSet addDataSetRow_Ext:iRow andName:@"service_flag" andValue:strServiceFlag];
        iGetCount++;
        if(iGetCount >=10)
            break;
        
    }
    
    sqlite3_finalize(stmt);
    [manager closeSQLLiteDB];
    
    return pLogDataSet;
    
    
}

-(bool)clearGoodsHistoryViewLog:(NSString*)strUserName
{
    NSString* strSQL = [NSString stringWithFormat:@"delete from t_goods_history  where userName='%@' ",strUserName];
    
    SQLLiteDBManager *manager = [[SQLLiteDBManager alloc]init];
    if([manager execSQL:strSQL] == false)
        return false;
    
    return true;
}


-(bool)clearStoreHistoryViewLog:(NSString*)strUserName
{
    NSString* strSQL = [NSString stringWithFormat:@"delete from t_store_history  where userName='%@' ",strUserName];
    
    SQLLiteDBManager *manager = [[SQLLiteDBManager alloc]init];
    if([manager execSQL:strSQL] == false)
        return false;
    
    return true;
}

//写一条搜索记录
-(bool)AddSearchHistoryLog:(NSString*)strUserName andType:(NSInteger)iType andKey:(NSString*)strKeyValue
{
    int iLogId = [self isHaveInSearch:strUserName andValue:strKeyValue andType:iType];
    if(iLogId > 0)
    {
        [self updateOneSearchHistorLog:iLogId];
        return true;
    }
    NSString* strCurTime = [self getSysCurrentTime];
    NSString* strSQL = [NSString stringWithFormat:@"insert into t_search_keyword(userName,keyType,keyContent,lastTime)values('%@',%d,'%@','%@')",strUserName,iType,strKeyValue,strCurTime];
    
    SQLLiteDBManager *manager = [[SQLLiteDBManager alloc]init];
    if([manager execSQL:strSQL] == false)
        return false;
    
    return true;
}


//判断店铺记录是否存在
-(int)isHaveInSearch:(NSString*)strUserName andValue:(NSString*)strKeyValue andType:(NSInteger)iType
{
    NSString* strSQL = [NSString stringWithFormat:@"select id from t_search_keyword where username='%@' and keyType=%d and keycontent='%@' ",strUserName,iType,strKeyValue];
    sqlite3_stmt *stmt;
    
    SQLLiteDBManager *manager = [[SQLLiteDBManager alloc]init];
    if (![manager prepareSQL:strSQL andStmt:&stmt] || !stmt) {
        return false;
    }
    int iLogId = 0;
    if(sqlite3_step(stmt) ==SQLITE_ROW)
    {
        NSString* strLogId = [[NSString alloc] initWithCString:(char*)sqlite3_column_text(stmt,0) encoding:NSUTF8StringEncoding];
        iLogId = [QDataSetObj convertToInt:strLogId];
    }
    sqlite3_finalize(stmt);
    [manager closeSQLLiteDB];
    
    return  iLogId;
}


//修改店铺的浏览记录的最后一次时间
-(bool)updateOneSearchHistorLog:(NSInteger)iLogId
{
    NSString* strCurTime = [self getSysCurrentTime];
    NSString* strSQL = [NSString stringWithFormat:@"update t_search_keyword set lastTime='%@' where id=%d ",strCurTime,iLogId];
    
    SQLLiteDBManager *manager = [[SQLLiteDBManager alloc]init];
    if([manager execSQL:strSQL] == false)
        return false;
    
    return true;
}


//获取商品浏览记录
-(QDataSetObj*)getSearchHistoryLog:(NSString*)strUserName andType:(NSInteger)iType andKey:(NSString*)strSearchKey
{
    
    NSString* strSQL = [NSString stringWithFormat:@"select id,keyContent  from t_search_keyword where userName='%@' and keyType=%d ",strUserName,iType];
    if(strSearchKey.length > 0)
    {
        strSQL = [strSQL stringByAppendingFormat:@" and keyContent like '%%%@%%' ",strSearchKey];
    }
    
    strSQL = [strSQL stringByAppendingString:@" order by lastTime desc"];

    sqlite3_stmt *stmt;
    SQLLiteDBManager *manager = [[SQLLiteDBManager alloc]init];
    if (![manager prepareSQL:strSQL andStmt:&stmt] || !stmt) {
        return nil;
    }
    
    int iRow = -1;
    QDataSetObj* pLogDataSet = [[QDataSetObj alloc] init];
    
    while (sqlite3_step(stmt) == SQLITE_ROW)
    {
        
        iRow++;
        
        NSString* strLogId = [[NSString alloc] initWithCString:(char*)sqlite3_column_text(stmt,0) encoding:NSUTF8StringEncoding];
        //
        NSString* strKeyContent = [[NSString alloc] initWithCString:(char*)sqlite3_column_text(stmt,1) encoding:NSUTF8StringEncoding];
        
        [pLogDataSet addDataSetRow_Ext:iRow andName:@"id" andValue:strLogId];
        [pLogDataSet addDataSetRow_Ext:iRow andName:@"keyContent" andValue:strKeyContent];

        
    }
    
    sqlite3_finalize(stmt);
    [manager closeSQLLiteDB];
    
    return pLogDataSet;
    
    
}

//删除用户所有的搜索记录
-(bool)clearSearchHistoryLog:(NSString*)strUserName andKeyType:(NSInteger)iKeyType
{

    NSString* strSQL = [NSString stringWithFormat:@"delete from t_search_keyword  where userName='%@' and keyType=%d ",strUserName,iKeyType];
    
    SQLLiteDBManager *manager = [[SQLLiteDBManager alloc]init];
    if([manager execSQL:strSQL] == false)
        return false;
    
    return true;
}


//清理超过数量的日志记录
-(void)clearMaxCountHistoryLog:(NSString*)strUserName
{
    //商品记录记录
    NSString* strMaxLastTime = [self getHistoryLogTimeMaxCount:strUserName andType:1];
    if(strMaxLastTime.length > 4)
    {
        [self deleteHistoryLogMaxCount:strUserName andType:1 andTime:strMaxLastTime];
    }
    //店铺记录
    strMaxLastTime = [self getHistoryLogTimeMaxCount:strUserName andType:2];
    if(strMaxLastTime.length > 4)
    {
        [self deleteHistoryLogMaxCount:strUserName andType:2 andTime:strMaxLastTime];
    }


}


//获取超过100条记录的时间
-(NSString*)getHistoryLogTimeMaxCount:(NSString*)strUserName andType:(NSInteger)iType
{
    NSString* strSQL = [NSString stringWithFormat:@"select  lasttime  from t_search_keyword where userName='%@' and keyType=%d order by lasttime desc ",strUserName,iType];
    
    sqlite3_stmt *stmt;
    SQLLiteDBManager *manager = [[SQLLiteDBManager alloc]init];
    if (![manager prepareSQL:strSQL andStmt:&stmt] || !stmt) {
        return 0;
    }
    
    int iRowCount = 0;
    NSString* strMaxLastTime = @"";
    
    while (sqlite3_step(stmt) == SQLITE_ROW)
    {
        
        NSString* strTime = [[NSString alloc] initWithCString:(char*)sqlite3_column_text(stmt,0) encoding:NSUTF8StringEncoding];
        
        iRowCount++;
        if(iRowCount >= MAXCOUNT_ROW_LOCALDB)
        {
            strMaxLastTime = strTime;
            break;
        }
    }
    
    sqlite3_finalize(stmt);
    [manager closeSQLLiteDB];    
    return  strMaxLastTime;

}


-(bool)deleteHistoryLogMaxCount:(NSString*)strUserName andType:(NSInteger)iType andTime:(NSString*)strLastTime
{
    NSString* strSQL = [NSString stringWithFormat:@"delete from t_search_keyword where userName='%@' and keyType=%d and lasttime<='%@' ",strUserName,iType,strLastTime];
    
    SQLLiteDBManager *manager = [[SQLLiteDBManager alloc]init];
    if([manager execSQL:strSQL] == false)
        return false;
    
    return true;
}

@end
