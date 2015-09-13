//
//  CKHttpImageHelper.h
//  FJ-E-YellowPage
//
//  Created by jiangjunchen on 13-5-15.
//  Copyright (c) 2013年 ytinfo. All rights reserved.
//

#import "CKHttpHelper.h"

typedef void(^CKHttpImageReceiveBlock)(UIImage *image,NSString *key,BOOL finished);

@interface CKHttpImageHelper : CKHttpHelper
{
    NSMutableArray *_imageUrls;
    BOOL _needCancel;
    BOOL _isDownLoading;
}

+(void)setImageCachePolicy:(NSURLRequestCachePolicy)imgCachePolicy;
+(void)setIsNeedDownImageFlag:(NSInteger)iFlag;

@property (copy,nonatomic) void(^receiveBlock)(UIImage *image,NSString *key,BOOL finished) ;

-(void)addImageUrl:(NSURL*)imgUrl forKey:(NSString*)key;
-(void)startWithReceiveBlock:(void(^)(UIImage *image,NSString *key,BOOL finished))receiveBlock;
-(int)getLeftCount;

@end
