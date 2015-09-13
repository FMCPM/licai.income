//
//  ChineseString.h

//
//  Created by  on 14-8-16.
//  Copyright (c) 2014年 ytinfo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "pinyin.h"


@interface ChineseString : NSObject

@property(retain,nonatomic)NSString *string;
@property(retain,nonatomic)NSString *pinYin;

@end
