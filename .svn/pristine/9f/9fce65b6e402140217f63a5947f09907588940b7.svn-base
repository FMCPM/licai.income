//
//  Car_TenderFlowView_Setp2.h
//
//  汽车贷款-产品详情-投标流程第二步

//  Created by lzq on 2014-11-16.

//

#import <UIKit/UIKit.h>
#import "QDataSetObj.h"
#import "MoneyTickedPopupView.h"
//#import "LLWalletSdk.h"
#import "LLPaySdk.h"
#import "UserIdSignInfoPopupView.h"

@interface Car_TenderFlowView_Setp2 : UIViewController<UITableViewDataSource,UITableViewDelegate,MoneyTickedPopupViewDelegate,LLPaySdkDelegate,UserIdSignInfoPopupViewDelegate>
{

    BOOL        m_isUsedLeftMoney;
    BOOL        m_isUsedBankCard;
    BOOL        m_isReadProtocol;
    BOOL        m_isUsedCashBill;
    
    //NSInteger   m_iFeePayType;
    
    //实际投标金额
    float       m_fReallyTenderFee;
    //账号余额
    float       m_fBillLeftFee;
    
    //协议号
    NSString*   m_strProtocolName;
    //选择代金券
    MoneyTickedPopupView*m_pMiddlePopView;
    //代金券信息
    QDataSetObj* m_pCashBillDataSet;
    //选择的代金券的id
    NSInteger   m_iSelectedCashBillId;
    //选择的代金券的金额
    float       m_fSelectedCashBillFee;
    
    //LLPaySdk*m_pllWallsdk;
    
    bool        m_isRegKeyboardEvent;
    UITextField* m_uiCurEditingField;
    UITapGestureRecognizer*m_pTapGesture;
    float       m_offsetToMove;
    //交易密码
    NSString*   m_strInputTradePwd;
    
    NSMutableDictionary* m_llDictPay;
    
   // UserIdSignInfoPopupView* m_pIdSignView;
    
    bool        m_blPrePayResult;
}


@property (strong, nonatomic) IBOutlet UITableView *m_uiMainTableView;

@property (strong, nonatomic) IBOutlet UIButton*   m_uiConfirmStepButton;

@property (nonatomic, retain) LLPaySdk *sdk;



@property (strong, nonatomic) NSString*     m_strProductName;
@property (strong, nonatomic) NSString*     m_strProductId;
@property (strong, nonatomic) NSString*     m_strTenderMoney;

@end
