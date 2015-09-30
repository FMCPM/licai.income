/*------------------------------------------------------------------------
 Filename       : 	JsonXmlParserObj.h
 
 Description	:   自定义的一个类：封装了json解析的相关操作。
 
 Author         :   lzq,lvzhuqiang@ytinfo.zj.cn
 
 Date           :   2012-06-12
 
 version        :   v1.0
 
 Copyright      :   2012年 ytinfo. All rights reserved.
 
 ------------------------------------------------------------------------*/



#import "JsonXmlParserObj.h"


@implementation JsonXmlParserObj


- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        m_oraJsonDict = nil;
        m_oraJsonArray = nil;
        m_oraParseDict = nil;
        m_blResult = YES;
    }
    return self;
}

//释放内存
-(void)dealloc
{
    NSLog(@"dataset is dealloc");
   
}

//设置操作结果
-(void)setOpeResult:(bool)blResult
{
    m_blResult = blResult;
}

//获取操作结果
-(bool)getOpeResult
{
    return  m_blResult;
}

//解析原始的消息体
-(bool)parseOraJsonDict:(NSDictionary*)oraJsonDict
{
    m_blResult = NO;
    
    if(oraJsonDict == nil)
        return NO;
    if(oraJsonDict.count < 1)
        return NO;
    
    m_oraParseDict = oraJsonDict;
    
    NSString* strOperFlag = [self getRightJsonKeyValue:[oraJsonDict objectForKey:@"operFlag"]];
    
    if([strOperFlag isEqualToString:@"1"] == YES)
    {
        m_blResult = YES;
    }
    //获取实际的data的结构体
    if([[oraJsonDict objectForKey:@"data"] isKindOfClass:[NSArray class]] == YES)
    {
        m_oraJsonArray = [oraJsonDict objectForKey:@"data"];
    }
    else
    {
        m_oraJsonDict = [oraJsonDict objectForKey:@"data"];
    }
    
    
    return m_blResult;
}


//根据关键字，解析对应的值
-(QDataSetObj*)parsetoDataSet:(NSString*)strKey
{
    if(m_oraJsonDict == nil && m_oraJsonArray == nil)
        return nil;

    if( strKey.length < 1 || [strKey isEqualToString:@"data"] == YES)
    {
        if(m_oraJsonDict != nil)
        {
            return [self parseDictListDataSet:m_oraJsonDict];
        }
        
        if(m_oraJsonArray != nil)
        {
            if(m_oraJsonArray.count < 1)
                return nil;
            return [self parseArrayListDataSet:m_oraJsonArray];
        }
        return nil;
    }
    if(m_oraJsonDict != nil)
    {
        if([[m_oraJsonDict objectForKey:strKey] isKindOfClass:[NSArray class]] == YES)
        {
            return [self parseArrayList_Lev1:strKey];
        }
    }
    if(m_oraJsonArray != nil)
    {
        if(m_oraJsonArray.count > 0)
        {
            return [self parseDictList_Lev1:strKey];
        }
    }
    
    return nil;
}

//解析array类型多行数据
-(QDataSetObj*)parseArrayList_Lev1:(NSString*)strKey
{
    if(m_oraJsonDict == nil)
        return nil;
    if(m_oraJsonDict.count < 1)
        return nil;
    if([[m_oraJsonDict objectForKey:strKey] isKindOfClass:[NSArray class]] == NO)
    {
        return nil;
    }
    
    NSArray* arItemList = [m_oraJsonDict objectForKey:strKey];
    if(arItemList == nil)
        return nil;

    QDataSetObj* pDataSet = [self parseArrayListDataSet:arItemList];
    return pDataSet;
}


//解析Array的数据
-(QDataSetObj*)parseArrayListDataSet:(NSArray*)arItemList
{
 
    if(arItemList.count < 1)
        return nil;
    if([[arItemList objectAtIndex:0] isKindOfClass:[NSDictionary class]] == NO)
    {
        return nil;
    }
    QDataSetObj* pDataSet = [[QDataSetObj alloc] init];
    int iRowIndex = -1;
    for (NSDictionary *jsonObj in arItemList)
    {
        
        NSArray *arKeys= [jsonObj allKeys];
        if(arKeys.count < 1)
            break;
        iRowIndex++;
        for (NSString *strkey in arKeys)
        {
            //如果Array里面的数据，还有NsArray的，则需要另外解析
            if([[jsonObj objectForKey:strkey] isKindOfClass:[NSArray class]] == YES)
            {
                NSMutableArray*arArray = [jsonObj objectForKey:strkey];
                if(arArray.count < 1)
                    continue;
                //解析Array里面嵌套的第二层的Array数据
                [self paserOneLineArrayJsonData:pDataSet andRow:iRowIndex andKey:strkey andArray:arArray];
                continue;
            }
            else if([[jsonObj objectForKey:strkey] isKindOfClass:[NSDictionary class]] == YES)//字典里面嵌套了字典类型的数据
            {
                NSDictionary* dictObj =  [jsonObj objectForKey:strkey];
                NSArray *arSonKeys = [dictObj allKeys];
                if(arSonKeys.count < 1)
                    break;
                NSString* strFieldName  = [NSString stringWithFormat:@"%@_count",strkey];
                //添加子数据的总的数量
                [pDataSet addDataSetRow_Ext:iRowIndex andName:strFieldName andValue:[NSString stringWithFormat:@"%d",arSonKeys.count]];
                //继续添加嵌套的字典类型的数据
                for (NSString *strSonkey in arSonKeys)
                {
                    strFieldName = [NSString stringWithFormat:@"%@_%@",strkey,strSonkey];
                    if([[dictObj objectForKey:strSonkey] isKindOfClass:[NSDictionary class]] == YES)//第三层字典类型的数据
                    {
                        NSDictionary* sonDict = [dictObj objectForKey:strSonkey];
                        [self paserOneLineDictJsonData:pDataSet andRow:iRowIndex andKey:strFieldName andArray:sonDict];
                        continue;
                    }
                    NSString* strValue = [dictObj objectForKey:strSonkey];
                     //具体类型在里面进行判断
                    [pDataSet addDataSetRow_Ext:iRowIndex andName:strFieldName andValue:strValue];
                }
                continue;
                
            }
            //不是数组和字典的，直接添加即可
            NSString* strValue = [jsonObj objectForKey:strkey];
            [pDataSet addDataSetRow_Ext:iRowIndex andName:strkey andValue:strValue];
        }
        
    }
    if(pDataSet)
    {
        [pDataSet setOpeResult:m_blResult];
    }
    
    return pDataSet;
}


//解析字典类型的类型单行数据
-(QDataSetObj*)parseDictList_Lev1:(NSString*)strKey
{
    
    if(m_oraJsonDict == nil)
        return nil;
    if(m_oraJsonDict.count < 1)
        return nil;
    if([[m_oraJsonDict objectForKey:strKey] isKindOfClass:[NSDictionary class]] == NO)
    {
        return nil;
    }
    
    NSDictionary* jsonDict = [m_oraJsonDict objectForKey:strKey];
    QDataSetObj* pDataSet = [self parseDictListDataSet:jsonDict];

    return pDataSet;
}

//解析dict数据
-(QDataSetObj*)parseDictListDataSet:(NSDictionary*)jsonDict
{
    NSArray *arKeys= [jsonDict allKeys];
    if(arKeys.count < 1)
        return nil;
    QDataSetObj* pDataSet = [[ QDataSetObj alloc] init];
    for (NSString *strkey in arKeys)
    {
        //如果Array里面的数据，还有NsArray的，则需要另外解析
        if([[jsonDict objectForKey:strkey] isKindOfClass:[NSArray class]] == YES)
        {
            NSMutableArray*sonArList = [jsonDict objectForKey:strkey];
            if(sonArList.count < 1)
                continue;
            //解析Array里面嵌套的第二层的Array数据
            [self paserOneLineArrayJsonData:pDataSet andRow:0 andKey:strkey andArray:sonArList];
            continue;
        }
        else if([[jsonDict objectForKey:strkey] isKindOfClass:[NSDictionary class]] == YES)//字典里面嵌套了字典类型的数据
        {
            NSDictionary* sonDict =  [jsonDict objectForKey:strkey];
            NSArray *arSonKeys = [sonDict allKeys];
            if(arSonKeys.count < 1)
                break;
            NSString* strFieldName  = [NSString stringWithFormat:@"%@_count",strkey];
            //添加子数据的总的数量
            [pDataSet addDataSetRow_Ext:0 andName:strFieldName andValue:[NSString stringWithFormat:@"%d",arSonKeys.count]];
            //继续添加嵌套的字典类型的数据
            for (NSString *strSonkey in arSonKeys)
            {
                strFieldName = [NSString stringWithFormat:@"%@_%@",strkey,strSonkey];
                if([[sonDict objectForKey:strSonkey] isKindOfClass:[NSDictionary class]] == YES)//第三层字典类型的数据
                {
                    NSDictionary* sonDict2 = [sonDict objectForKey:strSonkey];
                    [self paserOneLineDictJsonData:pDataSet andRow:0 andKey:strFieldName andArray:sonDict2];
                    continue;
                }
                NSString* strValue = [sonDict objectForKey:strSonkey];
                //具体类型在里面进行判断
                [pDataSet addDataSetRow_Ext:0 andName:strFieldName andValue:strValue];
            }
            continue;
            
        }
        //不是数组和字典的，直接添加即可
        NSString* strValue = [jsonDict objectForKey:strkey];
        [pDataSet addDataSetRow_Ext:0 andName:strkey andValue:strValue];
    }
    if(pDataSet)
    {
        [pDataSet setOpeResult:m_blResult];
    }
    return pDataSet;
}

//解析Array里面嵌套的第二层的Array数据
-(void)paserOneLineArrayJsonData:(QDataSetObj*)pDataSet andRow:(NSInteger)iRow andKey:(NSString*)strLineName andArray:(NSMutableArray*)mtJsonData
{
    
    if(mtJsonData == nil)
        return;
    if(mtJsonData.count < 1)
        return;
    
    //记录记录的行数
    NSString* strFieldName = [NSString stringWithFormat:@"%@_count",strLineName];
    [pDataSet addDataSetRow_Ext:iRow andName:strFieldName andValue:[NSString stringWithFormat:@"%d",mtJsonData.count]];
    //继续添加子数据
    for(int i=0;i<mtJsonData.count;i++)
    {
        strFieldName = [NSString stringWithFormat:@"%@_%d",strLineName,i];

        if([[mtJsonData objectAtIndex:i] isKindOfClass:[NSArray class]]== YES)//处理NSArray的数据类型，即数据类型为数组里面套数组
        {
            
            NSMutableArray*arArray = [mtJsonData objectAtIndex:i];
            if(arArray.count < 1)
                continue;
            strFieldName = [NSString stringWithFormat:@"%@_%d_count",strLineName,i];
            [pDataSet addDataSetRow_Ext:iRow andName:strFieldName andValue:[NSString stringWithFormat:@"%d",arArray.count]];
            for(int j=0;j<arArray.count;j++)
            {
                NSString* strValue = [arArray objectAtIndex:j];
                strFieldName = [NSString stringWithFormat:@"%@_%d_%d",strLineName,i,j];
                [pDataSet addDataSetRow_Ext:iRow andName:strFieldName andValue:strValue];
            }
            continue;
        }
        else if([[mtJsonData objectAtIndex:i] isKindOfClass:[NSDictionary class]]== YES)//处理NSDictionary类型的数据,即数组里面套字典类型
        {
            NSDictionary* jsonObj = [mtJsonData objectAtIndex:i];
            NSArray *arKeys=[jsonObj allKeys];
            if(arKeys.count < 1)
                break;
            for (NSString *strkey in arKeys)
            {
                strFieldName = [NSString stringWithFormat:@"%@_%@_%d",strLineName,strkey,i];
                
                if([[jsonObj objectForKey:strkey] isKindOfClass:[NSDictionary class]] == YES)//再嵌套字段类型的
                {
                    NSDictionary* sonDictObj = [jsonObj objectForKey:strkey];
                    if(sonDictObj.count < 1)
                        continue;
                    NSArray* arSongKeyList = [sonDictObj allKeys];
                    
                    for(NSString* strSonKeyName in arSongKeyList)
                    {
                        NSString* strSonFieldName = [NSString stringWithFormat:@"%@_%@",strFieldName,strSonKeyName];
                        NSString* strSonKeyValue = [sonDictObj objectForKey:strSonKeyName];
                        //具体类型在里面进行判断
                        [pDataSet addDataSetRow_Ext:iRow andName:strSonFieldName andValue:strSonKeyValue];
                    }
                }
                else if([[jsonObj objectForKey:strkey] isKindOfClass:[NSArray class]] == YES)
                {
                    //
                }
                else
                {
                    NSString* strValue = [jsonObj objectForKey:strkey];
                    //具体类型在里面进行判断
                    [pDataSet addDataSetRow_Ext:iRow andName:strFieldName andValue:strValue];
                }

            }
            continue;
        }
        //其他类型的会自动判断
        NSString* strValue = [mtJsonData objectAtIndex:i];
        [pDataSet addDataSetRow_Ext:iRow andName:strFieldName andValue:strValue];
        
    }
    
}

//解析指定行的字典类型的数据，一般是第三层嵌套
-(void)paserOneLineDictJsonData:(QDataSetObj*)pDataSet andRow:(NSInteger)iRow andKey:(NSString*)strLineName andArray:(NSDictionary*)dictJsonData
{
    

    NSArray *arKeys = [dictJsonData allKeys];
    if(arKeys.count < 1)
        return;
    //添加字典数据的总数
    NSString* strFieldName = [NSString stringWithFormat:@"%@_count",strLineName];
    [pDataSet addDataSetRow_Ext:iRow andName:strFieldName andValue:[NSString stringWithFormat:@"%d",arKeys.count]];
    //继续添加子数据
    for (NSString *strKey in arKeys)
    {
        if([[dictJsonData objectForKey:strKey] isKindOfClass:[NSDictionary class]] == NO)//暂时接解析到第三层
        {
            NSString* strValue = [dictJsonData objectForKey:strKey];
            strFieldName = [NSString stringWithFormat:@"%@_%@",strLineName,strKey];
            //具体类型在里面进行判断
            [pDataSet addDataSetRow_Ext:iRow andName:strFieldName andValue:strValue];
        }
    }

}

//获取字段数据类型中指定KEY对应的值
-(NSString*)getJsonValueByKey:(NSString*)strKey
{
    if(m_oraParseDict == nil)
        return @"";

    
    NSString* strKeyValue = [m_oraParseDict objectForKey:strKey];
    strKeyValue = [self getRightJsonKeyValue:strKeyValue];
    
    return strKeyValue;
}

//获取指定key对应的值
-(NSString*)getDictJsonValueByKey:(NSString*)strKey
{
    if(m_oraJsonDict == nil)
        return @"";
    
    
    NSString* strKeyValue = [m_oraJsonDict objectForKey:strKey];
    strKeyValue = [self getRightJsonKeyValue:strKeyValue];
    
    return strKeyValue;
}

//解析实际的json的数据类型，转换成NSString类型返回
-(NSString*)getRightJsonKeyValue:(NSString*)strJsonValue
{
    NSString* strParseValue = strJsonValue;
    if(strJsonValue == nil)
        strParseValue = @"";
    else if([strJsonValue isKindOfClass:[NSNull class]] == true)
        strParseValue = @"";
    else if([strJsonValue isKindOfClass:[NSNumber class]] == true)
    {
        const char * pObjCType = [((NSNumber*)strJsonValue) objCType];
        if (strcmp(pObjCType, @encode(int))  == 0) {
            
            int iValue = strJsonValue.intValue;
            strParseValue = [NSString stringWithFormat:@"%d",iValue];

        }
        else  if (strcmp(pObjCType, @encode(float)) == 0) {
            float fValue = strJsonValue.floatValue;
            strParseValue = [NSString stringWithFormat:@"%.2f",fValue];

        }
        else if (strcmp(pObjCType, @encode(double))  == 0) {
            
            float fValue = strJsonValue.floatValue;
            strParseValue = [NSString stringWithFormat:@"%.2f",fValue];
        }
        else if (strcmp(pObjCType, @encode(BOOL)) == 0) {
            
            bool blValue = [strJsonValue boolValue];
            if(blValue == true)
                strParseValue = @"1";
            else
                strParseValue = @"0";

        }else if (strcmp(pObjCType, @encode(long)) == 0)
        {
            int iValue = strJsonValue.intValue;
            strParseValue = [NSString stringWithFormat:@"%d",iValue];
        }
        else
        {
            //主要是有些数字，会用""，以字符串的方式
            int iValue = strJsonValue.intValue;
            strParseValue = [NSString stringWithFormat:@"%d",iValue];
        }
    }
    return strParseValue;
}

@end
