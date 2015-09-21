/*------------------------------------------------------------------------
 Filename       : 	FeePayComMethod.h
 
 Description	:   连连科技、支付宝的支付管理类。需要说明的是，目前支付宝的qianmi
 
 Author         :   lzq,lvzhuqiang@ytinfo.zj.cn
 
 Date           :   2014-04-28
 
 version        :   v1.0
 
 Copyright      :   2014年 ytinfo. All rights reserved.
 
 ------------------------------------------------------------------------*/

#import <UIKit/UIKit.h>
//#import "LLWalletSdk.h"

//支付宝合作身份者id，以2088开头的16位纯数字
#define PartnerID @"2088002055166450"
//支付宝不收款账号
#define SellerID  @"sjqservice@hotmail.com"
//查询安全校验码(key)，应用程序暂时用不着
#define QueryKey  @"eab95i43fuhzlpwww16ngrny309xlh6j"


@interface AliPayProduct : NSObject{
@private
	float _price;
	NSString *_subject;
	NSString *_body;
	NSString *_orderId;
}

@property (nonatomic, assign) float price;
@property (nonatomic, retain) NSString *subject;
@property (nonatomic, retain) NSString *body;
@property (nonatomic, retain) NSString *orderId;

@end

//自定义的支付回调协议
@protocol FeePayComMethodViewDelegate <NSObject>

@optional
//支付宝回调接口
//-(void)onEndAlipayReturnResult:(AlixPayResult*)pResult;
//连连科技回调接口
//-(void)onEndLLWalletReturnResult:(LLWalletPayResult)resultCode withResultDic:(NSDictionary *)dic;
@end


//@interface FeePayComMethod : NSObject<LLWalletSDKDelegate>
@interface FeePayComMethod : NSObject
{
    //连连科技的sdk
  //  LLWalletSdk *m_pllWallsdk;
  //  SEL _alipayResult;
}

@property (nonatomic,strong)id <FeePayComMethodViewDelegate> m_pPayresultDelegate;


//获取单例的静态函数
+(FeePayComMethod*)sharedInstance;

//收到alipay回调的url
-(bool)handleAlipayUrl:(NSURL*)url;

//获取支付宝签名后的订单信息
-(NSString*)getSignedFeePayByAlipay:(NSString*)strOrderSn andTitle:(NSString*)strOrderTitle andDesp:(NSString*)strOrderDesp andPrice:(float)fPrice andOrderId:(NSString*)strOrderId andOrderType:(NSInteger)iOrderType;

//支付宝返回后验签
-(bool)verifySignedUrlByAlixpay:(NSString*)strResultInfo andSigned:(NSString*)strSignedString;

//理财连连科技
-(NSMutableDictionary*)getFeePayByLLWall_Licai:(NSString*)strOrderSn andTitle:(NSString*)strOrderTitle andDesp:(NSString*)strOrderDesp andPrice:(NSString*)strOrderFee andTime:(NSString*)strOrderTime andBuyerId:(NSString *)strBuyerId andNotUrl:(NSString*)strNodifyUrl andOid:(NSString*)strOidPartner andBusiId:(NSString*)strBusiPartner andSign:(NSString*)strMdSign andValidOd:(NSString*)strValidOrder;

//理财连连科技_测试支付
-(NSMutableDictionary*)getFeePayByLLWall_Test;

@end
