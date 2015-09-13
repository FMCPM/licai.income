//
//  DDIntegralCityPageView.m
//  我的叮叮 - 积分管理 - 积分商城
//
//  Created by lzq on 2014-11-19
//
//

#import "DDIntegralCityPageView.h"
#import "CKKit.h"
#import "UIOwnSkin.h"
#import "GlobalDefine.h"
#import "UaConfiguration.h"
#import "JsonXmlParserObj.h"
#import "AppInitDataMethod.h"


@interface DDIntegralCityPageView ()

@end

@implementation DDIntegralCityPageView

@synthesize m_uiMainTableView = _uiMainTableView;
@synthesize m_iUserTotalJifen = _iUserTotalJifen;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}



- (void)viewDidLoad
{
	self.navigationController.navigationBar.translucent = NO;
    //
    NSString* strTitle= @"积分商城";

    self.navigationItem.titleView = [UIOwnSkin navibarTitleView:strTitle andFrame:CGRectMake(0, 0, 100, 40)];
    
    _uiMainTableView = nil;
    m_muImageDict = [[NSMutableDictionary alloc] init];
    self.view.backgroundColor = COLOR_VIEW_BK_01;
    //左边返回按钮
    self.navigationItem.leftBarButtonItem = [UIOwnSkin backItemTarget:self action:@selector(backNavButtonAction:)];

    [super viewDidLoad];
}



-(void)viewWillAppear:(BOOL)animated
{
    if(_uiMainTableView != nil)
        return;
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
    _uiMainTableView.backgroundColor = COLOR_VIEW_BK_01;
    _uiMainTableView.dataSource = self;
    _uiMainTableView.delegate = self;
    [self.view addSubview:_uiMainTableView];
    
    [self loadIntegralllGoods_Web];
    
    /*
    m_pInfoDataSet = [[QDataSetObj alloc] init];
    for(int i=0;i<3;i++)
    {
        [m_pInfoDataSet addDataSetRow_Ext:i andName:@"name" andValue:[NSString stringWithFormat:@"积分商品-%d",i+1]];
        
        [m_pInfoDataSet addDataSetRow_Ext:i andName:@"money1" andValue:[NSString stringWithFormat:@"%d",50+i+1]];
        [m_pInfoDataSet addDataSetRow_Ext:i andName:@"money2" andValue:[NSString stringWithFormat:@"%d",60+i+1]];
        
        [m_pInfoDataSet addDataSetRow_Ext:i andName:@"money3" andValue:[NSString stringWithFormat:@"%d",70+i+1]];
    }
    
    [_uiMainTableView reloadData];*/
    
}

-(void)viewDidAppear:(BOOL)animated
{

}

-(void)viewDidDisappear:(BOOL)animated
{
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)backNavButtonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


//获取积分商品
-(void)loadIntegralllGoods_Web
{
    
    CKHttpHelper* pHttpHelper = [CKHttpHelper httpHelperWithOwner:self];
    pHttpHelper.m_iWebServerType = 1;
    pHttpHelper.methodType  = CKHttpMethodTypePost_Page;
    
    [pHttpHelper clearParams];
    //专业市场的id
    [pHttpHelper setMethodName:[NSString stringWithFormat:@"productInfo/queryIntegralProductList"]];
    [pHttpHelper addParam:[NSString stringWithFormat:@"%d",[UaConfiguration sharedInstance].m_setLoginState.m_iUserMemberID] forName:@"memberId"];
    
    
    [pHttpHelper setCompleteBlock:^(id dataSet)
     {
         
         [SVProgressHUD dismiss];
         JsonXmlParserObj* pJsonObj = dataSet;
         if(pJsonObj == nil)
         {
             [SVProgressHUD showErrorWithStatus:HINT_WEBDATA_LOADING duration:1.8];
             return ;
         }
         
         QDataSetObj* pDataSet = [pJsonObj parsetoDataSet:@"inteProList"];
         if(pDataSet == nil)
             return;
         
         m_pInfoDataSet = pDataSet;
         
         
         CKHttpImageHelper* pImageHelper = [CKHttpImageHelper httpHelperWithOwner:self];
         for(int i=0;i<[pDataSet getRowCount];i++)
         {
             NSString* strImgUrl = [pDataSet getFeildValue:0 andColumn:@"productImg"];
             if(strImgUrl.length < 1)
                 continue;
             strImgUrl = [AppInitDataMethod getImageFullUrlPath:strImgUrl andImgFlag:4];
             NSURL *nsImageReqUrl = [NSURL URLWithString:strImgUrl];

             [pImageHelper addImageUrl:nsImageReqUrl forKey:[NSString stringWithFormat:@"%d",i+1]];
         }
         
         [_uiMainTableView reloadData];
         //
         [pImageHelper startWithReceiveBlock:^(UIImage *image,NSString *strKey,BOOL finsh)
          {
              
              if(image == nil || strKey == nil)
                  return ;
              
              [m_muImageDict setObject:image forKey:strKey];
              
              int iKey = [QDataSetObj convertToInt:strKey];
              
              NSIndexPath* indexPath = [NSIndexPath indexPathForRow:iKey inSection:0];
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
    
    [pHttpHelper setStartBlock:^{
        [SVProgressHUD showWithStatus:HINT_WEBDATA_LOADING];
    }];
    
    [pHttpHelper start];
    
    
}


//点击兑换积分商城
-(void)actionJifenExchangeClicked:(id)sender
{
    
    UITableViewCell* pCellObj = [UIOwnSkin getSuperTableViewCell:sender];
    if(pCellObj == nil)
        return;
    NSIndexPath* indexPath = [_uiMainTableView indexPathForCell:pCellObj];
    if(indexPath == nil)
        return;
    int iDataRow = indexPath.row-1;
    if(iDataRow < 0 || iDataRow >= [m_pInfoDataSet getRowCount])
        return;
    
    NSString* strProductId = [m_pInfoDataSet getFeildValue:iDataRow andColumn:@"ipId"];
    
    CKHttpHelper* pHttpHelper = [CKHttpHelper httpHelperWithOwner:self];
    pHttpHelper.m_iWebServerType = 1;
    pHttpHelper.methodType  = CKHttpMethodTypePost_Page;
    
    [pHttpHelper clearParams];
    //专业市场的id
    [pHttpHelper setMethodName:[NSString stringWithFormat:@"productInfo/exchangeIntegral"]];
    [pHttpHelper addParam:[NSString stringWithFormat:@"%d",[UaConfiguration sharedInstance].m_setLoginState.m_iUserMemberID] forName:@"memberId"];
    [pHttpHelper addParam:strProductId forName:@"productId"];
    
    [pHttpHelper setCompleteBlock:^(id dataSet)
     {
         
         [SVProgressHUD dismiss];
         JsonXmlParserObj* pJsonObj = dataSet;
         if(pJsonObj == nil)
         {
             [SVProgressHUD showErrorWithStatus:HINT_WEBDATA_NET_ERROR duration:1.8];
             return ;
         }
         NSString* strOpeFlag = [pJsonObj getDictJsonValueByKey:@"operFlag"];
         int iOpeFlag = [QDataSetObj convertToInt:strOpeFlag];
         if(iOpeFlag == 1)
         {
             [SVProgressHUD showSuccessWithStatus:@"积分兑换成功！" duration:2.0];
             return;
         }
         NSString* strErrorMsg = [pJsonObj getDictJsonValueByKey:@"message"];
         [SVProgressHUD showErrorWithStatus:strErrorMsg duration:2.0];
         
     }];
    
    [pHttpHelper setStartBlock:^{
        [SVProgressHUD showWithStatus:HINT_WEBDATA_SUBMITING];
    }];
    
    [pHttpHelper start];
    
}

#pragma mark -UITableView delegate and datasource

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
        return 44;
    return 70;
}

//Section
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//4行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(m_pInfoDataSet == nil)
        return 0;
    return [m_pInfoDataSet getRowCount]+1;

    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(UITableViewCell*)getCityJifenTopBarTableCell:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath
{
    NSString* strCityJifenTopBarTableCell = @"CityJifenTopBarTableCellId";
    UITableViewCell *pCellObj = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:strCityJifenTopBarTableCell];
    if (!pCellObj)
    {
        pCellObj = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strCityJifenTopBarTableCell];
        pCellObj.contentView.backgroundColor = [UIColor whiteColor];
        pCellObj.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel* pLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 80, 20)];
        pLable.textAlignment = NSTextAlignmentLeft;
        pLable.backgroundColor = [UIColor clearColor];
        pLable.font = [UIFont boldSystemFontOfSize:18];
        pLable.textColor = COLOR_FONT_1;
        pLable.text = @"总积分";
        pLable.tag = 1001;
        [pCellObj.contentView addSubview:pLable];
        

        pLable = [[UILabel alloc] initWithFrame:CGRectMake(110, 10, 200, 20)];
        pLable.textAlignment = NSTextAlignmentRight;
        pLable.backgroundColor = [UIColor clearColor];
        pLable.font = [UIFont boldSystemFontOfSize:20];
        pLable.textColor = COLOR_FONT_5;
        //pLable.text = @"500分";
        pLable.tag = 1002;
        [pCellObj.contentView addSubview:pLable];

        UIImageView* pLineImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 43, self.view.frame.size.width, 1)];
        pLineImgView.backgroundColor = COLOR_CELL_LINE_DEFAULT;
        [pCellObj.contentView addSubview:pLineImgView];
        
    }
    
    UILabel*pLabel = (UILabel*)[pCellObj.contentView viewWithTag:1002];
    if(pLabel)
    {
        pLabel.text = [NSString stringWithFormat:@"%d分",_iUserTotalJifen];
    }
    
    
    return pCellObj;
}

//加载cell
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell* pCellObj = nil;
    if(indexPath.row == 0)
    {
        pCellObj = [self getCityJifenTopBarTableCell:tableView indexPath:indexPath];
        return pCellObj;
    }
    
    static NSString *strJifenExchangeCellId = @"JifenExchangeCellId";
    pCellObj = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:strJifenExchangeCellId];
    
    if (!pCellObj)
    {
        pCellObj = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strJifenExchangeCellId];
        pCellObj.contentView.backgroundColor = COLOR_VIEW_BK_01;
        pCellObj.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView* pBackView = [[UIView alloc] initWithFrame:CGRectMake(10, 15, self.view.frame.size.width-20, 55)];
        pBackView.backgroundColor = [UIColor whiteColor];
        pBackView.layer.borderColor = COLOR_BTN_BORDER_1.CGColor;
        pBackView.layer.cornerRadius = 5.0f;
        pBackView.layer.borderWidth = 1.0f;
        [pCellObj.contentView addSubview:pBackView];
        
        
        //产品logo
        UIImageView* pLogoImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 7, 50, 40)];
        pLogoImgView.tag = 2001;
        [pBackView addSubview:pLogoImgView];
        
        //可兑换商品的名称
        UILabel* pLable = [[UILabel alloc] initWithFrame:CGRectMake(70, 7, 150, 20)];
        pLable.backgroundColor = [UIColor clearColor];
        pLable.font = [UIFont systemFontOfSize:14];
        pLable.textColor = COLOR_FONT_1;
        pLable.tag = 1001;
        pLable.textAlignment = NSTextAlignmentLeft;
        [pBackView addSubview:pLable];
        
        
        //兑换积分值
        pLable = [[UILabel alloc] initWithFrame:CGRectMake(70, 30, 150, 15)];
        pLable.backgroundColor = [UIColor clearColor];
        pLable.font = [UIFont systemFontOfSize:12];
        pLable.textColor = COLOR_FONT_2;
        pLable.tag = 1002;
        pLable.textAlignment = NSTextAlignmentLeft;
        [pBackView addSubview:pLable];
       
        //
        UIButton* pButton = [UIButton buttonWithType:UIButtonTypeCustom];
        pButton.frame = CGRectMake(230, 12, 60, 35);
        pButton.tag = 3001;
        [UIOwnSkin setButtonBackground:pButton];
        [pButton addTarget:self action:@selector(actionJifenExchangeClicked:) forControlEvents:UIControlEventTouchUpInside];
        [pButton setTitle:@"兑换" forState:UIControlStateNormal];
        [pBackView addSubview:pButton];

    }
    int iRow = indexPath.row - 1;
    UILabel*pLabel = (UILabel*)[pCellObj.contentView viewWithTag:1001];
    if(pLabel)
    {
        pLabel.text = [m_pInfoDataSet getFeildValue:iRow andColumn:@"productName"];
        
    }
    //
    pLabel = (UILabel*)[pCellObj.contentView viewWithTag:1002];
    if(pLabel)
    {
        pLabel.text = [NSString stringWithFormat:@"%@积分",[m_pInfoDataSet getFeildValue:iRow andColumn:@"integralAmount"]];
        
    }
 
    UIImageView*pLogoImgView = (UIImageView*)[pCellObj.contentView viewWithTag:2001];
    if(pLogoImgView)
    {
        NSString* strImgUrl = [m_pInfoDataSet getFeildValue:iRow andColumn:@"productImg"];
        if(strImgUrl.length < 1)
        {
            pLogoImgView.image = [UIImage imageNamed:NO_IMAGE_NAME];
        }
        else
        {
            UIImage* pDownImg = [m_muImageDict objectForKey:[NSString stringWithFormat:@"%d",iRow+1]];
            if(pDownImg)
            {
                pLogoImgView.image = pDownImg;
            }
            else
            {
                pLogoImgView.image = [UIImage imageNamed:LOADING_IMAGE_NAME];
            }
        }
    
    }
    return pCellObj;

    
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
