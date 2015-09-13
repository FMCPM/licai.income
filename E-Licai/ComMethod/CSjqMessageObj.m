//
//  CSjqMessageObj.m
//
//  Created by lzq on 2014-3-31.
//  Copyright (c) 2014年 ytinfo. All rights reserved.
//

#import "CSjqMessageObj.h"
#import "SQLLiteDBManager.h"
#import "UaConfiguration.h"
#import "GlobalDefine.h"

@implementation CSjqMessageObj


-(void)initialize
{

}

-(id)init
{
    self = [super init];
    if (self) {
        //[self initialize];
    }
    return self;
}


//将从服务端下载下来的消息写入本地数据库，返回实际写入数据库的记录的行数
-(int)writeMessageToLocalDB:(QDataSetObj*)pDataSet
{
    if(pDataSet == nil)
        return 0;
    //
    NSString* strLocalUserId = [UaConfiguration sharedInstance].m_setLoginState.m_strUserLoginName;
    int iTotalCount = 0;
    for(int i=0;i<[pDataSet getRowCount];i++)
    {
        NSString* strID =[pDataSet getFeildValue:i andColumn:@"id"];
        NSString*strFromId = [pDataSet getFeildValue:i andColumn:@"from"];
        //全部取小写
        strFromId = [strFromId lowercaseString];
        if(strFromId.length < 1)
        {
            NSString* strMsgType = [pDataSet getFeildValue:i andColumn:@"msgType"];
            int iMsgType = [QDataSetObj convertToInt:strMsgType];
            if(iMsgType == 2)//系统消息
            {
                strFromId = FROM_ID_SYSTEM;
            }
            else if(iMsgType == 3)//公共消息
            {
                strFromId = FROM_ID_PUBLIC;
            }
        }
        
        if([self isHaveSaveInDb:strID] == true)
        {
            //如果是对方发送的消息，并且本地已经存在，则不需要再从服务器上下载了
            if([strFromId isEqualToString:strLocalUserId] == false)
            {
                continue;
            }
            break;
        }
        
        NSString*strFromHeadUrl = [pDataSet getFeildValue:i andColumn:@"fromHeadUrl"];
        NSString* strToId = [pDataSet getFeildValue:i andColumn:@"to"];
        strToId = [strToId lowercaseString];
        NSString* strToHeadUrl = [pDataSet getFeildValue:i andColumn:@"toHeadUrl"];
        NSString* strMessage = [pDataSet getFeildValue:i andColumn:@"message"];
        NSString* strTime = [pDataSet getFeildValue:i andColumn:@"sendTime"];
        bool blSave = [self insertMessageToDb:strID andFrom:strFromId andHead1:strFromHeadUrl andToId:strToId andHead2:strToHeadUrl andMessage:strMessage andTime:strTime];
        if(blSave == false)
            continue;
        iTotalCount++;
       
    }
    return iTotalCount;
}



//判断当前的记录是否已经写入本地数据库
-(bool)isHaveSaveInDb:(NSString*)strFlowId
{
    NSString* strSQL = [NSString stringWithFormat:@"select id from t_message_log where flowId=%@",strFlowId];
    sqlite3_stmt *stmt;
    
    SQLLiteDBManager *manager = [[SQLLiteDBManager alloc]init];
    if (![manager prepareSQL:strSQL andStmt:&stmt] || !stmt) {
        return false;
    }
    bool blHaveId = false;
    if(sqlite3_step(stmt) ==SQLITE_ROW)
        blHaveId = true;

    sqlite3_finalize(stmt);
    [manager closeSQLLiteDB];
    
    return  blHaveId;
  
}

//将发送的消息写到本地数据库
-(bool)WriteSendLogToLocalDB:(SetRowObj*)pRowObj
{
    if(pRowObj == nil)
        return false;

    NSString* strFlowID = [pRowObj getFieldValue:@"flowId"];
    NSString* strUserId = [pRowObj getFieldValue:@"userId"];
    NSString* strFriendId = [pRowObj getFieldValue:@"friendId"];
    NSString* strMessageInfo = [pRowObj getFieldValue:@"messageInfo"];
    NSString* strSendTime = [pRowObj getFieldValue:@"sendTime"];
    int iMessageType = 2;
    NSString* strSQL = [NSString stringWithFormat:@"insert into t_message_log(flowId,userId,friendId,messageInfo,isRead,messageType,createTime)values(%@,'%@','%@','%@',1,%d,'%@')",strFlowID,strUserId,strFriendId,strMessageInfo,iMessageType,strSendTime];
    
    SQLLiteDBManager *manager = [[SQLLiteDBManager alloc]init];
    if([manager execSQL:strSQL] == false)
        return false;
    
    return true;
   
}

//写一条消息到本地的数据库
-(bool)insertMessageToDb:(NSString*)strFlowID andFrom:(NSString*)strFromId andHead1:(NSString*)strFromHead andToId:(NSString*)strToId andHead2:(NSString*)strToHead andMessage:(NSString*)strMessageInfo andTime:(NSString*)strSendTime
{
    NSString* strUserId = [UaConfiguration sharedInstance].m_setLoginState.m_strUserLoginName;
    NSString* strUserHeadUrl = @"";
    NSString* strFriendId = @"";
    NSString* strFriendHeadUrl = @"";
    //1_接收到的消息;2_发送的消息
    int iMessageType = 1;
    if([strUserId isEqualToString:strFromId])
    {
        iMessageType = 2;
        strUserHeadUrl = strFromHead;
        strFriendId = strToId;
        strFriendHeadUrl = strToHead;
    }
    else
    {
        strUserHeadUrl = strToHead;
        strFriendId = strFromId;
        strFriendHeadUrl = strFromHead;
        
    }
    if(strUserId.length < 1 || strFriendId.length <1)
        return  false;
    //默认是已读(0_未读)
    NSInteger iIsRead = 1;
    NSString* strSQL = [NSString stringWithFormat:@"insert into t_message_log(flowId,userId,friendId,messageInfo,isRead,messageType,createTime)values(%@,'%@','%@','%@',%d,%d,'%@')",strFlowID,strUserId,strFriendId,strMessageInfo,iIsRead,iMessageType,strSendTime];
    SQLLiteDBManager *manager = [[SQLLiteDBManager alloc]init];
    if([manager execSQL:strSQL] == false)
        return false;
    //处理用户自己的头像
    [self DealUserHeadImageUrl:strUserId andUrl:strUserHeadUrl];
    //处理好友的头像
    [self DealUserHeadImageUrl:strFriendId andUrl:strFriendHeadUrl];
    
    return true;

}

//写用户的头像信息到本地数据库
-(bool)DealUserHeadImageUrl:(NSString*)strUserId andUrl:(NSString*)strHeadUrl
{
    if(strUserId.length < 1 || strHeadUrl.length < 1)
        return false;
    NSString* strDbHeadUrl = [self getUserHeadImageUrl:strUserId];
    bool blResult = true;
    if(strDbHeadUrl.length < 1)
    {
        blResult = [self insertUserHeadImageUrl:strUserId andUrl:strHeadUrl];
    }
    else
    {
        if([strDbHeadUrl isEqualToString:strHeadUrl] == false)
        {
            //更新头像信息
            blResult = [self modifyUserHeadImageUrl:strUserId andUrl:strHeadUrl];
        }
        
    }
    return blResult;
}

//写账号及账号对应的Url写入数据库
-(bool)insertUserHeadImageUrl:(NSString*)strUserId andUrl:(NSString*)strHeadUrl
{
    NSString* strSQL = [NSString stringWithFormat:@"insert into t_userHeadImages(userId,headImgURl)values('%@','%@')",strUserId,strHeadUrl];
    SQLLiteDBManager *manager = [[SQLLiteDBManager alloc]init];
    if([manager execSQL:strSQL] == false)
        return false;
    return true;
}

//写账号及账号对应的Url写入数据库
-(bool)modifyUserHeadImageUrl:(NSString*)strUserId andUrl:(NSString*)strHeadUrl
{
    NSString* strSQL = [NSString stringWithFormat:@"update t_userHeadImages set headImgUrl='%@' where userId='%@' ",strHeadUrl,strUserId];
    SQLLiteDBManager *manager = [[SQLLiteDBManager alloc]init];
    if([manager execSQL:strSQL] == false)
        return false;
    return true;
}

//根据账号，获取用户对应的头像的url
-(NSString*)getUserHeadImageUrl:(NSString*)strUserId
{

    NSString* strSQL = [NSString stringWithFormat:@"select headImgUrl from t_userHeadImages where userId='%@' ",strUserId];
    
    sqlite3_stmt *stmt;
    SQLLiteDBManager *manager = [[SQLLiteDBManager alloc]init];
    if (![manager prepareSQL:strSQL andStmt:&stmt] || !stmt) {
        return @"";
    }
    if(sqlite3_step(stmt) != SQLITE_ROW)
        return @"";
    
    NSString* strHeadUrl = [[NSString alloc] initWithCString:(char*)sqlite3_column_text(stmt,0) encoding:NSUTF8StringEncoding];

    sqlite3_finalize(stmt);
    [manager closeSQLLiteDB];
    
    return strHeadUrl;
}


//根据用户，获取消息列表
-(QDataSetObj*)getMessageListOrderUser
{
   
    NSArray* arFriendsLsit = [self getFriendsList];
    if(arFriendsLsit.count < 1)
        return  nil;
    
    QDataSetObj* pResultDataSet = [[QDataSetObj alloc] init];
    for(int i=0;i<arFriendsLsit.count;i++)
    {
        NSString* strFriendId =[arFriendsLsit objectAtIndex:i];
        SetRowObj* pRowObj = [self getFriendTotalMessageInfo:strFriendId];
        if(pRowObj == nil)
            continue;
        [pResultDataSet addDataSetRow:pRowObj];
    }
    return  pResultDataSet;
}


//获取当前用户所有的，有聊天记录的好友列表
-(NSMutableArray*)getFriendsList
{

    NSString* strUserId = [UaConfiguration sharedInstance].m_setLoginState.m_strUserLoginName;
    NSString* strSQL = [NSString stringWithFormat:@"select distinct(friendId) from t_message_log where userId='%@' order by createtime desc ",strUserId];
    
    sqlite3_stmt *stmt;
    SQLLiteDBManager *manager = [[SQLLiteDBManager alloc]init];
    if (![manager prepareSQL:strSQL andStmt:&stmt] || !stmt) {
        return false;
    }
    bool blLoadSystemMsg = false;
    NSMutableArray* arFriendIdList = [[NSMutableArray alloc] init];
    //int iRow = -1;
    while (sqlite3_step(stmt) ==SQLITE_ROW)
    {
     
        NSString* strFriendId = [[NSString alloc] initWithCString:(char*)sqlite3_column_text(stmt,0) encoding:NSUTF8StringEncoding];

       // iRow++;
        if([strFriendId isEqualToString:FROM_ID_SYSTEM] == true)//系统消息
        {
            [arFriendIdList insertObject:strFriendId atIndex:0];
            blLoadSystemMsg = true;
            continue;
        }
        else if([strFriendId isEqualToString:FROM_ID_PUBLIC] == true)//公告消息
        {
            if(blLoadSystemMsg == false)
            {
                [arFriendIdList insertObject:strFriendId atIndex:0];
                continue;
            }
            else
            {
                if(arFriendIdList.count > 1)
                {
                    [arFriendIdList insertObject:strFriendId atIndex:1];
                    continue;
                }
            }
        }
        [arFriendIdList addObject:strFriendId];
       
    }

    sqlite3_finalize(stmt);
    [manager closeSQLLiteDB];
    
    return arFriendIdList;
}

//获取好友总的聊天记录，包括总数，未读的有多少条，以及最近一次的通话记录
-(SetRowObj*)getFriendTotalMessageInfo:(NSString*)strFriendId
{
    

    QDataSetObj* pFriendDataSet = [self getFriendMessageListInfo:strFriendId andGetFlag:0];
    if(pFriendDataSet == nil)
        return nil;
    SetRowObj* pRowObj = [[SetRowObj alloc] init];
    int iTotalCount = [pFriendDataSet getRowCount];
    int iNoReadCoun = 0;
    for(int i=0;i<iTotalCount;i++)
    {
        NSString* strIsRead = [pFriendDataSet getFeildValue:i andColumn:@"isRead"];
        if([strIsRead isEqualToString:@"0"])
            iNoReadCoun++;
    }
    
    [pRowObj addFieldObj:@"totalCount" andValue:[NSString stringWithFormat:@"%d",iTotalCount]];
    
    [pRowObj addFieldObj:@"noReadCount" andValue:[NSString stringWithFormat:@"%d",iNoReadCoun]];
    int iLastRow =iTotalCount-1;
 
    [pRowObj addFieldObj:@"userHeadUrl" andValue:[pFriendDataSet getFeildValue:iLastRow andColumn:@"userHeadUrl"]];
    
    [pRowObj addFieldObj:@"friendId" andValue:[pFriendDataSet getFeildValue:iLastRow andColumn:@"friendId"]];
    
    [pRowObj addFieldObj:@"friendHeadUrl" andValue:[pFriendDataSet getFeildValue:iLastRow andColumn:@"friendHeadUrl"]];
    
    [pRowObj addFieldObj:@"messageInfo" andValue:[pFriendDataSet getFeildValue:iLastRow andColumn:@"messageInfo"]];

    NSString* strSendTime = [pFriendDataSet getFeildValue:iLastRow andColumn:@"sendTime"];
    strSendTime = [self getMessageShowTime:strSendTime];
    [pRowObj addFieldObj:@"sendTime" andValue:strSendTime];
    return pRowObj;
}

//获取和指定好友的聊天记录的总数或则未读消息的总数
-(NSInteger)getFriendMessageCount:(NSString*)strFriendId andRead:(NSInteger)iReadFlag
{
    NSString* strUserId = [UaConfiguration sharedInstance].m_setLoginState.m_strUserLoginName;
    NSString* strSQL = @"";
    if(iReadFlag == -1)
    {
        strSQL = [NSString stringWithFormat:@"select count(id) from t_message_log where userId='%@' and friendId='%@'   ",strUserId,strFriendId];
    }
    else
    {
        strSQL = [NSString stringWithFormat:@"select count(id) from t_message_log where userId='%@' and friendId='%@'   ",strUserId,strFriendId];
    }
    sqlite3_stmt *stmt;
    SQLLiteDBManager *manager = [[SQLLiteDBManager alloc]init];
    if (![manager prepareSQL:strSQL andStmt:&stmt] || !stmt) {
        return nil;
    }

    NSString* strRecCount = @"";
    if(sqlite3_step(stmt) ==SQLITE_ROW)
    {
        strRecCount = [[NSString alloc] initWithCString:(char*)sqlite3_column_text(stmt,0) encoding:NSUTF8StringEncoding];
    }
 
    int iRecCount = [QDataSetObj convertToInt:strRecCount];
    
    sqlite3_finalize(stmt);
    [manager closeSQLLiteDB];
    
    return iRecCount;
    
}


//获取和指定用户的聊天记录
-(QDataSetObj*)getFriendMessageListInfo:(NSString*)strFriendId andGetFlag:(NSInteger)iGetFlag
{
    NSString* strUserId = [UaConfiguration sharedInstance].m_setLoginState.m_strUserLoginName;
    NSString* strSQL = @"";
    if(iGetFlag == 0)
    {
        strSQL = [NSString stringWithFormat:@"select  flowId,messageInfo,messageType,isRead,createTime from t_message_log where userId='%@' and friendId='%@' order by createtime ",strUserId,strFriendId];
    }
    else
    {
        strSQL = [NSString stringWithFormat:@"select top 1 flowId,messageInfo,messageType,isRead,createTime from t_message_log where userId='%@' and friendId='%@' order by createtime desc ",strUserId,strFriendId];
    }
    sqlite3_stmt *stmt;
    SQLLiteDBManager *manager = [[SQLLiteDBManager alloc]init];
    if (![manager prepareSQL:strSQL andStmt:&stmt] || !stmt) {
        return nil;
    }

    QDataSetObj* pResultDataSet = [[QDataSetObj alloc] init];
    NSString* strFlowID = @"";
    NSString* strUserHeadUrl = [self getUserHeadImageUrl:strUserId];
    NSString* strFriendHeadUrl =[self getUserHeadImageUrl:strFriendId];
    
    NSString* strMessageInfo = @"";
    NSString* strMessageType = @"";
    NSString* strIsRead = @"";
    NSString* strSendTime = @"";
    int iRow = -1;
    while (sqlite3_step(stmt) ==SQLITE_ROW)
    {
        strFlowID = [[NSString alloc] initWithCString:(char*)sqlite3_column_text(stmt,0) encoding:NSUTF8StringEncoding];
        //
        strMessageInfo = [[NSString alloc] initWithCString:(char*)sqlite3_column_text(stmt,1) encoding:NSUTF8StringEncoding];
        strMessageType = [[NSString alloc] initWithCString:(char*)sqlite3_column_text(stmt,2) encoding:NSUTF8StringEncoding];
        strIsRead = [[NSString alloc] initWithCString:(char*)sqlite3_column_text(stmt,3) encoding:NSUTF8StringEncoding];
        strSendTime = [[NSString alloc] initWithCString:(char*)sqlite3_column_text(stmt,4) encoding:NSUTF8StringEncoding];
        
        iRow++;
        [pResultDataSet addDataSetRow_Ext:iRow andName:@"flowId" andValue:strFlowID];
        [pResultDataSet addDataSetRow_Ext:iRow andName:@"userId" andValue:strUserId];
        [pResultDataSet addDataSetRow_Ext:iRow andName:@"userHeadUrl" andValue:strUserHeadUrl];
        [pResultDataSet addDataSetRow_Ext:iRow andName:@"friendId" andValue:strFriendId];
        [pResultDataSet addDataSetRow_Ext:iRow andName:@"friendHeadUrl" andValue:strFriendHeadUrl];
        [pResultDataSet addDataSetRow_Ext:iRow andName:@"messageInfo" andValue:strMessageInfo];
        [pResultDataSet addDataSetRow_Ext:iRow andName:@"messageType" andValue:strMessageType];
        [pResultDataSet addDataSetRow_Ext:iRow andName:@"isRead" andValue:strIsRead];
        [pResultDataSet addDataSetRow_Ext:iRow andName:@"sendTime" andValue:strSendTime];
        
    }
    
    sqlite3_finalize(stmt);
    [manager closeSQLLiteDB];
    
    return  pResultDataSet;
}


//获取和指定用户的聊天记录
/*
-(QDataSetObj*)getUserMessageListInfo
{
    NSString* strUserId = [UaConfiguration sharedInstance].m_setLoginState.m_strUserLoginName;
    NSString* strSQL = strSQL = [NSString stringWithFormat:@"select flowId,userHeadUrl,friendId,friendHeadUrl,messageInfo,messageType,isRead,createTime from t_message_log where userId='%@'  order by friendId,createtime desc  ",strUserId];

    sqlite3_stmt *stmt;
    SQLLiteDBManager *manager = [[SQLLiteDBManager alloc]init];
    if (![manager prepareSQL:strSQL andStmt:&stmt] || !stmt) {
        return nil;
    }

    QDataSetObj* pResultDataSet = [[QDataSetObj alloc] init];
    NSString* strFlowID = @"";
    NSString* strUserHeadUrl = @"";
    NSString* strFriendId = @"";
    NSString* strFriendHeadUrl = @"";
    NSString* strMessageInfo = @"";
    NSString* strMessageType = @"";
    NSString* strIsRead = @"";
    NSString* strSendTime = @"";
    int iRow = -1;
    while (sqlite3_step(stmt) ==SQLITE_ROW)
    {
        strFlowID = [[NSString alloc] initWithCString:(char*)sqlite3_column_text(stmt,0) encoding:NSUTF8StringEncoding];
        //
        if(strUserHeadUrl.length < 1)
        {
            strUserHeadUrl = [[NSString alloc] initWithCString:(char*)sqlite3_column_text(stmt,1) encoding:NSUTF8StringEncoding];
        }
        
        strFriendId = [[NSString alloc] initWithCString:(char*)sqlite3_column_text(stmt,2) encoding:NSUTF8StringEncoding];
        
        strFriendHeadUrl = [[NSString alloc] initWithCString:(char*)sqlite3_column_text(stmt,3) encoding:NSUTF8StringEncoding];

        //
        strMessageInfo = [[NSString alloc] initWithCString:(char*)sqlite3_column_text(stmt,4) encoding:NSUTF8StringEncoding];
        strMessageType = [[NSString alloc] initWithCString:(char*)sqlite3_column_text(stmt,5) encoding:NSUTF8StringEncoding];
        strIsRead = [[NSString alloc] initWithCString:(char*)sqlite3_column_text(stmt,6) encoding:NSUTF8StringEncoding];
        strSendTime = [[NSString alloc] initWithCString:(char*)sqlite3_column_text(stmt,7) encoding:NSUTF8StringEncoding];
        
        iRow++;
        [pResultDataSet addDataSetRow_Ext:iRow andName:@"flowId" andValue:strFlowID];
        [pResultDataSet addDataSetRow_Ext:iRow andName:@"userId" andValue:strUserId];
        [pResultDataSet addDataSetRow_Ext:iRow andName:@"userHeadUrl" andValue:strUserHeadUrl];
        [pResultDataSet addDataSetRow_Ext:iRow andName:@"friendId" andValue:strFriendId];
        [pResultDataSet addDataSetRow_Ext:iRow andName:@"friendHeadUrl" andValue:strFriendHeadUrl];
        [pResultDataSet addDataSetRow_Ext:iRow andName:@"messageInfo" andValue:strMessageInfo];
        [pResultDataSet addDataSetRow_Ext:iRow andName:@"messageType" andValue:strMessageInfo];
        [pResultDataSet addDataSetRow_Ext:iRow andName:@"isRead" andValue:strIsRead];
        [pResultDataSet addDataSetRow_Ext:iRow andName:@"sendTime" andValue:strSendTime];
        
    }
    sqlite3_finalize(stmt);
    [manager closeSQLLiteDB];
    
    return  pResultDataSet;
}
 */

//提取最近一条未读的消息
-(NSString*)getOneNoReadMessageInfo
{
    NSString* strUserId = [UaConfiguration sharedInstance].m_setLoginState.m_strUserLoginName;
    NSString* strSQL = strSQL = [NSString stringWithFormat:@"select  messageInfo from t_message_log where userId='%@' and isRead=0  order by createtime desc limit 1 ",strUserId];
    
    sqlite3_stmt *stmt;
    SQLLiteDBManager *manager = [[SQLLiteDBManager alloc]init];
    if (![manager prepareSQL:strSQL andStmt:&stmt] || !stmt) {
        return nil;
    }
    if((sqlite3_step(stmt) != SQLITE_ROW))
        return @"";
    NSString* strMessageInfo = [[NSString alloc] initWithCString:(char*)sqlite3_column_text(stmt,0) encoding:NSUTF8StringEncoding];
    
     sqlite3_finalize(stmt);
    [manager closeSQLLiteDB];
    
    return  strMessageInfo;
}

-(NSString*)getMessageShowTime:(NSString*)strOraTime
{
    NSDate* nsShowTime = [self convertDateFromString:strOraTime];
    if(nsShowTime == nil)
        return @"";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"yyyy.MM.dd HH:mm"];

    NSString* strShowTime = [dateFormatter stringFromDate:nsShowTime];
    return  strShowTime;
}

//将unix时间进行格式转换，可以用于直接显示
+(NSString*)convertToShowTime:(NSInteger)iOraTime
{

    NSDate* nsShowTime = [NSDate dateWithTimeIntervalSince1970:iOraTime];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"yyyy.MM.dd HH:mm"];
    NSString* strTime = [dateFormatter stringFromDate:nsShowTime];
    return  strTime;
}

//将unix时间转换成可以显示的时间
+(NSString*)convertToShowTime_pay:(NSInteger)iOraTime
{
    NSDate* nsShowTime = [NSDate dateWithTimeIntervalSince1970:iOraTime];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString* strTime = [dateFormatter stringFromDate:nsShowTime];
    return  strTime;
}


-(NSDate*) convertDateFromString:(NSString*)uiDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy.MM.dd HH:mm:ss"];
    NSDate *date=[formatter dateFromString:uiDate];
    if(date == nil)
    {
        [formatter setDateFormat:@"yyyy.MM.dd HH:mm"];
        date=[formatter dateFromString:uiDate];
    }
    
    return date;
}



//获取消息显示当前的时间
-(NSString*)getMessageReallyTime
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"yyyy.MM.dd HH:mm:ss"];
    NSString* strTime = [dateFormatter stringFromDate:[NSDate date]];
    return  strTime;
}

//页面刷新的时候，用于获取指定信息最后的时间
-(int)getInfoLastQueryTime:(NSInteger)iInfoId andName:(NSString*)strInfoName
{
    NSString* strUserId = [UaConfiguration sharedInstance].m_setLoginState.m_strUserLoginName;
    
    //
    NSString* strSQL = strSQL = [NSString stringWithFormat:@"SELECT lastTime FROM t_multInfoQTime where userid='%@' and infoId=%d  ",strUserId,iInfoId];
    
    sqlite3_stmt *stmt;
    SQLLiteDBManager *manager = [[SQLLiteDBManager alloc]init];
    if (![manager prepareSQL:strSQL andStmt:&stmt] || !stmt) {
        return nil;
    }
    
    int iLastTime = 0;
    if(sqlite3_step(stmt)!= SQLITE_ROW )
    {
        [self insertInfoQTimeToDb:iInfoId andName:strInfoName];
    }
    else
    {
        NSString* strLastTime = [[NSString alloc] initWithCString:(char*)sqlite3_column_text(stmt,0) encoding:NSUTF8StringEncoding];
        iLastTime = [QDataSetObj convertToInt:strLastTime];
    }
    
    sqlite3_finalize(stmt);
    [manager closeSQLLiteDB];
    
    return  iLastTime;
}

//写入数据库
-(bool)insertInfoQTimeToDb:(NSInteger)iInfoId andName:(NSString*)strInfoName
{
    NSString* strUserId = [UaConfiguration sharedInstance].m_setLoginState.m_strUserLoginName;
    
    //
    NSString* strSQL = [NSString stringWithFormat:@"insert into t_multInfoQTime(userId,infoId,infoName,lastTime)values('%@',%d,'%@',0) ",strUserId,iInfoId,strInfoName];
    //
    SQLLiteDBManager *manager = [[SQLLiteDBManager alloc]init];
    bool blResult = [manager execSQL:strSQL];
    [manager closeSQLLiteDB];
    
    return  blResult;
}

//修改指定消息最后的更新时间
-(bool)modInfoLastQueryTime:(NSInteger)iInfoId andTime:(int)iLastQTime
{
    NSString* strUserId = [UaConfiguration sharedInstance].m_setLoginState.m_strUserLoginName;
    
    //
    NSString* strSQL = strSQL = [NSString stringWithFormat:@"update t_multInfoQTime set lastTime=%d where userId='%@' and infoId=%d ",iLastQTime,strUserId,iInfoId];
    //
    SQLLiteDBManager *manager = [[SQLLiteDBManager alloc]init];
    bool blResult = [manager execSQL:strSQL];
    [manager closeSQLLiteDB];
    
    return  blResult;
}

//从本地数据库中提取所有信息的查询时间信息
-(QDataSetObj*)getMultInfoLastQTimes:(NSString*)strUserId
{

    NSString* strSQL = strSQL = [NSString stringWithFormat:@"select id,infoId,infoName,lastTime FROM t_multInfoQTime where userId='%@' ",strUserId];
    
    sqlite3_stmt *stmt;
    SQLLiteDBManager *manager = [[SQLLiteDBManager alloc]init];
    if (![manager prepareSQL:strSQL andStmt:&stmt] || !stmt) {
        return nil;
    }
    
    QDataSetObj* pResultDataSet = [[QDataSetObj alloc] init];
    NSString* strRecId = @"";
    NSString* strInfoId = @"";
    NSString* strInfoName = @"";
    NSString* strLastTime = @"";

    int iRow = -1;
    while (sqlite3_step(stmt) ==SQLITE_ROW)
    {
        strRecId = [[NSString alloc] initWithCString:(char*)sqlite3_column_text(stmt,0) encoding:NSUTF8StringEncoding];
        strInfoId = [[NSString alloc] initWithCString:(char*)sqlite3_column_text(stmt,1) encoding:NSUTF8StringEncoding];
        strInfoName = [[NSString alloc] initWithCString:(char*)sqlite3_column_text(stmt,2) encoding:NSUTF8StringEncoding];
        strLastTime = [[NSString alloc] initWithCString:(char*)sqlite3_column_text(stmt,3) encoding:NSUTF8StringEncoding];
        
        iRow++;
        [pResultDataSet addDataSetRow_Ext:iRow andName:@"id" andValue:strRecId];
        [pResultDataSet addDataSetRow_Ext:iRow andName:@"infoId" andValue:strInfoId];
        [pResultDataSet addDataSetRow_Ext:iRow andName:@"iInfoName" andValue:strInfoName];
        [pResultDataSet addDataSetRow_Ext:iRow andName:@"lastTime" andValue:strLastTime];
        [pResultDataSet addDataSetRow_Ext:iRow andName:@"isUpdate" andValue:@"0"];
    }
    sqlite3_finalize(stmt);
    [manager closeSQLLiteDB];
    
    return  pResultDataSet;
}


//获取用户未读的消息总数
-(NSInteger)getUserNoReadMessageCount
{
    
    NSString* strUserId = [UaConfiguration sharedInstance].m_setLoginState.m_strUserLoginName;
    if(strUserId.length < 1)
        return 0;
    NSString* strSQL  = [NSString stringWithFormat:@"select count(id) from t_message_log where userId='%@' and isRead=0 ",strUserId];
    
    sqlite3_stmt *stmt;
    SQLLiteDBManager *manager = [[SQLLiteDBManager alloc]init];
    if (![manager prepareSQL:strSQL andStmt:&stmt] || !stmt) {
        return nil;
    }
    if(sqlite3_step(stmt) != SQLITE_ROW)
        return 0;
    NSString* strCount = [[NSString alloc] initWithCString:(char*)sqlite3_column_text(stmt,0) encoding:NSUTF8StringEncoding];
     sqlite3_finalize(stmt);
    [manager closeSQLLiteDB];
    
    return  [QDataSetObj convertToInt:strCount];
}

//将信息修改为已读
-(bool)setMessageStateToRead:(NSString*)strUserId andFriend:(NSString*)strFriendId
{
    NSString* strSQL = strSQL = [NSString stringWithFormat:@"update t_message_log set isRead=1 where userId='%@' and friendId='%@' ",strUserId,strFriendId];
    //
    SQLLiteDBManager *manager = [[SQLLiteDBManager alloc]init];
    bool blResult = [manager execSQL:strSQL];
    [manager closeSQLLiteDB];
    return blResult;
}

//删除和某个朋友的聊天记录
-(NSInteger)deleteMessageLogByFriend:(NSString*)strUserId andFriend:(NSString*)strFriendId
{
    NSString* strSQL = strSQL = [NSString stringWithFormat:@"delete from t_message_log  where userId='%@' and friendId='%@' ",strUserId,strFriendId];
    //
    SQLLiteDBManager *manager = [[SQLLiteDBManager alloc]init];
    bool blResult = [manager execSQL:strSQL];
    [manager closeSQLLiteDB];
    return blResult;
}

//清理记录
-(void)clearMaxCountMessageLog:(NSString*)strUserName
{
    if(strUserName.length < 1)
        return;
    NSString* strMaxTime = [self getMessageLogTimeMaxCount:strUserName];
    if(strMaxTime.length < 4)
        return;
    [self deleteMessageLogMaxCount:strUserName andTime:strMaxTime];
}


//获取超过100条记录的时间
-(NSString*)getMessageLogTimeMaxCount:(NSString*)strUserName
{
    NSString* strSQL = [NSString stringWithFormat:@"select  createTime  from t_message_log where userId='%@'  order by createTime desc ",strUserName];
    
    sqlite3_stmt *stmt;
    SQLLiteDBManager *manager = [[SQLLiteDBManager alloc]init];
    if (![manager prepareSQL:strSQL andStmt:&stmt] || !stmt) {
        return 0;
    }
    
    int iRowCount = 0;
    NSString* strMaxLastTime = @"";
    
    while (sqlite3_step(stmt) == SQLITE_ROW)
    {
        
        NSString* strTime = [[NSString alloc] initWithCString:(char*)sqlite3_column_text(stmt,0) encoding:NSUTF8StringEncoding];
        
        iRowCount++;
        if(iRowCount >= MAXCOUNT_ROW_LOCALDB)
        {
            strMaxLastTime = strTime;
            break;
        }
    }
    
    sqlite3_finalize(stmt);
    [manager closeSQLLiteDB];
    return  strMaxLastTime;
    
}


-(bool)deleteMessageLogMaxCount:(NSString*)strUserName andTime:(NSString*)strLastTime
{
    NSString* strSQL = [NSString stringWithFormat:@"delete from t_message_log where userId='%@' and  createtime <= '%@' ",strUserName,strLastTime];
    
    SQLLiteDBManager *manager = [[SQLLiteDBManager alloc]init];
    if([manager execSQL:strSQL] == false)
        return false;
    
    return true;
}


@end
