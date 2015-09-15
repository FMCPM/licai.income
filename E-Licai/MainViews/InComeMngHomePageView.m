//
//  InComeMngHomePageView.m
//
//  叮叮理财 - 我的叮叮
//
//  Created by lzq on 2014-12-25.


#import "InComeMngHomePageView.h"
#import <QuartzCore/QuartzCore.h>
#import "UIOwnSkin.h"
#import "UaConfiguration.h"
#import "GlobalDefine.h"
#import "MyHoldAssetsPageView.h"
#import "DDBillLeftMoneyPageView.h"
#import "MyDdCenterMidTableCell.h"
#import "MyDdCenterTopTableCell.h"
#import "DDTradeLogPageView.h"
#import "DDBillCenterInfoPageView.h"
#import "DDIntegralInfoPageView.h"
#import "UserRegisterViewController.h"
#import "EAppDelegate.h"
#import "MoreMessageCenterPageView.h"
#import "JsonXmlParserObj.h"
#import "AppInitDataMethod.h"
#import "MoreHelpCenterInfoPageView.h"
#import "MyDdCenterNewMidTableCell.h"
#import "MyDdCenterNewBottomTableCell.h"

@interface InComeMngHomePageView ()

@end

@implementation InComeMngHomePageView
@synthesize m_uiMainTable = _uiMainTable;
@synthesize m_uiTopView = _uiTopView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
        // Custom initialization
       
        
    }
    return self;
}


- (void)viewDidLoad
{
    self.navigationController.navigationBar.translucent = NO;
    
    m_uiNavTitleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    m_uiNavTitleButton.frame = CGRectMake(0, 0, 100, 60);
    
    UILabel* pLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, 100, 16)];
    pLabel.backgroundColor = [UIColor clearColor];
    pLabel.font = [UIFont boldSystemFontOfSize:14];
    pLabel.text = @"账户";
    pLabel.textColor = COLOR_FONT_1;
    pLabel.tag = 1001;
    pLabel.textAlignment = UITextAlignmentCenter;
    [m_uiNavTitleButton addSubview:pLabel];
    
    pLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, 100, 20)];
    pLabel.backgroundColor = [UIColor clearColor];
    pLabel.font = [UIFont boldSystemFontOfSize:12];
   // pLabel.text = @"137****0021";
    pLabel.textColor = COLOR_FONT_2;
    pLabel.tag = 1002;
    pLabel.textAlignment = UITextAlignmentCenter;
    [m_uiNavTitleButton addSubview:pLabel];
    [m_uiNavTitleButton addTarget:self action:@selector(actionViewDDBillCenter:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView* pHalfImgView = [[UIImageView alloc] initWithFrame:CGRectMake(90, 38, 7, 7)];
    pHalfImgView.image = [UIImage imageNamed:@"icon_more_half.png"];
    [m_uiNavTitleButton addSubview:pHalfImgView];
    self.navigationItem.titleView = m_uiNavTitleButton;

	   
    
    //消息
    self.navigationItem.rightBarButtonItem = [UIOwnSkin navTextItemTarget:self action:@selector(actionRightMessageClicked:) text:@"消息" andWidth:40 color:COLOR_FONT_1];
    
    //帮助
    self.navigationItem.leftBarButtonItem = [UIOwnSkin navTextItemTarget:self action:@selector(actionLeftHelpClicked:) text:@"帮助" andWidth:40 color:COLOR_FONT_1];
    //设置背景
    self.view.backgroundColor = COLOR_VIEW_BACKGROUND;
    //m_MyDdInfoData = nil;
    m_iLoadViewFlag = 0;

    [self.m_uiMainTable registerNib:[UINib nibWithNibName:@"MyDdCenterNewMidTableCell" bundle:nil] forCellReuseIdentifier:@"MyDdCenterNewMidTableCell"];
    [self.m_uiMainTable registerNib:[UINib nibWithNibName:@"MyDdCenterNewBottomTableCell" bundle:nil] forCellReuseIdentifier:@"MyDdCenterNewBottomTableCell"];
    
    self.m_uiMainTable.tableFooterView = [[UIView alloc] init];

}

-(void)viewWillAppear:(BOOL)animated
{
	//[self DownLoadIncomeData];

/*改在viewDidAppear里面实现，发现有些操作，不会执行到这个事件
    if([[UaConfiguration sharedInstance] userIsHaveLoadinSystem] == YES)
    {
        m_iLoadViewFlag  = 0;
        [self LoadMyDdDefaultInfo_Web];
        return;
    }

    //未登录，现在统一到登录页面，不需要到注册页面
    if(m_iLoadViewFlag == 0)
    {
        //弹出登录页面
        LoginViewController* pLoginView = [[LoginViewController alloc] init];
        pLoginView.m_iLoadOrigin = 1;
        pLoginView.m_pLoginDelegate = self;
        pLoginView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:pLoginView animated:NO];
        m_iLoadViewFlag = 1;
        return;
    }
    else
    {
        m_iLoadViewFlag  = 0;
        [self setMyDDNavTitleView];
        m_MyDdInfoData = [[QDataSetObj alloc] init];
        [_uiMainTable reloadData];
    }
*/
 
}

-(void)viewDidDisappear:(BOOL)animated
{
    
}

-(void)viewDidAppear:(BOOL)animated
{

    if([[UaConfiguration sharedInstance] userIsHaveLoadinSystem] == YES)
    {
        m_iLoadViewFlag  = 0;
        [self LoadMyDdDefaultInfo_Web];
        return;
    }
    
    //未登录，现在统一到登录页面，不需要到注册页面
    if(m_iLoadViewFlag == 0)
    {
        //弹出登录页面
        LoginViewController* pLoginView = [[LoginViewController alloc] init];
        pLoginView.m_iLoadOrigin = 1;
        pLoginView.m_pLoginDelegate = self;
        pLoginView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:pLoginView animated:YES];
        m_iLoadViewFlag = 1;
        return;
    }
    else
    {
        m_iLoadViewFlag  = 0;
        [self setMyDDNavTitleView];
        m_MyDdInfoData = [[QDataSetObj alloc] init];
        [_uiMainTable reloadData];
    }

}

//右边的消息按钮
-(void)actionRightMessageClicked:(id)sendr
{
	
    MoreMessageCenterPageView* pMoreMsgView = [[MoreMessageCenterPageView alloc] init];
    pMoreMsgView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:pMoreMsgView animated:YES];
}

//帮助
-(void)actionLeftHelpClicked:(id)sender
{
    MoreHelpCenterInfoPageView* pHelpView = [[MoreHelpCenterInfoPageView alloc] init];
    pHelpView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:pHelpView animated:YES];
}

-(void)actionViewDDBillCenter:(id)sender
{
    DDBillCenterInfoPageView* pCenterView = [[DDBillCenterInfoPageView alloc] init];
    pCenterView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:pCenterView animated:YES];
}

//设置我的叮叮导航栏的Title
-(void)setMyDDNavTitleView
{
  
    if(m_uiNavTitleButton == nil)
        return;
    UILabel* pLabel = (UILabel*)[m_uiNavTitleButton viewWithTag:1002];
    if(pLabel)
    {
        if([[UaConfiguration sharedInstance] userIsHaveLoadinSystem] == NO)
        {
            pLabel.text = @"";
        }
        else
        {
            NSString* strPhone = [UaConfiguration sharedInstance].m_setLoginState.m_strUserLoginName;
            
            pLabel.text = [AppInitDataMethod convertToShowPhone:strPhone];
        }


    }
    

}

//获取我的叮叮的默认需要显示的信息
-(void)LoadMyDdDefaultInfo_Web
{
    [self setMyDDNavTitleView];
	CKHttpHelper  *httpHelper = [CKHttpHelper httpHelperWithOwner:self];
	httpHelper.methodType = CKHttpMethodTypePost_Page;
	httpHelper.m_iWebServerType = 1;
	[httpHelper setMethodName:@"productInfo/queryInCome"];
	
	[httpHelper addParam:[NSString stringWithFormat:@"%d",[UaConfiguration sharedInstance].m_setLoginState.m_iUserMemberID] forName:@"memberId"];
	
	[httpHelper setCompleteBlock:^(id data)
	 {
         [SVProgressHUD dismiss];
         JsonXmlParserObj* pJsonObj = data;
         if(pJsonObj == nil)
         {
             [SVProgressHUD showErrorWithStatus:HINT_WEBDATA_NET_ERROR duration:1.8];
             return ;
         }
         if([pJsonObj getOpeResult] == NO)
             return;
         
         m_MyDdInfoData = [pJsonObj parsetoDataSet:@"data"];
        
         [_uiMainTable reloadData];
   
	 }];
    [SVProgressHUD showWithStatus:HINT_WEBDATA_LOADING];
	[httpHelper start];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(m_MyDdInfoData == nil)
        return 0;
	return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 3;
            break;
        case 2:
            return 2;
            break;
            
        default:
            return 0;
            break;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if(indexPath.section == 0 && indexPath.row == 0)
        return 105;
    
	return 50 ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section == 2) {
        return 8;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, self.view.frame.size.width, 8);
    view.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    
    return view;
}

-(UITableViewCell*)getDdTopBarTableCell:(UITableView*)tableView andIndexPath:(NSIndexPath*)indexPath
{
    static NSString *strDdTopBarTableCellId = @"DdTopBarTableCellId";
    MyDdCenterTopTableCell *pCellObj = (MyDdCenterTopTableCell*)[tableView dequeueReusableCellWithIdentifier:strDdTopBarTableCellId];
    if (!pCellObj)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MyDdCenterTopTableCell" owner:self options:nil];
        pCellObj = [nib objectAtIndex:0];
        
        pCellObj.contentView.backgroundColor = [UIColor whiteColor];
        pCellObj.selectionStyle = UITableViewCellSelectionStyleNone;
        [pCellObj initCellDefaultSet];
        
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"MM月dd日"];
    NSString* strTime = [dateFormatter stringFromDate:[NSDate date]];
    pCellObj.m_uiDayInComeHintLabel.text = [NSString stringWithFormat:@"%@收益（元）",strTime];
    
    pCellObj.m_uiDayInComeValueLabel.text = [AppInitDataMethod convertMoneyShow:[m_MyDdInfoData getFeildValue:0 andColumn:@"incomeFee"]];
    
    pCellObj.m_uiTotalInHintLabel.text = @"累计收益（元）";

    pCellObj.m_uiTotalInFalueLabel.text = [AppInitDataMethod convertMoneyShow:[m_MyDdInfoData getFeildValue:0 andColumn:@"inAllfee"]];

    return  pCellObj;
}

-(UITableViewCell*)getDdBottomBarTableCell:(UITableView*)tableView andIndexPath:(NSIndexPath*)indexPath
{
    static NSString *strDdCenterComCellId = @"DdCenterComCellId";
    UITableViewCell *pCellObj = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:strDdCenterComCellId];
    if (pCellObj == nil)
    {
        
        
        pCellObj = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strDdCenterComCellId];
        pCellObj.accessoryType = UITableViewCellAccessoryNone;
        pCellObj.contentView.backgroundColor = COLOR_VIEW_BACKGROUND;
        pCellObj.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView* pBkView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
        pBkView.backgroundColor = [UIColor whiteColor];
        
        [pCellObj.contentView addSubview:pBkView];
        
        
        UILabel *pLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 120, 21)];
        pLabel.textAlignment = NSTextAlignmentLeft;
        pLabel.tag = 1001;
        pLabel.backgroundColor = [UIColor clearColor];
        [pLabel setTextColor:COLOR_FONT_1];
        [pLabel setFont:[UIFont systemFontOfSize:14]];
        [pBkView addSubview:pLabel];
        
        pLabel = [[UILabel alloc]initWithFrame:CGRectMake(200, 10, 100, 20)];
        pLabel.textAlignment = NSTextAlignmentRight;
        pLabel.tag = 1002;
        pLabel.backgroundColor = [UIColor clearColor];
        [pLabel setTextColor:COLOR_FONT_2];
        [pLabel setFont:[UIFont systemFontOfSize:14]];
        [pBkView addSubview:pLabel];
        
    }
    
    UILabel*pLabel1 = (UILabel*)[pCellObj.contentView viewWithTag:1001];
    UILabel*pLabel2 = (UILabel*)[pCellObj.contentView viewWithTag:1002];
    if(pLabel1 == nil || pLabel2 == nil )
        return pCellObj;
    
    if(indexPath.row == 2 )
    {
        pLabel1.text = @"交易记录";
        pLabel2.text = @"查看记录";
        
    }
    
    else if(indexPath.row == 3)
    {
        
        pLabel1.text = @"总积分";
        pLabel2.text = [NSString stringWithFormat:@"%@分",[m_MyDdInfoData getFeildValue:0 andColumn:@"integePoints"]];
    }
    return  pCellObj;
    
}

//
-(UITableViewCell*)getDdMidButtonTableCell:(UITableView*)tableView andIndexPath:(NSIndexPath*)indexPath
{
    static NSString *strDdMidButtonTableCellId = @"DdMidButtonTableCellId";
    MyDdCenterMidTableCell *pCellObj = (MyDdCenterMidTableCell*)[tableView dequeueReusableCellWithIdentifier:strDdMidButtonTableCellId];
    if (!pCellObj)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MyDdCenterMidTableCell" owner:self options:nil];
        pCellObj = [nib objectAtIndex:0];
        
        pCellObj.contentView.backgroundColor = [UIColor whiteColor];
        pCellObj.selectionStyle = UITableViewCellSelectionStyleNone;
        [pCellObj initCellDefaultSet];
        pCellObj.m_pCellDelegate = self;
        
    }

    //持有资产
    NSString* strHoldMoney = [AppInitDataMethod convertMoneyShow:[m_MyDdInfoData getFeildValue:0 andColumn:@"assets"]];

    //账户余额
    NSString*  strLeftMoney= [AppInitDataMethod convertMoneyShow:[m_MyDdInfoData getFeildValue:0 andColumn:@"balance"]];
    
    //总资产
    NSString* strTotalMoney = [NSString stringWithFormat:@"%.2f",[QDataSetObj convertToFloat:strHoldMoney]+[QDataSetObj convertToFloat:strLeftMoney]];
    [pCellObj showMidCellInfo:strTotalMoney andHoldMoney:strHoldMoney andLeftMoney:strLeftMoney];
    return  pCellObj;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* pCellObj = nil;
    if(indexPath.section == 0)
    {
        pCellObj = [self getDdTopBarTableCell:tableView andIndexPath:indexPath];
        return pCellObj;
    }else if(indexPath.section == 1)
    {
        //持有资产
        NSString* strHoldMoney = [AppInitDataMethod convertMoneyShow:[m_MyDdInfoData getFeildValue:0 andColumn:@"assets"]];
        
        //账户余额
        NSString*  strLeftMoney= [AppInitDataMethod convertMoneyShow:[m_MyDdInfoData getFeildValue:0 andColumn:@"balance"]];
        
        //总资产
        NSString* strTotalMoney = [NSString stringWithFormat:@"%.2f",[QDataSetObj convertToFloat:strHoldMoney]+[QDataSetObj convertToFloat:strLeftMoney]];
        
        MyDdCenterNewMidTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyDdCenterNewMidTableCell" forIndexPath:indexPath];
        cell.separatorInset = UIEdgeInsetsMake(0, self.view.frame.size.width/2.0, 0, self.view.frame.size.width/2.0);
        switch (indexPath.row) {
            case 0:
            {
                cell.contentLabel.text = @"总资产(元)";
                cell.moneyLabel.text = strTotalMoney;
                
            }
                break;
            case 1:
            {
                NSMutableAttributedString *attrubutedString = [[NSMutableAttributedString alloc] initWithString:@"持有资产(元)(含未结算受益)"];

                [attrubutedString addAttribute:NSForegroundColorAttributeName value:COLOR_FONT_2 range:NSMakeRange(7, 8)];
                [attrubutedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0f] range:NSMakeRange(7, 8)];

                cell.contentLabel.attributedText = attrubutedString;
                cell.moneyLabel.text = strHoldMoney;
            }
                break;
            case 2:
            {
                cell.contentLabel.text = @"账户余额(元)";
                cell.moneyLabel.text = strLeftMoney;
            }
                break;
        }
        
        return cell;
    } else if (indexPath.section == 2) {
        MyDdCenterNewBottomTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyDdCenterNewBottomTableCell" forIndexPath:indexPath];
        
        switch (indexPath.row) {
            case 0:
            {
                cell.contentLabel.text = @"交易记录";
                cell.iconImage.image = [UIImage imageNamed:@"icon_more_item_11"];
            }
                break;
            case 1:
            {
                cell.contentLabel.text = @"转让记录";
                cell.iconImage.image = [UIImage imageNamed:@"icon_more_item_12"];
            }
                break;
            default:
                break;
        }
        
        return cell;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if(indexPath.section == 1) {
        [self actionDDCenterButtonClicked:(indexPath.row + 1)];
    }
    
    if(indexPath.section == 2) {
        if(indexPath.row == 0)//交易记录
        {
            DDTradeLogPageView* pTradeLogView = [[DDTradeLogPageView alloc] init];
            pTradeLogView.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:pTradeLogView animated:YES];
            
        }
        else if(indexPath.row == 1)//转让记录
        {
            DDIntegralInfoPageView* pIntegralView = [[DDIntegralInfoPageView alloc] init];
            pIntegralView.hidesBottomBarWhenPushed = YES;
            
            NSString* strTotalPoints = [m_MyDdInfoData getFeildValue:0 andColumn:@"integePoints"];
            pIntegralView.m_iTotalIntegralValue = [QDataSetObj convertToInt:strTotalPoints];
            [self.navigationController pushViewController:pIntegralView animated:YES];
        }
    }
}



#pragma MyDdCenterMidTableCellDelegate（三个按钮点击的代理）

-(void)actionDDCenterButtonClicked:(NSInteger)iButtonIndex
{
    if(iButtonIndex == 1) //总资产
    {
        //不需要处理
    }
    else if(iButtonIndex == 2)//持有资产
    {
        MyHoldAssetsPageView* pHoldAssetView = [[MyHoldAssetsPageView alloc] init];
        pHoldAssetView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:pHoldAssetView animated:YES];
    }
    else if(iButtonIndex == 3)//账户余额
    {
        DDBillLeftMoneyPageView* pLeftMoneyView = [[DDBillLeftMoneyPageView alloc] init];
        pLeftMoneyView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:pLeftMoneyView animated:YES];
    }
}

//点击查看
/*
-(void)actionCellViewClicked:(id)sender
{
    UITableViewCell* pCellObj = [UIOwnSkin getSuperTableViewCell:sender];
    if(pCellObj == nil)
        return;
    NSIndexPath* indexPath = [_uiMainTable indexPathForCell:pCellObj];
    if(indexPath == nil)
        return;
    if(indexPath.row == 1)
    {
        MyHoldAssetsPageView* pHoldAssetView = [[MyHoldAssetsPageView alloc] init];
        pHoldAssetView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:pHoldAssetView animated:YES];
        
    }
    else if(indexPath.row == 2)
    {
        DDBillLeftMoneyPageView* pLeftMoneyView = [[DDBillLeftMoneyPageView alloc] init];
        pLeftMoneyView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:pLeftMoneyView animated:YES];
    }
}
*/

#pragma LoginDelegate
-(void)onSelectedNoLoadInSystem
{
    UIApplication *app = [UIApplication sharedApplication];
    EAppDelegate *curEypAppDelegate = (EAppDelegate *)app.delegate;
    [self.navigationController popViewControllerAnimated:YES];
    
    if (curEypAppDelegate.m_appTabBarController.JCTabBar.tabContainer != nil)
    {
        [curEypAppDelegate.m_appTabBarController.JCTabBar.tabContainer  itemSelectedByIndex:0];
    }
    m_iLoadViewFlag = 0;

}

@end
