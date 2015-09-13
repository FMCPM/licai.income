/*------------------------------------------------------------------------
 Filename       : 	InfoShareMethod.m
 
 Description	:   自定义的一个类：封装了第三方平台分享的一些方法
 
 Author         :   lzq,lvzhuqiang@ytinfo.zj.cn
 
 Date           :   2014-03-05
 
 version        :   v1.0
 
 Copyright      :   2014年 ytinfo. All rights reserved.
 
 ------------------------------------------------------------------------*/

#import "InfoShareMethod.h"
#import "SVProgressHUD.h"
#import <ShareSDK/ShareSDK.h>

@implementation InfoShareMethod

static InfoShareMethod* _pGInfoShareMethod = nil;

@synthesize m_pShareDelegate = _pShareDelegate;
- (id)init
{
    self = [super init];
    if (self) {
   
    }

    return self;
}

//获取单例的静态函数
+(InfoShareMethod*)sharedInstance
{
    @synchronized(self) {
        if (_pGInfoShareMethod == nil)
        {
            _pGInfoShareMethod = [[self alloc] init];
            /*
             if (!_pGFeePayComMethod) {
             _pGFeePayComMethod = [[self alloc] init];
             }*/
        }
    }
    return _pGInfoShareMethod;
}


//分享到新浪微博
- (void)shareToSinaWeibo:(NSString*)strTitle andContent:(NSString*)strContent andUrl:(NSString*)strUrl andImage:(NSString*)strImageUrl
{
    //创建分享内容
    NSString *imagePath = @"";//[[NSBundle mainBundle] pathForResource:IMAGE_NAME ofType:IMAGE_EXT];
    id<ISSContent> publishContent = [ShareSDK content:strContent
                                       defaultContent:@""
                                                image:[ShareSDK imageWithPath:imagePath]
                                                title:nil
                                                  url:nil
                                          description:nil
                                            mediaType:SSPublishContentMediaTypeText];
    
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:nil arrowDirect:UIPopoverArrowDirectionUp];
    
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:nil];
    
    //在授权页面中添加关注官方微博
    [authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
                                    SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
                                    SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),
                                    nil]];
    
    //显示分享菜单
    [ShareSDK showShareViewWithType:ShareTypeSinaWeibo
                          container:container
                            content:publishContent
                      statusBarTips:YES
                        authOptions:authOptions
                       shareOptions:[ShareSDK defaultShareOptionsWithTitle:nil
                                                           oneKeyShareList:[NSArray defaultOneKeyShareList]
                                                            qqButtonHidden:NO
                                                     wxSessionButtonHidden:NO
                                                    wxTimelineButtonHidden:NO
                                                      showKeyboardOnAppear:NO
                                                         shareViewDelegate:nil
                                                       friendsViewDelegate:nil
                                                     picViewerViewDelegate:nil]
                             result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                 
                                 if (state == SSPublishContentStateSuccess)
                                 {
                                     NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"发表成功"));
                                 }
                                 else if (state == SSPublishContentStateFail)
                                 {
                                     NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"发布失败!error code == %d, error code == %@"), [error errorCode], [error errorDescription]);
                                 }
                             }];
    
    /*//创建分享内容
    id<ISSCAttachment>  shareImg = nil;
    if(strImageUrl != nil & strImageUrl.length > 1)
    {
        shareImg= [ShareSDK imageWithUrl:strImageUrl];
    }
    strContent  =[strContent stringByAppendingFormat:@" %@",strUrl];
    id<ISSContent> publishContent = [ShareSDK content:strContent
                                       defaultContent:@"分享到新浪微博"
                                                image:shareImg
                                                title:strTitle
                                                  url:strUrl
                                          description:strContent
                                            mediaType:SSPublishContentMediaTypeText];
    
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:nil];
    
    //在授权页面中添加关注官方微博
    [authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"LiCai-InCome"],
                                    SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"LiCai-InCome"],
                                    SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),
                                    nil]];
    
    //显示分享菜单
    [ShareSDK showShareViewWithType:ShareTypeSinaWeibo
                          container:container
                            content:publishContent
                      statusBarTips:YES
                        authOptions:authOptions
                       shareOptions:[ShareSDK defaultShareOptionsWithTitle:nil
                                                           oneKeyShareList:[NSArray defaultOneKeyShareList]
                                                            qqButtonHidden:NO
                                                     wxSessionButtonHidden:NO
                                                    wxTimelineButtonHidden:NO
                                                      showKeyboardOnAppear:NO
                                                         shareViewDelegate:nil
                                                       friendsViewDelegate:nil
                                                     picViewerViewDelegate:nil]
                             result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                 
                                 if (state == SSPublishContentStateSuccess)
                                 {
                                     [SVProgressHUD showSuccessWithStatus:@"分享成功！" duration:1.8];
                                     [self backSuccResult];
                                 }
                                 else if (state == SSPublishContentStateFail)
                                 {
                                     [SVProgressHUD showErrorWithStatus:@"新浪微博分享失败!" duration:1.8];
                                     NSLog(@"sina error=%@", [error errorDescription]);
                                    
                                     
                                 }
                             }];
     */
}


//分享到腾讯微博
- (void)shareToTencentWeibo:(NSString*)strTitle andContent:(NSString*)strContent andUrl:(NSString*)strUrl andImage:(NSString*)strImageUrl
{
    
    id<ISSCAttachment>  shareImg = nil;
    if(strImageUrl != nil & strImageUrl.length > 1)
    {
        shareImg= [ShareSDK imageWithUrl:strImageUrl];
        NSLog(@"share img url=%@",strImageUrl);
    }
    strContent  =[strContent stringByAppendingFormat:@" %@",strUrl];
    id<ISSContent> publishContent = [ShareSDK content:strContent
                                       defaultContent:@"分享到腾讯微博"
                                                image:shareImg
                                                title:strTitle
                                                  url:strUrl
                                          description:strContent
                                            mediaType:SSPublishContentMediaTypeText];
    
    //显示分享菜单
    [ShareSDK showShareViewWithType:ShareTypeTencentWeibo
                          container:nil
                            content:publishContent
                      statusBarTips:NO
                        authOptions:nil
                       shareOptions:nil
                             result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                 
                                 if (state == SSPublishContentStateSuccess)
                                 {
                                     [SVProgressHUD showSuccessWithStatus:@"分享成功！"];
                                     [self backSuccResult];
                                 }
                                 else if (state == SSPublishContentStateFail)
                                 {
                                     
                                     [SVProgressHUD showErrorWithStatus:@"腾讯微博分享失败!"];
                                     
                                 }
                             }];
  
    /*
    [ShareSDK showShareViewWithType:ShareTypeTencentWeibo
                          container:nil
                            content:publishContent
                      statusBarTips:YES
                        authOptions:nil
                       shareOptions:[ShareSDK defaultShareOptionsWithTitle:nil
                                                           oneKeyShareList:[NSArray defaultOneKeyShareList]
                                                            qqButtonHidden:NO
                                                     wxSessionButtonHidden:NO
                                                    wxTimelineButtonHidden:NO
                                                      showKeyboardOnAppear:NO
                                                         shareViewDelegate:nil
                                                       friendsViewDelegate:nil
                                                     picViewerViewDelegate:nil]
                             result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                 
                                 if (state == SSPublishContentStateSuccess)
                                 {
                                     [SVProgressHUD showSuccessWithStatus:@"分享成功！"];
                                     [self backSuccResult];
                                 }
                                 else if (state == SSPublishContentStateFail)
                                 {

                                     [SVProgressHUD showErrorWithStatus:@"腾讯微博分享失败!"];
                                     
                                 }
                             }];*/
}

//分享给QQ好友
- (void)shareToQQFriend:(NSString*)strTitle andContent:(NSString*)strContent andUrl:(NSString*)strUrl andImage:(NSString*)strImageUrl
{
    
    id<ISSCAttachment>  shareImg = nil;
    if(strImageUrl != nil & strImageUrl.length > 1)
    {
        shareImg= [ShareSDK imageWithUrl:strImageUrl];
    }

    id<ISSContent> publishContent = [ShareSDK content:strContent
                                       defaultContent:@"分享到QQ好友"
                                                image:shareImg
                                                title:strTitle
                                                  url:strUrl
                                          description:strContent
                                            mediaType:SSPublishContentMediaTypeText];
    
    //创建弹出菜单容器
   // id<ISSContainer> container = [ShareSDK container];
    
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:nil];
    
    //在授权页面中添加关注官方微博
    [authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"LiCai-InCome"],
                                    SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"LiCai-InCome"],
                                    SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),
                                    nil]];
 /*
    //显示分享菜单（将分享至qq空间改成好友，函数名称不改了,2014-05-13）
    [ShareSDK showShareViewWithType:ShareTypeQQ
                          container:nil
                            content:publishContent
                      statusBarTips:YES
                        authOptions:authOptions
                       shareOptions:[ShareSDK defaultShareOptionsWithTitle:nil
                                                           oneKeyShareList:[NSArray defaultOneKeyShareList]
                                                            qqButtonHidden:NO
                                                     wxSessionButtonHidden:NO
                                                    wxTimelineButtonHidden:NO
                                                      showKeyboardOnAppear:NO
                                                         shareViewDelegate:nil
                                                       friendsViewDelegate:nil
                                                     picViewerViewDelegate:nil]
                             result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                 
                                 if (state == SSPublishContentStateSuccess)
                                 {
                                     [SVProgressHUD showSuccessWithStatus:@"分享成功！"];
                                     [self backSuccResult];
                                 }
                                 else if (state == SSPublishContentStateFail)
                                 {
                                     NSString* strErrorHint = [NSString stringWithFormat: @"腾讯微博分享失败：：error code == %d, error info == %@", [error errorCode], [error errorDescription]];
                                     [SVProgressHUD showErrorWithStatus:strErrorHint];
                                     
                                 }
                                 
                             }];
    
   */
    
    [ShareSDK showShareViewWithType:ShareTypeQQ
                          container:nil
                            content:publishContent
                      statusBarTips:YES
                        authOptions:authOptions
                       shareOptions:[ShareSDK defaultShareOptionsWithTitle:nil
                                                           oneKeyShareList:[NSArray defaultOneKeyShareList]
                                                            qqButtonHidden:NO
                                                     wxSessionButtonHidden:NO
                                                    wxTimelineButtonHidden:NO
                                                      showKeyboardOnAppear:NO
                                                         shareViewDelegate:nil
                                                       friendsViewDelegate:nil
                                                     picViewerViewDelegate:nil]
                             result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                 
                                 if (state == SSPublishContentStateSuccess)
                                 {
                                     [SVProgressHUD showSuccessWithStatus:@"分享成功！"];
                                     [self backSuccResult];
                                 }
                                 else if (state == SSPublishContentStateFail)
                                 {
                                     
                                     NSString* strErrorHint = [NSString stringWithFormat: @"腾讯好友分享失败：error code == %d, error info == %@", [error errorCode], [error errorDescription]];
                                     
                                     [SVProgressHUD showErrorWithStatus:strErrorHint];
                                 }
                             }];
   
}


//分享给微信好友
- (void)shareToWeixinSession:(NSString*)strTitle andContent:(NSString*)strContent andUrl:(NSString*)strUrl andImage:(NSString*)strImageUrl

{
    //创建分享内容
    id<ISSCAttachment>  shareImg = nil;
    if(strImageUrl != nil & strImageUrl.length > 1)
    {
        shareImg= [ShareSDK imageWithUrl:strImageUrl];
    }
    //modify by lzq at 2014-09-24：IOS的微信好友，分享的时候，strContent字段是有微信分享的时候填写，所以可以为0，title才是实际显示的。
    strTitle = strContent;
    id<ISSContent> publishContent = [ShareSDK content:strContent
                                       defaultContent:@"分享到微信好友"
                                                image:shareImg
                                                title:strTitle
                                                  url:strUrl
                                          description:strContent
                                            mediaType:SSPublishContentMediaTypeNews];
    
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:nil];
    
    //在授权页面中添加关注官方微博
    [authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"LiCai-InCome"],
                                    SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"LiCai-InCome"],
                                    SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),
                                    nil]];
    
    //显示分享菜单
    [ShareSDK showShareViewWithType:ShareTypeWeixiSession
                          container:nil
                            content:publishContent
                      statusBarTips:YES
                        authOptions:authOptions
                       shareOptions:[ShareSDK defaultShareOptionsWithTitle:nil
                                                           oneKeyShareList:[NSArray defaultOneKeyShareList]
                                                            qqButtonHidden:NO
                                                     wxSessionButtonHidden:NO
                                                    wxTimelineButtonHidden:NO
                                                      showKeyboardOnAppear:NO
                                                         shareViewDelegate:nil
                                                       friendsViewDelegate:nil
                                                     picViewerViewDelegate:nil]
                             result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                 
                                 if (state == SSPublishContentStateSuccess)
                                 {
                                     [SVProgressHUD showSuccessWithStatus:@"分享成功！"];
                                     [self backSuccResult];
                                 }
                                 else if (state == SSPublishContentStateFail)
                                 {

                                     //NSLog(@"微信好友分享失败:code=%d,msg=%@",[error errorCode],[error errorDescription]);
                                     NSString* strErrorMsg = [NSString stringWithFormat:@"微信好友分享失败:%@！",[error errorDescription]];
                                    [SVProgressHUD showErrorWithStatus:strErrorMsg duration:2.0];

                                 }
                             }];
}

//分享给微信朋友圈
- (void)shareToWeixinTimeline:(NSString*)strTitle andContent:(NSString*)strContent andUrl:(NSString*)strUrl andImage:(NSString*)strImageUrl
{
    id<ISSCAttachment>  shareImg = nil;
    if(strImageUrl != nil & strImageUrl.length > 1)
    {
        shareImg= [ShareSDK imageWithUrl:strImageUrl];
    }
    //modify by lzq at 2014-09-24：IOS的微信好友，分享的时候，strContent字段是有微信分享的时候填写，所以可以为0，title才是实际显示的。
    strTitle = strContent;
    //strContent = @"";
    id<ISSContent> publishContent = [ShareSDK content:strContent
                                       defaultContent:@"微信朋友圈"
                                                image:shareImg
                                                title:strTitle
                                                  url:strUrl
                                          description:strContent
                                            mediaType:SSPublishContentMediaTypeNews];
    
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:nil];
    
    //在授权页面中添加关注官方微博
    [authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"LiCai-InCome"],
                                    SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"LiCai-InCome"],
                                    SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),
                                    nil]];
    
    //显示分享菜单
    [ShareSDK showShareViewWithType:ShareTypeWeixiTimeline
                          container:nil
                            content:publishContent
                      statusBarTips:YES
                        authOptions:authOptions
                       shareOptions:[ShareSDK defaultShareOptionsWithTitle:nil
                                                           oneKeyShareList:[NSArray defaultOneKeyShareList]
                                                            qqButtonHidden:NO
                                                     wxSessionButtonHidden:NO
                                                    wxTimelineButtonHidden:NO
                                                      showKeyboardOnAppear:NO
                                                         shareViewDelegate:nil
                                                       friendsViewDelegate:nil
                                                     picViewerViewDelegate:nil]
                             result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                 
                                 if (state == SSPublishContentStateSuccess)
                                 {
                                     [SVProgressHUD showSuccessWithStatus:@"分享成功！"];
                                     [self backSuccResult];
                                 }
                                 else if (state == SSPublishContentStateFail)
                                 {

                                     NSString* strErrorMsg = [NSString stringWithFormat:@"微信朋友圈:%@！",[error errorDescription]];
                                     [SVProgressHUD showErrorWithStatus:strErrorMsg duration:2.0];
                                     
                                 }
                                 
                             }];
}

-(void)backSuccResult
{

    if(_pShareDelegate == nil)
        return;
    if([_pShareDelegate respondsToSelector:@selector(onShareSkdBackSharedSucc)] == false)
        return;
    [_pShareDelegate onShareSkdBackSharedSucc];
}

//启动分享
- (void)shareToMultPlat:(NSInteger)iSharType andTitle:(NSString*)strTitle andContent:(NSString*)strContent andUrl:(NSString*)strUrl andImage:(NSString*)strImageUrl
{
    if(iSharType == 1)//qq好友
    {
        [[InfoShareMethod sharedInstance] shareToQQFriend:strTitle andContent:strContent andUrl:strUrl andImage:strImageUrl];
    }
    else if(iSharType == 2)
    {
        [[InfoShareMethod sharedInstance] shareToWeixinSession:strTitle andContent:strContent andUrl:strUrl andImage:strImageUrl];
        
    }
    else if(iSharType == 3)//朋友圈
    {
        [[InfoShareMethod sharedInstance] shareToWeixinTimeline:strTitle andContent:strContent andUrl:strUrl andImage:strImageUrl];
    }
    else if(iSharType == 4)//新浪微博
    {
     
        [[InfoShareMethod sharedInstance] shareToSinaWeibo:strTitle andContent:strContent andUrl:strUrl andImage:strImageUrl];
    }


}

@end
