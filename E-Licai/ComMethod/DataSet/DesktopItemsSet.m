//
//  DesktopItemsSet.m
//  E-YellowPage
//
//  Created by jiangjunchen on 13-3-13.
//  Copyright (c) 2013年 ytinfo. All rights reserved.
//

#import "DesktopItemsSet.h"
#import "SQLLiteDBManager.h"
#import "SetRowObj.h"

#define kDeskTopItemsSetKey @"kDeskTopItemsSetKey"

@implementation DesktopItemsSet
-(id)initWithFilePath:(NSString*)filePath
{
    self = [super init];
    if (self) {
        _items = [self getItemPagesInfoFromFile:filePath];
    }
    return self;
}

//读取指定版首页的分类按钮信息
-(id)initWithVersionType:(NSInteger)versionType
{
    self = [super init];
    if (self) {
        _items = [[NSMutableArray alloc]init];
        NSString* strSQL = [NSString stringWithFormat:@"select  classCode,title,imgID,showIndex,isshow,id,subClassCode  from t_classManage where versionCode=%d and isshow>100 order by isshow",versionType];
        sqlite3_stmt *stmt;
        SQLLiteDBManager *manager = [[SQLLiteDBManager alloc]init];
        
        if (![manager prepareSQL:strSQL andStmt:&stmt] || !stmt) {
            return self;
        }
    //    NSMutableArray *curPage;
        while (sqlite3_step(stmt) ==SQLITE_ROW)
        {
            //   int showLevel = sqlite3_column_int(stmt, 3);
            //   int itemPath = sqlite3_column_int(stmt, 4);
            NSString *classCode = [NSString stringWithCString:(char*)sqlite3_column_text(stmt,0) encoding:NSUTF8StringEncoding];
            NSString *className = [NSString stringWithCString:(char*)sqlite3_column_text(stmt,1) encoding:NSUTF8StringEncoding];
            NSString *imgId = [NSString stringWithCString:(char*)sqlite3_column_text(stmt,2) encoding:NSUTF8StringEncoding];
            NSString *showLevel = [NSString stringWithCString:(char*)sqlite3_column_text(stmt,3) encoding:NSUTF8StringEncoding];
            NSString *itemPath = [NSString stringWithCString:(char*)sqlite3_column_text(stmt,4) encoding:NSUTF8StringEncoding];
            NSString *itemId = [NSString stringWithCString:(char*)sqlite3_column_text(stmt,5) encoding:NSUTF8StringEncoding];
            NSString *subClassCode = [NSString stringWithCString:(char*)sqlite3_column_text(stmt,6) encoding:NSUTF8StringEncoding];

            SetRowObj *rowItemInfo = [[SetRowObj alloc]init];
            [rowItemInfo addFieldObj:@"classCode" andValue:classCode];
            [rowItemInfo addFieldObj:@"className" andValue:className];
            [rowItemInfo addFieldObj:@"imgId" andValue:imgId];
            [rowItemInfo addFieldObj:@"showLevel" andValue:showLevel];
            [rowItemInfo addFieldObj:@"id" andValue:itemId];
            [rowItemInfo addFieldObj:@"itemPath" andValue:itemPath];
            [rowItemInfo addFieldObj:@"subClassCode" andValue:subClassCode];
            [_items addObject:rowItemInfo];

            
        }
        sqlite3_finalize(stmt);
        [manager closeSQLLiteDB];
    }
    return self;
}

//获取所有页面上的全部按钮的信息
-(NSMutableArray*)getItemPagesInfo
{
    return _items;
}

//获取所有页面上的全部按钮的信息-----内部方法
-(NSMutableArray*)getItemPagesInfoFromFile:(NSString*)itemPath
{
    if (!_items)
    {
        NSData *data = [[NSData alloc]initWithContentsOfFile:itemPath];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
        _items = [unarchiver decodeObjectForKey:kDeskTopItemsSetKey];
        [unarchiver finishDecoding];
    }
    return _items;
}

//根据某个按钮的itemPath获取到该按钮的信息
-(SetRowObj*)getItemInfoByItemPath:(NSString*)itemPath
{
    if (!_items) {
        return nil;
    }
    for (SetRowObj *iteminfo in _items) {
        if ([[iteminfo getFieldValue:@"itemPath"] isEqualToString:itemPath]) {
            return iteminfo;
        }
    }
    return nil;
}

-(SetRowObj*)getItemInfoByClassCode:(NSString *)classCode andSubClassCode:(NSString*)subClassCode
{
    if (!_items) {
        return nil;
    }
    for (SetRowObj *iteminfo in _items) {
        if ([[iteminfo getFieldValue:@"classCode"] isEqualToString:classCode]) {
            if ([[iteminfo getFieldValue:@"subClassCode"] isEqualToString:subClassCode]) {
                return iteminfo;
            }
        }
    }
    return nil;
}

//根据某个按钮的itemPath删除该按钮
-(void)deleteItemInfoByItemPath:(NSString*)itemPath
{
    if (!_items)
        return;
    
    for (SetRowObj *iteminfo in _items) {
        if ([[iteminfo getFieldValue:@"itemPath"] isEqualToString:itemPath]) {
            [_items removeObject:iteminfo];
            return;
        }
    }
}


//将用户首页的分类按钮等应用程序的信息写入本地文件
-(void)saveToFile:(NSString*)filePath
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        for (SetRowObj *iteminfo in _items) {
            
            NSString* strClassName = [iteminfo getFieldValue:@"className"];
            NSString* strItem = [iteminfo getFieldValue:@"itemPath"];
            NSLog(@"clssName is %@,item is%@",strClassName,strItem);
    
        }
        
        NSMutableData *data = [[NSMutableData alloc] init];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
        [archiver encodeObject:_items forKey:kDeskTopItemsSetKey];
        [archiver finishEncoding];
        [data writeToFile:filePath atomically:YES];
    });
}
@end
