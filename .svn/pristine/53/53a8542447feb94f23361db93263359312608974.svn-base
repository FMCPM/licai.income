/*------------------------------------------------------------------------
 Filename       : 	JsonXmlParserObj.h
 
 Description	:   自定义的一个类：封装了json解析的相关操作。
 
 Author         :   lzq,lvzhuqiang@ytinfo.zj.cn
 
 Date           :   2012-06-12
 
 version        :   v1.0
 
 Copyright      :   2012年 ytinfo. All rights reserved.
 
 ------------------------------------------------------------------------*/


#import <Foundation/Foundation.h>
#import "QDataSetObj.h"


@interface JsonXmlParserObj : NSObject
{

    //记录原始的json的消息体
    NSDictionary*  m_oraJsonDict;
    NSArray*       m_oraJsonArray;
    NSDictionary*  m_oraParseDict;
    
    bool           m_blResult;
    
}

//设置操作结果
-(void)setOpeResult:(bool)blResult;
//获取操作结果
-(bool)getOpeResult;

//输入原始的json消息体
-(bool)parseOraJsonDict:(NSDictionary*)oraJsonDict;

//根据关键字，解析对应的值
-(QDataSetObj*)parsetoDataSet:(NSString*)strKey;

//解析array类型多行数据
-(QDataSetObj*)parseArrayList_Lev1:(NSString*)strKey;
//解析字典类型的类型单行数据
-(QDataSetObj*)parseDictList_Lev1:(NSString*)strKey;
//获取指定key对应的值
-(NSString*)getJsonValueByKey:(NSString*)strKey;

//获取指定key对应的值
-(NSString*)getDictJsonValueByKey:(NSString*)strKey;
@end
