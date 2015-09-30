/*------------------------------------------------------------------------
 Filename       : 	AppInitDataMethod.h
 
 Description	:   自定义的一个类：封装了App初始化时，从服务器获取相关的初始化数据
 
 Author         :   lzq,lvzhuqiang@ytinfo.zj.cn
 
 Date           :   2014-04-16
 
 version        :   v1.0
 
 Copyright      :   2014年 ytinfo. All rights reserved.
 
 ------------------------------------------------------------------------*/

#import <UIKit/UIKit.h>
#import "QDataSetObj.h"

@interface AppInitDataMethod : NSObject
{

}
//获取快递公司列表
-(void)initExpreeEnters;
//获取所有的快递公司列表
//enterId:快递公司编号，如sf；enterName:快递公司名称
+(QDataSetObj*)getExptressEnters;
//获取订单取消或退款的原因列表
//reasonInfo:退款的原因;reasonId:目前没有用
//iReasonType:1_订单原因;2_退款原因
+(QDataSetObj*)getReasonsList:(NSInteger)iReasonType;
//根据订单中快递公司的id号，获取对应的爱查快递的公司的id
+(NSString*)getEnterIckdId:(NSString*)strEnterName;

//执行数据库升级脚本
-(BOOL)executeAppDbUpdateSQL;

+(NSMutableAttributedString*)getLabelAttributedString:(NSString*)strOraString andLight:(NSString*)strLight;

+(NSMutableAttributedString*)getLabelAttributedString_Other:(NSString*)strOraString andOther:(NSString*)strOther;
+(NSMutableAttributedString*)getLabelAttributedString:(NSString*)strOraString andLight:(NSString*)strLight andColor:(UIColor*)pColor;
//计算两个值的比例（%）
+(float)calculatePcert:(NSString*)strHaveValue andTotal:(NSString*)strTotalValue;
//百分比显示
+(NSString*)convertPcertShow:(NSString*)strValue;
//
+(NSString*)convertMoneyShow:(NSString*)strValue;
//获取图片完整的url路径
+(NSString*)getImageFullUrlPath:(NSString*)strImageName andImgFlag:(NSInteger)iImgFlag;
//返回可以直接显示的时间
+(NSString*)convertToShowTime:(NSInteger)iOraTime;

//返回可以直接显示的时间
+(NSString*)convertToShowTime2:(NSString*)strOraTime;
//隐藏手机号码中间4位
+(NSString*)convertToShowPhone:(NSString*)strOraPhone;
//utf8转gb2312
+(NSString*)UTF8_To_GB2312:(NSString*)utf8string;
@end
