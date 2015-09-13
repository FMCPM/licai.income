/*------------------------------------------------------------------------
 Filename       : 	SQLLiteDBManager.h
 
 Description	:   iphone端嵌入式数据库的管理类，提供对嵌入式数据库的各类操作
 
 
 Author         :   lzq,lvzhuqiang@ytinfo.zj.cn
 
 Date           :   2012-06-05
 
 version        :   v1.0
 
 Copyright      :   2012年 ytinfo. All rights reserved.

 ------------------------------------------------------------------------*/


#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface SQLLiteDBManager : NSObject
{
    //ios数据库句柄
  	sqlite3 *m_sqlDbHandler;  
    NSString *_strSqlDbPathName;
}
//打开sql lite 数据库，如果不存在，则创建一个新的数据库
-(BOOL)openSQLLiteDB;
//执行一条sql语句,不要返回数据集
-(BOOL)execSQL:(NSString*)strSQL;
//执行一条sql语句，并有数据集返回
-(BOOL)prepareSQL:(NSString*)strSQL andStmt:(sqlite3_stmt**)outStmt;
//关闭数据库
-(void)closeSQLLiteDB;
//初始化数据库设置
-(BOOL)initAppDBInfo;

//获取数据库路径名
+(NSString*)getSQLLiteDBPathName;
@end
