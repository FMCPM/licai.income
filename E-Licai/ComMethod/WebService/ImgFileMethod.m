/*------------------------------------------------------------------------
 Filename       : 	ImgFileMethod.h
 
 Description	:   一个自定义的文件操作方法类，主要用于图片数据的本地缓存，从而提高效率，减少不必要的网络流量
 
 Author         :   lzq,lvzhuqiang@ytinfo.zj.cn
 
 Date           :   2012-06-28
 
 version        :   v1.0
 
 Copyright      :   2012年 ytinfo. All rights reserved.
 
 ------------------------------------------------------------------------*/

#import "ImgFileMethod.h"

@implementation ImgFileMethod

@synthesize m_iImageType = _iImageType;

- (id)init
{
    self = [super init];
    if (self) {
        
        _iImageType = 0;
    }
    
    
    return self;
}

//判断本地是否存在图片文件，如果存在，则直接从本地读取
-(NSMutableData*)getImageDataFromLocal:(NSString*)strImgUrl
{
    NSString* strImgName = [ImgFileMethod getImgNameFormUrl:strImgUrl];
    if(strImgName.length < 2)
        return NULL;
        
    //存放缓存文件的目录
    NSString* strImgDirPath = [ImgFileMethod getAppDocumentImageDir];
    //获取文件名
    NSString*strImagePath = [strImgDirPath stringByAppendingPathComponent:strImgName];
    //判断文件是否存在
    if ([[NSFileManager defaultManager]fileExistsAtPath:strImagePath] == false)  
    {
        return NULL;
    }
    
    NSData *imgReaderData = [NSData dataWithContentsOfFile:strImagePath];    
    NSInteger iReadLen = [imgReaderData length];
    if(iReadLen < 10)
        return NULL;
    //内存在数据集里面释放
    NSMutableData* arMultData = [[NSMutableData alloc] initWithData:imgReaderData] ;    
    return arMultData;
    
}


+(UIImage*)getImageFormLocal:(NSString*)strImgUrl
{
    NSData *imgReaderData = [NSData dataWithContentsOfFile:strImgUrl];
    return [[UIImage alloc]initWithData:imgReaderData];
}

//从本地获取图片路径
+(NSString*)getLocalImagelUrlPath:(NSString*)strImageUrl
{
    NSLog(@"imgurl is %@",strImageUrl);
    NSString* strImgName = [ImgFileMethod getImgNameFormUrl:strImageUrl];
    
    if(strImgName.length < 1)
        return NULL;
    
    //存放缓存文件的目录
    NSString* strImgDirPath = [ImgFileMethod getAppDocumentImageDir];
    //获取文件名
    NSString*strLocalImageUrlPath = [strImgDirPath stringByAppendingPathComponent:strImgName];
    //判断文件是否存在
    if ([[NSFileManager defaultManager]fileExistsAtPath:strLocalImageUrlPath] == false)
    {
        return NULL;
        
    }
    
    return  strLocalImageUrlPath;
}

//从本地获取图片
-(NSString*)getLocalImagelUrlPath:(NSString*)strImageUrl;
{
    return [ImgFileMethod getLocalImagelUrlPath:strImageUrl];  
}
//根据文件的全局路径，获取文件名
+(NSString*)getImgNameFormUrl:(NSString*)strImgUrl
{
     
    NSArray* arChunks = [strImgUrl componentsSeparatedByString:@"/"];   
    int iCount = [arChunks count];
    
    NSString*strImgName = [arChunks objectAtIndex:iCount-1];
    
    NSLog(@"name is %@",strImgName);

    return strImgName;
    
        
}
//获取应用程序的Document目录
+(NSString*)getAppDocumentDir
{
    NSArray* arPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if(arPaths == NULL)
        return @"";
    NSString*strDirPath = [arPaths objectAtIndex:0];
    
    return strDirPath;

}

//获取应用程序沙盒中的tmp目录
+(NSString*)getAppTempDir
{
    NSString* strTempDir = NSTemporaryDirectory();
    return strTempDir;
}

//获取应用程序沙盒中的Document目录下存放缓存图片的目录
+(NSString*)getAppDocumentImageDir
{
    NSString* strDocumentDir = [ImgFileMethod getAppTempDir];
    NSString* strDocumentImgDir = [strDocumentDir stringByAppendingPathComponent:@"ImgCache"];
    NSFileManager* fileManager =[[NSFileManager alloc]init];
    if([fileManager fileExistsAtPath:strDocumentImgDir] == FALSE )
    {
        BOOL blResult = [fileManager createDirectoryAtPath:strDocumentImgDir withIntermediateDirectories:YES attributes:nil error:nil];
        if(blResult == FALSE)
            strDocumentImgDir = @"";

    }
    return strDocumentImgDir;
    
}


//将图片数据写到本地缓存区中
-(bool)writeImageDataToLocalCache:(NSMutableData*)pImageData andImageName:(NSString*)strImageName
{
    
    //存放缓存文件的目录
    NSString* strImgDirPath = [ImgFileMethod getAppDocumentImageDir];    

     
    NSString*strImagePathName = [strImgDirPath stringByAppendingPathComponent:strImageName];
//    NSLog(@"image name is %@",strImagePathName);
    //判断文件是否存在
    if ([[NSFileManager defaultManager]fileExistsAtPath:strImagePathName] == TRUE)
    {
        //删除文件
        [[NSFileManager defaultManager] removeItemAtPath:strImagePathName error:nil];  
    }
    
    [pImageData writeToFile:strImagePathName atomically:YES];

    return  TRUE;
}
     
//将新闻信息保存至于临时文件
-(NSString*)saveTempHtmlFileForNewsInfo:(NSString*)strNewsInfo
{
    //存放缓存文件的目录
    NSString* strTempDir = [ImgFileMethod getAppTempDir];
    
    NSString*strTempHtmlFileName = [strTempDir stringByAppendingPathComponent:@"newsinfo.html"];
    
    //判断文件是否存在
    if ([[NSFileManager defaultManager]fileExistsAtPath:strTempHtmlFileName] == TRUE)
    {
        //删除文件
        [[NSFileManager defaultManager] removeItemAtPath:strTempHtmlFileName error:nil];
    }

  //  NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8);
    NSData *nsHtmlData = [strNewsInfo dataUsingEncoding:enc];
    [nsHtmlData writeToFile: strTempHtmlFileName atomically: NO];
    return  strTempHtmlFileName;
}

+(void)deleteImgfileWithImgName:(NSString*)imgname
{
    NSString* strImgDirPath = [ImgFileMethod getAppDocumentImageDir];  
    NSString*strImagePathName = [strImgDirPath stringByAppendingPathComponent:imgname];
    //判断文件是否存在
    if ([[NSFileManager defaultManager]fileExistsAtPath:strImagePathName] == TRUE)  
    {
        //删除文件
        [[NSFileManager defaultManager] removeItemAtPath:strImagePathName error:nil];  
    }
}

//按比例压缩图片
-(UIImage*)zoomInImage:(UIImage*)pOraImage andSize:(CGSize)size;
{

    if(pOraImage.size.width < size.width)
        return pOraImage;
    
    // 创建一个bitmap的context,并把它设置成为当前正在使用的context

    UIGraphicsBeginImageContext(size);
        
    // 绘制改变大小的图片
    [pOraImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
        
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
        
    // 返回新的改变大小后的图片
    return scaledImage;

}

//默认情况下，都以jpeg的格式读取图片
-(NSData*)readJpegImageData:(UIImage*)pImage andMaxLen:(NSInteger)iMaxLen
{
    
    //
    NSData *szImageData  = UIImageJPEGRepresentation(pImage,1.0);
    if(szImageData == nil || szImageData.length < 1)
        return nil;
     _iImageType = 2;
    
    //转换成K为单位的长度
    int iTotalSize = szImageData.length / 1024;
    if(iTotalSize <= iMaxLen)
        return szImageData;
    
    //计算缩放比例
    float fZoomIn = (float)iMaxLen / (float)iTotalSize;
    if(fZoomIn < 0)
        return nil;
    
    while (true)
    {

        szImageData  = UIImageJPEGRepresentation(pImage,fZoomIn);
        iTotalSize = szImageData.length / 1024;
        if(iTotalSize <= iMaxLen)
            break;
        if(fZoomIn < 0.1)
        {
            return [self getImageDataBitesByZoomIn:pImage andMaxLen:iMaxLen];
        }
        fZoomIn = fZoomIn*0.9;
        
    }
    return szImageData;

}

//如果系统自带的方法不能将图片压缩至指定的大小，那么采用强制的方式进行压缩转换
-(NSData*)getImageDataBitesByZoomIn:(UIImage*)pImage andMaxLen:(NSInteger)iMaxLen
{
    _iImageType = 0;
    //modif by lzq at 2014-08-26:默认以jgep
    NSData* szImageData = UIImageJPEGRepresentation(pImage,1);
    if(szImageData != nil && szImageData.length > 1)
    {
        _iImageType = 2;
        
    }
    else
    {
        szImageData = UIImagePNGRepresentation(pImage);
        _iImageType = 1;
    }
    
    if(szImageData == nil)
    {
        _iImageType = 0;
        return nil;
    }
    //转换成K为单位的长度
    int iTotalSize = szImageData.length / 1024;
    if(iTotalSize < iMaxLen)
        return szImageData;
    
    //计算比例
    float fZoomIn = (float)MAX_USERHEADER_IMAGE_SIZE / (float)iTotalSize;
    if(fZoomIn == 0)
        return nil;
    
    fZoomIn  = sqrt(fZoomIn);
    
    UIImage* pZoomImage = pImage;
    while (true) {
        CGSize inSize = CGSizeMake(pImage.size.width,pImage.size.height);
        
        inSize.width = pZoomImage.size.width*fZoomIn;
        inSize.height = pZoomImage.size.height*fZoomIn;
        //按指定比例进行压缩
        pZoomImage = [self zoomInImage:pImage andSize:inSize];
        
        if(_iImageType == 1)
        {
            szImageData = UIImagePNGRepresentation(pZoomImage);
        }
        else
        {
            szImageData = UIImageJPEGRepresentation(pZoomImage,1);
        }
        iTotalSize = szImageData.length / 1024;
        if(iTotalSize < iMaxLen)
            return szImageData;
        if(fZoomIn < 0.1)
            break;
        fZoomIn = fZoomIn*0.9;
        
    }
    return nil;

}

//获取可以上传的图片的流
-(NSData*)getCanUploadImageData:(UIImage*)pImage
{
    //modif by lzq at 3014-08-24:默认为取jpeg
    NSData *szImageData  = [self readJpegImageData:pImage andMaxLen:MAX_IMAGE_SIZE];
    if(szImageData != nil)
        return szImageData;
    
    if(UIImagePNGRepresentation(pImage) == nil)
    {
        szImageData = UIImageJPEGRepresentation(pImage,1);
        _iImageType = 2;
    }
    else
    {
        szImageData = UIImagePNGRepresentation(pImage);
        _iImageType = 1;
    }
    if(szImageData == nil)
    {
        _iImageType = 0;
        return nil;
    }
    //转换成K为单位的长度
    int iTotalSize = szImageData.length / 1024;
    if(iTotalSize < MAX_IMAGE_SIZE)
        return szImageData;
    //计算缩放比例
    float fIn = (float)MAX_IMAGE_SIZE / (float)iTotalSize;
    if(fIn < 0)
        return nil;
    
    fIn = sqrtf(fIn);
    fIn = fIn*0.8;
    
    CGSize inSize = CGSizeMake(pImage.size.width,pImage.size.height);
    inSize.width = pImage.size.width*fIn;
    inSize.height = pImage.size.height*fIn;
    //按比例压缩
    UIImage* pInImage =[self zoomInImage:pImage andSize:inSize];
    if(_iImageType == 1)
    {
        szImageData = UIImagePNGRepresentation(pInImage);
    }
    else
    {
        szImageData = UIImageJPEGRepresentation(pInImage,1);
    }
    return szImageData;
}

//获取上传的头像的比特流
-(NSData*)getCanUploadUserHeaderImage:(UIImage*)pImage
{
    
    NSData *szImageData  = [self readJpegImageData:pImage andMaxLen:MAX_USERHEADER_IMAGE_SIZE];
    if(szImageData != nil)
    {
        return szImageData;
    }
    
    _iImageType = 0;
    //modif by lzq at 2014-08-26:默认以jgep
    szImageData = UIImageJPEGRepresentation(pImage,1);
    if(szImageData != nil && szImageData.length > 1)
    {
        _iImageType = 2;
        
    }
    else
    {
        szImageData = UIImagePNGRepresentation(pImage);
        _iImageType = 1;
    }
    
    if(szImageData == nil)
    {
        _iImageType = 0;
        return nil;
    }
    //转换成K为单位的长度
    int iTotalSize = szImageData.length / 1024;
    if(iTotalSize < MAX_USERHEADER_IMAGE_SIZE)
        return szImageData;
    
    //计算比例    
    float fIn = (float)MAX_USERHEADER_IMAGE_SIZE / (float)iTotalSize;
    if(fIn == 0)
        return nil;
    
    fIn  = sqrt(fIn);
    fIn = fIn*0.8;
    NSLog(@"ora width=%f,height=%f",pImage.size.width,pImage.size.height);
    CGSize inSize = CGSizeMake(pImage.size.width,pImage.size.height);
    
    inSize.width = pImage.size.width*fIn;
    inSize.height = pImage.size.height*fIn;
    
    NSLog(@"dst width=%f,height=%f",inSize.width,inSize.height);
    //按比例压缩
    UIImage* pInImage =[self zoomInImage:pImage andSize:inSize];
    if(_iImageType == 1)
    {
        szImageData = UIImagePNGRepresentation(pInImage);
    }
    else
    {
        szImageData = UIImageJPEGRepresentation(pInImage,1);
    }
    return szImageData;
}

//获取可以上传的店铺图片的比特流
-(NSData*)getCanUploadStoreImageBites:(UIImage*)pImage
{
    NSData *szImageData  = [self readJpegImageData:pImage andMaxLen:MAX_STORE_IMAGE_SIZE];
    if(szImageData != nil)
    {
        return szImageData;
    }
    //modif by lzq at 2014-08-26:默认以jgep
    szImageData = UIImageJPEGRepresentation(pImage,1);
    if(szImageData != nil && szImageData.length > 1)
    {
        _iImageType = 2;
        
    }
    else
    {
        szImageData = UIImagePNGRepresentation(pImage);
        _iImageType = 1;
    }
    
    if(szImageData == nil)
    {
        _iImageType = 0;
        return nil;
    }
    //转换成K为单位的长度
    int iTotalSize = szImageData.length / 1024;
    if(iTotalSize < MAX_STORE_IMAGE_SIZE)
        return szImageData;
    
    //实际的在正常的比例基础
    float fIn = (float)MAX_STORE_IMAGE_SIZE / (float)iTotalSize;
    if(fIn == 0)
        return nil;
  
    fIn  = sqrt(fIn);
    fIn = fIn*0.4;
    NSLog(@"ora width=%f,height=%f",pImage.size.width,pImage.size.height);
    CGSize inSize = CGSizeMake(pImage.size.width,pImage.size.height);
    
    inSize.width = pImage.size.width*fIn;
    inSize.height = pImage.size.height*fIn;
    
    NSLog(@"dst width=%f,height=%f",inSize.width,inSize.height);
    //按比例压缩
    UIImage* pInImage =[self zoomInImage:pImage andSize:inSize];
    if(_iImageType == 1)
    {
        szImageData = UIImagePNGRepresentation(pInImage);
    }
    else
    {
        szImageData = UIImageJPEGRepresentation(pInImage,1);
    }
    NSLog(@"store logo image data length=%dk",szImageData.length / 1024);
    return szImageData;
}

/*
-(NSData*)getCanUploadImageStoreData:(UIImage*)pImage
{
    _iImageType = 1;
    NSData *szImageData = UIImagePNGRepresentation(pImage);
    if(szImageData == nil)
    {
        szImageData = UIImageJPEGRepresentation(pImage,1);
        _iImageType = 2;
    }
    if(szImageData == nil)
    {
        _iImageType = 0;
        return nil;
    }
    //转换成K为单位的长度
    int iTotalSize = szImageData.length / 1024;
    if(iTotalSize < MAX_STORE_IMAGE_SIZE)
        return szImageData;
    //市场的在正常的比例基础上缩小10%
    float fIn = (float)MAX_STORE_IMAGE_SIZE / (float)iTotalSize - 0.1;
    if(fIn < 0)
        return nil;
    
    CGSize inSize = CGSizeMake(pImage.size.width,pImage.size.height);
    
    inSize.width = pImage.size.width*fIn;
    inSize.height = pImage.size.height*fIn;
    //按比例压缩
    UIImage* pInImage =[self zoomInImage:pImage andSize:inSize];
    if(_iImageType == 1)
    {
        szImageData = UIImagePNGRepresentation(pInImage);
    }
    else
    {
        szImageData = UIImageJPEGRepresentation(pInImage,1);
    }
    iTotalSize = szImageData.length / 1024;
    NSLog(@"Store  image size=%dk",iTotalSize);
  
    return szImageData;
}
*/

@end
