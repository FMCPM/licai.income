//
//  DDBillLeftMoneyPageView.h

//  我的叮叮-账户余额
//
//  Created  on 2014-11-20.
//

#import "DDBillLeftMoneyPageView.h"
#import "UaConfiguration.h"
#import "UIOwnSkin.h"
#import "DdBillDetailTableCell.h"
#import "DDBillGetCashPageView.h"
#import "CKHttpHelper.h"
#import "JsonXmlParserObj.h"
#import "AppInitDataMethod.h"

@interface DDBillLeftMoneyPageView ()

@end

@implementation DDBillLeftMoneyPageView

@synthesize m_uiMainTableView = _uiMainTableView;
@synthesize m_uiTopBarView = _uiTopBarView;

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
    self.navigationItem.titleView = [UIOwnSkin navibarTitleView:@"账户余额" andFrame:CGRectMake(0, 0, 100, 40)];
    
    //左边返回按钮
    self.navigationItem.leftBarButtonItem = [UIOwnSkin backItemTarget:self action:@selector(backNavButtonAction:)];
    
    //提现
    self.navigationItem.rightBarButtonItem = [UIOwnSkin navTextItemTarget:self action:@selector(onRightGetCashClicked:) text:@"提现" andWidth:40];
 
    [super viewDidLoad];
    
}

//刷新
-(void)backNavButtonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

//右边提现
-(void)onRightGetCashClicked:(id)sender
{
    DDBillGetCashPageView* pCashView = [[DDBillGetCashPageView alloc] init];
    pCashView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:pCashView animated:YES];
}



- (void)viewWillAppear:(BOOL)animated
{
    if(_uiTopBarView != nil)
        return;
    _uiTopBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    _uiTopBarView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_uiTopBarView];
    
    NSArray* arItems = [[NSArray alloc] initWithObjects:@"账户余额",@"收入明细",@"支出明细", nil];
    
    OwnSegmentedControl* pSegControl = [[OwnSegmentedControl alloc] initWithFrame:CGRectMake(35, 7,250,25) items:arItems];
    pSegControl.m_segDelegate = self;
    [_uiTopBarView addSubview:pSegControl];
    
    
    UIImageView* pLineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 39, self.view.frame.size.width, 1)];
    pLineView.backgroundColor = COLOR_CELL_LINE_DEFAULT;
    [_uiTopBarView addSubview:pLineView];
    
    if(_uiMainTableView != nil)
        return;
    
    
    CGRect rcTable = CGRectMake(0, 40, self.view.frame.size.width, self.view.frame.size.height-40);
    
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

    //第一个按钮选中
    m_iInfoType = 1;
    
    [self loadViewMultTypeInfoShow:0];
}


-(void)viewDidAppear:(BOOL)animated
{
 
}

-(void)loadViewMultTypeInfoShow:(NSInteger)iLoadFlag
{
    if(m_iInfoType == 1)
    {
        [self loadBillLeftInfo_Web];
    }
    else
    {
        [self loadInComeOrOutInfo_Web:m_iInfoType andFlag:iLoadFlag ];
    }
}



//获取账号余额
-(void)loadBillLeftInfo_Web
{
    if(m_isLoading == YES)
    {
        [_uiMainTableView reloadData];
        return;
    }

    CKHttpHelper* pHttpHelper = [CKHttpHelper httpHelperWithOwner:self];
    pHttpHelper.m_iWebServerType = 1;
    pHttpHelper.methodType  = CKHttpMethodTypePost_Page;

    //
    [pHttpHelper setMethodName:@"memberInfo/queryMyAccount"];
    
    [pHttpHelper addParam:[NSString stringWithFormat:@"%d",[UaConfiguration sharedInstance].m_setLoginState.m_iUserMemberID] forName:@"memberId"];
    [pHttpHelper setCompleteBlock:^(id dataSet)
     {
         m_isLoading = NO;
         [SVProgressHUD dismiss];
         JsonXmlParserObj* pJsonObj = dataSet;
         if(pJsonObj == nil)
         {
             [SVProgressHUD showErrorWithStatus:HINT_WEBDATA_NET_ERROR duration:1.8];
             return ;
         }
         m_pInfoDataSet = [pJsonObj parsetoDataSet:@"data"];
         
         [_uiMainTableView reloadData];

    }];
    
    [pHttpHelper setStartBlock:^{
        [SVProgressHUD showWithStatus:@"正在加载，请稍后..."];
    }];
    
    m_isLoading = YES;
    [pHttpHelper start];
 
    
}

//加载收入或支出明细
-(void)loadInComeOrOutInfo_Web:(NSInteger)iInfoType andFlag:(NSInteger)iLoadFlag
{
    if(m_isLoading == YES)
    {
        [_uiMainTableView reloadData];
        return;
    }
    
    if(iLoadFlag == 1)
    {
        m_pInfoDataSet = nil;
        m_pInfoDataSet = [[QDataSetObj alloc] init];
    }
    
    CKHttpHelper* pHttpHelper = [CKHttpHelper httpHelperWithOwner:self];
    pHttpHelper.m_iWebServerType = 1;
    pHttpHelper.methodType  = CKHttpMethodTypePost_Page;
    
    //
    if(iInfoType == 2)
    {
        [pHttpHelper setMethodName:@"memberInfo/incomeDtl"];
    }
    else
    {
        [pHttpHelper setMethodName:@"memberInfo/outPayDtl"];
    }
    
    [pHttpHelper addParam:[NSString stringWithFormat:@"%d",[UaConfiguration sharedInstance].m_setLoginState.m_iUserMemberID] forName:@"memberId"];
    [pHttpHelper setCompleteBlock:^(id dataSet)
     {
         m_isLoading = NO;
         [SVProgressHUD dismiss];
         JsonXmlParserObj* pJsonObj = dataSet;
         if(pJsonObj == nil)
         {
             [SVProgressHUD showErrorWithStatus:HINT_WEBDATA_NET_ERROR duration:1.8];
             return ;
         }
         QDataSetObj* pDataSet = nil;
         if(iInfoType == 2)
         {
             pDataSet = [pJsonObj parsetoDataSet:@"incomeList"];
         }
         else
         {
             pDataSet = [pJsonObj parsetoDataSet:@"outPayList"];
         }

         m_pInfoDataSet = pDataSet;
         
         [_uiMainTableView reloadData];
         
     }];
    
    [pHttpHelper setStartBlock:^{
        [SVProgressHUD showWithStatus:@"正在加载，请稍后..."];
    }];
    
    m_isLoading = YES;
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
    if(m_iInfoType != 1)
        return 90;
    if(indexPath.row == 0)
        return 60;
    return 90;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(m_pInfoDataSet == nil)
        return 0;
    
    if(m_iInfoType == 1)
        return 2;
    
    return [m_pInfoDataSet getRowCount];
}

//账号余额的信息
-(UITableViewCell *)getLeftMoneyTableCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strLeftMoneyTableCellId = @"LeftMoneyTableCellId";
    UITableViewCell *pCellObj = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:strLeftMoneyTableCellId];
    if (!pCellObj)
    {
        pCellObj = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strLeftMoneyTableCellId];
        pCellObj.contentView.backgroundColor =  COLOR_VIEW_BK_02;
        pCellObj.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        //产品名称
        UILabel*pLabel = [[UILabel alloc]initWithFrame:CGRectMake(20,15, 100, 30)];
        pLabel.backgroundColor = [UIColor clearColor];
        pLabel.textColor = COLOR_FONT_1;
        
        pLabel.font = [UIFont boldSystemFontOfSize:20.0f];
        pLabel.numberOfLines = 0;
        pLabel.textAlignment  = UITextAlignmentLeft;
        pLabel.tag = 1001;
        pLabel.text = @"账户余额";
        [pCellObj.contentView addSubview:pLabel];
        
        //余额
        pLabel = [[UILabel alloc] initWithFrame:CGRectMake(140, 15, 160, 30)];
        pLabel.textAlignment  = UITextAlignmentRight;
        pLabel.backgroundColor = [UIColor clearColor];
        pLabel.font = [UIFont boldSystemFontOfSize:20.0f];
        pLabel.textColor = COLOR_FONT_5;
        pLabel.tag = 1002;
        [pCellObj.contentView addSubview:pLabel];
        

    }
    
    UILabel*pLabel = (UILabel*)[pCellObj.contentView viewWithTag:1002];
    if(pLabel)
    {
        if(m_pInfoDataSet == nil)
        {
            pLabel.text = @"0.00";
        }
        else
        {
            NSString* strFeeValue1 = [m_pInfoDataSet getFeildValue:0 andColumn:@"balance"];
            NSString* strFeeValue2 = [m_pInfoDataSet getFeildValue:0 andColumn:@"wdFee"];
        
            float fTotalFee = [QDataSetObj convertToFloat:strFeeValue1]+[QDataSetObj convertToFloat:strFeeValue2];
            pLabel.text = [NSString stringWithFormat:@"%.2f",fTotalFee];
        }
        
    }
    
    return pCellObj;

}

//可用余额和提现中余额的Cell
-(UITableViewCell *)getCanUsedMoneyTableCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strCanUsedMoneyTableCellId = @"CanUsedMoneyTableCellId";
    UITableViewCell *pCellObj = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:strCanUsedMoneyTableCellId];
    if (!pCellObj)
    {
        pCellObj = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strCanUsedMoneyTableCellId];
        pCellObj.contentView.backgroundColor =  [UIColor whiteColor];
        pCellObj.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        //可用余额标题
        UILabel*pLabel = [[UILabel alloc]initWithFrame:CGRectMake(20,15, 120, 20)];
        pLabel.backgroundColor = [UIColor clearColor];
        pLabel.textColor = COLOR_FONT_1;
        
        pLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        pLabel.numberOfLines = 0;
        pLabel.textAlignment  = UITextAlignmentLeft;
        pLabel.tag = 1001;
        pLabel.text = @"可用余额（元）";
        [pCellObj.contentView addSubview:pLabel];
        
        //可用余额值
        pLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 20, 140, 20)];
        pLabel.textAlignment  = UITextAlignmentRight;
        pLabel.backgroundColor = [UIColor clearColor];
        pLabel.font = [UIFont systemFontOfSize:14];
        pLabel.textColor = COLOR_FONT_2;
        //pLabel.text = @"10000";
        pLabel.tag = 1002;
        [pCellObj.contentView addSubview:pLabel];
        
        
        //提现中余额标题
        pLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, 120, 20)];
        pLabel.backgroundColor = [UIColor clearColor];
        pLabel.font = [UIFont systemFontOfSize:14];
        pLabel.textColor = COLOR_FONT_1;
        pLabel.tag = 1003;
        pLabel.numberOfLines = 0;
        pLabel.textAlignment = UITextAlignmentLeft;
        pLabel.text = @"提现中余额（元）";
        [pCellObj.contentView addSubview:pLabel];
        
        //提现中余额的值
        pLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 40, 140, 20)];
        pLabel.textAlignment  = UITextAlignmentRight;
        pLabel.backgroundColor = [UIColor clearColor];
        pLabel.font = [UIFont systemFontOfSize:14];
        pLabel.textColor = COLOR_FONT_2;
        pLabel.tag = 1004;
        [pCellObj.contentView addSubview:pLabel];
        
        UIImageView*pLineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 79, self.view.frame.size.width, 1)];
        pLineView.backgroundColor = COLOR_CELL_LINE_DEFAULT;
        [pCellObj.contentView addSubview:pLineView];
        
    }
    UILabel* pLabel = (UILabel*)[pCellObj.contentView viewWithTag:1002];
    if(pLabel)
    {
        pLabel.text = [AppInitDataMethod convertMoneyShow:[m_pInfoDataSet getFeildValue:0 andColumn:@"balance"]];
    }
    
    pLabel = (UILabel*)[pCellObj.contentView viewWithTag:1004];
    if(pLabel)
    {
        pLabel.text = [AppInitDataMethod convertMoneyShow:[m_pInfoDataSet getFeildValue:0 andColumn:@"wdFee"]];
    }
    return pCellObj;
}


//支出或收入明细的Cell
-(UITableViewCell *)getDDBillDetailTableCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strDDBillDetailTableCellId = @"DDBillDetailTableCellId";
    DdBillDetailTableCell *pCellObj = (DdBillDetailTableCell*)[tableView dequeueReusableCellWithIdentifier:strDDBillDetailTableCellId];
    if (!pCellObj)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DdBillDetailTableCell" owner:self options:nil];
        pCellObj = [nib objectAtIndex:0];
        
        pCellObj.contentView.backgroundColor = [UIColor whiteColor];
        pCellObj.selectionStyle = UITableViewCellSelectionStyleNone;
        [pCellObj initCellDefaultShow];        
        
        UIImageView*pLineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 89, self.view.frame.size.width, 1)];
        pLineView.tag = 2001;
        pLineView.backgroundColor = COLOR_CELL_LINE_DEFAULT;
        [pCellObj.contentView addSubview:pLineView];

 
    }
    NSString* strMoney1 = @"";
    NSString* strTime = @"";
    NSString* strMoney2 = [m_pInfoDataSet getFeildValue:indexPath.row andColumn:@"balance"];

    if(m_iInfoType == 2)
    {
        pCellObj.m_uiFondInComeLabel.text = @"投资收益";
        NSString* strFee1 = [m_pInfoDataSet getFeildValue:indexPath.row andColumn:@"monthInterest"];
        NSString* strFee2 = [m_pInfoDataSet getFeildValue:indexPath.row andColumn:@"principal"];
        float fMoney1 = [QDataSetObj convertToFloat:strFee1]+[QDataSetObj convertToFloat:strFee2];
        strMoney1 = [NSString stringWithFormat:@"+%.2f",fMoney1];
        
        strTime = [m_pInfoDataSet getFeildValue:indexPath.row andColumn:@"createTime"];
    }
    else
    {
        pCellObj.m_uiFondInComeLabel.text = @"投标";
        strMoney1 = [m_pInfoDataSet getFeildValue:indexPath.row andColumn:@"bidAmount"];
        strMoney1 = [NSString stringWithFormat:@"-%.2f",[QDataSetObj convertToFloat:strMoney1]];
        strTime = [m_pInfoDataSet getFeildValue:indexPath.row andColumn:@"bidDate"];
    }

    //收入或支出
    pCellObj.m_uiAddInfoLabel.text = strMoney1;

    //余额
    pCellObj.m_uiLeftMoneyValueLabel.text = [NSString stringWithFormat:@"%.2f",[QDataSetObj convertToFloat:strMoney2]];
    //产品名称
    pCellObj.m_uiProductNameLabel.text = [m_pInfoDataSet getFeildValue:indexPath.row andColumn:@"TProduct_productName"];
    //日期
    pCellObj.m_uiTimeLabel.text = strTime;//[AppInitDataMethod convertToShowTime:[QDataSetObj convertToInt:strTime]];

    
    return pCellObj;
}

//
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* pCellObj = nil;
    if(m_iInfoType == 1)
    {
        if(indexPath.row == 0)
        {
            pCellObj = [self getLeftMoneyTableCell:tableView cellForRowAtIndexPath:indexPath];
        }
        else if(indexPath.row == 1)
        {
            pCellObj = [self getCanUsedMoneyTableCell:tableView cellForRowAtIndexPath:indexPath];
        }

    }
    else
    {
        pCellObj = [self getDDBillDetailTableCell:tableView cellForRowAtIndexPath:indexPath];
    }
    return pCellObj;
}




#pragma OwnSegmentedControlDelegate
-(void)didChangeSegmentedIndex:(UIButton *)pButton selectedIndex:(NSInteger)iBtnIndex
{
    m_iInfoType = iBtnIndex+1;
    m_pInfoDataSet = nil;
    [self loadViewMultTypeInfoShow:1];
}

@end
