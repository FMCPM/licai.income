//
//  WebServiceMethod.h
//  ahdxyp
//
//  Created by ytinfo ytinfo on 12-6-8.
//  Copyright 2012年 ytinfo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QDataSetObj.h"

@interface WebServiceMethod : NSObject<NSXMLParserDelegate>
{

    NSMutableData *m_webDataBuf;//webservice返回信息的存储区
    BOOL    m_isFinished;//用于标识webService方法是否已经从服务端返回结果
    NSXMLParser *m_xmlParser;//xml文本解析器
    QDataSetObj* m_pWebDataSet;//所有webservice返回结果都封装成统一的数据集
    NSInteger   m_iCurRowIndex;//当前操作的记录行的索引
    NSString*   m_strCurXmlIDName;//xml解析过程中，当前解析的xml元素的名称
    BOOL        m_blReadXmlElement;//标识是否在读取xml元素

}
//向服务端提交具体的webservice方法
-(NSInteger)submitWebServiceMethod:(NSString*)strBodyValue andMethodName:(NSString*)strMethodName;
//获取存储操作结果的数据集
-(QDataSetObj*)getResultDataSet;
//webservice操作是否结束
-(BOOL)isFinished;


@end
