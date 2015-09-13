//
//  Car_LoanEnterInfoPageView.m
//
//  汽车贷款-产品详情-贷款企业详情页面

//  Created by lzq on 2014-06-03.


#import "Car_LoanEnterInfoPageView.h"
#import "UaConfiguration.h"
#import "UIOwnSkin.h"
#import "CKHttpHelper.h"
#import "GlobalDefine.h"
#import "CKHttpImageHelper.h"
#import "AppInitDataMethod.h"
#import "UILabel+CKKit.h"
#import "JsonXmlParserObj.h"

@interface Car_LoanEnterInfoPageView ()

@end

@implementation Car_LoanEnterInfoPageView

@synthesize m_uiMainTableView = _uiMainTableView;
@synthesize m_strProductId = _strProductId;
@synthesize m_strLoanEnterMemo = _strLoanEnterMemo;

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

    m_muImageDict = [[NSMutableDictionary alloc] init];
    m_iSafeImageCount = 0;
    m_pInfoDataSet = nil;
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
    
    [self downLoadEnterDetailInfo_Web];
}

//导航条设置
-(void)initNavigationItem
{
    
    self.navigationController.navigationBar.translucent = NO;
    
    //标题
    self.navigationItem.titleView = [UIOwnSkin navibarTitleView:@"企业详情" andFrame:CGRectMake(0, 0, 100, 40)];
    //左边返回按钮
    self.navigationItem.leftBarButtonItem = [UIOwnSkin backItemTarget:self action:@selector(backNavButtonAction:)];
    
}

-(void)backNavButtonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}



//从服务端获取信息详情
-(void)downLoadEnterDetailInfo_Web
{
    
    
    CKHttpHelper *pHttpHelper = [CKHttpHelper httpHelperWithOwner:self];
    pHttpHelper.m_iWebServerType = 1;
    pHttpHelper.methodType = CKHttpMethodTypePost_Page;
    //设置webservice方法名
    [pHttpHelper setMethodName:@"productInfo/queryCompanyDtl"];
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
         m_pInfoDataSet = pDataSet;
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
              
              NSIndexPath* indexPath = [NSIndexPath indexPathForRow:iKey+3 inSection:0];
              UITableViewCell* pCellObj = [_uiMainTableView cellForRowAtIndexPath:indexPath];
              if(pCellObj)
              {
                  UIImageView* pImgView = (UIImageView*)[pCellObj.contentView viewWithTag:2001];
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


#pragma mark -UITableView delegate and datasource


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.row < 2)
        return 44;
    if(indexPath.row < 4)
    {
        NSString* strMemo = @"";
        if(indexPath.row == 2)
            strMemo = [m_pInfoDataSet getFeildValue:0 andColumn:@"companyBasicInfo"];
        else
            strMemo = [m_pInfoDataSet getFeildValue:0 andColumn:@"mainBusInfo"];
        
        strMemo = [NSString stringWithFormat:@"     %@",strMemo];
        int iHeight = [UILabel getFitTextHeightWithText:strMemo andWidth:300 andFont:[UIFont systemFontOfSize:12]];
        
        int iCellHeight = iHeight + 30;
        return iCellHeight;
    }
    
    return 180;
 

}

//
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    if(m_pInfoDataSet == nil)
        return 0;
    return 1;
}


//
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(m_pInfoDataSet == nil)
        return 0;
    
    int iRowsCount = 4+m_iSafeImageCount;
    
    return iRowsCount;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

//
-(UITableViewCell*)getEnterComLabelTableCell:(UITableView*)tableView andIndexPath:(NSIndexPath*)indexPath
{
    
    static NSString *strEnterComLabelCellId = @"EnterComLabelCellId";
    UITableViewCell *pCellObj = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:strEnterComLabelCellId];
    
    if (!pCellObj)
    {
        pCellObj = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strEnterComLabelCellId];
        pCellObj.contentView.backgroundColor = [UIColor whiteColor];
        pCellObj.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel* pLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 12, 70, 20)];
        pLable.textAlignment = NSTextAlignmentLeft;
        pLable.backgroundColor = [UIColor clearColor];
        pLable.font = [UIFont systemFontOfSize:14];
        pLable.textColor = COLOR_FONT_2;
         //
        pLable.tag = 1001;
        [pCellObj.contentView addSubview:pLable];
        
        pLable = [[UILabel alloc] initWithFrame:CGRectMake(80, 12, 230, 20)];
        pLable.textAlignment = NSTextAlignmentLeft;
        pLable.backgroundColor = [UIColor clearColor];
        pLable.font = [UIFont systemFontOfSize:14];
        pLable.textColor = COLOR_FONT_1;
        
        pLable.tag = 1002;
        [pCellObj.contentView addSubview:pLable];
        
    }
    UILabel* pLabel1 = (UILabel*)[pCellObj.contentView viewWithTag:1001];
    UILabel* pLabel2 = (UILabel*)[pCellObj.contentView viewWithTag:1002];
    
    if(pLabel1 == nil || pLabel2 == nil)
    {
        return pCellObj;
    }
    
    if(indexPath.row == 0)
    {
        pLabel1.text = @"经营年份：";
        pLabel2.text = [m_pInfoDataSet getFeildValue:0 andColumn:@"yearOperator"];
    }
    else if(indexPath.row == 1)
    {
        pLabel1.text = @"涉诉情况：";
        pLabel2.text = [m_pInfoDataSet getFeildValue:0 andColumn:@"litigationInfo"];
    }
    
    //
    
    return pCellObj;
}


-(UITableViewCell*)getEnterMemoLabelTableCell:(UITableView*)tableView andIndexPath:(NSIndexPath*)indexPath
{
    
    static NSString *strEnterMemoLabelTableCellId = @"EnterMemoLabelTableCell";
    UITableViewCell *pCellObj = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:strEnterMemoLabelTableCellId];
    
    if (!pCellObj)
    {
        pCellObj = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strEnterMemoLabelTableCellId];
        pCellObj.contentView.backgroundColor = [UIColor whiteColor];
        pCellObj.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel* pLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 200, 20)];
        pLable.textAlignment = NSTextAlignmentLeft;
        pLable.backgroundColor = [UIColor clearColor];
        pLable.font = [UIFont systemFontOfSize:14];
        pLable.textColor = COLOR_FONT_2;
        //
        pLable.tag = 1001;
        [pCellObj.contentView addSubview:pLable];
        
        
        pLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, 300, 20)];
        pLable.textAlignment = NSTextAlignmentLeft;
        pLable.backgroundColor = [UIColor clearColor];
        pLable.font = [UIFont systemFontOfSize:12];
        pLable.textColor = COLOR_FONT_1;
        pLable.numberOfLines = 0;
        pLable.tag = 1002;
        [pCellObj.contentView addSubview:pLable];
        
    }
    UILabel* pLabel1 = (UILabel*)[pCellObj.contentView viewWithTag:1001];
    UILabel* pLabel2 = (UILabel*)[pCellObj.contentView viewWithTag:1002];
    
    if(pLabel1 == nil || pLabel2 == nil)
    {
        return pCellObj;
    }
    
    
    if(indexPath.row == 2)
    {
        pLabel1.text = @"基本情况：";
        
         NSString* strBasicInfo = @"     ";
        strBasicInfo = [strBasicInfo stringByAppendingString:[m_pInfoDataSet getFeildValue:0 andColumn:@"companyBasicInfo"]];

        int iHeight = [UILabel getFitTextHeightWithText:strBasicInfo andWidth:300 andFont:[UIFont systemFontOfSize:12]];
        CGRect rcLabel = pLabel2.frame;
        rcLabel.size.height = iHeight;
        pLabel2.frame = rcLabel;
        pLabel2.text = strBasicInfo;
    }
    else if(indexPath.row == 3)
    {
        pLabel1.text = @"主营产品情况：";
        
        NSString* strMainProInfo = @"       ";
        strMainProInfo = [strMainProInfo stringByAppendingString:[m_pInfoDataSet getFeildValue:0 andColumn:@"mainBusInfo"]];
        int iHeight = [UILabel getFitTextHeightWithText:strMainProInfo andWidth:300 andFont:[UIFont systemFontOfSize:12]];
        CGRect rcLabel = pLabel2.frame;
        rcLabel.size.height = iHeight;
        pLabel2.frame = rcLabel;
        pLabel2.text = strMainProInfo;
    }
    
    
    return pCellObj;
}


-(UITableViewCell*)getEnterImageTableCell:(UITableView*)tableView andIndexPath:(NSIndexPath*)indexPath
{
    
    static NSString *strEnterImageTableCellId = @"EnterImageTableCellId";
    UITableViewCell *pCellObj = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:strEnterImageTableCellId];
    
    if (!pCellObj)
    {
        pCellObj = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strEnterImageTableCellId];
        pCellObj.contentView.backgroundColor = [UIColor whiteColor];
        pCellObj.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImageView* pImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 300, 170)];
        pImageView.tag = 2001;
        [pCellObj.contentView addSubview:pImageView];
        
        
    }
    UIImageView* pImageView = (UIImageView*)[pCellObj.contentView viewWithTag:2001];
    if(pImageView)
    {
        UIImage* pImage = [m_muImageDict objectForKey:[NSString stringWithFormat:@"%d",indexPath.row-3]];
        if(pImage)
        {
            pImageView.image = pImage;
        }
        else
        {
            pImageView.image = [UIImage imageNamed:LOADING_IMAGE_NAME];
        }
    }
    
    return pCellObj;
}

//加载cell
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell* pCellObj = nil;
    if(indexPath.row < 2)
    {
        pCellObj = [self getEnterComLabelTableCell:tableView andIndexPath:indexPath];
    }
    else if(indexPath.row < 4)
    {
        pCellObj = [self getEnterMemoLabelTableCell:tableView andIndexPath:indexPath];
    }
    else
        pCellObj = [self getEnterImageTableCell:tableView andIndexPath:indexPath];
    return pCellObj;
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


@end
