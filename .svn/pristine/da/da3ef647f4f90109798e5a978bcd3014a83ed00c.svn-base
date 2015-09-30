/*------------------------------------------------------------------------
 Filename       : 	InfoShareMethod.h
 
 Description	:   自定义的一个类：封装了第三方平台分享的一些方法
 
 Author         :   lzq,lvzhuqiang@ytinfo.zj.cn
 
 Date           :   2014-03-05
 
 version        :   v1.0
 
 Copyright      :   2014年 ytinfo. All rights reserved.
 
 ------------------------------------------------------------------------*/

#import <UIKit/UIKit.h>


@protocol InfoShareMethodDelegate <NSObject>

@optional
-(void)onShareSkdBackSharedSucc;
@end

@interface InfoShareMethod : NSObject
{
}

//获取单例的静态函数
+(InfoShareMethod*)sharedInstance;


@property (assign, nonatomic) id <InfoShareMethodDelegate> m_pShareDelegate;

//分享到新浪微博
- (void)shareToSinaWeibo:(NSString*)strTitle andContent:(NSString*)strContent andUrl:(NSString*)strUrl andImage:(NSString*)strImageUrl;
//分享到腾讯微博
- (void)shareToTencentWeibo:(NSString*)strTitle andContent:(NSString*)strContent andUrl:(NSString*)strUrl andImage:(NSString*)strImageUrl;
//分享给QQ好友
- (void)shareToQQFriend:(NSString*)strTitle andContent:(NSString*)strContent andUrl:(NSString*)strUrl andImage:(NSString*)strImageUrl;
//分享给微信好友
- (void)shareToWeixinSession:(NSString*)strTitle andContent:(NSString*)strContent andUrl:(NSString*)strUrl andImage:(NSString*)strImageUrl;
//分享给微信朋友圈
- (void)shareToWeixinTimeline:(NSString*)strTitle andContent:(NSString*)strContent andUrl:(NSString*)strUrl andImage:(NSString*)strImageUrl;
//分享
- (void)shareToMultPlat:(NSInteger)iSharType andTitle:(NSString*)strTitle andContent:(NSString*)strContent andUrl:(NSString*)strUrl andImage:(NSString*)strImageUrl;

@end
