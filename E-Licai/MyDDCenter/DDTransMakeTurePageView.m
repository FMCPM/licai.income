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

@interface DDTransMakeTurePageView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *transMoney;
@property (weak, nonatomic) IBOutlet UILabel *shouyi;
@property (weak, nonatomic) IBOutlet UILabel *yijiesuanMoney;
@property (weak, nonatomic) IBOutlet UILabel *lastTime;
@property (weak, nonatomic) IBOutlet UILabel *transShouyiMoney;
@property (weak, nonatomic) IBOutlet UIButton *makeTureButton;

@end

@implementation DDTransMakeTurePageView

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"债券转让";
    //左边返回按钮
    self.navigationItem.leftBarButtonItem = [UIOwnSkin backItemTarget:self action:@selector(backNavButtonAction:)];
    
    [self initUI];

    [self loadTransInfo_Web];
}

- (void)initUI {
    self.makeTureButton.layer.masksToBounds = YES;
    self.makeTureButton.layer.cornerRadius = 5.0;

    self.titleLabel.text = self.transName;

    self.transMoney.attributedText = [self getAttributedStringWith:@"投资金额" extraStr:self.transMoneyNum];
    
    self.shouyi.text = [NSString stringWithFormat:@"收益率: %@",self.shouyiMoneyNum];
    
    self.yijiesuanMoney.attributedText = [self getAttributedStringWith:@"已结算收益" extraStr:self.yijiesuanMoneyNum];
    
    self.lastTime.text = [NSString stringWithFormat:@"剩余期限: %@",self.lastTimeNum];
    
    self.transShouyiMoney.attributedText = [self getAttributedStringWith:@"转让收益" extraStr:self.transShouyiMoneyNum];
}

- (NSMutableAttributedString *)getAttributedStringWith:(NSString *)originStr extraStr:(NSString *)extraStr {
    NSString *string = [NSString stringWithFormat:@"%@: %@",originStr,extraStr];
    
    NSMutableAttributedString *attrubutedString = [[NSMutableAttributedString alloc] initWithString:string];
    
    [attrubutedString addAttribute:NSForegroundColorAttributeName value:COLOR_FONT_7 range:NSMakeRange(string.length-extraStr.length, extraStr.length)];

    return attrubutedString;
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
//获取转让产品明细
-(void)loadTransInfo_Web
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

-(void)backNavButtonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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

@end
