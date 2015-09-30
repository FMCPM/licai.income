/*------------------------------------------------------------------------
 Filename       : 	SQLLiteDBManager.h
 
 Description	:   iphone端嵌入式数据库的管理类，提供对嵌入式数据库的各类操作
 
 
 Author         :   lzq,lvzhuqiang@ytinfo.zj.cn
 
 Date           :   2012-06-05
 
 version        :   v1.0
 
 Copyright      :   2012年 ytinfo. All rights reserved.
 
 ------------------------------------------------------------------------*/


#import "SQLLiteDBManager.h"
#import "ImgFileMethod.h"

@implementation SQLLiteDBManager

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        m_sqlDbHandler = NULL;
        _strSqlDbPathName = [SQLLiteDBManager getSQLLiteDBPathName];
    }
    
    return self;
}

- (void) dealloc
{
    [self closeSQLLiteDB];
}
/*------------------------------------------------------------------------
 Function    :openSQLLiteDB
 Description :打开嵌入式数据库
 Params      :none
 Result      :返回全局的实例
 Author      :lzq,lvzhuqiang@ytinfo.zj.cn
 DateTime    :2012-06-06
 ------------------------------------------------------------------------*/

-(BOOL)openSQLLiteDB
{
    //数据库不存在，则创建
	if(sqlite3_open([_strSqlDbPathName UTF8String], &m_sqlDbHandler) != SQLITE_OK)
	{
		NSLog(@"db open fail:%@", _strSqlDbPathName);
        return FALSE;
		//[dbPath release];
	}

    NSLog(@"\n open db file %@ \n",_strSqlDbPathName);
    return TRUE;
}

//获取数据库路径名
+(NSString*)getSQLLiteDBPathName
{
   // return [[NSBundle mainBundle] pathForResource:@"SjqStreet" ofType:@"db"];
    
    NSString* strDocumentDir = [ImgFileMethod getAppDocumentDir];
    NSString* strDocumentDBDir = [strDocumentDir stringByAppendingPathComponent:@"DB"];
    NSFileManager* fileManager =[[NSFileManager alloc]init];
    if([fileManager fileExistsAtPath:strDocumentDBDir] == FALSE )
    {
        BOOL blResult = [fileManager createDirectoryAtPath:strDocumentDBDir withIntermediateDirectories:YES attributes:nil error:nil];
        if(blResult == FALSE){
            return nil;
        }
    }
    
    NSString*strDocumentDBFileName = [strDocumentDBDir stringByAppendingPathComponent:@"easybuy.db"];
    //删除临时目录下的数据库文件
//    [fileManager removeItemAtPath:strDocumentDBFileName error:nil];

    if([fileManager fileExistsAtPath:strDocumentDBFileName] == FALSE)
    {
        
        NSString * strSQLDBName = [[NSBundle mainBundle] pathForResource:@"easybuy" ofType:@"db"];
        
        NSError* error=nil;
        [fileManager copyItemAtPath:strSQLDBName toPath:strDocumentDBFileName error:&error];
        if(error != nil)
        {
            NSLog(@"%@", error);
            NSLog(@"%@", [error userInfo]);
            strDocumentDBFileName = nil;
        }
    }
    return  strDocumentDBFileName;

}

/*------------------------------------------------------------------------
 Function    :closeSQLLiteDB
 Description :关闭数据库
 Params      :none
 Result      :void
 Author      :lzq,lvzhuqiang@ytinfo.zj.cn
 DateTime    :2012-06-06
 ------------------------------------------------------------------------*/
-(void)closeSQLLiteDB
{
    NSLog(@"\nDB is Close!\n");
    if(m_sqlDbHandler != NULL)
    {
        sqlite3_close(m_sqlDbHandler);
        m_sqlDbHandler = NULL;
    }
}

/*------------------------------------------------------------------------
 Function    :execSQL
 Description :执行一个没有返回数据的sql操作
 Params      :none
 Result      :执行成功，返回TRUE，否则返回FALSE
 Author      :lzq,lvzhuqiang@ytinfo.zj.cn
 DateTime    :2012-06-06
 ------------------------------------------------------------------------*/

-(BOOL)execSQL:(NSString*)strSQL
{
    if(strSQL == NULL)
        return FALSE;
    
    if(m_sqlDbHandler == NULL)
    {
        if([self openSQLLiteDB] == FALSE)
            return FALSE;
    }

    char *szErrMsg;
	if(sqlite3_exec(m_sqlDbHandler, [strSQL UTF8String],NULL, NULL, &szErrMsg)!=SQLITE_OK)
	{
		NSLog(@"db exec fail:%@,errmsg:%s", strSQL,szErrMsg);
		return  FALSE;
	}
    
	return TRUE;

}
/*------------------------------------------------------------------------
  Function    :execSQL
  Description :执行一个有返回数据的sql操作
  Params      :none
  Result      :执行成功，返回TRUE，否则返回FALSE
  Author      :lzq,lvzhuqiang@ytinfo.zj.cn
  DateTime    :2012-06-06
------------------------------------------------------------------------*/

-(BOOL)prepareSQL:(NSString*)strSQL andStmt:(sqlite3_stmt**)outStmt
{
    if(m_sqlDbHandler == NULL)
    {
        if([self openSQLLiteDB] == FALSE)
            return FALSE;
    }
    
	if(sqlite3_prepare(m_sqlDbHandler,[strSQL UTF8String], -1, outStmt, NULL) !=SQLITE_OK)
	{
		NSLog(@"sqlite3_prepare fail:%@", strSQL);
		return FALSE;
	}
    
    return TRUE;
 
}


-(BOOL)initAppDBInfo
{
    
 
    NSString* strSQL = @"update t_ClassManage set isShow=0  where versionCode=1 and isShow=1" ;
    
    BOOL blResult = [self execSQL:strSQL];
    
     blResult = [self execSQL:strSQL];

    //  [self closeSQLLiteDB];
    
    return blResult;
    

}

@end
