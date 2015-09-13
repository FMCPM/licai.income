/*------------------------------------------------------------------------
 Filename       : 	SetRowObj.h
 
 Description	:   自定义的一个类：封装了对于WebService返回的结果集中“行”的相关属性和操作。
 
 Author         :   lzq,lvzhuqiang@ytinfo.zj.cn
 
 Date           :   2012-06-12
 
 version        :   v1.0
 
 Copyright      :   2012年 ytinfo. All rights reserved.
 
 ------------------------------------------------------------------------*/

#import <Foundation/Foundation.h>

@interface SetRowObj : NSObject <NSCoding, NSCopying>
{
    NSMutableDictionary* m_dictSetRow; //数据集中行记录信息的封装
    NSInteger   m_iRowIndex;
    NSMutableData* m_imgDataStream; //图片的STREAM
}
//获取行记录中列的数量
-(NSInteger)getFieldCount;
//添加一个列的信息
-(void)addFieldObj:(NSString*)strFieldName andValue:(NSString*)strFiledValue;
-(void)appendingVaileFromFieldObj:(NSString*)strFieldName andValue:(NSString*)strFiledValue;
//获取指定列（根据列的名称）的值
-(NSString*)getFieldValue:(NSString*)strFieldName;
//设置指定的列的值
-(void)setFieldValue:(NSString*)strFieldName andValue:(NSString*)strFieldValue;

//设置这个行的编号
-(void)setRowIndex:(NSInteger)iNewIndex;
//设置对应的图片的数据流
-(void)setImageStream:(NSMutableData*)imgStream;
//获取对应的图片的数据流
-(NSMutableData*)getImageStream;
//获取对应的图片的数据流
-(NSMutableData*)getImageStream:(NSString*)strImgFieldName;
//释放图片的数据流
-(void)closeImageStream;
//打印行纪录
-(void)printLineData;

@end
