//
//  BillPaymentViewController.h
//
//
//  Created by lzq on 2014-12-31.
//
//  Copyright (c) 2014年  All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "QDataSetObj.h"
#import "FeePayComMethod.h"
#import "LLPaySdk.h"

@interface BillPaymentViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,FeePayComMethodViewDelegate,LLPaySdkDelegate>
{
    /*
    UILabel                 *m_pLabelOrderNO;
    UILabel                 *m_pLabelPaySum;
    UILabel                 *m_pLabelBalance;
    UILabel                 *m_pLabelOrderSN;
    */
    NSInteger    m_iFeePayType ;
    SEL         _result;
    LLPaySdk*    m_pllWallsdk;
     ;
 
}

//@property (nonatomic, strong) QDataSetObj *m_pPayInfoData;
@property (strong, nonatomic) UITableView *m_uiPayTableView;
@property (nonatomic, assign) NSString * m_strOrderId;

@property (nonatomic, strong) QDataSetObj *  m_pOrderPayInfoData;
@property (nonatomic, assign) NSInteger m_iOrderType;


//@property (nonatomic,assign) SEL result;//这里声明为属性方便在于外部传入。
//-(void)paymentResult:(NSString *)result;
@end
