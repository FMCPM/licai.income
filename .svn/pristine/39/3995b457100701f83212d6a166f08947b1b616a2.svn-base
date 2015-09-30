//
//  CKQueue.h
//  YTSearch
//
//  Created by jiang junchen on 12-11-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CKQueue : NSObject{
    NSMutableArray *_muQueueArray;
}

@property (readonly, nonatomic) id m_idFront;
@property (readonly, nonatomic) id m_idRear;
@property (readonly, nonatomic) NSUInteger m_iCount;
@property (readonly, nonatomic) NSUInteger m_iSize;
@property (assign, nonatomic)   NSUInteger m_iWillDeleteNumberWhenFull;


-(id) initWithQueueMaxSize:(NSInteger)size;

/*********************************************************************************
 YES：表示队列未满，直接从队尾添加对象 如果队列已满，
 先从队头移出n（属性m_iWillDeleteNumberWhenFull)个对象再添加；
 
 NO：表示obj添加失败 失败原因在控制台输出）
 *********************************************************************************/
-(BOOL) addQueue:(id)obj withKey:(NSString*)key;

//根据键值删除对象      NO:没有该对象删除失败
-(BOOL) delObjectByKey:(NSString*)key;

-(BOOL) delObject:(id)obj;
//从队头删除一个对象    NO:队列为空删除失败 
-(BOOL) delQueue;

-(id)objectForKey:(NSString*)key;

-(void) delAllObjects;

@end
