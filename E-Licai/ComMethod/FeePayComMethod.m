/*------------------------------------------------------------------------
 Filename       : 	FeePayComMethod.h
 
 Description	:   连连科技、支付宝的支付管理类
 
 Author         :   lzq,lvzhuqiang@ytinfo.zj.cn
 
 Date           :   2014-04-28
 
 version        :   v1.0
 
 Copyright      :   2014年 ytinfo. All rights reserved.
 
 ------------------------------------------------------------------------*/

#import "FeePayComMethod.h"
#import "UaConfiguration.h"
#import "CKHttpHelper.h"
#import "SQLLiteDBManager.h"


@implementation FeePayComMethod

static FeePayComMethod* _pGFeePayComMethod = nil;
@synthesize m_pPayresultDelegate = _pPayresultDelegate;

- (id)init
{
    self = [super init];
    if (self) {
        //m_pllWallsdk = nil;
    }

    return self;
}

//获取单例的静态函数
+(FeePayComMethod*)sharedInstance
{
    @synchronized(self) {
        if (_pGFeePayComMethod == nil)
        {
            _pGFeePayComMethod = [[self alloc] init];
            /*
            if (!_pGFeePayComMethod) {
                _pGFeePayComMethod = [[self alloc] init];
            }*/
        }
    }
    return _pGFeePayComMethod;
}



//wap回调函数
/*
-(void)paymentResult:(NSString *)strResultd
{

     AlixPayResult* pAlixResult = [[AlixPayResult alloc] initWithString:strResultd];
    
    if(_pPayresultDelegate)
    {
        if([_pPayresultDelegate respondsToSelector:@selector(onEndAlipayReturnResult:)])
        {
            [_pPayresultDelegate onEndAlipayReturnResult:pAlixResult];
            return;
        }
    }

}

*/

//支付费用
/*
iPayType:1_支付宝;2_连连科技
strOrderSn:订单号，唯一的关键字
strOrderTitle:订单的标题
strOrderDesp:订单的描述
fPrice：价格
 
 */


-(NSString*)getSignedFeePayByAlipay:(NSString*)strOrderSn andTitle:(NSString*)strOrderTitle andDesp:(NSString*)strOrderDesp andPrice:(float)fPrice andOrderId:(NSString*)strOrderId andOrderType:(NSInteger)iOrderType
{
    /*
    AlixPayOrder *payOrder = [[AlixPayOrder alloc] init];
    payOrder.partner = PartnerID;
    payOrder.seller  = SellerID;
    //订单ID（由商家自行制定）
    payOrder.tradeNO =  strOrderSn;//[self generateTradeNO];
    //商品标题
    payOrder.productName = strOrderTitle;
    //商品描述
    payOrder.productDescription = strOrderDesp;
    //商品价格
    payOrder.amount = [NSString stringWithFormat:@"%.2f",fPrice]; //商品价格
    //回调URL
    payOrder.notifyURL = [[UaConfiguration sharedInstance] getOrderPayNotifyUrl:strOrderId andOrderType:iOrderType];
    

    //获取订单的信息
    NSString* strOrderInfo = [payOrder description];
    //对订单进行Rsa签名
    NSString* strSignedInfo = [self doRsa:strOrderInfo];
    
    NSString *strOrderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                             strOrderInfo, strSignedInfo, @"RSA"];
	return strOrderString;
     */
     //
    return @"";
}

//进行rsa签名
-(NSString*)doRsa:(NSString*)orderInfo
{
    /*
    id<DataSigner> signer;
    
    NSString* strPriveKey =[[NSBundle mainBundle] objectForInfoDictionaryKey:@"AlipayPrivateKey"];
    signer = CreateRSADataSigner(strPriveKey);
    NSString *strSignedString = [signer signString:orderInfo];
    return strSignedString;
     */
    return @"";
}


//获取银联支付的订单信息（md5签名）
-(NSMutableDictionary*)getFeePayByLLWall_Licai:(NSString*)strOrderSn andTitle:(NSString*)strOrderTitle andDesp:(NSString*)strOrderDesp andPrice:(NSString*)strOrderFee andTime:(NSString*)strOrderTime andBuyerId:(NSString *)strBuyerId andNotUrl:(NSString*)strNodifyUrl andOid:(NSString*)strOidPartner andBusiId:(NSString*)strBusiPartner andSign:(NSString*)strMdSign andValidOd:(NSString*)strValidOrder
{
    NSString* strUserId = [NSString stringWithFormat:@"%d",[UaConfiguration sharedInstance].m_setLoginState.m_iUserMemberID];
    //NSString* strOrderFee = [NSString stringWithFormat:@"%.2f",fPrice];
    NSMutableDictionary *dictParams = [NSMutableDictionary dictionary];
    [dictParams setDictionary:@{
                                @"busi_partner":strBusiPartner,
                                @"info_order":strOrderDesp,
                                @"sign":strMdSign,
                                @"name_goods":strOrderTitle,
                                @"notify_url":strNodifyUrl,
                                @"oid_partner":strOidPartner,
                                @"acct_name":strBuyerId,
                                @"user_id":strUserId,
                                @"dt_order":strOrderTime,
                                @"sign_type":@"MD5",
                                @"money_order":strOrderFee,
                                @"no_order":strOrderSn,
                                @"valid_order":@"10080",
                                }];
    
    return dictParams;
    
/*
    //商户订单时间	dt_order
    if(strOrderTime.length <1)
    {
        NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
        [dateFormater setDateFormat:@"yyyyMMddHHmmss"];
        strOrderTime = [dateFormater stringFromDate:[NSDate date]];
    }
    
    //签名方法（MD5/RSA），目前连连科技采用简单的md5加密
    NSString *strSignType = @"MD5";
    NSMutableDictionary *dictParams = [NSMutableDictionary dictionary];

    
    if(strOrderDesp.length < 1)
        strOrderDesp = strOrderTitle;
    NSString* strOrderFee = [NSString stringWithFormat:@"%.2f",fPrice];
    NSString* strUserId = [NSString stringWithFormat:@"%d",[UaConfiguration sharedInstance].m_setLoginState.m_iUserMemberID];

    [dictParams setDictionary:@{
                                @"sign_type":strSignType,
                                @"busi_partner":strBusiPartner,
                                @"dt_order":strOrderTime,
                                @"money_order":strOrderFee,
                                @"notify_url":strNodifyUrl,
                                @"no_order":strOrderSn,
                                @"name_goods":strOrderTitle,
                                @"info_order":strOrderDesp,
                                @"valid_order":strValidOrder,//@"10080"
                                @"user_id":strUserId,
                                @"acct_name":strBuyerId,
                                }];
    
    
    dictParams[@"oid_partner"] = @"201408071000001543";
    //dictParams[@"oid_partner"] = strOidPartner;
    NSDictionary* signedDict = [self partnerSignDicWithParam:dictParams];
    return signedDict;
 */
   // dictParams[@"sign"] = strMdSign;
   // return dictParams;
}


//测试支付
-(NSMutableDictionary*)getFeePayByLLWall_Test
{/*

    NSMutableDictionary *dictParams = [NSMutableDictionary dictionary];
    
    [dictParams setDictionary:@{
                                @"busi_partner":@"101001",
                                @"info_order":@"购买盈信宝625号",
                                @"name_goods":@"盈信宝625号",
                                @"notify_url":@"http://115.29.248.32:8080/productInfo/checkPayBack.do",
                                @"oid_partner" : @"201502041000205503",
                                @"acct_name":@"",
                                @"user_id":@"3",
                                @"dt_order":@"20150205161523",
                               @"sign_type":@"MD5",
                                @"money_order":@"135.00",
                                @"no_order":@"20150205161523",
                               @"valid_order" : @"10080",
                                }];
    //NSString *signString = [self partnerSignOrder:dictParams];
    dictParams[@"sign"] = @"30757350fa80b41bfb6331adfc420eca";
    return dictParams;

  */
    

    NSMutableDictionary* oraTestDict = [self createTestOrder];
    oraTestDict[@"oid_partner"] = @"201502041000205503";
    NSMutableDictionary* signedOrder = [NSMutableDictionary dictionaryWithDictionary:oraTestDict];
    NSString *signString = [self partnerSignOrder:oraTestDict];
    
    
    // 请求签名	sign	是	String	MD5（除了sign的所有请求参数+MD5key）
    signedOrder[@"sign"] = signString;
    
   
    return signedOrder;

}

- (NSMutableDictionary*)createTestOrder
{
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"yyyyMMddHHmmss"];
    NSString *simOrder = @"20150205151214";//[dateFormater stringFromDate:[NSDate date]];
    
    NSString *partnerPrefix = @"2015020300001"; // 设定自己商户的订单前缀，防止订单重复
    
    NSString *signType = @"MD5";    // MD5 || RSA
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [param setDictionary:@{
                           @"sign_type":signType,
                           //签名方式	partner_sign_type	是	String	RSA  或者 MD5
                           @"busi_partner":@"101001",
                           //商户业务类型	busi_partner	是	String(6)	虚拟商品销售：101001
                           @"dt_order":simOrder,
                           //商户订单时间	dt_order	是	String(14)	格式：YYYYMMDDH24MISS  14位数字，精确到秒
                           //                           @"money_order":@"0.10",
                           //交易金额	money_order	是	Number(8,2)	该笔订单的资金总额，单位为RMB-元。大于0的数字，精确到小数点后两位。 如：49.65
                           @"notify_url":@"www.dingding58.com",
                           //服务器异步通知地址	notify_url	是	String(64)	连连钱包支付平台在用户支付成功后通知商户服务端的地址，如：http://payhttp.xiaofubao.com/back.shtml
                           @"no_order":[NSString stringWithFormat:@"%@%@",partnerPrefix,  simOrder],
                           //商户唯一订单号	no_order	是	String(32)	商户系统唯一订单号
                           @"name_goods":@"测试商品",
                           //商品名称	name_goods	否	String(40)
                           @"info_order":simOrder,
                           //订单附加信息	info_order	否	String(255)	商户订单的备注信息
                           @"valid_order":@"10080",
                           //分钟为单位，默认为10080分钟（7天），从创建时间开始，过了此订单有效时间此笔订单就会被设置为失败状态不能再重新进行支付。
                           
                           //                           @"risk_item":@"{\"user_info_bind_phone\":\"13958069593\",\"user_info_dt_register\":\"20131030122130\"}",
                           //风险控制参数 否 此字段填写风控参数，采用json串的模式传入，字段名和字段内容彼此对应好
                           @"user_id":@"13858005686",
                           //商户用户唯一编号 否 该用户在商户系统中的唯一编号，要求是该编号在商户系统中唯一标识该用户
                           // user_id，一个user_id标示一个用户
                           // user_id为必传项，需要关联商户里的用户编号，一个user_id下的所有支付银行卡，身份证必须相同
                           // demo中需要开发测试自己填入user_id, 可以先用自己的手机号作为标示，正式上线请使用商户内的用户编号
                           
                           //                           @"id_no":@"339005198403100026",
                           //证件号码 id_no 否 String
                           @"acct_name":@"测试号",
                           //银行账号姓名 acct_name 否 String
                           //                           @"flag_modify":@"1",
                           //修改标记 flag_modify 否 String 0-可以修改，默认为0, 1-不允许修改 与id_type,id_no,acct_name配合使用，如果该用户在商户系统已经实名认证过了，则在绑定银行卡的输入信息不能修改，否则可以修改
                           //                           @"card_no":@"6227001540670034271",
                           //银行卡号 card_no 否 银行卡号前置，卡号可以在商户的页面输入
                           //                           @"no_agree":@"2014070900123076",
                           //签约协议号 否 String(16) 已经记录快捷银行卡的用户，商户在调用的时候可以与pay_type一块配合使用
                           }];
    
    
    param[@"money_order"] = @"0.01";
    
    return param;
}

- (NSString*)partnerSignOrder:(NSDictionary*)paramDic
{
    // 所有参与订单签名的字段，这些字段以外不参与签名
    NSArray *keyArray = @[@"busi_partner",@"dt_order",@"info_order",
                          @"money_order",@"name_goods",@"no_order",
                          @"notify_url",@"oid_partner", @"sign_type",
                          @"valid_order"];
    
    /*
     NSArray *keyArray = @[@"busi_partner",@"dt_order",@"info_order",
     @"money_order",@"name_goods",@"no_order",
     @"notify_url",@"oid_partner",@"risk_item", @"sign_type",
     @"valid_order"];*/
    // 对字段进行字母序排序
    NSMutableArray *sortedKeyArray = [NSMutableArray arrayWithArray:keyArray];
    
    [sortedKeyArray sortUsingComparator:^NSComparisonResult(NSString* key1, NSString* key2) {
        return [key1 compare:key2];
    }];
    
    NSMutableString *paramString = [NSMutableString stringWithString:@""];
    
    // 拼接成 A=B&X=Y
    for (NSString *key in sortedKeyArray)
    {
        if ([paramDic[key] length] != 0)
        {
            [paramString appendFormat:@"&%@=%@", key, paramDic[key]];
        }
    }
    
    if ([paramString length] > 1)
    {
        [paramString deleteCharactersInRange:NSMakeRange(0, 1)];    // remove first '&'
    }
    
    BOOL bMd5Sign = [paramDic[@"sign_type"] isEqualToString:@"MD5"];
    
    if (bMd5Sign)
    {
        // MD5签名，在最后加上key， 变成 A=B&X=Y&key=1234
        [paramString appendFormat:@"&key=%@", [self partnerKey:paramDic[@"oid_partner"]]];
    }
    
    NSString *signString = [self signString:paramString];
    
    
    return signString;
}

- (NSString*)partnerKey:(NSString*)oid_partner{
    
  
    NSString *pay_md5_key = @"yintong1234567890";
    
    bool blTest = NO;
    if (blTest) {
        pay_md5_key = @"201103171000000000";
        //pay_md5_key = @"md5key_201311062000003548_20131107";
    }
    else{
        /*
         正式环境 认证支付测试商户号  201408071000001543
         MD5 key  201408071000001543test_20140812
         
         正式环境 快捷支付测试商户号  201408071000001546
         MD5 key  201408071000001546_test_20140815
         */
    
    
        if ([oid_partner isEqualToString:@"201408071000001543"]) {
            pay_md5_key = @"201408071000001543test_20140812";
        }
        else if ([oid_partner isEqualToString:@"201408071000001546"]) {
            pay_md5_key = @"201408071000001546_test_20140815";
        }
        else if ([oid_partner isEqualToString:@"201502041000205503"])
        {
            pay_md5_key = @"201502041000205503_20150205";
        }
    }


    return pay_md5_key;
}

- (NSString *)signString:(NSString*)origString
{
    const char *original_str = [origString UTF8String];
    unsigned char result[32];
    CC_MD5(original_str, strlen(original_str), result);//调用md5
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++){
        [hash appendFormat:@"%02x", result[i]];
    }
    
    return hash;
}


@end
