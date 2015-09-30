//
//  Car_TenderFlowView_Setp1.h
//
//  汽车贷款-产品详情-投标流程第一步

//  Created by lzq on 2014-11-16.

//

#import <UIKit/UIKit.h>
#import "QDataSetObj.h"


@interface Car_TenderFlowView_Setp1 : UIViewController 

{

    UITapGestureRecognizer* m_pTapGesture;
}



@property (strong, nonatomic) IBOutlet UIButton*   m_uiNextStepButton;
@property (strong, nonatomic) IBOutlet UITextField*   m_uiLoanMoneyField;

@property (strong, nonatomic) NSString*     m_strProductName;
@property (strong, nonatomic) NSString*     m_strProductId;
//投资期限
@property (strong, nonatomic) NSString*     m_strLimitTime;
//起投金额
@property (strong, nonatomic) NSString* m_strStartTenderMoney;
@property (strong, nonatomic) NSString* m_strTotalTenderMoney;

-(IBAction)onTenderNextStepClicked:(id)sender;

@end
