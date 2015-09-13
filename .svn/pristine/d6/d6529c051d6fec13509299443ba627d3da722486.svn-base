/*------------------------------------------------------------------------
 Filename       : 	HistoryLogMethod.h
 
 Description	:   自定义的一个类：封装了App出售化时，从服务器获取相关的初始化数据
 
 Author         :   lzq,lvzhuqiang@ytinfo.zj.cn
 
 Date           :   2014-04-16
 
 version        :   v1.0
 
 Copyright      :   2014年 ytinfo. All rights reserved.
 
 ------------------------------------------------------------------------*/

#import <UIKit/UIKit.h>
#import "QDataSetObj.h"

@interface HistoryLogMethod : NSObject
{

}

//添加一条商品的历史浏览记录
-(bool)AddOneGoodsHistoryLog:(NSString*)strUserName andGoodsId:(NSInteger)iGoodsId andName:(NSString*)strGoodsName andImgUrl:(NSString*)strImgUrl andPriceName:(NSString*)strPriceName andPriceValue:(NSString*)strPriceValue andStock:(NSInteger)iStockNum andService:(NSString*)strServiceFlag;

//添加一条店铺的历史浏览记录
-(bool)AddOneStoreHistoryLog:(NSString*)strUserName andStoreId:(NSInteger)iStoreId andName:(NSString*)strStoreName andImgUrl:(NSString*)strImgUrl andAddr:(NSString*)strAddress andZy:(NSString*)strBusiZy andService:(NSString*)strServiceFlag;

//获取商品浏览记录
-(QDataSetObj*)getGoodsHistoryLog:(NSString*)strUserName andPageId:(NSInteger)iCurPageId;
//获取店铺浏览记录
-(QDataSetObj*)getStoreHistoryLog:(NSString*)strUserName andPageId:(NSInteger)iCurPageId;
//清除商品浏览记录
-(bool)clearGoodsHistoryViewLog:(NSString*)strUserName;
//清除店铺浏览记录
-(bool)clearStoreHistoryViewLog:(NSString*)strUserName;

//写一条搜索记录
-(bool)AddSearchHistoryLog:(NSString*)strUserName andType:(NSInteger)iType andKey:(NSString*)strKeyValue;

//获取搜索的日志记录
-(QDataSetObj*)getSearchHistoryLog:(NSString*)strUserName andType:(NSInteger)iType andKey:(NSString*)strSearchKey;
//删除用户所有的搜索记录
-(bool)clearSearchHistoryLog:(NSString*)strUserName andKeyType:(NSInteger)iKeyType;

//清理超过数量的日志记录
-(void)clearMaxCountHistoryLog:(NSString*)strUserName;

@end
