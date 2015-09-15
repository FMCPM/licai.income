/*------------------------------------------------------------------------
 Filename       : 	AppInitDataMethod.m
 
 Description	:   自定义的一个类：封装了App初始化时，从服务器获取相关的初始化数据
 
 Author         :   lzq,lvzhuqiang@ytinfo.zj.cn
 
 Date           :   2014-04-16
 
 version        :   v1.0
 
 Copyright      :   2014年 ytinfo. All rights reserved.
 
 ------------------------------------------------------------------------*/

#import "AppInitDataMethod.h"
#import "UaConfiguration.h"
#import "CKHttpHelper.h"
#import "SQLLiteDBManager.h"
#import "HistoryLogMethod.h"
#import "CSjqMessageObj.h"

@implementation AppInitDataMethod


- (id)init
{
    self = [super init];
    if (self) {
   
    }

    
    return self;
}





//获取物流公司信息
-(void)initExpreeEnters
{
    //执行数据库升级脚本
    [self executeAppDbUpdateSQL];
    //清理数据库
    [self clearMaxCountInfoFromDb];
    
    if([[UaConfiguration sharedInstance] userIsHaveLoadinSystem] == NO)
    {
        return;
    }
    if([UaConfiguration sharedInstance].m_setLoginState.m_strUserLoginSid.length < 1)
    {
        return;
    }
    /*
    if([UaConfiguration sharedInstance].m_isLoadedAppInitData == 1)
    {
        NSLog(@"have loaded app init data");
        return;
    }
     */
	CKHttpHelper *pHttpHelper = [CKHttpHelper httpHelperWithOwner:self];
	pHttpHelper.m_iWebServerType =1;
	pHttpHelper.methodType=  CKHttpMethodTypePost_Page;
    [pHttpHelper setMethodName:@"order.getExpressEnter"];
    [pHttpHelper addParam:[UaConfiguration sharedInstance].m_setLoginState.m_strUserLoginSid forName:@"sid"];
    
	[pHttpHelper setCompleteBlock:^(id dataSet)
	 {
        // [UaConfiguration sharedInstance].m_isLoadedAppInitData = 1;
         QDataSetObj* pDataSet = dataSet;
         [self writeExpressEntersData:pDataSet];
         [self initOrderCancelReasons];
	 }];
    
	[pHttpHelper start];
    
}

//清理超过规定数量的历史记录
-(void)clearMaxCountInfoFromDb
{
    HistoryLogMethod* pMethod = [[HistoryLogMethod alloc] init];
    [pMethod clearMaxCountHistoryLog:[UaConfiguration sharedInstance].m_setLoginState.m_strUserLoginName];
    
    CSjqMessageObj* pMessageObj = [[CSjqMessageObj alloc] init];
    [pMessageObj clearMaxCountMessageLog:[UaConfiguration sharedInstance].m_setLoginState.m_strUserLoginName];
}


//订单取消原因
-(void)initOrderCancelReasons
{
  	CKHttpHelper *pHttpHelper = [CKHttpHelper httpHelperWithOwner:self];
	pHttpHelper.m_iWebServerType =1;
	pHttpHelper.methodType=  CKHttpMethodTypePost_Page;
    [pHttpHelper setMethodName:@"order.getCancelReason"];
    [pHttpHelper addParam:[UaConfiguration sharedInstance].m_setLoginState.m_strUserLoginSid forName:@"sid"];
    
	[pHttpHelper setCompleteBlock:^(id dataSet)
	 {
         QDataSetObj* pDataSet = dataSet;
         [self writeReasonsData:1 andData:pDataSet];
         [self initMoneyRefundReasons];
	 }];
    
	[pHttpHelper start];
}

//退款原因
-(void)initMoneyRefundReasons
{
    CKHttpHelper *pHttpHelper = [CKHttpHelper httpHelperWithOwner:self];
	pHttpHelper.m_iWebServerType =1;
	pHttpHelper.methodType=  CKHttpMethodTypePost_Page;
    [pHttpHelper setMethodName:@"order.getRefundReason"];
    [pHttpHelper addParam:[UaConfiguration sharedInstance].m_setLoginState.m_strUserLoginSid forName:@"sid"];
    
	[pHttpHelper setCompleteBlock:^(id dataSet)
	 {
         QDataSetObj* pDataSet = dataSet;
         [self writeReasonsData:2 andData:pDataSet];
         [self initUserStoreWapUrl];
	 }];
    
	[pHttpHelper start];
    //
}

//获取店铺资料
-(void)initUserStoreWapUrl
{
    
    CKHttpHelper *pHttpHelper = [CKHttpHelper httpHelperWithOwner:self];
    pHttpHelper.m_iWebServerType = 1;
    pHttpHelper.methodType = CKHttpMethodTypePost_Page;
    //设置webservice方法名
    [pHttpHelper setMethodName:@"store.getStoreInfo"];
    
    //设置参数，顺序可以随意
    [pHttpHelper addParam:[UaConfiguration sharedInstance].m_setLoginState.m_strUserLoginSid forName:@"sid"];
    
    NSString* strStoreId = @"";//[NSString stringWithFormat:@"%d", [UaConfiguration sharedInstance].m_setLoginState.m_iUserStoreID];
    //店铺id
    [pHttpHelper addParam:strStoreId forName:@"storeId"];
    
    //设置结束block（webservice方法结束后，会自动调用）
    [pHttpHelper setCompleteBlock:^(id dataSet)
     {
         QDataSetObj* pDataSet = dataSet;
         if(pDataSet == nil)
             return ;
         if([pDataSet getOpeResult] == false)
             return;
         if([pDataSet getRowCount] < 1)
             return;
         NSString* strWapUrl = [pDataSet getFeildValue:0 andColumn:@"phoneShopUrl"];
         NSLog(@"wapurl=%@",strWapUrl);
         if(strWapUrl.length < 1)
             strWapUrl = @"";
         NSString* strStoreName = [pDataSet getFeildValue:0 andColumn:@"name"];
         NSString* strImgUrl = [pDataSet getFeildValue:0 andColumn:@"imgUrl"];
         [self setWapUrl:strWapUrl andName:strStoreName andImgUrl:strImgUrl];
         [self downloadUserHeaderImages];
     }];
    //开始连接

    [pHttpHelper start];
}

//设置店铺的wapurl和name的参数，app其它地方需要用到此参数
-(void)setWapUrl:(NSString*)strUrl andName:(NSString*)strName andImgUrl:(NSString *)strImgUrl
{
/*
    [UaConfiguration sharedInstance].m_setLoginState.m_strUserStoreWapUrl = strUrl;
    [UaConfiguration sharedInstance].m_setLoginState.m_strUserStoreName = strName;
    [UaConfiguration sharedInstance].m_setLoginState.m_strUserStoreImgUrl = strImgUrl;
*/
}

-(void)downloadUserHeaderImages
{
    
   /*
    if([UaConfiguration sharedInstance].m_setLoginState.m_strUserHeadImgPath.length == 0)
        return;
    if( [UaConfiguration sharedInstance].m_pUserHeadImage != nil)
        return;
    CKHttpImageHelper* pImgHelper = [CKHttpImageHelper httpHelperWithOwner:self];
    [CKHttpImageHelper setImageCachePolicy:NSURLRequestReloadIgnoringCacheData];
    
    //用户头像
    NSURL *nsImageReqUrl = [NSURL URLWithString:[UaConfiguration sharedInstance].m_setLoginState.m_strUserHeadImgPath];
    if(nsImageReqUrl)
    {
        [pImgHelper addImageUrl:nsImageReqUrl forKey:@"user_header"];
    }
    
    //
    [pImgHelper startWithReceiveBlock:^(UIImage *image, NSString *strKey,BOOL finsh)
     {
         
         [UaConfiguration sharedInstance].m_pUserHeadImage = image;
     }
     ];
    */
    
}


//将快递公司的信息写入本地数据库
-(void)writeExpressEntersData:(QDataSetObj*)pDataSet
{
    if(pDataSet == nil)
        return;
    if([pDataSet getOpeResult] == false)
        return;
    if([pDataSet getRowCount] < 1)
        return;
    NSString* strEnterId = @"";
    NSString* strEnterName = @"";
    NSString* strEnterIckd = @"";//爱查快递的编号
    for(int i=0;i<[pDataSet getRowCount];i++)
    {
        strEnterId = [pDataSet getFeildValue:i andColumn:@"enterId"];
        strEnterName = [pDataSet getFeildValue:i andColumn:@"enterName"];
        strEnterIckd = [pDataSet getFeildValue:i andColumn:@"enterParam"];
        if([self isHaveInEnter:strEnterId] == true)
        {
            [self updateOneExpressEnter:strEnterId andName:strEnterName andIckd:strEnterIckd];
            continue;
        }
        [self insertOneExpressEnter:strEnterId andName:strEnterName andIckd:strEnterIckd];
    }
}

//判断快递公司是否存在
-(bool)isHaveInEnter:(NSString*)strEnterId
{
    NSString* strSQL = [NSString stringWithFormat:@"select id from  t_express_enters where enterId='%@' ",strEnterId];
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

//写入快递公司到本地数据库
-(bool)insertOneExpressEnter:(NSString*)strEnterId andName:(NSString*)strEnterName andIckd:(NSString*)strEnterIckd
{

    NSString* strSQL = [NSString stringWithFormat:@"insert into t_express_enters(enterId,enterName,enterIckd)values('%@','%@','%@')",strEnterId,strEnterName,strEnterIckd];
    
    SQLLiteDBManager *manager = [[SQLLiteDBManager alloc]init];
    if([manager execSQL:strSQL] == false)
        return false;
    
    return true;
}

//修改快递公司信息
-(bool)updateOneExpressEnter:(NSString*)strEnterId andName:(NSString*)strEnterName andIckd:(NSString*)strEnterIckd
{
    NSString* strSQL = [NSString stringWithFormat:@"update t_express_enters set enterIckd='%@',enterName='%@' where enterId='%@' ",strEnterIckd,strEnterName,strEnterId];
    
    SQLLiteDBManager *manager = [[SQLLiteDBManager alloc]init];
    if([manager execSQL:strSQL] == false)
        return false;
    
    return true;
}

//写退款原因或订单取消原因到数据库
-(void)writeReasonsData:(NSInteger)iType andData:(QDataSetObj*)pDataSet
{
    if(pDataSet == nil)
        return;
    if([pDataSet getOpeResult] == false)
        return;
    if([pDataSet getRowCount] < 1)
        return;
    NSString* strReasonInfo = @"";
    NSString* strFieldName = @"reason";
    if(iType == 2)
        strFieldName = @"reasonName";
    for(int i=0;i<[pDataSet getRowCount];i++)
    {
        strReasonInfo = [pDataSet getFeildValue:i andColumn:strFieldName];
        if([self isHaveInReason:iType andInfo:strReasonInfo] == true)
            continue;
        [self insertOneReasonInfo:iType andInfo:strReasonInfo];
    }
    
}

//判断退款原因记录是否存在
-(bool)isHaveInReason:(NSInteger)iReasonType andInfo:(NSString*)strReasionInfo
{
    NSString* strSQL = [NSString stringWithFormat:@"select id from  t_cancelReasons where reasontype=%d and reasonInfo='%@' ",iReasonType,strReasionInfo];
    
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

//写入推荐原因等信息
-(bool)insertOneReasonInfo:(NSInteger)iReasonType andInfo:(NSString*)strReasonInfo
{
    
    NSString* strSQL = [NSString stringWithFormat:@"insert into t_cancelReasons(reasonId,reasonInfo,reasonType)values(0,'%@',%d)",strReasonInfo,iReasonType];
    
    SQLLiteDBManager *manager = [[SQLLiteDBManager alloc]init];
    if([manager execSQL:strSQL] == false)
        return false;
    
    return true;
}
//获取所有的快递公司列表
+(QDataSetObj*)getExptressEnters
{

    NSString* strSQL = @"select enterId,enterName from t_express_enters";
    sqlite3_stmt *stmt;
    SQLLiteDBManager *manager = [[SQLLiteDBManager alloc]init];
    if (![manager prepareSQL:strSQL andStmt:&stmt] || !stmt) {
        return nil;
    }
    NSString* strEnterId = @"";
    NSString* strEnterName= @"";
    int iRow = -1;
    QDataSetObj* pEntersDataSet = [[QDataSetObj alloc] init];
    while (sqlite3_step(stmt) == SQLITE_ROW)
    {
        strEnterId = [[NSString alloc] initWithCString:(char*)sqlite3_column_text(stmt,0) encoding:NSUTF8StringEncoding];
        //
        strEnterName = [[NSString alloc] initWithCString:(char*)sqlite3_column_text(stmt,1) encoding:NSUTF8StringEncoding];
        iRow++;
        [pEntersDataSet addDataSetRow_Ext:iRow andName:@"enterId" andValue:strEnterId];
        [pEntersDataSet addDataSetRow_Ext:iRow andName:@"enterName" andValue:strEnterName];
    }
        
    sqlite3_finalize(stmt);
    [manager closeSQLLiteDB];
    
    return pEntersDataSet;
   
}
//获取订单取消或退款的原因列表
+(QDataSetObj*)getReasonsList:(NSInteger)iReasonType
{
    NSString* strSQL = [NSString stringWithFormat:@"select reasonId,reasonInfo from  t_cancelReasons where reasontype=%d",iReasonType];
    
    sqlite3_stmt *stmt;
    SQLLiteDBManager *manager = [[SQLLiteDBManager alloc]init];
    if (![manager prepareSQL:strSQL andStmt:&stmt] || !stmt) {
        return nil;
    }
    NSString* strReasonId = @"";
    NSString* strReasonInfo= @"";
    int iRow = -1;
    QDataSetObj* pEntersDataSet = [[QDataSetObj alloc] init];
    while (sqlite3_step(stmt) == SQLITE_ROW)
    {
        strReasonId = [[NSString alloc] initWithCString:(char*)sqlite3_column_text(stmt,0) encoding:NSUTF8StringEncoding];
        //
        strReasonInfo = [[NSString alloc] initWithCString:(char*)sqlite3_column_text(stmt,1) encoding:NSUTF8StringEncoding];
        iRow++;
        [pEntersDataSet addDataSetRow_Ext:iRow andName:@"reasonId" andValue:strReasonId];
        [pEntersDataSet addDataSetRow_Ext:iRow andName:@"reasonInfo" andValue:strReasonInfo];
    }
    
    sqlite3_finalize(stmt);
    [manager closeSQLLiteDB];
    
    return pEntersDataSet;
  
}
//根据订单中快递公司的id号，获取对应的爱查快递的公司的id
+(NSString*)getEnterIckdId:(NSString*)strEnterName
{
    NSString* strSQL = [NSString stringWithFormat:@"select id,enterIckd from  t_express_enters where enterName='%@' ",strEnterName];
    sqlite3_stmt *stmt;
    
    SQLLiteDBManager *manager = [[SQLLiteDBManager alloc]init];
    if (![manager prepareSQL:strSQL andStmt:&stmt] || !stmt) {
        return false;
    }
    bool blHaveId = false;
    if(sqlite3_step(stmt) ==SQLITE_ROW)
        blHaveId = true;
    NSString* strEnterIckd =  [[NSString alloc] initWithCString:(char*)sqlite3_column_text(stmt,1) encoding:NSUTF8StringEncoding];
    if(strEnterIckd.length < 1)
        strEnterIckd = strEnterName;
    sqlite3_finalize(stmt);
    [manager closeSQLLiteDB];
    
    return  strEnterIckd;
  
}

//执行数据库脚本
-(BOOL)executeAppDbUpdateSQL
{
    
    //处理虚拟购物车的脚本升级
    NSString* strTableName = @"t_virtual_shopping_cart";
    NSString* strSQL = @"";
    if([self isExistTable:strTableName] == true)
    {
        return  true;
    }
    
    strSQL = @"CREATE TABLE t_virtual_shopping_cart (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, userName VARCHAR, goodsId VARCHAR, specid VARCHAR, color VARCHAR, size VARCHAR, price VARCHAR, buyCount INTEGER, lastTime DATETIME DEFAULT NULL, storage INTEGER, imgUrl VARCHAR, goodsName VARCHAR, storedId VARCHAR, storeName VARCHAR)";
    
    SQLLiteDBManager *manager = [[SQLLiteDBManager alloc]init];
    if([manager execSQL:strSQL] == false)
        return false;
    
    return true;
}


//判断某个表是否存在
-(bool)isExistTable:(NSString*)strTableName
{
   // bool blExist = false;
    NSString* strSQL = [NSString stringWithFormat:@"select * from sqlite_master where name='%@'",strTableName];
    sqlite3_stmt *stmt;
    
    SQLLiteDBManager *manager = [[SQLLiteDBManager alloc]init];
    if (![manager prepareSQL:strSQL andStmt:&stmt] || !stmt) {
        return false;
    }
    bool blExist = false;
    if(sqlite3_step(stmt) ==SQLITE_ROW)
    {
        blExist = true;
    }
    sqlite3_finalize(stmt);
    [manager closeSQLLiteDB];
    
    return  blExist;

}

+(NSMutableAttributedString*)getLabelAttributedString:(NSString*)strOraString andLight:(NSString*)strLight
{

    NSRange keyRange = [strOraString rangeOfString:strLight];
    if(keyRange.length > 0 )
    {
        NSMutableAttributedString *strLabelAtr = [[NSMutableAttributedString alloc] initWithString:strOraString];
        [strLabelAtr addAttribute:NSForegroundColorAttributeName value:COLOR_FONT_1 range:NSMakeRange(0,keyRange.location)];
        
        [strLabelAtr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.97 green:0.44 blue:0.42 alpha:1] range:NSMakeRange(keyRange.location,keyRange.length)];
        int iLength = strOraString.length;
        int iBegin = keyRange.location+keyRange.length;
        [strLabelAtr addAttribute:NSForegroundColorAttributeName value:COLOR_FONT_1 range:NSMakeRange(iBegin,iLength-iBegin)];
        return  strLabelAtr;
    }
    return nil;
}
+(NSMutableAttributedString*)getLabelAttributedString:(NSString*)strOraString andLight:(NSString*)strLight andColor:(UIColor*)pColor
{
    NSRange keyRange = [strOraString rangeOfString:strLight];
    if(keyRange.length > 0 )
    {
        NSMutableAttributedString *strLabelAtr = [[NSMutableAttributedString alloc] initWithString:strOraString];
        [strLabelAtr addAttribute:NSForegroundColorAttributeName value:COLOR_FONT_1 range:NSMakeRange(0,keyRange.location)];
        
        [strLabelAtr addAttribute:NSForegroundColorAttributeName value:pColor range:NSMakeRange(keyRange.location,keyRange.length)];
        int iLength = strOraString.length;
        int iBegin = keyRange.location+keyRange.length;
        [strLabelAtr addAttribute:NSForegroundColorAttributeName value:COLOR_FONT_1 range:NSMakeRange(iBegin,iLength-iBegin)];
        return  strLabelAtr;
    }
    return nil;
}

+(NSMutableAttributedString*)getLabelAttributedString_Other:(NSString*)strOraString andOther:(NSString*)strOther
{
    NSRange keyRange = [strOraString rangeOfString:strOther];
    if(keyRange.length > 0 )
    {
        NSMutableAttributedString *strLabelAtr = [[NSMutableAttributedString alloc] initWithString:strOraString];
        [strLabelAtr addAttribute:NSForegroundColorAttributeName value:COLOR_FONT_1 range:NSMakeRange(0,keyRange.location)];
        
        [strLabelAtr addAttribute:NSForegroundColorAttributeName value:COLOR_FONT_2 range:NSMakeRange(keyRange.location,keyRange.length)];
        int iLength = strOraString.length;
        int iBegin = keyRange.location+keyRange.length;
        [strLabelAtr addAttribute:NSForegroundColorAttributeName value:COLOR_FONT_1 range:NSMakeRange(iBegin,iLength-iBegin)];
        return  strLabelAtr;
    }
    return nil;
}

//计算两个值的比例（%）
+(float)calculatePcert:(NSString*)strHaveValue andTotal:(NSString*)strTotalValue
{
    float fHaveValue = [QDataSetObj convertToFloat:strHaveValue];
    float fTotalValue = [QDataSetObj convertToFloat:strTotalValue];
    if(fTotalValue < 1)
        return 0;
    float fPcertValue = fHaveValue / fTotalValue;
    fPcertValue = fPcertValue * 100;
    return fPcertValue;
}


//百分比显示
+(NSString*)convertPcertShow:(NSString*)strValue
{
    float fValue = [QDataSetObj convertToFloat:strValue]*100;
    NSString* strPcertValue = [NSString stringWithFormat:@"%.2f%%",fValue];
    return  strPcertValue;
}

//保留2位小数
+(NSString*)convertMoneyShow:(NSString*)strValue
{
    float fValue = [QDataSetObj convertToFloat:strValue];
    NSString* strMoney = [NSString stringWithFormat:@"%.2f",fValue];
    return strMoney;
}

//获取图片完整的url路径
+(NSString*)getImageFullUrlPath:(NSString*)strImageName andImgFlag:(NSInteger)iImgFlag
{
    NSString* strFullUrPath = @"";
    if(iImgFlag == 0)
    {
        strFullUrPath = [NSString stringWithFormat:@"%@/web/product/%@",[UaConfiguration sharedInstance].m_strSoapRequestUrl_1,strImageName];
    }
    else if(iImgFlag == 1)
    {
        strFullUrPath = [NSString stringWithFormat:@"%@/web/banklogo/%@",[UaConfiguration sharedInstance].m_strSoapRequestUrl_1,strImageName];
    }
    else if(iImgFlag == 2)
    {
          strFullUrPath = [NSString stringWithFormat:@"%@/web/ad/%@",[UaConfiguration sharedInstance].m_strSoapRequestUrl_1,strImageName];      
    }
    else if(iImgFlag == 3)
    {
          strFullUrPath = [NSString stringWithFormat:@"%@/web/active/%@",[UaConfiguration sharedInstance].m_strSoapRequestUrl_1,strImageName];
    }
    else if(iImgFlag == 4)
    {
          strFullUrPath = [NSString stringWithFormat:@"%@/web/intepro/%@",[UaConfiguration sharedInstance].m_strSoapRequestUrl_1,strImageName];
    }
    return strFullUrPath;
}

//返回可以直接显示的时间
+(NSString*)convertToShowTime:(NSInteger)iOraTime
{
    
    NSDate* nsShowTime = [NSDate dateWithTimeIntervalSince1970:iOraTime];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString* strTime = [dateFormatter stringFromDate:nsShowTime];
    return  strTime;
}

+(NSString*)convertToShowTime2:(NSString*)strOraTime
{
    NSRange range = [strOraTime rangeOfString:@" "];
    if(range.length < 1)
        return strOraTime;
    
    NSString* strShowTime = [strOraTime substringToIndex:range.location];
    return  strShowTime;
}

+(NSString*)convertToShowPhone:(NSString*)strOraPhone
{

    
    NSString* strShowPhone = strOraPhone;
    if(strOraPhone.length == 11)
    {
        strShowPhone = [strOraPhone substringToIndex:3];
        
        strShowPhone = [strShowPhone stringByAppendingFormat:@"****%@",[strOraPhone substringFromIndex:7]];
    }
    
    return strShowPhone;
}

+(NSString*)UTF8_To_GB2312:(NSString*)utf8string
{
    NSStringEncoding encoding =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData* gb2312data = [utf8string dataUsingEncoding:encoding];
    return [[NSString alloc] initWithData:gb2312data encoding:encoding];
}

@end
