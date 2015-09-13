//
//  MyHoldBackMoneyPlanView.h
//
//  我的叮叮 - 持有资产 - 回款计划
//
//  Created by lzq on 2015-01-05
//
//

#import "MyHoldBackMoneyPlanView.h"
#import "CKKit.h"
#import "UIOwnSkin.h"
#import "GlobalDefine.h"
#import "AppInitDataMethod.h"
#import "UaConfiguration.h"
#import "JsonXmlParserObj.h"
#import "WebViewController.h"

@interface MyHoldBackMoneyPlanView ()

@end

@implementation MyHoldBackMoneyPlanView

@synthesize m_uiMainTableView = _uiMainTableView;
@synthesize m_uiTopBarView = _uiTopBarView;
@synthesize m_uiStartTimeLabel = _uiStartTimeLabel;
@synthesize m_uiTotalInComeLabel = _uiTotalInComeLabel;
@synthesize m_strProductId = _strProductId;
@synthesize m_strOrderRecId = _strOrderRecId;

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
    self.navigationItem.titleView = [UIOwnSkin navibarTitleView:@"回款计划" andFrame:CGRectMake(0, 0, 100, 40)];
    
    _uiMainTableView = nil;
    _uiTopBarView.backgroundColor = COLOR_VIEW_BK_03;
    //左边返回按钮
    self.navigationItem.leftBarButtonItem = [UIOwnSkin backItemTarget:self action:@selector(backNavButtonAction:)];
    //
    [super viewDidLoad];
}



-(void)viewWillAppear:(BOOL)animated
{
    [self initTableView];
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


//初始化视图
-(void)initTableView
{
    if(_uiMainTableView != nil)
        return;
    CGRect rcTable = self.view.frame;
    rcTable.origin.y = 80;
    rcTable.size.height = self.view.frame.size.height - 80;

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

    [_uiMainTableView reloadData];
    
    [self loadInComMoneyPlanList_Web];
}

//获取回款计划
-(void)loadInComMoneyPlanList_Web
{
    CKHttpHelper*  pHttpHelper = [CKHttpHelper httpHelperWithOwner:self];
    pHttpHelper.m_iWebServerType = 1;
    pHttpHelper.methodType = CKHttpMethodTypePost_Page;
    //设置webservice方法名
    [pHttpHelper setMethodName:@"productInfo/queryRepayPlan"];
    //[pHttpHelper addParam:_strProductId  forName:@"relId"];
    //测试
    [pHttpHelper addParam:_strOrderRecId  forName:@"relId"];
    [pHttpHelper setCompleteBlock:^(id dataSet)
     {
         
         [SVProgressHUD dismiss];
         JsonXmlParserObj* pJsonObj = dataSet;
         if(pJsonObj == nil)
         {
             [SVProgressHUD showErrorWithStatus:HINT_WEBDATA_NET_ERROR duration:1.8];
             return ;
         }
         
         //总的期数
         NSString* strAllTime = [pJsonObj getDictJsonValueByKey:@"allTime"];
         
         //起息日
         _uiStartTimeLabel.text = [NSString stringWithFormat:@"起息日：%@",[pJsonObj getDictJsonValueByKey:@"startDate"]];
         
         //
         QDataSetObj* pDataSet = [pJsonObj parsetoDataSet:@"rePlanList"];
         if(pDataSet == nil)
             return;

         m_pInfoDataSet = [[QDataSetObj alloc] init];
 
         float fTotalInCome = 0;
         int iCurTime = 1;
         for(int i=0;i<[pDataSet getRowCount];i++)
         {
            // NSString* strLimit = [pDataSet getFeildValue:i andColumn:@"TProduct_limitTime"];
             
             [m_pInfoDataSet addDataSetRow_Ext:i andName:@"time1" andValue:[NSString stringWithFormat:@"%d/%@",iCurTime,strAllTime]];
             
             NSString* strCreateTime = [pDataSet getFeildValue:i andColumn:@"createTime"];
           //  strCreateTime = [AppInitDataMethod convertToShowTime:[QDataSetObj convertToInt:strCreateTime]];
             [m_pInfoDataSet addDataSetRow_Ext:i andName:@"time2" andValue:strCreateTime];
             
             [m_pInfoDataSet addDataSetRow_Ext:i andName:@"money1" andValue:[pDataSet getFeildValue:i andColumn:@"principal"]];
             NSString* strMonthInCome = [pDataSet getFeildValue:i andColumn:@"monthInterest"];
             
             [m_pInfoDataSet addDataSetRow_Ext:i andName:@"money2" andValue:strMonthInCome];
             [m_pInfoDataSet addDataSetRow_Ext:i andName:@"money3" andValue:[pDataSet getFeildValue:i andColumn:@"dayIncome"]];
             
             fTotalInCome = fTotalInCome + [QDataSetObj convertToFloat:strMonthInCome];
             iCurTime++;
         }
         _uiTotalInComeLabel.text = [NSString stringWithFormat:@"预计总收益：%.2f",fTotalInCome];
         [_uiMainTableView reloadData];
     }];
    
    [pHttpHelper setStartBlock:^{
        [SVProgressHUD showWithStatus:HINT_WEBDATA_LOADING];
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
    return [m_pInfoDataSet getRowCount];

    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}



//加载cell
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *strBackMoneyPlanCellId = @"BackMoneyPlanCellId";
    UITableViewCell *pCellObj = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:strBackMoneyPlanCellId];
    
    if (!pCellObj)
    {
        pCellObj = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strBackMoneyPlanCellId];
        pCellObj.contentView.backgroundColor = [UIColor whiteColor];
        pCellObj.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //当期/总期
        UILabel* pLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 80, 20)];
        pLable.textAlignment = NSTextAlignmentCenter;
        pLable.backgroundColor = [UIColor clearColor];
        pLable.font = [UIFont systemFontOfSize:12];
        pLable.textColor = COLOR_FONT_3;
        pLable.text = @"";
        pLable.tag = 1001;
        [pCellObj.contentView addSubview:pLable];
        
        //日期（年/月/日）
        pLable = [[UILabel alloc] initWithFrame:CGRectMake(5, 35, 90, 20)];
        pLable.textAlignment = NSTextAlignmentCenter;
        pLable.backgroundColor = [UIColor clearColor];
        pLable.font = [UIFont systemFontOfSize:12];
        pLable.textColor = COLOR_FONT_3;
        pLable.text = @"";
        pLable.tag = 1002;
        [pCellObj.contentView addSubview:pLable];
        
        
        //还款本金
        pLable = [[UILabel alloc] initWithFrame:CGRectMake(120, 8, 200, 18)];
        pLable.backgroundColor = [UIColor clearColor];
        pLable.font = [UIFont systemFontOfSize:12];
        pLable.textColor = COLOR_FONT_3;
        pLable.tag = 1003;
        pLable.textAlignment = NSTextAlignmentLeft;
        [pCellObj.contentView addSubview:pLable];
        
        //还款本息
        pLable = [[UILabel alloc] initWithFrame:CGRectMake(120, 26, 130, 18)];
        pLable.backgroundColor = [UIColor clearColor];
        pLable.font = [UIFont systemFontOfSize:12];
        pLable.textColor = COLOR_FONT_3;
        pLable.textAlignment = NSTextAlignmentLeft;
        pLable.tag = 1004;
        [pCellObj.contentView addSubview:pLable];
        
        
        //日收益
        pLable = [[UILabel alloc] initWithFrame:CGRectMake(120, 44, 200, 18)];
        pLable.textAlignment = NSTextAlignmentLeft;
        pLable.backgroundColor = [UIColor clearColor];
        pLable.font = [UIFont systemFontOfSize:12];
        pLable.textColor = COLOR_FONT_3;
        pLable.tag = 1005;
        [pCellObj.contentView addSubview:pLable];
        
        //线条
        UIImageView* pLineView = [[UIImageView alloc] initWithFrame:CGRectMake(105, 0, 1, 30)];
        pLineView.backgroundColor = COLOR_CELL_LINE_DEFAULT;
        pLineView.tag = 2001;
        [pCellObj.contentView addSubview:pLineView];
        
        //圆点
        UIImageView* pPointView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 30, 10, 10)];
        pPointView.image = [UIImage imageNamed:@"point_red.png"];
        pPointView.tag = 2002;
        [pCellObj.contentView addSubview:pPointView];
        
        //
        pLineView = [[UIImageView alloc] initWithFrame:CGRectMake(105, 40, 1, 30)];
        pLineView.backgroundColor = COLOR_CELL_LINE_DEFAULT;
        pLineView.tag = 2003;
        [pCellObj.contentView addSubview:pLineView];
    }
    //日期1
    UILabel*pLabel = (UILabel*)[pCellObj.contentView viewWithTag:1001];
    if(pLabel)
    {
        pLabel.text = [m_pInfoDataSet getFeildValue:indexPath.row andColumn:@"time1"];
        
    }
    //日期2
    pLabel = (UILabel*)[pCellObj.contentView viewWithTag:1002];
    if(pLabel)
    {
        NSString* strTime = [AppInitDataMethod convertToShowTime2:[m_pInfoDataSet getFeildValue:indexPath.row andColumn:@"time2"]];
        pLabel.text = strTime;
        
    }
    
    //还款/回款本金
    pLabel = (UILabel*)[pCellObj.contentView viewWithTag:1003];
    if(pLabel)
    {
        pLabel.text = [NSString stringWithFormat:@"还款本金：%@",[m_pInfoDataSet getFeildValue:indexPath.row andColumn:@"money1"]];

        
    }
    
    //还款/回款利息
    pLabel = (UILabel*)[pCellObj.contentView viewWithTag:1004];
    if(pLabel)
    {
        pLabel.text = [NSString stringWithFormat:@"还款利息：%@",[m_pInfoDataSet getFeildValue:indexPath.row andColumn:@"money2"]];

        
    }
    
    pLabel = (UILabel*)[pCellObj.contentView viewWithTag:1005];
    if(pLabel)
    {
        
        pLabel.text = [NSString stringWithFormat:@"日收益：%@",[m_pInfoDataSet getFeildValue:indexPath.row andColumn:@"money3"]];
        
    }
    

    UIImageView*pLineView1 = (UIImageView*)[pCellObj.contentView viewWithTag:2001];

    if(pLineView1)
    {
        if(indexPath.row == 0)
        {
            [pLineView1 setHidden:YES];
        }
        else
        {
            [pLineView1 setHidden:NO];
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
