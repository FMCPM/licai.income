//
//  DDTradeLogPageView.h

//  我的叮叮-交易记录
//
//  Created  on 2014-11-23.
//

#import "DDTradeLogPageView.h"
#import "UaConfiguration.h"
#import "UIOwnSkin.h"
#import "JsonXmlParserObj.h"
#import "AppInitDataMethod.h"

@interface DDTradeLogPageView ()

@end

@implementation DDTradeLogPageView

@synthesize m_uiMainTableView = _uiMainTableView;
;

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
    m_muImageListDic = [[NSMutableDictionary alloc]initWithCapacity:0];
    //标题
    self.navigationItem.titleView = [UIOwnSkin navibarTitleView:@"交易记录" andFrame:CGRectMake(0, 0, 100, 40)];
    
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

    [self loadTradeLogInfo_Web];
}


-(void)viewDidAppear:(BOOL)animated
{

}



//重新加载产品信息
-(void)loadTradeLogInfo_Web
{
    
    CKHttpHelper* pHttpHelper = [CKHttpHelper httpHelperWithOwner:self];
    pHttpHelper.m_iWebServerType = 1;
    pHttpHelper.methodType  = CKHttpMethodTypePost_Page;
    
    [pHttpHelper clearParams];
    //专业市场的id
    [pHttpHelper setMethodName:[NSString stringWithFormat:@"memberInfo/outPayDtl"]];
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
         
         QDataSetObj* pDataSet = [pJsonObj parsetoDataSet:@"outPayList"];
         if(pDataSet == nil)
             return;
         
         m_pInfoDataSet = pDataSet;
         
         [_uiMainTableView reloadData];
         

     }];
    
    [pHttpHelper setStartBlock:^{
        [SVProgressHUD showWithStatus:HINT_WEBDATA_LOADING];
    }];
    
    [pHttpHelper start];

    
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
    
    return 80;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(m_pInfoDataSet == nil)
        return 0;
    return [m_pInfoDataSet getRowCount];
}



//
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strTradeLogInfoTableId = @"TradeLogInfoTableId";
    UITableViewCell *pCellObj = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:strTradeLogInfoTableId];
    if (!pCellObj)
    {
        pCellObj = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strTradeLogInfoTableId];
        pCellObj.contentView.backgroundColor =  [UIColor whiteColor];
        pCellObj.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        //产品名称
        UILabel*pLabel = [[UILabel alloc]initWithFrame:CGRectMake(20,20, 150, 21)];
        pLabel.backgroundColor = [UIColor clearColor];
        pLabel.textColor = COLOR_FONT_1;
        
        pLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        pLabel.numberOfLines = 0;
        pLabel.textAlignment  = UITextAlignmentLeft;
        pLabel.tag = 1001;
       // pLabel.text = @"车金融B000122";
        [pCellObj.contentView addSubview:pLabel];
        
        //交易日期
        pLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 45, 100, 20)];
        pLabel.textAlignment  = UITextAlignmentLeft;
        pLabel.backgroundColor = [UIColor clearColor];
        pLabel.font = [UIFont systemFontOfSize:14.f];
        pLabel.textColor = COLOR_FONT_2;
        //pLabel.text = @"2014-11-23";
        pLabel.tag = 1002;
        [pCellObj.contentView addSubview:pLabel];
        
        //操作说明
        pLabel = [[UILabel alloc] initWithFrame:CGRectMake(175, 35, 50, 20)];
        pLabel.textAlignment  = UITextAlignmentLeft;
        pLabel.backgroundColor = [UIColor clearColor];
        pLabel.font = [UIFont systemFontOfSize:14.f];
        pLabel.textColor = COLOR_FONT_2;
        //pLabel.text = @"投标";
        pLabel.tag = 1003;
        [pCellObj.contentView addSubview:pLabel];
        
        //交易金额去
        pLabel = [[UILabel alloc] initWithFrame:CGRectMake(220, 20, 90, 20)];
        pLabel.textAlignment  = UITextAlignmentRight;
        pLabel.backgroundColor = [UIColor clearColor];
        pLabel.font = [UIFont systemFontOfSize:14.f];
        pLabel.textColor = COLOR_FONT_2;
        //pLabel.text = @"500000元";
        pLabel.tag = 1004;
        [pCellObj.contentView addSubview:pLabel];
        
        //状态说明
        pLabel = [[UILabel alloc] initWithFrame:CGRectMake(220, 45, 90, 20)];
        pLabel.textAlignment  = UITextAlignmentRight;
        pLabel.backgroundColor = [UIColor clearColor];
        pLabel.font = [UIFont systemFontOfSize:14.f];
        pLabel.textColor = COLOR_FONT_2;
        //pLabel.text = @"申购成功";
        pLabel.tag = 1005;
        [pCellObj.contentView addSubview:pLabel];
        
        //
        UIImageView* pLineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 79, self.view.frame.size.width, 1)];
        pLineView.backgroundColor = COLOR_CELL_LINE_DEFAULT;
        [pCellObj.contentView addSubview:pLineView];
        
        
    }
    
    int iDataRow = indexPath.row;
    UILabel*pLabel = (UILabel*)[pCellObj.contentView viewWithTag:1001];
    if(pLabel)
    {
        pLabel.text = [m_pInfoDataSet getFeildValue:iDataRow andColumn:@"TProduct_productName"];
    }
    pLabel = (UILabel*)[pCellObj.contentView viewWithTag:1002];
    if(pLabel)
    {
        NSString* strTime = [m_pInfoDataSet getFeildValue:iDataRow andColumn:@"bidDate"];
        strTime = [AppInitDataMethod convertToShowTime2:strTime];
        pLabel.text = strTime;//[AppInitDataMethod convertToShowTime:[QDataSetObj convertToInt:strTime]];
    }
    

    
    pLabel = (UILabel*)[pCellObj.contentView viewWithTag:1003];
    if(pLabel)
    {
        NSString* strPayType = [m_pInfoDataSet getFeildValue:0 andColumn:@"payType"];
        
        int iPayType = [QDataSetObj convertToInt:strPayType];
        if(iPayType == 1)
            pLabel.text = @"投标";
        else
            pLabel.text = @"";
    }
    //投资金额
    pLabel = (UILabel*)[pCellObj.contentView viewWithTag:1004];
    if(pLabel)
    {
        pLabel.text = [AppInitDataMethod convertMoneyShow:[m_pInfoDataSet getFeildValue:iDataRow andColumn:@"bidAmount"]];
    }
    
    pLabel = (UILabel*)[pCellObj.contentView viewWithTag:1005];
    if(pLabel)
    {
        NSString* strPayStatus = [m_pInfoDataSet getFeildValue:0 andColumn:@"payStatus"];
        int iPayStatus = [QDataSetObj convertToInt:strPayStatus];
        // payStatus: 1:待支付2:支付成功3:交易失败
        if(iPayStatus == 1)
        {
            pLabel.text = @"待支付";
        }
        else if(iPayStatus == 2)
        {
            pLabel.text = @"支付成功";
        }
        else if(iPayStatus == 3)
        {
            pLabel.text = @"交易失败";
        }
    }
    return pCellObj;
}



@end
