//
//  Car_LoanProjectInfoView.m
//
//  汽车贷款-产品详情-项目描述

//  Created by lzq on 2014-06-03.


#import "Car_LoanProjectInfoView.h"
#import "UaConfiguration.h"
#import "UIOwnSkin.h"
#import "CKHttpHelper.h"
#import "GlobalDefine.h"
#import "CKHttpImageHelper.h"
#import "AppInitDataMethod.h"
#import "UILabel+CKKit.h"
#import "JsonXmlParserObj.h"

@interface Car_LoanProjectInfoView ()

@end

@implementation Car_LoanProjectInfoView

@synthesize m_uiMainTableView = _uiMainTableView;
@synthesize m_strProductId = _strProductId;

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
	self.navigationController.navigationBarHidden = NO;

    _uiMainTableView = nil;
    m_strTotalMoney = @"";
    m_iImageCount = 0;
    //设置导航条信息
    [self initNavigationItem];
    //显示初始化数据
    [super viewDidLoad];

    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self initTableView];
        
}

-(void)viewDidAppear:(BOOL)animated
{

}


//初始化视图
-(void)initTableView
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
    [self downLoadLoanProjectMemo_Web];
}

//导航条设置
-(void)initNavigationItem
{

    self.navigationController.navigationBar.translucent = NO;
    
    //标题
    self.navigationItem.titleView = [UIOwnSkin navibarTitleView:@"项目描述" andFrame:CGRectMake(0, 0, 100, 40)];
    //左边返回按钮
    self.navigationItem.leftBarButtonItem = [UIOwnSkin backItemTarget:self action:@selector(backNavButtonAction:)];
    

}

-(void)backNavButtonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}



//从服务端获信息详情
-(void)downLoadLoanProjectMemo_Web
{

 
    CKHttpHelper *pHttpHelper = [CKHttpHelper httpHelperWithOwner:self];
    pHttpHelper.m_iWebServerType = 1;
    pHttpHelper.methodType = CKHttpMethodTypePost_Page;
    //设置webservice方法名
    [pHttpHelper setMethodName:@"productInfo/queryDescrip"];
     //sid
    [pHttpHelper addParam:_strProductId forName:@"productId"];
    //
    //设置结束block（webservice方法结束后，会自动调用）
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
         if(pDataSet == nil)
             return;
         if([pDataSet getRowCount] < 1)
             return;
         
         m_strProjectMemo = [pDataSet getFeildValue:0 andColumn:@"notes"];
         
         m_strLinkAddrInfo = [pDataSet getFeildValue:0 andColumn:@"borrowAddress"];
         m_strMoneyUseType = [pDataSet getFeildValue:0 andColumn:@"moneyUsr"];
         m_strTotalMoney = [pDataSet getFeildValue:0 andColumn:@"hasFinancingAmount"];

         //加载图片
         m_iImageCount = 0;
         NSString* strImgCount = [pDataSet getFeildValue:0 andColumn:@"images_count"];
         int iImageCount = [QDataSetObj convertToInt:strImgCount];
         if(iImageCount < 1)
         {
             [_uiMainTableView reloadData];
             return;
         }
         
         CKHttpImageHelper* pImageHelper = [CKHttpImageHelper httpHelperWithOwner:self];
         for(int i=0;i<iImageCount;i++)
         {
             NSString* strImgUrl = [pDataSet getFeildValue:0 andColumn:[NSString stringWithFormat:@"images_iamgeName_%d",i]];
             if(strImgUrl.length < 1)
                 continue;
             strImgUrl = [AppInitDataMethod getImageFullUrlPath:strImgUrl andImgFlag:0];
             NSURL *nsImageReqUrl = [NSURL URLWithString:strImgUrl];
             m_iImageCount++;
             [pImageHelper addImageUrl:nsImageReqUrl forKey:[NSString stringWithFormat:@"%d",m_iImageCount]];
             
         }
        [_uiMainTableView reloadData];
         //
         [pImageHelper startWithReceiveBlock:^(UIImage *image,NSString *strKey,BOOL finsh)
          {

              if(image == nil || strKey == nil)
                  return ;
              
              [m_muImageDcit setObject:image forKey:strKey];

              int iKey = [QDataSetObj convertToInt:strKey];
              
              NSIndexPath* indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
              UITableViewCell* pCellObj = [_uiMainTableView cellForRowAtIndexPath:indexPath];
              if(pCellObj)
              {
                  UIImageView* pImgView = (UIImageView*)[pCellObj.contentView viewWithTag:2000+iKey];
                  if(pImgView)
                      pImgView.image = image;
              }
              
          }];

     }];
    [pHttpHelper setStartBlock:^{
        [SVProgressHUD showWithStatus:HINT_WEBDATA_LOADING ];
    }];
    //开始连接
    [pHttpHelper start];

}

//获取整个cell的高度
-(int)getCellTotalHeight
{
    //一、计算地址的高度
    int iAddrHei = [UILabel getFitTextHeightWithText:m_strLinkAddrInfo andWidth:200 andFont:[UIFont systemFontOfSize:14]]-8;
    //二、计算项目描述的高度
    int iMemoHei = [UILabel getFitTextHeightWithText:m_strProjectMemo andWidth:280 andFont:[UIFont systemFontOfSize:14]] - 8;
    
    //三、计算总的高度
    int iTotalHei = 20+20+iAddrHei+40+10+iMemoHei+10+30;
    
    int iImgHei = m_iImageCount*180;
    
    iTotalHei+=iImgHei;
    return iTotalHei;
}


#pragma mark -UITableView delegate and datasource


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}


//加载cell
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    
    static NSString *strLoanProjectMemoCellId = @"LoanProjectMemoCellId";
    UITableViewCell *pCellObj = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:strLoanProjectMemoCellId];
    
    if (!pCellObj)
    {
        pCellObj = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strLoanProjectMemoCellId];
        pCellObj.contentView.backgroundColor = [UIColor whiteColor];
        pCellObj.selectionStyle = UITableViewCellSelectionStyleNone;
        int iCellHeight = [self getCellTotalHeight];
        
        UIView* pBkView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width-20, iCellHeight)];
        pBkView.backgroundColor = [UIColor whiteColor];
        pBkView.layer.borderWidth = 1.0f;
        pBkView.layer.borderColor = COLOR_BTN_BORDER_1.CGColor;
        pBkView.layer.cornerRadius = 5.0f;
        [pCellObj.contentView addSubview:pBkView];
        
        //融资金额
        UILabel* pLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 280, 20)];
        pLable.textAlignment = NSTextAlignmentLeft;
        pLable.backgroundColor = [UIColor clearColor];
        pLable.font = [UIFont systemFontOfSize:14];
        pLable.textColor = COLOR_FONT_1;
        pLable.tag = 1001;
        pLable.attributedText = [AppInitDataMethod getLabelAttributedString_Other:[NSString stringWithFormat:@"融资金额：%@",m_strTotalMoney] andOther:m_strTotalMoney];
        [pBkView addSubview:pLable];
        
        
        //借款方地址
        pLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 35, 85, 20)];
        pLable.backgroundColor = [UIColor clearColor];
        pLable.font = [UIFont systemFontOfSize:14];
        pLable.textColor = COLOR_FONT_1;
        pLable.text = @"借款方地址：";
        [pBkView addSubview:pLable];
        
        //计算详细地址的高度
        int iAddrHei = [UILabel getFitTextHeightWithText:m_strLinkAddrInfo andWidth:200 andFont:[UIFont systemFontOfSize:14]]-8;
        pLable = [[UILabel alloc] initWithFrame:CGRectMake(95, 35, 190, iAddrHei)];
        pLable.backgroundColor = [UIColor clearColor];
        pLable.font = [UIFont systemFontOfSize:14];
        pLable.numberOfLines = 0;
        pLable.textAlignment = UITextAlignmentLeft;
        pLable.textColor = COLOR_FONT_2;
        pLable.text = m_strLinkAddrInfo;
        [pBkView addSubview:pLable];
        
        int iTopY = 35+iAddrHei+5;
        //资金用途
        pLable = [[UILabel alloc] initWithFrame:CGRectMake(10, iTopY, 280, 20)];
        pLable.textAlignment = NSTextAlignmentLeft;
        pLable.backgroundColor = [UIColor clearColor];
        pLable.font = [UIFont systemFontOfSize:14];
        pLable.textColor = COLOR_FONT_1;
        pLable.attributedText = [AppInitDataMethod getLabelAttributedString_Other:[NSString stringWithFormat:@"资金用途：%@",m_strMoneyUseType] andOther:m_strMoneyUseType];
        [pBkView addSubview:pLable];
        
        iTopY = iTopY+20+10;
        //线条
        UIImageView* pLineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, iTopY, 280, 1)];
        pLineImageView.backgroundColor = COLOR_CELL_LINE_DEFAULT;
        [pBkView addSubview:pLineImageView];
        
        //项目描述
        iTopY = iTopY+10;
        pLable = [[UILabel alloc] initWithFrame:CGRectMake(10, iTopY, 100, 20)];
        pLable.backgroundColor = [UIColor clearColor];
        pLable.font = [UIFont systemFontOfSize:14];
        pLable.textColor = COLOR_FONT_6;
        pLable.text = @"项目背景";
        [pBkView addSubview:pLable];
        
        
        //具体的描述信息
        iTopY = iTopY+20+10;
        int iMemoHei = [UILabel getFitTextHeightWithText:m_strProjectMemo andWidth:280 andFont:[UIFont systemFontOfSize:14]] - 8;
        pLable = [[UILabel alloc] initWithFrame:CGRectMake(10, iTopY, 280, iMemoHei)];
        pLable.backgroundColor = [UIColor clearColor];
        pLable.font = [UIFont systemFontOfSize:14];
        pLable.textColor = COLOR_FONT_2;
        pLable.numberOfLines = 0;
        pLable.text = m_strProjectMemo;
        [pBkView addSubview:pLable];
        
        //显示身份证
        iTopY = iTopY+iMemoHei+10;
        
        for(int i=0;i<m_iImageCount;i++)
        {
            UIImageView*pImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, iTopY, 280, 170)];
            
            UIImage* pImage = [m_muImageDcit objectForKey:[NSString stringWithFormat:@"%d",i+1]];
            if(pImage)
                pImageView.image = pImage;
            else
            {
                pImageView.image = [UIImage imageNamed:LOADING_IMAGE_NAME];
            }
            pImageView.tag = 2000+i+1;
            [pBkView addSubview:pImageView];
            iTopY+=180;
        }
    
    }
    return pCellObj;

}



-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    int iCellHeight = [self getCellTotalHeight];
    iCellHeight = iCellHeight + 20;
    return iCellHeight;
}

//4个Section
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(m_strTotalMoney.length < 1)
        return 0;
    return 1;
}


//4行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 1;
    
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{

}



@end
