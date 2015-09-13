//
//  UserMessageInfoListPageView.h

//
//  Created by lzq on 2014-03-10.
//

#import "UserMessageInfoListPageView.h"
#import "UaConfiguration.h"
#import "UIOwnSkin.h"
#import "GlobalDefine.h"
#import "CKHttpHelper.h"
#import "UIColor+Hex.h"
#import "UserSendMessagePageView.h"
#import "CKHttpImageHelper.h"
#import "CSjqMessageObj.h"

@interface UserMessageInfoListPageView ()

@end

@implementation UserMessageInfoListPageView

@synthesize m_uiMessageTable = _uiMessageTable;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)dealloc
{
 //   [WebServiceHelper removeAllServicesFromController:self];
}

- (void)viewDidLoad
{
    self.navigationController.navigationBar.translucent = NO;
    //标题
    self.navigationItem.titleView = [UIOwnSkin navibarTitleView:@"我的消息" andFrame:CGRectMake(0, 0, 100, 40)];
    //左边导航返回
    self.navigationItem.leftBarButtonItem = [UIOwnSkin backItemTarget:self action:@selector(backNavButtonAction:)];
    m_muImageListDic = [[NSMutableDictionary alloc] init];
    m_blNeedRefresh = false;
    m_pMsgDataSet = nil;
    m_pImgHelper = nil;
    [super viewDidLoad];
    [SVProgressHUD showWithStatus:@"正在加载，请稍后..."];
    [self getUserMessageList_Web:0];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    if(m_blNeedRefresh == false)
        return;
    //如果需要刷新，则重新加载数据
    [self getUserMessageList_Web:1];

}

-(void)viewDidAppear:(BOOL)animated
{
 }

-(IBAction)backNavButtonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

//从服务端下载用户所有的消息列表
-(void)getUserMessageList_Web:(NSInteger)iLoadFlag
{
    if(m_isLoading == true)
        return;
    if(iLoadFlag == 1)//重新加载
    {
        //追加数据就不需要判断
        if(m_pImgHelper != nil)
        {
            int iLeftCount = [m_pImgHelper getLeftCount ];
            if(iLeftCount > 0)
            {
                [m_pImgHelper cancel];
                m_pImgHelper = nil;
            }
        }
        
        m_iCurPageID = 0;
        m_isToEndPage = NO;
        if([m_pMsgDataSet getRowCount] > 0)
        {
            m_pMsgDataSet = nil;
            m_pMsgDataSet = [[QDataSetObj alloc] init];
        }
    }
    
    CKHttpHelper*pHttpHelper = [CKHttpHelper httpHelperWithOwner:self];
    pHttpHelper.m_iWebServerType = 1;
    pHttpHelper.methodType  = CKHttpMethodTypePost_Page;
    [pHttpHelper setMethodName:[NSString stringWithFormat:@"user.getSessionList"]];
    [pHttpHelper addParam:[UaConfiguration sharedInstance].m_setLoginState.m_strUserLoginSid forName:@"sid"];
    m_iCurPageID++;
    [pHttpHelper addParam:[NSString stringWithFormat:@"%d",m_iCurPageID] forName:@"page"];
    
    [pHttpHelper setCompleteBlock:^(id dataSet)
     {
         [SVProgressHUD dismiss];
         m_isLoading = false;
         if(dataSet == nil)
         {
             [SVProgressHUD showErrorWithStatus:HINT_WEBDATA_NET_ERROR duration:1.8];
             return ;
         }
         int iRowCount = [dataSet getRowCount];
         if(iRowCount < 1)
         {
             m_isToEndPage = YES;
             return;
         }
         if(iRowCount < 10)
         {
             m_isToEndPage = YES;
         }
         if(m_pMsgDataSet == nil)
         {
             m_pMsgDataSet = [[QDataSetObj alloc] init];
         }
         if(m_pImgHelper == nil)
             m_pImgHelper = [[CKHttpImageHelper alloc] initWithOwner:self];
         for(int i=0;i<iRowCount;i++)
         {
             SetRowObj *pRowObj = [dataSet getRowObj:i];
             if(pRowObj == nil)
                 continue;
             [m_pMsgDataSet addDataSetRow:pRowObj];
             NSString* strImageUrl = [m_pMsgDataSet getFeildValue:i andColumn:@"fromHeadUrl"];
             if(strImageUrl.length < 1)
             {
                 continue;
             }
             
             NSURL *nsImageReqUrl = [NSURL URLWithString:strImageUrl];
             if(nsImageReqUrl == nil)
                 continue;
             NSString* strKey = [NSString stringWithFormat:@"%d",[m_pMsgDataSet getRowCount]];
             [m_pImgHelper addImageUrl:nsImageReqUrl forKey:strKey];
             
         }
         //重新加载
         [_uiMessageTable reloadData];
         //
         [m_pImgHelper startWithReceiveBlock:^(UIImage *pImage,NSString *strKey,BOOL blFinsh)
          {
              if(pImage  == nil || strKey == nil)
                  return ;
              int iRow = strKey.intValue - 1;
              [m_muImageListDic setObject:pImage forKey:strKey];
              
              NSIndexPath* indexPath = [NSIndexPath indexPathForRow:iRow inSection:0];
              UITableViewCell* pCellObj = [_uiMessageTable cellForRowAtIndexPath:indexPath];
              if(pCellObj == nil)
                  return;
              UIImageView* pHeadView = (UIImageView*)[pCellObj.contentView viewWithTag:1001];
              if(pHeadView == nil)
                  return;
              pHeadView.image = pImage;
          }];
         

     }];
    [pHttpHelper setStartBlock:^{
        [SVProgressHUD showErrorWithStatus:HINT_WEBDATA_LOADING];
    }];
    m_isLoading = YES;
    [pHttpHelper start];
    
    
}


//从本地数据库中读取相关的消息列表
/*
-(void)getUserMessageList_Local
{
    CSjqMessageObj* pSjqMessage = [[CSjqMessageObj alloc] init];
    m_pMsgDataSet = [pSjqMessage getMessageListOrderUser];
    if(m_pMsgDataSet == nil)
        return;
    if([m_pMsgDataSet getRowCount] < 1)
        return;

    CKHttpImageHelper* pImageHelper = [[CKHttpImageHelper alloc] initWithOwner:self];
    int iImageCount = [m_pMsgDataSet getRowCount];
    int iBeg = 0;
    if([UaConfiguration sharedInstance].m_pUserHeadImage == nil)
    {
        iBeg = -1;
    }
    
    for(int i=iBeg;i<iImageCount;i++)
    {
        NSString* strImageUrl = @"";
        if(i == -1)
        {
            strImageUrl = [m_pMsgDataSet getFeildValue:0 andColumn:@"userHeadUrl"];
        }
        else
        {
            strImageUrl = [m_pMsgDataSet getFeildValue:i andColumn:@"friendHeadUrl"];

        }
        
        if(strImageUrl.length < 1)
        {
            continue;
        }
        NSURL *nsImageReqUrl = [NSURL URLWithString:strImageUrl];
        if(nsImageReqUrl == nil)
            continue;
        NSString* strKey = [NSString stringWithFormat:@"%d",i+1];
        [pImageHelper addImageUrl:nsImageReqUrl forKey:strKey];

    }
    [_uiMessageTable reloadData];
    //
    [pImageHelper startWithReceiveBlock:^(UIImage *pImage,NSString *strKey,BOOL blFinsh)
    {
             if(pImage  == nil || strKey == nil)
                 return ;
             int iRow = strKey.intValue - 1;
             if(iRow < 0)
             {
                 [UaConfiguration sharedInstance].m_pUserHeadImage = pImage;
                 return;
             }
             [m_muImageListDic setObject:pImage forKey:strKey];
             NSIndexPath* indexPath = [NSIndexPath indexPathForRow:iRow inSection:0];
             UITableViewCell* pCellObj = [_uiMessageTable cellForRowAtIndexPath:indexPath];

             if(pCellObj == nil)
                 return;
             UIImageView* pHeadView = (UIImageView*)[pCellObj.contentView viewWithTag:1001];
             if(pHeadView == nil)
                 return;
             pHeadView.image = pImage;
    }];
 
}
*/
#pragma mark -about UITableView datasource and delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row >= [m_pMsgDataSet getRowCount])
        return;
    
    NSString* strFromUser = [m_pMsgDataSet getFeildValue:indexPath.row andColumn:@"from"];
    NSString* strToUser = [m_pMsgDataSet getFeildValue:indexPath.row andColumn:@"to"];
    NSString* strFriendId = @"";
    NSString* strMsgType = [m_pMsgDataSet getFeildValue:indexPath.row andColumn:@"msgType"];
    int iMsgType = [QDataSetObj convertToInt:strMsgType];
    if(iMsgType == 2)
        strFriendId = FROM_ID_SYSTEM;
    else if(iMsgType  == 3)
        strFriendId = FROM_ID_PUBLIC;
    else
    {
        if([[UaConfiguration sharedInstance].m_setLoginState isLoginUser:strToUser] == true)
        {
            strFriendId = strFromUser;
        }
        else  if([[UaConfiguration sharedInstance].m_setLoginState isLoginUser:strFromUser] == true)
        {
            strFriendId = strToUser;
        }
    }

    if(strFriendId.length < 1)
        return;
    
    SetRowObj* pOneMsgSetRow = nil;
    if(iMsgType > 1)
    {
        pOneMsgSetRow = [[SetRowObj alloc] init];
        [pOneMsgSetRow addFieldObj:@"showTime" andValue:[m_pMsgDataSet getFeildValue:indexPath.row andColumn:@"sendTime"]];
        [pOneMsgSetRow addFieldObj:@"messageInfo" andValue:[m_pMsgDataSet getFeildValue:indexPath.row andColumn:@"title"]];
        [pOneMsgSetRow addFieldObj:@"messageType" andValue:@"1"];
    }
    
    //发送消息的页面
    UserSendMessagePageView* pSendView = [[UserSendMessagePageView alloc] init];
    pSendView.m_strFriendId = strFriendId;
    pSendView.m_pOneMessageRowSet = pOneMsgSetRow;
    pSendView.m_iMessageType = iMsgType;
    pSendView.m_strSessionId = [m_pMsgDataSet getFeildValue:indexPath.row andColumn:@"id"];
    NSString* strKey = [NSString stringWithFormat:@"%d",indexPath.row+1];
    NSString* strFriendHeadImgUrl = @"";
    UIImage* pFriendHeadImage = [m_muImageListDic objectForKey:strKey];
    if(pFriendHeadImage == nil)
    {
       // pFriendHeadImage = [UIImage imageNamed:@"unknowUserHead.png"];
        strFriendHeadImgUrl = [m_pMsgDataSet getFeildValue:indexPath.row andColumn:@"fromHeadUrl"];
    }
    pSendView.m_pFriendHeadImage = pFriendHeadImage;
    pSendView.m_strFriendHeadImgUrl = strFriendHeadImgUrl;
    pSendView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:pSendView animated:YES];
    m_blNeedRefresh = true;
    
}

//
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(m_pMsgDataSet == nil)
        return  0;
    return [m_pMsgDataSet getRowCount];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* strMessageInfoCellID = @"UserMessageInfoCellId";
    UITableViewCell *pCellObj = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:strMessageInfoCellID];
    if (!pCellObj)
    {
        pCellObj = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strMessageInfoCellID];
        
        //好友头像的图片
        UIImageView*pLogoImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
        pLogoImgView.tag = 1001;
        [pCellObj.contentView addSubview:pLogoImgView];
        
        
        //新消息总数的Label
        [UIOwnSkin createOrangePointLabel:pCellObj andX:42 andY:2 andTag:1003];

        //好友账号
        UILabel *pLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(70, 5, 105, 21)];
        pLabel1.font = [UIFont systemFontOfSize:14.0];
        pLabel1.textColor = COLOR_FONT_1;
        pLabel1.backgroundColor = [UIColor clearColor];
        pLabel1.tag = 1004;
        [pCellObj.contentView addSubview:pLabel1];
        
        //消息时间
        UILabel *pLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(180, 5, 130, 21)];
        pLabel2.font = [UIFont systemFontOfSize:14.0];
        pLabel2.textColor = COLOR_FONT_2;
        pLabel2.backgroundColor = [UIColor clearColor];
        pLabel2.tag = 1005;
        pLabel2.textAlignment = UITextAlignmentRight;
        [pCellObj.contentView addSubview:pLabel2];
        
        //消息内容
        UILabel *pLabel3 = [[UILabel alloc]initWithFrame:CGRectMake(70, 26, 240, 42)];
        pLabel3.font = [UIFont systemFontOfSize:14.0];
        pLabel3.textColor = COLOR_FONT_2;
        pLabel3.backgroundColor = [UIColor clearColor];
        pLabel3.tag = 1006;
        pLabel3.textAlignment = UITextAlignmentLeft;
        pLabel3.numberOfLines  =0;
        [pCellObj.contentView addSubview:pLabel3];

        //每个Cell之间的线条
        UIImageView* pLineView = [[UIImageView alloc] initWithFrame:CGRectMake(0,79, 320, 1)];
        pLineView.image = [UIImage imageNamed:@"cell_pot_line.png"];
        [pCellObj.contentView addSubview:pLineView];
         pCellObj.selectionStyle = UITableViewCellSelectionStyleNone;       
    }
    
    //一、设置好友的logo
    UIImageView*pLogoView = (UIImageView*)[pCellObj.contentView viewWithTag:1001];
    if(pLogoView == nil)
        return  pCellObj;
    NSString* strKey = [NSString stringWithFormat:@"%d",indexPath.row+1];
    UIImage* pHeadImage = [m_muImageListDic objectForKey:strKey];
    if(pHeadImage == nil)
    {
        pHeadImage = [UIImage imageNamed:@"unknowUserHead.png"];
    }
    pLogoView.image = pHeadImage;
    
    //二、好友的账号
    UILabel*pLabel = (UILabel*)[pCellObj viewWithTag:1004];
    if(pLabel)
    {
        NSString* strFriendId = @"";
        NSString* strFromUser = [m_pMsgDataSet getFeildValue:indexPath.row andColumn:@"from"];
        NSString* strToUser = [m_pMsgDataSet getFeildValue:indexPath.row andColumn:@"to"];
        if([[UaConfiguration sharedInstance].m_setLoginState isLoginUser:strToUser] == true)
        {
            strFriendId = strFromUser;
        }
        else if([[UaConfiguration sharedInstance].m_setLoginState isLoginUser:strFromUser] == true)
        {
            strFriendId = strToUser;
        }
       /*
        if([strFriendId isEqualToString:FROM_ID_SYSTEM] == true)
        {
            strFriendId = @"系统消息";
        }
        else if([strFriendId isEqualToString:FROM_ID_PUBLIC] == true)
        {
            strFriendId = @"公共消息";
        }*/
        pLabel.text = strFriendId;
    }
    //三、发送时间
    pLabel = (UILabel*)[pCellObj viewWithTag:1005];
    if(pLabel)
    {
        pLabel.text = [m_pMsgDataSet getFeildValue:indexPath.row andColumn:@"sendTime"];
    }
    //四、未读消息总数
    NSString* strNewMessageCount = [m_pMsgDataSet getFeildValue:indexPath.row andColumn:@"newMsgNum"];
    [UIOwnSkin setOrangePointLabelText:pCellObj andText:strNewMessageCount andTag:1003];
    //五、消息内容
    pLabel = (UILabel*)[pCellObj viewWithTag:1006];
    if(pLabel)
    {
        pLabel.text  = [m_pMsgDataSet getFeildValue:indexPath.row andColumn:@"title"];
    }
    
    return pCellObj;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSInteger iMaxRow = [m_pMsgDataSet getRowCount] - 1;
    if(indexPath.row == iMaxRow)
    {
        if(m_isToEndPage)
        {
            if(m_iCurPageID == 1)
                return;
            [SVProgressHUD showSuccessWithStatus:HINT_LASTEST_PAGE duration:1.8];
            return;
        }
        // m_isClearData = NO;
        [self getUserMessageList_Web:0];
		
    }
    
}

@end
