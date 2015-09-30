//
//  CKConfig.h
//  CKSpritesEditer
//
//  Created by jiangjunchen on 13-5-2.
//  Copyright (c) 2013年 ckools. All rights reserved.
//

#ifndef CKSpritesEditer_CKConfig_h
#define CKSpritesEditer_CKConfig_h

//ARC
#if __has_feature(objc_arc)
//如果项目为ARC
#define AutoRelease(obj) (id)(obj)
#define Release(obj) (obj) = nil
#define Retain1(obj) (obj)
#define CKBridge  __bridge
#define Retain(obj) (obj)
#define CKWeak  weak
#define CKStrong strong
#define Dealloc() 
#else
//不是ARC
#define AutoRelease(obj) [(obj) autorelease]
#define Release(obj) if((obj)) [(obj) release]; (obj)=nil;
#define Retain(obj) [(obj) retain]
#define Retain1(obj) [(obj) retain]
#define CKBridge  
#define CKWeak  assign
#define CKStrong retain
#define Dealloc() [super dealloc]
#endif

#endif