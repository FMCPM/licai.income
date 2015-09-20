//
//  DDTransMakeTurePageView.m
//  E-Licai
//
//  Created by chaiweiwei on 15/9/16.
//  Copyright (c) 2015年 ytinfo. All rights reserved.
//

#import "DDTransMakeTurePageView.h"
#import "UIOwnSkin.h"
#import "GlobalDefine.h"
#import "CKHttpHelper.h"
#import "UaConfiguration.h"
#import "JsonXmlParserObj.h"
#import "QDataSetObj.h"
#import "Car_LoanDetailInfoPageView.h"
#import "DDUserSignInfoPageView.h"
#import "Car_TenderFlowView_Setp1.h"
#import "DDAddBankCardPageInfo.h"
#import "AppInitDataMethod.h"

@interface DDTransMakeTurePageView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *transMoney;
@property (weak, nonatomic) IBOutlet UILabel *shouyi;
@property (weak, nonatomic) IBOutlet UILabel *yijiesuanMoney;
@property (weak, nonatomic) IBOutlet UILabel *lastTime;
@property (weak, nonatomic) IBOutlet UILabel *transShouyiMoney;
@property (weak, nonatomic) IBOutlet UIButton *makeTureButton;
@property (weak, nonatomic) IBOutlet UIButton *checkOriginInfo;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topMasHeight;

@end

@implementation DDTransMakeTurePageView

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"债券转让";
    //左边返回按钮
    self.navigationItem.leftBarButtonItem = [UIOwnSkin backItemTarget:self action:@selector(backNavButtonAction:)];
    
    [self initUI];

    if(self.hidenCheckButton) {
        //从持有中进入的
        [self loadTransInfo_WebWithRelId];
    } else {
        //从首页中进入的
        [self loadTransInfo_WebWithTransId];
    }
    
}

- (void)initUI {
    self.makeTureButton.layer.masksToBounds = YES;
    self.makeTureButton.layer.cornerRadius = 5.0;

    self.titleLabel.text = self.transName;

    self.transMoney.attributedText = [self getAttributedStringWith:@"投资金额" extraStr:self.transMoneyNum extraChar:@"元"];
    
    self.shouyi.text = [NSString stringWithFormat:@"收益率: %@%%",self.shouyiMoneyNum];
    
    self.yijiesuanMoney.attributedText = [self getAttributedStringWith:@"已结算收益" extraStr:self.yijiesuanMoneyNum extraChar:@"元"];
    
    self.lastTime.text = [NSString stringWithFormat:@"剩余期限: %@个月",self.lastTimeNum];
    
    self.transShouyiMoney.attributedText = [self getAttributedStringWith:@"转让收益" extraStr:self.transShouyiMoneyNum extraChar:@"元"];
    
    self.checkOriginInfo.layer.masksToBounds = YES;
    self.checkOriginInfo.layer.cornerRadius = 5.0;
    self.checkOriginInfo.layer.borderWidth = 1;
    self.checkOriginInfo.layer.borderColor = [UIColor colorWithRed:0.77 green:0.77 blue:0.78 alpha:1].CGColor;
    if(self.hidenCheckButton) {
        self.checkOriginInfo.hidden = YES;
        self.topMasHeight.constant = 30;
        [self.makeTureButton setTitle:@"确定转让" forState:UIControlStateNormal];
        
        [self.makeTureButton addTarget:self action:@selector(actionMakeTureClick:) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [self.makeTureButton addTarget:self action:@selector(actionMakeTureInvestmentClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (NSMutableAttributedString *)getAttributedStringWith:(NSString *)originStr extraStr:(NSString *)extraStr extraChar:(NSString *)extraChar{
    NSString *string = [NSString stringWithFormat:@"%@: %@%@",originStr,extraStr,extraChar];
    
    NSMutableAttributedString *attrubutedString = [[NSMutableAttributedString alloc] initWithString:string];
    
    [attrubutedString addAttribute:NSForegroundColorAttributeName value:COLOR_FONT_7 range:NSMakeRange(string.length-extraStr.length-extraChar.length, extraStr.length + extraChar.length)];

    return attrubutedString;
}

//获取转让产品明细
-(void)loadTransInfo_WebWithRelId
{
    CKHttpHelper*  pHttpHelper = [CKHttpHelper httpHelperWithOwner:self];
    pHttpHelper.m_iWebServerType = 1;
    pHttpHelper.methodType = CKHttpMethodTypePost_Page;
    //设置webservice方法名
    [pHttpHelper setMethodName:@"productInfo/queryOnemProRel"];
    [pHttpHelper addParam:[NSString stringWithFormat:@"%d",[UaConfiguration sharedInstance].m_setLoginState.m_iUserMemberID] forName:@"memberId"];
    [pHttpHelper addParam:self.relId forName:@"relId"];
    
    [pHttpHelper setCompleteBlock:^(id dataSet)
     {
         
         [SVProgressHUD dismiss];
         JsonXmlParserObj* pJsonObj = dataSet;

         self.lastTimeNum = [pJsonObj getJsonValueByKey:@"leftTime"];
         self.yijiesuanMoneyNum = [pJsonObj getJsonValueByKey:@"hassy"];
         self.transMoneyNum = [pJsonObj getJsonValueByKey:@"bidAmount"];
         self.shouyiMoneyNum = [pJsonObj getJsonValueByKey:@"expectual"];
         self.transShouyiMoneyNum = [pJsonObj getJsonValueByKey:@"notsy"];

         [self initUI];
     }];
    
    [pHttpHelper setStartBlock:^{
        [SVProgressHUD showWithStatus:HINT_WEBDATA_LOADING];
    }];
    
    [pHttpHelper start];
    
}

//首页获取转让产品明细
-(void)loadTransInfo_WebWithTransId
{
    CKHttpHelper*  pHttpHelper = [CKHttpHelper httpHelperWithOwner:self];
    pHttpHelper.m_iWebServerType = 1;
    pHttpHelper.methodType = CKHttpMethodTypePost_Page;
    //设置webservice方法名
    [pHttpHelper setMethodName:@"debtorInfo/queryOneTrans"];
    [pHttpHelper addParam:self.transId forName:@"dataId"];
    
    [pHttpHelper setCompleteBlock:^(id dataSet)
     {
         
         [SVProgressHUD dismiss];
         JsonXmlParserObj* pJsonObj = dataSet;
         
         self.lastTimeNum = [pJsonObj getJsonValueByKey:@"leftTime"];
         self.yijiesuanMoneyNum = [pJsonObj getJsonValueByKey:@"hasSettleIncome"];
         self.transMoneyNum = [pJsonObj getJsonValueByKey:@"bidAmount"];
         self.shouyiMoneyNum = [pJsonObj getJsonValueByKey:@"TProduct.expectAnnual"];
         self.transShouyiMoneyNum = [pJsonObj getJsonValueByKey:@"notSettleIncome"];
         
         [self initUI];
     }];
    
    [pHttpHelper setStartBlock:^{
        [SVProgressHUD showWithStatus:HINT_WEBDATA_LOADING];
    }];
    
    [pHttpHelper start];
    
}

- (IBAction)checkOriginInfoAction:(id)sender {

    NSString* strProductId = self.productId;

    Car_LoanDetailInfoPageView *pLoanDetailView = [[Car_LoanDetailInfoPageView alloc] init];
    pLoanDetailView.m_strProductId = strProductId;
    pLoanDetailView.m_strProductName = self.transName;
    pLoanDetailView.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:pLoanDetailView animated:YES];
    
}

-(void)backNavButtonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
//确定投资
- (IBAction)actionMakeTureInvestmentClick:(id)sender {

    if([[UaConfiguration sharedInstance] userIsHaveLoadinSystem] == NO)
    {
        //弹出登录页面
        LoginViewController* pLoginView = [[LoginViewController alloc] init];
        pLoginView.m_iLoadOrigin = 3;
        pLoginView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:pLoginView animated:YES];
        return;
    }

    //如果没有实名认证，则进入身份信息确认的流程
    if([UaConfiguration sharedInstance].m_setLoginState.m_strUserReallyName.length < 1)
    {
        //第一步改成先进行身份验证
        DDUserSignInfoPageView* pUserSignView = [[DDUserSignInfoPageView alloc] init];
        pUserSignView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:pUserSignView animated:YES];
        return;
    }
    
    //如果没有银行卡，则需要添加银行卡流程
    if([UaConfiguration sharedInstance].m_setLoginState.m_strBankCardSno.length < 1)
    {
        
        [self reloadUserBankInfo_Web];
        return;
    }
    
    Car_TenderFlowView_Setp1* pStepView1 = [[Car_TenderFlowView_Setp1 alloc] init];
    pStepView1.hidesBottomBarWhenPushed = YES;
    pStepView1.m_strProductName = self.transName;
    pStepView1.m_strProductId = self.productId;
    
    pStepView1.m_strLimitTime = self.lastTimeNum;
    pStepView1.m_strStartTenderMoney = @"1000";
    pStepView1.m_strTotalTenderMoney = self.transMoneyNum;
    
    [self.navigationController pushViewController:pStepView1 animated:YES];

}
//查询银行卡信息
-(void)reloadUserBankInfo_Web
{
    
    
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
         if([self dealReceivedUserBankInfo:pJsonObj] == NO)
         {
             
             DDAddBankCardPageInfo* pAddBankView = [[DDAddBankCardPageInfo alloc] init];
             pAddBankView.hidesBottomBarWhenPushed = YES;
             [self.navigationController pushViewController:pAddBankView animated:YES];
         }
         else
         {
             Car_TenderFlowView_Setp1* pStepView1 = [[Car_TenderFlowView_Setp1 alloc] init];
             pStepView1.hidesBottomBarWhenPushed = YES;
             pStepView1.m_strProductName = self.transName;
             pStepView1.m_strProductId = self.productId;
             
//             pStepView1.m_strLimitTime = [m_pInfoDataSet getFeildValue:0 andColumn:@"limitTime"];
//             NSString* strMinMoney = [m_pInfoDataSet getFeildValue:0 andColumn:@"leastAmount"];
//             if(strMinMoney.length < 1)
//                 strMinMoney = _strMinTenderMoney;
//             pStepView1.m_strStartTenderMoney = strMinMoney;
//             pStepView1.m_strTotalTenderMoney = [m_pInfoDataSet getFeildValue:0 andColumn:@"financingAmount"];
             
             [self.navigationController pushViewController:pStepView1 animated:YES];
         }
         
         
     }];
    
    [pHttpHelper setStartBlock:^{
        [SVProgressHUD showWithStatus:HINT_WEBDATA_LOADING];
    }];
    
    [pHttpHelper start];
    
    
}

//银行卡等信息
-(bool)dealReceivedUserBankInfo:(JsonXmlParserObj*)pJsonObj
{
    if(pJsonObj == nil)
    {
        [SVProgressHUD showErrorWithStatus:HINT_WEBDATA_NET_ERROR duration:1.8];
        return NO;
    }
    
    QDataSetObj* pDataSet = [pJsonObj parsetoDataSet:@"data"];
    NSString* strBankLogoUrl = @"";
    if(pDataSet == nil)
        return NO;
    
    [UaConfiguration sharedInstance].m_setLoginState.m_strBankCardId = [pDataSet getFeildValue:0 andColumn:@"bankId"];
    [UaConfiguration sharedInstance].m_setLoginState.m_strBankCardSno = [pDataSet getFeildValue:0 andColumn:@"cardSno"];
    [UaConfiguration sharedInstance].m_setLoginState.m_strBankName = [pDataSet getFeildValue:0 andColumn:@"bankName"];
    strBankLogoUrl = [pDataSet getFeildValue:0 andColumn:@"logo"];
    
    if(strBankLogoUrl.length < 1)
    {
        return YES;
    }
    CKHttpImageHelper* pImageHelper = [CKHttpImageHelper httpHelperWithOwner:self];
    
    strBankLogoUrl = [AppInitDataMethod getImageFullUrlPath:strBankLogoUrl andImgFlag:1];
    NSURL *nsImageReqUrl = [NSURL URLWithString:strBankLogoUrl];
    
    [pImageHelper addImageUrl:nsImageReqUrl forKey:[NSString stringWithFormat:@"%d",1]];
    
    [pImageHelper startWithReceiveBlock:^(UIImage *image,NSString *strKey,BOOL finsh)
     {
         
         if(image == nil || strKey == nil)
             return ;
         
         [UaConfiguration sharedInstance].m_setLoginState.m_pBankLogoImage = image;
         
         
     }];
    return YES;
}

//确认转让
- (IBAction)actionMakeTureClick:(id)sender {
    CKHttpHelper* pHttpHelper = [CKHttpHelper httpHelperWithOwner:self];
    pHttpHelper.m_iWebServerType = 1;
    pHttpHelper.methodType  = CKHttpMethodTypePost_Page;
    
    [pHttpHelper clearParams];
    //专业市场的id
    [pHttpHelper setMethodName:[NSString stringWithFormat:@"debtorInfo/transDebot"]];
    [pHttpHelper addParam:[NSString stringWithFormat:@"%d",[UaConfiguration sharedInstance].m_setLoginState.m_iUserMemberID] forName:@"memberId"];
    [pHttpHelper addParam:self.relId forName:@"dataId"];
    
    [pHttpHelper setCompleteBlock:^(id dataSet) {
        
        [SVProgressHUD dismiss];
        JsonXmlParserObj* pJsonObj = dataSet;
        
        NSString *flag = [pJsonObj getJsonValueByKey:@"operFlag"];
        NSString *message = [pJsonObj getJsonValueByKey:@"message"];

        if(flag.intValue>0) {
            [SVProgressHUD showSuccessWithStatus:@"转让成功" duration:0.8];
            
//            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [SVProgressHUD showSuccessWithStatus:message duration:0.8];
//            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    
    [pHttpHelper setStartBlock:^{
        [SVProgressHUD showWithStatus:HINT_WEBDATA_LOADING];
    }];
    
    [pHttpHelper start];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)transName {
    if(!_transName) {
        _transName = @"";
    }
    return _transName;
}
- (NSString *)transMoneyNum {
    if(!_transMoneyNum) {
        _transMoneyNum = @"";
    }
    return _transMoneyNum;
}
- (NSString *)shouyiMoneyNum {
    if(!_shouyiMoneyNum) {
        _shouyiMoneyNum = @"";
    }
    return _shouyiMoneyNum;
}
- (NSString *)yijiesuanMoneyNum {
    if(!_yijiesuanMoneyNum) {
        _yijiesuanMoneyNum = @"";
    }
    return _yijiesuanMoneyNum;
}
- (NSString *)lastTimeNum {
    if(!_lastTimeNum) {
        _lastTimeNum = @"";
    }
    return _lastTimeNum;
}
- (NSString *)transShouyiMoneyNum {
    if(!_transShouyiMoneyNum) {
        _transShouyiMoneyNum = @"";
    }
    return _transShouyiMoneyNum;
}


@end
