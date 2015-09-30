//
//  Car_LoanRiskSafePageView.m
//
//  汽车贷款-产品详情-风险措施

//  Created by lzq on 2014-06-03.


#import "Car_LoanRiskSafePageView.h"
#import "UaConfiguration.h"
#import "UIOwnSkin.h"
#import "CKHttpHelper.h"
#import "GlobalDefine.h"
#import "CKHttpImageHelper.h"
#import "AppInitDataMethod.h"
#import "UILabel+CKKit.h"
#import "JsonXmlParserObj.h"

@interface Car_LoanRiskSafePageView ()

@end

@implementation Car_LoanRiskSafePageView

@synthesize m_uiMainTableView = _uiMainTableView;
@synthesize m_strProductId  = _strProductId;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{

	self.navigationController.navigationBar.translucent = NO;
	self.navigationController.navigationBarHidden = NO;

     _uiMainTableView = nil;
    m_strDiyaGoodsList = @"";
    m_strSafeDetailInfo = @"";
    m_muImageDict = [[NSMutableDictionary alloc] init];
    
    //设置导航条信息
    [self initNavigationItem];
    //显示初始化数据
    [super viewDidLoad];

    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self initTableView];
        
}

-(void)viewDidAppear:(BOOL)animated
{

}


//初始化视图
-(void)initTableView
{
    if(_uiMainTableView != nil)
        return;
    CGRect rcFrame = self.view.frame;
    rcFrame.origin.y = 0;
    _uiMainTableView = [[UITableView alloc]initWithFrame:rcFrame style:UITableViewStylePlain];
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
    
    [self downLoadLoanRishInfo_Web];
}

//导航条设置
-(void)initNavigationItem
{

    self.navigationController.navigationBar.translucent = NO;
    
    //标题
    self.navigationItem.titleView = [UIOwnSkin navibarTitleView:@"风险措施" andFrame:CGRectMake(0, 0, 100, 40)];
    //左边返回按钮
    self.navigationItem.leftBarButtonItem = [UIOwnSkin backItemTarget:self action:@selector(backNavButtonAction:)];
   
}

-(void)backNavButtonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}



//从服务端获取信息详情
-(void)downLoadLoanRishInfo_Web
{

 
    CKHttpHelper *pHttpHelper = [CKHttpHelper httpHelperWithOwner:self];
    pHttpHelper.m_iWebServerType = 1;
    pHttpHelper.methodType = CKHttpMethodTypePost_Page;
    //设置webservice方法名
    [pHttpHelper setMethodName:@"productInfo/queryRistDtl"];
     //sid
    [pHttpHelper addParam:_strProductId forName:@"productId"];
    //设置结束block（webservice方法结束后，会自动调用）
    [pHttpHelper setCompleteBlock:^(id dataSet)
     {
         [SVProgressHUD dismiss];
         JsonXmlParserObj* pJsonObj = dataSet;
         if(pJsonObj == nil)
         {
             [SVProgressHUD showErrorWithStatus:HINT_WEBDATA_NET_ERROR duration:1.8];
             return ;
         }
         QDataSetObj* pDataSet = [pJsonObj parsetoDataSet:@"data"];
         if(pDataSet == nil || [pDataSet getRowCount] < 1)
             return;
         m_strDiyaGoodsList = @"";
         NSString* strPawnGoods = [pDataSet getFeildValue:0 andColumn:@"pawnGoods"];
         if(strPawnGoods.length > 0)
         {
             NSArray* arGoodsList = [strPawnGoods componentsSeparatedByString:@"&&"];
             if(arGoodsList != nil)
             {
                 for(int i=0;i<arGoodsList.count;i++)
                 {
                     if(m_strDiyaGoodsList.length < 1)
                         m_strDiyaGoodsList = [arGoodsList objectAtIndex:i];
                     else
                     {
                         m_strDiyaGoodsList = [m_strDiyaGoodsList stringByAppendingFormat:@"\r\n%@",[arGoodsList objectAtIndex:i]];
                     }
                 }
             }
         }
         
         m_strSafeDetailInfo = [pDataSet getFeildValue:0 andColumn:@"riskDtl"];
         m_iSafeImageCount = 0;
         
         int iImageCount = [QDataSetObj convertToInt:[pDataSet getFeildValue:0 andColumn:@"images_count"]];
         if(iImageCount < 1)
         {
             [_uiMainTableView reloadData];
             return;
         }
         
         CKHttpImageHelper* pImageHelper = [CKHttpImageHelper httpHelperWithOwner:self];
         for(int i=0;i<iImageCount;i++)
         {
             NSString* strImgUrl = [pDataSet getFeildValue:0 andColumn:[NSString stringWithFormat:@"images_iamgeName_%d",i]];
             if(strImgUrl.length < 1)
                 continue;
             strImgUrl = [AppInitDataMethod getImageFullUrlPath:strImgUrl andImgFlag:0];
             NSURL *nsImageReqUrl = [NSURL URLWithString:strImgUrl];
             m_iSafeImageCount++;
             [pImageHelper addImageUrl:nsImageReqUrl forKey:[NSString stringWithFormat:@"%d",m_iSafeImageCount]];
         }
         

         [_uiMainTableView reloadData];
          //
         [pImageHelper startWithReceiveBlock:^(UIImage *image,NSString *strKey,BOOL finsh)
          {
          
              if(image == nil || strKey == nil)
                  return ;
              
              [m_muImageDict setObject:image forKey:strKey];
              
              int iKey = [QDataSetObj convertToInt:strKey];
              
              NSIndexPath* indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
              UITableViewCell* pCellObj = [_uiMainTableView cellForRowAtIndexPath:indexPath];
              if(pCellObj)
              {
                  UIImageView* pImgView = (UIImageView*)[pCellObj.contentView viewWithTag:2001+iKey];
                  if(pImgView)
                      pImgView.image = image;
              }

          
          }];
 

     }];
    [pHttpHelper setStartBlock:^{
        [SVProgressHUD showWithStatus:HINT_WEBDATA_LOADING ];
    }];
    //开始连接
    [pHttpHelper start];

}


//计算整个视图的高度
-(NSInteger)getTotalCellHeight
{
    //上面部分
    int iGoodsHeight = 0;
    if(m_strDiyaGoodsList.length > 0)
    {
        iGoodsHeight = [UILabel getFitTextHeightWithText:m_strDiyaGoodsList andWidth:280 andFont:[UIFont systemFontOfSize:14]];
    }
    if(iGoodsHeight > 0)
    {
        iGoodsHeight = iGoodsHeight + 40;
    }

    //下面部分
    int iSafeHeight = 40;
    if(m_strSafeDetailInfo.length > 0)
    {
        iSafeHeight = iSafeHeight+[UILabel getFitTextHeightWithText:m_strSafeDetailInfo andWidth:280 andFont:[UIFont systemFontOfSize:14]];
    }
    
    //图片部分
    int iImageCount = m_iSafeImageCount*180;

    int iTotalHeight = iGoodsHeight + iSafeHeight + iImageCount;
    
    return iTotalHeight;
    
}

#pragma mark -UITableView delegate and datasource


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int iCellHeight = [self getTotalCellHeight];
    iCellHeight+=20;
    return iCellHeight;
}

//
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(m_strSafeDetailInfo.length < 1 && m_strDiyaGoodsList.length < 1 && m_iSafeImageCount < 1)
        return 0;
    return 1;
}


//
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}


//加载cell
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    
    static NSString *strLoanSafeInfoCellID = @"LoanSafeInfoCellId";
    UITableViewCell *pCellObj = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:strLoanSafeInfoCellID];
    
    if (!pCellObj)
    {
        pCellObj = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strLoanSafeInfoCellID];
        pCellObj.contentView.backgroundColor = [UIColor whiteColor];
        pCellObj.selectionStyle = UITableViewCellSelectionStyleNone;
        
        int iCellHeight = [self getTotalCellHeight];
        UIView* pBkView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width-20, iCellHeight)];
        pBkView.backgroundColor = [UIColor whiteColor];
        pBkView.layer.borderWidth = 1.0f;
        pBkView.layer.borderColor = COLOR_CELL_LINE_DEFAULT.CGColor;
        pBkView.layer.cornerRadius = 5.0f;
        [pCellObj.contentView addSubview:pBkView];
        
        int iTopY = 0;
        //质押情况
        if(m_strDiyaGoodsList.length > 1)
        {
          
            UILabel* pLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 280, 20)];
            pLable.textAlignment = NSTextAlignmentLeft;
            pLable.backgroundColor = [UIColor clearColor];
            pLable.font = [UIFont systemFontOfSize:16];
            pLable.textColor = COLOR_FONT_6;
            pLable.text = @"质押情况";
            pLable.tag = 1001;
            [pBkView addSubview:pLable];
            
            
            //质押物
            int iHeight = [UILabel getFitTextHeightWithText:m_strDiyaGoodsList andWidth:280 andFont:[UIFont systemFontOfSize:14]]-8;
            //
            pLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 35, 280, iHeight)];
            pLable.backgroundColor = [UIColor clearColor];
            pLable.font = [UIFont systemFontOfSize:14];
            pLable.textColor = COLOR_FONT_2;
            pLable.numberOfLines = 0;
            pLable.text = m_strDiyaGoodsList;
            pLable.tag = 1002;
            [pBkView addSubview:pLable];
      
            iTopY = 35+iHeight+10;
            
            UIImageView* pLineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, iTopY, 280, 1)];
            pLineImageView.backgroundColor = COLOR_CELL_LINE_DEFAULT;
            pLineImageView.tag = 2001;
            [pBkView addSubview:pLineImageView];
        }
        
        iTopY+=10;
        //项目描述
        UILabel* pLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, iTopY, 100, 20)];
        pLabel.backgroundColor = [UIColor clearColor];
        pLabel.font = [UIFont systemFontOfSize:16];
        pLabel.textColor = COLOR_FONT_6;
        pLabel.text = @"风险措施";
        pLabel.tag = 1002;
        [pBkView addSubview:pLabel];
        
        iTopY +=25;

        if(m_strSafeDetailInfo.length > 1)
        {
            int iHeight = [UILabel getFitTextHeightWithText:m_strSafeDetailInfo andWidth:280 andFont:[UIFont systemFontOfSize:14]]-8;
            //
            pLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, iTopY, 280, iHeight)];
            pLabel.backgroundColor = [UIColor clearColor];
            pLabel.font = [UIFont systemFontOfSize:14];
            pLabel.textColor = COLOR_FONT_2;
            pLabel.numberOfLines = 0;
            pLabel.text = m_strSafeDetailInfo;
            pLabel.tag = 1003;
            [pBkView addSubview:pLabel];
            
            iTopY = iTopY+iHeight+10;
        }
        
        for(int i=0;i<m_iSafeImageCount;i++)
        {
            UIImageView*pImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, iTopY, 280, 170)];
            
            UIImage* pImage = [m_muImageDict objectForKey:[NSString stringWithFormat:@"%d",i+1]];
            if(pImage)
                pImageView.image = pImage;
            else
            {
                pImageView.image = [UIImage imageNamed:LOADING_IMAGE_NAME];
            }
            pImageView.tag = 2002+i;
            [pBkView addSubview:pImageView];
            iTopY+=180;
        }

        
        
    }
    return pCellObj;

}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{

   /*
    NSInteger iMaxRow = [self getIntrolGoodsSectionRowCount];
    if(m_strAdImageUrl.length < 10)
    {
        iMaxRow--;
    }
    
    if(indexPath.row == iMaxRow)
    {
        if(m_isToEndPage)
        {
            if(m_iCurPageId == 1)
                return;
            [SVProgressHUD showSuccessWithStatus:HINT_LASTEST_PAGE duration:1.8];
            return;
        }
        
   
        [self downLoadInfoList_Web];

    }
    */
}



@end
