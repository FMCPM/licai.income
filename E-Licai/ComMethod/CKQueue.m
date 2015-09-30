//
//  CKQueue.m
//  YTSearch
//
//  Created by jiang junchen on 12-11-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CKQueue.h"

@implementation CKQueue
@synthesize m_idFront       = _idFront;
@synthesize m_idRear        = _idRear;
@synthesize m_iCount        = _iCount;
@synthesize m_iSize         = _iSize;
@synthesize m_iWillDeleteNumberWhenFull   = _iWillDeleteNumberWhenFull;

-(void)initialize
{
    _muQueueArray = [[NSMutableArray alloc]init];
    _iCount = 0;
    _iSize  = 100;
    _iWillDeleteNumberWhenFull = 1;
}

-(id)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

-(id) initWithQueueMaxSize:(NSInteger)size
{
    self = [super init];
    if (self) {
        [self initialize];
        if (size < 1) {
            NSLog(@"CKQueue Ero:[initWithQueueMaxSize:] MaxSize should >= 1!");
        }
        else {
            _iSize = size;
        }
    }
    return self;
}

-(void)setM_iWillDeleteNumberWhenFull:(NSUInteger)number
{
    if (number < 1) {
        NSLog(@"CKQueue Ero:[setM_iWillDeleteNumberWhenFull:] number should >= 1!");
        number = 1;
    }
    
    if (number > _iSize) {
        NSLog(@"CKQueue Ero:[setM_iWillDeleteNumberWhenFull:] number should <= MaxSize!");
        number = _iSize;
    }
    _iWillDeleteNumberWhenFull = number;
}
/*********************************************************************************
 YES：表示队列未满，直接从队尾添加对象 如果队列已满，
 先从队头移出n（属性m_iWillDeleteNumberWhenFull)个对象再添加；
 
 NO：表示obj添加失败 失败原因在控制台输出）
 *********************************************************************************/
-(BOOL) addQueue:(id)obj withKey:(NSString*)key
{
    if (!obj) {
        NSLog(@"CKQueue Ero:[addQueue] object can't be nil!");
        return NO;
    }
    if (!key) {
        key = [[NSString alloc]initWithFormat:@"%@",obj];
    }
    
    if (_muQueueArray.count >= _iSize) {

        NSRange range = NSMakeRange(0, _iWillDeleteNumberWhenFull);
      //  NSRange range = NSMakeRange(0, _iWillDeleteNumberWhenFull);
        NSIndexSet *indexset = [[NSIndexSet alloc]initWithIndexesInRange:range];
        [_muQueueArray removeObjectsAtIndexes:indexset];
    }
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:obj,key, nil];
    [_muQueueArray addObject:dic];
    _iCount = _muQueueArray.count;
    return YES;
}

//根据键值删除对象      NO:没有该对象删除失败
-(BOOL) delObjectByKey:(NSString*)key
{
    if (!key) {
        NSLog(@"CKQueue Ero:[delObjectByKey:] key can't be nil!");
        return NO;
    }
    for (NSDictionary* dic in _muQueueArray) {
        id obj = [dic objectForKey:key];
        if (obj) {
            [_muQueueArray removeObject:dic];
            _iCount = _muQueueArray.count;
            return YES;
        }
    }
    return NO;
}

-(BOOL) delObject:(id)obj
{
    if (!obj) {
        NSLog(@"CKQueue Ero:[delObject:] obj can't be nil!");
        return NO;
    }
    BOOL flag = NO;
    for (NSDictionary *dic in _muQueueArray) {
        NSString *key = [NSString stringWithFormat:@"%@",obj];
        id delobj = [dic objectForKey:key];
        if (delobj) {
            [_muQueueArray removeObject:dic];
            _iCount = _muQueueArray.count;
            flag = YES;
        }
    }
    return flag;
}

//从队头删除一个对象    NO:队列为空删除失败 
-(BOOL) delQueue
{
    if(_muQueueArray.count == 0) {
        return NO;
    }
    [_muQueueArray removeObjectAtIndex:0];
    return YES;
}

-(id)objectForKey:(NSString*)key
{
    if (!key) {
        NSLog(@"CKQueue Ero:[objectForKey:] key can't be nil!");
        return nil;
    }
    for (NSDictionary *dic in _muQueueArray) {
        id obj = [dic objectForKey:key];
        if (obj) {
            return obj;
        }
    }
    return nil;
}

-(void) delAllObjects
{
    [_muQueueArray removeAllObjects];
    _iCount = _muQueueArray.count;
}
@end
