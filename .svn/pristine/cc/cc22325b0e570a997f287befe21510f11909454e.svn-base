//
//  DDBankCardInfoPageView.m

//  我的叮叮-账号中心-银行卡管理
//
//  Created on 2014-11-23.
//

#import "DDBankCardInfoPageView.h"
#import "UaConfiguration.h"
#import "UIOwnSkin.h"
#import "CKHttpHelper.h"
#import "CKHttpImageHelper.h"
#import "GlobalDefine.h"
#import "JsonXmlParserObj.h"
#import "AppInitDataMethod.h"

@interface DDBankCardInfoPageView ()

@end

@implementation DDBankCardInfoPageView

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
    self.view.backgroundColor = COLOR_VIEW_BK_01;
    //标题
    self.navigationItem.titleView = [UIOwnSkin navibarTitleView:@"银行卡管理" andFrame:CGRectMake(0, 0, 100, 40)];
    
    //左边返回按钮
    self.navigationItem.leftBarButtonItem = [UIOwnSkin backItemTarget:self action:@selector(backNavButtonAction:)];
    _uiMainTableView = nil;
    
 
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

    [self loadUserBankInfo_Web];
}


-(void)viewDidAppear:(BOOL)animated
{

}


//加载用户的银行卡等信息
-(void)loadUserBankInfo_Web
{
    
    if([UaConfiguration sharedInstance].m_setLoginState.m_strBankCardSno.length > 1)
    {
        return;
    }
    
     CKHttpHelper* pHttpHelper = [CKHttpHelper httpHelperWithOwner:self];
    pHttpHelper.m_iWebServerType = 1;
    pHttpHelper.methodType  = CKHttpMethodTypePost_Page;
    
    //专业市场的id
    [pHttpHelper setMethodName:[NSString stringWithFormat:@"memberInfo/queryUserBank"]];
    [pHttpHelper addParam:[NSString stringWithFormat:@"%d",[UaConfiguration sharedInstance].m_setLoginState.m_iUserMemberID] forName:@"memberId"];

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
         NSString* strBankLogoUrl = @"";
         if(pDataSet != nil)
         {
             [UaConfiguration sharedInstance].m_setLoginState.m_strBankCardId = [pDataSet getFeildValue:0 andColumn:@"bankId"];
             [UaConfiguration sharedInstance].m_setLoginState.m_strBankCardSno = [pDataSet getFeildValue:0 andColumn:@"cardSno"];
             [UaConfiguration sharedInstance].m_setLoginState.m_strBankName = [pDataSet getFeildValue:0 andColumn:@"bankName"];
             strBankLogoUrl = [pDataSet getFeildValue:0 andColumn:@"logo"];
         }
         
         if(strBankLogoUrl.length < 1)
         {
             [_uiMainTableView reloadData];
             return;
         }
         CKHttpImageHelper* pImageHelper = [CKHttpImageHelper httpHelperWithOwner:self];

         strBankLogoUrl = [AppInitDataMethod getImageFullUrlPath:strBankLogoUrl andImgFlag:1];
         NSURL *nsImageReqUrl = [NSURL URLWithString:strBankLogoUrl];

         [pImageHelper addImageUrl:nsImageReqUrl forKey:[NSString stringWithFormat:@"%d",1]];
         
         [_uiMainTableView reloadData];
         //
         [pImageHelper startWithReceiveBlock:^(UIImage *image,NSString *strKey,BOOL finsh)
          {
              
              if(image == nil || strKey == nil)
                  return ;
              
              [UaConfiguration sharedInstance].m_setLoginState.m_pBankLogoImage = image;
              
              NSIndexPath* indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
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
    
    return 150;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}



//
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strBankCardInfoCellId = @"BankCardInfoCellId";
    UITableViewCell *pCellObj = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:strBankCardInfoCellId];
    if (!pCellObj)
    {
        pCellObj = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strBankCardInfoCellId];
        pCellObj.contentView.backgroundColor =  [UIColor whiteColor];
        pCellObj.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        UIView*pTopBarView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 15)];
        pTopBarView.backgroundColor = COLOR_VIEW_BK_01;
        [pCellObj.contentView addSubview:pTopBarView];
        
        UIImageView* pLineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
        pLineView.backgroundColor = COLOR_CELL_LINE_DEFAULT;
        [pTopBarView addSubview:pLineView];
        
        
        pLineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 14, self.view.frame.size.width, 1)];
        pLineView.backgroundColor = COLOR_CELL_LINE_DEFAULT;
        [pTopBarView addSubview:pLineView];
        
        //银行卡的背景视图
        UIView*pCardView = [[UIView alloc] initWithFrame:CGRectMake(20, 37, self.view.frame.size.width-40, 90)];
        pCardView.backgroundColor = COLOR_VIEW_BK_01;
        pCardView.layer.borderColor = COLOR_VIEW_BK_01.CGColor;
        pCardView.layer.borderWidth = 1.0f;
        pCardView.layer.cornerRadius = 5.0f;
        [pCellObj.contentView addSubview:pCardView];
        
        //银行卡的logo
        UIImageView* pLogoImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 13, 25, 25)];
        pLogoImgView.tag = 2001;
        [pCardView addSubview:pLogoImgView];
        
        //银行卡中文名称
        UILabel*pLabel = [[UILabel alloc]initWithFrame:CGRectMake(40,15, 220,20)];
        pLabel.backgroundColor = [UIColor clearColor];
        pLabel.textColor = COLOR_FONT_1;
        
        pLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        pLabel.numberOfLines = 0;
        pLabel.textAlignment  = UITextAlignmentLeft;
        pLabel.tag = 1001;
        [pCardView addSubview:pLabel];
        
        //银行卡英文名称
        /*
        pLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 28, 220, 14)];
        pLabel.textAlignment  = UITextAlignmentLeft;
        pLabel.backgroundColor = [UIColor clearColor];
        pLabel.font = [UIFont systemFontOfSize:10.f];
        pLabel.textColor = [UIColor whiteColor];
        pLabel.tag = 1002;
        [pCardView addSubview:pLabel];
        */
        //卡号
        pLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, 220, 20)];
        pLabel.textAlignment  = UITextAlignmentRight;
        pLabel.backgroundColor = [UIColor clearColor];
        pLabel.font = [UIFont systemFontOfSize:14.f];
        pLabel.textColor = COLOR_FONT_1;
        pLabel.tag = 1003;
        [pCardView addSubview:pLabel];
        
    }
    
    UILabel*pLabel = (UILabel*)[pCellObj.contentView viewWithTag:1001];
    if(pLabel)
    {
        pLabel.text = [UaConfiguration sharedInstance].m_setLoginState.m_strBankName;
    }

    
    pLabel = (UILabel*)[pCellObj.contentView viewWithTag:1003];
    if(pLabel)
    {
        pLabel.text = [UaConfiguration sharedInstance].m_setLoginState.m_strBankCardSno;
    }
    UIImageView*pLogoImgView  = (UIImageView*)[pCellObj.contentView viewWithTag:2001];
    if(pLogoImgView)
    {
        pLogoImgView.image = [UaConfiguration sharedInstance].m_setLoginState.m_pBankLogoImage;
    }
    return pCellObj;
}





@end
