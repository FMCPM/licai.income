//
//  CKNetworkTestHelper.h
//  FJ-E-YellowPage
//  Description:一个自定义的类，用于APP客户端网络环境的检测，并自动选择一个适合的网络
//
//  Created by lzq on 13-6-27.
//  Copyright (c) 2013年 ytinfo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CKConfig.h"

@interface CKNetworkTestHelper : NSObject
{
    
    NSMutableData *m_webDataBuf;
    //webservice服务器的IP地址列表
    NSArray* m_arAppServicerIpList;
    //当前启用的服务器IP的索引
    NSInteger m_iCurIpIndex;
    //
    __unsafe_unretained NSURLConnection *_currentConnection; 

}



//定义几个block方法，类似C++的函数指针
//typedef void(^CKNetTestHttpCompleteBlock)(id data);

//网络环境测试完成时执行的block
@property (copy, nonatomic) void(^netTestCompleteBlock)(id data);

//当前正在进行的连接对象（只读!）
@property (nonatomic, readonly) NSURLConnection *m_currentConnection;

//是否正在进行连接
@property (nonatomic,readonly) BOOL m_isConnecting;

//当前的连接的响应
@property (nonatomic, readonly) NSURLResponse *m_currentResponse;

//
-(void)clearDataBuff;
//一次性添加多对参数和参数名
//使用方法如 :[helper addParmsAndKeys:@"1001",@"memberId",@"0551",@"cityCode",nil];
//-(void) addParamsAndKeys:(NSString*)firstObj, ... NS_REQUIRES_NIL_TERMINATION;

//开始网络环境检测
-(void)startTest;


//主动取消http连接
-(void)cancel;


@end
