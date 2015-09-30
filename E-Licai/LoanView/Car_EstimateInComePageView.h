//
//  Car_EstimateInComePageView.h
//
//  汽车贷款-产品详情-预估收益

//  Created by lzq on 2014-11-16.

//

#import <UIKit/UIKit.h>
#import "QDataSetObj.h"


@interface Car_EstimateInComePageView : UIViewController

{

    UITapGestureRecognizer* m_pTapGesture;
    
    //总的融资金额
    float  m_fTotalTenderMoney;
}



@property (strong, nonatomic) IBOutlet UIButton*   m_uiEstimateButton;
@property (strong, nonatomic) IBOutlet UITextField*   m_uiInputMoneyField;
//@property (strong, nonatomic) NSString*     m_strProductName;
//@property (strong, nonatomic) NSString*     m_strTotalMoney;


@property (strong, nonatomic) QDataSetObj*  m_pPrevDataSet;

-(IBAction)onEstimateInComeClicked:(id)sender;
@end
