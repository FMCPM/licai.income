//
//  CKHttpHelper.m
//  FJ-E-YellowPage
//
//  Created by jiangjunchen on 13-5-13.
//  Copyright (c) 2013年 ytinfo. All rights reserved.
//

#import "CKHttpHelper.h"

@implementation CKHttpHelper
@synthesize methodName = _methodName;
@synthesize baseUrl_1 = _baseUrl_1;
@synthesize completeBlock = _completeBlock;
@synthesize progressBlock = _progressBlock;
@synthesize startBlock = _startBlock;
@synthesize currentConnection = _currentConnection;
@synthesize isConnecting = _isConnecting;
@synthesize cachePolicy = _cachePolicy;
@synthesize timeout = _timeout;
@synthesize currentResponse = _currentResponse;
@synthesize m_iWebServerType = _iWebServerType;

static NSURL* g_baseUrl1 = nil;
static NSURL* g_baseUrl2 = nil;
static CKHttpParserBlock g_parserBlock = nil;
static CKHttpMethodType g_methodType = CKHttpMethodTypeSoap;
static CKHttpFailureBlock g_failureBlock;
static NSMutableDictionary *g_allPointers;
static CGFloat g_timeout = 60;

+(NSURL*)baseUrl1
{
    return g_baseUrl1;
}
+(NSURL*)baseUrl2
{
    return g_baseUrl2;
}

+(void)setBaseUrl:(NSURL *)baseUrl1 andUrl2:(NSURL*)baseUrl2
{
    Release(g_baseUrl1);
    g_baseUrl1 = [baseUrl1 copy];
    if(baseUrl2 == nil)
        return;
    Release(g_baseUrl2);
    g_baseUrl2 = [baseUrl2 copy];
}

+(void)setParserBlock:(CKHttpParserBlock)paserBlock
{
    if (g_parserBlock != paserBlock) {
        Release(g_parserBlock);
        g_parserBlock = paserBlock;
    }
    
}
//设置http的方法
+(void)setHttpMethodType:(CKHttpMethodType)methodType
{
    g_methodType = methodType;
}

//
+(void)setFailureBlock:(CKHttpFailureBlock)failure
{
    if (g_failureBlock != failure) {
        Release(failure);
        g_failureBlock = failure;
    }
}

//设置默认缓存
+(void)setCache:(CKUrlCache*)cache
{
    [CKUrlCache setSharedURLCache:cache];
}

//设置默认的webservice方法
+(void)setBaseUrl:(NSURL*)baseUrl
            Cache:(CKUrlCache*)cachecache
   HttpMethodType:(CKHttpMethodType)methodtype
      ParserBlock:(CKHttpParserBlock)paserBlock
     FailureBlock:(CKHttpFailureBlock)failureBlock
{
    [CKUrlCache    setSharedURLCache:cachecache];
    [CKHttpHelper setBaseUrl:baseUrl andUrl2:nil];
    [CKHttpHelper setHttpMethodType:methodtype];
    [CKHttpHelper setParserBlock:paserBlock];
    [CKHttpHelper setFailureBlock:failureBlock];
}

+ (void)setTimeout:(CGFloat)timeout
{
    g_timeout = timeout;
}

+(id) httpHelper
{
    return AutoRelease([[self alloc]init]);
}

//返回一个CKHttpHelper的autorelease对象，并指定该对象的拥有者为owner
+(id) httpHelperWithOwner:(id)owner
{
    CKHttpHelper *helper = AutoRelease([[self alloc]init]);
    [helper setOwner:owner];
    //可以添加一个标识
    //[helper addParam:@"ios" forName:@"tag"];
    return helper;
}

+(void) stopHttpHelpersForOwner:(id)owner
{
    NSString *key = [NSString stringWithFormat:@"%@",owner];
    if (!g_allPointers)
        return;
    NSDictionary *points = [g_allPointers objectForKey:key];
    if (!points)
        return;
    //对points加锁
    @synchronized(points) {
        NSArray *allKeys = [points allKeys];
        for (NSString *valueKey in allKeys) {
            NSValue *value = [points objectForKey:valueKey];
            if (value) {
                const void *p = [value pointerValue];
                CKHttpHelper *helper = (CKBridge CKHttpHelper *)(p);
                [helper cancel];
            }
        }
    }
}

+(void) clearUrlCache
{
    [[CKUrlCache sharedURLCache] removeAllCachedResponses];
}

//初始化
-(void)initialize
{
    self.baseUrl_1 = g_baseUrl1;
    self.baseUrl_2 = g_baseUrl2;
    self.methodType = g_methodType;
    self.failureBlock = g_failureBlock;
    self.parserBlock = g_parserBlock;
    self.methodName = nil;
    self.completeBlock = nil;
    self.cachePolicy = NSURLRequestUseProtocolCachePolicy;//默认取缓存
    self.timeout = g_timeout;//默认超时
    self.m_iWebServerType = 0;
    _owner = nil;
    _webDataBuf = nil;
    _httpBody = nil;
    _isConnecting = NO;
    _paramsDic = [[NSMutableDictionary alloc]init];
}

-(id)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

//初始化
-(id)initWithOwner:(id)owner
{
    self = [self init];
    if (self) {
        [self setOwner:owner];
    }
    return self;
}

//设置拥有者（owner，即CKHttpHelper对象的调用者，或者说该http方法的调用者）
-(void)setOwner:(id)owner
{
    if (owner) {
        NSString *key = [NSString stringWithFormat:@"%@",owner];
        
        if (!g_allPointers)
            g_allPointers = [[NSMutableDictionary alloc]init];
        
        NSMutableDictionary *points = [g_allPointers objectForKey:key];
        
        if (!points) {
            points = [NSMutableDictionary dictionary];
            [g_allPointers setObject:points forKey:key];
        }
        //_bridge 关键字来实现id类型与void*类型的相互转换
        void *p = (CKBridge void *)(self);
        NSValue *value = [NSValue valueWithPointer:p];
        NSString *valueKey = [NSString stringWithFormat:@"%p",p];
        
        [points setObject:value forKey:valueKey];
    }
    _owner = owner;
}

-(void)dealloc
{
    if (_owner && g_allPointers) {
        
        NSString *key = [NSString stringWithFormat:@"%@",_owner];
        NSMutableDictionary *points = [g_allPointers objectForKey:key];
        
        if (points) {
            
            const void *p = (CKBridge void*)(self);
            NSString *valueKey = [NSString stringWithFormat:@"%p",p];
            [points removeObjectForKey:valueKey];
            
            if (points.count==0)
                [g_allPointers removeObjectForKey:key];
            
        }
    }
    
    self.baseUrl_1 = nil;
    self.baseUrl_2 = nil;
    self.methodName = nil;
    
    Release(_httpBody);
    Release(_paramsDic);
    Release(_webDataBuf);
    Release(_currentResponse);
    self.progressBlock = nil;
    self.completeBlock = nil;
    self.failureBlock = nil;
    self.parserBlock = nil;
    Dealloc();
}

-(void)addParam:(NSString*)param forName:(NSString*)name
{
    if(param == nil || name == nil)
        return;
    [_paramsDic setObject:param forKey:name];
}

-(void) addParamsAndKeys:(NSString*)firstObj, ...
{
    id tempObject = firstObj;
    id eachObject;
    BOOL canSet = NO;
    va_list argumentList;
    if (tempObject) // The first argument isn't part of the varargs list,
    {                                   // so we'll handle it separately.
        va_start(argumentList, firstObj); // Start scanning for arguments after firstObject.
        while ((eachObject = va_arg(argumentList, id))) { // As many times as we can get an argument of type
            canSet = !canSet;
            if (canSet) {
                [_paramsDic setObject:tempObject forKey:eachObject];
            }
            else {
                tempObject = eachObject;
            }
        }
        va_end(argumentList);
    }
}

-(NSString*)paramForName:(NSString*)name
{
    return [_paramsDic objectForKey:@"name"];
}

-(void)addHttpBody:(NSData*)body forName:(NSString*)name
{
    if (!body) {
        return;
    }
    if (!name) {
        name = @"null";
    }
    if (!_httpBody) {
        _httpBody = [[NSMutableDictionary alloc]init];
    }
    [_httpBody setObject:body forKey:name];
}

-(void)clearParams
{
    [_paramsDic removeAllObjects];
}

-(void)clearDataBuff
{
    Release(_webDataBuf);
}

-(void)clearBodys
{
    Release(_httpBody);
}

//开始http连接
-(void)start
{
    m_isCurrentNetError = NO;
    NSMutableURLRequest *urlRequest = nil;
    _isConnecting = YES;
    
    if (_methodType == CKHttpMethodTypeSoap)
        urlRequest = [self httpUrlRequestForSoap];
    
    else if(_methodType == CKHttpMethodTypePost_Data)
        urlRequest = [self httpUrlRequestForPost_Data];
    
    else if(_methodType == CKHttpMethodTypeGet)
        urlRequest = [self httpUrlRequestForGet];
    
    else if(_methodType == CKHttpMethodTypePost_Page)
        urlRequest = [self httpUrlRequestForPost_Page];
    else if(_methodType == CKHttpMethodTypePost_Body)
        urlRequest = [self httpUrlRequestForPost_Body];
    //异步申请一个主线程任务队列
    dispatch_async(dispatch_get_main_queue(), ^{
        Release(_webDataBuf);
        _webDataBuf =[[NSMutableData alloc]init];
        
        //如果开始连接前有回调处理，则进行回调处理(执行block)
        if (self.startBlock)
            self.startBlock();
        
        _currentConnection = [NSURLConnection connectionWithRequest:urlRequest delegate:self];
        
    });
}

//执行http方法前，执行StartBlock
-(void)startWithStartBlock:(void(^)(void))startBlock
{
    if (self.startBlock != startBlock) {
        self.startBlock = startBlock;
    }
    [self start];
}

//http请求方式为soap（一种特殊的http post方式）
-(NSMutableURLRequest *)httpUrlRequestForSoap
{
    NSURL<NSCopying> *soapUrl = [_baseUrl_1 URLByDeletingLastPathComponent];
    if(_iWebServerType == 1)
        soapUrl = [_baseUrl_2 URLByDeletingLastPathComponent];
    
    
    NSString *soapBody = [NSString stringWithFormat:@"<%@ xmlns=\"%@\"> \n",_methodName,soapUrl];
    NSArray *allKeys = [_paramsDic allKeys];
    for (id key in allKeys)
    {
        NSString *obj = [_paramsDic objectForKey:key];
        if (obj) {
            soapBody = [soapBody stringByAppendingFormat:@"<%@>%@</%@>",key,obj,key];
        }
    }
    soapBody = [soapBody stringByAppendingFormat:@"</%@> \n",_methodName];
    
    NSString* strSoapMsg = [NSString stringWithFormat:
                            @ "<?xml version=\"1.0\" encoding=\"utf-8\"?> \n"
                            "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                            "<soap:Body> \n"
                            "%@"
                            "</soap:Body> \n"
                            "</soap:Envelope> \n"
                            ,soapBody];
    NSLog(@"%@",strSoapMsg);
    
    NSMutableURLRequest *urlRequeset = nil;
    if(_iWebServerType == 1)
        urlRequeset = [NSMutableURLRequest requestWithURL:_baseUrl_2];
    else
        urlRequeset = [NSMutableURLRequest requestWithURL:_baseUrl_1];
    [urlRequeset addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    NSString *strSoapAction = [NSString stringWithFormat:@"%@%@", soapUrl,_methodName];
    [urlRequeset addValue:strSoapAction forHTTPHeaderField:@"SOAPAction"];
    NSString *strMsgLen =[NSString stringWithFormat:@"%d", [strSoapMsg length]];
    [urlRequeset addValue:strMsgLen forHTTPHeaderField:@"Content-Length"];
    [urlRequeset setHTTPMethod:@"POST"];
    [urlRequeset setHTTPBody:[strSoapMsg dataUsingEncoding:NSUTF8StringEncoding]];
    [urlRequeset setTimeoutInterval:_timeout];
    [urlRequeset setCachePolicy:_cachePolicy];
    return urlRequeset;
}

//设置http post方式的body之间的分割标记，生产
- (NSString *)generateBoundaryString
{
    CFUUIDRef       uuid;
    CFStringRef     uuidStr;
    NSString *      result;
    //UUID含义是通用唯一识别码 (Universally Unique Identifier)
    uuid = CFUUIDCreate(NULL);
    assert(uuid != NULL);
    
    uuidStr = CFUUIDCreateString(NULL, uuid);
    assert(uuidStr != NULL);
    
    result = [NSString stringWithFormat:@"Boundary-%@", uuidStr];
    
    CFRelease(uuidStr);
    CFRelease(uuid);
    
    return result;
}

//http请求方式为POST,主要用于传递图片和视频
-(NSMutableURLRequest *)httpUrlRequestForPost_Data
{
    NSString* strRequestUrl = @"";
    
    if(_iWebServerType == 2)//快递查询接口
        strRequestUrl = @"http://api.ickd.cn/?";
    else
    {
        strRequestUrl = [_baseUrl_1 absoluteString];
        if (_methodName)
        {
            strRequestUrl = [NSString stringWithFormat:@"%@?action=%@",strRequestUrl,_methodName];
        }
    }
    //设置参数
    NSArray *allKeys = [_paramsDic allKeys];
    for (id key in allKeys)
    {
        NSString*strKey = key;
        
        NSString *strValue = [_paramsDic objectForKey:key];
        if (strValue && strKey)
        {
            strRequestUrl = [NSString stringWithFormat:@"%@&%@=%@",strRequestUrl,strKey,strValue];
        }
    }
    //url编码转换，主要是解决中文的问题
    strRequestUrl = [strRequestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //转换成url
    NSURL *nsUrl = [NSURL URLWithString:strRequestUrl];
    NSMutableURLRequest *urlRequeset = [NSMutableURLRequest requestWithURL:nsUrl];
    
    NSString *strBoundary = [self generateBoundaryString];
    assert(strBoundary != nil);
    
    NSMutableData  * postData =[NSMutableData data];
    if (_httpBody) {
        NSInteger i=0;
        for ( NSString * key in  [_httpBody allKeys])
        {
            NSString *strBodyPrefix = [NSString stringWithFormat:
                                       @
                                       "\r\n"
                                       "--%@\r\n"
                                       "Content-Disposition: form-data; name=\"fileContents\"; filename=\"%@\"\r\n"
                                       "Content-Type: %@\r\n"
                                       "\r\n",
                                       strBoundary,
                                       key,       // +++ very broken for non-ASCII
                                       @"application/octet-stream"
                                       ];
            //fileContents
            [postData  appendData: [strBodyPrefix dataUsingEncoding:NSUTF8StringEncoding]];
            [postData appendData:[_httpBody objectForKey:key ]];
            
            if (i != _httpBody.count-1)
                [postData  appendData:[[NSString  stringWithFormat:@"\r\n--%@\r\n",strBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
            i++;
        }
        [postData  appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",strBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    //打包后的上传文件大小
    unsigned long long bodyLength =(unsigned long long)[postData length];
    
    [urlRequeset setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", strBoundary] forHTTPHeaderField:@"Content-Type"];
    [urlRequeset setValue:[NSString stringWithFormat:@"%llu", bodyLength] forHTTPHeaderField:@"Content-Length"];
    [urlRequeset setHTTPMethod:@"POST"];
    [urlRequeset setHTTPBody:postData];
    [urlRequeset setTimeoutInterval:_timeout];
    [urlRequeset setCachePolicy:_cachePolicy];
    
    NSLog(@"%@",urlRequeset);
    return urlRequeset;
}

//http直接访问web页面，post方式
-(NSMutableURLRequest *)httpUrlRequestForPost_Page
{
    
    
    NSString* strRequestUrl = [_baseUrl_1 absoluteString];
    
    strRequestUrl = [_baseUrl_1 absoluteString];
    if (_methodName)
    {
        strRequestUrl = [NSString stringWithFormat:@"%@/%@.do",strRequestUrl,_methodName];
    }
    
    //设置参数
    NSString* strParams = @"";
    NSArray *allKeys = [_paramsDic allKeys];
    for (id key in allKeys)
    {
        NSString*strKey = key;
        
        NSString *strValue = [_paramsDic objectForKey:key];
        if (strValue && strKey)
        {
            //strRequestUrl = [NSString stringWithFormat:@"%@%@=%@",strRequestUrl,strKey,strValue];
            if(strParams.length < 1)
                strParams = [NSString stringWithFormat:@"?%@=%@",strKey,strValue];
            else
                strParams = [strParams stringByAppendingFormat:@"&%@=%@",strKey,strValue];
        }
    }
    if(strParams.length > 0)
    {
        strRequestUrl = [strRequestUrl stringByAppendingString:strParams];
    }
   // NSLog(@"Http RequestUrl=%@",strRequestUrl);
    //url编码转换，主要是解决中文的问题
    strRequestUrl = [strRequestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"Http RequestUrl Utf8=%@",strRequestUrl);
    //转换成url
    NSURL *nsUrl = [NSURL URLWithString:strRequestUrl];
    NSMutableURLRequest *urlRequeset = [NSMutableURLRequest requestWithURL:nsUrl];
    //
    [urlRequeset setHTTPMethod:@"POST"];
    //[urlRequeset setHTTPBody:postData];
    [urlRequeset setTimeoutInterval:_timeout];
    [urlRequeset setCachePolicy:_cachePolicy];
    
    return urlRequeset;
}



//http请求方式为POST,主要用于传递图片和视频
-(NSMutableURLRequest *)httpUrlRequestForPost_Body
{
    NSString* strRequestUrl = @"";
    
    strRequestUrl = [_baseUrl_1 absoluteString];
    if (_methodName)
    {
        strRequestUrl = [NSString stringWithFormat:@"%@?action=%@",strRequestUrl,_methodName];
    }
    //设置参数
    NSArray *allKeys = [_paramsDic allKeys];
    for (id key in allKeys)
    {
        NSString*strKey = key;
        
        NSString *strValue = [_paramsDic objectForKey:key];
        if (strValue && strKey)
        {
            strRequestUrl = [NSString stringWithFormat:@"%@&%@=%@",strRequestUrl,strKey,strValue];
        }
    }
    //url编码转换，主要是解决中文的问题
    strRequestUrl = [strRequestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //转换成url
    NSURL *nsUrl = [NSURL URLWithString:strRequestUrl];
    NSMutableURLRequest *urlRequeset = [NSMutableURLRequest requestWithURL:nsUrl];
    
    NSMutableData *postBody =[NSMutableData data];
    //[postBody appendData:[[NSString stringWithFormat:@"<Request Action=\"Login\">"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //[postBody appendData:[[NSString stringWithFormat:@"</Request  >"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [urlRequeset setHTTPBody:postBody];
    
    NSLog(@"urlRequest=%@",urlRequeset);
    return urlRequeset;
}

//http请求方式为GET
-(NSMutableURLRequest *)httpUrlRequestForGet
{
    NSURL *tmpUrl = _baseUrl_1;
    if(_iWebServerType == 1)
        tmpUrl = _baseUrl_2;
    if (_methodName) {
        tmpUrl = [tmpUrl URLByAppendingPathComponent:_methodName];
    }
    
    NSString *strUrl = [NSString stringWithFormat:@"%@",tmpUrl];
    
    NSArray *allKeys = [_paramsDic allKeys];
    for (NSInteger i=0; i<allKeys.count; i++) {
        NSString *key = [allKeys objectAtIndex:i];
        NSString *obj = [_paramsDic objectForKey:key];
        if (obj)
        {
            if (i>0)
                strUrl = [strUrl stringByAppendingFormat:@"&%@=%@",key,obj];
            else
                strUrl = [strUrl stringByAppendingFormat:@"?%@=%@",key,obj];
        }
        
    }
    NSMutableURLRequest *urlRequeset = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strUrl]];
    [urlRequeset setHTTPMethod:@"GET"];
    [urlRequeset setTimeoutInterval:_timeout];
    [urlRequeset setCachePolicy:_cachePolicy];
    return urlRequeset;
}


// 收到响应时，会触发
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [connection cancel];
    _currentConnection = nil;
    Release(_webDataBuf);
    _isConnecting = NO;
    NSLog(@"didFailWithError is %@",[error debugDescription]);
    if (_failureBlock) {
        _failureBlock(error);
    }
    if (_completeBlock) {
        _completeBlock(nil);
    }
}

//上传过程中的进度提示
-(void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
    /// NSLog(@"totalBytesWritten=%d",totalBytesWritten);
    //NSLog(@"totalBytesExpectedToWrite=%d",totalBytesExpectedToWrite);
    if (_progressBlock) {
        _progressBlock(totalBytesWritten,totalBytesExpectedToWrite);
    }
    
}


//收到数据后，写入缓存区中
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_webDataBuf appendData:data];
}

//http连接成功后，收到应答后的处理
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)aResponse{
    
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)aResponse;
    if ((httpResponse.statusCode / 100) != 2)
    {
        NSLog(@"服务器接收失败");
        m_isCurrentNetError = YES;
    } else {
        NSLog(@"服务器接收成功");
        m_isCurrentNetError = NO;
    }
    if (_currentResponse)
        Release(_currentResponse);
    
    _currentResponse = Retain(aResponse);
    [_webDataBuf setLength:0];
    
}

//连接结束
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //[connection cancel];
    _currentConnection = nil;
    _isConnecting = NO;
    
    if (_webDataBuf && _methodType == CKHttpMethodTypeGet) {
        [[CKUrlCache sharedURLCache] storeData:_webDataBuf forRequest:connection.currentRequest forResponse:_currentResponse];
    }
    id data = nil;
    if(m_isCurrentNetError == YES)
    {
        int iBufLen = _webDataBuf.length;
        if(iBufLen >40)
            data = _webDataBuf;
    }
    else
        data = _webDataBuf;
    if (_parserBlock) {
        data = _parserBlock(data);
    }
    if (_completeBlock) {
        _completeBlock(data);
    }
}

-(void)cancel
{
    _isConnecting = NO;
    
    if (_currentConnection) {
        
        if (_completeBlock)
            _completeBlock(nil);
        
        [_currentConnection cancel];
        _currentConnection = nil;
        
        
    }
}

@end
