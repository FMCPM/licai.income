//
//  GoodsBatchEditTableCell.m

//
//  Created by lzq on 2014-05-20.
//


#import "GoodsMultLineImageCell.h"
#import "GlobalDefine.h"

@implementation GoodsMultLineImageCell

@synthesize m_pCellDelegate = _pCellDelegate;
@synthesize m_uiAddImageBtn = _uiAddImageBtn;
@synthesize m_uiSuperParentView = _uiSuperParentView;


-(id)initWithFrame:(CGRect)frame andType:(NSInteger)iFilterType
{

    self = [super initWithFrame:frame];
    if (self)
    {

        
    }
    return self;
}
-(id)initWithFrame:(CGRect)frame andCellId:(NSInteger)iCellId
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        if(iCellId == 0)
            self.backgroundColor = COLOR_VIEW_BACKGROUND;
        else
            self.backgroundColor = [UIColor whiteColor];
        m_dictImgIdUrlList = [[NSMutableDictionary alloc] init];
        _uiAddImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _uiAddImageBtn.frame = CGRectMake(8, 5, 70, 70);
        [_uiAddImageBtn addTarget:self action:@selector(actionAddOneImageCliked:) forControlEvents:UIControlEventTouchUpInside];
        [_uiAddImageBtn setImage:[UIImage imageNamed:@"uploadpic.png"] forState:UIControlStateNormal];
        [self addSubview:_uiAddImageBtn];
        m_arPicIDList = nil;
        m_arPicObjList = nil;
        m_arButtonList = nil;
        m_iCellHeight = 80;
        m_iCellId = iCellId;
    }
    return self;
}

//启动添加图片的流程
-(void)actionAddOneImageCliked:(id)sender
{
    if(_pCellDelegate == nil)
        return;
    if([_pCellDelegate respondsToSelector:@selector(onActionAddOneGoodsImage:)] == false)
        return;
    [_pCellDelegate onActionAddOneGoodsImage:m_iCellId];
}


//启动上传商品图片的流程
-(void)AddOneGoodsImage:(UIImage*)pImage andId:(NSInteger)iImageId andFlag:(bool)blRefreshFlag
{
    if(pImage == nil)
        return;
    
    if(m_arPicIDList == nil)
    {
        m_arPicIDList = [[NSMutableArray alloc] init];
    }
    if(m_arPicObjList == nil)
    {
        m_arPicObjList = [[NSMutableArray alloc] init];
    }
    if(m_arButtonList == nil)
    {
        m_arButtonList = [[NSMutableArray alloc] init];
    }
    [m_arPicIDList addObject:[NSString stringWithFormat:@"%d",iImageId]];
    [m_arPicObjList addObject:pImage];
    [self addOneImageView:pImage  andIndex:m_arButtonList.count];
    if(blRefreshFlag == false)
        return;
    [self refreshImagesShow];
    [self statCellViewHeight ];
}

//刷新显示
-(void)refreshImagesShow
{
    for(int i=0;i<m_arPicIDList.count;i++)
    {
        CGRect rcBtnFrame = [self getButtonRectByIndex:i];
        UIView*pContaintView = [m_arButtonList objectAtIndex:i];
        if(pContaintView == nil)
            continue;
        pContaintView.frame  =rcBtnFrame;
    }
    CGRect rcUpload =  [self getButtonRectByIndex:m_arPicIDList.count];
    _uiAddImageBtn.frame = rcUpload;
    
}


//获取指定位置的按钮的位置(从0开始编号)
-(CGRect)getButtonRectByIndex:(NSInteger)iBtnIndex
{
    int iTopY = 0;
    int iLeftX = 0;
    
    iBtnIndex++;
    int iBarRow = iBtnIndex/4;
    if(iBtnIndex % 4 != 0)
        iBarRow++;
    
    iTopY   = (iBarRow-1)*75+5;
    iLeftX  = (iBtnIndex-1)%4 * 78 + 8;
    
    CGRect rcBtnFrame = CGRectMake(iLeftX, iTopY, 70, 70);
    return rcBtnFrame;
}


//在指定区域添加一个图片
-(void)addOneImageView:(UIImage*)pImage andIndex:(NSInteger)iBtnIndex
{
    
    CGRect rcBtnFrame  = [self getButtonRectByIndex:iBtnIndex];
    rcBtnFrame.origin.y =  rcBtnFrame.origin.y-10;
    rcBtnFrame.size.width = rcBtnFrame.size.width+8;
    rcBtnFrame.size.height = rcBtnFrame.size.height+10;
    
    UIView*pContaintView = [[UIView alloc] initWithFrame:rcBtnFrame];
    pContaintView.tag = 1000+iBtnIndex+1;

    
    rcBtnFrame.origin.y = 0;
    rcBtnFrame.origin.x = 0;
    rcBtnFrame.size.width = rcBtnFrame.size.width-8;
    rcBtnFrame.size.height = rcBtnFrame.size.height-10;
    UIImageView *pImageView = [[UIImageView alloc] initWithFrame:rcBtnFrame];
    pImageView.image = pImage;
    pImageView.layer.borderWidth = 1.0f;
    pImageView.layer.borderColor = COLOR_CELL_LINE_DEFAULT.CGColor;
    [pImageView.layer setMasksToBounds:YES];
    pImageView.layer.cornerRadius = 4.0f;
    pImageView.tag = 100+iBtnIndex+1;
    [pContaintView addSubview:pImageView];
    
    //删除按钮
    UIButton* pDeleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    pDeleteBtn.frame = rcBtnFrame;
    [pDeleteBtn addTarget:self action:@selector(onDeleteUploadPicClicked:) forControlEvents:UIControlEventTouchUpInside];
    pDeleteBtn.tag = 200 + iBtnIndex+1;
    [pContaintView addSubview:pDeleteBtn];
    
    //删除提示视图
    UIImageView*pDelHintImgView = [[UIImageView alloc] initWithFrame:CGRectMake(rcBtnFrame.origin.x+60, rcBtnFrame.origin.y-3, 15, 15)];
    pDelHintImgView.image = [UIImage imageNamed:@"cell_delete_2.png"] ;
    pDelHintImgView.tag = 300+iBtnIndex+1;
    [pContaintView addSubview:pDelHintImgView];
    [self addSubview:pContaintView];
    
    [m_arButtonList addObject:pContaintView];
}

//删除一个图片
-(void)onDeleteUploadPicClicked:(id)sender
{
    UIButton* pButton = (UIButton*)sender;
    if(pButton == nil)
        return;
    int iIndex = pButton.tag - 200 -1;
    if(iIndex<0 || iIndex>=m_arPicIDList.count)
        return;
    
    for(int i=iIndex+1;i<m_arButtonList.count;i++)
    {
        UIView*pView = [m_arButtonList objectAtIndex:i];
        if(pView == nil)
            continue;
        pView.tag  = 1000+i;
        UIImageView* pImageView = (UIImageView*)[pView viewWithTag:100+i+1];
        if(pImageView)
            pImageView.tag = 100+i;
        UIButton* pDelButton = (UIButton*)[pView viewWithTag:200+i+1];
        if(pDelButton)
            pDelButton.tag = 200+i;
        UIImageView* pHintView = (UIImageView*)[pView viewWithTag:300+i+1];
        if(pHintView)
            pHintView.tag = 300+i;
    }
    
    UIView* pDelView = [m_arButtonList objectAtIndex:iIndex];
    [pDelView removeFromSuperview];
    [m_arButtonList removeObjectAtIndex:iIndex];
    NSString* strPicId = [m_arPicIDList objectAtIndex:iIndex];
    [m_arPicIDList removeObjectAtIndex:iIndex];
    [m_arPicObjList removeObjectAtIndex:iIndex];
    //删除图片
    [m_dictImgIdUrlList removeObjectForKey:strPicId];
    
    [self refreshImagesShow];
    [self statCellViewHeight ];
}

//统计cell的高度
-(void)statCellViewHeight
{
    int iSuccCount = m_arPicIDList.count+1;
    int iBarHeight = 80;
    
    int iRowCount = iSuccCount/4;
    if(iSuccCount % 4 != 0)
        iRowCount++;
    iBarHeight = iRowCount*75+5;
    if(iBarHeight == m_iCellHeight)
        return;
    m_iCellHeight = iBarHeight;

    if(_pCellDelegate == nil)
        return;
    if([_pCellDelegate respondsToSelector:@selector(onNeedRefreshTableViewCell:)] == false)
        return;
    [_pCellDelegate onNeedRefreshTableViewCell:0];
    
}
-(NSInteger)getCellViewHeight
{
    return m_iCellHeight;
}

//收到图片后，显示该图片
-(void)setImageShow:(UIImage*)pImage andIndex:(NSInteger)iIndex
{
    if(iIndex < 0 || iIndex>=m_arButtonList.count)
        return;
    UIView*pView = [m_arButtonList objectAtIndex:iIndex];
    if(pView == nil)
        return;
    UIImageView*pImageView = (UIImageView*)[pView viewWithTag:100+iIndex+1];
    if(pImageView)
        pImageView.image=pImage;
}

//获取需要上传的图片的索引
-(NSInteger)getNeedUploadPicture
{
    if(m_arPicIDList.count < 1)
        return -1;
    for(int i=0;i<m_arPicIDList.count;i++)
    {
        NSString* strPicID = [m_arPicIDList objectAtIndex:i];
        int iPicId = [QDataSetObj convertToInt:strPicID];
        if(iPicId == 0)
        {
            //先设置为-1，表示正在上传，避免上传失败后，重复的上传
            [m_arPicIDList setObject:@"-1" atIndexedSubscript:i];
            return i;
        }
    }
    return -1;
 
}

//获取指定所以的图片
-(UIImage*)getImageByIndex:(NSInteger)iIndex
{
    if(iIndex <0 || iIndex>= m_arPicObjList.count)
        return nil;
    UIImage*pImage = [m_arPicObjList objectAtIndex:iIndex];
    return pImage;
}

-(bool)setImageIdByIndex:(NSInteger)iIndex andId:(NSInteger)iImageId andUrl:(NSString*)strImageUrl
{
    if(iIndex <0 || iIndex>= m_arPicObjList.count)
        return false;
    [m_arPicIDList setObject:[NSString stringWithFormat:@"%d",iImageId] atIndexedSubscript:iIndex];
    
    //添加图片
    [m_dictImgIdUrlList setObject:strImageUrl forKey:[NSString stringWithFormat:@"%d",iImageId]];
    return true;
}

-(NSInteger)getTotalImageCount
{
    if(m_arPicObjList == nil)
        return 0;
    return m_arPicObjList.count;
}

-(NSString*)getImageIdsList
{
    if(m_arPicIDList == nil)
        return @"";
    NSString* strPicIds = @"";
    for(int i=0;i<m_arPicIDList.count;i++)
    {
        NSString* strTemp = [m_arPicIDList objectAtIndex:i];
        int iId = [QDataSetObj convertToInt:strTemp];
        if(iId < 1)
            continue;
        if(strPicIds.length == 0)
            strPicIds = strTemp;
        else
            strPicIds = [strPicIds stringByAppendingFormat:@",%@",strTemp];
    }
    return strPicIds;
}

//获取可以直接在html页面显示的商品描述信息
-(NSString*)getGoodsMemoHtmlText:(NSString*)strGoodsMemo
{
    NSString* strHtmlText = [NSString stringWithFormat:@"<p>%@</p>",strGoodsMemo];
    
    NSArray* allKeys = [m_dictImgIdUrlList allKeys];
    for (NSString *strKey in allKeys)
    {
        NSString *strValue = [m_dictImgIdUrlList objectForKey:strKey];
        if(strValue == nil)
            continue;
        if(strValue.length < 1)
            continue;
        strHtmlText = [strHtmlText stringByAppendingFormat:@"<div><img src=\"%@\"></div>",strValue];
    }
    return strHtmlText;
}


@end
