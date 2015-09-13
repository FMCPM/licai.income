/*------------------------------------------------------------------------
 Filename       : 	AnsyImageData.h
 
 Description	:   自定义的一个类：封装了在IOS下面，从网络上下载图片相关的操作（method）方法，包括网络连接、图片流下载和存储等。
 
 Author         :   lzq,lvzhuqiang@ytinfo.zj.cn
 
 Date           :   2012-06-15
 
 version        :   v1.0
 
 Copyright      :   2012年 ytinfo. All rights reserved.
 
 ------------------------------------------------------------------------*/
#import <Foundation/Foundation.h>
#import "AnsyImageData.h"

@interface AnsyImageTaskObj : NSObject
{
    //图片对应的DataSet数据集中的行的索引，如果是应用程序启动图片，则是图片的版本号
    NSInteger   m_iImageRowIndex;
    //图片对应服务器的URL
    NSString*   m_strImgUrl;
    //存储图片的数据缓存区
    AnsyImageData*  m_pAnsyImageData;
}
//启动图片异步下载的任务;
-(NSInteger)startAnsyDownLoadLogoImg:(NSInteger)iImgRowIndex andImgUrl:(NSString*)strImgUrl;
//是否已经结束图片的下载
-(BOOL)isFinishedDownLoad;
//获取图片当所属数据集中对应行的索引值
-(NSInteger)getImageRowIndex;
//获取图片的存储区
-(AnsyImageData*)getAnsyImageDataBuf;
//获取图片的URL
-(NSString*)getImageUrl;
//从服务器端下载应用程序图片
-(NSInteger)startAnsyDownLoadAppImg;
//
-(void)addAppImageDownLoadInfo:(NSInteger)iImageVersion andImgUrl:(NSString*)strImgUrl;
@end
