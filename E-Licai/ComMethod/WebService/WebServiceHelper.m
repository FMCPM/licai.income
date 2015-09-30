//
//  WebServiceHelper.m
//  ahdxyp
//
//  Created by jiang junchen on 12-8-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "WebServiceHelper.h"
#import "GlobalDefine.h"
#import "ImgFileMethod.h"
#import "WebserviceParser.h"


@interface WebServiceHelper (){
    NSUInteger m_iImageUrlIndex;
    NSMutableArray *m_muarrayUIImage;
}
@property (nonatomic, retain)NSArray *m_arrayImageUrl;
@property (nonatomic, retain)NSArray *m_arrayImageKey;
@end

static NSMutableDictionary      *_dicServices   = nil;

@implementation WebServiceHelper
@synthesize m_arrayImageKey;
@synthesize m_arrayImageUrl;
@synthesize m_isNeedDealloc;
@synthesize m_isFinishDownLoadImg;
@synthesize m_iTag;
@synthesize m_delegate;



+(void) removeAllServicesFromController:(id)controller
{
    if (!_dicServices)  return;
    NSString *key = [[NSString alloc]initWithFormat:@"%@",controller];
    NSMutableArray *services = (NSMutableArray*)[_dicServices objectForKey:key];
    if (!services)  return;
    for (id obj in services) {
        WebServiceHelper *wsh = (WebServiceHelper*)obj;
        wsh.m_isNeedDealloc = YES;
    }
    [services removeAllObjects];
    [_dicServices removeObjectForKey:key];
}

+(void) removeService:(WebServiceHelper*)service FromController:(id)controller
{
    service.m_isNeedDealloc = YES;
    if (!_dicServices)  return;
    NSString *key = [[NSString alloc]initWithFormat:@"%@",controller];
    NSMutableArray *services = (NSMutableArray*)[_dicServices objectForKey:key];
    [services removeObject:service];
    if (services.count <= 0) {
        [_dicServices removeObjectForKey:key];
    }
}

-(id) initWithFatherController:(id)controller
{
    if (self = [super init]) {
        _fatherController = controller;
        if (!_dicServices) {
            _dicServices = [[NSMutableDictionary alloc]init];
        }
        NSString *key = [[NSString alloc]initWithFormat:@"%@",controller];
        NSLog(@"key = %@",key);
        NSMutableArray *services = [_dicServices objectForKey:key];
        if (!services) {
            services = [[NSMutableArray alloc]init];
            [_dicServices setObject:services forKey:key];         
        }
        [services addObject:self];
        m_iTag = 0;
    }
    return self;
}


- (void) StartWebServiceMerhod:(NSString *)methodMsg
                      andMethodName:(NSString *)methodName
                      andCompletion:(void(^)(void))completion
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self addState:WEBSERVICE_OK];
        m_isNeedDealloc = NO;
        if (completion)
            completion();
        if(methodMsg == NULL){
            [self addState:WEBSERVICE_STARTERO];
            [self addState:WEBSERVICE_FINISHED];
            [self.m_delegate webServiceHelper:self WithResultState:_iState DataSet:NULL];
            return;
        }
        if(m_WebServiceMethod == NULL)
            m_WebServiceMethod = [[WebServiceMethod alloc]init];
        NSInteger iResultID = [m_WebServiceMethod submitWebServiceMethod:methodMsg
                                                           andMethodName:methodName];
        if(iResultID != RET_OK)
        {
            m_WebServiceMethod = NULL;
            [self addState:WEBSERVICE_STARTERO];
            [self addState:WEBSERVICE_FINISHED];
            [self.m_delegate webServiceHelper:self WithResultState:_iState DataSet:NULL];
            return;
        }
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self getWebServiceResultThread];
        });
    });


  //  [NSThread detachNewThreadSelector: @selector(getWebServiceResultThread) toTarget: self withObject: nil];
}

- (void) getWebServiceResultThread
{
    while(YES){
        if (m_isNeedDealloc )   {
            return;
        }
        if(m_WebServiceMethod == nil){
            [self addState:WEBSERVICE_DATAERO];
            break;
        }
        if([m_WebServiceMethod isFinished])
            break;

        [NSThread sleepForTimeInterval:0.1];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self finishedWebServiceInfo];
    });
 //   [self performSelectorOnMainThread: @selector(finishedWebServiceInfo) withObject:nil waitUntilDone: YES];
}

- (void) finishedWebServiceInfo
{
    if (_iState & WEBSERVICE_OK) {
        m_WebServiceDataSet = [m_WebServiceMethod getResultDataSet];
        if(m_WebServiceDataSet == nil)
            [self addState:WEBSERVICE_FINISHERO];
    }
    [self addState:WEBSERVICE_FINISHED];
    if (self.m_delegate && [self.m_delegate respondsToSelector:@selector(webServiceHelper:WithResultState:DataSet:)]) {
        [self.m_delegate webServiceHelper:self WithResultState:_iState DataSet:m_WebServiceDataSet]; 
    }
    m_WebServiceMethod = nil;
    m_WebServiceDataSet = nil;
}

-(void)addState:(int)flag
{
    if (flag == WEBSERVICE_IGNO) {
        _iState = WEBSERVICE_OK;
    }
    else if (flag == WEBSERVICE_OK) {
        _iState = flag;
    }
    else if (flag == WEBSERVICE_FINISHED) {
        _iState |= WEBSERVICE_FINISHED;
    }
    else {
        int finished = 0;
        if (_iState & WEBSERVICE_FINISHED) {
            finished = WEBSERVICE_FINISHED;
        }
        _iState &= ~WEBSERVICE_OK;
        _iState |= flag;
        _iState |= finished;
    }
}

#pragma mark -
#pragma mark down load one image
-(void)downLoadImagesWithUrls:(NSArray *)arrUrls andKeys:(NSArray *)arrKeys
{
    if (!arrUrls || arrUrls.count < 1) {
        [self addState:WEBSERVICE_STARTERO];
        [self addState:WEBSERVICE_FINISHED];
        if ([m_delegate respondsToSelector:@selector(webServiceHelper:WithResultState:andUIImage:andKey:)]) {
            [m_delegate webServiceHelper:self 
                         WithResultState:_iState 
                              andUIImage:nil andKey:nil];
        }
        return;
    }
    self.m_arrayImageKey = arrKeys;
    self.m_arrayImageUrl = arrUrls;
    m_iImageUrlIndex = 0;
    NSString *firstKey;
    if (self.m_arrayImageKey == nil) {
        firstKey = [[NSString alloc]initWithFormat:@"%d",m_iImageUrlIndex];
        
    }else {
        firstKey = (NSString*)[self.m_arrayImageKey objectAtIndex:0];
    }
    dispatch_async(dispatch_get_main_queue(),^{
        [self downLoadImageWithKey:firstKey];
    });
}

-(BOOL)downLoadImageWithKey:(NSString*)key
{
    [self addState:WEBSERVICE_OK];
    while (1) {
        if (m_iImageUrlIndex == m_arrayImageKey.count-1) {
            [self addState:WEBSERVICE_FINISHED];
        }
        if (m_iImageUrlIndex > m_arrayImageUrl.count-1){
            if (_iState & WEBSERVICE_FINISHED) {
                return YES;
            }
            [self addState:WEBSERVICE_FINISHERO];
            [self addState:WEBSERVICE_FINISHED];
            if ([m_delegate respondsToSelector:@selector(webServiceHelper:WithResultState:andUIImage:andKey:)]) {
                [m_delegate webServiceHelper:self
                             WithResultState:_iState
                                  andUIImage:nil andKey:nil];
            }
            return NO;
        }
        m_pAnsyImageTaskObj = nil;
        m_pAnsyImageTaskObj = [[AnsyImageTaskObj alloc] init];
        int iResultID = [m_pAnsyImageTaskObj startAnsyDownLoadLogoImg:0 andImgUrl:(NSString *)[m_arrayImageUrl objectAtIndex:m_iImageUrlIndex++]];
        //下载失败，释放图片下载对象
        if(iResultID != RET_OK){
            [self addState:WEBSERVICE_STARTERO];
            if ([m_delegate respondsToSelector:@selector(webServiceHelper:WithResultState:andUIImage:andKey:)]) {
                [m_delegate webServiceHelper:self
                             WithResultState:_iState
                                  andUIImage:nil andKey:nil];
            }
        }
        else 
            break;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self waitAnsyDownLoadImgThreadWithImgKey:key];
    });
    //启动异步的图片加载，并刷新UI的线程
//    [NSThread detachNewThreadSelector: @selector(waitAnsyDownLoadImgThreadWithImgKey:) toTarget: self withObject: key];
    return NO;
}

-(void)downLoadImageWithUrl:(NSString*)imgurl andKey:(NSString*)key
{
    if (!imgurl) {
        [self addState:WEBSERVICE_STARTERO];
        [self addState:WEBSERVICE_FINISHED];
        if ([m_delegate respondsToSelector:@selector(webServiceHelper:WithResultState:andUIImage:andKey:)]) {
            [m_delegate webServiceHelper:self 
                         WithResultState:_iState 
                              andUIImage:nil andKey:key];
        }
        return;
    }
    self.m_arrayImageUrl = [[NSMutableArray alloc]initWithObjects:imgurl, nil];
    self.m_arrayImageKey = nil;
    m_iImageUrlIndex     = 0;
    dispatch_async(dispatch_get_main_queue(),^{
        [self downLoadImageWithKey:key];
    });
}

-(void)waitAnsyDownLoadImgThreadWithImgKey:(NSString*)key
{
    while (TRUE) 
    {
        if (m_isNeedDealloc) {
            return;
        }
        if (m_delegate == nil) {
            break;
        }
        if(m_pAnsyImageTaskObj == nil){
            [self addState:WEBSERVICE_DATAERO];
            break;
        }
        
        if([m_pAnsyImageTaskObj isFinishedDownLoad] == YES){
            break;
        }
        [NSThread sleepForTimeInterval:0.1];  
    }
    [self finishLoadImageWithKey:key];
    //[self performSelectorOnMainThread:@selector(finishLoadImageWithKey:) withObject:key waitUntilDone:NO];
}

-(void)finishLoadImageWithKey:(NSString*)key
{
    UIImage *img = nil;
    if (_iState & WEBSERVICE_OK) {
        img = [self getImageFromDownLoadData];
        if(!img){
            [self addState:WEBSERVICE_DATAERO];
        }
    }
    if ([m_delegate respondsToSelector:@selector(webServiceHelper:WithResultState:andUIImage:andKey:)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [m_delegate webServiceHelper:self
                         WithResultState:_iState
                              andUIImage:img andKey:key];
        });
    }
    NSString *nextKey;
    if (self.m_arrayImageKey && self.m_arrayImageKey.count > m_iImageUrlIndex) {
        nextKey = (NSString*)[self.m_arrayImageKey objectAtIndex:m_iImageUrlIndex];
    }else {
        nextKey = [[NSString alloc]initWithFormat:@"%d",m_iImageUrlIndex];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self downLoadImageWithKey:nextKey];
    });
 //   [self downLoadImageWithKey:nextKey];
}

-(UIImage *)getImageFromDownLoadData
{
    if(m_pAnsyImageTaskObj == nil)
    {
        return nil;
    }
    AnsyImageData* pAnsiImageData = [m_pAnsyImageTaskObj getAnsyImageDataBuf];
    if(!pAnsiImageData){
        return nil;
    }
    NSMutableData *pImageStream     = nil;
    UIImage *pImage                 = nil;
    pImageStream                    = [pAnsiImageData getImageDataStream];
    
    if(pImageStream == nil)
    {
        return nil;
    }
    else 
    {
        pImage = [[UIImage alloc] initWithData:pImageStream];
        if (!pImage) {
            NSString* strImgName = [ImgFileMethod getImgNameFormUrl:[m_pAnsyImageTaskObj getImageUrl]];
            [ImgFileMethod deleteImgfileWithImgName:strImgName];
            return nil;
        }
        m_pAnsyImageTaskObj = nil;
        return pImage;
    }
}
-(void)uploadFromUrl:(NSURL *)sUrl toBaseUrl:(NSURL *)dUrl withMemberId:(NSString*)memberId
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *strBoundary = [self generateBoundaryString];
        assert(strBoundary != nil);

        NSString *strBodyPrefix = [NSString stringWithFormat:
                                   @
                                   "\r\n"
                                   "--%@\r\n"
                                   "Content-Disposition: form-data; name=\"fileContents\"; filename=\"%@\"\r\n"
                                   "Content-Type: %@\r\n"
                                   "\r\n",
                                   strBoundary,
                                   [sUrl lastPathComponent],       // +++ very broken for non-ASCII
                                   @"application/octet-stream"
                                   ];
        assert(strBodyPrefix != nil);
        
        NSString *strBodySuffix = [NSString stringWithFormat:
                                   @
                                   "\r\n"
                                   "--%@\r\n"
                                   "Content-Disposition: form-data; name=\"uploadButton\"\r\n"
                                   "\r\n"
                                   "Upload File\r\n"
                                   "--%@--\r\n"
                                   "\r\n"
                                   //empty epilogue
                                   ,
                                   strBoundary,
                                   strBoundary
                                   ];
        assert(strBodySuffix != nil);
        
        
        //文件大小
        NSNumber *fileLengthNum = (NSNumber *) [[[NSFileManager defaultManager] attributesOfItemAtPath:[sUrl path] error:NULL] objectForKey:NSFileSize];
        assert( [fileLengthNum isKindOfClass:[NSNumber class]] );
        
        //打包后的上传文件大小
        unsigned long long bodyLength =
        (unsigned long long) [strBodyPrefix length]
        + [fileLengthNum unsignedLongLongValue]
        + (unsigned long long) [strBodySuffix length];
        
        NSData *data = [NSData dataWithContentsOfURL:sUrl];
        NSMutableData *body = [NSMutableData data];

        [body appendData:[strBodyPrefix dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:data];
        [body appendData:[strBodySuffix dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:dUrl];
        [request setHTTPMethod:@"POST"];
        //application/octet-stream
        [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=\"%@\"", strBoundary] forHTTPHeaderField:@"Content-Type"];
        [request setValue:[NSString stringWithFormat:@"%llu", bodyLength] forHTTPHeaderField:@"Content-Length"];
        [request setValue:memberId forHTTPHeaderField:@"memberId"];
        [request setHTTPBody:body];
        
        //建立连接
        dispatch_async(dispatch_get_main_queue(), ^{
            _webDataBuf =[NSMutableData data];
            [NSURLConnection connectionWithRequest:request delegate:self];
        });
    });
}

-(void)uploadFromUrl:(NSURL *)sUrl toBaseUrl:(NSURL *)dUrl
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *strBoundary = [self generateBoundaryString];
        assert(strBoundary != nil);
        NSString *strBodyPrefix = [NSString stringWithFormat:
                                   @
                                   "\r\n"
                                   "--%@\r\n"
                                   "Content-Disposition: form-data; name=\"fileContents\"; filename=\"%@\"\r\n"
                                   "Content-Type: %@\r\n"
                                   "\r\n",
                                   strBoundary,
                                   [sUrl lastPathComponent],       // +++ very broken for non-ASCII
                                   @"application/octet-stream"
                                   ];
        assert(strBodyPrefix != nil);
        
        NSString *strBodySuffix = [NSString stringWithFormat:
                                   @
                                   "\r\n"
                                   "--%@\r\n"
                                   "Content-Disposition: form-data; name=\"uploadButton\"\r\n"
                                   "\r\n"
                                   "Upload File\r\n"
                                   "--%@--\r\n"
                                   "\r\n"
                                   //empty epilogue
                                   ,
                                   strBoundary,
                                   strBoundary
                                   ];
        assert(strBodySuffix != nil);
        
        
        //文件大小
        NSNumber *fileLengthNum = (NSNumber *) [[[NSFileManager defaultManager] attributesOfItemAtPath:[sUrl path] error:NULL] objectForKey:NSFileSize];
        assert( [fileLengthNum isKindOfClass:[NSNumber class]] );
        
        //打包后的上传文件大小
        unsigned long long bodyLength =
        (unsigned long long) [strBodyPrefix length]
        + [fileLengthNum unsignedLongLongValue]
        + (unsigned long long) [strBodySuffix length];
        
        NSData *data = [NSData dataWithContentsOfURL:sUrl];
        NSMutableData *body = [NSMutableData data];
        [body appendData:[strBodyPrefix dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:data];
        [body appendData:[strBodySuffix dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:dUrl];
        [request setHTTPMethod:@"POST"];
        //application/octet-stream
        [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=\"%@\"", strBoundary] forHTTPHeaderField:@"Content-Type"];
        [request setValue:[NSString stringWithFormat:@"%llu", bodyLength] forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody:body];
        
        //建立连接
        dispatch_async(dispatch_get_main_queue(), ^{
            _webDataBuf =[NSMutableData data];
            [NSURLConnection connectionWithRequest:request delegate:self];
        });
    });
}

-(void)uploadFile:(NSString*)fileName toBaseUrl:(NSURL*)url
{
    NSURL *surl = [NSURL URLWithString:fileName];
    [self uploadFromUrl:surl toBaseUrl:url];    
}

- (NSString *)generateBoundaryString
{
    CFUUIDRef       uuid;
    CFStringRef     uuidStr;
    NSString *      result;
    
    uuid = CFUUIDCreate(NULL);
    assert(uuid != NULL);
    
    uuidStr = CFUUIDCreateString(NULL, uuid);
    assert(uuidStr != NULL);
    
    result = [NSString stringWithFormat:@"Boundary-%@", uuidStr];
    
    CFRelease(uuidStr);
    CFRelease(uuid);
    
    return result;
}

// 收到响应时，会触发
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    _webDataBuf = nil;
    [connection cancel];
    connection = nil;
}

-(void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
    NSLog(@"totalBytesWritten=%d",totalBytesWritten);
    NSLog(@"totalBytesExpectedToWrite=%d",totalBytesExpectedToWrite);
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_webDataBuf appendData:data];
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)aResponse{

    NSLog(@"aResponse:%@",aResponse.URL);
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)aResponse;
    NSLog(@"httpResponse.statusCode = %d",httpResponse.statusCode);
    if ((httpResponse.statusCode / 100) != 2) {
        NSLog(@"服务器接收失败");
    } else {
        NSLog(@"服务器接收成功");
    }
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    WebserviceParser *parser = [[WebserviceParser alloc]init];
    
    m_WebServiceDataSet = [parser ParserData_Json:_webDataBuf ];
    if (m_WebServiceDataSet) {
        NSLog(@"boolResult=%@",[m_WebServiceDataSet getFeildValue:0 andColumn:@"boolResult"]);
    }
    
    [connection cancel];
    connection = nil;
}

@end
