/*------------------------------------------------------------------------
 Filename       : 	QDataSetObj.h
 
 Description	:   自定义的一个类：封装了对于WebService返回的结果集DataSet的相关属性和方法，提供类似标准的DataSet的相关操作。
 
 Author         :   lzq,lvzhuqiang@ytinfo.zj.cn
 
 Date           :   2012-06-12
 
 version        :   v1.0

 ------------------------------------------------------------------------*/


#import <Foundation/Foundation.h>
#import "SetRowObj.h"

#define IfDebug 1

@interface QDataSetObj : NSObject<NSCoding,NSCopying>
{
    //存储返回结果的集合（数组）
    NSMutableArray* m_dictWebDataSet;
    //1_返回多行的数据集;2_只有一行记录的数据集;3_返回int类型的操作结果的数据集;4_返回bool型操作结果的数据集
    NSInteger   m_iDataSetType;    
    //操作结果
    bool        m_blOpeResult;
    
    NSString*   m_strErrorText;
}
//设置操作结果
-(void)setOpeResult:(bool)blResult;
//获取操作结果
-(bool)getOpeResult;
//获取错误的详情
-(NSString*)getErrorText;
//添加一行记录
-(void)addDataSetRow:(SetRowObj*)newRowObj;
//在指定位置插入一行记录
-(void)insertDataSetRow:(SetRowObj*)newRowObj andIndex:(NSInteger)iIndex;
//添加一行记录
-(void)addDataSetRow_Ext:(NSInteger)iRowIndex andName:(NSString*)strFieldName andValue:(NSString*)strFieldValue;
//删除一行纪录
-(BOOL)removeDataSetRowAtRowIndex:(NSInteger)index;
//获取指定行的数据
-(SetRowObj*)getRowObj:(NSInteger)iIndex;
//设置数据集的类型
-(void)setDataSetType:(NSInteger)iType;
//获取数据集中记录的行数
-(NSInteger)getRowCount;
//获取指定行记录的值
-(NSString*)getFeildValue:(NSInteger)iRowIndex andColumn:(NSString*)strFieldName;
-(float)getFeildValue_Float:(NSInteger)iRowIndex andColumn:(NSString*)strFieldName;
-(int)getFeildValue_Int:(NSInteger)iRowIndex andColumn:(NSString*)strFieldName;
//获取指定行的图片的数据流
-(NSMutableData*)getImageStreamData:(NSInteger)iRowIndex;
//获取指定行的图片的数据流
-(NSMutableData*)getImageStreamData:(NSInteger)iRowIndex andImgField:(NSString*)strImgFieldName;
//关闭图片流
-(void)closeImageStreamData:(NSInteger)iRowIndex;
//设置某个字段的值
-(void)setFieldValue:(NSInteger)iRowIndex andName:(NSString*)strName andValue:(NSString*)strValue;
//测试打印数据
-(void)printTestData;
//-------------------------静态方法----------------
//获取可以实现换行的字符串
+(NSString*)GetCanChangeLineString:(NSString*)strOraValue;
//是否为整形
+(BOOL)isPureInt:(NSString*)strValue;
//是否为浮点型
+(BOOL)isPureFloat:(NSString*)strValue;
//将字符串转换成整形
+(NSInteger)convertToInt:(NSString*)strValue;
//将字符串转换成浮点型
+(float)convertToFloat:(NSString*)strValue;
//判断是否超过指定的长度（一个中文字算3个单位长度）
+(bool)isBigMaxLength:(NSString*)strText andLength:(NSInteger)iMaxLen;
//判断是否含有中文字
+(bool)isHaveChineseFont:(NSString*)strText;
//获取浮点类型
+(NSString*)getFloatValueShow:(float)fValue;

@end
