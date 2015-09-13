//
//  Define.h
//  YP
//
//  Created by luming on 12-2-15.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+Hex.h"


@protocol GlobalDefine


/*---------------------------1-------------------------*/
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define IS_OS_5_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0)

#define IMG_WITH_ARG(str) ( \
[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(str@"@2x") ofType:@"png"]] \
)

#define IMG_WITH_ARG_v2(str) ( \
[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(str) ofType:@"png"]] \
)

#define SYSTEM_VESION [[[UIDevice currentDevice] systemVersion] floatValue]

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )


/*---------------------------2-------------------------*/
#define  NO_IMAGE_NAME  @"bg_noLogoImg.png"
#define  LOADING_IMAGE_NAME @"bg_imgloading.png"
#define  ERROR_IMAGE_NAME @"bg_errorloadimg.png"
#define HINT_LASTEST_PAGE @"已经到底了！"


#define cell_height_0   44.0
#define cell_height_normal  80.0
#define img_length      60.0



#define start_color [UIColor colorWithRed:220.0/255 green:140.0/255 blue:0 alpha:1.0f]
#define end_color [UIColor colorWithRed:250.0/255 green:170.0/255 blue:0 alpha:1.0f]
#define selection_start_color [UIColor colorWithHex:0xda862c]
#define selection_end_color [UIColor colorWithHex:0xdf862c]

enum msgRet
{
	RET_OK =0,
	RET_FAIL =1,
	RET_ELSE =99
};

enum ansyMsgType
{
	MSG_TYPE_STARTVIEW = 1
};

enum userLoginRet {
	LOGIN_OK =0,
	LOGIN_NAME_NULL =1,
	LOGIN_USER_NOT_EXIT =2,
	LOGIN_PWD_ERR =3,
	LOGIN_OTHER_ERR =99
};
#define RGBCOLOR(r,g,b) \
[UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:1.f]

#define RGBACOLOR(r,g,b,a) \
[UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:a]


#define COLOR_CELL_LINE_DEFAULT \
[UIColor colorWithRed:232/255.0 green:232/255.0 blue:232/255.0 alpha:1.0]

//字体颜色一，接近黑色
#define COLOR_FONT_1    \
[UIColor colorWithRed:84/255.0 green:84/255.0 blue:84/255.0 alpha:1.0]

//字体颜色二，接近淡灰色
#define COLOR_FONT_2    \
[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0]

//字体颜色三，接近橙色
#define COLOR_FONT_3    \
[UIColor colorWithRed:253/255.0 green:167/255.0 blue:76/255.0 alpha:1.0]

//字体颜色四，接近绿色
#define COLOR_FONT_4    \
[UIColor colorWithRed:92/255.0 green:184/255.0 blue:67/255.0 alpha:1.0]

//字体颜色五，接近红色
#define COLOR_FONT_5    \
[UIColor colorWithRed:252/255.0 green:0/255.0 blue:16/255.0 alpha:1.0]

//字体颜色六，接近蓝色
#define COLOR_FONT_6    \
[UIColor colorWithRed:35/255.0 green:118/255.0 blue:158/255.0 alpha:1.0]


//默认的背景色，有点淡蓝色
#define COLOR_VIEW_BACKGROUND \
RGBCOLOR(238, 242, 245)

//默认的背景色，接近亮灰色
#define COLOR_BAR_BACKGROUND \
[UIColor colorWithHex:0xF5F5F5]

//按钮的边框颜色(接近橙色)
#define COLOR_BUTTON_RECT  \
RGBCOLOR(253, 167, 33)

//按钮的字体(接近橙色)
#define COLOR_BUTTON_FONT \
RGBCOLOR(221, 114, 76)


//add by lzq at 2014-11-25

//按钮的边框颜色1，淡灰色
#define COLOR_BTN_BORDER_1 \
[UIColor colorWithRed:197/255.0 green:197/255.0 blue:197/255.0 alpha:1.0]

//按钮的边框颜色2，接近橙色
#define COLOR_BTN_BORDER_2 \
RGBCOLOR(253, 167, 33)

//按钮的边框颜色3，接近蓝色
#define COLOR_BTN_BORDER_3 \
RGBCOLOR(137,200, 196)
//定义页面的背景色

//视图的背景色1，有点淡蓝色
#define COLOR_VIEW_BK_01 \
RGBCOLOR(238, 242, 245)

//视图的背景色2，接近亮灰色
#define COLOR_VIEW_BK_02 \
RGBCOLOR(239, 239, 239)

//视图的背景色3，接近橙色
#define COLOR_VIEW_BK_03 \
RGBCOLOR(253, 167, 33)

//视图的背景色4，接近淡橙色（）
#define COLOR_VIEW_BK_04 \
RGBCOLOR(253, 248, 234)

//视图的背景色4，接近淡灰色（）
#define COLOR_VIEW_BK_05 \
RGBCOLOR(252, 252, 252)
///---------------------------------------------------------------------------
/// @name Calling Delegates
///---------------------------------------------------------------------------
#define JC_CALL_DELEGATE(_delegate, _selector) \
do { \
id _theDelegate = _delegate; \
if(_theDelegate != nil && [_theDelegate respondsToSelector:_selector]) { \
[_theDelegate performSelector:_selector]; \
} \
} while(0);

#define JC_CALL_DELEGATE_WITH_ARG(_delegate, _selector, _argument) \
do { \
id _theDelegate = _delegate; \
if(_theDelegate != nil && [_theDelegate respondsToSelector:_selector]) { \
[_theDelegate performSelector:_selector withObject:_argument]; \
} \
} while(0);

#define JC_CALL_DELEGATE_WITH_ARGS(_delegate, _selector, _arg1, _arg2) \
do { \
id _theDelegate = _delegate; \
if(_theDelegate != nil && [_theDelegate respondsToSelector:_selector]) { \
[_theDelegate performSelector:_selector withObject:_arg1 withObject:_arg2]; \
} \
} while(0);



//服务端操作时网络错误（包括对应接口返回异常数据）
#define HINT_WEBDATA_NET_ERROR @"网络错误，请稍后重试..."
//向服务的提交数据
#define HINT_WEBDATA_SUBMITING @"正在提交请求，请稍后..."
//向服务的提交数据
#define HINT_WEBDATA_LOADING @"正在加载，请稍后..."

//输入的信息超过规定的长度
#define HINT_BIG_MAX_LENGTH @"您输入的信息过长！"

//买家标识
#define BUYER_FLAG_ID    1
//卖家标识
#define SELLER_FLAG_ID   2
//本地最多的记录行数
#define MAXCOUNT_ROW_LOCALDB   1000
@end
