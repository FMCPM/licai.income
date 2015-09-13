/*------------------------------------------------------------------------
 Filename       : 	SetRowObj.cpp
 
 Description	:   自定义的一个类：封装了对于WebService返回的结果集中“行”的相关属性和操作。
 
 Author         :   lzq,lvzhuqiang@ytinfo.zj.cn
 
 Date           :   2012-06-12
 
 version        :   v1.0
 
 Copyright      :   2012年 ytinfo. All rights reserved.
 
 ------------------------------------------------------------------------*/

#import "SetRowObj.h"
#import "ImgFileMethod.h"

@implementation SetRowObj

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        m_dictSetRow = [[NSMutableDictionary alloc] init];
        m_iRowIndex  = -1;
        m_imgDataStream = NULL;
       
    }
    return self;
}

//释放内存
-(void)dealloc
{
    NSLog(@"delloc row(%d)",m_iRowIndex);
    [m_dictSetRow removeAllObjects];
}

//获取行记录中列的数量
-(NSInteger)getFieldCount
{
    if(m_dictSetRow == NULL)
        return 0;
    
    return [m_dictSetRow count];
}
/*------------------------------------------------------------------------
 Function    :addResultObj
 Description :行记录中添加一个列的信息
 Params      :
    strFieldName：列的名称
    strFiledValue：列的值
 Result      :void
 Author      :lzq,lvzhuqiang@ytinfo.zj.cn
 DateTime    :2012-06-12
 ------------------------------------------------------------------------*/

-(void)addFieldObj:(NSString*)strFieldName andValue:(NSString*)strFiledValue
{
    if(m_dictSetRow == NULL)
        return ;
    if([strFiledValue isKindOfClass:[NSNull class]])
    {
        strFiledValue = @"";
    }
    else if([strFiledValue isKindOfClass:[NSNumber class]])
    {
        NSInteger iValue = strFiledValue.intValue;
        strFiledValue = [NSString stringWithFormat:@"%d",iValue];
    }
    
    [m_dictSetRow setObject:strFiledValue forKey:strFieldName];
}
/*------------------------------------------------------------------------
 Function    :appendingVaileFromFieldObj
 Description :行记录中接续一个列的信息，如果原本该列不存在，先创建一个
 Params      :
 strFieldName：列的名称
 strFiledValue：列的值
 Result      :void
 Author      :jjc,jiangjunchen@ytinfo.zj.cn
 DateTime    :2012-12-21
 ------------------------------------------------------------------------*/
-(void)appendingVaileFromFieldObj:(NSString*)strFieldName andValue:(NSString*)strFiledValue
{
    if(m_dictSetRow == NULL)
        return ;
    NSString *str = (NSString*)[m_dictSetRow objectForKey:strFieldName];
    if (str) {
        strFiledValue = [str stringByAppendingString:strFiledValue];
    }
    [m_dictSetRow setObject:strFiledValue forKey:strFieldName];
}

/*------------------------------------------------------------------------
 Function    :getFieldValue
 Description :获取指定列（根据列的名称）的值
 Params      :
    strFieldName：列的名称
 Result      :返回列的值
 Author      :lzq,lvzhuqiang@ytinfo.zj.cn
  DateTime    :2012-06-12
 ------------------------------------------------------------------------*/
-(NSString*)getFieldValue:(NSString*)strFieldName
{
    NSString* strFieldValue = [m_dictSetRow objectForKey:strFieldName];
    if(strFieldValue == NULL)
    {
        return @"";
    }

    return strFieldValue;
    
}


//设置指定的列的值
-(void)setFieldValue:(NSString*)strFieldName andValue:(NSString*)strFieldValue
{
    NSString* strValue = [m_dictSetRow objectForKey:strFieldName];
    if(strValue == nil)
    {
        [self addFieldObj:strFieldName andValue:strFieldValue];
        return ;
    }
    [m_dictSetRow setObject:strFieldValue forKey:strFieldName];
}


-(void)setRowIndex:(NSInteger)iNewIndex
{
    m_iRowIndex = iNewIndex;
}


//设置对应的图片的数据流
-(void)setImageStream:(NSMutableData*)imgStream
{
    m_imgDataStream = nil;
   // m_imgDataStream = imgStream;
}


//获取对应的图片的数据流
-(NSMutableData*)getImageStream
{
    return m_imgDataStream;

}
//获取对应的图片的数据流
-(NSMutableData*)getImageStream:(NSString*)strImgFieldName
{
    
    NSString* strImgUrl = [self getFieldValue:strImgFieldName];
    if(strImgUrl.length < 1)
        return nil;
    
    ImgFileMethod* pMethod = [[ImgFileMethod alloc] init];
    m_imgDataStream = [pMethod getImageDataFromLocal:strImgUrl];
    return m_imgDataStream;

}

//释放图片的数据流
-(void)closeImageStream
{
    m_imgDataStream = nil;
}

//打印行
-(void)printLineData
{

    NSArray *arKeys=[m_dictSetRow allKeys];
    if(arKeys.count < 1)
        return;

    for (NSString *strkey in arKeys)
    {
        
        NSString* strValue = [m_dictSetRow objectForKey:strkey];
        NSLog(@"Line%d->Name=%@,value=%@",m_iRowIndex,strkey,strValue);
        
    }
}
#pragma NSCopying delegate and NSCoding delegate
#pragma mark- NSCoding delegate
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:m_dictSetRow forKey:@"m_dictSetRow"];
    [aCoder encodeInteger:m_iRowIndex forKey:@"m_iRowIndex"];
    [aCoder encodeObject:m_imgDataStream forKey:@"m_imgDataStream"];
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        m_dictSetRow = [aDecoder decodeObjectForKey:@"m_dictSetRow"];
        m_iRowIndex = [aDecoder decodeIntegerForKey:@"m_iRowIndex"];
        m_imgDataStream = [aDecoder decodeObjectForKey:@"m_imgDataStream"];
    }
    return self;
}
-(id)copyWithZone:(NSZone *)zone
{
    SetRowObj *copy = [[[self class] allocWithZone:zone] init];
    copy->m_dictSetRow = [m_dictSetRow copy];
    copy->m_iRowIndex = m_iRowIndex;
    copy->m_imgDataStream = [m_imgDataStream copy];
    return copy;
}
@end
