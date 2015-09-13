//
//  DDIntegralInfoPageView.m
//  我的叮叮 - 积分管理
//
//  Created by lzq on 2014-11-19
//
//

#import "DDIntegralInfoPageView.h"
#import "CKKit.h"
#import "UIOwnSkin.h"
#import "GlobalDefine.h"
#import "DDIntegralCityPageView.h"
#import "JsonXmlParserObj.h"
#import "UaConfiguration.h"
#import "AppInitDataMethod.h"


@interface DDIntegralInfoPageView ()

@end

@implementation DDIntegralInfoPageView

@synthesize m_uiMainTableView = _uiMainTableView;
@synthesize m_iTotalIntegralValue = _iTotalIntegralValue;

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
    NSString* strTitle= @"积分";

    self.navigationItem.titleView = [UIOwnSkin navibarTitleView:strTitle andFrame:CGRectMake(0, 0, 100, 40)];
    
    _uiMainTableView = nil;
    
    //左边返回按钮
    self.navigationItem.leftBarButtonItem = [UIOwnSkin backItemTarget:self action:@selector(backNavButtonAction:)];
    //

    m_pNavItemView = [[RightNavItemView alloc] initWithFrame:CGRectMake(270, 0, 40, 30) andType:1];
    UIBarButtonItem* pRightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:m_pNavItemView];
    m_pNavItemView.m_pNavItemDelegate = self;
    [m_pNavItemView setItemTitle:@"积分商城"];
    self.navigationItem.rightBarButtonItem = pRightBtnItem;
    
    [super viewDidLoad];
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
    
    [self loadIntegralllInfo_Web];

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


//获取积分信息
-(void)loadIntegralllInfo_Web
{
    
    CKHttpHelper* pHttpHelper = [CKHttpHelper httpHelperWithOwner:self];
    pHttpHelper.m_iWebServerType = 1;
    pHttpHelper.methodType  = CKHttpMethodTypePost_Page;
    
    [pHttpHelper clearParams];
    //专业市场的id
    [pHttpHelper setMethodName:[NSString stringWithFormat:@"memberInfo/queryIntegralList"]];
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
         
         QDataSetObj* pDataSet = [pJsonObj parsetoDataSet:@"integralList"];
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



#pragma mark -UITableView delegate and datasource

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
        return 80;
    return 50;
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
    {
        return 1;
    }
    return [m_pInfoDataSet getRowCount]+1;

    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(UITableViewCell*)getJifenTopBarTableCell:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath
{
    NSString* strGetJifenTopBarTableCell = @"GetJifenTopBarTableCellId";
    UITableViewCell *pCellObj = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:strGetJifenTopBarTableCell];
    if (!pCellObj)
    {
        pCellObj = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strGetJifenTopBarTableCell];
        pCellObj.contentView.backgroundColor = COLOR_VIEW_BK_03;
        pCellObj.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel* pLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 80, 25)];
        pLable.textAlignment = NSTextAlignmentRight;
        pLable.backgroundColor = [UIColor clearColor];
        pLable.font = [UIFont boldSystemFontOfSize:20];
        pLable.textColor = [UIColor whiteColor];
        pLable.text = @"总积分";
        pLable.tag = 1001;
        [pCellObj.contentView addSubview:pLable];
        

        pLable = [[UILabel alloc] initWithFrame:CGRectMake(110, 40, 200, 30)];
        pLable.textAlignment = NSTextAlignmentRight;
        pLable.backgroundColor = [UIColor clearColor];
        pLable.font = [UIFont boldSystemFontOfSize:26];
        pLable.textColor = [UIColor whiteColor];
        //pLable.text = @"500";
        pLable.tag = 1002;
        [pCellObj.contentView addSubview:pLable];
        
    }
    UILabel* pLabel = (UILabel*)[pCellObj.contentView viewWithTag:1002];
    if(pLabel)
    {
        pLabel.text = [NSString stringWithFormat:@"%d",_iTotalIntegralValue];
    }
     
    return pCellObj;
}

//加载cell
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell* pCellObj = nil;
    if(indexPath.row == 0)
    {
        pCellObj = [self getJifenTopBarTableCell:tableView indexPath:indexPath];
        return pCellObj;
    }
    static NSString *strJifenInfoCellId = @"JifenInfoCellId";
    pCellObj = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:strJifenInfoCellId];
    
    if (!pCellObj)
    {
        pCellObj = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strJifenInfoCellId];
        pCellObj.contentView.backgroundColor = [UIColor whiteColor];
        pCellObj.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //日期
        UILabel* pLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 9, 80, 32)];
        pLable.textAlignment = NSTextAlignmentCenter;
        pLable.backgroundColor = [UIColor clearColor];
        pLable.font = [UIFont systemFontOfSize:12];
        pLable.textColor = COLOR_FONT_2;
        pLable.text = @"";
        pLable.tag = 1001;
        pLable.numberOfLines = 0;
        [pCellObj.contentView addSubview:pLable];
        
        //日志信息
        pLable = [[UILabel alloc] initWithFrame:CGRectMake(110, 9, 200, 32)];
        pLable.backgroundColor = [UIColor clearColor];
        pLable.font = [UIFont systemFontOfSize:12];
        pLable.textColor = COLOR_FONT_2;
        pLable.tag = 1002;
        pLable.textAlignment = NSTextAlignmentLeft;
        pLable.numberOfLines = 0;
        [pCellObj.contentView addSubview:pLable];
        
        
        //圆点上部分的线条
        UIImageView* pLineView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 0, 1, 20)];
        pLineView.backgroundColor = COLOR_CELL_LINE_DEFAULT;
        pLineView.tag = 2001;
        [pCellObj.contentView addSubview:pLineView];
        
        
        UIImageView* pPointView = [[UIImageView alloc] initWithFrame:CGRectMake(95, 20, 10, 10)];
        pPointView.tag = 2002;
        [pCellObj.contentView addSubview:pPointView];
        
        //圆点下部分的线条
        pLineView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 30, 1, 20)];
        pLineView.backgroundColor = COLOR_CELL_LINE_DEFAULT;
        pLineView.tag = 2003;
        [pCellObj.contentView addSubview:pLineView];
        
    }
    int iDataRow = indexPath.row - 1;
    UILabel*pLabel1 = (UILabel*)[pCellObj.contentView viewWithTag:1001];
    if(pLabel1)
    {
        pLabel1.text = [AppInitDataMethod convertToShowTime2:[m_pInfoDataSet getFeildValue:iDataRow andColumn:@"createTime"]];
        
    }
    UILabel* pLabel2 = (UILabel*)[pCellObj.contentView viewWithTag:1002];
    if(pLabel2)
    {
        pLabel2.text = [NSString stringWithFormat:@"%@：%@",[m_pInfoDataSet getFeildValue:iDataRow andColumn:@"notes"],[m_pInfoDataSet getFeildValue:iDataRow andColumn:@"integralAmount"]];
        
    }
    
    
    UIImageView*pLineView = (UIImageView*)[pCellObj.contentView viewWithTag:2001];
    UIImageView*pPointView = (UIImageView*)[pCellObj.contentView viewWithTag:2002];
    if(pPointView ==nil || pLineView ==nil)
        return pCellObj;
    
    CGRect rcLine = pLineView.frame;
    if(indexPath.row == 1)
    {
        pLineView.hidden = YES;
        pPointView.image = [UIImage imageNamed:@"point_red.png"];
        pLabel1.textColor = COLOR_FONT_5;
        pLabel2.textColor = COLOR_FONT_5;
    }
    else
    {
        pLineView.hidden = NO;
        pPointView.image = [UIImage imageNamed:@"point_gray.png"];
        pLabel1.textColor = COLOR_FONT_2;
        pLabel2.textColor = COLOR_FONT_2;
    }
    pLineView.frame = rcLine;

    return pCellObj;

    
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma RightNavItemViewDelegate

//点击积分商城
-(void)actionRightNavItemClicked:(id)Sender
{
    DDIntegralCityPageView* pCityView = [[DDIntegralCityPageView alloc] init];
    pCityView.hidesBottomBarWhenPushed = YES;
    pCityView.m_iUserTotalJifen = _iTotalIntegralValue;
    [self.navigationController pushViewController:pCityView animated:YES];
}

@end
