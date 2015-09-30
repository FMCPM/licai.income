//
//  MoreActivityCenterPageView.h
//  更多 - 帮助中心
//
//  Created by lzq on 2014-11-26.

//

#import "MoreHelpCenterInfoPageView.h"
#import <QuartzCore/QuartzCore.h>
#import "UaConfiguration.h"
#import "UIOwnSkin.h"
#import "GlobalDefine.h"
#import "JsonXmlParserObj.h"
#import "UILabel+CKKit.h"

@interface MoreHelpCenterInfoPageView ()

@end

@implementation MoreHelpCenterInfoPageView

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
    self.navigationItem.titleView  = [UIOwnSkin navibarTitleView:@"帮助中心" andFrame:CGRectMake(0, 0, 100, 40)];
    
    //导航返回按钮
    self.navigationItem.leftBarButtonItem = [UIOwnSkin backItemTarget:self action:@selector(backNavButtonAction:)];
    //
    m_pInfoDataSet = nil;

    m_iCurPageID = 0;
    m_isLoading = NO;
    m_isToEndPage = NO;

    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
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
    
    [self getHelpMessageList_Web:0];
}

- (void)backNavButtonAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];    
}


//下载促销信息
-(void)getHelpMessageList_Web:(NSInteger)iLoadFlag
{
    self.view.backgroundColor = [UIColor whiteColor];
 
    if(m_isLoading == YES)
        return;
    if(iLoadFlag == 1)
    {
        m_pInfoDataSet = nil;
        m_pInfoDataSet = [[QDataSetObj alloc] init];
    }

    CKHttpHelper*  pHttpHelper = [CKHttpHelper httpHelperWithOwner:self];
    pHttpHelper.m_iWebServerType = 1;
    pHttpHelper.methodType  = CKHttpMethodTypePost_Page;

    m_iCurPageID++;
    [pHttpHelper setMethodName:[NSString stringWithFormat:@"memberInfo/queryHelpList"]];
    [pHttpHelper addParam:@"10" forName:@"pageB.rowCount"];
    
    [pHttpHelper addParam:[NSString stringWithFormat:@"%d",m_iCurPageID] forName:@"pageB.pageIndex"];

    [pHttpHelper setCompleteBlock:^(id dataSet)
    {
        [SVProgressHUD dismiss];
        m_isLoading = NO;
        m_isToEndPage = YES;
        JsonXmlParserObj* pJsonObj = dataSet;
        if(pJsonObj == nil)
        {
            [SVProgressHUD showErrorWithStatus:HINT_WEBDATA_NET_ERROR duration:1.8];
            return ;
        }
        QDataSetObj*pDataSet = [pJsonObj parsetoDataSet:@"helpList"];
        if(pDataSet == nil)
        {
            [_uiMainTableView reloadData];
            return;
        }
        if(m_pInfoDataSet == nil)
        {
            m_pInfoDataSet = [[QDataSetObj alloc] init];
        }
        if([pDataSet getRowCount] >= 10)
            m_isToEndPage = NO;
        int iAddRow = [m_pInfoDataSet getRowCount];
        for(int i=0;i<[pDataSet getRowCount];i++)
        {
            [m_pInfoDataSet addDataSetRow_Ext:iAddRow andName:@"cellTitle" andValue:[pDataSet getFeildValue:i andColumn:@"helpTitile"]];
            [m_pInfoDataSet addDataSetRow_Ext:iAddRow andName:@"cellMemo" andValue:[pDataSet getFeildValue:i andColumn:@"helpContent"]];
            [m_pInfoDataSet addDataSetRow_Ext:iAddRow andName:@"createDate" andValue:[pDataSet getFeildValue:i andColumn:@"createDate"]];
        }
        
        [_uiMainTableView reloadData];
        
    
    }];
    
    //开始时执行的block
    [pHttpHelper setStartBlock:^{
        [SVProgressHUD showWithStatus:HINT_WEBDATA_LOADING];
    }];
    m_isLoading = YES;
    [pHttpHelper start];

}


//点击促销记录的相关处理（暂时不需要处理）
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    

}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSInteger iMaxRow = [m_pInfoDataSet getRowCount] - 1;
    
    int iRow = indexPath.row;
    if(iRow == iMaxRow)
    {
        if(m_isToEndPage == YES)
        {
            if(m_iCurPageID == 1)
                return;
            [SVProgressHUD showSuccessWithStatus:HINT_LASTEST_PAGE duration:1.8];
            return;
        }
        [self getHelpMessageList_Web:1];
    }

}


//每个section为200高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* strMemo = [m_pInfoDataSet getFeildValue:indexPath.row andColumn:@"cellMemo"];
    int iHeight = [UILabel getFitTextHeightWithText:strMemo andWidth:280 andFont:[UIFont systemFontOfSize:12]];
	
    iHeight += 40;
    
    return iHeight;
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
    static NSString *strHelpInfoCellId = @"HelpInfoCellId";
    UITableViewCell *pCellObj = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:strHelpInfoCellId];
    
    NSString* strMemo = [m_pInfoDataSet getFeildValue:indexPath.row andColumn:@"cellMemo"];
    int iMemoHeight = [UILabel getFitTextHeightWithText:strMemo andWidth:280.0f andFont:[UIFont systemFontOfSize:12]];
    int iCellHeight = iMemoHeight+40;
    
    if (!pCellObj)
    {
        pCellObj = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strHelpInfoCellId];
        pCellObj.contentView.backgroundColor =  [UIColor whiteColor];
        pCellObj.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView*pBkView = [[UIView alloc] initWithFrame:CGRectMake(10,10, 300, iCellHeight-10)];
        pBkView.backgroundColor = [UIColor whiteColor];
        pBkView.tag = 2001;
        pBkView.layer.borderColor = COLOR_BTN_BORDER_1.CGColor;
        pBkView.layer.cornerRadius = 5.0f;
        pBkView.layer.borderWidth = 1.0f;
        [pCellObj.contentView addSubview:pBkView];
        
        //标题
        UILabel*pLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 280, 20)];
        pLabel.backgroundColor = [UIColor clearColor];
        pLabel.textColor = COLOR_FONT_1;
        pLabel.font = [UIFont systemFontOfSize:14];
        pLabel.numberOfLines = 0;
        pLabel.tag = 1001;
       // pLabel.text = @"测试的活动中心的消息";
        pLabel.textAlignment = UITextAlignmentLeft;
        [pBkView addSubview:pLabel];
        
        //具体的信息
        pLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, 280, iMemoHeight)];
        pLabel.backgroundColor = [UIColor clearColor];
        pLabel.textColor = COLOR_FONT_1;
        pLabel.font = [UIFont systemFontOfSize:12];
        pLabel.numberOfLines = 0;
        pLabel.tag = 1002;
        // pLabel.text = @"测试的活动中心的消息";
        pLabel.textAlignment = UITextAlignmentLeft;
        [pBkView addSubview:pLabel];
       
       
    }
    
    UIView* pBackView = [pCellObj.contentView viewWithTag:2001];
    if(pBackView)
    {
        CGRect rcBackView = pBackView.frame;
        rcBackView.size.height = iCellHeight-10;
        pBackView.frame = rcBackView;
    }
    
    UILabel* pLabel = (UILabel*)[pCellObj.contentView viewWithTag:1001];
    if(pLabel)
    {
        pLabel.text = [m_pInfoDataSet getFeildValue:indexPath.row andColumn:@"cellTitle"];
    }
    
    pLabel = (UILabel*)[pCellObj.contentView viewWithTag:1002];
    if(pLabel)
    {
        CGRect rcLabel = pLabel.frame;
        rcLabel.size.height = iMemoHeight;
        pLabel.frame = rcLabel;
        pLabel.text = [m_pInfoDataSet getFeildValue:indexPath.row andColumn:@"cellMemo"];
    }

    
    return pCellObj;

	
}



@end
