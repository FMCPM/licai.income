//
//  MoreMessageDetailPageView.h

//  更多 - 消息中心 - 消息详情
//
//  Created by lzq  on 2014-11-26.
//

#import "MoreMessageDetailPageView.h"
#import "UaConfiguration.h"
#import "UIOwnSkin.h"
#import "UILabel+CKKit.h"

@interface MoreMessageDetailPageView ()

@end

@implementation MoreMessageDetailPageView

@synthesize m_uiMainTableView = _uiMainTableView;
;
@synthesize m_strMessageId = _strMessageId;
@synthesize m_strMessageContent = _strMessageContent;
@synthesize m_strMessageTitle = _strMessageTitle;
@synthesize m_strMessageSendDate = _strMessageSendDate;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}


- (void)viewDidLoad
{
  
    self.navigationController.navigationBar.translucent = NO;
    
    //标题
    self.navigationItem.titleView = [UIOwnSkin navibarTitleView:@"阅读消息" andFrame:CGRectMake(0, 0, 100, 40)];
    
    //左边返回按钮
    self.navigationItem.leftBarButtonItem = [UIOwnSkin backItemTarget:self action:@selector(backNavButtonAction:)];
    _uiMainTableView = nil;
    
    self.view.backgroundColor = [UIColor whiteColor];
 
    [super viewDidLoad];
    
}

//
-(void)backNavButtonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewWillAppear:(BOOL)animated
{
    
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

}


-(void)viewDidAppear:(BOOL)animated
{

}



//重新加载产品信息
-(void)loadTradeLogInfo_Web:(NSInteger)iLoadFlag
{
    
    
    /*
    if(m_isLoading == true)
        return;
    if(iLoadFlag == 1)//重新加载
    {
        
        //追加数据就不需要判断
        if(m_pImgHelper != nil)
        {
            int iLeftCount = [m_pImgHelper getLeftCount ];
            if(iLeftCount > 0)
            {
                [m_pImgHelper cancel];
                m_pImgHelper = nil ;
            }
        }
        m_iCurPageID = 0;
        
        if([m_pGoodsOrStoreDataSet getRowCount] > 0)
        {
            m_pGoodsOrStoreDataSet = nil;
            m_pGoodsOrStoreDataSet = [[QDataSetObj alloc] init];
        }
        [m_muImageListDic removeAllObjects];
    }
    
    if(m_pHttpHelper == nil)
    {
        m_pHttpHelper = [CKHttpHelper httpHelperWithOwner:self];
        m_pHttpHelper.m_iWebServerType = 1;
        m_pHttpHelper.methodType  = CKHttpMethodTypePost_Page;
    }
    
    [m_pHttpHelper clearParams];
    //专业市场的id
    [m_pHttpHelper setMethodName:[NSString stringWithFormat:@"page.getShopList"]];
    [m_pHttpHelper addParam:[UaConfiguration sharedInstance].m_setLoginState.m_strOwnerId forName:@"areaId"];
    [m_pHttpHelper addParam:[UaConfiguration sharedInstance].m_setLoginState.m_strUserLoginSid forName:@"sid"];
    
    m_iCurPageID++;
    [m_pHttpHelper addParam:[NSString stringWithFormat:@"%d",m_iCurPageID] forName:@"page"];
    
    
    //keyWord：关键字（可以为空
    if(m_pUISearchBar)
        _strKeyword  =[m_pUISearchBar getKeywordText];
    [m_pHttpHelper addParam:_strKeyword forName:@"keyword"];
    [self saveHistoryLog:_strKeyword];
    
    //orderFlag:排序类型,0_无; 2_人气;3_新品；4_信用;
    [m_pHttpHelper addParam:[NSString stringWithFormat:@"%d",_iOrderFlag] forName:@"orderFlag"];
    //正倒序,0_无;1_正序；2_倒序；
    [m_pHttpHelper addParam:@"0" forName:@"orderType"];

    
    //卖家类型,0_无;2_品牌联盟;
    [m_pHttpHelper addParam:[NSString stringWithFormat:@"%@",_strQSellerType] forName:@"sellerType"];
    
    __block SearchGoodsOrStorePageView *blockSelf = self;
    [m_pHttpHelper setCompleteBlock:^(id dataSet)
     {
         
         [SVProgressHUD dismiss];
         blockSelf->m_isLoading = false;
         if(dataSet)
         {
             
             NSInteger iRowCount = [dataSet getRowCount];
             if(iRowCount < 10)
             {
                 blockSelf->m_isToEndPage = true;
             }
             if(iRowCount == 0)
             {
                [blockSelf->_uiGoodsOrStoreTableView reloadData];
                 if([blockSelf->m_pGoodsOrStoreDataSet getRowCount] < 1)
                 {
                    // [SVProgressHUD showSuccessWithStatus:@"没有符合条件的商品信息！" duration:1.8];
                     [blockSelf showNoQueryResultHintView:2];
                     
                 }
                 return ;
             }
             SetRowObj *pQDataRow = nil;
             
             if(blockSelf->m_pImgHelper == nil)
             {
                 blockSelf->m_pImgHelper = [CKHttpImageHelper httpHelperWithOwner:blockSelf];
             }
             
             for (int i=0; i<iRowCount; i++)
             {
                 pQDataRow = [dataSet getRowObj:i];
                 if(!pQDataRow)
                     continue;
                 [blockSelf->m_pGoodsOrStoreDataSet addDataSetRow:pQDataRow];
                 
                 NSString *strImageUrl = [pQDataRow getFieldValue:@"imgUrl"];
                 if(strImageUrl.length < 1)
                     continue;
                 strImageUrl =   [strImageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                 NSURL *nsImageReqUrl = [NSURL URLWithString:strImageUrl];
                 if(nsImageReqUrl)
                 {
                     NSString *strKey = [NSString stringWithFormat:@"%d",blockSelf->m_pGoodsOrStoreDataSet.getRowCount-1];
                     [blockSelf->m_pImgHelper addImageUrl:nsImageReqUrl forKey:strKey];
                 }
             }
             //重新加载tableview
             blockSelf->_uiGoodsOrStoreTableView.tableFooterView = nil;

             //
             [blockSelf->m_pImgHelper startWithReceiveBlock:^(UIImage *image,NSString *key,BOOL finsh)
              {
                  NSIndexPath *nsPath  = [NSIndexPath indexPathForRow:key.intValue inSection:0];
                  UITableViewCell*pCellObj    = (UITableViewCell*)[blockSelf->_uiGoodsOrStoreTableView cellForRowAtIndexPath:nsPath];
                  
                  if (image)
                  {
                      if(key == nil)
                      {
                          NSLog(@"key is null");
                      }
                      [blockSelf->m_muImageListDic setObject:image forKey:key];
                      
                      UIImageView* pLogoView = (UIImageView*)[pCellObj.contentView viewWithTag:1001];
                      if(pLogoView)
                          pLogoView.image = image;
                  }
                  
                  if(finsh == true)
                  {
                      NSLog(@"down load image end");
                  }
              }
              ];
         }
         else
         {
             blockSelf->m_isToEndPage = false;
             //[SVProgressHUD showErrorWithStatus:HINT_WEBDATA_NET_ERROR duration:1.8];
         }
        [blockSelf->_uiGoodsOrStoreTableView reloadData];
     }];
    
    [m_pHttpHelper setStartBlock:^{
        [SVProgressHUD showWithStatus:@"正在加载，请稍后..."];
    }];
    
    m_isLoading = true;
    [m_pHttpHelper start];
    */
    
}


#pragma UITableViewDataSource,UITableViewDelegate

//didSelectRowAtIndexPath
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{

}


//
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(_strMessageContent.length < 1)
        return 80;
    int iHeight = [UILabel getFitTextHeightWithText:_strMessageContent andWidth:300 andFont:[UIFont systemFontOfSize:14]];
    if(iHeight < 30)
        iHeight = 30;
    int iCellHeight = 50+ iHeight;
    return iCellHeight;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

//
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strMoreMessageDetailCellId = @"MoreMessageDetailCellId";
    UITableViewCell *pCellObj = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:strMoreMessageDetailCellId];
    if (!pCellObj)
    {
        pCellObj = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strMoreMessageDetailCellId];
        pCellObj.contentView.backgroundColor =  [UIColor whiteColor];
        pCellObj.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        //产品名称
        UILabel*pLabel = [[UILabel alloc]initWithFrame:CGRectMake(10,10, 300, 21)];
        pLabel.backgroundColor = [UIColor clearColor];
        pLabel.textColor = COLOR_FONT_1;
        
        pLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        pLabel.numberOfLines = 0;
        pLabel.textAlignment  = UITextAlignmentLeft;
        pLabel.tag = 1001;
        pLabel.text = _strMessageTitle;
        [pCellObj.contentView addSubview:pLabel];
    
        //
        pLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 35, 280, 14)];
        pLabel.textAlignment  = UITextAlignmentLeft;
        pLabel.backgroundColor = [UIColor clearColor];
        pLabel.font = [UIFont systemFontOfSize:11.0f];
        pLabel.textColor = COLOR_FONT_2;
        pLabel.text = _strMessageSendDate;
        pLabel.tag = 1002;
        [pCellObj.contentView addSubview:pLabel];
        
        //
        
        int iHeight = [UILabel getFitTextHeightWithText:_strMessageContent andWidth:300 andFont:[UIFont systemFontOfSize:14]];
        pLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, 300, iHeight)];
        pLabel.textAlignment  = UITextAlignmentLeft;
        pLabel.backgroundColor = [UIColor clearColor];
        pLabel.font = [UIFont systemFontOfSize:14.0f];
        pLabel.textColor = COLOR_FONT_2;
        pLabel.text = _strMessageContent;
        pLabel.tag = 1003;
        pLabel.numberOfLines = 0;
        [pCellObj.contentView addSubview:pLabel];
        
    }
    
    return pCellObj;
}





@end
