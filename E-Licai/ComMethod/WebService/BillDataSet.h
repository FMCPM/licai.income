/*------------------------------------------------------------------------
 Filename       : 	BillDataSet.h
 
 Description	:   自定义的一个类：封装了订单相关的一些属性、方法。
 
 Author         :   lzq,lvzhuqiang@ytinfo.zj.cn
 
 Date           :   2014-03-020
 
 version        :   v1.0
 
 Copyright      :   2014年 ytinfo. All rights reserved.
 
 ------------------------------------------------------------------------*/

#import "QDataSetObj.h"

@interface BillDataSet : NSObject
{
    //存储返回结果的集合（数组）
    QDataSetObj*  m_pBillDataSet;

}

@property(nonatomic,strong)NSString* m_strGoodsBillID;
@property(nonatomic,strong)NSString* m_strGoodsBillTitle;

//添加一个商品到订单
-(void)addGoods:(NSInteger)iGoodsID andColor:(NSInteger)iColorID andSize:(NSInteger)iSizeID andCount:(NSInteger)iCount;
//获取订单中的商品ID列表
-(NSString*)getGoodsIDList;
//获取所有的省的列表
-(QDataSetObj*)getProvinceInfoList;
//获取某个省所属的城市列表
-(QDataSetObj*)getCityInfoLsit:(NSInteger)iProvinceId;

//根据城市的id，获取省的信息
-(SetRowObj*)getProvinceObj:(NSInteger)iCityId;
//根据id，获取省份或城市的名称
-(NSString*)getProvinceOrCityNameById:(NSString*)strId;
//根据城市的编号，获取所在地信息
-(NSString*)getAreaInfoShowByCityId:(NSString*)strCityId;
@end
