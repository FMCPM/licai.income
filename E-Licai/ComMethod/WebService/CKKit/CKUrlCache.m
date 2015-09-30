//
//  CKHttpCache.m
//  FJ-E-YellowPage
//
//  Created by jiangjunchen on 13-5-16.
//  Copyright (c) 2013年 ytinfo. All rights reserved.
//

#import "CKUrlCache.h"
#import "CKConfig.h"
#import "CKEncrypt.h"

@implementation CKUrlCache
@synthesize cacheTime = _cacheTime;
@synthesize diskPath = _diskPath;
@synthesize responseDictionary = _responseDictionary;

static CKUrlCache *g_sharedCache = nil;

+(void)setSharedURLCache:(CKUrlCache *)cache
{
    if (g_sharedCache != cache) {
        g_sharedCache = cache;
    }
    [super setSharedURLCache:cache];
}

+(CKUrlCache *)sharedURLCache
{
    return g_sharedCache;
}

//初始化缓存区的大小
-(id)initWithMemoryCapacity:(NSUInteger)memoryCapacity diskCapacity:(NSUInteger)diskCapacity diskPath:(NSString *)path cacheTime:(NSInteger)cacheTime
{
    if (self = [super initWithMemoryCapacity:memoryCapacity diskCapacity:diskCapacity diskPath:path]) {
        self.cacheTime = cacheTime;
        if (path)
            self.diskPath = path;
        else
            self.diskPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        
        self.responseDictionary = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return self;
}

- (void)removeAllCachedResponses {
    [super removeAllCachedResponses];
    
    [self deleteCacheFolder];
}

- (void)removeCachedResponseForRequest:(NSURLRequest *)request {
    [super removeCachedResponseForRequest:request];
    NSString *url = request.URL.absoluteString;
    NSString *fileName = [self cacheRequestFileName:url];
    NSString *otherInfoFileName = [self cacheRequestOtherInfoFileName:url];
    NSString *filePath = [self cacheFilePath:fileName];
    NSString *otherInfoPath = [self cacheFilePath:otherInfoFileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:filePath error:nil];
    [fileManager removeItemAtPath:otherInfoPath error:nil];
}

- (void)dealloc {
    Release(_diskPath);
    Release(_responseDictionary);
    Dealloc();
}

- (NSCachedURLResponse *)cachedResponseForRequest:(NSURLRequest *)request
{
    if ([request.HTTPMethod compare:@"GET"] != NSOrderedSame)
    {
        return [super cachedResponseForRequest:request];
    }
    return [self cachedResponseForCKRequest:request];
}

//默认从缓存区取文件
- (NSCachedURLResponse *)cachedResponseForCKRequest:(NSURLRequest *)request
{
    NSString *url = request.URL.absoluteString;
    NSString *fileName = [self cacheRequestFileName:url];
    NSString *otherInfoFileName = [self cacheRequestOtherInfoFileName:url];
    NSString *filePath = [self cacheFilePath:fileName];
    NSString *otherInfoPath = [self cacheFilePath:otherInfoFileName];
    NSDate *date = [NSDate date];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath])
    {
        BOOL expire = false;
        NSDictionary *otherInfo = [NSDictionary dictionaryWithContentsOfFile:otherInfoPath];
        
        if (self.cacheTime > 0) {
            NSInteger createTime = [[otherInfo objectForKey:@"time"] intValue];
            if (createTime + self.cacheTime < [date timeIntervalSince1970]) {
                expire = true;
            }
        }
        
        if (expire == false) {
            NSLog(@"data from cache ...");
            
            NSData *data = [NSData dataWithContentsOfFile:filePath];
            NSURLResponse *response = [[NSURLResponse alloc] initWithURL:request.URL
                                                                MIMEType:[otherInfo objectForKey:@"MIMEType"]
                                                   expectedContentLength:data.length
                                                        textEncodingName:[otherInfo objectForKey:@"textEncodingName"]];
            NSCachedURLResponse *cachedResponse = AutoRelease([[NSCachedURLResponse alloc] initWithResponse:response data:data]);
            Release(response);
            return cachedResponse;
        } else {
            NSLog(@"cache expire ... ");
            
            [fileManager removeItemAtPath:filePath error:nil];
            [fileManager removeItemAtPath:otherInfoPath error:nil];
        }
    }
 
    return nil;

}

- (NSString *)cacheRequestFileName:(NSString *)requestUrl
{
    return [CKEncrypt md5Hash:requestUrl];
}

- (NSString *)cacheRequestOtherInfoFileName:(NSString *)requestUrl {
    return [CKEncrypt md5Hash:[NSString stringWithFormat:@"%@-otherInfo",requestUrl]];
}

- (NSString *)cacheFilePath:(NSString *)file {
    NSString *path = [NSString stringWithFormat:@"%@/%@", self.diskPath, [self cacheFolder]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir;
    if ([fileManager fileExistsAtPath:path isDirectory:&isDir] && isDir) {
 
    }
    else {
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return [NSString stringWithFormat:@"%@/%@", path, file];
}

- (NSString *)cacheFolder {
    return @"URLCACHE";
}

- (void)deleteCacheFolder {
    NSString *path = [NSString stringWithFormat:@"%@/%@", self.diskPath, [self cacheFolder]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:path error:nil];
}

-(void)storeData:(NSData *)data forRequest:(NSURLRequest *)request forResponse:(NSURLResponse*)response
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *url = request.URL.absoluteString;
        NSString *fileName = [self cacheRequestFileName:url];
        NSString *otherInfoFileName = [self cacheRequestOtherInfoFileName:url];
        NSString *filePath = [self cacheFilePath:fileName];
        NSString *otherInfoPath = [self cacheFilePath:otherInfoFileName];
        NSDate *date = [NSDate date];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:filePath]) {
            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%f", [date timeIntervalSince1970]], @"time",
                                  response.MIMEType, @"MIMEType",
                                  response.textEncodingName, @"textEncodingName", nil];
            [dict writeToFile:otherInfoPath atomically:YES];
            [data writeToFile:filePath atomically:YES];
        }
    });
}


@end

