//
//  WebserviceParser.m
//  FJ-E-YellowPage
//
//  Created by jiangjunchen on 13-5-7.
//  Copyright (c) 2013年 ytinfo. All rights reserved.
//

#import "WebserviceParser.h"
#import "JsonXmlParserObj.h"

@implementation WebserviceParser

//解析收到的数据包
-(QDataSetObj*)ParserData_Set:(NSData*)nsData
{
    if(nsData == nil)
        return nil;
    
    NSError* error = nil;
    NSDictionary* nsJson =[NSJSONSerialization
                           JSONObjectWithData:nsData //1
                           options:kNilOptions
                           error:&error];
    if(nsJson == nil)
    {
        NSLog(@"ParserData is Faild!");
        NSString*strData = [[NSString alloc] initWithData:nsData encoding:NSUTF8StringEncoding];
        NSLog(@"Received Data =%@",strData);
        
        return nil;
    }
    QDataSetObj* pJsonDataSet = [self visitJsonDict:nsJson];
    if(pJsonDataSet == nil)
    {
        NSString*strBody = [[NSString alloc] initWithData:nsData encoding:NSUTF8StringEncoding];
        NSLog(@"Received Error Json body=%@",strBody);
    }
    
    return pJsonDataSet;
    
}


//解析收到的数据包
-(JsonXmlParserObj*)ParserData_Json:(NSData*)nsData
{
    if(nsData == nil)
        return nil;
    NSError* error = nil;
    NSDictionary* dictJson =[NSJSONSerialization
                             JSONObjectWithData:nsData //1
                             options:kNilOptions
                             error:&error];
    if(dictJson == nil)
    {
        NSLog(@"ParserData is Faild!");
        NSString*strData = [[NSString alloc] initWithData:nsData encoding:NSUTF8StringEncoding];
        NSLog(@"Received Data =%@",strData);
        
        return nil;
    }
    JsonXmlParserObj* pDataSet = [JsonXmlParserObj alloc];
    [pDataSet parseOraJsonDict:dictJson];
    return pDataSet;
    
}


//遍历并解析接收到的json包体
-(QDataSetObj*)visitJsonDict:(NSDictionary *)dict
{
    if(dict.count < 1)
        return nil;
    QDataSetObj* pJsonDataSet = [[QDataSetObj alloc] init];
    [pJsonDataSet setOpeResult:YES];
  ///  [pJsonDataSet parseJsonBodyData:dict];
    return pJsonDataSet;
}


@end
