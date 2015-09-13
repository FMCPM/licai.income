//
//  MoreActivityCenterPageView.m
//  更多 - 活动中心
//
//  Created by lzq on 2014-11-26.

//

#import "MoreActivityCenterPageView.h"
#import <QuartzCore/QuartzCore.h>
#import "UaConfiguration.h"
#import "UIOwnSkin.h"
#import "GlobalDefine.h"
#import "JsonXmlParserObj.h"
#import "AppInitDataMethod.h"
#import "WebViewController.h"

@interface MoreActivityCenterPageView ()

@end

@implementation MoreActivityCenterPageView

@synthesize m_uiMainTableView = _uiMainTableView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
       // m_iCurPageID = 0;
    }
    return self;
}


-(void)viewDidAppear:(BOOL)animated
{
}

//
- (void)viewDidLoad
{

    //标题
    self.navigationItem.titleView  = [UIOwnSkin navibarTitleView:@"活动中心" andFrame:CGRectMake(0, 0, 100, 40)];
    
    //导航返回按钮
    self.navigationItem.leftBarButtonItem = [UIOwnSkin backItemTarget:self action:@selector(backNavButtonAction:)];
    //
    m_pInfoDataSet = nil;
    m_muImageListDic = [[NSMutableDictionary alloc]initWithCapacity:0];

    m_iCurPageID = 0;
    m_isLoading = false;
    m_isToEndPage = false;
    
    _uiMainTableView = nil;
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    
   // [self getPromoMessageList_Web:0];
}

-(void)viewWillAppear:(BOOL)animated
{
    if(_uiMainTableView != nil)
        return;
    CGRect rcTable = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    _uiMainTableView = [[UITableView alloc]initWithFrame:rcTable style:UITableViewStylePlain];
    _uiMainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _uiMainTableView.separatorColor = [UIColor clearColor];
    _uiMainTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _uiMainTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _uiMainTableView.showsHorizontalScrollIndicator = NO;
    _uiMainTableView.showsVerticalScrollIndicator = NO;
    _uiMainTableView.backgroundColor = [UIColor whiteColor];
    _uiMainTableView.dataSource = self;
    _uiMainTableView.delegate = self;
    [self.view addSubview:_uiMainTableView];
    
    [self loadSysActivityInfoList_Web:0];
}

- (void)backNavButtonAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];    
}


//下载促销信息
-(void)loadSysActivityInfoList_Web:(NSInteger)iLoadFlag
{

    if(m_isLoading == true)
        return;
    
    if(iLoadFlag == 1)
    {
        m_pInfoDataSet = nil;
        m_iCurPageID = 0;
        [m_muImageListDic removeAllObjects];
    }

    CKHttpHelper*  pHttpHelper = [CKHttpHelper httpHelperWithOwner:self];
    pHttpHelper.m_iWebServerType = 1;
    pHttpHelper.methodType  = CKHttpMethodTypePost_Page;

    [pHttpHelper setMethodName:[NSString stringWithFormat:@"productInfo/queryActiveList"]];
    [pHttpHelper addParam:@"10" forName:@"pageB.rowCount"];
    m_iCurPageID++;
    [pHttpHelper addParam:[NSString stringWithFormat:@"%d",m_iCurPageID] forName:@"pageB.pageIndex"];
    
    [pHttpHelper setCompleteBlock:^(id dataSet)
    {
        [SVProgressHUD dismiss];
        m_isLoading = NO;
        m_isToEndPage = YES;
        JsonXmlParserObj* pJsonObj = dataSet;
        if(pJsonObj == nil)
        {
            return ;
        }
        
        QDataSetObj* pDataSet = [pJsonObj parseArrayList_Lev1:@"activeList"];
        if(pDataSet == nil)
        {
            return;
        }
        if([pDataSet getRowCount]>9)
        {
            m_isToEndPage  = NO;
        }
        if(m_pInfoDataSet == nil)
            m_pInfoDataSet = [[QDataSetObj alloc] init];
        CKHttpImageHelper* pImageHelper = [CKHttpImageHelper httpHelperWithOwner:self];
        int iAddRow = [m_pInfoDataSet getRowCount];
        for(int i=0;i<[pDataSet getRowCount];i++)
        {
            NSString* strActiveId = [pDataSet getFeildValue:i andColumn:@"activeId"];
            NSString* strActiveName = [pDataSet getFeildValue:i andColumn:@"activeName"];
            NSString* strContent = [pDataSet getFeildValue:i andColumn:@"content"];
            
            NSString* strCreateTime = [pDataSet getFeildValue:i andColumn:@"createTime"];
            
            NSString* strImgUrl =[pDataSet getFeildValue:i andColumn:@"titleImages"];
            
            [m_pInfoDataSet addDataSetRow_Ext:iAddRow andName:@"activeId" andValue:strActiveId];
            
            [m_pInfoDataSet addDataSetRow_Ext:iAddRow andName:@"activeName" andValue:strActiveName];
            
            [m_pInfoDataSet addDataSetRow_Ext:iAddRow andName:@"content" andValue:strContent];
            
            [m_pInfoDataSet addDataSetRow_Ext:iAddRow andName:@"createTime" andValue:strCreateTime];
            [m_pInfoDataSet addDataSetRow_Ext:iAddRow andName:@"imgUrl" andValue:strImgUrl];
            iAddRow++;
            if(strImgUrl.length < 1)
                continue;
            strImgUrl = [AppInitDataMethod getImageFullUrlPath:strImgUrl andImgFlag:3];
            NSURL *nsImageReqUrl = [NSURL URLWithString:strImgUrl];

            [pImageHelper addImageUrl:nsImageReqUrl forKey:[NSString stringWithFormat:@"%d",iAddRow]];
         
        }

        [_uiMainTableView reloadData];
        //
        [pImageHelper startWithReceiveBlock:^(UIImage *image,NSString *strKey,BOOL finsh)
         {
             
             if(image == nil || strKey == nil)
                 return ;
             
             [m_muImageListDic setObject:image forKey:strKey];
             
             int iKey = [QDataSetObj convertToInt:strKey];
             
             NSIndexPath* indexPath = [NSIndexPath indexPathForRow:iKey-1 inSection:0];
             UITableViewCell* pCellObj = [_uiMainTableView cellForRowAtIndexPath:indexPath];
             if(pCellObj)
             {
                 UIImageView* pImgView = (UIImageView*)[pCellObj.contentView viewWithTag:2001];
                 if(pImgView)
                     pImgView.image = image;
             }
             
         }];
       
        [_uiMainTableView reloadData];
        
    }];
    
    //开始时执行的block
    [pHttpHelper setStartBlock:^{
        [SVProgressHUD showWithStatus:HINT_WEBDATA_LOADING];
    }];
    m_isLoading = true;
    [pHttpHelper start];

}


//点击促销记录的相关处理（暂时不需要处理）
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* strActiveId = [m_pInfoDataSet getFeildValue:indexPath.row andColumn:@"activeId"];
    
    WebViewController* pWebView = [[WebViewController alloc] init];
    pWebView.m_strViewTitle = @"活动详情";
    pWebView.m_strWebUrl = [NSString stringWithFormat:@"%@/productInfo/queryOneActive.do?dataId=%@",[UaConfiguration sharedInstance].m_strSoapRequestUrl_1,strActiveId];
    pWebView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:pWebView animated:YES];
    

}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{


}


//每个section为200高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 180;
	
}

//返回section的数量
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(m_pInfoDataSet == nil)
        return 0;
    
    return 1;
}

//每个section为1行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
 

    if(m_pInfoDataSet == nil)
        return 0;
    
    return [m_pInfoDataSet getRowCount];
 
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{	
    static NSString *strActivityInfoCellID = @"ActivityInfoCellId";
    UITableViewCell *pCellObj = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:strActivityInfoCellID];
    if (!pCellObj)
    {
        pCellObj = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strActivityInfoCellID];
        pCellObj.contentView.backgroundColor =  [UIColor whiteColor];
        pCellObj.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImageView*pBkView = [[UIImageView alloc] initWithFrame:CGRectMake(10,10, 300, 170)];
        pBkView.backgroundColor = [UIColor whiteColor];
        pBkView.layer.borderWidth = 1.0f;
        pBkView.layer.borderColor = COLOR_BTN_BORDER_1.CGColor;
        pBkView.layer.cornerRadius = 5.0f;
        [pCellObj.contentView addSubview:pBkView];
        
        //促销的广告图
        UIImageView*pImageView = [[UIImageView alloc] initWithFrame:CGRectMake(3,3, 294, 122)];
        pImageView.tag = 2001;
       // pImageView.image = [UIImage imageNamed:@"activitytest.png"];
        [pBkView addSubview:pImageView];
        
        //促销信息
        UILabel*pLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 130, 280, 40)];
        pLabel.backgroundColor = [UIColor clearColor];
        pLabel.textColor = [UIColor darkGrayColor];
        pLabel.font = [UIFont systemFontOfSize:12];
        pLabel.numberOfLines = 0;
        pLabel.tag = 1001;
        //pLabel.text = @"测试的活动中心的消息";
        pLabel.textAlignment = UITextAlignmentLeft;
        [pBkView addSubview:pLabel];
        
    }
    if(indexPath.row >= [m_pInfoDataSet getRowCount])
        return pCellObj;
    
    UILabel* pLabel = (UILabel*)[pCellObj.contentView viewWithTag:1001];
    if(pLabel)
    {
        pLabel.text = [m_pInfoDataSet getFeildValue:indexPath.row andColumn:@"activeName"];
    }
    
    UIImageView* pLogoImgView = (UIImageView*)[pCellObj.contentView viewWithTag:2001];
    if(pLogoImgView == nil)
        return pCellObj;
    NSString* strImgUrl = [m_pInfoDataSet getFeildValue:indexPath.row andColumn:@"imgUrl"];
    if(strImgUrl.length > 0)
    {
        UIImage* pImage = [m_muImageListDic objectForKey:[NSString stringWithFormat:@"%d",indexPath.row+1]];
        if(pImage)
        {
            pLogoImgView.image = pImage;
        }
        else
        {
            pLogoImgView.image = [UIImage imageNamed:LOADING_IMAGE_NAME];
        }
    
    }
    else
    {
        pLogoImgView.image = [UIImage imageNamed:NO_IMAGE_NAME];
    }
    return pCellObj;

	
}

-(void)setImageViewFitImage:(UIImageView*)pImageView andImage:(UIImage*)image
{
   // NSLog(@"width=%f,height=%f",pImage .size.width,pImage.size.height);
    int iWidth = image.size.width*145/image.size.height;
    if(iWidth > 320)
        iWidth = 320;
    
    CGRect rcFrame = pImageView.frame;
    rcFrame.size.width = iWidth;
    rcFrame.origin.x = (320-iWidth)/2;
    
    pImageView.frame = rcFrame;
    pImageView.image = image;
}

@end
