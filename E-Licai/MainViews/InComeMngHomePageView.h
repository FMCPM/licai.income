//
//  InComeMngHomePageView.h
//
//  叮叮理财 - 我的叮叮
//
//  Created by lzq on 2014-12-25.

//

#import <UIKit/UIKit.h>

#import "CKKit.h"
#import "QDataSetObj.h"
#import "MyDdCenterMidTableCell.h"
#import "LoginViewController.h"
	
@interface InComeMngHomePageView : UIViewController<UITableViewDataSource,UITableViewDelegate,MyDdCenterMidTableCellDelegate,LoginDelegate>
{
 
    QDataSetObj * m_MyDdInfoData;
    UIButton*   m_uiNavTitleButton;
    NSInteger   m_iLoadViewFlag;
    
}

@property (strong  ,nonatomic) IBOutlet UITableView *m_uiMainTable;
@property (strong  ,nonatomic) IBOutlet UIView *m_uiTopView;
//@property (assign  ,nonatomic) NSInteger    m_iLoadViewFlag;

@end
