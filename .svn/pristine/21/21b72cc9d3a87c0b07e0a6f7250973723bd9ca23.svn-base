//
//  CKHttpHelper.h
//  FJ-E-YellowPage
//
//  Created by jiangjunchen on 13-5-13.
//  Copyright (c) 2013年 ytinfo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CKConfig.h"
#import "CKUrlCache.h"

@interface CKHttpHelper : NSObject <NSURLConnectionDelegate,NSURLConnectionDataDelegate>
{
    //  NSMutableURLRequest *_urlRequest;
    NSMutableDictionary *_httpBody;
    NSMutableData *_webDataBuf;
    NSMutableDictionary *_paramsDic;
    __unsafe_unretained id _owner;
    __unsafe_unretained NSURLConnection *_currentConnection;
    
    bool    m_isCurrentNetError;
    
}

//定义几个block方法，类似C++的函数指针
typedef void(^CKHttpCompleteBlock)(id data);
typedef void(^CKHttpFailureBlock)(NSError *error);
typedef void(^CKHttpProgressBlock)(NSInteger sendedBytes, NSInteger totalBytes);
typedef id(^CKHttpParserBlock)(NSData* webData);
typedef void(^CKHttpStartBlock)(void);

typedef enum
{
    CKHttpMethodTypeSoap,
    CKHttpMethodTypePost_Data,
    CKHttpMethodTypeGet,
    CKHttpMethodTypePost_Page,
    CKHttpMethodTypePost_Body
    
}CKHttpMethodType;

//设置请求的webservice方法名
@property (nonatomic,copy) NSString *methodName;

//设置本次请求的webservice服务器地址（不改变全局的webservice地址）
@property (nonatomic,copy) NSURL *baseUrl_1;
//获取优惠劵的URL
@property (nonatomic,copy) NSURL *baseUrl_2;
//获取优惠劵的URL
@property (nonatomic,assign) NSInteger m_iWebServerType;//默认位0，是获取商家的信息，else_获取优惠劵信息
//进度条的block
@property (copy, nonatomic) void(^progressBlock)(NSInteger sendedBytes, NSInteger totalBytes);

//完成时执行的block
@property (copy, nonatomic) void(^completeBlock)(id data);

//连接失败时执行的block
@property (copy, nonatomic) void(^failureBlock)(NSError *error) ;

//数据接收完成并解析时执行的block,block返回nil表示不解析
@property (copy, nonatomic) id(^parserBlock)(NSData* webData) ;

//开始连接请求时执行的block
@property (copy, nonatomic) void(^startBlock)(void) ;

//指定缓存机制
@property (assign, nonatomic) NSURLRequestCachePolicy cachePolicy;

//http请求的类型:soap,post,get
@property (assign, nonatomic) CKHttpMethodType methodType;

//当前正在进行的连接对象（只读!）
@property (nonatomic, readonly) NSURLConnection *currentConnection;

//当前的连接的响应
@property (nonatomic, readonly) NSURLResponse *currentResponse;

//是否正在进行连接
@property (nonatomic,readonly) BOOL isConnecting;

//指定超时时间（/秒）
@property (assign, nonatomic) CGFloat timeout;



+(NSURL *)baseUrl1;
+(NSURL *)baseUrl2;
//设置默认webservice服务器地址(设置的webservice地址为全局地址，不需要重复设置）
+(void)setBaseUrl:(NSURL *)baseUrl1 andUrl2:(NSURL*)baseUrl2;

//设置默认解析返回数据的block
+(void)setParserBlock:(CKHttpParserBlock)paserBlock;

//设置默认请求方式:soap、post、get
+(void)setHttpMethodType:(CKHttpMethodType)methodType;

//设置默认处理连接错误的block
+(void)setFailureBlock:(CKHttpFailureBlock)failure;

//设置默认缓存
+(void)setCache:(CKUrlCache*)cache;

//设置默认超时时间
+ (void)setTimeout:(CGFloat)timeout;

+(void)setBaseUrl:(NSURL*)baseUrl
            Cache:(CKUrlCache*)cachecache
   HttpMethodType:(CKHttpMethodType)methodtype
      ParserBlock:(CKHttpParserBlock)paserBlock
     FailureBlock:(CKHttpFailureBlock)failureBlock;

//返回一个CKHttpHelper的autorelease对象
+(id) httpHelper;

//返回一个CKHttpHelper的autorelease对象，并指定该对象的拥有者为owner
+(id) httpHelperWithOwner:(id)owner;

//停止拥有者（owner）的所有CKHttpHelper对象的网络连接
+(void) stopHttpHelpersForOwner:(id)owner;

//主动清除url缓存
+(void) clearUrlCache;

//初始化为owner下的CKHttpHelper对象
-(id)initWithOwner:(id)owner;

//一次性添加多对参数和参数名
//使用方法如 :[helper addParmsAndKeys:@"1001",@"memberId",@"0551",@"cityCode",nil];
-(void) addParamsAndKeys:(NSString*)firstObj, ... NS_REQUIRES_NIL_TERMINATION;

//添加一对参数和参数名
-(void)addParam:(NSString*)param forName:(NSString*)name;

//添加一段数据用于提交请求（body可以是image，video或其他任何文件的data）
//name最好指定文件格式,如@"myVideo.mp4"
-(void)addHttpBody:(NSData*)body forName:(NSString*)name;

//通过参数名获取参数
-(NSString*)paramForName:(NSString*)name;

//清除所有参数
-(void)clearParams;

//清除下载的数据
-(void)clearDataBuff;

//清除所有的提交数据
-(void)clearBodys;

//开始建立http连接
-(void)start;

//开始建立http连接,并执行startBlock
-(void)startWithStartBlock:(void(^)(void))startBlock;

//主动取消http连接
-(void)cancel;

@end
