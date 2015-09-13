//
//  MoreMessageCenterPageView.h

//  更多 - 消息中心
//
//  Created by lzq  on 2014-11-23.
//

#import "MoreMessageCenterPageView.h"
#import "UaConfiguration.h"
#import "UIOwnSkin.h"
#import "MoreMessageDetailPageView.h"
#import "JsonXmlParserObj.h"
#import "AppInitDataMethod.h"

@interface MoreMessageCenterPageView ()

@end

@implementation MoreMessageCenterPageView

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

    //标题
    self.navigationItem.titleView = [UIOwnSkin navibarTitleView:@"消息中心" andFrame:CGRectMake(0, 0, 100, 40)];
    
    //左边返回按钮
    self.navigationItem.leftBarButtonItem = [UIOwnSkin backItemTarget:self action:@selector(backNavButtonAction:)];
    _uiMainTableView = nil;
    m_pInfoDataSet = [[QDataSetObj alloc] init];
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

    [self loadMessageinfo_Web:0];
}


-(void)viewDidAppear:(BOOL)animated
{

}



//加载系统信息
-(void)loadMessageinfo_Web:(NSInteger)iLoadFlag
{
    if([[UaConfiguration sharedInstance] userIsHaveLoadinSystem] == NO)
    {
        [SVProgressHUD showErrorWithStatus:@"请先登录！" duration:1.8];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    if(m_isLoading == YES)
        return;
    if(iLoadFlag == 1)//重新加载
    {
        
        m_iCurPageId = 0;
        
        if([m_pInfoDataSet getRowCount] > 0)
        {
            m_pInfoDataSet = nil;
            m_pInfoDataSet = [[QDataSetObj alloc] init];
        }

    }
    
    CKHttpHelper* pHttpHelper = [CKHttpHelper httpHelperWithOwner:self];
    pHttpHelper.m_iWebServerType = 1;
    pHttpHelper.methodType  = CKHttpMethodTypePost_Page;
    
    [pHttpHelper clearParams];
    //专业市场的id
    [pHttpHelper setMethodName:[NSString stringWithFormat:@"memberInfo/queryMessageList"]];
    [pHttpHelper addParam:[NSString stringWithFormat:@"%d",[UaConfiguration sharedInstance].m_setLoginState.m_iUserMemberID] forName:@"memberId"];
    [pHttpHelper addParam:@"10" forName:@"pageB.rowCount"];
    m_iCurPageId++;
    [pHttpHelper addParam:[NSString stringWithFormat:@"%d",m_iCurPageId] forName:@"pageB.pageIndex"];

    [pHttpHelper setCompleteBlock:^(id dataSet)
     {
         [SVProgressHUD dismiss];
         m_isLoading = NO;
         m_isToEndPage = YES;
         ;
         JsonXmlParserObj* pJsonObj = dataSet;
         if(pJsonObj == nil)
         {
             [SVProgressHUD showErrorWithStatus:HINT_WEBDATA_NET_ERROR duration:1.8];
             return ;
         }
         QDataSetObj* pDataSet = [pJsonObj parsetoDataSet:@"messageList"];
         if(pDataSet == nil )
         {

             return;
         }
         if([pDataSet getRowCount] >= 10)
         {
             m_isToEndPage = NO;
         }
    
         int iAddRow = [m_pInfoDataSet getRowCount];
         for(int i=0;i<[pDataSet getRowCount];i++)
         {
             [m_pInfoDataSet addDataSetRow_Ext:iAddRow andName:@"messageTitle" andValue:[pDataSet getFeildValue:i andColumn:@"messageTitle"]];
             [m_pInfoDataSet addDataSetRow_Ext:iAddRow andName:@"msgContent" andValue:[pDataSet getFeildValue:i andColumn:@"msgContent"]];
             NSString* strSendTime = [pDataSet getFeildValue:i andColumn:@"sendDate"];
             [m_pInfoDataSet addDataSetRow_Ext:iAddRow andName:@"sendDate" andValue:strSendTime];
             iAddRow++;
         }
         [_uiMainTableView reloadData];
     }];
    
    
    [SVProgressHUD showWithStatus:HINT_WEBDATA_LOADING];

    m_isLoading = YES;
    [pHttpHelper start];
  
    
}


#pragma UITableViewDataSource,UITableViewDelegate

//didSelectRowAtIndexPath
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    MoreMessageDetailPageView* pMsgDetailView = [[MoreMessageDetailPageView alloc] init];
    pMsgDetailView.hidesBottomBarWhenPushed = YES;
    pMsgDetailView.m_strMessageTitle = [m_pInfoDataSet getFeildValue:indexPath.row andColumn:@"messageTitle"];
    pMsgDetailView.m_strMessageContent = [m_pInfoDataSet getFeildValue:indexPath.row andColumn:@"msgContent"];
    pMsgDetailView.m_strMessageSendDate = [m_pInfoDataSet getFeildValue:indexPath.row andColumn:@"sendDate"];
    
    [self.navigationController pushViewController:pMsgDetailView animated:YES];
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(m_pInfoDataSet == nil)
        return 0;
    return [m_pInfoDataSet getRowCount];
}
//
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 60;
}

//
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strMoreMessageInfoCellId = @"MoreMessageInfoCel";
    UITableViewCell *pCellObj = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:strMoreMessageInfoCellId];
    if (!pCellObj)
    {
        pCellObj = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strMoreMessageInfoCellId];
        pCellObj.contentView.backgroundColor =  [UIColor whiteColor];
        pCellObj.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        //产品名称
        UILabel*pLabel = [[UILabel alloc]initWithFrame:CGRectMake(10,8, 160, 21)];
        pLabel.backgroundColor = [UIColor clearColor];
        pLabel.textColor = COLOR_FONT_1;
        
        pLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        pLabel.numberOfLines = 0;
        pLabel.textAlignment  = UITextAlignmentLeft;
        pLabel.tag = 1001;
       // pLabel.text = @"申购成功";
        [pCellObj.contentView addSubview:pLabel];
    
        //
        pLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 35, 280, 12)];
        pLabel.textAlignment  = UITextAlignmentLeft;
        pLabel.backgroundColor = [UIColor clearColor];
        pLabel.font = [UIFont systemFontOfSize:12.0f];
        pLabel.textColor = COLOR_FONT_2;
       // pLabel.text = @"您于2014-11-23申购的贷款已经成功发放";
        pLabel.tag = 1002;
        [pCellObj.contentView addSubview:pLabel];
        
        //
        pLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 8, 140, 14)];
        pLabel.textAlignment  = UITextAlignmentRight;
        pLabel.backgroundColor = [UIColor clearColor];
        pLabel.font = [UIFont systemFontOfSize:11.0f];
        pLabel.textColor = COLOR_FONT_2;
        //pLabel.text = @"2014-11-23";
        pLabel.tag = 1003;
        [pCellObj.contentView addSubview:pLabel];
        
        //
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(300, 25, 7, 12)];
        imageView.image = [UIImage imageNamed:@"cell_arrow.png"];
        [pCellObj.contentView addSubview:imageView];
                
        //
        UIImageView* pLineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 59, self.view.frame.size.width, 1)];
        pLineView.backgroundColor = COLOR_CELL_LINE_DEFAULT;
        [pCellObj.contentView addSubview:pLineView];
        
    }
    int iDataRow = indexPath.row;
    UILabel* pLabel = (UILabel*)[pCellObj.contentView viewWithTag:1001];
    if(pLabel)
    {
        pLabel.text = [m_pInfoDataSet getFeildValue:iDataRow andColumn:@"messageTitle"];
        
    }
    pLabel = (UILabel*)[pCellObj.contentView viewWithTag:1002];
    if(pLabel)
    {
        pLabel.text = [m_pInfoDataSet getFeildValue:iDataRow andColumn:@"msgContent"];
        
    }
   
    pLabel = (UILabel*)[pCellObj.contentView viewWithTag:1003];
    if(pLabel)
    {
        pLabel.text = [m_pInfoDataSet getFeildValue:iDataRow andColumn:@"sendDate"];
        
    }
    
    
    return pCellObj;
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    NSInteger iMaxRow = [m_pInfoDataSet getRowCount] -1 ;
    if(indexPath.row == iMaxRow)
    {
        if(m_isToEndPage)
        {
            if(m_iCurPageId == 1)
                return;
            [SVProgressHUD showSuccessWithStatus:HINT_LASTEST_PAGE duration:1.8];
            return;
        }
        // m_isClearData = NO;
        [self loadMessageinfo_Web:0];
        
    }
}


@end
