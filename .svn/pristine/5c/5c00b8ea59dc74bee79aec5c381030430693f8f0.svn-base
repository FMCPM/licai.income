//
//  CSjqMessageObj.m
//
//  Created by lzq on 2014-3-31.
//  Copyright (c) 2014年 ytinfo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QDataSetObj.h"

#define FROM_ID_SYSTEM @"system"
#define FROM_ID_PUBLIC @"public"

@interface CSjqMessageObj : NSObject{


}

//将从服务端收到的消息写入本地数据库
-(int)writeMessageToLocalDB:(QDataSetObj*)pDataSet;
//将发送的消息写到本地数据库
-(bool)WriteSendLogToLocalDB:(SetRowObj*)pRowObj;

//根据用户，获取消息列表
-(QDataSetObj*)getMessageListOrderUser;
//获取与某个好友之间所有的聊天记录
-(QDataSetObj*)getFriendMessageListInfo:(NSString*)strFriendId andGetFlag:(NSInteger)iGetFlag;
//获取消息显示的当前的时间
-(NSString*)getMessageShowTime:(NSString*)strOraTime;

//获取消息显示当前的时间
-(NSString*)getMessageReallyTime;
//页面刷新的时候，用于获取指定信息最后的时间
-(int)getInfoLastQueryTime:(NSInteger)iInfoId andName:(NSString*)strInfoName;
//修改指定消息最后的更新时间
-(bool)modInfoLastQueryTime:(NSInteger)iInfoId andTime:(int)iLastQTime;
//从本地数据库中提取所有信息的查询时间信息
-(QDataSetObj*)getMultInfoLastQTimes:(NSString*)strUserId;
//添加一条信息到数据库中
-(bool)insertInfoQTimeToDb:(NSInteger)iInfoId andName:(NSString*)strInfoName;
//获取用户未读的消息总数
-(NSInteger)getUserNoReadMessageCount;
//将信息修改为已读
-(bool)setMessageStateToRead:(NSString*)strUserId andFriend:(NSString*)strFriendId;
//根据账号，获取用户对应的头像的url
-(NSString*)getUserHeadImageUrl:(NSString*)strUserId;
//写账号及账号对应的Url写入数据库
-(bool)insertUserHeadImageUrl:(NSString*)strUserId andUrl:(NSString*)strHeadUrl;
//提取最近一条未读的消息
-(NSString*)getOneNoReadMessageInfo;
//将unix时间转换成可以显示的时间
+(NSString*)convertToShowTime:(NSInteger)iOraTime;
//将unix时间转换成可以显示的时间
+(NSString*)convertToShowTime_pay:(NSInteger)iOraTime;

//删除和某个朋友的聊天记录
-(NSInteger)deleteMessageLogByFriend:(NSString*)strUserId andFriend:(NSString*)strFriendId;

//清理记录
-(void)clearMaxCountMessageLog:(NSString*)strUserName;

@end
