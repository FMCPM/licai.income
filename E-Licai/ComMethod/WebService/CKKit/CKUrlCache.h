//
//  CKHttpCache.h
//  FJ-E-YellowPage
//
//  Created by jiangjunchen on 13-5-16.
//  Copyright (c) 2013年 ytinfo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CKUrlCache : NSURLCache

@property(nonatomic, assign) NSInteger cacheTime;
@property(nonatomic, copy) NSString *diskPath;
@property(nonatomic, retain) NSMutableDictionary *responseDictionary;

+(CKUrlCache *)sharedURLCache;
+(void)setSharedURLCache:(CKUrlCache *)cache;
-(id)initWithMemoryCapacity:(NSUInteger)memoryCapacity diskCapacity:(NSUInteger)diskCapacity diskPath:(NSString *)path cacheTime:(NSInteger)cacheTime;
-(void)storeData:(NSData *)data forRequest:(NSURLRequest *)request forResponse:(NSURLResponse*)response;
@end
