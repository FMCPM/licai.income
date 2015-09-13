//
//  WebServiceMethod.m
//  ahdxyp
//
//  Created by ytinfo ytinfo on 12-6-8.
//  Copyright 2012年 ytinfo. All rights reserved.
//

#import "WebServiceMethod.h"
#import "UaConfiguration.h"
#import "GlobalDefine.h"

@implementation WebServiceMethod


- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        m_pWebDataSet = NULL;
        m_iCurRowIndex= -1;
        m_isFinished  = TRUE;
    }


    return self;
}


/*------------------------------------------------------------------------
 Function    :submitWebServiceMethod
 Description :向服务端提交具体的webService方法
 Params      :
    strBodyValue:具体的webservice方法的消息体
    strMethodName:具体webservice方法的名称
 Result      :void
 Author      :lzq,lvzhuqiang@ytinfo.zj.cn
 DateTime    :2012-06-05
 ------------------------------------------------------------------------*/

-(NSInteger)submitWebServiceMethod:(NSString*)strBodyValue andMethodName:(NSString*)strMethodName
{
    //webservice完整的Url
	NSURL *strServiceUrl = [NSURL URLWithString:[UaConfiguration sharedInstance].m_strSoapRequestUrl_1];
    //webservice的IP和端口号
    NSURL<NSCopying> *soapIpAddr = [strServiceUrl URLByDeletingLastPathComponent];

     
    NSString* strSoapMsg = [NSString stringWithFormat: 
                            @ "<?xml version=\"1.0\" encoding=\"utf-8\"?> \n"
                            "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n" 
                            "<soap:Body> \n"
                            "<%@ xmlns=\"%@\"> \n"
                            "%@"
                            "</%@> \n"
                            "</soap:Body> \n"
                            "</soap:Envelope> \n"
                            
                            ,strMethodName,soapIpAddr,strBodyValue,strMethodName];



    //NSURL *strServiceUrl = [[NSURL alloc]initWithString:@"http://60.13.166.195/SmsWebService/SmsWebService.asmx"];


    //默认超时时间为5秒
	NSMutableURLRequest *urlRequest =[NSMutableURLRequest requestWithURL:strServiceUrl cachePolicy:NSURLRequestUseProtocolCachePolicy  timeoutInterval:5.0];
        

	[urlRequest addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
   
   	NSString *strSoapAction = [NSString stringWithFormat:@"%@%@", soapIpAddr,strMethodName];
    
	[urlRequest addValue:strSoapAction forHTTPHeaderField:@"SOAPAction"];
    
    NSString *strMsgLen =[NSString stringWithFormat:@"%d", [strSoapMsg length]];
    [urlRequest addValue:strMsgLen forHTTPHeaderField:@"Content-Length"];
	[urlRequest setHTTPMethod:@"POST"];
	[urlRequest setHTTPBody:[strSoapMsg dataUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"soap is %@",strSoapMsg);

    //初始化url连接
	NSURLConnection* urlConnection =[[NSURLConnection alloc]initWithRequest:urlRequest delegate:self];
	//[soapMsg release];
	if (!urlConnection)
	{
        NSLog(@"the NSURLConntion is null");
  
        return  RET_FAIL;

	}
    m_webDataBuf =[NSMutableData data];
    m_isFinished = FALSE;

    return RET_OK;
}




/*------------------------------------------------------------------------
 Function    :didReceiveResponse
 Description :当服务器提供了足够客户程序创建NSURLResponse对象的信息时，代理对象会收到 
            一个connection：didReceiveResponse：消息，在消息内可以检查NSURLResponse 
            对象和确定数据的预期长途，mime类型，文件名以及其他服务器提供的元信息
 Params      :none
 Result      :void
 Author      :lzq,lvzhuqiang@ytinfo.zj.cn
 DateTime    :2012-06-05
 ------------------------------------------------------------------------*/
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	//[m_webDataBuf setLength: 0];

}


/*------------------------------------------------------------------------
 Function    :didReceiveData
 Description :当下载开始的时候，每当有数据接收，代理会定期收到connection：didReceiveData：消息,将新接收到的数据存储到缓存区中
 Params      :
    connection:url连接对象实例
    data:收到的数据
 Result      :void
 Author      :lzq,lvzhuqiang@ytinfo.zj.cn
 DateTime    :2012-06-05
 ------------------------------------------------------------------------*/
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[m_webDataBuf appendData:data];
    
}

/*------------------------------------------------------------------------
 Function    :didFailWithError
 Description :如果电脑没有连接网络，则出现此信息（不是网络服务器不通） 
 Params      :
    connection:url连接对象实例
    error:错误对象实例
 Result      :void
 Author      :lzq,lvzhuqiang@ytinfo.zj.cn
 DateTime    :2012-06-05
 ------------------------------------------------------------------------*/

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [connection cancel];
    NSLog(@"received error:%@",[error debugDescription]);
	m_webDataBuf = nil;
    m_isFinished = TRUE;
	connection = nil;

}
/*------------------------------------------------------------------------
 Function    :connectionDidFinishLoading
 Description :如果连接请求成功的下载，代理会接收connectionDidFinishLoading：消息,代理不会收到其他的消息了，在消息的实现中，应该释放掉连接 
 Params      :
    connection:url连接
 Result      :void
 Author      :lzq,lvzhuqiang@ytinfo.zj.cn
 DateTime    :2012-06-05
 ------------------------------------------------------------------------*/

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{

    //需要对字符串进行转换<>
	NSMutableString *strOraXML = [[NSMutableString alloc] initWithBytes: [m_webDataBuf mutableBytes] length:[m_webDataBuf length] encoding:NSUTF8StringEncoding];
    
    
    [strOraXML replaceOccurrencesOfString:@"&gt;" withString:@">" options:0 range:NSMakeRange(0, strOraXML.length)];
    [strOraXML replaceOccurrencesOfString:@"&lt;" withString:@"<" options:0 range:NSMakeRange(0, strOraXML.length)];
    
    NSRange startRange = [strOraXML rangeOfString:@"&amp;lt;"];
    NSRange EndRange = [strOraXML rangeOfString:@"/&amp;gt;"];
    while (startRange.location != NSNotFound) 
    {
        if (EndRange.location == NSNotFound) {
            break;
        }
        NSRange range = NSMakeRange(startRange.location, EndRange.location-startRange.location+EndRange.length);
        NSString *substring = [strOraXML substringWithRange:range];
        if ([substring rangeOfString:@"br"].location == NSNotFound) {
            [strOraXML replaceCharactersInRange:range withString:@""];
        }
        else {
            [strOraXML replaceCharactersInRange:range withString:@"\n"];
        }
        startRange = [strOraXML rangeOfString:@"&amp;lt;"];
        EndRange = [strOraXML rangeOfString:@"/&amp;gt;"];
    }
    NSLog(@"finish load:%@",strOraXML);
    m_isFinished = TRUE;
    
    
        
    
    /*
    
    //需要对字符串进行转换<>
	NSString *strOraXML = [[NSString alloc] initWithBytes: [m_webDataBuf mutableBytes] length:[m_webDataBuf length] encoding:NSUTF8StringEncoding];
	
    [m_webDataBuf release];
    
    NSString* strDestXml = [strOraXML stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    strDestXml = [strDestXml stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    [strOraXML release];
    //strDestXml会自动autorelease
    NSLog(@"finish load:%@",strDestXml);
     */
    if([strOraXML isEqual: @""])
    {
 //       m_isFinished = TRUE;
        connection = nil;
        return;
    }
		//重新加載xmlParser
	if( m_xmlParser )
	{
        m_xmlParser.delegate = nil;
        m_xmlParser = nil;
	}
 
    NSData* pXmlDataBuf = [strOraXML dataUsingEncoding: NSUTF8StringEncoding];	
	m_xmlParser = [[NSXMLParser alloc] initWithData: pXmlDataBuf];
    
	[m_xmlParser setDelegate: self];
	[m_xmlParser setShouldResolveExternalEntities: YES];
	[m_xmlParser parse];
	//释放url connection
    [connection cancel];
    connection = nil;
}


//解析开始解析的时间，一般不需要处理
- (void)parserDidStartDocument:(NSXMLParser *)parser
{
	//NSLog(@"-------------------start--------------");
}
/*------------------------------------------------------------------------
 Function    :didStartElement
 Description :开始读取每个xml元素
 Params      :
    elementName:元素的名称
 Result      :void
 Author      :lzq,lvzhuqiang@ytinfo.zj.cn
 DateTime    :2012-06-12
 ------------------------------------------------------------------------*/

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *)qName
   attributes: (NSDictionary *)attributeDict
{
    m_blReadXmlElement = FALSE;
   // NSLog(@"start element is %@",elementName);
	//返回记录操作结果的int型的值
	if( [elementName isEqualToString:@"int"])
    {
        m_pWebDataSet = [[QDataSetObj alloc] init];
        [m_pWebDataSet setDataSetType:3];
        m_iCurRowIndex= 0;
        m_strCurXmlIDName=@"intResult";
        m_blReadXmlElement=TRUE;
        
    }
    else if([elementName isEqualToString:@"boolean"])//返回记录操作结果的bool型的值
	{
        m_pWebDataSet = [[QDataSetObj alloc] init];
        [m_pWebDataSet setDataSetType:4];
        m_iCurRowIndex= 0;
        m_strCurXmlIDName=@"boolResult";
        m_blReadXmlElement=TRUE;

	}    
    else if([elementName isEqualToString:@"NewDataSet"])//返回标准数据集
    {
         m_pWebDataSet = [[QDataSetObj alloc] init];
         [m_pWebDataSet setDataSetType:1];
         m_strCurXmlIDName = @"";
    }
	else if([elementName isEqualToString:@"ds"])//数据集中行的标识符(xml元素)
    {
         m_iCurRowIndex++;
         m_strCurXmlIDName = @"";
    }
    else
    {
         m_strCurXmlIDName = elementName;
         m_blReadXmlElement=TRUE;
    }
}

/*------------------------------------------------------------------------
 Function    :foundCharacters
 Description :读取一个xml元素对应的值的消息处理
 Params      :
    string:元素的值
 Result      :void
 Author      :lzq,lvzhuqiang@ytinfo.zj.cn
 DateTime    :2012-06-12
 ------------------------------------------------------------------------*/
-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    
}
-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if(m_pWebDataSet == NULL)
        return;
    if(m_iCurRowIndex < 0)
        return ;
    if([m_strCurXmlIDName isEqualToString:@""])
        return ;
    if(m_blReadXmlElement == FALSE)
        return ;
    if([string isEqual: @""])
        return ;
   // NSLog(@"foundchar:name=%@;value=%@",m_strCurXmlIDName,string);
    if([string isEqualToString:@"\n"])
        return;
    
  //  NSString*strAddFieldName = [[NSString alloc] initWithString:m_strCurXmlIDName];
 //   NSString*strAddFieldValue= [[NSString alloc] initWithString:string];
    //[m_pWebDataSet addDataSetRow_Ext:m_iCurRowIndex andName:strAddFieldName andValue:strAddFieldValue];
    [m_pWebDataSet addDataSetRow_Ext:m_iCurRowIndex andName:m_strCurXmlIDName andValue:string];
    

 //   [strAddFieldName release];
 //   [strAddFieldValue release];
}
/*------------------------------------------------------------------------
 Function    :didEndElement
 Description :读取每个xml元素结束位置时的消息处理
 Params      :
 string:元素的值
 Result      :void
 Author      :lzq,lvzhuqiang@ytinfo.zj.cn
 DateTime    :2012-06-12
 ------------------------------------------------------------------------*/

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
//	NSLog(@"didend element:%@",elementName);
	//返回记录操作结果的int型的值
	if( [elementName isEqualToString:@"int"])
    {
        m_iCurRowIndex = -1;
        
    }
    else if([elementName isEqualToString:@"boolean"])//返回记录操作结果的bool型的值
	{
       m_iCurRowIndex = -1;
         
	}    
    else if([elementName isEqualToString:@"NewDataSet"])//返回标准数据集
    {
        m_iCurRowIndex = -1;
    }
	
	m_blReadXmlElement = FALSE;
}
/*------------------------------------------------------------------------
 Function    :parserDidEndDocument
 Description :整个xml文件解析完成后的消息处理
 Params      :none
 Result      :void
 Author      :lzq,lvzhuqiang@ytinfo.zj.cn
 DateTime    :2012-06-12
 ------------------------------------------------------------------------*/
- (void)parserDidEndDocument:(NSXMLParser *)parser
{
	m_isFinished = TRUE;
    m_xmlParser = nil;

	
}
//是否结束解析
-(BOOL)isFinished
{
    return  m_isFinished;
}

//获取存储操作结果的数据集
-(QDataSetObj*)getResultDataSet
{
    return  m_pWebDataSet;
}




@end
