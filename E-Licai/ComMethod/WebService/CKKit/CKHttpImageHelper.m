//
//  CKHttpImageHelper.m
//  FJ-E-YellowPage
//
//  Created by jiangjunchen on 13-5-15.
//  Copyright (c) 2013年 ytinfo. All rights reserved.
//

#import "CKHttpImageHelper.h"
#import "ImgFileMethod.h"
#import "GlobalDefine.h"

@implementation CKHttpImageHelper

@synthesize receiveBlock = _receiveBlock;

//是否需要下载图片
static NSInteger g_isNeedDownImage = 1;

static NSURLRequestCachePolicy g_imageCachePolicy = NSURLRequestReturnCacheDataElseLoad;

+(void)setImageCachePolicy:(NSURLRequestCachePolicy)imgCachePolicy
{
    g_imageCachePolicy = imgCachePolicy;
}
+(void)setIsNeedDownImageFlag:(NSInteger)iFlag
{
    g_isNeedDownImage = iFlag;
}

-(id)init
{
    self = [super init];
    if (self) {
        self.cachePolicy = g_imageCachePolicy;
    }
    return self;
}

-(void)addImageUrl:(NSURL*)imgUrl forKey:(NSString*)key
{
    
    if (!imgUrl)
        return;
    
    if (!key)
        key = @"null";
    
    if(!_imageUrls)
        _imageUrls = [[NSMutableArray alloc]init];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObject:imgUrl forKey:key];
    [_imageUrls addObject:dic];
}
//completeBlock属性的方法，自动会调用
-(void)setCompleteBlock:(void(^)(id data))completeBlock
{
    __block CKHttpImageHelper *blockSelf = self;
    [super setCompleteBlock:^(id data)
     {
         UIImage *image = nil;
         if (data)
         {
             image = [UIImage imageWithData:data];
             if(image == nil)
                 image = [UIImage imageNamed:ERROR_IMAGE_NAME];
         }
         else
         {
             image = [UIImage imageNamed:ERROR_IMAGE_NAME];
         }
         if(blockSelf->_needCancel ==YES)
         {
             if(blockSelf->_imageUrls)
             {
                 [blockSelf->_imageUrls removeAllObjects];
             }
             blockSelf->_isDownLoading = NO;
             return ;
         }
         
         NSString<NSCopying> *curkey = nil;
         
         if (blockSelf->_imageUrls && [blockSelf->_imageUrls count]>0) {
             NSDictionary *dic = [blockSelf->_imageUrls objectAtIndex:0];
             NSArray *allKeys = [dic allKeys];
             if (allKeys && allKeys.count>0) {
                 curkey = [[dic allKeys]objectAtIndex:0];
             }
             [blockSelf->_imageUrls removeObjectAtIndex:0];
         }
         
         BOOL finished = YES;
         if (blockSelf->_imageUrls && [blockSelf->_imageUrls count]>0 && !blockSelf->_needCancel)
             finished = NO;
         
         if (blockSelf.receiveBlock) {
             blockSelf.receiveBlock(image,curkey,finished);
         }
         if(finished == YES)
             blockSelf->_isDownLoading = NO;
         
         if (!finished) {
             if (blockSelf.startBlock)
                 blockSelf.startBlock = nil;
             
             [blockSelf start];
         }
     }];
}

-(void)startWithReceiveBlock:(CKHttpImageReceiveBlock)receiveBlock;
{
    if (self.receiveBlock != receiveBlock) {
        self.receiveBlock = receiveBlock;
    }
    if(_isDownLoading == YES)
        return;
    [self start];
}

-(void)start
{
    if (self.isConnecting) {
        return;
    }

    self.methodType = CKHttpMethodTypeGet;
    _needCancel = NO;

    if (!self.completeBlock) {
        [self setCompleteBlock:nil];
    }
    
    if (self.parserBlock) {
        [self setParserBlock:nil];
    }
    if(_imageUrls == nil)
        return;
    if(_imageUrls.count < 1)
        return;
    _isDownLoading = YES;
    NSURL *imgurl = nil;
    NSString *key = @"0";
    if (_imageUrls && [_imageUrls count]>0)
    {
        NSDictionary *dic = [_imageUrls objectAtIndex:0];
        NSArray *allKeys = [dic allKeys];
        
        if (allKeys && allKeys.count > 0)
            key = [[dic allKeys]objectAtIndex:0];
        imgurl = [dic objectForKey:key];
    }
    if(imgurl == nil)
        return;
    int iPathCount = 0;
    if(imgurl)
        iPathCount = [imgurl pathComponents].count;
    
    if(iPathCount==0)
    {
        UIImage *image = [UIImage imageNamed:NO_IMAGE_NAME];
        if (self.receiveBlock)
        {
            self.receiveBlock(image,key,true);
        }
        if(_imageUrls.count > 0)
            [_imageUrls removeObjectAtIndex:0];
        [self start];
        return;
    }
    //
    if(g_isNeedDownImage == 0 )
        [self startWithNoNet ];
    else
    {
        [self setBaseUrl_1:imgurl];
        [super start];
    }
}

-(void)cancel
{
    _needCancel = YES;
    [super cancel];
}

-(void)startWithNoNet
{
    
    NSString<NSCopying> *curkey = nil;
    
    while (_imageUrls.count > 0)
    {
        NSDictionary *dic = [_imageUrls objectAtIndex:0];
        NSArray *allKeys = [dic allKeys];
        if (allKeys && allKeys.count>0)
        {
            curkey = [[dic allKeys]objectAtIndex:0];
        }
        [_imageUrls removeObjectAtIndex:0];
        
        BOOL finished = YES;
        if ([_imageUrls count]>0 && !_needCancel)
            finished = NO;
        UIImage *image = [UIImage imageNamed:NO_IMAGE_NAME];
        if (self.receiveBlock) {
            self.receiveBlock(image,curkey,finished);
        }
        if(finished == YES)
            break;
    }
    
    
}

-(int)getLeftCount
{
    if(!_imageUrls)
        return 0;
    return _imageUrls.count;
}
@end
