//
//  QueryDataSet.h
//  YTSearch
//
//  Created by jiang junchen on 12-11-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QueryDataSet : NSObject
@property (strong, nonatomic) NSString          *m_strBClassCode;
@property (strong, nonatomic) NSString          *m_strDClassCode;
@property (strong, nonatomic) NSString          *m_strKeyWord;
@property (assign, nonatomic) NSInteger         m_iSortType;
@property (assign, nonatomic) NSInteger         m_iViewQueryType;    //视图查询和显示的方式,默认0_普通商家;1_专业市场的商家;2_特殊商街的商家
@property (assign, nonatomic) double            m_lfMinLatitude;
@property (assign, nonatomic) double            m_lfMaxLatitude;
@property (assign, nonatomic) double            m_lfMinLongitude;
@property (assign, nonatomic) double            m_lfMaxLongitude;
@end
