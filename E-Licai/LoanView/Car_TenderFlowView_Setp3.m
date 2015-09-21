//
//  Car_TenderFlowView_Setp3.h
//
//  汽车贷款-产品详情-投标流程第三步-确认

//  Created by lzq on 2014-11-16.

//


#import "Car_TenderFlowView_Setp3.h"
#import "UaConfiguration.h"
#import "CKHttpHelper.h"
#import "CKKit.h"
#import "SQLLiteDBManager.h"
#import <QuartzCore/QuartzCore.h>
#import "UIOwnSkin.h"
#import "GlobalDefine.h"


@interface Car_TenderFlowView_Setp3 ()

@end

@implementation Car_TenderFlowView_Setp3

@synthesize m_strProductId = _strProductId;
@synthesize m_strProductName = _strProductName;
@synthesize m_uiOkStepButton = _uiOkStepButton;
@synthesize m_strTenderFeeValue = _strTenderFeeValue;

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
    self.navigationItem.titleView = [UIOwnSkin navibarTitleView:@"确认购买" andFrame:CGRectMake(0, 0, 100, 40)];
    //左边返回按钮
    self.navigationItem.leftBarButtonItem = [UIOwnSkin backItemTarget:self action:@selector(backNavButtonAction:)];

    [self initViewShow];
    [super viewDidLoad];
}



- (void)viewWillDisappear:(BOOL)animated
{


}


-(void)viewDidAppear:(BOOL)animated
{

}

- (void)backNavButtonAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)initViewShow
{
    //设置下一步的按钮
    [UIOwnSkin setButtonBackground:_uiOkStepButton];
    
    //产品的名称
    UILabel*pLabel = (UILabel*)[self.view viewWithTag:1001];
    if(pLabel)
    {
        pLabel.textColor = COLOR_FONT_1;
        pLabel.text = [NSString stringWithFormat:@"成功购买 %@",_strProductName];
    }
    //投标金额
    pLabel = (UILabel*)[self.view viewWithTag:1002];
    if(pLabel)
    {
        pLabel.textColor = COLOR_FONT_1;
        pLabel.text = [NSString stringWithFormat:@"%@元",_strTenderFeeValue];
    }
    //成功提示信息
    pLabel = (UILabel*)[self.view viewWithTag:1003];
    if(pLabel)
    {
        pLabel.textColor = COLOR_FONT_2;
    }
    
    
    //开始计算收益的提示
    pLabel = (UILabel*)[self.view viewWithTag:1004];
    if(pLabel)
    {
        pLabel.textColor = COLOR_FONT_1;
    }
    
    //具体的收益描述
    pLabel = (UILabel*)[self.view viewWithTag:1005];
    if(pLabel)
    {
        pLabel.textColor = COLOR_FONT_2;
    }
    
    //查看收益的提示
    pLabel = (UILabel*)[self.view viewWithTag:1006];
    if(pLabel)
    {
        pLabel.textColor = COLOR_FONT_1;
    }
    //查看收益的具体内容
    pLabel = (UILabel*)[self.view viewWithTag:1007];
    if(pLabel)
    {
        pLabel.textColor = COLOR_FONT_1;
    }
    
    //线条
    UIImageView*pLineView = (UIImageView*)[self.view viewWithTag:1008];
    if(pLineView)
    {
        pLineView.backgroundColor = COLOR_CELL_LINE_DEFAULT;
    }

    //资金安全提示
    pLabel = (UILabel*)[self.view viewWithTag:1010];
    if(pLabel)
    {
        pLabel.textColor = COLOR_FONT_2;
    }
    
    [_uiOkStepButton addTarget:self action:@selector(actionSuccRiskClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
}

//
-(IBAction)actionSuccRiskClicked:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
