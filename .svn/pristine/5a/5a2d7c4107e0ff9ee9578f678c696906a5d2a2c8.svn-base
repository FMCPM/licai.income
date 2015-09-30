/*------------------------------------------------------------------------
 Filename       : 	ImgFileMethod.h
 
 Description	:   一个自定义的文件操作方法类，主要用于图片数据的本地缓存，从而提高效率，减少不必要的网络流量
 
 Author         :   lzq,lvzhuqiang@ytinfo.zj.cn
 
 Date           :   2012-06-28
 
 version        :   v1.0
 
 Copyright      :   2012年 ytinfo. All rights reserved.
 
 ------------------------------------------------------------------------*/
#import <Foundation/Foundation.h>

//上传图片最大允许为500K
#define MAX_IMAGE_SIZE 500
#define MAX_USERHEADER_IMAGE_SIZE 50
#define MAX_STORE_IMAGE_SIZE 20

@interface ImgFileMethod : NSObject
{

    
}


//图片类型
@property (nonatomic,assign)NSInteger  m_iImageType;

//获取指定大小的图片
-(UIImage*)zoomInImage:(UIImage*)pOraImage andSize:(CGSize)size;
//获取可以上传的图片的流
-(NSData*)getCanUploadImageData:(UIImage*)pImage;


//判断本地是否存在图片文件，如果存在，则直接从本地读取
-(NSMutableData*)getImageDataFromLocal:(NSString*)strImgUrl;
//从本地获取图片路径
-(NSString*)getLocalImagelUrlPath:(NSString*)strImageUrl;
//将图片数据写到本地缓存区中
-(bool)writeImageDataToLocalCache:(NSMutableData*)pImageData andImageName:(NSString*)strImageName;
//将新闻信息保存至于临时文件
-(NSString*)saveTempHtmlFileForNewsInfo:(NSString*)strNewsInfo;
//获取可以上传的店铺图片
-(NSData*)getCanUploadStoreImageBites:(UIImage*)pImage;
//获取可以上传的用户头像图片的流
-(NSData*)getCanUploadUserHeaderImage:(UIImage*)pImage;
//获取可以上传的店铺图片的流
//-(NSData*)getCanUploadImageStoreData:(UIImage*)pImage;




//从本地获取图片路径
+(NSString*)getLocalImagelUrlPath:(NSString*)strImageUrl;
//从本地获取缓存图片
+(UIImage*)getImageFormLocal:(NSString*)strImgUrl;
//获取应用程序沙盒中的Document目录
+(NSString*)getAppDocumentDir;
//获取应用程序沙盒中的tmp目录：保存应用数据，但不需要持久化的，在应用关闭后，该目录下的数据将删除 
+(NSString*)getAppTempDir;
//根据文件的全局路径，获取文件名
+(NSString*)getImgNameFormUrl:(NSString*)strImgUrl;
//获取应用程序沙盒中的Document目录下存放缓存图片的目录
+(NSString*)getAppDocumentImageDir;
//根据图片名称删除本地图片文件
+(void)deleteImgfileWithImgName:(NSString*)imgname;


@end
