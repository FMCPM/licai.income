//
//  DesktopItemsSet.h
//  E-YellowPage
//
//  Created by jiangjunchen on 13-3-13.
//  Copyright (c) 2013年 ytinfo. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SetRowObj;

@interface DesktopItemsSet : NSObject
{
    NSMutableArray *_items;
}
//根据文件的路径获取数据并初始化
-(id)initWithFilePath:(NSString*)filePath;

//根据版本(1:大众版  2:地方版)从数据库获取数据并初始化
-(id)initWithVersionType:(NSInteger)versionType;

//获取所有页面上的全部按钮的信息
-(NSMutableArray*)getItemPagesInfo;

//根据某个按钮的itemPath获取到该按钮的信息
-(SetRowObj*)getItemInfoByItemPath:(NSString*)itemPath;

-(SetRowObj*)getItemInfoByClassCode:(NSString *)classCode andSubClassCode:(NSString*)subClassCode;

-(void)deleteItemInfoByItemPath:(NSString*)itemPath;
//
-(void)saveToFile:(NSString*)filePath;
@end
