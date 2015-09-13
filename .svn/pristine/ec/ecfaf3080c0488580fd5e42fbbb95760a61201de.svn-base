//
//  WebServiceHelper.h
//  ahdxyp
//
//  Created by jiang junchen on 12-8-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebServiceMethod.h"
#import "AnsyImageTaskObj.h"


@protocol WebServiceHelperDelegate;

#define WEBSERVICE_OK               0x01
#define WEBSERVICE_STARTERO         0x02
#define WEBSERVICE_FINISHERO        0x04
#define WEBSERVICE_DATAERO          0x08
#define WEBSERVICE_FINISHED         0x10
#define WEBSERVICE_IGNO             0x0

@interface WebServiceHelper : NSObject<NSURLConnectionDelegate,NSURLConnectionDataDelegate>{
    WebServiceMethod *m_WebServiceMethod;
    QDataSetObj *m_WebServiceDataSet;
    AnsyImageTaskObj *m_pAnsyImageTaskObj;
    __weak id _fatherController;
  //  NSURLConnection *_curConnection;
    NSMutableData *_webDataBuf;//webservice返回信息的存储区
    int _iState;
}

@property (nonatomic, weak) id <WebServiceHelperDelegate> m_delegate;
@property (nonatomic, assign) BOOL m_isNeedDealloc;
@property (nonatomic, assign) BOOL m_isFinishDownLoadImg;
@property (nonatomic, assign) NSInteger m_iTag;

+(void) removeService:(WebServiceHelper*)service FromController:(id)controller;
+(void) removeAllServicesFromController:(id)controller;
-(id) initWithFatherController:(id)controller;

- (void) StartWebServiceMerhod:(NSString *)methodMsg
                 andMethodName:(NSString *)methodName
                 andCompletion:(void(^)(void))completion;
-(void)downLoadImageWithUrl:(NSString*)imgurl andKey:(NSString*)key;
//-(void)downLoadImagesWithUrls:(NSArray *)arrUrls;
-(void)downLoadImagesWithUrls:(NSArray *)arrUrls andKeys:(NSArray *)arrKeys;
//-(void)downLoadImageWithImageUrl:(NSString *)strImageUrl;
-(void)uploadFile:(NSString*)fileName toBaseUrl:(NSURL*)url;
-(void)uploadFromUrl:(NSURL *)sUrl toBaseUrl:(NSURL *)dUrl withMemberId:(NSString*)memberId;
-(void)uploadFromUrl:(NSURL *)sUrl toBaseUrl:(NSURL *)dUrl;

@end

@protocol WebServiceHelperDelegate <NSObject>

- (void) webServiceHelper:(WebServiceHelper *)service WithResultState:(NSInteger)rsltState DataSet:(QDataSetObj *)dataSet;
@optional
//- (void) webServiceHelper:(WebServiceHelper *)service WithUIImage:(UIImage *)image andIndex:(NSUInteger)index;
- (void) webServiceHelper:(WebServiceHelper *)service WithResultState:(NSInteger)rsltState andUIImage:(UIImage *)image andKey:(NSString*)key;
@end
