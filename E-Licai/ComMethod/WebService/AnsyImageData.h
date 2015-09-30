//
//  AnsyImageData.h
//  ahdxyp
//
//  Created by ytinfo ytinfo on 12-6-15.
//  Copyright 2012年 ytinfo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnsyImageData : NSObject
{
    NSURLConnection*  m_netConnection;
    NSMutableData*    m_imgDataStream;
    BOOL              m_isFinished;
    //文件名称
    NSString*         m_strImageFileName;
    BOOL              m_blNeedSaveFile;
}

//从网络上下砸图片
- (NSInteger)loadImageFromURL:(NSString*)strUrl;
//判断是否已经下载完成
-(BOOL)isFinished;
//获取图片的数据流
-(NSMutableData*)getImageDataStream;
//设置image data stream;
-(void)setImageDataStream:(NSMutableData*)imageDataStream;
@end
