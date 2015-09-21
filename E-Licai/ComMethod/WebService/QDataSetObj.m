/*------------------------------------------------------------------------
 Filename       : 	WebDataSetObj.cpp
 
 Description	:   自定义的一个类：封装了对于WebService返回的结果集DataSet的相关属性和方法，提供类似标准的DataSet的相关操作。
 
 Author         :   lzq,lvzhuqiang@ytinfo.zj.cn
 
 Date           :   2012-06-12
 
 version        :   v1.0
 
 Copyright      :   2012年 ytinfo. All rights reserved.
 
 ------------------------------------------------------------------------*/

#import "QDataSetObj.h"
#import "SetRowObj.h"

@implementation QDataSetObj


- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        m_dictWebDataSet = [[NSMutableArray alloc] init];
    }
    return self;
}

//释放内存
-(void)dealloc
{
    NSLog(@"dataset is dealloc");
    [m_dictWebDataSet removeAllObjects];
}

//设置操作结果
-(void)setOpeResult:(bool)blResult
{
    m_blOpeResult = blResult;
}

//获取操作结果
-(bool)getOpeResult
{
    return  m_blOpeResult;
}
//获取错误内容
-(NSString*)getErrorText
{

    return m_strErrorText;
    
}
//设置数据集的类型1_返回多行的数据集;2_只有一行记录的数据集;3_返回int类型的操作结果的数据集;4_返回bool型操作结果的数据集
-(void)setDataSetType:(NSInteger)iType
{
    m_iDataSetType = iType;
}

/*------------------------------------------------------------------------
 Function    :addDataSetRow
 Description :数据集中添加一行记录
 Params      :
    newRowObj:需要添加的行的记录的对象实例
 Result      :void
 Author      :lzq,lvzhuqiang@ytinfo.zj.cn
 DateTime    :2012-06-12
 ------------------------------------------------------------------------*/
-(void)addDataSetRow:(SetRowObj*)newRowObj
{
    if(m_dictWebDataSet == NULL)
        return ;
    if(newRowObj == NULL)
        return ;
    [m_dictWebDataSet addObject:newRowObj];
    
}

-(void)insertDataSetRow:(SetRowObj*)newRowObj andIndex:(NSInteger)iIndex
{
    if(m_dictWebDataSet == nil)
        return;
    if(m_dictWebDataSet.count == 0)
    {
        [m_dictWebDataSet addObject:newRowObj];
        return;
    }
    if(iIndex >= m_dictWebDataSet.count)
        return;
    
    [m_dictWebDataSet insertObject:newRowObj atIndex:iIndex];
}

/*------------------------------------------------------------------------
 Function    :addDataSetRow_Ext
 Description :数据集中添加一行记录
 Params      :
    iRowIndex:记录行的索引
    strFieldName:列的名称 
    strFieldValue:列的值
 Result      :void
 Author      :lzq,lvzhuqiang@ytinfo.zj.cn
 DateTime    :2012-06-12
 ------------------------------------------------------------------------*/

-(void)addDataSetRow_Ext:(NSInteger)iRowIndex andName:(NSString*)strFieldName andValue:(NSString*)strFieldValue
{
    if(iRowIndex < 0 )
        return ;
    if([strFieldValue isKindOfClass:[NSNull class]] == true)
        strFieldValue = @"";
    else if([strFieldValue isKindOfClass:[NSNumber class]] == true)
    {
        const char * pObjCType = [((NSNumber*)strFieldValue) objCType];
        if (strcmp(pObjCType, @encode(int))  == 0) {
            
            int iValue = strFieldValue.intValue;
            strFieldValue = [NSString stringWithFormat:@"%d",iValue];
            NSLog(@"字典中key=%@的值是int类型",strFieldName);
           // NSLog(@"字典中key=%@的值是int类型,值为%d",strKey,[strFieldValue intValue]);
        }
        else  if (strcmp(pObjCType, @encode(float)) == 0) {
            float fValue = strFieldValue.floatValue;
            strFieldValue = [NSString stringWithFormat:@"%.4f",fValue];
            NSLog(@"字典中key=%@的值是float类型",strFieldName);
        }
        else if (strcmp(pObjCType, @encode(double))  == 0) {
            
            float fValue = strFieldValue.floatValue;
            strFieldValue = [NSString stringWithFormat:@"%.4f",fValue];
            NSLog(@"字典中key=%@的值是doub类型",strFieldName);
            //NSLog(@"字典中key=%@的值是double类型,值为%f",key,[value doubleValue]);
        }
        else if (strcmp(pObjCType, @encode(BOOL)) == 0) {
            
            bool blValue = [strFieldValue boolValue];
            if(blValue == true)
                strFieldValue = @"1";
            else
                strFieldValue = @"0";
           // NSLog(@"字典中key=%@的值是bool类型,值为%i",key,[value boolValue]);
        }else if (strcmp(pObjCType, @encode(long)) == 0)
        {
            int iValue = strFieldValue.intValue;
            strFieldValue = [NSString stringWithFormat:@"%d",iValue];
            NSLog(@"字典中key=%@的值是long类型",strFieldName);
        }
        else
        {
            //主要是有些数字，会用""，以字符串的方式
            int iValue = strFieldValue.intValue;
            strFieldValue = [NSString stringWithFormat:@"%d",iValue];
            NSLog(@"字典中的key=%@未知数据类型，默认转换成int",strFieldName);
        }
    }
    int iRowCount = [self getRowCount];
    SetRowObj*pRowObj = NULL;
    if(iRowIndex < iRowCount )
    {
        pRowObj = [m_dictWebDataSet objectAtIndex:iRowIndex];
        if(pRowObj)
        {
            [pRowObj appendingVaileFromFieldObj:strFieldName andValue:strFieldValue];

        }
        return ;
    }
    if(pRowObj == NULL)
    {
        pRowObj = [[SetRowObj alloc] init];
        [m_dictWebDataSet addObject:pRowObj];
        [pRowObj setRowIndex:iRowIndex];
       // NSLog(@"add new row:%d;",iRowIndex);
    }
    [pRowObj addFieldObj:strFieldName andValue:strFieldValue];
    
}

/*------------------------------------------------------------------------
 Function    :removeDataSetRowAtRowIndex:
 Description :行记录中删除一个列的信息
 Params      :NSInteger
 Result      :返回记录的行数
 Author      :jjc,jiangjunchen@ytinfo.zj.cn
 DateTime    :2012-12-21
 ------------------------------------------------------------------------*/
-(BOOL)removeDataSetRowAtRowIndex:(NSInteger)index
{
    if (!m_dictWebDataSet)
        return NO;
    if (index<0 || index>m_dictWebDataSet.count)
        return NO;
    [m_dictWebDataSet removeObjectAtIndex:index];
    return YES;
}
/*------------------------------------------------------------------------
 Function    :getRowCount
 Description :行记录中添加一个列的信息
 Params      :none
 Result      :返回记录的行数
 Author      :lzq,lvzhuqiang@ytinfo.zj.cn
 DateTime    :2012-06-12
 ------------------------------------------------------------------------*/
-(NSInteger)getRowCount
{
    
    if(m_dictWebDataSet == NULL)
       return 0;
    int iRowCount = [m_dictWebDataSet count];
    return  iRowCount;
    
}

/*------------------------------------------------------------------------
 Function    :getRowCount
 Description :行记录中添加一个列的信息
 Params      :none
 Result      :返回记录的行数
 Author      :lzq,lvzhuqiang@ytinfo.zj.cn
 DateTime    :2012-06-12
 ------------------------------------------------------------------------*/
-(NSString*)getFeildValue:(NSInteger)iRowIndex andColumn:(NSString*)strFieldName
{
    
    int iRowCount = [self getRowCount];
    if(iRowIndex < 0 || iRowIndex >= iRowCount)
        return @"";
    
    SetRowObj*pRowObj = [m_dictWebDataSet objectAtIndex:iRowIndex];
    if(pRowObj == nil)
        return @"";
    
    NSString*strFieldValue =[pRowObj getFieldValue:strFieldName];
    if(strFieldValue == nil)
        return @"";
    return strFieldValue;
 
}

-(float)getFeildValue_Float:(NSInteger)iRowIndex andColumn:(NSString*)strFieldName
{
    NSString* strValue = [self getFeildValue:iRowIndex andColumn:strFieldName];
    
    float fValue = [QDataSetObj convertToFloat:strValue];
    
    return  fValue;
}

-(int)getFeildValue_Int:(NSInteger)iRowIndex andColumn:(NSString*)strFieldName
{
    NSString* strValue = [self getFeildValue:iRowIndex andColumn:strFieldName];
    
    int iValue = [QDataSetObj convertToInt:strValue];
    
    return  iValue;
}
//设置某个字段的值
-(void)setFieldValue:(NSInteger)iRowIndex andName:(NSString*)strName andValue:(NSString*)strValue
{
    int iRowCount = [self getRowCount];
    if(iRowIndex < 0 || iRowIndex >= iRowCount)
    {
        return ;
    }
    SetRowObj*pRowObj = [m_dictWebDataSet objectAtIndex:iRowIndex];
    if(pRowObj == NULL)
        return ;
    [pRowObj setFieldValue:strName andValue:strValue];
}
/*------------------------------------------------------------------------
 Function    :getRowCount
 Description :从数据集中获取相应位置的行记录
 Params      :
    iIndex:记录的索引
 Result      :返回指定位置的行记录
 Author      :lzq,lvzhuqiang@ytinfo.zj.cn
 DateTime    :2012-06-12
 ------------------------------------------------------------------------*/
//获取指定行的数据
-(SetRowObj*)getRowObj:(NSInteger)iIndex
{
    
    if(iIndex < 0)
        return NULL;
    int iRowCount = [self getRowCount];
    SetRowObj*pRowObj = NULL;
    if(iIndex < iRowCount )
    {
        pRowObj = [m_dictWebDataSet objectAtIndex:iIndex];
    }
    return pRowObj;
}

//获取指定行的图片的数据流
-(NSMutableData*)getImageStreamData:(NSInteger)iRowIndex
{
    SetRowObj* pRowObj = [self getRowObj:iRowIndex];
    if(pRowObj == NULL)
        return NULL;
    return  [pRowObj getImageStream];
}

//获取指定行的图片的数据流
-(NSMutableData*)getImageStreamData:(NSInteger)iRowIndex andImgField:(NSString*)strImgFieldName
{
    SetRowObj* pRowObj = [self getRowObj:iRowIndex];
    if(pRowObj == NULL)
        return NULL;
    return  [pRowObj getImageStream:strImgFieldName];
}

//关闭图片流
-(void)closeImageStreamData:(NSInteger)iRowIndex
{
    SetRowObj* pRowObj = [self getRowObj:iRowIndex];
    if(pRowObj == NULL)
        return ;
    [pRowObj closeImageStream];
}

#pragma mark- NSCoding delegate 
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:m_dictWebDataSet forKey:@"m_dictWebDataSet"];
    [aCoder encodeInteger:m_iDataSetType forKey:@"m_iDataSetType"];
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        m_dictWebDataSet = [aDecoder decodeObjectForKey:@"m_dictWebDataSet"];
        m_iDataSetType = [aDecoder decodeIntegerForKey:@"m_iDataSetType"];
    }
    return self;
}
-(id)copyWithZone:(NSZone *)zone
{
    QDataSetObj *copy = [[[self class] allocWithZone:zone] init];
    copy->m_iDataSetType = m_iDataSetType;
    copy->m_dictWebDataSet = [m_dictWebDataSet copy];
    return copy;
}

//测试打印数据
-(void)printTestData
{
    for(int i=0;i<m_dictWebDataSet.count;i++)
    {
        SetRowObj* pRowObj = [m_dictWebDataSet objectAtIndex:i];
        if(pRowObj)
        {
            [pRowObj printLineData];
        }
    }
 
}

//--------------静态方法-----------------------------

//获取可以实现换行的字符串，\r\n字符在存入数据库后，变成了实际的字符，所以需要转换成换行符号
+(NSString*)GetCanChangeLineString:(NSString*)strOraValue
{
    NSString*strValue = [strOraValue stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"\r\n"];
    
    strValue = [strValue stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
    return  strValue;
}


//判断是否为整形：
+(BOOL)isPureInt:(NSString*)strValue{
    if(strValue == nil)
        return false;
    if(strValue.length < 1)
        return  false;
    NSScanner* scan = [NSScanner scannerWithString:strValue];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

//判断是否为浮点形：
+(BOOL)isPureFloat:(NSString*)strValue{
    
    
    if(strValue == nil)
        return false;
    if(strValue.length < 1)
        return  false;
    NSScanner* scan = [NSScanner scannerWithString:strValue];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}

//将字符串转换成整形
+(NSInteger)convertToInt:(NSString*)strValue
{
    if([QDataSetObj isPureInt:strValue] == NO)
        return 0;
    if(strValue.length < 1)
        return 0;
    NSInteger iValue = strValue.integerValue;
    return iValue;
}

//将字符串转换成浮点型
+(float)convertToFloat:(NSString*)strValue
{
    if([QDataSetObj isPureFloat:strValue] == NO)
        return 0;
    if(strValue.length < 1)
        return 0;
    float fValue = strValue.floatValue;
    return fValue;
}

//判断是否超过指定的长度（一个中文字算3个单位长度）
+(bool)isBigMaxLength:(NSString*)strText andLength:(NSInteger)iMaxLen
{
    if(strText == nil)
        return false;
    const char* szText = [strText UTF8String];
    int iLen = strlen(szText);
    if(iLen > iMaxLen)
        return true;
    return false;
}

//判断是否含有中文字
+(bool)isHaveChineseFont:(NSString*)strText
{
    int iLength = [strText length];
    
    for (int i=0; i<iLength; ++i)
    {
        NSRange range = NSMakeRange(i, 1);
        NSString *subString = [strText substringWithRange:range];
        const char *cString = [subString UTF8String];
        if (strlen(cString) == 3)
        {
            return true;
        }
    }
    return false;
}


+(NSString*)getFloatValueShow:(float)fValue
{
    
    if(fValue == 0)
        return @"0";
    NSString* strValue = [NSString stringWithFormat:@"%.2f",fValue];
    NSArray* arValueList = [strValue componentsSeparatedByString:@"."];
    if(arValueList.count > 1)
    {
        NSString* strLeft = [arValueList objectAtIndex:1];
        if([strLeft isEqualToString:@"00"])
        {
            strValue = [arValueList objectAtIndex:0];
        }
    }
    return strValue;
}


@end
