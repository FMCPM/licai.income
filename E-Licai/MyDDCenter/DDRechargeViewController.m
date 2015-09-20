//
//  DDRechargeViewController.m
//  E-Licai
//
//  Created by chaiweiwei on 15/9/20.
//  Copyright (c) 2015年 ytinfo. All rights reserved.
//

#import "DDRechargeViewController.h"
#import "UIOwnSkin.h"
#import "GlobalDefine.h"
#import "CKHttpHelper.h"
#import "SVProgressHUD.h"
#import "WebViewController.h"
#import "JsonXmlParserObj.h"
#import "UaConfiguration.h"

@interface DDRechargeViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *rechargeFieldTextView;

@property (weak, nonatomic) IBOutlet UITextField *passwordFieldTextView;
@property (weak, nonatomic) IBOutlet UIButton *rechargeButton;

@end

@implementation DDRechargeViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self initUI];
}

- (void)initUI {
    self.title = @"充值";
    //左边返回按钮
    self.navigationItem.leftBarButtonItem = [UIOwnSkin backItemTarget:self action:@selector(backNavButtonAction:)];
    
    
    UIView* pSupView = [self.rechargeFieldTextView superview];
    if(pSupView)
    {
        pSupView.layer.borderColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.95 alpha:1].CGColor;
    }
    
    pSupView = [self.passwordFieldTextView superview];
    if(pSupView)
    {
        pSupView.layer.borderColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.95 alpha:1].CGColor;
    }
    
    self.rechargeButton.layer.masksToBounds = YES;
    self.rechargeButton.layer.cornerRadius = 5;
    self.rechargeFieldTextView.delegate = self;

}

- (void)textFieldDidBeginEditing:(UITextField *)textField {

    UIView* pSupView = [textField superview];
    if(pSupView)
    {
        pSupView.layer.borderColor = COLOR_FONT_7.CGColor;
    };

}

- (void)textFieldDidEndEditing:(UITextField *)textField {

    UIView* pSupView = [textField superview];
    if(pSupView)
    {
        pSupView.layer.borderColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.95 alpha:1].CGColor;
    }
    
    [textField resignFirstResponder];
}

- (IBAction)rechargeAction:(id)sender {
    NSString *num = self.rechargeFieldTextView.text;
    NSString *password  = self.passwordFieldTextView.text;
    
    if(num.intValue < 100)
    {
        [SVProgressHUD showErrorWithStatus:@"不少于100元" duration:1.8];
        return ;
    }
    if(password.length < 1)
    {
        [SVProgressHUD showErrorWithStatus:@"请输入交易密码！" duration:1.8];
        return;
    }

    WebViewController *webVc = [[WebViewController alloc] init];
    NSString *baseUrl = [[UaConfiguration sharedInstance] m_strSoapRequestUrl_1];

    NSInteger memberID = [UaConfiguration sharedInstance].m_setLoginState.m_iUserMemberID;
    webVc.m_strWebUrl = [NSString stringWithFormat:@"%@/userCenterInfo/charge.do?odReq.occur_balance=%@&memberId=%d",baseUrl,num,memberID];
    
    webVc.title = @"充值";
    webVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webVc animated:YES];
}

- (void)backNavButtonAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
