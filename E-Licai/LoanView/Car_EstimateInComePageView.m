//
//  Car_EstimateInComePageView.h
//
//  汽车贷款-产品详情-预估收益

//  Created by lzq on 2014-11-16.

//


#import "Car_EstimateInComePageView.h"
#import "UaConfiguration.h"
#import "CKHttpHelper.h"
#import <QuartzCore/QuartzCore.h>
#import "UIOwnSkin.h"
#import "GlobalDefine.h"
#import "JsonXmlParserObj.h"
#import "AppInitDataMethod.h"

@interface Car_EstimateInComePageView ()

@end

@implementation Car_EstimateInComePageView


@synthesize m_uiEstimateButton = _uiEstimateButton;
@synthesize m_uiInputMoneyField = _uiInputMoneyField;
@synthesize m_pPrevDataSet = _pPrevDataSet;

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
    self.navigationItem.titleView = [UIOwnSkin navibarTitleView:@"预估收益" andFrame:CGRectMake(0, 0, 100, 40)];
    //左边返回按钮
    self.navigationItem.leftBarButtonItem = [UIOwnSkin backItemTarget:self action:@selector(backNavButtonAction:)];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initViewShow];
    [self setViewInfoShow];
    [super viewDidLoad];
}

- (void)backNavButtonAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];    
}


-(void)viewWillAppear:(BOOL)animated
{
    
}

- (void)viewWillDisappear:(BOOL)animated
{


}


-(void)viewDidAppear:(BOOL)animated
{

}

//预估收益
-(IBAction)onEstimateInComeClicked:(id)sender
{
    [self hiddenKeyBoard];
    [self getEstmateInComeInfo_Web];
}


-(void)initViewShow
{
    m_pTapGesture = nil;
    //设置下一步的按钮
    [UIOwnSkin setButtonBackground:_uiEstimateButton];
    
    //产品的名称
    UILabel*pLabel = (UILabel*)[self.view viewWithTag:1001];
    if(pLabel)
    {
        pLabel.textColor = COLOR_FONT_1;
    }
    //融资金额提示
    pLabel = (UILabel*)[self.view viewWithTag:1002];
    if(pLabel)
    {
        pLabel.textColor = COLOR_FONT_1;
    }
    //融资金额的值
    pLabel = (UILabel*)[self.view viewWithTag:1003];
    if(pLabel)
    {
        pLabel.textColor = COLOR_FONT_1;
    }
    
    //预估收益的提示
    pLabel = (UILabel*)[self.view viewWithTag:1005];
    if(pLabel)
    {
        pLabel.textColor = COLOR_FONT_1;
    }
    
    //投标金额
    UIView* pView = [self.view viewWithTag:1006];
    if(pView)
    {
        pView.backgroundColor = COLOR_VIEW_BK_05;
        pView.layer.borderColor = COLOR_BTN_BORDER_1.CGColor;
        pView.layer.borderWidth = 1.0f;
        pView.layer.cornerRadius = 1.0f;
    }
    //投标金额的提示
    pLabel = (UILabel*)[self.view viewWithTag:1007];
    if(pLabel)
    {
        pLabel.textColor = COLOR_FONT_2;
        pLabel.textAlignment = UITextAlignmentLeft;
    }
    _uiInputMoneyField.textColor =  COLOR_FONT_1;
    _uiInputMoneyField.placeholder = @"输入投标金额";
    _uiInputMoneyField.keyboardType = UIKeyboardTypeDecimalPad;
    _uiInputMoneyField.returnKeyType = UIReturnKeyDone;
    [_uiInputMoneyField addTarget:self action:@selector(actionTextFieldEditingDidEnd:) forControlEvents:UIControlEventEditingDidEnd];
    [_uiInputMoneyField addTarget:self action:@selector(actionTextFieldEditingDidEndExit:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [_uiInputMoneyField addTarget:self action:@selector(actionTextFieldEditingDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
    //元
    pLabel = (UILabel*)[self.view viewWithTag:1008];
    if(pLabel)
    {
        pLabel.textColor = COLOR_FONT_1;
    }
    //理财期限
    pLabel = (UILabel*)[self.view viewWithTag:1009];
    if(pLabel)
    {
        pLabel.textColor = COLOR_FONT_2;
    }
    
    //预估收益的提示
    pLabel = (UILabel*)[self.view viewWithTag:1010];
    if(pLabel)
    {
        pLabel.textColor = COLOR_FONT_1;
    }
    //具体预估收益的值
    pLabel = (UILabel*)[self.view viewWithTag:1011];
    if(pLabel)
    {
        pLabel.textColor = COLOR_FONT_2;
    }
    //计算提示
    pLabel = (UILabel*)[self.view viewWithTag:1014];
    if(pLabel)
    {
        pLabel.textColor = COLOR_FONT_2;
    }
    
    //线条
    UIImageView*pLineView = (UIImageView*)[self.view viewWithTag:1004];
    if(pLineView)
    {
        pLineView.backgroundColor = COLOR_CELL_LINE_DEFAULT;
    }
    pLineView = (UIImageView*)[self.view viewWithTag:1012];
    if(pLineView)
    {
        pLineView.backgroundColor = COLOR_CELL_LINE_DEFAULT;
    }
    //self.view.hidden = YES;
}

//估算投标金额
-(void)getEstmateInComeInfo_Web
{
    NSString* strBidFee = _uiInputMoneyField.text;
    if(strBidFee.length < 1)
    {
        
        [SVProgressHUD showErrorWithStatus:@"请输入投标金额！" duration:1.8];
        return;
        
    }
    
    float fBidFee = [QDataSetObj convertToFloat:strBidFee];
    if(fBidFee == 0)
    {
        [SVProgressHUD showErrorWithStatus:@"投标金额必须是大于0的数字！" duration:1.8];
        return;
    }
    
    if(fBidFee > m_fTotalTenderMoney)
    {
        NSString* strHint = [NSString stringWithFormat:@"投标金额不能大于%.2f元",m_fTotalTenderMoney];
        [SVProgressHUD showErrorWithStatus:strHint duration:1.8];
        return;
    }
    
    CKHttpHelper *pHttpHelper = [CKHttpHelper httpHelperWithOwner:self];
    pHttpHelper.m_iWebServerType = 1;
    pHttpHelper.methodType = CKHttpMethodTypePost_Page;
    //设置webservice方法名
    [pHttpHelper setMethodName:@"productInfo/calIncome"];
    //productId
    [pHttpHelper addParam:[_pPrevDataSet getFeildValue:0 andColumn:@"productId"] forName:@"productId"];
    //
    [pHttpHelper addParam:strBidFee forName:@"bidFee"];
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
         
         
         NSString* strSrvFee = [pJsonObj getDictJsonValueByKey:@"syFee"];

         UILabel* pLabel = (UILabel*)[self.view viewWithTag:1011];
         if(pLabel)
         {
             pLabel.text = [NSString stringWithFormat:@"%@元",[AppInitDataMethod convertMoneyShow:strSrvFee]];
         }
    }];
    [pHttpHelper setStartBlock:^{
        [SVProgressHUD showWithStatus:HINT_WEBDATA_SUBMITING ];
    }];
    //开始连接
    [pHttpHelper start];
}

-(void)setViewInfoShow
{
    if(_pPrevDataSet == nil || [_pPrevDataSet getRowCount] < 1)
        return;
    //产品的名称
    UILabel*pLabel = (UILabel*)[self.view viewWithTag:1001];
    if(pLabel)
    {
        pLabel.text = [_pPrevDataSet getFeildValue:0 andColumn:@"productName"];
    }

    
    //融资金额的值
    pLabel = (UILabel*)[self.view viewWithTag:1003];
    if(pLabel)
    {
        NSString* strTotalMoney = [_pPrevDataSet getFeildValue:0 andColumn:@"totalMoney"];
        m_fTotalTenderMoney = [QDataSetObj convertToFloat:strTotalMoney];
        pLabel.text = [NSString stringWithFormat:@"%@元",[AppInitDataMethod convertMoneyShow:strTotalMoney]];
        pLabel.textAlignment = UITextAlignmentRight;
    }
    
    //投标金额的值
    /*
    pLabel = (UILabel*)[self.view viewWithTag:1007];
    if(pLabel)
    {

        pLabel.textAlignment = UITextAlignmentCenter;
       // pLabel.text = [NSString stringWithFormat:@"投标金额：%@",[m_pInfoDataSet getFeildValue:0 andColumn:@"tenderMoney"]];
    }
     */

    //理财期限
    pLabel = (UILabel*)[self.view viewWithTag:1009];
    if(pLabel)
    {
        pLabel.text = [NSString stringWithFormat:@"理财期限：%@个月",[_pPrevDataSet getFeildValue:0 andColumn:@"limitTime"]];
    }
    
    //具体预估收益的值
    /*
    pLabel = (UILabel*)[self.view viewWithTag:1011];
    if(pLabel)
    {
        pLabel.text = [NSString stringWithFormat:@"%@元",[m_pInfoDataSet getFeildValue:0 andColumn:@"estInCome"]];
    }
     */
}



//点击完成等结束编辑
-(void)actionTextFieldEditingDidEndExit:(id)sender
{
    UITextField* pTextField = (UITextField*)sender;
    if(pTextField == nil)
        return;
    [pTextField resignFirstResponder];

}

//开始编辑
-(void)actionTextFieldEditingDidBegin:(id)sender
{
    if(m_pTapGesture == nil)
    {
        m_pTapGesture  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenKeyBoard)];
        [self.view addGestureRecognizer:m_pTapGesture];
    }
}

-(void)hiddenKeyBoard
{
    [_uiInputMoneyField resignFirstResponder];
}

//完成编辑
-(void)actionTextFieldEditingDidEnd:(id)sender
{
    UITextField* pTextField = (UITextField*)sender;
    if(pTextField == nil)
        return;
    
    [pTextField resignFirstResponder];
    
    if(m_pTapGesture != nil)
    {
        [self.view removeGestureRecognizer:m_pTapGesture];
        m_pTapGesture  = nil;
    }
 }


@end
