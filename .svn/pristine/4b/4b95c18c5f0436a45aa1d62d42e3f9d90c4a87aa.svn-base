//
//  CKNetworkTestHelper.m
//  FJ-E-YellowPage
//
//  Created by lzq on 13-6-27.
//  Copyright (c) 2013年 ytinfo. All rights reserved.
//

#import "CKNetworkTestHelper.h"

@implementation CKNetworkTestHelper

@synthesize m_isConnecting = _isConnecting;

@synthesize netTestCompleteBlock = _netTestCompleteBlock;
@synthesize m_currentConnection = _currentConnection;
@synthesize m_currentResponse = _currentResponse;

-(id)init
{
    self = [super init];
    if (self) {
        m_webDataBuf = nil;
        ///翼淘秘书全国版，地址为http://119.37.199.221:9000/，另外http://61.191.41.115:9000/是福建翼淘秘书的地址
        m_arAppServicerIpList = [[NSArray alloc] initWithObjects:@"http://119.37.199.222:9003/",@"http://119.37.199.221:9003/", nil];
        m_iCurIpIndex = -1;
    }
    return self;
}



-(void)dealloc
{
    Release(m_webDataBuf);
}

/*

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
*/


-(void)clearDataBuff
{
    Release(m_webDataBuf);
    Release(_currentResponse); 
}


//开始http连接,启动测试
-(void)startTest
{

    m_iCurIpIndex++;
    NSMutableURLRequest * urlRequest = urlRequest = [self httpUrlRequestForTest];
    if(urlRequest == nil)
    {
        if (_netTestCompleteBlock) {
            _netTestCompleteBlock(nil);
        }
        return;
    }
    
    _isConnecting = YES;
    //异步申请一个主线程任务队列
    dispatch_async(dispatch_get_main_queue(), ^{
        Release(m_webDataBuf);
        m_webDataBuf =[[NSMutableData alloc]init];
        
        _currentConnection = [NSURLConnection connectionWithRequest:urlRequest delegate:self];
    });
}


//http请求方式为soap（一种特殊的http post方式）
-(NSMutableURLRequest *)httpUrlRequestForTest
{
    
    if(m_iCurIpIndex < 0 || m_iCurIpIndex>=[m_arAppServicerIpList count])
        return nil;
    
    NSString* strTestPageUrl = [m_arAppServicerIpList objectAtIndex:m_iCurIpIndex];
    if(strTestPageUrl.length < 1)
        return nil;
    strTestPageUrl = [[NSString alloc] initWithFormat:@"%@index.aspx",strTestPageUrl];
    NSLog(@"test pate url is %@",strTestPageUrl);
    
    NSURL *nsRequestUrl = [NSURL URLWithString:strTestPageUrl];

    NSMutableURLRequest *urlRequeset = [NSMutableURLRequest requestWithURL:nsRequestUrl];
     
    [urlRequeset addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[urlRequeset setHTTPMethod:@"POST"];

    [urlRequeset setTimeoutInterval:30];
   // [urlRequeset setCachePolicy:_cachePolicy];
    return urlRequeset;
}


// 收到响应时，会触发
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [connection cancel];
    _currentConnection = nil;
    Release(m_webDataBuf);
    _isConnecting = NO;
    
    NSLog(@"didFailWithError is %@",[error debugDescription]);
    //重新启用探测
    [self startTest];

}

//上传过程中的进度提示
-(void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
    NSLog(@"totalBytesWritten=%d",totalBytesWritten);
    NSLog(@"totalBytesExpectedToWrite=%d",totalBytesExpectedToWrite);

    
}


//收到数据后，写入缓存区中
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [m_webDataBuf appendData:data];
}

//http连接成功后，收到应答后的处理
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)aResponse{
    
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)aResponse;
    
    //  NSLog(@"httpResponse.statusCode = %d",httpResponse.statusCode);
    if ((httpResponse.statusCode / 100) != 2)
    {
        NSLog(@"服务器接收失败");
    } else {
        NSLog(@"服务器接收成功");
    }
    if (_currentResponse)
        Release(_currentResponse);
    
    _currentResponse = Retain(aResponse);
    [m_webDataBuf setLength:0];
    
}

//连接结束
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //[connection cancel];
    _currentConnection = nil;
    _isConnecting = NO;
    
    //
    NSString* strCurIp = [m_arAppServicerIpList objectAtIndex:m_iCurIpIndex];
    NSString* strWebServiceUrl = [[NSString alloc] initWithFormat:@"%@Service.asmx",strCurIp];
   // NSURL* nsInuseUrl = [[NSURL alloc] initWithString:strWebServiceUrl];
    if (_netTestCompleteBlock) {
        _netTestCompleteBlock(strWebServiceUrl);
    }
}

//退出连接
-(void)cancel
{
    _isConnecting = NO;
    
    if (_currentConnection)
    {
        
        if (_netTestCompleteBlock)
            _netTestCompleteBlock(nil);
        
        [_currentConnection cancel];
        _currentConnection = nil;
        
    }
}



@end
