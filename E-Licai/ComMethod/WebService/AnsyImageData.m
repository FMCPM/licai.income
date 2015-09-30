//
//  AnsyImageData.m
//  ahdxyp
//
//  Created by ytinfo ytinfo on 12-6-15.
//  Copyright 2012年 ytinfo. All rights reserved.
//

#import "AnsyImageData.h"
#import "GlobalDefine.h"
#import "ImgFileMethod.h"

@implementation AnsyImageData

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
       // m_netConnection = NULL;
        m_imgDataStream = NULL;
        m_netConnection   = NULL;
        m_blNeedSaveFile = FALSE;
    }
 
    return self;
}

/*------------------------------------------------------------------------
 Function    :loadImageFromURL
 Description :根据图片的URL，从网络上将图片下载到本地
 Params      :
    strUrl:图片对应的完整的URL
 Result      :int,ret_ok表示成功 
 Author      :lzq,lvzhuqiang@ytinfo.zj.cn
 DateTime    :2012-06-15
 ------------------------------------------------------------------------*/
- (NSInteger)loadImageFromURL:(NSString*)strUrl 
{
    m_imgDataStream = nil;
    //获取图片文件名称
    m_strImageFileName = [NSString stringWithFormat:@"%@",[ImgFileMethod getImgNameFormUrl:strUrl]];
    NSURL *nsLoadImgUrl = [NSURL URLWithString:strUrl];
    NSURLRequest* urlRequest = [NSURLRequest requestWithURL:nsLoadImgUrl
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy
                                         timeoutInterval:60.0];//超时5秒即可x
    NSLog(@"urlRequest is %@",strUrl);
    //创建URL连接
    m_netConnection = [[NSURLConnection alloc]
                  initWithRequest:urlRequest delegate:self startImmediately:YES];
    NSInteger iResultID = RET_OK;
    if(m_netConnection)
    {
        m_isFinished = FALSE;
       // m_imgDataStream = [[NSMutableData alloc] init];
        
    }
    else
    {
        m_isFinished = TRUE;
        iResultID    = RET_FAIL;
    }
    return iResultID;

}


#pragma mark - 
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"%@",[error description]);
    NSLog(@"cannot connect to the resource ");
    m_isFinished = TRUE;
}


-(void)connection:(NSURLConnection *)_connection didReceiveResponse:(NSURLResponse *)response{
    //[_connection cancel];
    NSLog(@"received response");
    //get file size

    NSInteger size = [response expectedContentLength];
    
    NSLog(@"received response size is %d",size);
    NSLog(@"response is %@",[response debugDescription]);

 }

- (void)connection:(NSURLConnection *)theConnection
    didReceiveData:(NSData *)incrementalData 
{
    NSLog(@"received image data");

    if (!incrementalData) {
        NSLog(@"incrementalData is null");
    }
    if (m_imgDataStream == NULL) 
    {
        m_imgDataStream = [[NSMutableData alloc] initWithCapacity:2048];
    }
    [m_imgDataStream appendData:incrementalData];
}

//结束下载
- (void)connectionDidFinishLoading:(NSURLConnection*)theConnection 
{
   // m_blNeedSaveFile = TRUE;
    ImgFileMethod* pMethod = [[ImgFileMethod alloc] init];
    [pMethod writeImageDataToLocalCache:m_imgDataStream andImageName:m_strImageFileName];
    m_blNeedSaveFile = FALSE;
    m_isFinished = TRUE;

}
-(BOOL)isFinished
{
    return  m_isFinished;
}


//获取图片流
-(NSMutableData*)getImageDataStream
{    
    /*
    if(m_blNeedSaveFile == TRUE)
    {
        
        ImgFileMethod* pMethod = [[ImgFileMethod alloc] init];
        [pMethod writeImageDataToLocalCache:m_imgDataStream andImageName:m_strImageFileName];
        m_blNeedSaveFile = FALSE;
    }
    */
    return  m_imgDataStream;
}
 

//设置image data stream;
-(void)setImageDataStream:(NSMutableData*)imageDataStream
{
    m_imgDataStream = imageDataStream;
  //  [m_imgDataStream retain];
    m_isFinished = TRUE;
}

@end
