//
//  LoanTenderInfoListView.m
//
//  汽车贷款-产品详情-投标情况

//  Created by lzq on 2014-06-03.


#import "Car_LoanTenderInfoListView.h"
#import "UaConfiguration.h"
#import "UIOwnSkin.h"
#import "CKHttpHelper.h"
#import "GlobalDefine.h"
#import "CKHttpImageHelper.h"
#import "JsonXmlParserObj.h"
#import "AppInitDataMethod.h"

@interface Car_LoanTenderInfoListView ()

@end

@implementation Car_LoanTenderInfoListView

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

    m_pIntroInfoDataSet = nil;
    _uiMainTableView = nil;
    //设置导航条信息
    [self initNavigationItem];
    //显示初始化数据
    
    m_pIntroInfoDataSet = nil;
    m_isLoading = NO;
    [super viewDidLoad];

    
}

-(void)viewWillAppear:(BOOL)animated
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
    
    [self downLoadLoanTenderList_Web:0];
        
}

-(void)viewDidAppear:(BOOL)animated
{

}

//导航条设置
-(void)initNavigationItem
{
    
    self.navigationController.navigationBar.translucent = NO;
    
    //标题
    self.navigationItem.titleView = [UIOwnSkin navibarTitleView:@"投标情况" andFrame:CGRectMake(0, 0, 100, 40)];
    //左边返回按钮
    self.navigationItem.leftBarButtonItem = [UIOwnSkin backItemTarget:self action:@selector(backNavButtonAction:)];
    //右边刷新
    self.navigationItem.rightBarButtonItem = [UIOwnSkin navTextItemTarget:self action:@selector(onRightRefreshClicked:) text:@"刷新" andWidth:40];
}


-(void)backNavButtonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

//刷新
-(void)onRightRefreshClicked:(id)sender
{
    [self downLoadLoanTenderList_Web:1];
}

//从服务端获取投标信息
-(void)downLoadLoanTenderList_Web:(NSInteger)iLoadFlag
{
    if(m_isLoading == YES)
        return;
    
    CKHttpHelper *pHttpHelper = [CKHttpHelper httpHelperWithOwner:self];
    pHttpHelper.m_iWebServerType = 1;
    pHttpHelper.methodType = CKHttpMethodTypePost_Page;
    //设置webservice方法名
    [pHttpHelper setMethodName:@"productInfo/queryAllBidMember"];
     //
    [pHttpHelper addParam:_strProductId forName:@"productId"];
    
    //设置结束block（webservice方法结束后，会自动调用）
    [pHttpHelper setCompleteBlock:^(id dataSet)
     {
         
         [SVProgressHUD dismiss];
         m_isLoading = NO;
         JsonXmlParserObj* pJsonObj = dataSet;
         if(pJsonObj == nil)
         {
             [SVProgressHUD showErrorWithStatus:HINT_WEBDATA_NET_ERROR duration:1.8];
             return ;
         }
         
         m_pIntroInfoDataSet = [pJsonObj parsetoDataSet:@"buyList"];
         
         //[m_pIntroInfoDataSet printTestData];
         //暂时先写册数数据
         /*
         m_pIntroInfoDataSet = [[QDataSetObj alloc] init];
         for(int i=0;i<10;i++)
         {
             [m_pIntroInfoDataSet addDataSetRow_Ext:i andName:@"userName" andValue:[NSString stringWithFormat:@"1380571000%d",i]];
             [m_pIntroInfoDataSet addDataSetRow_Ext:i andName:@"tenderMoney" andValue:[NSString stringWithFormat:@"%d000",i+1]];
             [m_pIntroInfoDataSet addDataSetRow_Ext:i andName:@"tenderTime" andValue:[NSString stringWithFormat:@"2014-12-%.02d",i+1]];
         }
          */

         [_uiMainTableView reloadData];
     }];
    [pHttpHelper setStartBlock:^{
        [SVProgressHUD showWithStatus:HINT_WEBDATA_LOADING ];
    }];
    m_isLoading = YES;
    //开始连接
    [pHttpHelper start];

}

#pragma mark -UITableView delegate and datasource

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 55;
}

//4个Section
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(m_pIntroInfoDataSet == nil)
        return 0;
    return 1;
}


//
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(m_pIntroInfoDataSet == nil)
        return 0;

    return [m_pIntroInfoDataSet getRowCount];
    
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

//加载cell
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString *strLoanTenderInfoCellID = @"LoanTenderInfoCellId";
    UITableViewCell *pCellObj = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:strLoanTenderInfoCellID];
    
    if (!pCellObj)
    {
        pCellObj = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strLoanTenderInfoCellID];
        pCellObj.contentView.backgroundColor = [UIColor whiteColor];
        pCellObj.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        //投标账号
        UILabel* pLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 200, 16)];
        pLable.backgroundColor = [UIColor clearColor];
        pLable.font = [UIFont systemFontOfSize:14];
        pLable.textColor = COLOR_FONT_1;
        pLable.text = @"";
        pLable.tag = 1001;
        pLable.textAlignment = UITextAlignmentLeft;
        [pCellObj.contentView addSubview:pLable];
        
        
        //投标金额
        pLable = [[UILabel alloc] initWithFrame:CGRectMake(220, 10, 90, 16)];
        pLable.backgroundColor = [UIColor clearColor];
        pLable.font = [UIFont systemFontOfSize:14];
        pLable.textColor = COLOR_FONT_1;
        pLable.tag = 1002;
        pLable.textAlignment = UITextAlignmentRight;
        //pLable.text = @"50.00元";
        [pCellObj.contentView addSubview:pLable];
        
        pLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 28, 200, 16)];
        pLable.backgroundColor = [UIColor clearColor];
        pLable.font = [UIFont systemFontOfSize:12];
        pLable.textColor = COLOR_FONT_2;
        //pLable.text = @"2014.11.16 10:20";
        pLable.tag = 1003;
        [pCellObj.contentView addSubview:pLable];
        
        UIImageView* pImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 54, 320, 1)];
        pImageView.backgroundColor = COLOR_CELL_LINE_DEFAULT;
        [pCellObj.contentView addSubview:pImageView];
        
    }
    
    int iDataRow = indexPath.row;
    UILabel* pLabel = (UILabel*)[pCellObj.contentView viewWithTag:1001];
    if(pLabel )
    {
        NSString* strPhone = [m_pIntroInfoDataSet getFeildValue:iDataRow andColumn:@"TMember_mobilePhone"];
        
        pLabel.text = [AppInitDataMethod convertToShowPhone:strPhone];
    }
    pLabel = (UILabel*)[pCellObj.contentView viewWithTag:1002];
    if(pLabel )
    {
        pLabel.text = [NSString stringWithFormat:@"%@元",[m_pIntroInfoDataSet getFeildValue:iDataRow andColumn:@"bidAmount"]];
    }
    pLabel = (UILabel*)[pCellObj.contentView viewWithTag:1003];
    if(pLabel )
    {
        NSString* strBidDateTime = [m_pIntroInfoDataSet getFeildValue:iDataRow andColumn:@"bidDate"];
        pLabel.text = strBidDateTime;//[self convertToShowTime:strBidDateTime.integerValue ];
    }
    return pCellObj;
    
}

-(NSString*)convertToShowTime:(NSInteger)iOraTime
{
    
    NSDate* nsShowTime = [NSDate dateWithTimeIntervalSince1970:iOraTime];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString* strTime = [dateFormatter stringFromDate:nsShowTime];
    return  strTime;
}

@end
