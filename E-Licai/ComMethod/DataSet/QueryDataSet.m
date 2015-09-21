//
//  QueryDataSet.m
//  YTSearch
//
//  Created by jiang junchen on 12-11-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "QueryDataSet.h"

@implementation QueryDataSet
@synthesize m_strKeyWord            = _strKeyWord;
@synthesize m_iSortType             = _iSortType;
@synthesize m_strBClassCode         = _strBClassCode;        
@synthesize m_strDClassCode         = _strDClassCode;
@synthesize m_iViewQueryType        = _iViewQueryType;
@synthesize m_lfMinLatitude;
@synthesize m_lfMaxLatitude;
@synthesize m_lfMinLongitude;
@synthesize m_lfMaxLongitude;
-(id)init
{
    self = [super init];
    if (self) {
        _strKeyWord = @"";
        _iSortType = 0;
        _strBClassCode = @"";
        _strDClassCode = @"";
        _iViewQueryType = 0;
        self.m_lfMaxLatitude = 0.0f;
        self.m_lfMinLatitude = 0.0f;
        self.m_lfMaxLongitude = 0.0f;
        self.m_lfMinLongitude = 0.0f;
        
    }
    return self;
}
@end