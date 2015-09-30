/*------------------------------------------------------------------------
 Filename       : 	AnsyImageData.cpp
 
 Description	:   自定义的一个类：封装了在IOS下面，从网络上下载图片相关的操作（method）方法，包括网络连接、图片流下载和存储等。
 
 Author         :   lzq,lvzhuqiang@ytinfo.zj.cn
 
 Date           :   2012-06-15
 
 version        :   v1.0
 
 Copyright      :   2012年 ytinfo. All rights reserved.
 
 ------------------------------------------------------------------------*/
#import "AnsyImageTaskObj.h"
#import "ImgFileMethod.h"
#import "GlobalDefine.h"

@implementation AnsyImageTaskObj

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        m_pAnsyImageData = NULL;
        m_strImgUrl      = NULL;
    }
    
    return self;
}

/*------------------------------------------------------------------------
 Function    :startAnsyDownLoadLogoImg
 Description :启动图片异步下载的任务;
 Params      :
    iImgRowIndex:图片所属企业在数据集中的对应行记录的索引
    stImgrUrl:图片对应的完整的URL
 Result      :int 
 Author      :lzq,lvzhuqiang@ytinfo.zj.cn
 DateTime    :2012-06-15
 ------------------------------------------------------------------------*/

-(NSInteger)startAnsyDownLoadLogoImg:(NSInteger)iImgRowIndex andImgUrl:(NSString*)strImgUrl
{
    
    m_strImgUrl = nil;
    m_strImgUrl = strImgUrl;
    
    m_iImageRowIndex = iImgRowIndex;
    m_pAnsyImageData = [[AnsyImageData alloc] init];
   
    //先判断本地文件是否存在，如果存在，则不需要再次下载了
    ImgFileMethod* pMethod = [[ImgFileMethod alloc] init];    
    NSMutableData*pImageData = [pMethod getImageDataFromLocal:strImgUrl];
    int iResultID = RET_OK;
    if(pImageData == NULL)
    {
        iResultID = [m_pAnsyImageData loadImageFromURL:strImgUrl];
    }
    else 
    {
        [m_pAnsyImageData setImageDataStream:pImageData];
    }
    return  iResultID;
    
}

//从服务器端下载应用程序图片
-(NSInteger)startAnsyDownLoadAppImg
{
    if(m_strImgUrl == NULL )
        return  RET_FAIL;
    m_pAnsyImageData = [[AnsyImageData alloc] init];
    //启动图片下载
    NSInteger iResultID = [m_pAnsyImageData loadImageFromURL:m_strImgUrl];
    return  iResultID;

}

//设置应用程序程序图片下载信息
-(void)addAppImageDownLoadInfo:(NSInteger)iImageVersion andImgUrl:(NSString*)strImgUrl
{
    m_strImgUrl = nil;
    m_strImgUrl = strImgUrl;
    m_iImageRowIndex = iImageVersion;
    
}

//是否已经结束图片的下载
-(BOOL)isFinishedDownLoad
{
    if(m_pAnsyImageData == NULL)
        return TRUE;
    return [m_pAnsyImageData isFinished];
}


//获取图片当所属数据集中对应行的索引值
-(NSInteger)getImageRowIndex
{
    return m_iImageRowIndex;
}
//获取图片的存储区
-(AnsyImageData*)getAnsyImageDataBuf
{    
    return m_pAnsyImageData;
}

//获取图片的URL
-(NSString*)getImageUrl
{
    return m_strImgUrl;
}
@end
