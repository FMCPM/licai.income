//
//  Car_TenderFlowView_Setp1.h
//
//  汽车贷款-产品详情-投标流程第一步

//  Created by lzq on 2014-11-16.

//


#import "Car_TenderFlowView_Setp1.h"
#import "UaConfiguration.h"
#import "CKHttpHelper.h"
#import "CKKit.h"
#import "SQLLiteDBManager.h"
#import <QuartzCore/QuartzCore.h>
#import "UIOwnSkin.h"
#import "GlobalDefine.h"
#import "Car_TenderFlowView_Setp2.h"


@interface Car_TenderFlowView_Setp1 ()

@end

@implementation Car_TenderFlowView_Setp1

@synthesize m_strProductId = _strProductId;
@synthesize m_strProductName = _strProductName;
@synthesize m_uiNextStepButton = _uiNextStepButton;
@synthesize m_uiLoanMoneyField = _uiLoanMoneyField;
@synthesize m_strLimitTime = _strLimitTime;
@synthesize m_strStartTenderMoney = _strStartTenderMoney;
@synthesize m_strTotalTenderMoney = _strTotalTenderMoney;

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
    self.navigationItem.titleView = [UIOwnSkin navibarTitleView:@"投标" andFrame:CGRectMake(0, 0, 100, 40)];
    //左边返回按钮
    self.navigationItem.leftBarButtonItem = [UIOwnSkin backItemTarget:self action:@selector(backNavButtonAction:)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    //初始化设置
    [self initViewShow];
    [super viewDidLoad];
}

- (void)viewWillDisappear:(BOOL)animated
{
    
    
}


-(void)viewDidAppear:(BOOL)animated
{
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    //注销键盘事件
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
}


-(void)initViewShow
{
    //设置下一步的按钮
    _uiNextStepButton.enabled = NO;
    [UIOwnSkin setButtonBackground:_uiNextStepButton andColor:COLOR_BTN_BORDER_1];
    //产品的名称
    UILabel*pLabel = (UILabel*)[self.view viewWithTag:1001];
    if(pLabel)
    {
        pLabel.textColor = COLOR_FONT_1;
        pLabel.text = _strProductName;
    }
    //起投金额
    pLabel = (UILabel*)[self.view viewWithTag:1002];
    if(pLabel)
    {
        pLabel.textColor = COLOR_FONT_1;
        pLabel.text = [NSString stringWithFormat:@"起投金额：%@元",_strStartTenderMoney];
        
    }
    //手续费
    pLabel = (UILabel*)[self.view viewWithTag:1003];
    if(pLabel)
    {
        pLabel.textColor = COLOR_FONT_1;
    }
    //理财期限
    pLabel = (UILabel*)[self.view viewWithTag:1004];
    if(pLabel)
    {
        pLabel.textColor = COLOR_FONT_1;
        pLabel.text = [NSString stringWithFormat:@"理财期限：限%@个月",_strLimitTime];
    }
    //线条
    UIImageView*pLineView = (UIImageView*)[self.view viewWithTag:1006];
    if(pLineView)
    {
        pLineView.backgroundColor = COLOR_CELL_LINE_DEFAULT;
    }
    
    //投标金额的提示
    pLabel = (UILabel*)[self.view viewWithTag:1005];
    if(pLabel)
    {
        pLabel.textColor = COLOR_FONT_1;
    }
    
    UIView* pView = [self.view viewWithTag:1007];
    pView.backgroundColor = COLOR_VIEW_BK_02;
    pView.layer.borderColor = COLOR_BTN_BORDER_1.CGColor;
    pView.layer.borderWidth = 1.0f;
    pView.layer.cornerRadius = 1.0f;
   
    
    //投资金额的提示
    pLabel = (UILabel*)[self.view viewWithTag:1009];
    if(pLabel)
    {
        pLabel.textColor = COLOR_FONT_2;
        pLabel.text = [NSString stringWithFormat:@"投标金额：%@的倍数",_strStartTenderMoney];
    }
    //资金安全提示
    pLabel = (UILabel*)[self.view viewWithTag:1010];
    if(pLabel)
    {
        pLabel.textColor = COLOR_FONT_2;
    }
    
    _uiLoanMoneyField .font =[UIFont systemFontOfSize:14.0];
    _uiLoanMoneyField.tag = 1008;
    _uiLoanMoneyField.borderStyle = UITextBorderStyleNone;
    _uiLoanMoneyField.keyboardType = UIKeyboardTypeDecimalPad;
    _uiLoanMoneyField.clearButtonMode = UITextFieldViewModeWhileEditing;

    _uiLoanMoneyField.contentHorizontalAlignment  = UIControlContentHorizontalAlignmentCenter;
    _uiLoanMoneyField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _uiLoanMoneyField.textAlignment = UITextAlignmentCenter;
    _uiLoanMoneyField.placeholder = [NSString stringWithFormat:@"投标金额需 > %@",_strStartTenderMoney];
    _uiLoanMoneyField.returnKeyType = UIReturnKeyDone;
    [_uiLoanMoneyField addTarget:self action:@selector(actionTextFieldEditingDidEndExit:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [_uiLoanMoneyField addTarget:self action:@selector(actionTextFieldEditingDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
    [_uiLoanMoneyField addTarget:self action:@selector(actionTextFieldEditingDidEnd:) forControlEvents:UIControlEventEditingDidEnd];
    [_uiLoanMoneyField addTarget:self action:@selector(actionTextFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
}

- (void)backNavButtonAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}



//键盘显示的事件
-(void)keyboardWillShow:(NSNotification*)aNotification
{
    if(m_pTapGesture == nil)
    {
        m_pTapGesture  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenKeyBoard)];
        [self.view addGestureRecognizer:m_pTapGesture];
    }
    
}

-(void)hiddenKeyBoard
{
    [_uiLoanMoneyField resignFirstResponder];

    
}

-(void)actionTextFieldEditingDidEndExit:(id)sender
{
    UITextField* pTextField = (UITextField*)sender;
    if(pTextField == nil)
        return;
    
    [pTextField resignFirstResponder];
}


-(void)actionTextFieldEditingDidBegin:(id)sender
{
    //
    
}

-(void)actionTextFieldEditingDidEnd:(id)sender
{
    UITextField* pTextField = (UITextField*)sender;
    if(pTextField == nil)
        return;
    
    [pTextField resignFirstResponder];
    
    
}


-(void)actionTextFieldEditingChanged:(id)sender
{
    UITextField* pTextField = (UITextField*)sender;
    if(pTextField == nil)
        return;
    
    bool blNext  = NO;
    if(pTextField.text.length > 0)
    {
        float fInput = pTextField.text.floatValue;
        float fMin = _strStartTenderMoney.floatValue;
        if(fInput >= fMin)
            blNext = YES;
    }
    if(blNext == YES)
    {
        
        _uiNextStepButton.enabled = YES;
        [UIOwnSkin setButtonBackground:_uiNextStepButton];
    }
    else
    {
        _uiNextStepButton.enabled = NO;
        [UIOwnSkin setButtonBackground:_uiNextStepButton andColor:COLOR_BTN_BORDER_1];
    }
}



-(IBAction)onTenderNextStepClicked:(id)sender
{
    [_uiLoanMoneyField resignFirstResponder];
    
    NSString* strInputValue = _uiLoanMoneyField.text;
    if(strInputValue.length < 1)
    {
        [SVProgressHUD showErrorWithStatus:@"请输入投标金额！" duration:1.8];
        return;
    }

    int  iInputFee = [QDataSetObj convertToInt:strInputValue];
    int iMinFee = [QDataSetObj convertToInt:_strStartTenderMoney];
    if(iInputFee < iMinFee)
    {
     
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"投标金额不能低于%@",_strStartTenderMoney] duration:1.8];
        return;
    }
    
    int iMaxFee = [QDataSetObj convertToInt:_strTotalTenderMoney];
    if(iInputFee > iMaxFee)
    {
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"投标金额不能高于%d",iMaxFee] duration:1.8];
        return;
    }
    int iModFee = iInputFee % iMinFee;
    if(iModFee !=0 )
    {
      
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"投标必须金额%@的倍数！",_strStartTenderMoney] duration:1.8];
        return;
    }
    
    
    
    Car_TenderFlowView_Setp2* pStepView2 = [[Car_TenderFlowView_Setp2 alloc] init];
    pStepView2.m_strProductId = _strProductId;
    pStepView2.m_strProductName = _strProductName;
    pStepView2.m_strTenderMoney = strInputValue;
    pStepView2.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:pStepView2 animated:YES];
    
}



@end
